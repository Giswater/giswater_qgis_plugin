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
review_arc.field_checked,
review_arc.is_validated
FROM review_arc, selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_arc.expl_id=selector_expl.expl_id;


DROP VIEW IF EXISTS v_edit_review_audit_arc;
CREATE VIEW v_edit_review_audit_arc AS SELECT
review_audit_arc.id,
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
review_audit_arc.expl_id,
the_geom,
review_status_id,
field_date,
field_user,
is_validated
FROM review_audit_arc,selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_audit_arc.expl_id=selector_expl.expl_id
AND review_status_id!=0;


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
field_checked,
is_validated
FROM review_node, selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_node.expl_id=selector_expl.expl_id;


DROP VIEW IF EXISTS v_edit_review_audit_node;
CREATE VIEW  v_edit_review_audit_node AS SELECT
review_audit_node.id,
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
review_audit_node.expl_id,
the_geom,
review_status_id,
field_date,
field_user,
is_validated
FROM review_audit_node, selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_audit_node.expl_id=selector_expl.expl_id
AND review_status_id!=0;


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
review_connec.field_checked,
review_connec.is_validated
FROM review_connec,selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_connec.expl_id=selector_expl.expl_id;


DROP VIEW IF EXISTS v_edit_review_audit_connec;
CREATE VIEW v_edit_review_audit_connec AS SELECT
review_audit_connec.id,
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
review_audit_connec.expl_id, 
the_geom, 
review_status_id, 
field_date, 
field_user, 
is_validated
FROM review_audit_connec,selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_audit_connec.expl_id=selector_expl.expl_id
AND review_status_id!=0;


DROP VIEW IF EXISTS v_edit_review_gully;
CREATE VIEW  v_edit_review_gully AS SELECT
review_gully.gully_id, 
review_gully.top_elev, 
review_gully.ymax, 
review_gully.sandbox, 
review_gully.matcat_id, 
review_gully.gully_type,
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
review_gully.field_checked,
review_gully.is_validated
FROM review_gully,selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_gully.expl_id=selector_expl.expl_id;


DROP VIEW IF EXISTS v_edit_review_audit_gully;
CREATE VIEW v_edit_review_audit_gully AS SELECT
review_audit_gully.id,
gully_id, 
old_top_elev, 
new_top_elev, 
old_ymax, 
new_ymax, 
old_sandbox, 
new_sandbox, 
old_matcat_id, 
new_matcat_id, 
old_gully_type,
new_gully_type,
old_gratecat_id, 
new_gratecat_id, 
old_units, 
new_units, 
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
review_audit_gully.expl_id, 
the_geom, 
review_status_id, 
field_date, 
field_user, 
is_validated
FROM review_audit_gully,selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_audit_gully.expl_id=selector_expl.expl_id
AND review_status_id!=0;



