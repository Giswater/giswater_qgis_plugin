/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

/*
	
 --REVIEW VIEWS
 
DROP VIEW IF EXISTS v_edit_review_node CASCADE;
CREATE VIEW v_edit_review_node AS 
 SELECT audit_review_node.node_id,
	node.nodecat_id,
    node.elevation,
    node."depth",
	node."state",
	audit_review_node.nodecat_id AS field_nodecat_id,
    audit_review_node.elevation AS field_elevation,
    audit_review_node."depth" AS field_depth,
    audit_review_node.annotation,
    audit_review_node.observ,
	audit_review_node.moved_geom,
    audit_review_node.office_checked,
	audit_review_node.the_geom	
   FROM node
     RIGHT JOIN audit_review_node ON node.node_id = audit_review_node.node_id
  WHERE audit_review_node.field_checked IS TRUE AND audit_review_node.office_checked IS NOT TRUE;
  

CREATE OR REPLACE VIEW v_edit_review_arc AS 
 SELECT review_audit_arc.arc_id,
    arc.arccat_id,
	arc."state",
    review_audit_arc.arccat_id AS field_arccat_id,
    review_audit_arc.annotation,
    review_audit_arc.observ,
    review_audit_arc.moved_geom,
    review_audit_arc.office_checked,
    review_audit_arc.the_geom
   FROM arc
     RIGHT JOIN review_audit_arc ON arc.arc_id = review_audit_arc.arc_id
  WHERE review_audit_arc.field_checked IS TRUE AND review_audit_arc.office_checked IS NOT TRUE;
  
  
  CREATE OR REPLACE VIEW v_edit_review_connec AS 
	SELECT review_audit_connec.connec_id,
	 connec.elevation,
	 connec."depth",
	 connec.connecat_id,
	 connec."state",
	 review_audit_connec.elevation as field_elevation,
	 review_audit_connec."depth" AS field_depth,
	 review_audit_connec.connecat_id AS field_connecat_id,
	 review_audit_connec.annotation,
	 review_audit_connec.observ,
	 review_audit_connec.moved_geom,
	 review_audit_connec.office_checked,
	 review_audit_connec.the_geom
	 FROM connec
		RIGHT JOIN review_audit_connec ON connec.connec_id = review_audit_connec.connec_id
  WHERE review_audit_connec.field_checked IS TRUE AND review_audit_connec.office_checked IS NOT TRUE;
*/