/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



DROP VIEW IF EXISTS v_ui_arc_x_node;
CREATE OR REPLACE VIEW v_ui_arc_x_node AS
SELECT 
v_arc.arc_id,
node_1, 
st_x(a.the_geom) AS x1,
st_y(a.the_geom) AS y1,
node_2,
st_x(b.the_geom) AS x2,
st_y(b.the_geom) AS y2
FROM v_arc
LEFT JOIN node a ON a.node_id::text = v_arc.node_1::text
LEFT JOIN node b ON b.node_id::text = v_arc.node_2::text;





DROP VIEW IF EXISTS v_ui_element_x_arc CASCADE;
CREATE OR REPLACE VIEW v_ui_element_x_arc AS
SELECT
element_x_arc.id,
element_x_arc.arc_id,
element_x_arc.element_id,
element.elementcat_id,
element.num_elements,
element.state,
element.state_type,
element.observ,
element.comment,
element.builtdate,
element.enddate,
element.link,
element.publish,
element.inventory
FROM element_x_arc
JOIN element ON element.element_id = element_x_arc.element_id
WHERE state=1;



DROP VIEW IF EXISTS v_ui_element_x_node CASCADE;
CREATE OR REPLACE VIEW v_ui_element_x_node AS
SELECT
element_x_node.id,
element_x_node.node_id,
element_x_node.element_id,
element.elementcat_id,
element.num_elements,
element.state,
element.state_type,
element.observ,
element.comment,
element.builtdate,
element.enddate,
element.link,
element.publish,
element.inventory
FROM element_x_node
JOIN element ON element.element_id = element_x_node.element_id
WHERE state=1;



DROP VIEW IF EXISTS v_ui_element_x_connec CASCADE;
CREATE OR REPLACE VIEW v_ui_element_x_connec AS
SELECT
element_x_connec.id,
element_x_connec.connec_id,
element_x_connec.element_id,
element.elementcat_id,
element.num_elements,
element.state,
element.state_type,
element.observ,
element.comment,
element.builtdate,
element.enddate,
element.link,
element.publish,
element.inventory
FROM element_x_connec
JOIN element ON element.element_id = element_x_connec.element_id
WHERE state=1;




   