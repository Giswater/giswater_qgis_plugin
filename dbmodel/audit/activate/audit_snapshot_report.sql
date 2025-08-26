/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = PARENT_SCHEMA, public, pg_catalog;


INSERT INTO config_report
(id, alias, query_text, addparam, filterparam, sys_role, descript, active, device)
VALUES(902, 'DB Activity', 'SELECT date, user_name, count, action FROM audit.v_log WHERE schema = ''PARENT_SCHEMA''',
'{"orderBy":"1", "orderType": "DESC", "filterSign":"> now() - INTERVAL", "vDefault":"60 days"}'::json,
'[{"columnname":"date", "label":"Fecha:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select id, idval FROM om_typevalue WHERE typevalue = ''custom_report_update_db'' ORDER BY addparam->>''orderby''", "filterSign":"> now() - INTERVAL"}]'::json,
'role_master', NULL, true, '{4}') ON CONFLICT (id) DO NOTHING;

DO $$
DECLARE
    v_project_type text;
    v_schema text;  
BEGIN
    SELECT project_type INTO v_project_type FROM PARENT_SCHEMA.sys_version LIMIT 1;

    IF v_project_type = 'UD' THEN
        INSERT INTO config_report
        (id, alias, query_text, addparam, filterparam, sys_role, descript, active)
        VALUES(903, 'Check health UD', 'SELECT * FROM audit.v_fidlog_index WHERE schema = ''PARENT_SCHEMA''', '{"orderBy":"1", "orderType": "DESC"}'::json, NULL, 'role_master', NULL, true) ON CONFLICT (id) DO NOTHING;

        INSERT INTO config_report
        (id, alias, query_text, addparam, filterparam, sys_role, descript, active)
        VALUES(904, 'Check health UD (Detail)', 'SELECT date, type, fprocess_name, (case when criticity = 2 then ''WARNING'' WHEN criticity = 3 THEN ''ERROR'' END) criticity, value 
        FROM audit.v_fidlog_aux WHERE type IS NOT NULL AND schema = ''PARENT_SCHEMA''
        ', '{"orderBy":"1", "orderType": "DESC"}'::json, '[{"columnname":"type", "label":"Type:",
        "widgettype":"combo","datatype":"text","layoutorder":2, "dvquerytext":"Select distinct on (type) type AS id, type AS idval FROM audit.v_fidlog_aux WHERE schema = ''PARENT_SCHEMA'' ORDER BY type DESC"}]'::json, 'role_master', NULL, true) ON CONFLICT (id) DO NOTHING;
    ELSE
        INSERT INTO config_report
        (id, alias, query_text, addparam, filterparam, sys_role, descript, active, device)
        VALUES(903, 'Check health WS', 'SELECT * FROM audit.v_fidlog_index WHERE schema = ''PARENT_SCHEMA''', '{"orderBy":"1", "orderType": "DESC"}'::json, NULL, 'role_master', NULL, true, '{4}') ON CONFLICT (id) DO NOTHING;

        INSERT INTO config_report
        (id, alias, query_text, addparam, filterparam, sys_role, descript, active, device)
        VALUES(904, 'Check health WS (Detail)', 'SELECT date, type, fprocess_name, (case when criticity = 2 then ''WARNING'' WHEN criticity = 3 THEN ''ERROR'' END) criticity, value 
        FROM audit.v_fidlog_aux WHERE type IS NOT NULL AND schema = ''PARENT_SCHEMA''
        ', '{"orderBy":"1", "orderType": "DESC"}'::json, '[{"columnname":"type", "label":"Type:",
        "widgettype":"combo","datatype":"text","layoutorder":2, "dvquerytext":"Select distinct on (type) type AS id, type AS idval FROM audit.v_fidlog_aux WHERE schema = ''PARENT_SCHEMA'' ORDER BY type DESC"}]'::json, 'role_master', NULL, true, '{4}') ON CONFLICT (id) DO NOTHING;
    END IF;
END $$;