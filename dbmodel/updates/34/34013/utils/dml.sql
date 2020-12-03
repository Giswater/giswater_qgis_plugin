/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/06/08
DELETE FROM sys_table WHERE id IN ('cat_arc_class', 'cat_arc_class_cat', 'cat_arc_class_type');

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


INSERT INTO config_param_system VALUES ('basic_selector_explfrommuni', '{"selector":"selector_expl", "selector_id":"expl_id"}', 'Select which label to display for selectors', 
'Selector labels:',null,  null, TRUE, null, 'utils', NULL, FALSE, 'json', null, null, null, null, null, null, null, null, null, false);

-- update data metatables
UPDATE sys_table set id = 'inp_curve_value' where id ='inp_curve';
UPDATE sys_table set id = 'inp_curve' where id ='inp_curve_id';

UPDATE config_form_fields SET formname = 'inp_curve_value' WHERE formname = 'inp_curve';
UPDATE config_form_fields SET formname = 'inp_curve' WHERE formname = 'inp_curve_id';

UPDATE sys_foreignkey SET target_table = 'inp_curve_value' WHERE target_table = 'inp_curve';
UPDATE sys_foreignkey SET target_table = 'inp_curve' WHERE target_table = 'inp_curve_id';

UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'sys_role_id', 'sys_role') where dv_querytext like '%sys_role_id%';

DELETE FROM sys_message WHERE id IN (0,1,2,3,999);

INSERT INTO sys_fprocess VALUES (248, 'Daily update', 'utils');

DELETE FROM sys_function WHERE function_name = 'gw_fct_admin_schema_dropdreprecated_rel';

DELETE FROM sys_table WHERE id IN('om_psector','om_psector_cat_type','om_psector_selector', 'om_psector_x_arc', 'om_psector_x_node', 'om_psector_x_other');

DELETE FROM sys_table WHERE id IN('v_om_current_psector','v_om_current_psector_budget','v_om_current_psector_budget_detail_rec', 'v_om_current_psector_budget_detail_reh');


DELETE FROM sys_table WHERE id IN('inp_controls_x_node');

UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json,'feature_type','arc'::text) where parameter = 'basic_search_network_arc';
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json,'feature_type','node'::text) where parameter = 'basic_search_network_node';
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json,'feature_type','connec'::text) where parameter = 'basic_search_network_connec';
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json,'feature_type','gully'::text) where parameter = 'basic_search_network_gully';
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json,'feature_type','visit'::text) where parameter = 'basic_search_network_visit';
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json,'feature_type','element'::text) where parameter = 'basic_search_network_element';


DELETE FROM config_param_system WHERE parameter IN('cat_geom1_vd','expl_field_code','expl_field_name','expl_layer','geom1_vd','portal_field_code','portal_field_number',
'portal_field_postal','portal_layer','scale_zoom','slope_vd','street_field_code','street_field_expl', 'street_field_name', 'street_layer', 'sys_elev_vd','sys_elev1_vd',
'sys_elev2_vd','top_elev_vd','y1_vd','y2_vd','ymax_vd','z1_vd','z2_vd');


DELETE FROM sys_param_user WHERE id IN('parameter_vdefault', 'om_param_type_vdefault');

UPDATE sys_param_user SET id ='edit_connec_category_vdefault' WHERE id = 'connec_category_vdefault';
UPDATE sys_param_user SET id ='edit_connec_fluid_vdefault' WHERE id = 'connec_fluid_vdefault';
UPDATE sys_param_user SET id ='edit_connec_function_vdefault' WHERE id = 'connec_function_vdefault';
UPDATE sys_param_user SET id ='edit_connec_location_vdefault' WHERE id = 'connec_location_vdefault';
UPDATE sys_param_user SET id ='edit_presszone_vdefault' WHERE id = 'presszone_vdefault';
UPDATE sys_param_user SET id ='edit_pavement_vdefault' WHERE id = 'pavement_vdefault';
UPDATE sys_param_user SET id ='edit_connec_location_vdefault' WHERE id = 'connec_location_vdefault';
UPDATE sys_param_user SET id ='edit_connecarccat_vdefault' WHERE id = 'connecarccat_vdefault';


UPDATE config_param_user SET parameter ='edit_connec_category_vdefault' WHERE parameter = 'connec_category_vdefault';
UPDATE config_param_user SET parameter ='edit_connec_fluparameter_vdefault' WHERE parameter = 'connec_fluparameter_vdefault';
UPDATE config_param_user SET parameter ='edit_connec_function_vdefault' WHERE parameter = 'connec_function_vdefault';
UPDATE config_param_user SET parameter ='edit_connec_location_vdefault' WHERE parameter = 'connec_location_vdefault';
UPDATE config_param_user SET parameter ='edit_presszone_vdefault' WHERE parameter = 'presszone_vdefault';
UPDATE config_param_user SET parameter ='edit_pavement_vdefault' WHERE parameter = 'pavement_vdefault';
UPDATE config_param_user SET parameter ='edit_connec_location_vdefault' WHERE parameter = 'connec_location_vdefault';
UPDATE config_param_user SET parameter ='edit_connecarccat_vdefault' WHERE parameter = 'connecarccat_vdefault';

UPDATE sys_param_user SET formname ='dynamic' WHERE formname = 'dynamic_param';
UPDATE sys_param_user SET formname ='hidden' WHERE formname = 'hidden_param';

UPDATE config_param_system SET value= '{"SECTOR":"Disable", "DMA":"Stylesheet", "PRESSZONE":"Random", "DQA":"Random", "MINSECTOR":"Random"}'
WHERE parameter = 'utils_grafanalytics_dynamic_symbology';


INSERT INTO config_toolbox VALUES (2890,'Reconstruction cost & amortization values',TRUE,'{"featureType":[]}',
'[{"widgetname":"resultName", "label":"Result name:", "widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layoutorder":1, "placeholder":"result name" ,"value":""},
{"widgetname":"step", "label":"Step:", "widgettype":"combo", "datatype":"text", "layoutname":"grl_option_parameters","layoutorder":2,"comboIds":["1","2"],
"comboNames":["STEP-1:RECONSTRUCTION COST", "STEP-2:AMORTIZATION VALUES"], "selectedId":"1"}, 
{"widgetname":"coefficient", "label":"Coefficient:", "widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layoutorder":3, "placeholder":"1", "value":""},
{"widgetname":"descript", "label":"Description:", "widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layoutorder":4, "placeholder":"description" ,"ismandatory":false, "value":""}]');
   
UPDATE sys_function SET descript = 'Function to calculate reconstruction cost and amortization values. Process need to be executed in two steps. 
First step calculates reconstruction cost based on prices tables, lengths and crossection values.
With reconstruction cost calculated,it is mandatory before to execute second step to fill builtcost and acoeff columns on plan_rec_result_* tables for specific result. 
After that, second step may be executed wich will calculate amortization values like aperiod, arate, amortized and pending amounts.', input_params='json', return_type = 'json' WHERE id = 2890;
