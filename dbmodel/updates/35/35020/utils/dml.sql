/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/30
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (430, 'Check matcat null for arcs','utils', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (431, 'Check minimun length for arcs','ud', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('temp_data', 'Table for additional, uneditable fields related to feature','role_om', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, descript, sys_role, project_type, vdefault, datatype, ismandatory)
VALUES ('edit_typevalue_fk_disable', 'hidden', 'Used on code to disable fk in order to enhance performance for grafanalytics mapzones', 'role_basic', 'utils','FALSE','boolean',true) 
ON CONFLICT (id) DO NOTHING;

--2021/12/07
INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES ('3192', 'It is not possible to connect on service arc with a planified node', 'Reconnect arc with node state 1', 2, TRUE, 'utils', NULL)
ON CONFLICT (id) DO NOTHING;
