/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/15
INSERT INTO sys_table VALUES ('v_plan_psector_arc', 'View to show arcs related to psectors. Useful to show arcs which will be obsolete in psectors', 'role_basic', 0, 'role_master', 2, 'Cannot view related arcs to psectors') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_plan_psector_node', 'View to show nodes related to psectors. Useful to show nodes which will be obsolete in psectors', 'role_basic', 0, 'role_master', 2, 'Cannot view related nodes to psectors') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_plan_psector_connec', 'View to show connecs related to psectors. Useful to show connecs which will be obsolete in psectors', 'role_basic', 0, 'role_master', 2, 'Cannot view related connecs to psectors') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_plan_psector_link', 'View to show links related to psectors. Useful to show links which will be obsolete in psectors', 'role_basic', 0, 'role_master', 2, 'Cannot view related links to psectors') ON CONFLICT (id) DO NOTHING;


DELETE FROM sys_table WHERE id='v_plan_psector_x_arc';
DELETE FROM sys_table WHERE id='v_plan_psector_x_node';
DELETE FROM sys_table WHERE id='v_plan_psector_x_other';


--2020/12/28
UPDATE config_param_system SET value  = $${"catalog":"CATALOG", "vs":"VS", "hs":"HS", "referencePlane":"REFERENCE",  "dimensions":"SLOPE / LENGTH", "ordinates": "ORDINATES", "topelev":"TOP ELEV", "ymax":"YMAX", "elev": "ELEV", "code":"CODE", "distance":"DISTANCE"}$$ 
WHERE parameter = 'om_profile_guitarlegend';

UPDATE config_param_user SET value = $${"title":{"text":{"color":"black", "weight":"bold", "size":10}},
"terrain":{"color":"gray", "width":1.5, "style":"dashdot"}, "infra":{"real":{"color":"black", "width":1, "style":"solid"}, "interpolated":{"color":"gray", "width":1.5,"style":"solid"}},
"grid":{"boundary":{"color":"gray","style":"solid", "width":1}, "lines":{"color":"lightgray","style":"solid", "width":1},"text":{"color":"black", "weight":"normal"}},
"guitar":{"lines":{"color":"black", "style":"solid", "width":1}, "auxiliarlines":{"color":"gray","style":"solid", "width":1}, "text":{"color":"black", "weight":"normal"}}}$$
WHERE parameter = 'om_profile_stylesheet';

UPDATE sys_param_user SET vdefault = $${"title":{"text":{"color":"black", "weight":"bold", "size":10}},
"terrain":{"color":"gray", "width":1.5, "style":"dashdot"}, "infra":{"real":{"color":"black", "width":1, "style":"solid"}, "interpolated":{"color":"gray", "width":1.5,"style":"solid"}},
"grid":{"boundary":{"color":"gray","style":"solid", "width":1}, "lines":{"color":"lightgray","style":"solid", "width":1},"text":{"color":"black", "weight":"normal"}},
"guitar":{"lines":{"color":"black", "style":"solid", "width":1}, "auxiliarlines":{"color":"gray","style":"solid", "width":1}, "text":{"color":"black", "weight":"normal"}}}$$
WHERE id = 'om_profile_stylesheet';


-- reserved id's for anl_drained_flows toolbox extra tools
-- INSERT INTO sys_fprocess VALUES (367, 'Drained flows');
-- INSERT INTO sys_function VALUES (3014,'anl_drained_flows');
-- INSERT INTO sys_function VALUES (3016,'anl_drained_flows_recursive');

-- 2021/01/05
UPDATE config_param_user SET value = gw_fct_json_object_delete_keys(value::json,'showLog') WHERE parameter = 'inp_options_debug';
UPDATE sys_param_user SET vdefault = gw_fct_json_object_delete_keys(vdefault::json,'showLog') WHERE id = 'inp_options_debug';

-- 2021/01/08
INSERT INTO sys_message VALUES (3168, 'Before set isparent=TRUE, other field has to have related dv_parent_id', NULL, 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message VALUES (3170, 'Before delete dv_parent_id, you must set isparent=FALSE to the parent field', NULL, 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING;

-- 2021/01/11
DELETE FROM config_form_tabs WHERE tabname='tab_visit';

-- 2021/01/12
ALTER TABLE man_type_location DROP CONSTRAINT IF EXISTS man_type_location_featurecat_id_fkey;
ALTER TABLE man_type_fluid DROP CONSTRAINT IF EXISTS man_type_fluid_featurecat_id_fkey;
ALTER TABLE man_type_category DROP CONSTRAINT IF EXISTS man_type_category_featurecat_id_fkey;
ALTER TABLE man_type_function DROP CONSTRAINT IF EXISTS man_type_function_featurecat_id_fkey;

UPDATE config_form_fields set dv_querytext = concat(replace(dv_querytext,'OR featurecat_id =','OR'),'= ANY(featurecat_id::text[]) ') WHERE 
dv_querytext ILIKE '%OR featurecat_id =%' and columnname IN ('fluid_type', 'category_type','function_type', 'location_type');

UPDATE man_type_function SET featurecat_id = concat('{',featurecat_id,'}') where featurecat_id is not null AND featurecat_id NOT ILIKE '{%}';
UPDATE man_type_fluid SET featurecat_id = concat('{',featurecat_id,'}') where featurecat_id is not null AND featurecat_id NOT ILIKE '{%}';
UPDATE man_type_category SET featurecat_id = concat('{',featurecat_id,'}') where featurecat_id is not null AND featurecat_id NOT ILIKE '{%}';
UPDATE man_type_location SET featurecat_id = concat('{',featurecat_id,'}') where featurecat_id is not null AND featurecat_id NOT ILIKE '{%}';

UPDATE sys_param_user SET dv_querytext_filterc = null, feature_field_id = null WHERE id IN ('edit_featureval_category_vdefault',
'edit_featureval_fluid_vdefault','edit_featureval_function_vdefault','edit_featureval_location_vdefault');


INSERT INTO inp_typevalue VALUES ('inp_pjoint_type', 'NODE', 'NODE') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO inp_typevalue VALUES ('inp_pjoint_type', 'VNODE', 'VNODE') ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO config_param_system VALUES ('admin_config_control_trigger', 'TRUE', 'Enable or disable trigger related to config tables. If true, is enabled', 'Config control trigger:', NULL, NULL, FALSE, NULL, 'utils', NULL, NULL, 'boolean') ON CONFLICT (parameter) DO NOTHING;

UPDATE config_form_fields SET dv_parent_id = 'feature_id', dv_querytext = 'SELECT id, idval FROM (SELECT node_1 AS id, node_1 AS idval FROM arc UNION SELECT DISTINCT node_2 AS id, node_2 AS idval FROM arc)c WHERE id IS NOT NULL' WHERE formname = 'visit_singlevent' AND columnname = 'position_id';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, idval FROM config_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))' 
WHERE formname IN ('visit_singlevent','visit_multievent') AND columnname = 'class_id';

UPDATE config_form_fields SET isparent = false WHERE formname IN ('v_edit_dimensions', 'v_edit_samplepoint') AND columnname = 'state';

UPDATE config_form_fields SET dv_parent_id = 'muni_id' WHERE formname IN ('v_ext_address', 'v_ext_plot','v_edit_samplepoint') 
AND columnname in ('streetname','streetname2');

DELETE  FROM config_form_fields WHERE columnname = 'lot_id';

DELETE FROM sys_param_user WHERE id = 'basic_search_municipality_vdefault';
DELETE FROM config_param_user WHERE parameter = 'basic_search_municipality_vdefault';