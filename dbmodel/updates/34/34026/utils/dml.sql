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
UPDATE config_param_system SET value  = $${{"arc":"SELECT arc_id AS arc_id, concat(v_edit_arc.matcat_id,'-Ø',(c.geom1*100)::integer) as catalog, (case when slope is not null then concat((100*slope)::numeric(12,2),' / ',gis_length::numeric(12,2),'m') else concat('None / ',gis_length::numeric(12,2),'m') end) as dimensions , arc_id as code FROM v_edit_arc JOIN cat_arc c ON id = arccat_id"}}$$ 
WHERE parameter = 'om_profile_guitartext';

UPDATE config_param_system SET value  = $${{"catalog":"CATALOG", "vs":"VS", "hs":"HS", "referencePlane":"REFERENCE",  "dimensions":"SLOPE / LENGTH", "ordinates": "ORDINATES", "topelev":"TOP ELEV", "ymax":"YMAX", "elev": "ELEV", "code":"CODE", "distance":"DISTANCE"}}$$ 
WHERE parameter = 'om_profile_guitarlegend';

UPDATE config_param_user SET value = $${{"title":{"text":{"color":"black", "weight":"bold", "size":10}},
"terrain":{"color":"gray", "width":1.5, "style":"dashdot"}, "infra":{"real":{"color":"black", "width":1, "style":"solid"}, "interpolated":{"color":"gray", "width":1.5,"style":"solid"}},
"grid":{"boundary":{"color":"gray","style":"solid", "width":1}, "lines":{"color":"lightgray","style":"solid", "width":1},"text":{"color":"black", "weight":"normal"}},
"guitar":{"lines":{"color":"black", "style":"solid", "width":1}, "auxiliarlines":{"color":"gray","style":"solid", "width":1}, "text":{"color":"black", "weight":"normal"}}}}$$
WHERE parameter = 'om_profile_stylesheet';

UPDATE sys_param_user SET vdefault = $${{"title":{"text":{"color":"black", "weight":"bold", "size":10}},
"terrain":{"color":"gray", "width":1.5, "style":"dashdot"}, "infra":{"real":{"color":"black", "width":1, "style":"solid"}, "interpolated":{"color":"gray", "width":1.5,"style":"solid"}},
"grid":{"boundary":{"color":"gray","style":"solid", "width":1}, "lines":{"color":"lightgray","style":"solid", "width":1},"text":{"color":"black", "weight":"normal"}},
"guitar":{"lines":{"color":"black", "style":"solid", "width":1}, "auxiliarlines":{"color":"gray","style":"solid", "width":1}, "text":{"color":"black", "weight":"normal"}}}}$$
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
