"""
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
from qgis.PyQt.QtCore import pyqtSignal

from .task import GwTask
from ...libs import tools_db, tools_log


class GwVacuumSchemaTask(GwTask):

    task_finished = pyqtSignal()

    def __init__(self, description, params):
        super().__init__(description)
        self.params = params
        self.db_exception = (None, None, None)  # error, sql, filepath
        self.status = False
        self.output = []

    def run(self):
        super().run()        
        
        schema_name = self.params.get('schema_name')
        logs = self.params.get('logs', False)
        verbose = self.params.get('verbose', False)

        tools_log.log_info("Starting execute_vacuum method")
        sql = (f"SELECT table_name FROM information_schema.tables WHERE table_schema = '{schema_name}' AND table_type = 'BASE TABLE' ORDER BY table_name")

        tables = tools_db.get_rows(sql, commit=True)
            
        # Create a separate connection for vacuum operations
        aux_conn = tools_db.dao.get_aux_conn()
        if aux_conn is None:
            msg = "Error creating auxiliary connection for vacuum"
            tools_log.log_error(msg)
            return False
                
        try:
            if tables is not None:
                msg = "Executing vacuum"
                tools_log.log_info(msg)

                for table in tables:
                    try:
                        aux_conn.autocommit = True
                        if verbose:
                            tools_db.execute_sql(f"VACUUM FULL VERBOSE ANALYZE {schema_name}.{table[0].strip()};", 
                                                commit=False, aux_conn=aux_conn)
                            for notice in aux_conn.notices:
                                for line in notice.strip().splitlines():
                                    line = line.strip()
                                    if line.startswith("INFO:") and "CPU:" not in line:
                                        tools_log.log_info(line)
                            tools_log.log_info(f"Vacuum executed: {schema_name}.{table[0].strip()}")
                            aux_conn.notices.clear()
                        
                        else:
                            tools_db.execute_sql(f"VACUUM FULL ANALYZE {schema_name}.{table[0].strip()};", 
                                                commit=False, aux_conn=aux_conn)
                            if logs:
                                tools_log.log_info(f"Vacuum executed: {schema_name}.{table[0].strip()}")

                    except Exception as e:
                        msg = f"Error executing vacuum: {e}"
                        tools_log.log_error(msg)
                        return False
        finally:
            # Always clean up the auxiliary connection
            tools_db.dao.delete_aux_con(aux_conn)
        
        return True

    def finished(self, result):
        super().finished(result)
        
        msg = "Schema vacuum executed"
        tools_log.log_info(msg)

        self.task_finished.emit()
