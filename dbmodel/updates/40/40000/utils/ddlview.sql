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
DROP VIEW IF EXISTS v_plan_netscenario_arc;
DROP VIEW IF EXISTS v_plan_netscenario_node;
DROP VIEW IF EXISTS v_plan_netscenario_connec;
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

DROP VIEW IF EXISTS v_edit_review_connec;
DROP VIEW IF EXISTS v_edit_review_gully;

SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE" }}$$);

DROP VIEW IF EXISTS ve_epa_pipe;
DROP VIEW IF EXISTS ve_epa_shortpipe;
DROP VIEW IF EXISTS ve_epa_virtualvalve;
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

DROP view IF EXISTS v_edit_link;
DROP view IF EXISTS v_edit_link_connec;
DROP view IF EXISTS v_edit_link_gully;

DROP VIEW IF EXISTS v_edit_minsector;
DROP VIEW IF EXISTS v_edit_samplepoint;

DROP VIEW IF EXISTS v_plan_psector_gully;
DROP VIEW IF EXISTS v_ui_element_x_gully;
DROP VIEW IF EXISTS vi_gully2node;
DROP VIEW IF EXISTS ve_pol_gully;
DROP VIEW IF EXISTS v_edit_inp_gully;

DROP VIEW IF EXISTS v_edit_gully;
DROP VIEW IF EXISTS v_edit_element;

DROP VIEW IF EXISTS ve_gully;
DROP VIEW IF EXISTS vu_gully;

DROP view IF EXISTS vu_link;
DROP view IF EXISTS vu_link_connec;
DROP view IF EXISTS vu_link_gully;

DROP VIEW IF EXISTS v_edit_presszone;
DROP VIEW IF EXISTS vu_presszone;

DROP VIEW IF EXISTS v_om_mincut_hydrometer;

DROP VIEW IF EXISTS v_edit_dma;
DROP VIEW IF EXISTS vu_dma;
DROP VIEW IF EXISTS v_edit_plan_netscenario_presszone;
DROP VIEW IF EXISTS v_edit_dqa;
DROP VIEW IF EXISTS vu_dqa;

DROP VIEW IF EXISTS v_state_link;
DROP VIEW IF EXISTS v_state_connec;

DROP VIEW IF EXISTS v_edit_pond;
DROP VIEW IF EXISTS v_edit_pool;
DROP VIEW IF EXISTS v_om_waterbalance_report;
DROP VIEW IF EXISTS v_ui_dma;
DROP VIEW IF EXISTS v_om_waterbalance;

DROP VIEW IF EXISTS v_ui_dqa;

DROP VIEW IF EXISTS v_ui_sector;
DROP VIEW IF EXISTS v_edit_sector;
DROP VIEW IF EXISTS vu_sector;

-- 30/10/2024

CREATE OR REPLACE VIEW vcp_pipes AS
 SELECT p.arc_id,
    p.minorloss,
    p.dint, p.dscenario_id
   FROM config_param_user c, selector_inp_result r, rpt_inp_arc rpt
   JOIN inp_dscenario_pipe p ON rpt.arc_id = p.arc_id
   WHERE c.parameter::text = 'epatools_calibrator_dscenario_id'::text AND c.value = p.dscenario_id::text
   AND c.cur_user = "current_user"()::text AND r.result_id = rpt.result_id AND r.cur_user = "current_user"()::text;
ALTER TABLE vcp_pipes
  OWNER TO role_admin;
GRANT ALL ON TABLE vcp_pipes TO role_admin;
GRANT ALL ON TABLE vcp_pipes TO role_basic;


CREATE OR REPLACE VIEW vcv_times AS
 SELECT rpt.result_id,
    rpt.inp_options ->> 'inp_times_duration'::text AS duration
   FROM selector_inp_result r, rpt_cat_result rpt
   WHERE r.result_id = rpt.result_id AND r.cur_user = "current_user"()::text;
ALTER TABLE vcv_times
  OWNER TO role_admin;
GRANT ALL ON TABLE vcv_times TO role_admin;
GRANT ALL ON TABLE vcv_times TO role_basic;


