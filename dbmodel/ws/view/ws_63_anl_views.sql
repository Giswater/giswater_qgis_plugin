/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Consistency
-- ----------------------------

DROP VIEW IF EXISTS v_anl_topological_consistency CASCADE;
CREATE OR REPLACE VIEW v_anl_topological_consistency AS
SELECT
anl_node_topological_consistency.node_id,
node_type,
num_arcs,
anl_node_topological_consistency.the_geom,
node.expl_id
FROM selector_expl, anl_node_topological_consistency
JOIN node ON node.node_id=anl_node_topological_consistency.node_id
WHERE ((node.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());



-- ----------------------------
-- MINCUT
-- ----------------------------

DROP VIEW IF EXISTS v_anl_mincut_valve CASCADE;
CREATE OR REPLACE VIEW v_anl_mincut_valve AS 
SELECT 
v_edit_node.node_id,
cat_node.nodetype_id,
closed,
broken,
the_geom
FROM v_edit_node
JOIN cat_node ON v_edit_node.node.nodecat_id=cat_node.id
JOIN man_valve ON v_edit_node.node_id=man_valve.node_id
JOIN anl_mincut_selector_valve ON cat_node.nodetype_id=anl_mincut_selector_valve.id;



-- ----------------------------
-- MINCUT CATALOG
-- ----------------------------


DROP VIEW IF EXISTS "v_anl_mincut_result_arc" CASCADE; 
CREATE VIEW "v_anl_mincut_result_arc" AS 
SELECT 
anl_mincut_result_arc.id,
anl_mincut_result_arc.result_id,
anl_mincut_result_arc.arc_id,  
arc.the_geom 
FROM arc, anl_mincut_result_selector
JOIN anl_mincut_result_arc ON (((anl_mincut_result_arc.arc_id) = (arc_id)))
WHERE (((anl_mincut_result_selector.result_id) = (anl_mincut_result_arc.result_id))) 
AND anl_mincut_result_selector.cur_user="current_user"() 
GROUP BY anl_mincut_result_arc.id, anl_mincut_result_selector.result_id, arc.the_geom
ORDER BY anl_mincut_result_arc.arc_id;



DROP VIEW IF EXISTS "v_anl_mincut_result_node" CASCADE; 
CREATE VIEW "v_anl_mincut_result_node" AS
SELECT 
anl_mincut_result_node.id,
anl_mincut_result_node.result_id,
anl_mincut_result_node.node_id,  
node.the_geom 
FROM anl_mincut_result_selector, node
JOIN anl_mincut_result_node ON ((anl_mincut_result_node.node_id) = (node.node_id))
WHERE ((anl_mincut_result_selector.result_id) = (anl_mincut_result_node.result_id)) 
AND anl_mincut_result_selector.cur_user="current_user"()
GROUP BY anl_mincut_result_node.id, anl_mincut_result_selector.result_id, node.the_geom
ORDER BY anl_mincut_result_node.node_id;


DROP VIEW IF EXISTS "v_anl_mincut_result_valve" CASCADE; -- to do!
CREATE VIEW "v_anl_mincut_result_valve" AS
SELECT 
anl_mincut_result_valve.result_id,
node_id,
closed,
broken,
unaccess,
proposed,
the_geom
FROM anl_mincut_result_selector, anl_mincut_result_valve 
WHERE ((anl_mincut_result_selector.id) = (anl_mincut_result_valve.result_id))
AND anl_mincut_result_selector.cur_user="current_user"();



DROP VIEW IF EXISTS "v_anl_mincut_result_connec";
CREATE OR REPLACE VIEW "v_anl_mincut_result_connec" AS 
SELECT
anl_mincut_result_connec.id,
anl_mincut_result_connec.result_id,
anl_mincut_result_connec.connec_id,  
connec.the_geom 
FROM anl_mincut_result_selector, connec
JOIN anl_mincut_result_connec ON (((anl_mincut_result_connec.connec_id) = (connec.connec_id)))
WHERE ((anl_mincut_result_selector.result_id) = (anl_mincut_result_connec.result_id))
AND anl_mincut_result_selector.cur_user="current_user"()
GROUP BY anl_mincut_result_connec.id, anl_mincut_result_selector.result_id, connec.the_geom
ORDER BY anl_mincut_result_connec.connec_id;


DROP VIEW IF EXISTS "v_anl_mincut_result_polygon";
CREATE OR REPLACE VIEW "v_anl_mincut_result_polygon" AS 
SELECT
anl_mincut_result_polygon.id,
anl_mincut_result_polygon.result_id,
anl_mincut_result_polygon.polygon_id,  
anl_mincut_result_polygon.the_geom 
FROM anl_mincut_result_polygon,anl_mincut_result_selector
WHERE ((anl_mincut_result_selector.result_id) = (anl_mincut_result_polygon.result_id))
AND anl_mincut_result_selector.cur_user="current_user"()
GROUP BY anl_mincut_result_polygon.id, anl_mincut_result_selector.result_id, anl_mincut_result_polygon.the_geom
ORDER BY anl_mincut_result_polygon.polygon_id;




DROP VIEW IF EXISTS "v_anl_mincut_result_hydrometer";
CREATE OR REPLACE VIEW "v_anl_mincut_result_hydrometer" AS 
SELECT
anl_mincut_result_hydrometer.id,
anl_mincut_result_hydrometer.result_id,
anl_mincut_result_hydrometer.hydrometer_id
FROM anl_mincut_result_hydrometer,anl_mincut_result_selector
WHERE ((anl_mincut_result_selector.result_id) = (anl_mincut_result_hydrometer.result_id))
AND anl_mincut_result_selector.cur_user="current_user"() 
GROUP BY anl_mincut_result_hydrometer.id, anl_mincut_result_selector.result_id
ORDER BY anl_mincut_result_hydrometer.hydrometer_id;


