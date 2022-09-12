/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


INSERT INTO config_report VALUES (
902,'Actividad GDB GAM',
'SELECT * FROM audit.v_log_gam',
'{"orderBy":"4", "orderType": "DESC"}', 
'[{"columnname":"date", "filterSign":"> now() - INTERVAL", "vDefault":"60 days", "label":"Fecha:", "widgettype":"combo","datatype":"text","layoutorder":1,"dvquerytext":"Select id, idval FROM ws.om_typevalue WHERE typevalue = 'custom_report_update_db' ORDER BY addparam->>'orderby'", "filterSign":"> now() - INTERVAL"},
  {"columnname":"user_name", "filterSign":"=", "vDefault":'''', "label":"User:", "widgettype":"combo","datatype":"text","layoutorder":2,"dvquerytext":"SELECT DISTINCT user_name as id, user_name as idval FROM audit.v_log_gam UNION SELECT '''' as id, null as idval ORDER BY 1 asc"}]'
,'role_master',NULL,TRUE);


INSERT INTO config_report VALUES (
903,'Check health GAM',
'SELECT * FROM audit.v_fidlog_gam_index',
'{"orderBy":"1", "orderType": "DESC"}', NULL,
'role_master',NULL,TRUE);

INSERT INTO config_report VALUES (
904,'Check health GAM (Detalle)',
'SELECT date, type, fprocess_name, (case when criticity = 2 then ''WARNING'' WHEN criticity = 3 THEN ''ERROR'' END) criticity, value FROM audit.v_fidlog_gam_aux WHERE type IS NOT NULL',
'{"orderBy":"1", "orderType": "DESC"}',
'[{"columnname":"date", "label":"Date:", "widgettype":"combo","datatype":"text","layoutorder":1, "dvquerytext":"Select distinct on (date) date AS id, date AS idval FROM audit.v_fidlog_gam_aux ORDER BY date DESC"},
{"columnname":"type", "label":"Type:", "widgettype":"combo","datatype":"text","layoutorder":2, "dvquerytext":"Select distinct on (type) type AS id, type AS idval FROM audit.v_fidlog_gam_aux ORDER BY type DESC"}]',
'role_master',NULL,TRUE);


