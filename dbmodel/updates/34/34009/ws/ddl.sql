/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/09
ALTER TABLE anl_mincut_inlet_x_exploitation RENAME to config_mincut_inlet;
ALTER TABLE anl_mincut_selector_valve RENAME to config_mincut_valve;
ALTER TABLE anl_mincut_checkvalve RENAME to config_mincut_checkvalve;

ALTER TABLE anl_mincut_result_selector RENAME to selector_mincut_result ;
ALTER TABLE inp_selector_dscenario RENAME to selector_inp_demand;
ALTER TABLE rpt_selector_hourly_compare RENAME to selector_rpt_compare_tstep;
ALTER TABLE rpt_selector_hourly RENAME to selector_rpt_main_tstep;

-- remove id from selectors
ALTER TABLE selector_inp_demand DROP CONSTRAINT dscenario_id_cur_user_unique;
ALTER TABLE selector_inp_demand DROP CONSTRAINT inp_selector_dscenario_pkey;
ALTER TABLE selector_inp_demand ADD CONSTRAINT selector_inp_demand_pkey PRIMARY KEY(dscenario_id, cur_user);
ALTER TABLE selector_inp_demand DROP COLUMN id;

ALTER TABLE selector_mincut_result DROP CONSTRAINT result_id_cur_user_unique;
ALTER TABLE selector_mincut_result DROP CONSTRAINT anl_mincut_result_selector_pkey;
ALTER TABLE selector_mincut_result ADD CONSTRAINT selector_mincut_result_pkey PRIMARY KEY(result_id, cur_user);
ALTER TABLE selector_mincut_result DROP COLUMN id;

ALTER TABLE selector_rpt_compare DROP CONSTRAINT rpt_selector_compare_result_id_cur_user_unique;
ALTER TABLE selector_rpt_compare DROP CONSTRAINT rpt_selector_compare_pkey;
ALTER TABLE selector_rpt_compare ADD CONSTRAINT selector_rpt_compare_pkey PRIMARY KEY(result_id, cur_user);
ALTER TABLE selector_rpt_compare DROP COLUMN id;

ALTER TABLE selector_rpt_compare_tstep DROP CONSTRAINT rpt_selector_result_hourly_compare_pkey;
ALTER TABLE selector_rpt_compare_tstep ADD CONSTRAINT selector_rpt_compare_tstep_pkey PRIMARY KEY("time", cur_user);
ALTER TABLE selector_rpt_compare_tstep DROP COLUMN id;

ALTER TABLE selector_rpt_main DROP CONSTRAINT rpt_selector_result_id_cur_user_unique;
ALTER TABLE selector_rpt_main DROP CONSTRAINT rpt_selector_result_pkey;
ALTER TABLE selector_rpt_main ADD CONSTRAINT selector_rpt_main_pkey PRIMARY KEY(result_id, cur_user);
ALTER TABLE selector_rpt_main DROP COLUMN id;

ALTER TABLE selector_rpt_main_tstep DROP CONSTRAINT rpt_selector_result_hourly_pkey;
ALTER TABLE selector_rpt_main_tstep ADD CONSTRAINT selector_rpt_main_tstep_pkey PRIMARY KEY("time", cur_user);
ALTER TABLE selector_rpt_main_tstep DROP COLUMN id;

ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_cat_seq RENAME TO om_mincut_seq;
  
-- harmonize mincut
ALTER TABLE anl_mincut_cat_cause RENAME to _anl_mincut_cat_cause_;
ALTER TABLE anl_mincut_cat_class RENAME to _anl_mincut_cat_class_;
ALTER TABLE anl_mincut_cat_state RENAME to _anl_mincut_cat_state_;
ALTER TABLE anl_mincut_cat_type RENAME to om_mincut_cat_type;
ALTER TABLE anl_mincut_result_cat RENAME to om_mincut;
ALTER TABLE anl_mincut_result_arc RENAME to om_mincut_arc;
ALTER TABLE anl_mincut_result_node RENAME to om_mincut_node;
ALTER TABLE anl_mincut_result_connec RENAME to om_mincut_connec;
ALTER TABLE anl_mincut_result_hydrometer RENAME to om_mincut_hydrometer;
ALTER TABLE anl_mincut_result_polygon RENAME to om_mincut_polygon;
ALTER TABLE anl_mincut_result_valve RENAME to om_mincut_valve;
ALTER TABLE anl_mincut_result_valve_unaccess RENAME to om_mincut_valve_unaccess;





