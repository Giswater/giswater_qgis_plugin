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

UPDATE config_param_system SET isdeprecated = false where isdeprecated is null;

INSERT INTO audit_cat_param_user (id, formname, descript, sys_role_id, idval, label, dv_querytext, dv_parent_id, isenabled, layout_order, project_type, 
isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, widgettype, ismandatory, widgetcontrols, 
vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, isdeprecated) 
VALUES ('profile_stylesheet', 'hidden', 'Parameter to customize stylesheet for profile tool', 'role_om', NULL, 'Profile stylesheet', NULL, NULL, true, 10, 'utils', 
false, NULL, NULL, NULL,  null, 'json', 'linetext', true, NULL, 
'{"guitartext":{"color":"black", "italic":true, "bold":true},"legendtext":{"color":"black", "italic":true, "bold":true},"scaletext":{"color":"black", "height":10, "italic":true, "bold":true},
"ground":{"color":"black", "width":0.2}, "infra":{"color":"black", "width":0.2}, "guitar":{"color":"black", "width":0.2}, "estimated":{"color":"black", "width":0.2}}'::json, 
'lyt_om', true, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;
