/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



/*

DROP VIEW IF EXISTS v_edit_review_node CASCADE;
CREATE VIEW v_edit_review_node AS 
 SELECT review_audit_node.node_id,
 node.nodecat_id,
    node.top_elev,
    node.ymax,
	node."state",
	review_audit_node.nodecat_id AS field_nodecat_id,
    review_audit_node.top_elev AS field_top_elev,
    review_audit_node.ymax AS field_ymax,
    review_audit_node.annotation,
    review_audit_node.observ,
	review_audit_node.moved_geom,
    review_audit_node.office_checked,
	review_audit_node.the_geom	
   FROM node
     RIGHT JOIN review_audit_node ON node.node_id = review_audit_node.node_id
  WHERE review_audit_node.field_checked IS TRUE AND review_audit_node.office_checked IS NOT TRUE;
  

CREATE OR REPLACE VIEW v_edit_review_arc AS 
 SELECT review_audit_arc.arc_id,
	arc.arc_type,
    arc.arccat_id,
    arc.y1,
    arc.y2,
	arc."state",
	review_audit_arc.arc_type AS field_arc_type,
    review_audit_arc.arccat_id AS field_arccat_id,
    review_audit_arc.y1 AS field_y1,
    review_audit_arc.y2 AS field_y2,
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
	 connec.top_elev,
	 connec.y1,
	 connec.y2,
	 connec.connec_type,
	 connec.connecat_id,
	 connec."state",
	 review_audit_connec.top_elev as field_top_elev,
	 review_audit_connec.y1 AS field_y1,
	 review_audit_connec.y2 AS field_y2,
	 review_audit_connec.connec_type AS field_connec_type,
	 review_audit_connec.connecat_id AS field_connecat_id,
	 review_audit_connec.annotation,
	 review_audit_connec.observ,
	 review_audit_connec.moved_geom,
	 review_audit_connec.office_checked,
	 review_audit_connec.the_geom
	 FROM connec
		RIGHT JOIN review_audit_connec ON connec.connec_id = review_audit_connec.connec_id
  WHERE review_audit_connec.field_checked IS TRUE AND review_audit_connec.office_checked IS NOT TRUE;

  
  CREATE OR REPLACE VIEW v_edit_review_gully AS 
	SELECT review_audit_gully.gully_id,
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
	 review_audit_gully.ymax AS field_ymax,
	 review_audit_gully.top_elev as field_top_elev,
	 review_audit_gully.matcat_id AS field_matcat_id,
	 review_audit_gully.gratecat_id AS field_gratecat_id,
	 review_audit_gully.units AS field_units,
	 review_audit_gully.groove AS field_groove,
	 review_audit_gully.arc_id AS field_arc_id,
	 review_audit_gully.siphon AS field_siphon,
	 review_audit_gully.featurecat_id AS field_featurecat_id,
	 review_audit_gully.feature_id AS field_feature_id,	 
	 review_audit_gully.annotation,
	 review_audit_gully.observ,
	 review_audit_gully.moved_geom,
	 review_audit_gully.office_checked,
	 review_audit_gully.the_geom
	 FROM gully
		RIGHT JOIN review_audit_gully ON gully.gully_id = review_audit_gully.gully_id
  WHERE review_audit_gully.field_checked IS TRUE AND review_audit_gully.office_checked IS NOT TRUE;

  

*/