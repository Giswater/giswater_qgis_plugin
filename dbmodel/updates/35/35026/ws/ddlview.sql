/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/07
DROP VIEW v_om_mincut_node;
CREATE OR REPLACE VIEW v_om_mincut_node AS 
 SELECT om_mincut_node.id,
    om_mincut_node.result_id,
    om_mincut.work_order,
    om_mincut_node.node_id,
    nodetype_id,
    om_mincut_node.the_geom
   FROM selector_mincut_result,
    node
     JOIN om_mincut_node ON om_mincut_node.node_id::text = node.node_id::text
     JOIN om_mincut ON om_mincut_node.result_id = om_mincut.id
     JOIN cat_node ON nodecat_id=cat_node.id
  WHERE selector_mincut_result.result_id::text = om_mincut_node.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_om_mincut_arc AS 
 SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut.work_order,
    om_mincut_arc.arc_id,
    om_mincut_arc.the_geom
   FROM selector_mincut_result,
    arc
     JOIN om_mincut_arc ON om_mincut_arc.arc_id::text = arc.arc_id::text
     JOIN om_mincut ON om_mincut_arc.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_arc.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text
  ORDER BY om_mincut_arc.arc_id;
  
CREATE OR REPLACE VIEW v_om_mincut_connec AS 
 SELECT om_mincut_connec.id,
    om_mincut_connec.result_id,
    om_mincut.work_order,
    om_mincut_connec.connec_id,
    connec.customer_code,
    om_mincut_connec.the_geom
   FROM selector_mincut_result,
    connec
     JOIN om_mincut_connec ON om_mincut_connec.connec_id::text = connec.connec_id::text
     JOIN om_mincut ON om_mincut_connec.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_connec.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;
