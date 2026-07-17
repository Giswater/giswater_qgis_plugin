/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = PARENT_SCHEMA, public, pg_catalog;

INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam)
VALUES ('custom_report_update_db', '60 days', '2 MONTHS', NULL, '{"orderby":0}'::json)
ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam)
VALUES ('custom_report_update_db', '1 days', '1 DAY', NULL, '{"orderby":5}'::json)
ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam)
VALUES ('custom_report_update_db', '3 days', '3 DAYS', NULL, '{"orderby":4}'::json)
ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam)
VALUES ('custom_report_update_db', '7 days', '1 WEEK', NULL, '{"orderby":3}'::json)
ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam)
VALUES ('custom_report_update_db', '14 days', '2 WEEKS', NULL, '{"orderby":2}'::json)
ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam)
VALUES ('custom_report_update_db', '31 days', '1 MONTH', NULL, '{"orderby":1}'::json)
ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO config_fprocess
(fid, tablename, target, querytext, orderby, addparam, active)
VALUES(9000, 'audit_fid_log', 'DATA', 'SELECT sum(gis_length) FROM ve_arc WHERE state=1', NULL, NULL, true) ON CONFLICT (fid, tablename, target) DO NOTHING;

INSERT INTO sys_fprocess
(fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(9000, 'Calculate current network length', 'utils', NULL, 'core', true, 'length', NULL) ON CONFLICT (fid) DO NOTHING;



INSERT INTO config_report
(id, alias, query_text, addparam, filterparam, sys_role, descript, active, device)
VALUES(902, 'DB Activity', 'SELECT date, user_name, count, action FROM audit.v_log WHERE schema = ''PARENT_SCHEMA''',
'{"orderBy":"1", "orderType": "DESC", "filterSign":"> now() - INTERVAL", "vDefault":"60 days"}'::json,
'[{"columnname":"date", "label":"Fecha:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select id, idval FROM om_typevalue WHERE typevalue = ''custom_report_update_db'' ORDER BY addparam->>''orderby''", "filterSign":"> now() - INTERVAL"}]'::json,
'role_plan', NULL, true, '{4}') ON CONFLICT (id) DO NOTHING;

INSERT INTO config_report
(id, alias, query_text, addparam, filterparam, sys_role, descript, active)
VALUES(903, 'Check health UD', 'SELECT * FROM audit.v_fidlog_index WHERE schema = ''PARENT_SCHEMA''', '{"orderBy":"1", "orderType": "DESC"}'::json, NULL, 'role_plan', NULL, true) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_report
(id, alias, query_text, addparam, filterparam, sys_role, descript, active)
VALUES(904, 'Check health UD (Detail)', 'SELECT date, type, fprocess_name, (case when criticity = 2 then ''WARNING'' WHEN criticity = 3 THEN ''ERROR'' END) criticity, value 
FROM audit.v_fidlog_aux WHERE type IS NOT NULL AND schema = ''PARENT_SCHEMA''
', '{"orderBy":"1", "orderType": "DESC"}'::json, '[{"columnname":"type", "label":"Type:",
"widgettype":"combo","datatype":"text","layoutorder":2, "dvquerytext":"Select distinct on (type) type AS id, type AS idval FROM audit.v_fidlog_aux WHERE schema = ''PARENT_SCHEMA'' ORDER BY type DESC"}]'::json, 'role_plan', NULL, true) ON CONFLICT (id) DO NOTHING;


UPDATE PARENT_SCHEMA.sys_table SET isaudit = true WHERE
id = ANY (SELECT child_layer FROM PARENT_SCHEMA.cat_feature) OR id = 'node';
