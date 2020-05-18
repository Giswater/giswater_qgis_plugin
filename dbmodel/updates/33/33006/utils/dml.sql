/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 11/10/2019
UPDATE config_param_user SET parameter = 'qgis_toolbar_hidebuttons', value = '{"action_index":[199,74,75,76]}' WHERE parameter = 'actions_to_hide';

UPDATE audit_cat_param_user SET dv_querytext = 'SELECT UNNEST(ARRAY (select (text_column::json->>''list_layers_name'')::text[] from temp_table where fprocesscat_id = 63 and user_name = current_user)) as id, UNNEST(ARRAY (select (text_column::json->>''list_layers_name'')::text[] 
FROM temp_table WHERE fprocesscat_id = 63 and user_name = current_user)) as idval ' WHERE id = 'cad_tools_base_layer_vdefault';

-- 14/10/2019
INSERT INTO sys_fprocess_cat VALUES (64, 'Nodes without elevation', 'epa', 'Nodes without elevation', 'ws') ON conflict (id) DO NOTHING;
INSERT INTO sys_fprocess_cat VALUES (65, 'Nodes with elevation=0', 'epa', 'Nodes with elevation=0', 'ws') ON conflict (id) DO NOTHING;
INSERT INTO sys_fprocess_cat VALUES (66, 'Node2arc with more than two arcs', 'epa', 'Node2arc with more than two arcs', 'ws') ON conflict (id) DO NOTHING;
INSERT INTO sys_fprocess_cat VALUES (67, 'Node2arc with less than two arcs', 'epa', 'Node2arc with less than two arcs', 'ws') ON conflict (id) DO NOTHING;

--15/10/2019
UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_config_system_variables", "enabled":"true", "trg_fields":"parameter, value, data_type, context, descript, label","featureType":[""]}]' 
WHERE id = 'config_param_system';

UPDATE audit_cat_table SET notify_action = '[{"action":"user","name":"refresh_config_user_variables", "enabled":"true", "trg_fields":"parameter,value,cur_user","featureType":[""]}]'
WHERE id = 'config_param_user';

UPDATE audit_cat_table SET notify_action='[{"action":"desktop","name":"refresh_canvas", "enabled":"true", "trg_fields":"the_geom","featureType":["link", "v_edit_link"]}]' 
WHERE id='link';
UPDATE audit_cat_table SET notify_action='[{"action":"desktop","name":"refresh_canvas", "enabled":"true", "trg_fields":"the_geom","featureType":["vnode", "v_edit_vnode"]}]' 
WHERE id='vnode';

-- 15/10/2019
UPDATE audit_cat_function SET alias = 'Build nodes using arcs start & end vertices' WHERE function_name = 'gw_fct_built_nodefromarc';

UPDATE audit_cat_table SET sys_role_id='role_basic' WHERE id = 'temp_table';

-- 17/10/2019
UPDATE audit_cat_param_user SET description = 'If true, link will be automatically generated when inserting a new connec with state=1. For planified connecs, link will always be automatically generated'
WHERE id = 'edit_connect_force_automatic_connect2network';



UPDATE config_api_form_fields SET dv_querytext=concat('SELECT location_type as id, location_type as idval FROM man_type_location WHERE (featurecat_id is null AND feature_type=''NODE'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='location_type' AND cat_feature.feature_type='NODE';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT location_type as id, location_type as idval FROM man_type_location WHERE (featurecat_id is null AND feature_type=''ARC'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='location_type' AND cat_feature.feature_type='ARC';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT location_type as id, location_type as idval FROM man_type_location WHERE (featurecat_id is null AND feature_type=''CONNEC'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='location_type' AND cat_feature.feature_type='CONNEC';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE (featurecat_id is null AND feature_type=''NODE'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='fluid_type' AND cat_feature.feature_type='NODE';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE (featurecat_id is null AND feature_type=''ARC'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='fluid_type' AND cat_feature.feature_type='ARC';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE (featurecat_id is null AND feature_type=''CONNEC'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='fluid_type' AND cat_feature.feature_type='CONNEC';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT category_type as id, category_type as idval FROM man_type_category WHERE (featurecat_id is null AND feature_type=''NODE'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='category_type' AND cat_feature.feature_type='NODE';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT category_type as id, category_type as idval FROM man_type_category WHERE (featurecat_id is null AND feature_type=''ARC'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='category_type' AND cat_feature.feature_type='ARC';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT category_type as id, category_type as idval FROM man_type_category WHERE (featurecat_id is null AND feature_type=''CONNEC'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='category_type' AND cat_feature.feature_type='CONNEC';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT function_type as id, function_type as idval FROM man_type_function WHERE (featurecat_id is null AND feature_type=''NODE'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='function_type' AND cat_feature.feature_type='NODE';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT function_type as id, function_type as idval FROM man_type_function WHERE (featurecat_id is null AND feature_type=''ARC'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='function_type' AND cat_feature.feature_type='ARC';

UPDATE config_api_form_fields SET dv_querytext=concat('SELECT function_type as id, function_type as idval FROM man_type_function WHERE (featurecat_id is null AND feature_type=''CONNEC'') OR featurecat_id =',quote_literal(cat_feature.id)),
dv_querytext_filterc=NULL, dv_parent_id=null
FROM cat_feature WHERE child_layer = formname AND column_id ='function_type' AND cat_feature.feature_type='CONNEC';




UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE (featurecat_id is null AND feature_type=''NODE'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_node' and column_id = 'location_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type=''NODE'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_node' and column_id = 'location_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE (featurecat_id is null AND feature_type=''NODE'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_node' and column_id = 'fluid_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE feature_type=''NODE'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_node' and column_id = 'fluid_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE (featurecat_id is null AND feature_type=''NODE'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_node' and column_id = 'function_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type=''NODE'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_node' and column_id = 'function_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE (featurecat_id is null AND feature_type=''NODE'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_node' and column_id = 'location_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type=''NODE'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_node' and column_id = 'location_type';


UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE (featurecat_id is null AND feature_type=''ARC'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_arc' and column_id = 'location_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type=''ARC'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_arc' and column_id = 'location_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE (featurecat_id is null AND feature_type=''ARC'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_arc' and column_id = 'fluid_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE feature_type=''ARC'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_arc' and column_id = 'fluid_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE (featurecat_id is null AND feature_type=''ARC'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_arc' and column_id = 'function_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type=''ARC'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_arc' and column_id = 'function_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE (featurecat_id is null AND feature_type=''ARC'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_arc' and column_id = 'location_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type=''ARC'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_arc' and column_id = 'location_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE (featurecat_id is null AND feature_type=''CONNEC'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_connec' and column_id = 'location_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type=''CONNEC'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_connec' and column_id = 'location_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE (featurecat_id is null AND feature_type=''CONNEC'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_connec' and column_id = 'fluid_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE feature_type=''CONNEC'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_connec' and column_id = 'fluid_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE (featurecat_id is null AND feature_type=''CONNEC'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_connec' and column_id = 'function_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type=''CONNEC'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_connec' and column_id = 'function_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE (featurecat_id is null AND feature_type=''CONNEC'') ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 've_connec' and column_id = 'location_type';

UPDATE config_api_form_fields SET 
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type=''CONNEC'' ',
dv_querytext_filterc=NULL, dv_parent_id=null
WHERE formname = 'v_edit_connec' and column_id = 'location_type';
