/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME" , public, pg_catalog;



DROP VIEW IF EXISTS v_anl_review_node;
CREATE OR REPLACE VIEW v_anl_review_node AS 
SELECT
node_id,
node_type,
state,
num_arcs,
node_id_aux,
context,
exploitation.name AS expl_name,
anl_review_node.the_geom
FROM selector_expl, anl_review_node
	JOIN exploitation ON anl_review_node.expl_id=exploitation.expl_id
	WHERE anl_review_node.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_review_node.cur_user="current_user"();


DROP VIEW IF EXISTS v_anl_review_connec;
CREATE OR REPLACE VIEW v_anl_review_connec AS 
SELECT
connec_id,
connec_type,
state,
connec_id_aux,
context,
exploitation.name AS expl_name,
anl_review_connec.the_geom
FROM selector_expl, anl_review_connec
	JOIN exploitation ON anl_review_connec.expl_id=exploitation.expl_id
	WHERE anl_review_connec.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_review_connec.cur_user="current_user"();



DROP VIEW IF EXISTS v_anl_review_arc;
CREATE OR REPLACE VIEW v_anl_review_arc AS 
SELECT
arc_id,
arc_type,
state,
arc_id_aux,
context,
exploitation.name AS expl_name,
anl_review_arc.the_geom
FROM selector_expl, anl_review_arc
	JOIN exploitation ON anl_review_arc.expl_id=exploitation.expl_id
	WHERE anl_review_arc.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_review_arc.cur_user="current_user"();


DROP VIEW IF EXISTS v_anl_review_arc_point;
CREATE OR REPLACE VIEW v_anl_review_arc_point AS 
SELECT
arc_id,
arc_type,
state,
arc_id_aux,
context,
exploitation.name AS expl_name,
anl_review_arc.the_geom_p
FROM selector_expl, anl_review_arc
	JOIN exploitation ON anl_review_arc.expl_id=exploitation.expl_id
	WHERE anl_review_arc.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_review_arc.cur_user="current_user"();
	

	
	
	
DROP VIEW IF EXISTS v_anl_review_arc_x_node;
CREATE OR REPLACE VIEW v_anl_review_arc_x_node AS 
SELECT
arc_id,
arc_type,
state,
node_id,
context,
exploitation.name AS expl_name,
anl_review_arc_x_node.the_geom
FROM selector_expl, anl_review_arc_x_node
	JOIN exploitation ON anl_review_arc_x_node.expl_id=exploitation.expl_id
	WHERE anl_review_arc_x_node.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_review_arc_x_node.cur_user="current_user"();

	
	
	
DROP VIEW IF EXISTS v_anl_review_arc_x_node_point;
CREATE OR REPLACE VIEW v_anl_review_arc_x_node_point AS 
SELECT
arc_id,
arc_type,
node_id,
context,
exploitation.name AS expl_name,
anl_review_arc_x_node.the_geom_p
FROM selector_expl, anl_review_arc_x_node
	JOIN exploitation ON anl_review_arc_x_node.expl_id=exploitation.expl_id
	WHERE anl_review_arc_x_node.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_review_arc_x_node.cur_user="current_user"();