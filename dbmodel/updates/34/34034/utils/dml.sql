/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/26
INSERT INTO sys_table VALUES ('v_plan_psector_budget_arc', 'View to show budget of every arc related to a psector', 'role_basic', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_plan_psector_budget_node', 'View to show budget of every node related to a psector', 'role_basic', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_plan_psector_budget_other', 'View to show budget of other prices related to a psector', 'role_basic', 0) ON CONFLICT (id) DO NOTHING;

--2021/03/30
UPDATE config_form_tableview SET columnindex = 1 WHERE columnname = 'rid' AND tablename ='v_ui_arc_x_relations';
UPDATE config_form_tableview SET columnindex = 2 WHERE columnname = 'arc_id' AND tablename ='v_ui_arc_x_relations';
UPDATE config_form_tableview SET columnindex = 3 WHERE columnname = 'featurecat_id' AND tablename ='v_ui_arc_x_relations';
UPDATE config_form_tableview SET columnindex = 4 WHERE columnname = 'catalog' AND tablename ='v_ui_arc_x_relations';
UPDATE config_form_tableview SET columnindex = 5 WHERE columnname = 'feature_id' AND tablename ='v_ui_arc_x_relations';
UPDATE config_form_tableview SET columnindex = 6 WHERE columnname = 'feature_code' AND tablename ='v_ui_arc_x_relations';
UPDATE config_form_tableview SET columnindex = 7 WHERE columnname = 'sys_type' AND tablename ='v_ui_arc_x_relations';
UPDATE config_form_tableview SET columnindex = 8 WHERE columnname = 'arc_state' AND tablename ='v_ui_arc_x_relations';
UPDATE config_form_tableview SET columnindex = 9 WHERE columnname = 'feature_state' AND tablename ='v_ui_arc_x_relations';
UPDATE config_form_tableview SET columnindex = 10 WHERE columnname = 'x' AND tablename ='v_ui_arc_x_relations';
UPDATE config_form_tableview SET columnindex = 11 WHERE columnname = 'y' AND tablename ='v_ui_arc_x_relations';