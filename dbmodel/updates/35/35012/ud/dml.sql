/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/08/19
INSERT INTO inp_typevalue VALUES ('inp_options_networkmode', '1', '1D SWMM');
INSERT INTO inp_typevalue VALUES ('inp_options_networkmode', '2', '1D/2D SWMM-IBER');

INSERT INTO sys_param_user(id, formname, descript, sys_role,  label, dv_querytext, isenabled, layoutorder, project_type, isparent, vdefault, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, epaversion)
VALUES ('inp_options_networkmode', 'epaoptions', 'Export geometry mode: 1D SWMM , 1D/2D coupled model (SWMM-IBER)', 'role_epa', 'Network geometry generator:',
'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_options_networkmode''', TRUE, 0, 'ud', FALSE, '1', FALSE, 'text','combo', TRUE, 
'lyt_general_1',TRUE, '{"from":"5.0.022", "to":null,"language":"english"}') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function VALUES (3070, 'gw_fct_pg2epa_vnodetrimarcs', 'ud', 'function', 'text', 'json', 'Function to trim arcs using gullies', 'role_epa')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function VALUES (3072, 'gw_trg_edit_inp_gully', 'ud', 'trigger function', null, null, 'role_epa')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_gully', 'Table to manage gullies on epa', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('temp_gully', 'Table to manage gullies on epa exportaiton process', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_gully', 'Editable view to manage gullies on epa', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_fprocess VALUES (141,'vi_gully', '[GULLY]', NULL, 99)
ON CONFLICT (fid, tablename, target) DO NOTHING;

UPDATE sys_table SET id = 'inp_demand' WHERE id = 'inp_dscenario_demand';
UPDATE sys_table SET id = 'v_edit_inp_demand' WHERE id = 'v_edit_inp_dscenario_demand';

--2021/08/30
UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"lidco_id","featureType":["v_edit_inp_lid_usage"]}]'
WHERE id='inp_lid_control';

DELETE FROM sys_param_user WHERE project_type='ws';