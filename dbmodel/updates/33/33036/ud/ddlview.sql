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
