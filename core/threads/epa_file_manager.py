"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import os
import re
import subprocess

from qgis.PyQt.QtCore import pyqtSignal

from ..utils import tools_gw
from ... import global_vars
from ...lib import tools_log, tools_qt, tools_db, tools_qgis
from .task import GwTask


class GwEpaFileManager(GwTask):
    """ This shows how to subclass QgsTask """

    fake_progress = pyqtSignal()

    def __init__(self, description, go2epa):

        super().__init__(description)
        self.go2epa = go2epa
        self.json_result = None
        self.rpt_result = None
        self.fid = 140
        self.funtion_name = None
        self.initialize_variables()
        self.set_variables_from_go2epa()


    def initialize_variables(self):

        self.exception = None
        self.error_msg = None
        self.message = None
        self.common_msg = ""
        self.function_failed = False
        self.complet_result = None


    def set_variables_from_go2epa(self):
        """ Set variables from object Go2Epa """

        self.dlg_go2epa = self.go2epa.dlg_go2epa
        self.result_name = self.go2epa.result_name
        self.file_inp = self.go2epa.file_inp
        self.file_rpt = self.go2epa.file_rpt
        self.go2epa_export_inp = self.go2epa.export_inp
        self.go2epa_execute_epa = self.go2epa.exec_epa
        self.go2epa_import_result = self.go2epa.import_result
        self.net_geom = self.go2epa.net_geom
        self.export_subcatch = self.go2epa.export_subcatch


    def run(self):

        super().run()

        self.initialize_variables()
        status = True
        if self.go2epa_export_inp or self.go2epa_execute_epa:
            status = self._exec_function_pg2epa()
            if not status:
                self.funtion_name = 'gw_fct_pg2epa_main'
                return False

        if self.go2epa_export_inp:
            status = self._export_inp()

        if status and self.go2epa_execute_epa:
            status = self._execute_epa()

        if status and self.go2epa_import_result:
            self.funtion_name = 'gw_fct_rpt2pg_main'
            status = self._import_rpt()

        return status


    def finished(self, result):

        super().finished(result)

        self.dlg_go2epa.btn_cancel.setEnabled(False)
        if self.isCanceled():
            return

        self._close_file()

        # If PostgreSQL function returned null
        if (self.go2epa_export_inp or self.go2epa_export_inp) and self.complet_result is None:
            msg = f"Database returned null. Check postgres function '{self.funtion_name}'"
            tools_log.log_warning(msg)

        elif result:

            if self.go2epa_export_inp and self.complet_result:
                if 'status' in self.complet_result:
                    if self.complet_result['status'] == "Accepted":
                        if 'body' in self.complet_result:
                            if 'data' in self.complet_result['body']:
                                tools_gw.add_layer_temp(self.dlg_go2epa, self.complet_result['body']['data'],
                                                        'INP results', True, True, 1, False, close=False,
                                                        call_set_tabs_enabled=False)

            if self.go2epa_import_result and self.rpt_result:
                if 'status' in self.rpt_result:
                    if self.rpt_result['status'] == "Accepted":
                        if 'body' in self.rpt_result:
                            if 'data' in self.rpt_result['body']:
                                tools_gw.add_layer_temp(self.dlg_go2epa, self.rpt_result['body']['data'],
                                                        'RPT results', True, True, 1, False, close=False,
                                                        call_set_tabs_enabled=False)
                        self.message = self.rpt_result['message']['text']

            if self.common_msg != "":
                tools_qgis.show_info(self.common_msg)
            if self.message is not None:
                tools_qt.show_info_box(self.message)
            self.go2epa.check_result_id()
            return

        if self.function_failed:
            if self.json_result is None or not self.json_result:
                tools_log.log_warning("Function failed finished")
            if self.complet_result:
                if 'status' in self.complet_result:
                    if "Failed" in self.complet_result['status']:
                        tools_gw.manage_json_exception(self.complet_result)
            if self.rpt_result:
                if 'status' in self.rpt_result:
                    if "Failed" in self.rpt_result['status']:
                        tools_gw.manage_json_exception(self.rpt_result)

        if self.error_msg:
            title = f"Task aborted - {self.description()}"
            tools_qt.show_info_box(self.error_msg, title=title)
            return

        if self.exception:
            title = f"Task aborted - {self.description()}"
            tools_qt.show_info_box(self.exception, title=title)
            raise self.exception

        # If Database exception, show dialog after task has finished
        if global_vars.session_vars['last_error']:
            tools_qt.show_exception_message(msg=global_vars.session_vars['last_error_msg'])


    def cancel(self):

        tools_qgis.show_info(f"Task canceled - {self.description()}")
        self._close_file()
        super().cancel()


    def _close_file(self, file=None):

        if file is None:
            file = self.file_rpt

        try:
            if file:
                file.close()
                del file
        except Exception:
            pass


    # region private functions

    def _exec_function_pg2epa(self):

        self.json_result = None
        self.setProgress(0)

        extras = f'"resultId":"{self.result_name}"'
        extras += f', "useNetworkGeom":"{self.net_geom}"'
        extras += f', "dumpSubcatch":"{self.export_subcatch}"'
        self.body = tools_gw.create_body(extras=extras)
        dict_result = tools_gw.exec_pg_function('gw_fct_pg2epa_main', self.body, log_sql=True, is_thread=True)
        self.function_failed = dict_result['function_failed']
        self.json_result = dict_result['json_result']
        self.complet_result = dict_result['complet_result']

        return dict_result['status']


    def _export_inp(self):

        if self.isCanceled():
            return False

        tools_log.log_info(f"Create inp file into POSTGRESQL")

        # Get values from complet_result['body']['file'] and insert into INP file
        if 'file' not in self.complet_result['body']:
            return False

        self._fill_inp_file(self.file_inp, self.complet_result['body']['file'])
        self.message = self.complet_result['message']['text']
        self.common_msg += "Export INP finished. "

        return True


    def _fill_inp_file(self, folder_path=None, all_rows=None):

        tools_log.log_info(f"Write inp file........: {folder_path}")

        # Generate generic INP file
        file_inp = open(folder_path, "w")
        read = True
        for row in all_rows:
            # Use regexp to check which targets to read (everyone except GULLY)
            if bool(re.match('\[(.*?)\]', row['text'])) and \
                    ('GULLY' in row['text'] or 'LINK' in row['text'] or
                     'GRATE' in row['text'] or 'LXSECTIONS' in row['text']):
                read = False
            elif bool(re.match('\[(.*?)\]', row['text'])):
                read = True
            if 'text' in row and row['text'] is not None and read:
                line = row['text'].rstrip() + "\n"
                file_inp.write(line)

        self._close_file(file_inp)

        # Replace extension .inp
        aditional_path = folder_path.replace('.inp', f'.gul')
        aditional_file = open(aditional_path, "w")
        read = True
        save_file = False
        for row in all_rows:
            # Use regexp to check which targets to read (only TITLE and aditional target)
            if bool(re.match('\[(.*?)\]', row['text'])) and ('TITLE' in row['text'] or row['text'] in ['GULLY', 'LINK', 'GRATE', 'LXSECTIONS']):
                read = True
                if row['text'] in ['GULLY', 'LINK', 'GRATE', 'LXSECTIONS']:
                    save_file = True
            elif bool(re.match('\[(.*?)\]', row['text'])):
                read = False
            if 'text' in row and row['text'] is not None and read:
                line = row['text'].rstrip() + "\n"
                aditional_file.write(line)

        self._close_file(aditional_file)

        if save_file is False:
            os.remove(aditional_path)


    def _execute_epa(self):

        if self.isCanceled():
            return False

        tools_log.log_info(f"Execute EPA software")

        if self.file_rpt == "null":
            message = "You have to set this parameter"
            self.error_msg = f"{message}: RPT file"
            return False

        msg = "INP file not found"
        if self.file_inp is not None:
            if not os.path.exists(self.file_inp):
                self.error_msg = f"{msg}: {self.file_inp}"
                return False
        else:
            self.error_msg = f"{msg}: {self.file_inp}"
            return False

        # Set file to execute
        opener = None
        if global_vars.project_type in 'ws':
            opener = f"{global_vars.plugin_dir}{os.sep}resources{os.sep}epa{os.sep}epanet{os.sep}epanet20012.exe"
        elif global_vars.project_type in 'ud':
            opener = f"{global_vars.plugin_dir}{os.sep}resources{os.sep}epa{os.sep}swmm{os.sep}swmm50022.exe"

        if opener is None:
            return False

        if not os.path.exists(opener):
            self.error_msg = f"File not found: {opener}"
            return False

        subprocess.call([opener, self.file_inp, self.file_rpt], shell=False)
        self.common_msg += "EPA model finished. "

        return True


    def _import_rpt(self):
        """ Import result file """

        tools_log.log_info(f"Import rpt file........: {self.file_rpt}")

        self.rpt_result = None
        self.json_rpt = None
        status = False
        try:
            # Call import function
            status = self._read_rpt_file(self.file_rpt)
            if not status:
                return False
            status = self._exec_import_function()
        except Exception as e:
            self.error_msg = str(e)
        finally:
            return status


    def _read_rpt_file(self, file_path=None):

        self.file_rpt = open(file_path, "r+")
        full_file = self.file_rpt.readlines()
        progress = 0

        # Create dict with sources
        sql = f"SELECT tablename, target FROM config_fprocess WHERE fid = {self.fid};"
        rows = tools_db.get_rows(sql)
        sources = {}
        for row in rows:
            json_elem = row[1].replace('{', '').replace('}', '')
            item = json_elem.split(',')
            for i in item:
                sources[i.strip()] = row[0].strip()

        # While we don't find a match with the target, target and col40 must be null
        target = "null"
        col40 = "null"
        json_rpt = ""
        # noinspection PyUnusedLocal
        row_count = sum(1 for rows in full_file)

        for line_number, row in enumerate(full_file):

            if self.isCanceled():
                return False

            progress += 1
            if '**' in row or '--' in row:
                continue

            row = row.rstrip()
            dirty_list = row.split(' ')

            # Clean unused items
            for x in range(len(dirty_list) - 1, -1, -1):
                if dirty_list[x] == '':
                    dirty_list.pop(x)

            sp_n = []
            if len(dirty_list) > 0:
                for x in range(0, len(dirty_list)):
                    if bool(re.search('[0-9][-]\d{1,2}[.]]*', str(dirty_list[x]))):
                        last_index = 0
                        for i, c in enumerate(dirty_list[x]):
                            if "-" == c:
                                json_elem = dirty_list[x][last_index:i]
                                last_index = i
                                sp_n.append(json_elem)

                        # noinspection PyUnboundLocalVariable
                        json_elem = dirty_list[x][last_index:i]
                        sp_n.append(json_elem)

                    elif bool(re.search('(\d\..*\.\d)', str(dirty_list[x]))):
                        if 'Version' not in dirty_list and 'VERSION' not in dirty_list:
                            error_near = f"Error near line {line_number+1} -> {dirty_list}"
                            tools_log.log_info(error_near)
                            message = (f"The rpt file is not valid to import. "
                                       f"Because columns on rpt file are overlaped, it seems you need to improve your simulation. "
                                       f"Please ckeck and fix it before continue. \n"
                                       f"{error_near}")
                            self.error_msg = message
                            return False
                    elif bool(re.search('>50', str(dirty_list[x]))):
                        error_near = f"Error near line {line_number+1} -> {dirty_list}"
                        tools_log.log_info(error_near)
                        message = (f"The rpt file is not valid to import. "
                                   f"Because velocity has not numeric value (>50), it seems you need to improve your simulation. "
                                   f"Please ckeck and fix it before continue. \n"
                                   f"{error_near}")
                        self.error_msg = message
                        return False
                    else:
                        sp_n.append(dirty_list[x])

            # Find strings into dict and set target column
            for k, v in sources.items():
                try:
                    if k in (f'{sp_n[0]} {sp_n[1]}', f'{sp_n[0]}'):
                        target = "'" + v + "'"
                        _time = re.compile('^([012]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$')
                        if _time.search(sp_n[3]):
                            col40 = "'" + sp_n[3] + "'"
                except IndexError:
                    pass
                except Exception as e:
                    tools_log.log_info(type(e).__name__)

            if len(sp_n) > 0:
                json_elem = f'"target": "{target}", "col40": "{col40}", '
                for x in range(0, len(sp_n)):
                    json_elem += f'"col{x + 1}":'
                    if "''" not in sp_n[x]:
                        value = '"' + sp_n[x].strip().replace("\n", "") + '", '
                        value = value.replace("''", "null")
                    else:
                        value = 'null, '
                    json_elem += value

                json_elem = '{' + str(json_elem[:-2]) + '}, '
                json_rpt += json_elem

            # Update progress bar
            if progress % 1000 == 0:
                self.setProgress((line_number * 100) / row_count)

        # Manage JSON
        json_rpt = '[' + str(json_rpt[:-2]) + ']'
        self.json_rpt = json_rpt

        self._close_file()

        return True


    def _exec_import_function(self):
        """ Call function gw_fct_rpt2pg_main """

        extras = f'"resultId":"{self.result_name}"'
        if self.json_rpt:
            extras += f', "file": {self.json_rpt}'
        self.body = tools_gw.create_body(extras=extras)
        self.json_result = tools_gw.execute_procedure('gw_fct_rpt2pg_main', self.body)
        self.rpt_result = self.json_result
        if self.json_result is None or not self.json_result:
            self.function_failed = True
            return False

        if 'status' in self.json_result and self.json_result['status'] == 'Failed':
            tools_log.log_warning(self.json_result)
            self.function_failed = True
            return False

        # final message
        self.common_msg += "Import RPT file finished."

        return True

    # endregion