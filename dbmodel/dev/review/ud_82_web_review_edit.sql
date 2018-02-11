/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


DROP VIEW IF EXISTS v_edit_review_arc;
CREATE VIEW  v_edit_review_arc AS SELECT
review_arc.arc_id,
review_arc.y1,
review_arc.y2,
review_arc.arc_type,
review_arc.matcat_id,
review_arc.shape,
review_arc.geom1,
review_arc.geom2,
review_arc.annotation,
review_arc.observ,
review_arc.expl_id,
review_arc.the_geom,
review_arc.field_checked
FROM review_arc, selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_arc.expl_id=selector_expl.expl_id;


DROP VIEW IF EXISTS v_edit_audit_review_arc;
CREATE VIEW v_edit_audit_review_arc AS SELECT
audit_review_arc.id,
arc_id,
old_y1,
new_y1,
old_y2,
new_y2,
old_arc_type,
new_arc_type,
old_matcat_id,
new_matcat_id,
old_shape,
new_shape,
old_geom1,
new_geom1,
old_geom2,
new_geom2,
old_arccat_id,
new_arccat_id,
annotation,
observ,
audit_review_arc.expl_id,
the_geom,
review_status_id,
field_date,
field_user,
is_validated
FROM audit_review_arc,selector_expl
WHERE selector_expl.cur_user="current_user"() AND audit_review_arc.expl_id=selector_expl.expl_id;


DROP VIEW IF EXISTS v_edit_review_node;
CREATE VIEW  v_edit_review_node AS SELECT
node_id,
top_elev,
ymax,
node_type,
matcat_id,
shape,
geom1,
geom2,
annotation,
observ,
review_node.expl_id,
the_geom,
field_checked
FROM review_node, selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_node.expl_id=selector_expl.expl_id;


DROP VIEW IF EXISTS v_edit_audit_review_node;
CREATE VIEW  v_edit_audit_review_node AS SELECT
audit_review_node.id,
node_id,
old_top_elev,
new_top_elev,
old_ymax,
new_ymax,
old_node_type,
new_node_type,
old_matcat_id,
new_matcat_id,
old_shape,
new_shape,
old_geom1,
new_geom1,
old_geom2,
new_geom2,
old_nodecat_id,
new_nodecat_id,
annotation,
observ,
audit_review_node.expl_id,
the_geom,
review_status_id,
field_date,
field_user,
is_validated
FROM audit_review_node, selector_expl
WHERE selector_expl.cur_user="current_user"() AND audit_review_node.expl_id=selector_expl.expl_id;


DROP VIEW IF EXISTS v_edit_review_connec;
CREATE VIEW  v_edit_review_connec AS SELECT
review_connec.connec_id, 
review_connec.y1, 
review_connec.y2, 
review_connec.connec_type, 
review_connec.matcat_id, 
review_connec.shape, 
review_connec.geom1,
review_connec.geom2, 
review_connec.annotation, 
review_connec.observ, 
review_connec.expl_id, 
review_connec.the_geom, 
review_connec.field_checked
FROM review_connec,selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_connec.expl_id=selector_expl.expl_id;


DROP VIEW IF EXISTS v_edit_audit_review_arc;
CREATE VIEW v_edit_audit_review_arc AS SELECT
audit_review_connec.id,
connec_id, 
old_y1, 
new_y1, 
old_y2, 
new_y2, 
old_connec_type, 
new_connec_type, 
old_matcat_id, 
new_matcat_id, 
old_shape, 
new_shape, 
old_geom1, 
new_geom1, 
old_geom2, 
new_geom2, 
old_connecat_id, 
new_connecat_id, 
annotation, 
observ, 
audit_review_connec.expl_id, 
the_geom, 
review_status_id, 
field_date, 
field_user, 
is_validated
FROM audit_review_connec,selector_expl
WHERE selector_expl.cur_user="current_user"() AND audit_review_connec.expl_id=selector_expl.expl_id;


DROP VIEW IF EXISTS v_edit_review_gully;
CREATE VIEW  v_edit_review_gully AS SELECT
review_gully.gully_id, 
review_gully.top_elev, 
review_gully.ymax, 
review_gully.sandbox, 
review_gully.matcat_id, 
review_gully.gratecat_id, 
review_gully.units, 
review_gully.groove, 
review_gully.siphon, 
review_gully.connec_matcat_id, 
review_gully.connec_shape, 
review_gully.connec_geom1, 
review_gully.connec_geom2, 
review_gully.connec_arccat_id,
review_gully.featurecat_id, 
review_gully.feature_id, 
review_gully.annotation, 
review_gully.observ, 
review_gully.expl_id, 
review_gully.the_geom, 
review_gully.field_checked
FROM review_gully,selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_gully.expl_id=selector_expl.expl_id;


DROP VIEW IF EXISTS v_edit_audit_review_gully;
CREATE VIEW v_edit_audit_review_gully AS SELECT
audit_review_gully.id,
gully_id, 
old_top_elev, 
new_top_elev, 
old_ymax, 
new_ymax, 
old_sandbox, 
new_sandbox, 
old_matcat_id, 
new_matcat_id, 
old_gratecat_id, 
new_gratecat_id, 
old_units, new_units, 
old_groove, 
new_groove, 
old_siphon, 
new_siphon, 
old_connec_matcat_id, 
new_connec_matcat_id, 
old_connec_shape, 
new_connec_shape, 
old_connec_geom1, 
new_connec_geom1, 
old_connec_geom2, 
new_connec_geom2,
old_connec_arccat_id,
new_connec_arccat_id,
old_featurecat_id, 
new_featurecat_id, 
old_feature_id, 
new_feature_id, 
annotation, 
observ, 
audit_review_gully.expl_id, 
the_geom, 
review_status_id, 
field_date, 
field_user, 
is_validated
FROM audit_review_gully,selector_expl
WHERE selector_expl.cur_user="current_user"() AND audit_review_gully.expl_id=selector_expl.expl_id;








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