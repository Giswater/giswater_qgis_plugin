/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;
--2020/03/11

DROP VIEW IF EXISTS v_anl_flow_gully;
CREATE OR REPLACE VIEW v_anl_flow_gully AS 
 SELECT v_edit_gully.gully_id,
    CASE WHEN fprocesscat_id=120 THEN 'Flow trace'
    WHEN fprocesscat_id = 121 THEN 'Flow exit' end as context,
    anl_arc.expl_id,
    v_edit_gully.the_geom
   FROM anl_arc
     JOIN v_edit_gully ON anl_arc.arc_id::text = v_edit_gully.arc_id::text
     JOIN selector_expl ON anl_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text 
     AND anl_arc.cur_user::name = "current_user"() AND (fprocesscat_id = 120 OR fprocesscat_id = 121);


DROP VIEW IF EXISTS v_anl_flow_connec;
CREATE OR REPLACE VIEW v_anl_flow_connec AS 
 SELECT v_edit_connec.connec_id,
    CASE WHEN fprocesscat_id=120 THEN 'Flow trace'
    WHEN fprocesscat_id = 121 THEN 'Flow exit' end as context,
    anl_arc.expl_id,
    v_edit_connec.the_geom
   FROM anl_arc
     JOIN v_edit_connec ON anl_arc.arc_id::text = v_edit_connec.arc_id::text
     JOIN selector_expl ON anl_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text 
     AND anl_arc.cur_user::name = "current_user"() AND (fprocesscat_id = 120 OR fprocesscat_id = 121);


DROP VIEW IF EXISTS v_anl_flow_arc;
CREATE OR REPLACE VIEW v_anl_flow_arc AS 
 SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id as arc_type,
    CASE WHEN fprocesscat_id=120 THEN 'Flow trace'
    WHEN fprocesscat_id = 121 THEN 'Flow exit' end as context,
    anl_arc.expl_id,
    anl_arc.the_geom
   FROM selector_expl,
    anl_arc
  WHERE anl_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text 
  AND anl_arc.cur_user::name = "current_user"() AND (fprocesscat_id = 120 OR fprocesscat_id = 121);


DROP VIEW IF EXISTS v_anl_flow_node;
CREATE OR REPLACE VIEW v_anl_flow_node AS 
 SELECT anl_node.id ,
    anl_node.node_id,
    anl_node.nodecat_id as node_type,
    CASE WHEN fprocesscat_id=120 THEN 'Flow trace'
    WHEN fprocesscat_id = 121 THEN 'Flow exit' end as context,
    anl_node.expl_id,
    anl_node.the_geom
   FROM selector_expl,
    anl_node
  WHERE anl_node.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND 
  anl_node.cur_user::name = "current_user"() AND (fprocesscat_id = 120 OR fprocesscat_id = 121);


--2020/03/13
DROP VIEW IF EXISTS v_ui_node_x_connection_downstream;
CREATE OR REPLACE VIEW v_ui_node_x_connection_downstream AS 
 SELECT row_number() OVER (ORDER BY v_edit_arc.node_1)+1000000 AS rid,
    v_edit_arc.node_1 AS node_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code AS feature_code,
    v_edit_arc.arc_type AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y2 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS downstream_id,
    node.code AS downstream_code,
    node.node_type AS downstream_type,
    v_edit_arc.y1 AS downstream_depth,
    sys_type,
    st_x(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_edit_arc'::text as sys_table_id
   FROM v_edit_arc
     JOIN node ON v_edit_arc.node_2::text = node.node_id::text
     JOIN arc_type ON arc_type.id::text = v_edit_arc.arc_type::text
     LEFT JOIN cat_arc ON v_edit_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON v_edit_arc.state = value_state.id;

