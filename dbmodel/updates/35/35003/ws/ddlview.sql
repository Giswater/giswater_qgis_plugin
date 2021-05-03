/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/04/27
--save views and remove 1st field
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_vnode","v_arc_x_vnode","v_edit_link","v_ui_workcat_x_feature_end","v_rtc_period_pjoint", "v_rtc_period_pjointpattern", "v_rtc_interval_nodepattern", "v_rtc_period_nodepattern", 
"v_rtc_period_node", "v_rtc_period_dma", "v_rtc_period_hydrometer","vp_basic_connec", "vi_pjoint", "v_edit_inp_demand",
"vi_parent_hydrometer","v_ui_arc_x_relations", "v_edit_inp_connec"], "action":"saveView","hasChilds":"False"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_connec"], "fieldName":"featurecat_id","action":"deleteField","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["vi_parent_connec","ve_connec","v_connec","vu_connec"], "fieldName":"featurecat_id","action":"deleteField","hasChilds":"False"}}$$);

--restore connec views
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["vu_connec", "v_connec", "ve_connec","vi_parent_connec"], "action":"restoreView","hasChilds":"False"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_connec"], "action":"restoreView","hasChilds":"True"}}$$);

--delete 2nd field
 SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_connec"], "fieldName":"feature_id","action":"deleteField","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":[ "vi_parent_connec","ve_connec","v_connec","vu_connec"], "fieldName":"feature_id","action":"deleteField","hasChilds":"False"}}$$);

--remove fields from table
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"connec", "column":"feature_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"connec", "column":"featurecat_id"}}$$);

--restore all views
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["vu_connec", "v_connec", "ve_connec","vi_parent_connec"], "action":"restoreView","hasChilds":"False"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_connec"], "action":"restoreView","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_inp_connec","v_ui_arc_x_relations","vi_parent_hydrometer", "v_edit_inp_demand", "vi_pjoint", "vp_basic_connec","v_rtc_period_hydrometer",
"v_rtc_period_dma", "v_rtc_period_node", "v_rtc_period_nodepattern", "v_rtc_interval_nodepattern","v_rtc_period_pjointpattern",
"v_rtc_period_pjoint", "v_ui_workcat_x_feature_end","v_edit_link","v_vnode","v_arc_x_vnode"], "action":"restoreView","hasChilds":"False"}}$$);


-- 2021/05/01
CREATE OR REPLACE VIEW vi_rules AS 
 SELECT c.text
   FROM (SELECT d.id,
            d.text
           FROM ( SELECT inp_rules.id AS id,
                    inp_rules.text
                   FROM selector_sector, inp_rules
                  WHERE selector_sector.sector_id = inp_rules.sector_id AND selector_sector.cur_user = "current_user"()::text AND inp_rules.active IS NOT FALSE
                  ORDER BY inp_rules.id) d) c
  ORDER BY c.id;


CREATE OR REPLACE VIEW vi_controls AS 
 SELECT c.text
   FROM (SELECT d.id,
            d.text
           FROM ( SELECT inp_controls.id AS id,
                    inp_controls.text
                   FROM selector_sector,inp_controls
                  WHERE selector_sector.sector_id = inp_controls.sector_id AND selector_sector.cur_user = "current_user"()::text AND inp_controls.active IS NOT FALSE
                  ORDER BY inp_controls.id) d) c
  ORDER BY c.id;
