"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal, QObject
from qgis.core import QgsTask, QgsMessageLog, Qgis

from collections import OrderedDict
import re
import json
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
        self.set_variables_from_go2epa()
        self.add_layer = AddLayer(self.controller.iface, None, controller, None)
        #self.progressChanged.connect(self.progress_changed)


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

        self.controller.log_info(f"Task started: {self.description()}")

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

            if self.export_inp:
                if self.complet_result['status'] == "Accepted":
                    if 'body' in self.complet_result:
                        if 'data' in self.complet_result['body']:
                            self.add_layer.add_temp_layer(self.dlg_go2epa, self.complet_result['body']['data'],
                                'INP results', True, True, 1, False)

            if self.import_result:
                if 'status' in self.rpt_result[0]:
                    if self.rpt_result[0]['status'] == "Accepted":
                        if 'body' in self.rpt_result[0]:
                            if 'data' in self.rpt_result[0]['body']:
                                self.add_layer.add_temp_layer(self.dlg_go2epa, self.rpt_result[0]['body']['data'],
                                    'RPT results', True, True, 1, False)
                self.message = self.rpt_result[0]['message']['text']

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

        self.controller.log_info(f"Task {self.description()} was cancelled")
        super().cancel()


    def isCanceled(self):

        self.close_file()


    def progress_changed(self, progress):

        self.controller.log_info(f"progressChanged: {progress}")


    def close_file(self, file=None):

        if file is None:
            file = self._file

        if file:
            file.close()
            del file


    def exec_function_pg2epa(self):

        self.setProgress(0)
        extras = '"iterative":"off"'
        extras += f', "resultId":"{self.result_name}"'
        extras += f', "useNetworkGeom":"{self.net_geom}"'
        extras += f', "dumpSubcatch":"{self.export_subcatch}"'
        body = self.create_body(extras=extras)
        self.complet_result = self.controller.get_json('gw_fct_pg2epa_main', body, log_sql=True, commit=True)
        if not self.complet_result:
            self.controller.show_warning(str(self.controller.last_error))
            message = "Export failed"
            self.controller.show_info_box(message)
            return False

        return True


    def export_to_inp(self):

        # Get values from complet_result['body']['file'] and insert into INP file
        if 'file' not in self.complet_result['body']:
            return False

        self.fill_inp_file(self.file_inp, self.complet_result['body']['file'])
        self.message = self.complet_result['message']['text']
        self.common_msg += "Export INP finished. "


    def fill_inp_file(self, folder_path=None, all_rows=None):

        self.controller.log_info(f"fill_inp_file: {folder_path}")

        file1 = open(folder_path, "w")
        for row in all_rows:
            if 'text' in row and row['text'] is not None:
                line = row['text'].rstrip() + "\n"
                file1.write(line)

        self.close_file(file1)


    def execute_epa(self):

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

        self.controller.log_info(f"import_rpt: {self.file_rpt}")

        status = False
        try:
            # Delete previous values of user on temp table
            sql = ("DELETE FROM temp_csv "
                   "WHERE cur_user = current_user AND fid = 111")
            self.controller.execute_sql(sql)
            # Importing file to temporal table
            status = self.insert_rpt_into_db(self.file_rpt)
            if not status:
                return False
            status = self.exec_function_rpt2pg()
        except Exception as e:
            self.error_msg = str(e)
        finally:
            return status


    def insert_rpt_into_db(self, folder_path=None):

        self._file = open(folder_path, "r+")
        full_file = self._file.readlines()
        progress = 0

        # Create dict with sources
        sql = "SELECT tablename, target FROM config_fprocess WHERE fid = 111;"
        rows = self.controller.get_rows(sql)
        sources = {}
        for row in rows:
            aux = row[1].replace('{','').replace('}', '')
            item = aux.split(',')
            for i in item:
                sources[i.strip()]=row[0].strip()

        # While we don't find a match with the source, source and csv40 must be null
        source = "null"
        csv40 = "null"
        sql = ""
        row_count = sum(1 for rows in full_file)  # @UnusedVariable

        self.controller.log_info(f"'{self.description()}'. Row count: {row_count}")

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
                                aux = dirty_list[x][last_index:i]
                                last_index = i
                                sp_n.append(aux)

                        aux = dirty_list[x][last_index:i]
                        sp_n.append(aux)

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

            # Find strings into dict and set source column
            for k, v in sources.items():
                try:
                    if k in (f'{sp_n[0]} {sp_n[1]}', f'{sp_n[0]}'):
                        source = "'" + v + "'"
                        _time = re.compile('^([012]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$')
                        if _time.search(sp_n[3]):
                            csv40 = "'" + sp_n[3] + "'"
                except IndexError:
                    pass
                except Exception as e:
                    self.controller.log_info(type(e).__name__)

            if len(sp_n) > 0:
                sql += f"INSERT INTO temp_csv (fid, source, csv40, "
                values = f"VALUES(111, {source}, {csv40}, "
                for x in range(0, len(sp_n)):
                    if "''" not in sp_n[x]:
                        sql += f"csv{x + 1}, "
                        value = "'" + sp_n[x].strip().replace("\n", "") + "', "
                        values += value.replace("''", "null")
                    else:
                        sql += f"csv{x + 1}, "
                        values = "VALUES(null, "
                sql = sql[:-2] + ") "
                values = values[:-2] + ");\n"
                sql += values

            # Execute SQL every in batches of N records
            if progress % 1000 == 0:
                self.setProgress((line_number * 100) / row_count)
                self.controller.execute_sql(sql)
                sql = ""

        if sql != "":
            self.controller.execute_sql(sql)

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


    def exec_function_rpt2pg(self):
        """ Call function gw_fct_rpt2pg_main """

        function_name = 'gw_fct_rpt2pg_main'
        extras = '"iterative":"disabled"'
        extras += f', "resultId":"{self.result_name}"'
        extras += f', "currentStep":"1"'
        extras += f', "continue":"False"'
        body = self.create_body(extras=extras)
        sql = f"SELECT {function_name}({body})::text"
        row = self.controller.get_row(sql)
        if not row or row[0] is None:
            self.controller.show_warning(self.controller.last_error)
            message = "Import failed"
            self.controller.show_info_box(message)
            return False
        else:
            self.rpt_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        # final message
        self.common_msg += "Import RPT finished."

        return True

