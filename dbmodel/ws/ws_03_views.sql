/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE VIEW SCHEMA_NAME.v_arc_x_node1 AS 
SELECT arc.arc_id, arc.node_1, 
node.elevation AS elevation1, 
node.depth AS depth1, 
(cat_arc.dext)/1000 AS dext, 
node.depth - (cat_arc.dext)/1000 AS r1
FROM SCHEMA_NAME.arc
JOIN SCHEMA_NAME.node ON arc.node_1::text = node.node_id::text
JOIN SCHEMA_NAME.cat_arc ON arc.arccat_id::text = cat_arc.id::text AND arc.arccat_id::text = cat_arc.id::text;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_arc_x_node2 AS 
SELECT arc.arc_id, arc.node_2, 
node.elevation AS elevation2, 
node.depth AS depth2,
(cat_arc.dext)/1000 AS dext, 
node.depth - (cat_arc.dext)/1000 AS r2
FROM SCHEMA_NAME.arc
JOIN SCHEMA_NAME.node ON arc.node_2::text = node.node_id::text
JOIN SCHEMA_NAME.cat_arc ON arc.arccat_id::text = cat_arc.id::text AND arc.arccat_id::text = cat_arc.id::text;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_arc_x_node AS 
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
FROM SCHEMA_NAME.v_arc_x_node1
JOIN SCHEMA_NAME.v_arc_x_node2 ON v_arc_x_node1.arc_id::text = v_arc_x_node2.arc_id::text
JOIN SCHEMA_NAME.arc ON v_arc_x_node2.arc_id::text = arc.arc_id::text; 



CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_element_x_node AS 
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
FROM SCHEMA_NAME.element_x_node
JOIN SCHEMA_NAME.element ON element.element_id::text = element_x_node.element_id::text;




CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_element_x_connec AS
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
FROM SCHEMA_NAME.element_x_connec
JOIN SCHEMA_NAME.element ON element.element_id::text = element_x_connec.element_id::text;



   