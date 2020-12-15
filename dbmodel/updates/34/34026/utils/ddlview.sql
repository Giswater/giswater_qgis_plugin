/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/15
DROP VIEW IF EXISTS v_plan_psector_arc;
CREATE OR REPLACE VIEW v_plan_psector_arc AS
SELECT arc.arc_id,
plan_psector_x_arc.psector_id,
arc.code, 
arc.arccat_id,
arc.state AS original_state,
arc.state_type AS original_state_type,
plan_psector_x_arc.state AS plan_state,
plan_psector_x_arc.doable,
plan_psector_x_arc.addparam,
arc.the_geom
FROM selector_psector, arc
JOIN plan_psector_x_arc USING (arc_id)
WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_plan_psector_node;
CREATE OR REPLACE VIEW v_plan_psector_node AS
SELECT node.node_id,
plan_psector_x_node.psector_id,
node.code, 
node.nodecat_id,
node.state AS original_state,
node.state_type AS original_state_type,
plan_psector_x_node.state AS plan_state,
plan_psector_x_node.doable,
node.the_geom
FROM selector_psector, node
JOIN plan_psector_x_node USING (node_id)
WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_plan_psector_connec;
CREATE OR REPLACE VIEW v_plan_psector_connec AS
SELECT connec.connec_id,
plan_psector_x_connec.psector_id,
connec.code, 
connec.connecat_id,
connec.state AS original_state,
connec.state_type AS original_state_type,
plan_psector_x_connec.state AS plan_state,
plan_psector_x_connec.doable,
connec.the_geom
FROM selector_psector, connec
JOIN plan_psector_x_connec USING (connec_id)
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;