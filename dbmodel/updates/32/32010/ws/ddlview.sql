/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


DROP VIEW v_om_visit;
CREATE OR REPLACE VIEW v_om_visit AS 
 SELECT DISTINCT ON (a.visit_id) a.visit_id,
    a.code,
    a.visitcat_id,
    a.name,
    a.visit_start,
    a.visit_end,
    a.user_name,
    a.is_done,
    a.feature_id,
    a.feature_type,
    a.the_geom
   FROM ( SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_node.node_id AS feature_id,
            'NODE'::text AS feature_type,
            (CASE WHEN om_visit.the_geom IS NULL THEN node.the_geom ELSE om_visit.the_geom END)
           FROM selector_state,
            om_visit
             JOIN om_visit_x_node ON om_visit_x_node.visit_id = om_visit.id
             JOIN node ON node.node_id::text = om_visit_x_node.node_id::text
             JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
          WHERE selector_state.state_id = node.state AND selector_state.cur_user = "current_user"()::text
        UNION
         SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_arc.arc_id AS feature_id,
            'ARC'::text AS feature_type,
            (CASE WHEN om_visit.the_geom IS NULL THEN st_lineinterpolatepoint(arc.the_geom,0.5) ELSE om_visit.the_geom END)
           FROM selector_state,
            om_visit
             JOIN om_visit_x_arc ON om_visit_x_arc.visit_id = om_visit.id
             JOIN arc ON arc.arc_id::text = om_visit_x_arc.arc_id::text
             JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
          WHERE selector_state.state_id = arc.state AND selector_state.cur_user = "current_user"()::text
        UNION
         SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_connec.connec_id AS feature_id,
            'CONNEC'::text AS feature_type,
            (CASE WHEN om_visit.the_geom IS NULL THEN connec.the_geom ELSE om_visit.the_geom END)
           FROM selector_state,
            om_visit
             JOIN om_visit_x_connec ON om_visit_x_connec.visit_id = om_visit.id
             JOIN connec ON connec.connec_id::text = om_visit_x_connec.connec_id::text
             JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
          WHERE selector_state.state_id = connec.state AND selector_state.cur_user = "current_user"()::text) a;
		  
		  

DROP VIEW v_rtc_hydrometer_x_node_period;
CREATE OR REPLACE VIEW v_rtc_hydrometer_x_node_period AS 
 SELECT a.hydrometer_id,
    a.node_1 AS node_id,
    a.arc_id,
    b.dma_id,
    b.period_id,
    b.lps_avg * 0.5::double precision AS lps_avg_real,
    c.effc::numeric(5,4) AS losses,
    b.lps_avg * 0.5::double precision / c.effc AS lps_avg,
    c.minc AS cmin,
    b.lps_avg * 0.5::double precision / c.effc * c.minc AS lps_min,
    c.maxc AS cmax,
    b.lps_avg * 0.5::double precision / c.effc * c.maxc AS lps_max,
    pattern_id
   FROM v_rtc_hydrometer_x_arc a
     JOIN v_rtc_hydrometer_period b ON b.hydrometer_id::bigint = a.hydrometer_id::bigint
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = b.period_id::text AND c.dma_id::text = b.dma_id::text
UNION
 SELECT a.hydrometer_id,
    a.node_2 AS node_id,
    a.arc_id,
    b.dma_id,
    b.period_id,
    b.lps_avg * 0.5::double precision AS lps_avg_real,
    c.effc::numeric(5,4) AS losses,
    b.lps_avg * 0.5::double precision / c.effc AS lps_avg,
    c.minc AS cmin,
    b.lps_avg * 0.5::double precision / c.effc * c.minc AS lps_min,
    c.maxc AS cmax,
    b.lps_avg * 0.5::double precision / c.effc * c.maxc AS lps_max,
    pattern_id
   FROM v_rtc_hydrometer_x_arc a
     JOIN v_rtc_hydrometer_period b ON b.hydrometer_id::bigint = a.hydrometer_id::bigint
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = b.period_id::text AND c.dma_id::text = b.dma_id::text;

