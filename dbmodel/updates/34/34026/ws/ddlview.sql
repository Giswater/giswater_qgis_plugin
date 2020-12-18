/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/16
CREATE OR REPLACE VIEW v_plan_psector_arc AS
SELECT arc.arc_id,
plan_psector_x_arc.psector_id,
arc.code, 
arc.arccat_id,
cat_arc.arctype_id,
cat_feature.system_id,
arc.state AS original_state,
arc.state_type AS original_state_type,
plan_psector_x_arc.state AS plan_state,
plan_psector_x_arc.doable,
plan_psector_x_arc.addparam,
arc.the_geom
FROM selector_psector, arc
JOIN plan_psector_x_arc USING (arc_id)
JOIN cat_arc ON cat_arc.id=arc.arccat_id
JOIN cat_feature ON cat_feature.id=cat_arc.arctype_id
WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_plan_psector_node AS
SELECT node.node_id,
plan_psector_x_node.psector_id,
node.code, 
node.nodecat_id,
cat_node.nodetype_id,
cat_feature.system_id,
node.state AS original_state,
node.state_type AS original_state_type,
plan_psector_x_node.state AS plan_state,
plan_psector_x_node.doable,
node.the_geom
FROM selector_psector, node
JOIN plan_psector_x_node USING (node_id)
JOIN cat_node ON cat_node.id=node.nodecat_id
JOIN cat_feature ON cat_feature.id=cat_node.nodetype_id
WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_plan_psector_connec AS
SELECT connec.connec_id,
plan_psector_x_connec.psector_id,
connec.code, 
connec.connecat_id,
cat_connec.connectype_id,
cat_feature.system_id,
connec.state AS original_state,
connec.state_type AS original_state_type,
plan_psector_x_connec.state AS plan_state,
plan_psector_x_connec.doable,
connec.the_geom
FROM selector_psector, connec
JOIN plan_psector_x_connec USING (connec_id)
JOIN cat_connec ON cat_connec.id=connec.connecat_id
JOIN cat_feature ON cat_feature.id=cat_connec.connectype_id
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_plan_psector_link AS 
SELECT link.link_id,
plan_psector_x_connec.psector_id,
connec.connec_id,
connec.state AS original_state,
connec.state_type AS original_state_type,
plan_psector_x_connec.state AS plan_state,
plan_psector_x_connec.doable,
link.the_geom
FROM selector_psector,connec
JOIN plan_psector_x_connec USING (connec_id)
JOIN link ON link.feature_id=connec.connec_id
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    a.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_junction.demand,
    inp_junction.pattern_id,
    n.the_geom
   FROM selector_sector,
    node n
     JOIN inp_junction USING (node_id)
     JOIN vi_parent_arc a ON node_1 = node_id
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text
  UNION
   SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    a.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_junction.demand,
    inp_junction.pattern_id,
    n.the_geom
   FROM selector_sector,
    node n
     JOIN inp_junction USING (node_id)
     JOIN vi_parent_arc a ON node_2 = node_id
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text

















