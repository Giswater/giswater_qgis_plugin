/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



INSERT INTO audit_cat_param_user VALUES ('arctype_vdefault', 'config', 'Default value of arc type', 'role_edit', NULL, NULL, 'Arc Type:', 'SELECT id AS id, id AS idval FROM arc_type WHERE id IS NOT NULL', NULL, true, 10, 1, 'ud', false, NULL, NULL, NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
UPDATE audit_cat_param_user set layout_order=2 where id = 'arccat_vdefault';
