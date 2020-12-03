/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/02/13
INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (114, 'Arc fusion', 'edit', 'utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (115, 'Test functions', 'admin', 'utils') ON CONFLICT (id) DO NOTHING;

UPDATE audit_cat_function
set sample_query = '{"WS":{"client":{"device":4, "infoType":1, "lang":"ES"},"data":{"iterative":"off", "resultId":"test1", "useNetworkGeom":"false", "dumpSubcatch":"true"}},
"UD":{"client":{"device":4, "infoType":1, "lang":"ES"},"data":{"iterative":"off", "resultId":"test1", "useNetworkGeom":"false", "dumpSubcatch":"true"}}}'
where function_name='gw_fct_pg2epa_main';

UPDATE audit_cat_function
set sample_query = '{"WS":{"client":{"device":4, "infoType":1, "lang":"ES"}, "feature":{"id":["node_id"]},"data":{}},
"UD":{"client":{"device":4, "infoType":1, "lang":"ES"}, "feature":{"id":["node_id"]},"data":{}}}'
where function_name='gw_fct_arc_divide';

UPDATE audit_cat_function
set sample_query = '{"WS":{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "version":"3.3.019", "fprocesscat_id":1}},"UD":{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "version":"3.3.019", "fprocesscat_id":1}}}'
where function_name='gw_fct_audit_check_project';

UPDATE audit_cat_function
set sample_query = '{"WS":{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "rolePermissions":"role_master", "activeLayer":"", "visibleLayer":["None", "None", "v_anl_mincut_result_cat", "v_anl_mincut_result_valve", "v_anl_mincut_result_connec", "v_anl_mincut_result_node", "v_anl_mincut_result_arc", "v_edit_exploitation", "v_edit_dma", "ve_node_wtp", "ve_node_source", "ve_node_waterwell", "ve_node_tank", "ve_node_netsamplepoint", "ve_node_netelement", "ve_node_flexunion", "ve_node_expantank", "ve_node_register", "ve_node_pump", "ve_node_hydrant", "ve_node_pressure_meter", "ve_node_flowmeter", "ve_node_reduction", "ve_node_filter", "ve_node_manhole", "ve_node_air_valve", "ve_node_check_valve", "ve_node_green_valve", "ve_node_pr_reduc_valve", "ve_node_outfall_valve", "ve_node_shutoff_valve", "ve_node_curve", "ve_node_endline", "ve_node_junction", "ve_node_t", "ve_node_x", "ve_node_water_connection", "ve_arc_varc", "ve_arc_pipe", "ve_connec_greentap", "ve_connec_fountain", "ve_connec_tap", "ve_connec_wjoin", "v_edit_link", "v_edit_dimensions", "v_edit_element", "v_edit_samplepoint", "v_edit_cad_auxcircle", "v_edit_cad_auxpoint", "v_edit_inp_connec", "inp_energy", "inp_reactions", "macroexploitation", "cat_mat_node", "cat_mat_arc", "cat_node", "cat_arc", "inp_cat_mat_roughness", "cat_connec", "cat_mat_element", "cat_element", "cat_owner", "cat_soil", "cat_pavement", "cat_work", "cat_presszone", "cat_builder", "cat_brand_model", "cat_brand", "cat_users", "ext_municipality", "v_ext_streetaxis", "v_ext_plot"], "coordinates":{"epsg":25831, "xcoord":418896.1541621131,"ycoord":4576599.51751637, "zoomRatio":1020.7091061537468}}},"UD":{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "rolePermissions":"role_master", "activeLayer":"", "visibleLayer":["None", "None","v_edit_node","ve_node_chamber", "ve_node_change", "ve_node_circ_manhole", "ve_node_highpoint", "ve_node_jump", "ve_node_junction", "ve_node_netelement", "ve_node_netgully", "ve_node_netinit", "ve_node_outfall", "ve_node_owerflow_storage", "ve_node_pump_station", "ve_node_rect_manhole", "ve_node_register", "ve_node_sandbox", "ve_node_sewer_storage", "ve_node_valve", "ve_node_virtual_node", "ve_node_weir", "ve_node_wwtp"], "coordinates":{"epsg":25831, "xcoord":419211.489,"ycoord":4576528.2, "zoomRatio":1020.7091061537468}}}}'
where function_name='gw_api_getinfofromcoordinates';