CREATE OR REPLACE VIEW ws8.v_om_mincut_initpoint AS 
 SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
	b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    ext_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om_mincut.postnumber,
	c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.notified,
	om_mincut.output
   FROM ws8.selector_mincut_result,
    ws8.om_mincut
     LEFT JOIN ws8.om_typvalue a ON a.id = mincut_state AND typevalue ='mincut_state'
     LEFT JOIN ws8.om_typvalue b ON b.id = mincut_class AND typevalue ='mincut_classº' 
     LEFT JOIN ws8.om_typvalue c ON c.id = anl_cause AND typevalue ='mincut_cause'
     LEFT JOIN ws8.exploitation ON om_mincut.expl_id = exploitation.expl_id
     LEFT JOIN ws8.ext_streetaxis ON om_mincut.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN ws8.macroexploitation ON om_mincut.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ws8.ext_municipality ON om_mincut.muni_id = ext_municipality.muni_id
  WHERE selector_mincut_result.result_id = om_mincut.id AND selector_mincut_result.cur_user = "current_user"()::text
  AND om_mincut.id > 0;


CREATE OR REPLACE VIEW ws8.v_om_mincut_planned_arc AS 
 SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut_arc.arc_id,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut_arc.the_geom
   FROM ws8.om_mincut_arc
     JOIN ws8.om_mincut ON om_mincut.id = om_mincut_arc.result_id
  WHERE om_mincut.mincut_state < 2;



CREATE OR REPLACE VIEW ws8.v_om_mincut_planned_valve AS 
 SELECT om_mincut_valve.id,
    om_mincut_valve.result_id,
    om_mincut_valve.node_id,
    om_mincut_valve.closed,
    om_mincut_valve.unaccess,
    om_mincut_valve.proposed,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut_valve.the_geom
   FROM ws8.om_mincut_valve
     JOIN ws8.om_mincut ON om_mincut.id = om_mincut_valve.result_id
  WHERE om_mincut.mincut_state < 2 AND om_mincut_valve.proposed = true;


CREATE OR REPLACE VIEW ws8.v_om_mincut_arc AS 
 SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut.work_order,
    om_mincut_arc.arc_id,
    arc.the_geom
   FROM ws8.selector_mincut_result,
    ws8.arc
     JOIN ws8.om_mincut_arc ON om_mincut_arc.arc_id::text = arc.arc_id::text
     JOIN ws8.om_mincut ON om_mincut_arc.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_arc.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text
  ORDER BY om_mincut_arc.arc_id;


CREATE OR REPLACE VIEW ws8.v_om_mincut_audit AS 
 SELECT audit_log_data.id,
    audit_log_data.feature_id,
    audit_log_data.log_message,
    arc.the_geom
   FROM ws8.audit_log_data
     JOIN ws8.arc ON arc.arc_id::text = audit_log_data.feature_id::text
  WHERE audit_log_data.fprocesscat_id = 29 AND audit_log_data.cur_user = "current_user"()::text
  ORDER BY audit_log_data.log_message;


CREATE OR REPLACE VIEW ws8.v_om_mincut AS 
 SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
	b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    ext_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om_mincut.postnumber,
	c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_the_geom,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.notified,
	om_mincut.output
   FROM ws8.selector_mincut_result,
    ws8.om_mincut
     LEFT JOIN ws8.om_typvalue a ON a.id = mincut_state AND typevalue ='mincut_state'
     LEFT JOIN ws8.om_typvalue b ON b.id = mincut_class AND typevalue ='mincut_classº' 
     LEFT JOIN ws8.om_typvalue c ON c.id = anl_cause AND typevalue ='mincut_cause'
     LEFT JOIN ws8.exploitation ON om_mincut.expl_id = exploitation.expl_id
     LEFT JOIN ws8.ext_streetaxis ON om_mincut.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN ws8.macroexploitation ON om_mincut.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ws8.ext_municipality ON om_mincut.muni_id = ext_municipality.muni_id
  WHERE selector_mincut_result.result_id = om_mincut.id AND selector_mincut_result.cur_user = "current_user"()::text
  AND om_mincut.id > 0;



CREATE OR REPLACE VIEW ws8.v_om_mincut_conflict_arc AS 
 SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
    anl_arc.state,
    anl_arc.arc_id_aux,
    anl_arc.expl_id,
    anl_arc.fprocesscat_id,
    anl_arc.cur_user,
    anl_arc.the_geom,
    anl_arc.the_geom_p
   FROM ws8.anl_arc
  WHERE anl_arc.fprocesscat_id = 31 AND anl_arc.cur_user::name = "current_user"();


