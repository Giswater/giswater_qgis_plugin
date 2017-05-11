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




DROP VIEW IF EXISTS v_edit_review_node CASCADE;
CREATE VIEW v_edit_review_node AS 
 SELECT node.node_id,
    node.top_elev,
    node.ymax,
    review_audit_node.top_elev AS cota_tapa,
    review_audit_node.ymax AS profunditat,
    review_audit_node.annotation,
	review_audit_node.moved_geom,
    review_audit_node.office_checked,
	node.the_geom	
   FROM node
     JOIN review_audit_node ON node.node_id::text = review_audit_node.node_id::text
  WHERE review_audit_node.field_checked IS TRUE AND review_audit_node.office_checked IS NOT TRUE;
  
DROP VIEW IF EXISTS v_edit_review_arc CASCADE;
  CREATE VIEW v_edit_review_arc AS 
 SELECT arc.arc_id,
	arc.arccat_id,
    arc.y1,
    arc.y2,
    review_audit_arc.arccat_id AS seccio,
    review_audit_arc.y1 AS sonda_ini,
	review_audit_arc.y2 AS sonda_fi,
	review_audit_arc.annotation,
	review_audit_arc.moved_geom,
    review_audit_arc.office_checked,
	arc.the_geom
   FROM arc
     JOIN review_audit_arc ON arc.arc_id::text = review_audit_arc.arc_id::text
  WHERE review_audit_arc.field_checked IS TRUE AND review_audit_arc.office_checked IS NOT TRUE;