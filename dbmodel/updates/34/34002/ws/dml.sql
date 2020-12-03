/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/01/30
DELETE FROM config_param_system WHERE parameter = 'inp_fast_buildup';

INSERT INTO audit_cat_param_user VALUES 
('inp_options_buildup_supply', 'hidden_value', 'Parameters for supply buildup epanets models', 'role_epa', NULL, NULL, 'supply options for buildup model', NULL, NULL, true, NULL, NULL, 'ws', false, NULL, NULL, NULL, 
false, 'text', 'linetext', true, null,
'{"node":{"nullElevBuffer":100, "ceroElevBuffer":100}, "pipe":{"diameter":"160"}, "junction":{"defaultDemand":"0.001"}, "tank":{"distVirtualReservoir":0.01}, "pressGroup":{"status":"ACTIVE", "forceStatus":"ACTIVE", "defaultCurve":"IM20"}, "pumpStation":{"status":"CLOSED", "forceStatus":"CLOSED"}, "PRV":{"status":"ACTIVE", "forceStatus":"ACTIVE"}, "reservoir":{"switch2Junction":["ETAP", "POU", "CAPTACIO"]}}',
NULL, NULL, TRUE, NULL, NULL, NULL, NULL, FALSE)
ON conflict (id) DO NOTHING;


INSERT INTO audit_cat_param_user VALUES 
('inp_options_buildup_transport', 'hidden_value', 'Parameters for transport buildup epanets models', 'role_epa', NULL, NULL, 'Tansport options for buildup model', NULL, NULL, true, NULL, NULL, 'ws', false, NULL, NULL, NULL, 
false, 'text', 'linetext', true, null,
null,
NULL, NULL, TRUE, NULL, NULL, NULL, NULL, FALSE)
ON conflict (id) DO NOTHING;


-- refactor buildup models
UPDATE inp_typevalue SET idval = 'SUPPLY' WHERE typevalue = 'inp_options_buildup_mode' AND id = '1';
UPDATE inp_typevalue SET idval = 'TRANSPORT' WHERE typevalue = 'inp_options_buildup_mode' AND id = '2';

INSERT INTO inp_typevalue VALUES ('inp_options_buildup_mode', '3', 'TRANSIENT')
ON CONFLICT (typevalue,id) DO NOTHING;

INSERT INTO inp_typevalue VALUES ('inp_options_buildup_mode', '4', 'LOSSES')
ON CONFLICT (typevalue,id) DO NOTHING;

UPDATE audit_cat_function SET function_name = 'gw_fct_pg2epa_buildup_supply', descript ='Function to generate supply models, simplifiyng certain data'
WHERE function_name = 'gw_fct_pg2epa_fast_buildup';

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox)
VALUES (2798, 'gw_fct_pg2epa_advancedsettings', 'utils', 'function','Parameters for advanced user', 'role_epa', false, false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox)
VALUES (2800, 'gw_fct_pg2epa_buildup_transport', 'utils', 'function','Function to generate supply models oriented to manage olumes of water and water quality', 'role_epa', false, false)
ON CONFLICT (id) DO NOTHING;


--2020/03/05
INSERT INTO config_param_system (parameter, value, data_type, context, descript, project_type,  isdeprecated) 
VALUES ('use_fire_code_seq', 'FALSE', 'boolean', 'system', 'If TRUE, when insert a new hydrant with fire_code=NULL this field will be filled with next val of sequence', 'ws', false) ON CONFLICT (parameter) DO NOTHING;



-- 2020/02/27
INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_virtualvalve', 'form', 'id', 12, 'text', 'combo', 'State type', 
NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL' , 
NULL, NULL, 'state',  ' AND value_state_type.state = ', 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_pipe', 'form', 'state_type', 12, 'text', 'combo', 'State type',
NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL' , 
NULL, NULL, 'state',  ' AND value_state_type.state = ', 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;