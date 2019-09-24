/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-----------------------
-- 24/09/2019
-----------------------

INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'plan_psector_x_gully', 'id', 1, False);
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'plan_psector_x_gully', 'psector_id', 4, False);
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'plan_psector_x_gully', 'link_geom', 8, False);
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'plan_psector_x_gully', 'vnode_geom', 9, False);

