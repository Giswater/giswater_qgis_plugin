/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/07/26

UPDATE sys_function SET project_type='utils' WHERE id=1346;

--2022/07/28

INSERT INTO config_param_system
("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('edit_custom_link', '{"google_maps":false}', 'Allow users to enable custom configurations to fill features ''link'' field', 'Custom link field', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'json', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT (parameter) DO NOTHING;

UPDATE config_param_system c
SET value=gw_fct_json_object_set_key(c.value::json,'fid',a.value) 
FROM (
SELECT value::boolean from config_param_system WHERE "parameter"='edit_feature_usefid_on_linkid'
)a
WHERE parameter = 'edit_custom_link';

DELETE FROM config_param_system WHERE "parameter"='edit_feature_usefid_on_linkid';

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (465, 'Check number of rows in a plan_price table', 'utils',null, 'core', true, 'Check plan-config',null) ON CONFLICT (fid) DO NOTHING;

UPDATE sys_function SET function_name='gw_fct_graphanalytics_downstream' WHERE function_name ='gw_fct_grafanalytics_downstream';
UPDATE sys_function SET function_name='gw_fct_graphanalytics_downstream_recursive' WHERE function_name ='gw_fct_grafanalytics_downstream_recursive';
UPDATE sys_function SET function_name='gw_fct_graphanalytics_upstream' WHERE function_name ='gw_fct_grafanalytics_upstream';
UPDATE sys_function SET function_name='gw_fct_graphanalytics_upstream_recursive' WHERE function_name ='gw_fct_grafanalytics_upstream_recursive';
UPDATE sys_function SET function_name='gw_fct_graphanalytics_minsector' WHERE function_name ='gw_fct_grafanalytics_minsector';
UPDATE sys_function SET function_name='gw_fct_graphanalytics_mincut' WHERE function_name ='gw_fct_grafanalytics_mincut';
UPDATE sys_function SET function_name='gw_fct_graphanalytics_mapzones' WHERE function_name ='gw_fct_grafanalytics_mapzones';
UPDATE sys_function SET function_name='gw_fct_graphanalytics_mincutzones' WHERE function_name ='gw_fct_grafanalytics_mincutzones';
UPDATE sys_function SET function_name='gw_fct_graphanalytics_mapzones_basic' WHERE function_name ='gw_fct_grafanalytics_mapzones_basic';
UPDATE sys_function SET function_name='gw_fct_graphanalytics_mapzones_advanced' WHERE function_name ='gw_fct_grafanalytics_mapzones_advanced';
UPDATE sys_function SET function_name='gw_fct_graphanalytics_flowtrace' WHERE function_name ='gw_fct_grafanalytics_flowtrace';
UPDATE sys_function SET function_name='gw_fct_graphanalytics_check_data' WHERE function_name ='gw_fct_grafanalytics_check_data';
UPDATE sys_function SET function_name='gw_fct_graphanalytics_lrs' WHERE function_name ='gw_fct_grafanalytics_lrs';
UPDATE sys_function SET function_name='gw_fct_graphanalytics_mapzones_config' WHERE function_name ='gw_fct_grafanalytics_mapzones_config';

UPDATE config_toolbox SET alias='Check data for graphanalytics process' WHERE alias='Check data for grafanalytics process';
UPDATE config_toolbox SET inputparams=replace(inputparams::text,'Graf', 'Graph')::json;
UPDATE config_toolbox SET inputparams=replace(inputparams::text,'graf', 'graph')::json;

--2022/08/05
INSERT INTO config_param_system (parameter, value, descript, isenabled, project_type) 
VALUES('utils_use_gw_snapping', 'TRUE', 'Variable to choose if the snapping config is managed by Giswater or not', FALSE, 'utils')
ON CONFLICT (parameter) DO NOTHING;

UPDATE sys_fprocess SET fprocess_type='Check graph-data' WHERE fprocess_type='Check graf-data';
UPDATE sys_fprocess SET fprocess_type='Check graph-config' WHERE fprocess_type='Check graf-config';
UPDATE config_csv SET descript= replace(descript,'graf','graph');

--2022/08/10
INSERT INTO config_info_layer(layer_id, is_parent, tableparent_id, is_editable, formtemplate, headertext, orderby, tableparentepa_id, addparam)
VALUES ('ve_pol_node', false, null, true, 'info_feature', null, 10, null, null) ON CONFLICT (layer_id) DO NOTHING;

INSERT INTO config_info_layer(layer_id, is_parent, tableparent_id, is_editable, formtemplate, headertext, orderby, tableparentepa_id, addparam)
VALUES ('ve_pol_connec', false, null, true, 'info_feature', null, 11, null, null) ON CONFLICT (layer_id) DO NOTHING;

UPDATE config_fprocess SET active = true WHERE active is null;

INSERT INTO config_info_layer(layer_id, is_parent, tableparent_id, is_editable, formtemplate,headertext, orderby, tableparentepa_id, addparam)
VALUES ('v_edit_link', false, null, true, 'info_generic', 'Link',25,null,null) ON CONFLICT (layer_id) DO NOTHING;;

UPDATE config_form_fields SET layoutname='lyt_data_1' WHERE formname='v_edit_link';

UPDATE config_form_fields SET layoutorder=1 WHERE formname='v_edit_link' AND columnname='link_id';
UPDATE config_form_fields SET layoutorder=2 WHERE formname='v_edit_link' AND columnname='feature_type';
UPDATE config_form_fields SET layoutorder=3 WHERE formname='v_edit_link' AND columnname='feature_id';
UPDATE config_form_fields SET layoutorder=4 WHERE formname='v_edit_link' AND columnname='exit_type';
UPDATE config_form_fields SET layoutorder=5 WHERE formname='v_edit_link' AND columnname='exit_id';
UPDATE config_form_fields SET layoutorder=6 WHERE formname='v_edit_link' AND columnname='state';
UPDATE config_form_fields SET layoutorder=7 WHERE formname='v_edit_link' AND columnname='expl_id';
UPDATE config_form_fields SET layoutorder=8 WHERE formname='v_edit_link' AND columnname='macrosector_id';
UPDATE config_form_fields SET layoutorder=9 WHERE formname='v_edit_link' AND columnname='sector_id';
UPDATE config_form_fields SET layoutorder=10 WHERE formname='v_edit_link' AND columnname='macrodma_id';
UPDATE config_form_fields SET layoutorder=11 WHERE formname='v_edit_link' AND columnname='dma_id';
UPDATE config_form_fields SET layoutorder=12 WHERE formname='v_edit_link' AND columnname='gis_length';
UPDATE config_form_fields SET layoutorder=13 WHERE formname='v_edit_link' AND columnname='userdefined_geom';
UPDATE config_form_fields SET layoutorder=14 WHERE formname='v_edit_link' AND columnname='ispsectorgeom';
UPDATE config_form_fields SET layoutorder=15 WHERE formname='v_edit_link' AND columnname='psector_rowid';
