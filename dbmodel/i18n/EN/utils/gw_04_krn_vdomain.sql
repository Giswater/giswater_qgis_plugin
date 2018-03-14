/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO sys_csv2pg_cat VALUES (2, 'Import node visit file', 'Import node visit file', 'The csv file must contains next columns on same position: [node_id], [unit]', 'role_om');
INSERT INTO sys_csv2pg_cat VALUES (3, 'Import arc visit file', 'Import arc visit file', 'The csv file must contains next columns on same position: [arc_id], [unit]. The column [...] must be numeric with two decimals', 'role_om');
INSERT INTO sys_csv2pg_cat VALUES (1, 'Import db prices', 'Import db prices', 'The csv file must contains next columns on same position: [id], [unit], [descript], [text], [price]. The column [price] must be numeric with two decimals', 'role_master');