-- 2020/02/21
INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (116, 'Mincut results', 'om', 'ws') ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2802, 'gw_fct_visit_multiplier', 'utils', 'function', null, null, null,'Function desmultiplier visits when multifeature', 'role_om',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, context, descript, sys_role_id, 
isdeprecated, istoolbox, alias, isparametric)
VALUES (2804, 'gw_fct_admin_manage_schema', 'utils', 'function', null, null, null,'Function to manage (repair, update, compare) giswater schemas', 'role_admin',
false, false, null, false) ON CONFLICT (id) DO NOTHING;

--2020/02/24
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox,isparametric)
VALUES (2806, 'gw_fct_admin_test_ci', 'utils','function', 'Function used in continous integration to test database processes', 
'role_admin', FALSE, FALSE, FALSE) ON CONFLICT (id) DO NOTHING;


INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, qgis_criticity,  isdeprecated)
    VALUES ('ext_cat_raster', 'external catalog', 'Catalog of rasters', 'role_edit', 0, 0, false)
    ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, qgis_criticity,  isdeprecated)
    VALUES ('ext_raster_dem', 'external table', 'Table to store raster DEM', 'role_edit', 0, 0, false)
    ON CONFLICT (id) DO NOTHING;
    
INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, qgis_criticity,isdeprecated)
VALUES ('ext_district', 'table to external', 'Catalog of districts', 'role_edit', 0, 0, false) ON CONFLICT (id) DO NOTHING;


--2020/02/25
INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3042,'Arc with state 2 cant be divided by node with state 1.', 'To divide an arc, the state of the node has to be the same', 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3044,'Can''t detect any arc to divide.', null, 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3046,'Selected node type doesn''t divide arc. Node type: ', null, 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3048,'Flow length is longer than length of exit arc feature', 'Please review your project!', 2,true,'ud', false) ON CONFLICT (id) DO NOTHING;


--2020/02/26
INSERT INTO audit_cat_param_user (id, formname, description, sys_role_id, qgis_message, idval, label, dv_querytext, dv_parent_id, isenabled, layout_id, 
layout_order, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, widgettype, 
ismandatory, widgetcontrols, vdefault, layoutname, reg_exp, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, isdeprecated) 
VALUES ('qgis_form_log_hidden', 'config', 'Hide log form after executing a process', 'role_edit', NULL, NULL, 'Hide log form', NULL, NULL, true, 15, 9, 
'utils', false, NULL, NULL, NULL, false, 'boolean', 'check', true, NULL, 'false', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3050,'It is not possible to relate connects with state=1 to arcs with state=2', 'Please check your map', 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3052,'Connect2network tool is not enabled for connec''s with state=2. Connec_id:', 
'For planned connec''s you must create the link manually (one link for each alternative and one connec) by using the psector form and relate the connec using the arc_id field. After that you will be able to customize the link''s geometry.', 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3054,'Connect2network tool is not enabled for gullies with state=2. Gully_id:', 
'For planned gullies you must create the link manually (one link for each alternative and one gully) by using the psector form and relate the gully using the arc_id field. After that you will be able to customize the link''s geometry.', 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3056,'It is impossible to validate the arc without assigning value of arccat_id. Arc_id:', NULL, 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3058,'It is impossible to validate the connec without assigning value of connecat_id. Connec_id:', NULL, 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3060,'It is impossible to validate the node without assigning value of nodecat_id. Node_id:', NULL, 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3062,'Selected gratecat_id has NULL width or length. Gratecat_id:', 'Check grate catalog or your custom config values before continue', 2,true,'ud', false) ON CONFLICT (id) DO NOTHING;
 
INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3064,'There is a pattern with same name on inp_pattern table', 'Please check before continue.', 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;
 
INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3066,'The dma and period don''t exists yet on dma-period table (ext_rtc_scada_dma_period). It means there are no values for that dma or for that CRM period into GIS', 'Please check it before continue.', 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;
 
INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3068,'The dma/period defined on the dma-period table (ext_rtc_scada_dma_period) has a pattern_id defined', 'Please check it before continue.', 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3070,'Link needs one connec/gully feature as start point. Geometry have been checked and there is no connec/gully feature as start/end point', NULL, 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3072,'It is not possible to connect link closer than 0.25 meters from nod2arc features in order to prevent conflits if this node may be a nod2arc', 'Please check it before continue', 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3074,'It is mandatory to connect as init point one connec or gully with link',NULL,  2,true,'ud', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3076,'It is not possible to create the link. On inventory mode only one link is enabled for each connec. Connec_id:',
'On planning mode it is possible to create more than one link, one for each alternative, but it is mandatory to use the psector form and relate the connec using arc_id field. After that you will be able to customize the link''s geometry.',
 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3078,'It is not possible to create the link. On inventory mode only one link is enabled for each gully. Gully_id:',
'On planning mode it is possible to create more than one link, one for each alternative, but it is mandatory to use the psector form and relate gully using arc_id field. After that you will be able to customize the link''s geometry.',
 2,true,'ud', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3080,'It''s not possible to relate connec with state=2 over feature with state=1. Connec_id:',NULL, 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3082,'It''s not possible to relate connec over other connec or node while working with alternatives on planning mode. Only arcs are avaliable',NULL, 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3084,'It is not enabled to insert vnodes. if you are looking to join links you can use vconnec to join it',
'You can create vconnec feature and simbolyze it as vnodes. By using vconnec as vnodes you will have all features in terms of propagation of arc_id', 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3086,'It is not enabled to update vnodes','If you are looking to update endpoint of links use the link''s layer to do it', 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3088,'It is not enabled to delete vnodes','Vnode will be automaticly deleted when link connected to vnode disappears', 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3090,'Please enter a valid grafClass', NULL, 2,true,'ws', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3092,'Only arc is available as input feature to execute mincut', NULL, 2,true,'ws', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3094,'One of new arcs has no length', 'The selected node may be its final.', 2,true,'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_error (id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3096, 'If widgettype=typeahead, isautoupdate must be FALSE', NULL, 2, TRUE, 'utils', false) ON CONFLICT (id) DO NOTHING;

UPDATE audit_cat_param_user SET vdefault = 'TRUE' WHERE  id = 'qgis_form_initproject_hidden';

UPDATE config_param_system SET descript = 'If status is TRUE, when insert a new connec, customer_code will be the same as field (connec_id or code). If you choose connec_id you can previously visualize it on form, but if you choose code you will see customer_code after inserting'
WHERE parameter = 'customer_code_autofill';


-- 2020/02/27
UPDATE config_api_typevalue SET id='lyt_bot_1', idval='lyt_bot_1' WHERE id='bot_layout_1' AND typevalue = 'layout_name_typevalue';
UPDATE config_api_typevalue SET id='lyt_bot_2', idval='lyt_bot_2' WHERE id='bot_layout_2' AND typevalue = 'layout_name_typevalue';
UPDATE config_api_typevalue SET id='lyt_data_1', idval='lyt_data_1' WHERE id='layout_data_1' AND typevalue = 'layout_name_typevalue';
UPDATE config_api_typevalue SET id='lyt_data_2', idval='lyt_data_2' WHERE id='layout_data_2' AND typevalue = 'layout_name_typevalue';
UPDATE config_api_typevalue SET id='lyt_data_3', idval='lyt_data_3' WHERE id='layout_data_3' AND typevalue = 'layout_name_typevalue';
UPDATE config_api_typevalue SET id='lyt_data_1', idval='lyt_data_1' WHERE id='layout_data_1' AND typevalue = 'layout_name_typevalue';
UPDATE config_api_typevalue SET id='lyt_top_1', idval='lyt_top_1' WHERE id='top_layout' AND typevalue = 'layout_name_typevalue';
UPDATE config_api_typevalue SET id='lyt_distance', idval='lyt_distance' WHERE id='distance_layout' AND typevalue = 'layout_name_typevalue';
UPDATE config_api_typevalue SET id='lyt_symbology', idval='lyt_symbology' WHERE id='symbology_layout' AND typevalue = 'layout_name_typevalue';
UPDATE config_api_typevalue SET id='lyt_depth', idval='lyt_depth' WHERE id='depth_layout' AND typevalue = 'layout_name_typevalue';
UPDATE config_api_typevalue SET id='lyt_other', idval='lyt_other' WHERE id='other_layout' AND typevalue = 'layout_name_typevalue';



