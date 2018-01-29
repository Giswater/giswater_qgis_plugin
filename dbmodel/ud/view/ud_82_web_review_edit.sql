/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



/*

DROP VIEW IF EXISTS v_edit_review_node CASCADE;
CREATE VIEW v_edit_review_node AS 
 SELECT audit_review_node.node_id,
 node.nodecat_id,
    node.top_elev,
    node.ymax,
	node."state",
	audit_review_node.nodecat_id AS field_nodecat_id,
    audit_review_node.top_elev AS field_top_elev,
    audit_review_node.ymax AS field_ymax,
    audit_review_node.annotation,
    audit_review_node.observ,
	audit_review_node.moved_geom,
    audit_review_node.office_checked,
	audit_review_node.the_geom	
   FROM node
     RIGHT JOIN audit_review_node ON node.node_id = audit_review_node.node_id
  WHERE audit_review_node.field_checked IS TRUE AND audit_review_node.office_checked IS NOT TRUE;
  

CREATE OR REPLACE VIEW v_edit_review_arc AS 
 SELECT audit_review_arc.arc_id,
	arc.arc_type,
    arc.arccat_id,
    arc.y1,
    arc.y2,
	arc."state",
	audit_review_arc.arc_type AS field_arc_type,
    audit_review_arc.arccat_id AS field_arccat_id,
    audit_review_arc.y1 AS field_y1,
    audit_review_arc.y2 AS field_y2,
    audit_review_arc.annotation,
    audit_review_arc.observ,
    audit_review_arc.moved_geom,
    audit_review_arc.office_checked,
    audit_review_arc.the_geom
   FROM arc
     RIGHT JOIN audit_review_arc ON arc.arc_id = audit_review_arc.arc_id
  WHERE audit_review_arc.field_checked IS TRUE AND audit_review_arc.office_checked IS NOT TRUE;
  
  
  CREATE OR REPLACE VIEW v_edit_review_connec AS 
	SELECT audit_review_connec.connec_id,
	 connec.top_elev,
	 connec.y1,
	 connec.y2,
	 connec.connec_type,
	 connec.connecat_id,
	 connec."state",
	 audit_review_connec.top_elev as field_top_elev,
	 audit_review_connec.y1 AS field_y1,
	 audit_review_connec.y2 AS field_y2,
	 audit_review_connec.connec_type AS field_connec_type,
	 audit_review_connec.connecat_id AS field_connecat_id,
	 audit_review_connec.annotation,
	 audit_review_connec.observ,
	 audit_review_connec.moved_geom,
	 audit_review_connec.office_checked,
	 audit_review_connec.the_geom
	 FROM connec
		RIGHT JOIN audit_review_connec ON connec.connec_id = audit_review_connec.connec_id
  WHERE audit_review_connec.field_checked IS TRUE AND audit_review_connec.office_checked IS NOT TRUE;

  
  CREATE OR REPLACE VIEW v_edit_review_gully AS 
	SELECT audit_review_gully.gully_id,
	 gully.top_elev,
	 gully.ymax,
	 gully.matcat_id,
	 gully.gratecat_id,
	 gully.units,
	 gully.groove,
	 gully.arc_id,
	 gully.siphon,
	 gully.featurecat_id,
	 gully.feature_id,
	 gully."state",
	 audit_review_gully.ymax AS field_ymax,
	 audit_review_gully.top_elev as field_top_elev,
	 audit_review_gully.matcat_id AS field_matcat_id,
	 audit_review_gully.gratecat_id AS field_gratecat_id,
	 audit_review_gully.units AS field_units,
	 audit_review_gully.groove AS field_groove,
	 audit_review_gully.arc_id AS field_arc_id,
	 audit_review_gully.siphon AS field_siphon,
	 audit_review_gully.featurecat_id AS field_featurecat_id,
	 audit_review_gully.feature_id AS field_feature_id,	 
	 audit_review_gully.annotation,
	 audit_review_gully.observ,
	 audit_review_gully.moved_geom,
	 audit_review_gully.office_checked,
	 audit_review_gully.the_geom
	 FROM gully
		RIGHT JOIN audit_review_gully ON gully.gully_id = audit_review_gully.gully_id
  WHERE audit_review_gully.field_checked IS TRUE AND audit_review_gully.office_checked IS NOT TRUE;

  

*/