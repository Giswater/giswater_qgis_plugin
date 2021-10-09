/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/10/05
UPDATE arc SET inverted_slope = FALSE WHERE inverted_slope IS NULL;

DELETE FROM sys_param_user WHERE id = 'inp_scenario_dwf';
DELETE FROM sys_param_user WHERE id = 'inp_scenario_hydrology';

DELETE FROM config_param_user WHERE parameter = 'inp_scenario_dwf';
DELETE FROM config_param_user WHERE parameter = 'inp_scenario_hydrology';

INSERT INTO sys_fprocess VALUES (398, 'Copy EPA hydrology values)', 'ud') ON CONFLICT (fid) DO NOTHING;
INSERT INTO sys_fprocess VALUES (399, 'Copy EPA DWF values)', 'ud') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES ('3100', 'gw_fct_manage_hydrology_values', 'ud', 'function','json', 'json', 
'Function to manage values of defined target dwf catalog (delete or copy from another one). It works with all ojects linked with hydrology catalog (Subcatchment, Lids, Loadings, Coverages and Groundwater', 'role_epa', NULL) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES ('3102', 'gw_fct_manage_dwf_values', 'ud', 'function','json', 'json', 
'Function to manage values of defined target dwf catalog (insert, delete or copy from another one). It works with dwf table', 'role_epa', NULL) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3100,'Manage Hydrology values', '{"featureType":[]}', 
'[{"widgetname":"target", "label":"Target:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT distinct(hydrology_id) as id, name as idval FROM cat_hydrology WHERE active IS TRUE", "layoutname":"grl_option_parameters", "layoutorder":1, "selectedId":""},
  {"widgetname":"sector", "label":"Sector:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT sector_id AS id, name as idval FROM sector JOIN selector_sector USING (sector_id) WHERE cur_user = current_user", "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":"$userSector"},
  {"widgetname":"action", "label":"Action:", "widgettype":"combo", "datatype":"text", "comboIds":["DELETE-COPY", "KEEP-COPY", "DELETE-ONLY"], "comboNames":["DELETE & COPY", "KEEP & COPY", "ONLY DELETE"], "layoutname":"grl_option_parameters","layoutorder":3, "selectedId":"DELETE-ONLY"},
  {"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT distinct(hydrology_id) as id, name as idval FROM cat_hydrology WHERE active IS TRUE", "layoutname":"grl_option_parameters", "layoutorder":4, "selectedId":"$userHydrology"}
 
  ]', NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3102,'Manage Dwf values', '{"featureType":[]}', 
'[
  {"widgetname":"target", "label":"Target Scenario:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, idval FROM cat_dwf_scenario c WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"$userDwf"},
  {"widgetname":"sector", "label":"Sector:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT sector_id AS id, name as idval FROM sector JOIN selector_sector USING (sector_id) WHERE cur_user = current_user", "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":"$userSector"},
  {"widgetname":"action", "label":"Action:", "widgettype":"combo", "datatype":"text", "comboIds":["INSERT-ONLY", "DELETE-COPY", "KEEP-COPY", "DELETE-ONLY"], "comboNames":["ONLY INSERT", "DELETE & COPY", "KEEP & COPY", "ONLY DELETE"], "layoutname":"grl_option_parameters","layoutorder":3, "selectedId":"INSERT-ONLY"},
  {"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, idval FROM cat_dwf_scenario c WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":4, "selectedId":""}
  ]', NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess VALUES (401, 'Y0 higger than ymax on nodes)', 'ud')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_param_system (parameter, value, descript, standardvalue, isenabled, project_type) VALUES(
'epa_automatic_man2inp_values', 
'{"status":false, "values":[
{"sourceTable":"ve_node_sewer_storage", "query":"UPDATE inp_storage t SET y0 = min_height FROM ve_node_sewer_storage s "}]}',
'Before insert - update of any feature, automatic update of columns on inp tables from columns on man table',
'{"status":false}'
, FALSE, 'ws')
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_inp_lid_usage','form_feature', 'main', 'hydrology_id',null,null,'string', 'combo','hydrology_id','Hydrology identifier', false,
false, true, false, false, 'SELECT DISTINCT (hydrology_id) AS id,  name  AS idval FROM cat_hydrology WHERE hydrology_id IS NOT NULL',true,
null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

-- update 
UPDATE inp_lid_usage SET hydrology_id = value::integer FROM config_param_user WHERE parameter = 'inp_options_hydrology_scenario';
UPDATE inp_loadings_pol_x_subc SET hydrology_id = value::integer FROM config_param_user WHERE parameter = 'inp_options_hydrology_scenario';
UPDATE inp_groundwater SET hydrology_id = value::integer FROM config_param_user WHERE parameter = 'inp_options_hydrology_scenario';
UPDATE inp_coverage_land_x_subc SET hydrology_id = value::integer FROM config_param_user WHERE parameter = 'inp_options_hydrology_scenario';
UPDATE inp_subcatchment SET hydrology_id = value::integer FROM config_param_user WHERE parameter = 'inp_options_hydrology_scenario' AND hydrology_id IS NULL; 
