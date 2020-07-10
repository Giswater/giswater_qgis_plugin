"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal
from qgis.core import QgsTask

import re
import os
import subprocess

from .add_layer import AddLayer


class TaskGo2Epa(QgsTask):
    """ This shows how to subclass QgsTask """

    fake_progress = pyqtSignal()

    def __init__(self, description, controller, go2epa):

        super().__init__(description, QgsTask.CanCancel)
        self.exception = None
        self.controller = controller
        self.go2epa = go2epa
        self.error_msg = None
        self.message = None
        self.common_msg = ""
        self._file = None
        self.fid = 140
        self.set_variables_from_go2epa()
        self.add_layer = AddLayer(self.controller.iface, None, controller, None)
        # self.progressChanged.connect(self.progress_changed)


    def set_variables_from_go2epa(self):
        """ Set variables from object Go2Epa """

        self.dlg_go2epa = self.go2epa.dlg_go2epa
        self.result_name = self.go2epa.result_name
        self.file_inp = self.go2epa.file_inp
        self.file_rpt = self.go2epa.file_rpt
        self.export_inp = self.go2epa.export_inp
        self.exec_epa = self.go2epa.exec_epa
        self.import_result = self.go2epa.import_result
        self.project_type = self.go2epa.project_type
        self.plugin_dir = self.go2epa.plugin_dir
        self.net_geom = self.go2epa.net_geom
        self.export_subcatch = self.go2epa.export_subcatch


    def run(self):

        if not self.exec_function_pg2epa():
            return False

        if self.export_inp:
            self.export_to_inp()

        if self.exec_epa:
            self.execute_epa()

        if self.import_result:
            self.import_rpt()

        return True


    def finished(self, result):

        self.close_file()

        if result:

            if self.export_inp and self.complet_result:
                if 'status' in self.complet_result:
                    if self.complet_result['status'] == "Accepted":
                        if 'body' in self.complet_result:
                            if 'data' in self.complet_result['body']:
                                self.add_layer.add_temp_layer(self.dlg_go2epa, self.complet_result['body']['data'],
                                    'INP results', True, True, 1, False, disable_tabs=False)

            if self.import_result and self.rpt_result:
                if 'status' in self.rpt_result:
                    if self.rpt_result['status'] == "Accepted":
                        if 'body' in self.rpt_result:
                            if 'data' in self.rpt_result['body']:
                                self.add_layer.add_temp_layer(self.dlg_go2epa, self.rpt_result['body']['data'],
                                    'RPT results', True, True, 1, False, disable_tabs=False)
                        self.message = self.rpt_result['message']['text']

            if self.common_msg != "":
                self.controller.show_info(self.common_msg)
            if self.message is not None:
                self.controller.show_info_box(self.message)
            self.go2epa.check_result_id()
            return

        if self.error_msg:
            self.controller.log_info(f"Task aborted: {self.description()}")
            self.controller.log_warning(f"Exception description: {self.error_msg}")
            return

        if self.exception:
            self.controller.log_info(f"Task aborted: {self.description()}")
            self.controller.log_warning(f"Exception: {self.exception}")
            raise self.exception


    def cancel(self):

        self.controller.log_info(f"Task canceled: {self.description()}")
        self.close_file()
        super().cancel()


    def progress_changed(self, progress):

        self.controller.log_info(f"progressChanged: {progress}")


    def close_file(self, file=None):

        if file is None:
            file = self._file

        if file:
            file.close()
            del file


    def exec_function_pg2epa(self):

        self.complet_result = None
        self.setProgress(0)
        extras = f'"resultId":"{self.result_name}"'
        extras += f', "useNetworkGeom":"{self.net_geom}"'
        extras += f', "dumpSubcatch":"{self.export_subcatch}"'
        body = self.create_body(extras=extras)
        function_name = 'gw_fct_pg2epa_main'
        json_result = self.controller.get_json(function_name, body, log_sql=True)
        if json_result is None:
            return False

        self.complet_result = json_result
        if not self.complet_result:
            return False

        return True


    def export_to_inp(self):

        self.controller.log_info(f"Create inp file into POSTGRESQL")

        # Get values from complet_result['body']['file'] and insert into INP file
        if 'file' not in self.complet_result['body']:
            return False

        self.fill_inp_file(self.file_inp, self.complet_result['body']['file'])
        self.message = self.complet_result['message']['text']
        self.common_msg += "Export INP finished. "


    def fill_inp_file(self, folder_path=None, all_rows=None):

        self.controller.log_info(f"Write inp file........: {folder_path}")

        file1 = open(folder_path, "w")
        for row in all_rows:
            if 'text' in row and row['text'] is not None:
                line = row['text'].rstrip() + "\n"
                file1.write(line)

        self.close_file(file1)


    def execute_epa(self):

        self.controller.log_info(f"Execute EPA software")

        if self.file_rpt == "null":
            message = "You have to set this parameter"
            self.controller.show_warning(message, parameter="RPT file")
            return

        msg = "INP file not found"
        if self.file_inp is not None:
            if not os.path.exists(self.file_inp):
                self.controller.show_warning(msg, parameter=str(self.file_inp))
                return
        else:
            self.controller.show_warning(msg, parameter=str(self.file_inp))
            return

        # Set file to execute
        opener = None
        if self.project_type in 'ws':
            opener = f"{self.plugin_dir}/epa/ws_epanet20012.exe"
        elif self.project_type in 'ud':
            opener = f"{self.plugin_dir}/epa/ud_swmm50022.exe"

        if opener is None:
            return

        if os.path.exists(opener):
            subprocess.call([opener, self.file_inp, self.file_rpt], shell=False)
            self.common_msg += "EPA model finished. "
        else:
            msg = "File not found"
            self.controller.show_warning(msg, parameter=opener)


    def import_rpt(self):
        """import result file"""

        self.controller.log_info(f"Import rpt file........: {self.file_rpt}")

        self.rpt_result = None
        self.json_rpt = None
        status = False
        try:
            # Call import function
            status = self.read_rpt_file(self.file_rpt)
            if not status:
                return False
            status = self.exec_import_function()
        except Exception as e:
            self.error_msg = str(e)
        finally:
            return status


    def read_rpt_file(self, folder_path=None):

        self._file = open(folder_path, "r+")
        full_file = self._file.readlines()
        progress = 0

        # Create dict with sources
        sql = f"SELECT tablename, target FROM config_fprocess WHERE fid = {self.fid};"
        rows = self.controller.get_rows(sql)
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
        row_count = sum(1 for rows in full_file)  # @UnusedVariable

        # self.controller.log_info(f"'{self.description()}'. Row count: {row_count}")

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

                        json_elem = dirty_list[x][last_index:i]
                        sp_n.append(json_elem)

                    elif bool(re.search('(\d\..*\.\d)', str(dirty_list[x]))):
                        if 'Version' not in dirty_list and 'VERSION' not in dirty_list:
                            self.controller.log_info(f"Error near line {line_number+1} -> {dirty_list}")
                            message = ("The rpt file has a heavy inconsistency. "
                                       "As a result it's not posible to import it. "
                                       "Columns are overlaped one againts other, this is a not valid simulation. "
                                       "Please ckeck and fix it before continue")
                            self.controller.show_message(message, 1)
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
                    self.controller.log_info(type(e).__name__)

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

        self.close_file()

        return True


    def create_body(self, form='', feature='', filter_fields='', extras=None):
        """ Create and return parameters as body to functions"""

        client = f'$${{"client":{{"device":4, "infoType":1, "lang":"ES"}}, '
        form = f'"form":{{{form}}}, '
        feature = f'"feature":{{{feature}}}, '
        filter_fields = f'"filterFields":{{{filter_fields}}}'
        page_info = f'"pageInfo":{{}}'
        data = f'"data":{{{filter_fields}, {page_info}'
        if extras is not None:
            data += ', ' + extras
        data += f'}}}}$$'
        body = "" + client + form + feature + data

        return body


    def exec_import_function(self):
        """ Call function gw_fct_rpt2pg_main """

        extras = f'"resultId":"{self.result_name}"'
        if self.json_rpt:
            extras += f', "file": {self.json_rpt}'
        body = self.create_body(extras=extras)
        function_name = 'gw_fct_rpt2pg_main'
        json_result = self.controller.get_json(function_name, body, log_sql=False)
        if json_result is None:
            return False

        self.rpt_result = json_result
        if not self.rpt_result:
            return False

        # final message
        self.common_msg += "Import RPT file finished."

        return True
