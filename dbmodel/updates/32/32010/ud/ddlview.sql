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
          WHERE selector_state.state_id = connec.state AND selector_state.cur_user = "current_user"()::text
        UNION
         SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_gully.gully_id AS feature_id,
            'GULLY'::text AS feature_type,
            (CASE WHEN om_visit.the_geom IS NULL THEN gully.the_geom ELSE om_visit.the_geom END)
           FROM selector_state,
            om_visit
             JOIN om_visit_x_gully ON om_visit_x_gully.visit_id = om_visit.id
             JOIN gully ON gully.gully_id::text = om_visit_x_gully.gully_id::text
             JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
          WHERE selector_state.state_id = gully.state AND selector_state.cur_user = "current_user"()::text) a;
