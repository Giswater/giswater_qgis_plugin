/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/10
CREATE OR REPLACE VIEW v_edit_inp_lid_usage AS 
SELECT 
subc_id, 
lidco_id, 
"number", 
l.area, 
l.width, 
initsat, 
fromimp, 
toperv, 
rptfile, 
l.descript,
s.the_geom
FROM inp_lid_usage l
JOIN v_edit_inp_subcatchment s USING(subc_id);


CREATE OR REPLACE VIEW vi_lid_usage AS 
 SELECT inp_lid_usage.subc_id,
    inp_lid_usage.lidco_id,
    inp_lid_usage.number::integer AS number,
    inp_lid_usage.area,
    inp_lid_usage.width,
    inp_lid_usage.initsat,
    inp_lid_usage.fromimp,
    inp_lid_usage.toperv::integer AS toperv,
    inp_lid_usage.rptfile
    FROM v_edit_inp_subcatchment
   JOIN inp_lid_usage ON inp_lid_usage.subc_id::text = v_edit_inp_subcatchment.subc_id::text;

--SAVE VIEWS
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_vnode", "v_vnode","v_ui_arc_x_relations","v_arc_x_vnode","v_edit_link","v_ui_workcat_x_feature_end","v_rtc_period_pjoint", 
"v_ui_node_x_connection_upstream","vp_basic_gully","v_anl_flow_gully","v_ui_workcat_x_feature", "v_web_parent_gully", "v_edit_man_gully"], "action":"SAVE-VIEW","hasChilds":"False"}}$$);


SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_gully"], "action":"SAVE-VIEW","hasChilds":"True"}}$$);
    
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["ve_gully","v_gully","vu_gully", "v_plan_psector_gully","v_ui_plan_arc_cost","v_plan_result_arc","v_plan_current_psector_budget_detail","v_plan_current_psector_budget", "v_plan_psector_budget_arc",
"v_plan_psector_all","v_plan_current_psector","v_plan_psector","v_plan_arc"], "action":"SAVE-VIEW","hasChilds":"False"}}$$);
    
ALTER TABLE gully ALTER COLUMN gratecat_id TYPE character varying(30) USING gratecat_id::character varying(30);

--RESTORE VIEWS
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_plan_arc","v_plan_psector","v_plan_current_psector","v_plan_psector_all",
"v_plan_psector_budget_arc","v_plan_current_psector_budget","v_plan_current_psector_budget_detail","v_plan_result_arc","v_ui_plan_arc_cost","v_plan_psector_gully","vu_gully",
"v_gully", "ve_gully"  ], "action":"RESTORE-VIEW","hasChilds":"False"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_gully"], "action":"RESTORE-VIEW","hasChilds":"True"}}$$);
    
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":[ "v_edit_man_gully","v_ui_workcat_x_feature", "v_anl_flow_gully","vp_basic_gully","v_ui_node_x_connection_upstream",
"v_rtc_period_pjoint","v_ui_workcat_x_feature_end","v_edit_link", "v_arc_x_vnode","v_ui_arc_x_relations","v_vnode", "v_web_parent_gully"], "action":"RESTORE-VIEW","hasChilds":"False"}}$$);
