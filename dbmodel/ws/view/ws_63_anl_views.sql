/*
This file is part of Giswater 2.0
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


DROP VIEW IF EXISTS v_anl_mincut_connec;
CREATE OR REPLACE VIEW v_anl_mincut_connec AS 
SELECT
connec_id,
v_edit_connec.the_geom
FROM anl_mincut_arc
JOIN v_edit_connec on v_edit_connec.arc_id=anl_mincut_arc.arc_id;


DROP VIEW IF EXISTS v_anl_mincut_hydrometer;
CREATE OR REPLACE VIEW v_anl_mincut_hydrometer AS 
SELECT
hydrometer_id,
v_edit_connec.connec_id,
code,
anl_mincut_arc.arc_id
FROM anl_mincut_arc
JOIN v_edit_connec on v_edit_connec.arc_id=anl_mincut_arc.arc_id
JOIN rtc_hydrometer_x_connec on rtc_hydrometer_x_connec.connec_id=v_edit_connec.connec_id;


-- ----------------------------
-- MINCUT CATALOG
-- ----------------------------


DROP VIEW IF EXISTS "v_anl_mincut_result_arc" CASCADE; 
CREATE VIEW "v_anl_mincut_result_arc" AS 
SELECT 
anl_mincut_result_arc.id,
anl_mincut_result_arc.mincut_result_cat_id,
anl_mincut_result_arc.arc_id,  
arc.the_geom 
FROM arc, anl_mincut_result_selector
JOIN anl_mincut_result_arc ON (((anl_mincut_result_arc.arc_id) = (arc_id)))
WHERE (((anl_mincut_result_selector.result_id) = (anl_mincut_result_arc.mincut_result_cat_id))) 
AND anl_mincut_result_selector.cur_user="current_user"() 
GROUP BY anl_mincut_result_arc.id, anl_mincut_result_selector.result_id, arc.the_geom
ORDER BY anl_mincut_result_arc.arc_id;



DROP VIEW IF EXISTS "v_anl_mincut_result_node" CASCADE; 
CREATE VIEW "v_anl_mincut_result_node" AS
SELECT 
anl_mincut_result_node.id,
anl_mincut_result_node.mincut_result_cat_id,
anl_mincut_result_node.node_id,  
node.the_geom 
FROM anl_mincut_result_selector, node
JOIN anl_mincut_result_node ON ((anl_mincut_result_node.node_id) = (node.node_id))
WHERE ((anl_mincut_result_selector.result_id) = (anl_mincut_result_node.mincut_result_cat_id)) 
AND anl_mincut_result_selector.cur_user="current_user"()
GROUP BY anl_mincut_result_node.id, anl_mincut_result_selector.result_id, node.the_geom
ORDER BY anl_mincut_result_node.node_id;


DROP VIEW IF EXISTS "v_anl_mincut_result_valve" CASCADE; -- to do!
CREATE VIEW "v_anl_mincut_result_valve" AS
SELECT 
anl_mincut_result_valve.id,
anl_mincut_result_valve.mincut_result_cat_id,
anl_mincut_result_valve.valve_id,  
node.the_geom 
FROM anl_mincut_result_selector, node
JOIN anl_mincut_result_valve ON ((anl_mincut_result_valve.valve_id) = (node.node_id))
WHERE  ((anl_mincut_result_selector.id) = (anl_mincut_result_valve.mincut_result_cat_id))
AND anl_mincut_result_selector.cur_user="current_user"();



DROP VIEW IF EXISTS "v_anl_mincut_result_connec";
CREATE OR REPLACE VIEW "v_anl_mincut_result_connec" AS 
SELECT
anl_mincut_result_connec.id,
anl_mincut_result_connec.mincut_result_cat_id,
anl_mincut_result_connec.connec_id,  
connec.the_geom 
FROM anl_mincut_result_selector, connec
JOIN anl_mincut_result_connec ON (((anl_mincut_result_connec.connec_id) = (connec.connec_id)))
WHERE ((anl_mincut_result_selector.result_id) = (anl_mincut_result_connec.mincut_result_cat_id))
AND anl_mincut_result_selector.cur_user="current_user"()
GROUP BY anl_mincut_result_connec.id, anl_mincut_result_selector.result_id, connec.the_geom
ORDER BY anl_mincut_result_connec.connec_id;


DROP VIEW IF EXISTS "v_anl_mincut_result_polygon";
CREATE OR REPLACE VIEW "v_anl_mincut_result_polygon" AS 
SELECT
anl_mincut_result_polygon.id,
anl_mincut_result_polygon.mincut_result_cat_id,
anl_mincut_result_polygon.polygon_id,  
anl_mincut_result_polygon.the_geom 
FROM anl_mincut_result_polygon,anl_mincut_result_selector
WHERE ((anl_mincut_result_selector.result_id) = (anl_mincut_result_polygon.mincut_result_cat_id))
AND anl_mincut_result_selector.cur_user="current_user"()
GROUP BY anl_mincut_result_polygon.id, anl_mincut_result_selector.result_id, anl_mincut_result_polygon.the_geom
ORDER BY anl_mincut_result_polygon.polygon_id;




DROP VIEW IF EXISTS "v_anl_mincut_result_hydrometer";
CREATE OR REPLACE VIEW "v_anl_mincut_result_hydrometer" AS 
SELECT
anl_mincut_result_hydrometer.id,
anl_mincut_result_hydrometer.mincut_result_cat_id,
anl_mincut_result_hydrometer.hydrometer_id
FROM anl_mincut_result_hydrometer,anl_mincut_result_selector
WHERE ((anl_mincut_result_selector.result_id) = (anl_mincut_result_hydrometer.mincut_result_cat_id))
AND anl_mincut_result_selector.cur_user="current_user"() 
GROUP BY anl_mincut_result_hydrometer.id, anl_mincut_result_selector.result_id
ORDER BY anl_mincut_result_hydrometer.hydrometer_id;




DROP VIEW IF EXISTS "v_anl_mincut_result_arc_compare" CASCADE; 
CREATE VIEW "v_anl_mincut_result_arc_compare" AS 
SELECT 
anl_mincut_result_arc.id,
anl_mincut_result_arc.mincut_result_cat_id,
anl_mincut_result_arc.arc_id,  
arc.the_geom 
FROM anl_mincut_result_selector_compare, arc
JOIN anl_mincut_result_arc ON ((anl_mincut_result_arc.arc_id) = (arc.arc_id))
WHERE ((anl_mincut_result_selector_compare.id) = (anl_mincut_result_arc.mincut_result_cat_id))
AND anl_mincut_result_selector_compare.cur_user="current_user"();


DROP VIEW IF EXISTS "v_anl_mincut_result_node_compare" CASCADE; 
CREATE VIEW "v_anl_mincut_result_node_compare" AS
SELECT 
anl_mincut_result_node.id,
anl_mincut_result_node.mincut_result_cat_id,
anl_mincut_result_node.node_id,  
node.the_geom 
FROM anl_mincut_result_selector_compare, node
JOIN anl_mincut_result_node ON ((anl_mincut_result_node.node_id) = (node.node_id))
WHERE ((anl_mincut_result_selector_compare.id) = (anl_mincut_result_node.mincut_result_cat_id))
AND anl_mincut_result_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_anl_mincut_result_valve_compare" CASCADE; 
CREATE VIEW "v_anl_mincut_result_valve_compare" AS
SELECT 
anl_mincut_result_valve.id,
anl_mincut_result_valve.mincut_result_cat_id,
anl_mincut_result_valve.valve_id,  
node.the_geom 
FROM anl_mincut_result_selector_compare,node
JOIN anl_mincut_result_valve ON ((anl_mincut_result_valve.valve_id) = (node.node_id))
WHERE ((anl_mincut_result_selector_compare.id) = (anl_mincut_result_valve.mincut_result_cat_id))
AND anl_mincut_result_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_anl_mincut_result_connec_compare";
CREATE OR REPLACE VIEW "v_anl_mincut_result_connec_compare" AS 
SELECT
anl_mincut_result_connec.id,
anl_mincut_result_connec.mincut_result_cat_id,
anl_mincut_result_connec.connec_id,  
connec.the_geom 
FROM anl_mincut_result_selector_compare, connec
JOIN anl_mincut_result_connec ON ((anl_mincut_result_connec.connec_id) = (connec.connec_id))
WHERE ((anl_mincut_result_selector_compare.id) = (anl_mincut_result_connec.mincut_result_cat_id))
AND anl_mincut_result_selector_compare.cur_user="current_user"();


DROP VIEW IF EXISTS "v_anl_mincut_result_polygon_compare";
CREATE OR REPLACE VIEW "v_anl_mincut_result_polygon_compare" AS 
SELECT
anl_mincut_result_polygon.id,
anl_mincut_result_polygon.mincut_result_cat_id,
anl_mincut_result_polygon.polygon_id,  
anl_mincut_result_polygon.the_geom 
FROM anl_mincut_result_polygon,anl_mincut_result_selector_compare
WHERE (anl_mincut_result_selector_compare.id) = (anl_mincut_result_polygon.mincut_result_cat_id)
AND anl_mincut_result_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_anl_mincut_result_hydrometer_compare";
CREATE OR REPLACE VIEW "v_anl_mincut_result_hydrometer_compare" AS 
SELECT
anl_mincut_result_hydrometer.id,
anl_mincut_result_hydrometer.mincut_result_cat_id,
anl_mincut_result_hydrometer.hydrometer_id
FROM anl_mincut_result_hydrometer, anl_mincut_result_selector_compare
WHERE (anl_mincut_result_selector_compare.id) = (anl_mincut_result_hydrometer.mincut_result_cat_id)
AND anl_mincut_result_selector_compare.cur_user="current_user"();
