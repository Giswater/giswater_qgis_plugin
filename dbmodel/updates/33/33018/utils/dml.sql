/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--04/12/2019
INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (101, 'Connecs with duplicated customer_code', 'Edit','Connecs with duplicated customer_code','utils');

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (102, 'Feature which id is not an integer', 'Edit','Feature which id is not an integer','utils');

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (103, 'Final nodes with arc_id', 'Edit','Final nodes with arc_id','utils');

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (104, 'Connec without link', 'Edit','Connec without link','utils');

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, fprocess_i18n, project_type)
VALUES (105, 'Connec or gully chain with different arc_id ', 'Edit','Connec or gully chain with different arc_id','utils');
