/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
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

INSERT INTO sys_version (id, giswater, project_type, postgres, postgis, "date", "language", epsg) VALUES(2, '4.0.001', 'AUDIT', 'PostgreSQL 16.1, compiled by Visual C++ build 1937, 64-bit', '3.4 USE_GEOS=1 USE_PROJ=1 USE_STATS=1', '2025-04-16 10:48:31.383', 'en_US', 25831);
