/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25

DELETE FROM sys_function WHERE id = 2128;


INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('plan_typevalue', 'result_type', 'plan_result_cat', 'result_type');

INSERT INTO config_typevalue VALUES ('formtemplate_typevalue','visit','visit','visit');
INSERT INTO config_typevalue VALUES ('formtemplate_typevalue','visit_class','visit_class','visitClass');

INSERT INTO config_info_layer VALUES ('v_edit_om_visit',FALSE,NULL,TRUE,'v_edit_om_visit','visit','Visit',10);

INSERT INTO config_info_layer_x_type  VALUES ('v_edit_om_visit', 1, 'v_edit_om_visit');


INSERT INTO om_typevalue VALUES ('profile_papersize','0','CUSTOM',null);
INSERT INTO om_typevalue VALUES ('profile_papersize','1','DIN A5 - 210x148',null,'{"xdim":210, "ydim":148}');
INSERT INTO om_typevalue VALUES ('profile_papersize','2','DIN A4 - 297x210',null,'{"xdim":297, "ydim":210}');
INSERT INTO om_typevalue VALUES ('profile_papersize','3','DIN A3 - 420x297',null,'{"xdim":420, "ydim":297}');
INSERT INTO om_typevalue VALUES ('profile_papersize','4','DIN A2 - 594x420',null,'{"xdim":594, "ydim":420}');
INSERT INTO om_typevalue VALUES ('profile_papersize','5','DIN A1 - 840x594',null,'{"xdim":840, "ydim":594}');


INSERT INTO config_param_system VALUES ('basic_selector_explfrommuni', '{"selector":"selector_expl", "selector_id":"expl_id"}', NULL, 'Select which label to display for selectors', 
'Selector labels:',null,  null, TRUE, null, 'utils', NULL, FALSE, 'json', null, null, null, null, null, null, null, null, null, null, false);

-- rename tables
ALTER TABLE inp_curve RENAME TO inp_curve_value;
ALTER TABLE inp_curve_id RENAME TO inp_curve;

-- update data metatables
UPDATE sys_table set id = 'inp_curve_value' where 'inp_curve', sys_sequence = null, sys_sequence_field = null;
UPDATE sys_table set id = 'inp_curve' where 'inp_curve_id';

UPDATE config_form_fields SET formname = 'inp_curve_value' WHERE formname = 'inp_curve';
UPDATE config_form_fields SET formname = 'inp_curve' WHERE formname = 'inp_curve_id';

UPDATE sys_foreignkey SET target_table = 'inp_curve_value' WHERE target_table = 'inp_curve';
UPDATE sys_foreignkey SET target_table = 'inp_curve' WHERE target_table = 'inp_curve_id';

UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'sys_role_id', 'sys_role') where dv_querytext like '%sys_role_id%';

DELETE FROM sys_message WHERE id IN (0,1,2,3,999);

INSERT INTO sys_process VALUES (248, 'Daily update', 'utils');
