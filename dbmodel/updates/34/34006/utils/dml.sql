/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/03/28
INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, isdeprecated) 
VALUES ('om_profile', 'O&M', 'Table to store profiles', 'role_om', 0, 'role_om', false)
ON CONFLICT (id) DO NOTHING;

UPDATE audit_cat_table SET isdeprecated = true 
WHERE id IN ('anl_arc_profile_value');

UPDATE audit_cat_table SET id  ='ext_rtc_dma_period' WHERE id = 'ext_rtc_scada_dma_period';

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (122,'Profile analysis','om','utils') 
ON CONFLICT (id) DO NOTHING;

--2002/03/11
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2832, 'gw_fct_getprofilevalues', 'utils', 'function', null, null, null,'Function to manage profile values', 'role_om',
false, false, null, false) 
ON CONFLICT (id) DO NOTHING;

-- deprecate config_param_system variables
UPDATE config_param_system SET isdeprecated = true where parameter in
('top_elev_vd','ymax_vd','sys_elev_vd','geom1_vd','z1_vd','z2_vd','cat_geom1_vd','sys_elev1_vd','sys_elev2_vd','y1_vd','y2_vd','slope_vd');

UPDATE config_param_system SET isdeprecated = true where parameter in
('expl_layer','expl_field_code','expl_field_name','scale_zoom','street_layer','street_field_code','street_field_name','portal_layer',
'portal_field_code','portal_field_number','portal_field_postal','street_field_expl');

INSERT INTO audit_cat_param_user (id, formname, descript, sys_role_id, idval, label, dv_querytext, dv_parent_id, isenabled, layout_order, project_type, 
isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, widgettype, ismandatory, widgetcontrols, 
vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, isdeprecated) 
VALUES ('profile_stylesheet', 'hidden', 'Parameter to customize stylesheet for profile tool', 'role_om', NULL, 'Profile stylesheet', NULL, NULL, true, 10, 'utils', 
false, NULL, NULL, NULL,  null, 'json', 'linetext', true, NULL, 
'{"guitartext":{"color":"black", "italic":true, "bold":true},"legendtext":{"color":"black", "italic":true, "bold":true},"scaletext":{"color":"black", "height":10, "italic":true, "bold":true},
"ground":{"color":"black", "width":0.2}, "infra":{"color":"black", "width":0.2}, "guitar":{"color":"black", "width":0.2}, "estimated":{"color":"black", "width":0.2}}'::json, 
'lyt_om', true, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;


-- update values on config_param_system and audit_cat_param_user

UPDATE config_param_system SET isdeprecated = false where isdeprecated is null;
UPDATE config_param_system SET project_type = 'utils' where project_type is null;
UPDATE config_param_system SET context = 'api', datatype = 'text', descript='Api Version', label='Api Version' where parameter = 'ApiVersion';
UPDATE config_param_system SET dv_isparent = null, isautoupdate = null, datatype = 'json'  where parameter = 'edit_replace_doc_folderpath';
UPDATE config_param_system SET ismandatory = false where layoutname is  not null and ismandatory is null;
UPDATE config_param_system SET dv_isparent = false where layoutname is  not null and dv_isparent is null;
UPDATE config_param_system SET isautoupdate = false where layoutname is  not null and isautoupdate is null;
UPDATE config_param_system SET datatype = 'json' where parameter  IN ('api_search_muni', 'api_search_gully');
UPDATE config_param_system SET widgettype = null, ismandatory = null, layout_order = null WHERE layoutname is null;
UPDATE config_param_system SET context = 'api' where parameter  IN ('api_search_exploitation');
UPDATE config_param_system SET context = 'api_search', descript = 'Search configuration parameteres' 
where context IN ('api_search_network', 'api_search_workcat', 'api_search_adress', 'api_search_hydrometer', 'api_search_visit', 'api_search_psector', 'api');
UPDATE config_param_system SET descript = 'Variable to configure prefix on subcathcments' where parameter = 'inp_subc_seq_id_prefix';
UPDATE config_param_system SET isenabled = true where isenabled is null;

UPDATE audit_cat_param_user SET project_type = 'utils' where project_type is null;
UPDATE audit_cat_param_user SET isenabled = true where isenabled is null;
UPDATE audit_cat_param_user SET isdeprecated = false where isdeprecated is null;
UPDATE audit_cat_param_user SET project_type = 'utils' where project_type is null;
UPDATE audit_cat_param_user SET isenabled = true where isenabled is null;

-- insert triggers into audit_cat_function in order to preserve id (created in 3.1.132)

INSERT INTO audit_cat_function VALUES (2834, 'gw_trg_edit_team_x_user', 'utils', 'function trigger', NULL, NULL, NULL, 'Makes editable v_om_user_x_team', 'role_om', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function VALUES (2836, 'gw_trg_edit_team_x_visitclass', 'utils', 'function trigger', NULL, NULL, NULL, 'Makes editable v_om_team_x_visitclass', 'role_om', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function VALUES (2838, 'gw_trg_edit_cat_team', 'utils', 'function trigger', NULL, NULL, NULL, 'Makes editable v_edit_cat_team', 'role_om', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function VALUES (2840, 'gw_trg_edit_cat_vehicle', 'utils', 'function trigger', NULL, NULL, NULL, 'Makes editable v_ext_cat_vehicle', 'role_om', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function VALUES (2842, 'gw_trg_edit_lot_x_user', 'utils', 'function trigger', NULL, NULL, NULL, 'Makes editable v_om_lot_x_user', 'role_om', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function VALUES (2844, 'gw_trg_edit_team_x_vehicle', 'utils', 'function trigger', NULL, NULL, NULL, 'Makes editable v_om_team_x_vehicle', 'role_om', false) 
ON CONFLICT (id) DO NOTHING;

--2020/04/01

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (123,'Check arc drawing direction','om', 'utils') ON CONFLICT (id) DO NOTHING;

--2020/04/06
INSERT INTO config_param_system (parameter, value, context, descript, label, isenabled, layout_order, project_type, datatype, widgettype, ismandatory, isdeprecated)
VALUES ('custom_form_param', '{"custom_form_tab_labels":[{"index":"0", "text":"Main data"}, {"index":"1", "text":"Additional data"}]}',
'edit', 'Custom form tab labels', 'Used to manage labels on diferent tabs in custom form Data tab', FALSE, null, 'utils', 'json', 'linetext', false, false) 
ON CONFLICT (parameter) DO NOTHING;

