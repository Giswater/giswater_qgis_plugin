/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO om_typevalue
(typevalue, id, idval, descript, addparam)
VALUES('custom_report_update_db', '60 days', '2 MONTHS', NULL, '{"orderby":0}'::json);
INSERT INTO om_typevalue
(typevalue, id, idval, descript, addparam)
VALUES('custom_report_update_db', '1 days', '1 DAY', NULL, '{"orderby":5}'::json);
INSERT INTO om_typevalue
(typevalue, id, idval, descript, addparam)
VALUES('custom_report_update_db', '3 days', '3 DAYS', NULL, '{"orderby":4}'::json);
INSERT INTO om_typevalue
(typevalue, id, idval, descript, addparam)
VALUES('custom_report_update_db', '7 days', '1 WEEK', NULL, '{"orderby":3}'::json);
INSERT INTO om_typevalue
(typevalue, id, idval, descript, addparam)
VALUES('custom_report_update_db', '14 days', '2 WEEKS', NULL, '{"orderby":2}'::json);
INSERT INTO om_typevalue
(typevalue, id, idval, descript, addparam)
VALUES('custom_report_update_db', '31 days', '1 MONTH', NULL, '{"orderby":1}'::json);
