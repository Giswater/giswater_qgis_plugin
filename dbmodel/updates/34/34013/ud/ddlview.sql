/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



CREATE OR REPLACE VIEW v_ui_rpt_cat_result AS 
 SELECT
    rpt_cat_result.result_id,
    rpt_cat_result.flow_units,
    rpt_cat_result.rain_runof,
    rpt_cat_result.snowmelt,
    rpt_cat_result.groundw,
    rpt_cat_result.flow_rout,
    rpt_cat_result.pond_all,
    rpt_cat_result.water_q,
    rpt_cat_result.infil_m,
    rpt_cat_result.flowrout_m,
    rpt_cat_result.start_date,
    rpt_cat_result.end_date,
    rpt_cat_result.dry_days,
    rpt_cat_result.rep_tstep,
    rpt_cat_result.wet_tstep,
    rpt_cat_result.dry_tstep,
    rpt_cat_result.rout_tstep,
    rpt_cat_result.var_time_step,
    rpt_cat_result.max_trials,
    rpt_cat_result.head_tolerance,
    rpt_cat_result.exec_date
   FROM rpt_cat_result;


CREATE TRIGGER gw_trg_ui_rpt_cat_result
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_ui_rpt_cat_result
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_ui_rpt_cat_result();



CREATE OR REPLACE VIEW v_anl_flow_arc AS 
 SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
        CASE
            WHEN anl_arc.fid = 220 THEN 'Flow trace'::text
            WHEN anl_arc.fid = 221 THEN 'Flow exit'::text
            ELSE NULL::text
        END AS context,
    anl_arc.expl_id,
    anl_arc.the_geom
   FROM selector_expl,
    anl_arc
  WHERE anl_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND anl_arc.cur_user::name = "current_user"() AND (anl_arc.fid = 220 OR anl_arc.fid = 221);



CREATE OR REPLACE VIEW v_anl_flow_connec AS 
 SELECT connec.connec_id,
        CASE
            WHEN anl_arc.fid = 220 THEN 'Flow trace'::text
            WHEN anl_arc.fid = 221 THEN 'Flow exit'::text
            ELSE NULL::text
        END AS context,
    anl_arc.expl_id,
    connec.the_geom
   FROM anl_arc
     JOIN connec ON anl_arc.arc_id::text = connec.arc_id::text
     JOIN selector_expl ON anl_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND anl_arc.cur_user::name = "current_user"() AND (anl_arc.fid = 220 OR anl_arc.fid = 221);



CREATE OR REPLACE VIEW v_anl_flow_gully AS 
 SELECT v_gully.gully_id,
        CASE
            WHEN anl_arc.fid = 220 THEN 'Flow trace'::text
            WHEN anl_arc.fid = 221 THEN 'Flow exit'::text
            ELSE NULL::text
        END AS context,
    anl_arc.expl_id,
    v_gully.the_geom
   FROM anl_arc
     JOIN v_gully ON anl_arc.arc_id::text = v_gully.arc_id::text
     JOIN selector_expl ON anl_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND anl_arc.cur_user::name = "current_user"() AND (anl_arc.fid = 220 OR anl_arc.fid = 221);



CREATE OR REPLACE VIEW v_anl_flow_node AS 
 SELECT anl_node.id,
    anl_node.node_id,
    anl_node.nodecat_id AS node_type,
        CASE
            WHEN anl_node.fid = 220 THEN 'Flow trace'::text
            WHEN anl_node.fid = 221 THEN 'Flow exit'::text
            ELSE NULL::text
        END AS context,
    anl_node.expl_id,
    anl_node.the_geom
   FROM selector_expl,
    anl_node
  WHERE anl_node.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND anl_node.cur_user::name = "current_user"() AND (anl_node.fid = 220 OR anl_node.fid = 221);
