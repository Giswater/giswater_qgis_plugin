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
INSERT INTO audit_cat_table VALUES ('v_edit_field_valve', 'System', 'Selector of hydrometers', 'role_basic', 0, NULL, NULL, 0, NULL,'selector_hydrometer_id_seq', 'node_id');
INSERT INTO audit_cat_error values('3012','The position value is bigger than the full length of the arc. ', 'Please review your data.',2,TRUE,'utils');
INSERT INTO audit_cat_error values('3014','The position id is not node_1 or node_2 of selected arc.', 'Please review your data.',2,TRUE,'utils');

--2018/10/22
UPDATE audit_cat_table SET qgis_role_id='role_om' where id='v_ui_anl_mincut_result_cat';


