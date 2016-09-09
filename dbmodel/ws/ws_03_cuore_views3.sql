/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- View structure for v_arc_x_node
-- ----------------------------

DROP VIEW IF EXISTS v_arc_x_node1;
CREATE OR REPLACE VIEW v_arc_x_node1 AS 
SELECT arc.arc_id, arc.node_1, 
node.elevation AS elevation1, 
node.depth AS depth1, 
(cat_arc.dext)/1000 AS dext, 
node.depth - (cat_arc.dext)/1000 AS r1
FROM arc
JOIN node ON arc.node_1::text = node.node_id::text
JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text AND arc.arccat_id::text = cat_arc.id::text;


DROP VIEW IF EXISTS v_arc_x_node2;
CREATE OR REPLACE VIEW v_arc_x_node2 AS 
SELECT arc.arc_id, arc.node_2, 
node.elevation AS elevation2, 
node.depth AS depth2,
(cat_arc.dext)/1000 AS dext, 
node.depth - (cat_arc.dext)/1000 AS r2
FROM arc
JOIN node ON arc.node_2::text = node.node_id::text
JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text AND arc.arccat_id::text = cat_arc.id::text;


DROP VIEW IF EXISTS v_arc_x_node;
CREATE OR REPLACE VIEW v_arc_x_node AS 
SELECT 
v_arc_x_node1.arc_id,
v_arc_x_node1.node_1,
v_arc_x_node1.elevation1,
v_arc_x_node1.depth1,
v_arc_x_node1.r1,
v_arc_x_node2.node_2,
v_arc_x_node2.elevation2,
v_arc_x_node2.depth2,
v_arc_x_node2.r2,
arc."state",
arc.sector_id,
arc.the_geom
FROM v_arc_x_node1
JOIN v_arc_x_node2 ON v_arc_x_node1.arc_id::text = v_arc_x_node2.arc_id::text
JOIN arc ON v_arc_x_node2.arc_id::text = arc.arc_id::text; 


DROP VIEW IF EXISTS v_ui_element_x_node;
CREATE OR REPLACE VIEW v_ui_element_x_node AS 
SELECT
element_x_node.id,
element_x_node.node_id,
element.elementcat_id,
element_x_node.element_id,
element.state,
element.observ,
element.comment,
element.builtdate,
element.enddate
FROM element_x_node
JOIN element ON element.element_id::text = element_x_node.element_id::text;


DROP VIEW IF EXISTS v_ui_element_x_arc;
CREATE OR REPLACE VIEW v_ui_element_x_arc AS
SELECT
element_x_arc.id,
element_x_arc.arc_id,
element.elementcat_id,
element_x_arc.element_id,
element.state,
element.observ,
element.comment,
element.builtdate,
element.enddate
FROM element_x_arc
JOIN element ON element.element_id::text = element_x_arc.element_id::text;


DROP VIEW IF EXISTS v_ui_element_x_connec;
CREATE OR REPLACE VIEW v_ui_element_x_connec AS
SELECT
element_x_connec.id,
element_x_connec.connec_id,
element.elementcat_id,
element_x_connec.element_id,
element.state,
element.observ,
element.comment,
element.builtdate,
element.enddate
FROM element_x_connec
JOIN element ON element.element_id::text = element_x_connec.element_id::text;