CREATE OR REPLACE VIEW vcv_dma AS
 SELECT ext_rtc_dma_period.id,
    ext_rtc_dma_period.dma_id,
    ext_rtc_dma_period.cat_period_id AS period_id,
    ext_rtc_dma_period.effc,
    ext_rtc_dma_period.pattern_id
   FROM ext_rtc_dma_period;

ALTER TABLE vcv_dma
  OWNER TO role_admin;
GRANT ALL ON TABLE vcv_dma TO role_admin;
GRANT ALL ON TABLE vcv_dma TO role_basic;


CREATE OR REPLACE VIEW vcv_junction AS
SELECT rpt.node_id,
    rpt.dma_id
   FROM selector_inp_result r,
    rpt_inp_node rpt
  WHERE r.result_id::text = rpt.result_id::text AND r.cur_user = "current_user"()::text AND rpt.epa_type = 'JUNCTION';

ALTER TABLE vcv_junction
  OWNER TO role_admin;
GRANT ALL ON TABLE vcv_junction TO role_admin;
GRANT ALL ON TABLE vcv_junction TO role_basic;


CREATE OR REPLACE VIEW vcv_demands AS
 SELECT inp.feature_id, inp.demand, inp.pattern_id, inp.source, dscenario_id
   FROM config_param_user c, inp_dscenario_demand inp
   WHERE c.parameter::text = 'epatools_calibrator_dscenario_id'::text AND c.value = inp.dscenario_id::text
   AND c.cur_user = "current_user"()::text;

ALTER TABLE vcv_demands
  OWNER TO role_admin;
GRANT ALL ON TABLE vcv_demands TO role_admin;
GRANT ALL ON TABLE vcv_demands TO role_basic;


CREATE OR REPLACE VIEW vcv_patterns AS
 SELECT patt.*
   FROM selector_inp_result r, rpt_inp_pattern_value patt
   WHERE r.result_id = patt.result_id AND r.cur_user = "current_user"()::text;;

ALTER TABLE vcv_patterns
  OWNER TO role_admin;
GRANT ALL ON TABLE vcv_patterns TO role_admin;
GRANT ALL ON TABLE vcv_patterns TO role_basic;


CREATE OR REPLACE VIEW vcv_emitters AS
  SELECT DISTINCT node_id, sum(length/10000) as coef
    FROM selector_inp_result r,rpt_inp_arc a
    JOIN rpt_inp_node n USING(result_id)
    WHERE (a.node_1 = n.node_id OR a.node_2 = n.node_id) and r.result_id = n.result_id
    AND r.cur_user = "current_user"()::text
    GROUP BY node_id;

ALTER TABLE vcv_emitters
  OWNER TO role_admin;
GRANT ALL ON TABLE vcv_emitters TO role_admin;
GRANT ALL ON TABLE vcv_emitters TO role_basic;


CREATE OR REPLACE VIEW vcv_emitters_log
 AS
 SELECT DISTINCT n.node_id, n.dma_id,
    sum(a.length / 10000::numeric) AS c0_default,
	NULL::numeric AS c0_updated
   FROM selector_inp_result r,
    rpt_inp_arc a
     JOIN rpt_inp_node n USING (result_id)
  WHERE (a.node_1::text = n.node_id::text OR a.node_2::text = n.node_id::text) AND r.result_id::text = n.result_id::text AND r.cur_user = "current_user"()::text
  GROUP BY n.node_id, n.dma_id;

ALTER TABLE vcv_emitters_log
    OWNER TO role_admin;


CREATE OR REPLACE VIEW vcv_dma_log
 AS
 SELECT DISTINCT
    n.dma_id,
    NULL::numeric AS coef
   FROM selector_inp_result r,
    rpt_inp_arc a
     JOIN rpt_inp_node n USING (result_id)
  WHERE (a.node_1::text = n.node_id::text OR a.node_2::text = n.node_id::text) AND r.result_id::text = n.result_id::text AND r.cur_user = "current_user"()::text
  GROUP BY n.node_id, n.dma_id;

ALTER TABLE vcv_dma_log
    OWNER TO role_admin;

GRANT ALL ON TABLE vcv_dma_log TO role_basic;
GRANT ALL ON TABLE vcv_dma_log TO role_admin;
