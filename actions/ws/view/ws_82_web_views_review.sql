/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


	
 --REVIEW VIEWS
 
DROP VIEW IF EXISTS v_edit_review_arc;
CREATE VIEW  v_edit_review_arc AS SELECT
review_arc.arc_id,
review_arc.matcat_id, 
review_arc.pnom, 
review_arc.dnom, 
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
old_matcat_id, 
new_matcat_id,
old_pnom, 
new_pnom, 
old_dnom, 
new_dnom, 
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
elevation, 
depth, 
nodetype_id, 
nodecat_id, 
annotation, 
observ,
review_node.expl_id,
the_geom, 
field_checked
FROM review_node, selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_node.expl_id=selector_expl.expl_id;



DROP VIEW IF EXISTS v_edit_review_audit_node;
CREATE VIEW  v_edit_review_audit_node AS SELECT
review_audit_node.id, 
node_id, 
old_elevation, 
new_elevation, 
old_depth, 
new_depth, 
old_nodetype_id, 
new_nodetype_id, 
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
connec_id, 
matcat_id, 
pnom, 
dnom, 
connectype_id,
annotation, 
observ,
review_connec.expl_id, 
the_geom, 
field_checked
FROM review_connec,selector_expl
WHERE selector_expl.cur_user="current_user"() AND review_connec.expl_id=selector_expl.expl_id;


DROP VIEW IF EXISTS v_edit_review_audit_connec;
CREATE VIEW v_edit_review_audit_connec AS SELECT
review_audit_connec.id,
connec_id, 
old_matcat_id, 
new_matcat_id, 
old_pnom, 
new_pnom, 
old_dnom, 
new_dnom,
old_connectype_id,
new_connectype_id,
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