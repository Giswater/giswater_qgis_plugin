/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/01/20
insert into audit_cat_function (id,function_name, project_type, function_type,descript, sys_role_id, isdeprecated, istoolbox, 
       isparametric)
VALUES (2794,'gw_fct_audit_check_project','utils','function','Functions that controls the qgis project',
'role_basic', false,false,false);

--2020/01/23
INSERT INTO audit_cat_param_user (id, formname, description, sys_role_id, qgis_message, idval, 
       label, dv_querytext, dv_parent_id, isenabled, layout_id, layout_order, 
       project_type, isparent, dv_querytext_filterc, feature_field_id, 
       feature_dv_parent_value, isautoupdate, datatype, widgettype, 
       ismandatory, widgetcontrols, vdefault, layoutname, reg_exp, iseditable, 
       dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, isdeprecated)
VALUES ('audit_project_epa_result', 'config', 'Id of EPA results to analyze when audit check project function', 'role_epa', 
NULL, NULL, 'EPA result to check database on load project', NULL, NULL, true, 8, 14, 'utils', false, NULL, NULL, NULL, 
false, 'string', 'text', true, NULL, 'gw_check_project', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;

INSERT INTO audit_cat_param_user (id, formname, description, sys_role_id, qgis_message, idval, 
       label, dv_querytext, dv_parent_id, isenabled, layout_id, layout_order, 
       project_type, isparent, dv_querytext_filterc, feature_field_id, 
       feature_dv_parent_value, isautoupdate, datatype, widgettype, 
       ismandatory, widgetcontrols, vdefault, layoutname, reg_exp, iseditable, 
       dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, isdeprecated)
VALUES ('audit_project_plan_result', 'config', 'Id of PLAN results to analyze when audit check project function', 
'role_master', NULL, NULL, 'PLAN result to check database on load project', NULL, NULL, true, 8, 15, 'utils', false, NULL, 
NULL, NULL, false, 'string', 'text', true, NULL, 'gw_check_project', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;


UPDATE audit_cat_param_user set  layout_order=15  where id='audit_project_epa_result';
UPDATE audit_cat_param_user set layout_order=16  where id='audit_project_plan_result';


INSERT INTO audit_cat_param_user(id, formname, description, sys_role_id, isenabled,
project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, vdefault, isdeprecated)
VALUES ('edit_disable_statetopocontrol','dynamic_param','If true, topocontrol is executed without state definition. This parameter is used for trg_topocontrol_node when ficticius arcs are inserted due a misterious bug of postgres who does not recongize the new node over the old one',
'role_edit', true, 'utils',false,false,'boolean',null,true,false,false);

INSERT INTO audit_cat_function(id, function_name, function_type, project_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2796, 'gw_api_getselectors', 'utils', 'function', 'Function used for api to get values of user selectors from database', 
'role_basic', false, false, false);

