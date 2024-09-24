/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_state_arc AS
WITH
p AS (SELECT arc_id, psector_id, state FROM plan_psector_x_arc WHERE active),
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user),
a as (SELECT arc_id, state FROM arc)
SELECT arc.arc_id FROM selector_state,arc WHERE arc.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND p.state = 0
	UNION ALL
SELECT DISTINCT p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND p.state = 1;


CREATE OR REPLACE VIEW v_state_node AS
WITH
p AS (SELECT node_id, psector_id, state FROM plan_psector_x_node WHERE active),
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user),
n AS (SELECT node_id, state FROM node)
SELECT n.node_id FROM selector_state,n WHERE n.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.node_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND p.state = 0 AND cf.value is TRUE
	UNION ALL
SELECT DISTINCT p.node_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND p.state = 1 AND cf.value is TRUE;

-- delete all views to avoid conflicts, then recreate them
DROP VIEW IF EXISTS v_plan_psector_budget_detail;
DROP VIEW IF EXISTS v_plan_psector_budget_arc;
DROP VIEW IF EXISTS v_plan_psector_budget;
DROP VIEW IF EXISTS v_plan_psector_all;
DROP VIEW IF EXISTS v_plan_current_psector;
DROP VIEW IF EXISTS v_plan_psector_arc;
DROP VIEW IF EXISTS v_plan_psector_connec;
DROP VIEW IF EXISTS v_plan_psector_node;
DROP VIEW IF EXISTS v_plan_psector;
DROP VIEW IF EXISTS v_plan_result_arc;
DROP VIEW IF EXISTS v_ui_plan_arc_cost;

DROP VIEW IF EXISTS v_ui_workcat_x_feature;
DROP VIEW IF EXISTS v_ui_workcat_x_feature_end;
DROP VIEW IF EXISTS v_ui_node_x_connection_downstream;
DROP VIEW IF EXISTS v_ui_node_x_connection_upstream;

DROP VIEW IF EXISTS v_edit_inp_orifice;
DROP VIEW IF EXISTS v_edit_inp_outlet;
DROP VIEW IF EXISTS v_edit_inp_pump;
DROP VIEW IF EXISTS v_edit_inp_virtual;
DROP VIEW IF EXISTS v_edit_inp_weir;

DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_orifice;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_pump;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_weir;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_outlet;
DROP VIEW IF EXISTS v_edit_inp_flwreg_orifice;
DROP VIEW IF EXISTS v_edit_inp_flwreg_pump;
DROP VIEW IF EXISTS v_edit_inp_flwreg_weir;
DROP VIEW IF EXISTS v_edit_inp_flwreg_outlet;

DROP VIEW IF EXISTS v_edit_inp_dscenario_inflows;
DROP VIEW IF EXISTS v_edit_inp_dscenario_inflows_poll;
DROP VIEW IF EXISTS v_edit_inp_dscenario_junction;
DROP VIEW IF EXISTS v_edit_inp_dscenario_treatment;
DROP VIEW IF EXISTS v_edit_inp_dwf;
DROP VIEW IF EXISTS v_edit_inp_inflows;
DROP VIEW IF EXISTS v_edit_inp_inflows_poll;
DROP VIEW IF EXISTS v_edit_inp_treatment;
DROP VIEW IF EXISTS v_edit_inp_junction;

DROP VIEW IF EXISTS v_edit_inp_divider;
DROP VIEW IF EXISTS v_edit_inp_dscenario_outfall;
DROP VIEW IF EXISTS v_edit_inp_outfall;
DROP VIEW IF EXISTS v_edit_inp_dscenario_storage;
DROP VIEW IF EXISTS v_edit_inp_storage;
DROP VIEW IF EXISTS v_edit_inp_netgully;
DROP VIEW IF EXISTS v_edit_man_netelement;
DROP VIEW IF EXISTS v_plan_psector_budget_node;
DROP VIEW IF EXISTS v_plan_result_node;
DROP VIEW IF EXISTS v_ui_plan_node_cost;
DROP VIEW IF EXISTS v_plan_node;
DROP VIEW IF EXISTS ve_pol_chamber;
DROP VIEW IF EXISTS ve_pol_netgully;
DROP VIEW IF EXISTS ve_pol_node;
DROP VIEW IF EXISTS ve_pol_storage;
DROP VIEW IF EXISTS ve_pol_wwtp;
DROP VIEW IF EXISTS vi_coverages;
DROP VIEW IF EXISTS vi_groundwater;

DROP VIEW IF EXISTS v_edit_inp_dscenario_conduit;
DROP VIEW IF EXISTS v_edit_inp_conduit;