CREATE OR REPLACE VIEW ws8.v_om_mincut_conflict_valve AS 
 SELECT anl_node.id,
    anl_node.node_id,
    anl_node.nodecat_id,
    anl_node.state,
    anl_node.num_arcs,
    anl_node.node_id_aux,
    anl_node.nodecat_id_aux,
    anl_node.state_aux,
    anl_node.expl_id,
    anl_node.fprocesscat_id,
    anl_node.cur_user,
    anl_node.the_geom
   FROM ws8.anl_node
  WHERE anl_node.fprocesscat_id = 31 AND anl_node.cur_user::name = "current_user"();



CREATE OR REPLACE VIEW ws8.v_om_mincut_connec AS 
 SELECT om_mincut_connec.id,
    om_mincut_connec.result_id,
    om_mincut.work_order,
    om_mincut_connec.connec_id,
    connec.customer_code,
    connec.the_geom
   FROM ws8.selector_mincut_result,
    ws8.connec
     JOIN ws8.om_mincut_connec ON om_mincut_connec.connec_id::text = connec.connec_id::text
     JOIN ws8.om_mincut ON om_mincut_connec.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_connec.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW ws8.v_om_mincut_hydrometer AS 
 SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    rtc_hydrometer_x_connec.connec_id
   FROM ws8.selector_mincut_result,
    ws8.om_mincut_hydrometer
     JOIN ws8.ext_rtc_hydrometer ON om_mincut_hydrometer.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ws8.rtc_hydrometer_x_connec ON om_mincut_hydrometer.hydrometer_id::text = rtc_hydrometer_x_connec.hydrometer_id::text
     JOIN ws8.om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_hydrometer.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW ws8.v_om_mincut_node AS 
 SELECT om_mincut_node.id,
    om_mincut_node.result_id,
    om_mincut.work_order,
    om_mincut_node.node_id,
    node.the_geom
   FROM ws8.selector_mincut_result,
    ws8.node
     JOIN ws8.om_mincut_node ON om_mincut_node.node_id::text = node.node_id::text
     JOIN ws8.om_mincut ON om_mincut_node.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_node.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;




CREATE OR REPLACE VIEW ws8.v_om_mincut_polygon AS 
 SELECT om_mincut_polygon.id,
    om_mincut_polygon.result_id,
    om_mincut.work_order,
    om_mincut_polygon.polygon_id,
    om_mincut_polygon.the_geom
   FROM ws8.selector_mincut_result,
    ws8.om_mincut_polygon
     JOIN ws8.om_mincut ON om_mincut_polygon.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_polygon.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW ws8.v_om_mincut_valve AS 
 SELECT om_mincut_valve.id,
    om_mincut_valve.result_id,
    om_mincut.work_order,
    om_mincut_valve.node_id,
    om_mincut_valve.closed,
    om_mincut_valve.broken,
    om_mincut_valve.unaccess,
    om_mincut_valve.proposed,
    om_mincut_valve.the_geom
   FROM ws8.selector_mincut_result,
    ws8.om_mincut_valve
     JOIN ws8.om_mincut ON om_mincut_valve.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_valve.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;
  
  

CREATE OR REPLACE VIEW ws8.v_ui_mincut AS 
 SELECT om_mincut.id,
    om_mincut.id AS name,
    om_mincut.work_order,
    a.idval AS state,
	b.idval AS clas
    om_mincut.mincut_type,
    om_mincut.received_date,
    exploitation.name AS exploitation,
    ext_municipality.name AS municipality,
    om_mincut.postcode,
    ext_streetaxis.name AS streetaxis,
    om_mincut.postnumber,
	c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    cat_users.name AS assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.notified,
    om_mincut.output
   FROM ws8.om_mincut
     LEFT JOIN ws8.om_typvalue a ON a.id = mincut_state AND typevalue ='mincut_state'
     LEFT JOIN ws8.om_typvalue b ON b.id = mincut_class AND typevalue ='mincut_classº' 
     LEFT JOIN ws8.om_typvalue c ON c.id = anl_cause AND typevalue ='mincut_cause'e
     LEFT JOIN ws8.exploitation ON exploitation.expl_id = om_mincut.expl_id
     LEFT JOIN ws8.macroexploitation ON macroexploitation.macroexpl_id = om_mincut.macroexpl_id
     LEFT JOIN ws8.ext_municipality ON ext_municipality.muni_id = om_mincut.muni_id
     LEFT JOIN ws8.ext_streetaxis ON ext_streetaxis.id::text = om_mincut.streetaxis_id::text
     LEFT JOIN ws8.cat_users ON cat_users.id::text = om_mincut.assigned_to::text
  WHERE om_mincut.id > 0;
  
  
  ALTER TABLE v_anl_mincut_selected_valve RENAME TO v_om_mincut_selected_valve;