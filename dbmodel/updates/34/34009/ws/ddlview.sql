/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/05/09

CREATE OR REPLACE VIEW v_om_mincut_initpoint AS 
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
   FROM selector_mincut_result, om_mincut
	 LEFT JOIN om_typevalue a ON a.id::integer = mincut_state AND a.typevalue ='mincut_state'
     LEFT JOIN om_typevalue b ON b.id::integer = mincut_class AND b.typevalue ='mincut_class' 
     LEFT JOIN om_typevalue c ON c.id::integer = anl_cause::integer AND c.typevalue ='mincut_cause'
     LEFT JOIN exploitation ON om_mincut.expl_id = exploitation.expl_id
     LEFT JOIN ext_streetaxis ON om_mincut.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN macroexploitation ON om_mincut.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ext_municipality ON om_mincut.muni_id = ext_municipality.muni_id
  WHERE selector_mincut_result.result_id = om_mincut.id AND selector_mincut_result.cur_user = "current_user"()::text
  AND om_mincut.id > 0;


CREATE OR REPLACE VIEW v_om_mincut_planned_arc AS 
 SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut_arc.arc_id,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut_arc.the_geom
   FROM om_mincut_arc
     JOIN om_mincut ON om_mincut.id = om_mincut_arc.result_id
  WHERE om_mincut.mincut_state < 2;



CREATE OR REPLACE VIEW v_om_mincut_planned_valve AS 
 SELECT om_mincut_valve.id,
    om_mincut_valve.result_id,
    om_mincut_valve.node_id,
    om_mincut_valve.closed,
    om_mincut_valve.unaccess,
    om_mincut_valve.proposed,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut_valve.the_geom
   FROM om_mincut_valve
     JOIN om_mincut ON om_mincut.id = om_mincut_valve.result_id
  WHERE om_mincut.mincut_state < 2 AND om_mincut_valve.proposed = true;


CREATE OR REPLACE VIEW v_om_mincut_arc AS 
 SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut.work_order,
    om_mincut_arc.arc_id,
    arc.the_geom
   FROM selector_mincut_result,
    arc
     JOIN om_mincut_arc ON om_mincut_arc.arc_id::text = arc.arc_id::text
     JOIN om_mincut ON om_mincut_arc.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_arc.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text
  ORDER BY om_mincut_arc.arc_id;


CREATE OR REPLACE VIEW v_om_mincut_audit AS 
 SELECT audit_log_data.id,
    audit_log_data.feature_id,
    audit_log_data.log_message,
    arc.the_geom
   FROM audit_log_data
     JOIN arc ON arc.arc_id::text = audit_log_data.feature_id::text
  WHERE audit_log_data.fprocesscat_id = 29 AND audit_log_data.cur_user = "current_user"()::text
  ORDER BY audit_log_data.log_message;


CREATE OR REPLACE VIEW v_om_mincut AS 
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
   FROM selector_mincut_result, om_mincut
	 LEFT JOIN om_typevalue a ON a.id::integer = mincut_state AND a.typevalue ='mincut_state'
     LEFT JOIN om_typevalue b ON b.id::integer = mincut_class AND b.typevalue ='mincut_class' 
     LEFT JOIN om_typevalue c ON c.id::integer = anl_cause::integer AND c.typevalue ='mincut_cause'
     LEFT JOIN exploitation ON om_mincut.expl_id = exploitation.expl_id
     LEFT JOIN ext_streetaxis ON om_mincut.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN macroexploitation ON om_mincut.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ext_municipality ON om_mincut.muni_id = ext_municipality.muni_id
  WHERE selector_mincut_result.result_id = om_mincut.id AND selector_mincut_result.cur_user = "current_user"()::text
  AND om_mincut.id > 0;



CREATE OR REPLACE VIEW v_om_mincut_conflict_arc AS 
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
   FROM anl_arc
  WHERE anl_arc.fprocesscat_id = 31 AND anl_arc.cur_user::name = "current_user"();


CREATE OR REPLACE VIEW v_om_mincut_conflict_valve AS 
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
   FROM anl_node
  WHERE anl_node.fprocesscat_id = 31 AND anl_node.cur_user::name = "current_user"();



CREATE OR REPLACE VIEW v_om_mincut_connec AS 
 SELECT om_mincut_connec.id,
    om_mincut_connec.result_id,
    om_mincut.work_order,
    om_mincut_connec.connec_id,
    connec.customer_code,
    connec.the_geom
   FROM selector_mincut_result,
    connec
     JOIN om_mincut_connec ON om_mincut_connec.connec_id::text = connec.connec_id::text
     JOIN om_mincut ON om_mincut_connec.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_connec.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_om_mincut_hydrometer AS 
 SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    rtc_hydrometer_x_connec.connec_id
   FROM selector_mincut_result,
    om_mincut_hydrometer
     JOIN ext_rtc_hydrometer ON om_mincut_hydrometer.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN rtc_hydrometer_x_connec ON om_mincut_hydrometer.hydrometer_id::text = rtc_hydrometer_x_connec.hydrometer_id::text
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_hydrometer.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_om_mincut_node AS 
 SELECT om_mincut_node.id,
    om_mincut_node.result_id,
    om_mincut.work_order,
    om_mincut_node.node_id,
    node.the_geom
   FROM selector_mincut_result,
    node
     JOIN om_mincut_node ON om_mincut_node.node_id::text = node.node_id::text
     JOIN om_mincut ON om_mincut_node.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_node.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;




CREATE OR REPLACE VIEW v_om_mincut_polygon AS 
 SELECT om_mincut_polygon.id,
    om_mincut_polygon.result_id,
    om_mincut.work_order,
    om_mincut_polygon.polygon_id,
    om_mincut_polygon.the_geom
   FROM selector_mincut_result,
    om_mincut_polygon
     JOIN om_mincut ON om_mincut_polygon.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_polygon.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_om_mincut_valve AS 
 SELECT om_mincut_valve.id,
    om_mincut_valve.result_id,
    om_mincut.work_order,
    om_mincut_valve.node_id,
    om_mincut_valve.closed,
    om_mincut_valve.broken,
    om_mincut_valve.unaccess,
    om_mincut_valve.proposed,
    om_mincut_valve.the_geom
   FROM selector_mincut_result,
    om_mincut_valve
     JOIN om_mincut ON om_mincut_valve.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_valve.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;
  
  

CREATE OR REPLACE VIEW v_ui_mincut AS 
 SELECT om_mincut.id,
    om_mincut.id AS name,
    om_mincut.work_order,
    a.idval AS state,
	b.idval AS class,
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
   FROM om_mincut
	 LEFT JOIN om_typevalue a ON a.id::integer = mincut_state AND a.typevalue ='mincut_state'
     LEFT JOIN om_typevalue b ON b.id::integer = mincut_class AND b.typevalue ='mincut_class' 
     LEFT JOIN om_typevalue c ON c.id::integer = anl_cause::integer AND c.typevalue ='mincut_cause'
     LEFT JOIN exploitation ON exploitation.expl_id = om_mincut.expl_id
     LEFT JOIN macroexploitation ON macroexploitation.macroexpl_id = om_mincut.macroexpl_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = om_mincut.muni_id
     LEFT JOIN ext_streetaxis ON ext_streetaxis.id::text = om_mincut.streetaxis_id::text
     LEFT JOIN cat_users ON cat_users.id::text = om_mincut.assigned_to::text
  WHERE om_mincut.id > 0;
  
  
  ALTER TABLE v_anl_mincut_selected_valve RENAME TO v_om_mincut_selected_valve;