/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-----------------------
-- 24/09/2019
-----------------------

INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'plan_psector_x_arc', 'id', 1, False);
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'plan_psector_x_arc', 'psector_id', 3, False);
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'plan_psector_x_connec', 'id', 1, False);
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'plan_psector_x_connec', 'psector_id', 4, False);
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'plan_psector_x_connec', 'link_geom', 8, False);
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'plan_psector_x_connec', 'vnode_geom', 9, False);
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'plan_psector_x_node', 'id', 1, False);
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'plan_psector_x_node', 'psector_id', 3, False);
-----------------------
-- 26/09/2019
-----------------------
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'v_edit_plan_psector_x_other', 'id', 1, False);
INSERT INTO config_client_forms (location_type, project_type, table_id, column_id, column_index, status) VALUES('new psector', 'utils', 'v_edit_plan_psector_x_other', 'psector_id', 2, False);