DROP VIEW IF EXISTS v_rtc_period_dma;
DROP VIEW IF EXISTS v_rtc_period_node;
DROP VIEW IF EXISTS v_rtc_period_pjoint;
DROP VIEW IF EXISTS v_rtc_period_hydrometer;

DROP VIEW IF EXISTS ve_pol_connec;

DROP VIEW IF EXISTS v_ui_presszone;
DROP VIEW IF EXISTS v_ui_arc_x_relations;
DROP VIEW IF EXISTS v_ui_arc_x_node;
DROP VIEW IF EXISTS v_ui_node_x_relations;

DROP VIEW IF EXISTS v_ui_element;
DROP VIEW IF EXISTS v_ui_element_x_arc;
DROP VIEW IF EXISTS v_ui_element_x_connec;
DROP VIEW IF EXISTS v_ui_element_x_node;
DROP VIEW IF EXISTS ve_pol_element;

DROP VIEW IF EXISTS v_ext_raster_dem;

DROP VIEW IF EXISTS v_plan_arc;
DROP VIEW IF EXISTS v_plan_aux_arc_pavement;

DROP VIEW IF EXISTS vi_parent_dma;
DROP VIEW IF EXISTS vi_parent_arc;
DROP VIEW IF EXISTS vi_parent_hydrometer;
DROP VIEW IF EXISTS vi_parent_connec;

DROP VIEW IF EXISTS v_edit_field_valve;
DROP VIEW IF EXISTS ve_pol_register;
DROP VIEW IF EXISTS ve_pol_tank;
DROP VIEW IF EXISTS ve_pol_fountain;
DROP VIEW IF EXISTS v_edit_inp_dscenario_pump;
DROP VIEW IF EXISTS v_edit_inp_pump_additional;
DROP VIEW IF EXISTS v_edit_inp_dscenario_pump_additional;
DROP VIEW IF EXISTS v_edit_inp_dscenario_shortpipe;
DROP VIEW IF EXISTS v_edit_inp_dscenario_connec;
DROP VIEW IF EXISTS v_edit_inp_connec;
DROP VIEW IF EXISTS v_edit_inp_shortpipe;
DROP VIEW IF EXISTS v_edit_inp_dscenario_tank;
DROP VIEW IF EXISTS v_edit_inp_tank;
DROP VIEW IF EXISTS v_edit_inp_dscenario_reservoir;
DROP VIEW IF EXISTS v_edit_inp_reservoir;
DROP VIEW IF EXISTS v_edit_inp_dscenario_valve;
DROP VIEW IF EXISTS v_edit_inp_valve;
DROP VIEW IF EXISTS v_edit_inp_dscenario_inlet;
DROP VIEW IF EXISTS v_edit_inp_inlet;

DROP VIEW IF EXISTS v_edit_inp_dscenario_demand;
DROP VIEW IF EXISTS v_edit_inp_dscenario_virtualvalve;
DROP VIEW IF EXISTS v_edit_inp_dscenario_virtualpump;
DROP VIEW IF EXISTS v_edit_inp_dscenario_pipe;
DROP VIEW IF EXISTS v_edit_inp_virtualvalve;
DROP VIEW IF EXISTS v_edit_inp_virtualpump;
DROP VIEW IF EXISTS v_edit_inp_pipe;

SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE" }}$$);

DROP VIEW IF EXISTS ve_epa_pipe;
DROP VIEW IF EXISTS ve_epa_shortpipe;
DROP VIEW IF EXISTS ve_epa_valve;

DROP VIEW IF EXISTS v_edit_arc;
DROP VIEW IF EXISTS v_edit_node;
DROP VIEW IF EXISTS v_edit_connec;

DROP VIEW IF EXISTS ve_arc CASCADE;
DROP VIEW IF EXISTS vu_arc;

DROP VIEW IF EXISTS ve_node CASCADE;
DROP VIEW IF EXISTS vu_node;

DROP VIEW IF EXISTS ve_connec CASCADE;
DROP VIEW IF EXISTS vu_connec;

DROP view if exists v_edit_link;
DROP view if exists v_edit_link_connec;
DROP view if exists v_edit_link_gully;

DROP view if exists vu_link;
DROP view if exists vu_link_connec;
DROP view if exists vu_link_gully;

DROP VIEW IF EXISTS vu_presszone;

DROP VIEW IF EXISTS v_om_mincut_hydrometer;

DROP VIEW IF EXISTS v_edit_dma;
DROP VIEW IF EXISTS v_edit_presszone;
DROP VIEW IF EXISTS v_edit_plan_netscenario_presszone;
DROP VIEW IF EXISTS v_edit_dqa;
