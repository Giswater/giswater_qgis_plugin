/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source") 
VALUES('edit_workcat_id_plan', 'config', 'Default value of workcat id plan', 'role_edit', NULL, 'Workcat id plan:', 'SELECT cat_work.id AS id,cat_work.id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, true, 25, 'utils', false, NULL, 'workcat_id_plan', NULL, false, 'string', 'combo', false, NULL, NULL, 'lyt_inventory', true, NULL, NULL, NULL, NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_form_fields(	formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate,  dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields 
		  where layoutname ='lyt_data_2' and formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully') group by formname )
SELECT c.formname, formtype, tabname, 'expl_id2',  'lyt_data_2', lytorder+1, datatype, widgettype, 'Exploitation 2', tooltip, placeholder, ismandatory, false, 
iseditable, isautoupdate,  'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL and expl_id !=0', dv_orderby_id, true, null, null, true
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully') 
AND columnname = 'expl_id'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, false, 
iseditable, isautoupdate,  dv_querytext, dv_orderby_id, dv_isnullvalue,   lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,  hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields join cat_feature on child_layer = formname
		  where layoutname ='lyt_data_2'  group by formname )
SELECT distinct child_layer,formtype, tabname, columnname, 'lyt_data_2', lytorder+1, datatype, widgettype, label, tooltip,  ismandatory, 
isparent, iseditable, isautoupdate, isfilter, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL and expl_id !=0', dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, true
FROM config_form_fields, cat_feature
join lyt on child_layer = formname
WHERE  (config_form_fields.formname ilike 've_node' and columnname = 'expl_id2')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3214, 'gw_trg_link_data', 'utils', 'trigger function', null, null,
'Triggers that fills data related to connect on link table', 'role_edit', null, 'core') ON CONFLICT (id) DO NOTHING;

UPDATE config_toolbox SET  inputparams = 
'[{"widgetname":"configZone", "label":"Configurate zone:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,
"comboIds":["SECTOR"], 
"comboNames":["SECTOR"]}]', active = true WHERE id=3204;


INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3218, 'gw_fct_getreport', 'utils', 'function', 'json', 'json', 'Function that returns the form and data of a report tool' , 'role_edit', null, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3220, 'gw_fct_getstyle', 'utils', 'function', 'json', 'json', 'Function that sets style defined o sys_style table' , 'role_basic', null, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3222, 'gw_fct_vnode_repair', 'utils', 'function', 'json', 'json', 'Function that inserts missing vnodes.' , 'role_edit', null, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(	id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3228, 'gw_fct_anl_node_proximity', 'utils', 'function', 'json', 'json', 'Function that analysis the distyance between two nodes.', 'role_edit', null, 'core')
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_function WHERE function_name = 'gw_trg_feature_border';

INSERT INTO sys_table(id, descript, sys_role, source)
VALUES ('v_expl_arc', 'View that filters arcs by exploitation', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, source)
VALUES ('v_state_link', 'View that filters links by state and exploitation', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, source)
VALUES ('v_state_link_connec', 'View that filters links related to connecs by state and exploitation', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;
	
update sys_table SET id = 'v_plan_psector_budget' WHERE id = 'v_plan_current_psector_budget';
update sys_table SET id = 'v_plan_psector_budget_detail' WHERE id = 'v_plan_current_psector_budget_detail';