UPDATE config_api_typevalue SET addparam='{"createAddfield":"TRUE"}' WHERE id IN ('button', 'check', 'combo', 'datepikertime', 'doubleSpinbox', 'hyperlink', 'text', 'typeahead') AND typevalue = 'widgettype_typevalue';

UPDATE config_api_typevalue SET addparam='{"createAddfield":"TRUE"}' WHERE id IN ('boolean', 'date', 'dobule', 'integer', 'numeric', 'smallint', 'text') AND typevalue = 'datatype_typevalue';

UPDATE config_api_typevalue SET addparam='{"createAddfield":"TRUE"}' WHERE id IN ('gw_api_open_url') AND typevalue = 'widgetfunction_typevalue';

UPDATE config_api_typevalue SET addparam='{"createAddfield":"TRUE"}' WHERE id IN ('lyt_bot_1', 'lyt_bot_2', 'lyt_data_1', 'lyt_data_2', 'lyt_data_3', 'lyt_top_1') AND typevalue = 'layout_name_typevalue';


SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'id', 1, 'integer', 'text', 'id', 
NULL, NULL, NULL, TRUE, NULL, FALSE, NULL, NULL, 
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'formname', 2, 'text', 'text', 'Formname',
NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'formtype', 3, 'text', 'text', 'Formtype',
NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'column_id', 4, 'text', 'text', 'Column id', NULL, 'column_id - Id of the column', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'label', 5, 'text', 'text', 'Label', NULL, 'label - Label shown on the item form', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'hidden', 6, 'boolean', 'check', 'Hidden', NULL, 'hidden - Hide this field from form', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'layoutname', 7, 'text', 'combo', 'Layout name', NULL, 'layoutname - Name of the layout which field will be located', NULL, TRUE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue= ''layout_name_typevalue'' AND  addparam->>''createAddfield''=''TRUE''', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'layout_order', 8, 'integer', 'text', 'Layout order', NULL, 'layout_order - Order in the layout which field will be located', 
NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'iseditable', 9, 'boolean', 'check', 'Is editable', NULL, 'iseditable - Field is editable or not', 
NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'ismandatory', 10, 'boolean', 'check', 'Is mandatory', NULL, 'ismandatory - Field is mandatory or not', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'datatype', 11, 'text', 'combo', 'Datatype', NULL, 'datatype - Data type of the field', NULL, TRUE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue=''datatype_typevalue'' AND addparam->>''createAddfield''=''TRUE''',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'widgettype', 12, 'text', 'combo', 'Widgettype', NULL, 
'widgettype - Widget of the field. Must match with the data type. Advanced configuration on widgetcontrols field is possible
If widgettype=''text'', you can force values using "maxMinValues":{"min": or "max":} or "maxLength" or "regexpControl". In addition you can enable multiline widget using "setQgisMultiline"
If widgettype=''combo'', you can only make editable combo for specific values of child using enableWhenParent
If widgettype=''typeahead'' additional rules must be followed: id and idval for dv_querytext must be the same in exception of the fields streetaxis(2)_id/ streetname(2)', 
NULL, TRUE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue=''widgettype_typevalue'' AND addparam->>''createAddfield''=''TRUE''', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'widgetdim', 13, 'integer', 'text', 'Widgetdim', NULL, 'widgetdim - Dimension of the widget (may affect all widgets on same layout)', NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'tooltip', 14, 'text', 'text', 'Tooltip', NULL, 'tooltip - Tooltip shown when mouse passes over the label', NULL,  FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'placeholder', 15, 'text', 'text', 'Placeholder', NULL, 'placeholder - Sample value for textedit widgets', NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'stylesheet', 16, 'text', 'text', 'Stylesheet', NULL, 'stylesheet - Style of the label in the form. CSS styles are allowed', '{"label":"color:blue; font-weight:bold; font-style:normal; font-size:15px; background-color: yellow"}',  FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'isparent', 17, 'boolean', 'check', 'Isparent', NULL, 'isparent - Is parent of another field', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'isautoupdate', 18, 'boolean', 'check', 'Isautoupdate', NULL, 
'isautoupdate - Force update of feature. If is true, you can use the key autoupdateReloadFields of widgetcontrols to identify fields must be reloaded with updated values.
Warning: It is dangerous for typeahead widget. It crashes!'
, NULL,  TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'dv_querytext', 19, 'text', 'text', 'Dv querytext', NULL, 'dv_querytext - For combos, query which fill the values of the combo. Must have id, idval column structure', 'SELECT id, idval FROM some_table WHERE some_column=''some_value''', FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'dv_orderby_id', 20, 'boolean', 'check', 'Dv orderby id', NULL, 'dv_orderby_id - For combos, order for id or not', NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'dv_isnullvalue', 21, 'boolean', 'check', 'Dv isnullvalue', NULL, 'dv_isnullvalue - For combos, allow null value', NULL,  FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'dv_parent_id', 22, 'text', 'text', 'Dv parentid', NULL, 
'dv_parent_id - Id of the related parent table. Use only (mandatory in that case) when dv_querytext_filterc IS NOT NULL.', NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'dv_querytext_filterc', 23, 'text', 'text', 'Dv querytext filterc', NULL, 
'dv_querytext_filterc - Filter related to the parent table', ' AND value_state_type.state=', 
FALSE, NULL, TRUE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'widgetcontrols', 24, 'text', 'text', 'Widget controls', NULL, 
'widgetcontrols - Advanced options to control the widget.
If widgettype=''text'', you can force values using "minValue" or "maxValue" or "regexpControl". In addition you can enable multiline widget using "setQgisMultiline"
If widgettype=''combo'', you can only make editable combo for specific values of child using enableWhenParent
If isautoupdate=true, you can use autoupdateReloadFields to identify fields must be reloaded with updated values',
'{"setQgisMultiline":true, "maxMinValues":{"min":0.001, "max":100}, "maxLength":16, "autoupdateReloadFields":["a", "b"], "enableWhenParent":["a", "b"], "regexpControl":""}', 
FALSE, NULL, TRUE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'widgetfunction', 25, 'text', 'combo', 'Widget function', NULL, 'widgetfunction - Python action triggered by users click on widget', NULL, FALSE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue=''widgetfunction_typevalue''', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'linkedaction', 26, 'text', 'combo', 'Linked action', NULL, 'linkedaction - Form action related with this field', NULL, FALSE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue=''actionfunction_typevalue''', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'listfilterparam', 27, 'text', 'text', 'Listfilterparam', NULL, 'listfilterparam - Parameters of the filters for lists', '{"sign":">","vdefault":"2014-01-01"}', FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_actions (actionname) VALUES ('actionEdit') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionCopyPaste') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionCatalog') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionWorkcat') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionRotation') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionZoomIn') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionZoomOut') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionCentered') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionLink') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionHelp') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionGetArcId') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionAddPhoto') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionAddFile') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionDelete') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionGetParentId') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionSection') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionInterpolate') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('visit_start') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('visit_end') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('actionZoom') ON CONFLICT (actionname) DO NOTHING;
INSERT INTO config_api_form_actions (actionname) VALUES ('getInfoFromId') ON CONFLICT (actionname) DO NOTHING;

--2020/03/10
UPDATE config_api_form_fields SET isautoupdate = FALSE WHERE widgettype='typeahead';
UPDATE config_api_form_fields SET widgetcontrols = gw_fct_json_object_delete_keys(widgetcontrols,'autoupdateReloadFields', 'typeaheadSearchField') WHERE widgettype='typeahead';

--2020/03/11
UPDATE config_api_form_fields SET dv_parent_id = null, dv_querytext_filterc = null where column_id = 'category_type';

UPDATE config_api_form_fields SET widgettype = 'text' WHERE column_id = 'macrodma_id';
UPDATE config_api_form_fields SET widgettype = 'text' WHERE column_id = 'macroexpl_id';
UPDATE config_api_form_fields SET widgettype = 'text' WHERE column_id = 'macrosector_id';
