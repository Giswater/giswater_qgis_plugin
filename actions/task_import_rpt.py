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

from .add_layer import AddLayer


class TaskImportRpt(QgsTask):
    """ This shows how to subclass QgsTask """

    fake_progress = pyqtSignal()
    def __init__(self, description, controller, dlg_go2epa, file_rpt, result_name):

        super().__init__(description, QgsTask.CanCancel)
        self.exception = None
        self.controller = controller
        self.dlg_go2epa = dlg_go2epa
        self.file_rpt = file_rpt
        self.result_name = result_name
        self.error_msg = None
        self.message = None
        self._file = None
        self.add_layer = AddLayer(self.controller.iface, None, controller, None)
        #self.progressChanged.connect(self.progress_changed)


    def run(self):

        self.controller.log_info(f"Task started: {self.description()}")

        #self.dlg_go2epa.close()
        self.setProgress(0)
        status = False
        try:
            # Delete previous values of user on temp table
            sql = ("DELETE FROM temp_csv2pg "
                   "WHERE user_name = current_user AND csv2pgcat_id = 11")
            self.controller.execute_sql(sql)
            # Importing file to temporal table
            status = self.insert_rpt_into_db(self.file_rpt)
            if status:
                self.finish_rpt()
        except Exception as e:
            self.error_msg = str(e)
        finally:
            return status


    def finished(self, result):

        self.close_file()

        if result:
            self.controller.log_info(f"Task finished: {self.description()}")
            if 'status' in self.rpt_result[0]:
                if self.rpt_result[0]['status'] == "Accepted":
                    if 'body' in self.rpt_result[0]:
                        if 'data' in self.rpt_result[0]['body']:
                            self.add_layer.add_temp_layer(self.dlg_go2epa, self.rpt_result[0]['body']['data'],
                                'RPT results', True, True, 1, False)
            self.message = self.rpt_result[0]['message']['text']
            self.controller.show_info_box(self.message)
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


    def progress_changed(self, progress):

        self.controller.log_info(f"progressChanged: {progress}")


    def close_file(self):

        if self._file:
            self._file.close()
            del self._file


    def insert_rpt_into_db(self, folder_path=None):

        self._file = open(folder_path, "r+")
        full_file = self._file.readlines()
        progress = 0
        counter = 1

        # Create dict with sources
        sql = "SELECT tablename, target FROM sys_csv2pg_config WHERE pg2csvcat_id = '11';"
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
                sql += f"INSERT INTO temp_csv2pg (csv2pgcat_id, source, csv40, "
                values = f"VALUES(11, {source}, {csv40}, "
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


        # Call function gw_fct_rpt2pg_main
        function_name = 'gw_fct_rpt2pg_main'
        extras = '"iterative":"disabled"'
        #if is_iterative and _continue:
        #    extras = '"iterative":"enabled"'
        extras += f', "resultId":"{self.result_name}"'
        extras += f', "currentStep":"{counter}"'
        extras += f', "continue":"{False}"'
        body = self.create_body(extras=extras)
        sql = f"SELECT {function_name}({body})::text"
        row = self.controller.get_row(sql, log_sql=True)
        if not row or row[0] is None:
            self.controller.show_warning(f"NOT ROW FOR: {sql}")
            self.message = "Import failed"
            return False

        self.rpt_result = [json.loads(row[0], object_pairs_hook=OrderedDict)]

        return True


    def create_body(self, form='', feature='', filter_fields='', extras=None):
        """ Create and return parameters as body to functions"""

        client = f'$${{"client":{{"device":9, "infoType":100, "lang":"ES"}}, '
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

