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
