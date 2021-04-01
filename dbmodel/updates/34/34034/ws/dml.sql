/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/22
UPDATE sys_table SET notify_action  = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["inp_pump_additional", "inp_curve","inp_curve_value","v_edit_inp_valve","v_edit_inp_tank","v_edit_inp_pump"]}]' 
WHERE id  = 'inp_curve';

-- 2021/03/23
UPDATE config_form_fields SET dv_querytext = 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL' WHERE formname = 'new_dma';
UPDATE config_form_fields SET widgettype = 'text' WHERE widgettype ='spinbox' and formtype  ='form_feature';
UPDATE config_form_fields SET widgettype = 'text' WHERE columnname ='to_arc' and formtype  ='form_feature';
UPDATE config_form_fields set widgetcontrols = '{"setQgisMultiline":false}' WHERE widgetcontrols IS NULL AND formtype = 'form_feature' AND widgettype = 'text';

UPDATE cat_feature_node SET num_arcs = 9 WHERE man_table = 'man_tank';

-- 2021/03/30
UPDATE om_mincut_cat_type SET descript=id WHERE descript IS NULL;

-- 2021/04/01
INSERT INTO config_param_system (parameter, value, descript, isenabled, project_type) VALUES(
'epa_valve_vdefault_tcv', 
'{"catfeatureId":["SHUTOFF_VALVE", "FL_CONTR_VALVE"], "vdefault":{"valv_type":"TCV", "coef_loss":0.02, "minorloss":0.02, "status":"OPEN"}}', 
'Vdefault values for epa-tcv-valves. This parameter must be according the epa_default definition for all valves', FALSE, 'ws')
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system (parameter, value, descript, isenabled, project_type) VALUES(
'epa_valve_vdefault_prv', 
'{"catfeatureId":["PR_REDUC_VALVE"], "vdefault":{"valv_type":"PRV", "minorloss":0.02, "status":"ACTIVE"}}', 
'Vdefault values for epa-prv-valves. This parameter must be according the epa_default definition for all valves', FALSE, 'ws')
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system (parameter, value, descript, isenabled, project_type, standardvalue) VALUES(
'epa_shutoffvalve', 'SHORTPIPE', 
'On the fly transformation for shutoff-valves. This parameter must be according the epa_default definition for shutoff valves on cat_feature_node table (SHORPIPE or VALVE)', FALSE, 'ws', 'SHORTPIPE')
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system (parameter, value, descript, isenabled, project_type, standardvalue) VALUES(
'epa_patterns', '{"ceateNewPatternWhenNewDma":true}', 
'Configure variables for vdefault values on pattern_id for dma table among others',FALSE, 'ws','{"ceateNewPatternWhenNewDma":false}')
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system (parameter, value, descript, standardvalue, isenabled, project_type) VALUES(
'epa_automatic_man2inp_values', 
'{"status":false, "values":[
{"source":{"table":"ve_node_deposito", "column":"hmax"}, "target":{"table":"inp_tank", "column":"maxlevel", "idname":"node_id"}}, 
{"source":{"table":"ve_node_valvula_reductora_pres", "column":"press_exit"}, "target":{"table":"inp_valve", "column":"pressure", "idname":"node_id"}}]}',
'Before trigger go2epa, automatic loop updating values on inp tables',
'{"status":false, "values":[
{"source":{"table":"ve_node_deposito", "column":"hmax"}, "target":{"table":"inp_tank", "column":"maxlevel", "idname":"node_id"}}, 
{"source":{"table":"ve_node_valvula_reductora_pres", "column":"press_exit"}, "target":{"table":"inp_valve", "column":"pressure", "idname":"node_id"}}]}'
, FALSE, 'ws')
ON CONFLICT (parameter) DO NOTHING;
