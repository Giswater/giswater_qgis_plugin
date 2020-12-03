/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/01/23

CREATE OR REPLACE VIEW v_anl_arc AS 
 SELECT anl_arc.id,
    anl_arc.arc_id,
    anl_arc.arccat_id AS arc_type,
    anl_arc.state,
    anl_arc.arc_id_aux,
    anl_arc.fprocesscat_id,
    exploitation.name AS expl_name,
    anl_arc.the_geom,
    anl_arc.result_id,
    anl_arc.descript
   FROM selector_audit,  anl_arc
   JOIN exploitation ON anl_arc.expl_id = exploitation.expl_id
   WHERE anl_arc.fprocesscat_id = selector_audit.fprocesscat_id AND selector_audit.cur_user = "current_user"()::text AND anl_arc.cur_user::name = "current_user"();

   
CREATE OR REPLACE VIEW v_anl_node AS 
 SELECT anl_node.id,
    anl_node.node_id,
    anl_node.nodecat_id,
    anl_node.state,
    anl_node.node_id_aux,
    anl_node.nodecat_id_aux AS state_aux,
    anl_node.num_arcs,
    anl_node.fprocesscat_id,
    exploitation.name AS expl_name,
    anl_node.the_geom,
    anl_node.result_id,
    anl_node.descript
   FROM selector_audit, anl_node
   JOIN exploitation ON anl_node.expl_id = exploitation.expl_id
  WHERE anl_node.fprocesscat_id = selector_audit.fprocesscat_id AND selector_audit.cur_user = "current_user"()::text AND anl_node.cur_user::name = "current_user"();

  
CREATE OR REPLACE VIEW v_anl_connec AS 
 SELECT anl_connec.id,
    anl_connec.connec_id,
    anl_connec.connecat_id,
    anl_connec.state,
    anl_connec.connec_id_aux,
    anl_connec.connecat_id_aux AS state_aux,
    anl_connec.fprocesscat_id,
    exploitation.name AS expl_name,
    anl_connec.the_geom,
    anl_connec.result_id,
    anl_connec.descript
   FROM selector_audit,  anl_connec
     JOIN exploitation ON anl_connec.expl_id = exploitation.expl_id
  WHERE anl_connec.fprocesscat_id = selector_audit.fprocesscat_id AND selector_audit.cur_user = "current_user"()::text AND anl_connec.cur_user::name = "current_user"();
