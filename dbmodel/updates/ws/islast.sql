/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- 2018/09/28
INSERT INTO audit_cat_table VALUES ('v_anl_mincut_init_point', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);


-- 2018/10/05
UPDATE audit_cat_table SET sys_role_id='role_om' WHERE id='v_anl_mincut_result_cat';

INSERT INTO audit_cat_table VALUES ('v_edit_field_valve', 'System', 'Selector of hydrometers', 'role_basic', 0, NULL, NULL, 0, NULL,'selector_hydrometer_id_seq', 'id');

INSERT INTO audit_cat_error values('3012','The position value is bigger than the full length of the arc. ', 'Please review your data.',2,TRUE,'utils');
INSERT INTO audit_cat_error values('3014','The position id is not node_1 or node_2 of selected arc.', 'Please review your data.',2,TRUE,'utils');

INSERT INTO audit_cat_function VALUES (2498, 'gw_trg_visit_event_update_xy', 'om', NULL, 'p_event_id', 'Enables the posibility to update the xcoord, ,ycoord columns using position_id and position_value.', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2500, 'gw_trg_edit_field_node', 'edit', NULL, 'p_node_id', 'To update data on field', NULL, NULL, NULL);
INSERT INTO audit_cat_function VALUES (2502, 'gw_fct_utils_role_permisions', 'amin', NULL, '', 'To role permissionf of the schema', NULL, NULL, NULL);



