/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/04/22
INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, sys_rows, qgis_role_id, qgis_criticity, qgis_message, isdeprecated)
VALUES ('anl_mincut_checkvalve','Mincut','Table to config check valves and their direction on the network', 'role_om',0,null,null,null,null, false) ON CONFLICT (id) DO NOTHING;
