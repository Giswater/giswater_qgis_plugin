/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


DROP VIEW IF EXISTS v_man_arc CASCADE;
CREATE VIEW v_man_arc AS 
SELECT
arc_id,
node_1,
node_2,
the_geom
FROM arc
JOIN man_selector_state ON arc.state=man_selector_state.id
;

DROP VIEW IF EXISTS v_man_node CASCADE;
CREATE VIEW v_man_node AS 
SELECT
node_id,
the_geom
FROM node
JOIN man_selector_state ON node.state=man_selector_state.id
;

DROP VIEW IF EXISTS v_man_connec CASCADE;
CREATE VIEW v_man_connec AS 
SELECT
connec_id,
the_geom
FROM connec
JOIN man_selector_state ON connec.state=man_selector_state.id
;



DROP VIEW IF EXISTS v_ui_element_x_arc CASCADE;
CREATE OR REPLACE VIEW v_ui_element_x_arc AS
SELECT
element_x_arc.id,
element_x_arc.arc_id,
element_x_arc.element_id,
element.elementcat_id,
element.state,
element.observ,
element.comment,
element.builtdate,
element.enddate,
element.link,
element.publish,
element.inventory
FROM element_x_arc
JOIN element ON element.element_id::text = element_x_arc.element_id::text;



DROP VIEW IF EXISTS v_ui_element_x_node CASCADE;
CREATE OR REPLACE VIEW v_ui_element_x_node AS
SELECT
element_x_node.id,
element_x_node.node_id,
element_x_node.element_id,
element.elementcat_id,
element.state,
element.observ,
element.comment,
element.builtdate,
element.enddate,
element.link,
element.publish,
element.inventory
FROM element_x_node
JOIN element ON element.element_id::text = element_x_node.element_id::text;



DROP VIEW IF EXISTS v_ui_element_x_connec CASCADE;
CREATE OR REPLACE VIEW v_ui_element_x_connec AS
SELECT
element_x_connec.id,
element_x_connec.connec_id,
element_x_connec.element_id,
element.elementcat_id,
element.state,
element.observ,
element.comment,
element.builtdate,
element.enddate,
element.link,
element.publish,
element.inventory
FROM element_x_connec
JOIN element ON element.element_id::text = element_x_connec.element_id::text;



CREATE OR REPLACE VIEW v_edit_dimensions AS 
 SELECT dimensions.id,
    dimensions.distance,
    dimensions.depth,
    dimensions.the_geom,
    dimensions.coordx,
    dimensions.coordy,
    dimensions.feature_id,
    dimensions.feature_type
   FROM dimensions;
