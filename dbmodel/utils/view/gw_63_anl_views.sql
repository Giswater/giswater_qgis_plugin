/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME" , public, pg_catalog;



DROP VIEW IF EXISTS v_anl_review_arc
CREATE OR REPLACE VIEW v_anl_review_arc AS 
SELECT
arc_id,
arc_type,
context,
exploitation.name AS expl_name,
the_geom
FROM selector_expl, anl_review_arc
	JOIN exploitation ON node.expl_id=exploitation.expl_id
	WHERE anl_review_arc.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_review_arc.cur_user="current_user"();


	

DROP VIEW IF EXISTS v_anl_review_node;
CREATE OR REPLACE VIEW v_anl_review_node AS 
SELECT
node_id,
node_type,
num_arcs,
context,
exploitation.name AS expl_name,
the_geom
FROM selector_expl, anl_review_node
	JOIN exploitation ON node.expl_id=exploitation.expl_id
	WHERE anl_review_arc.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_review_arc.cur_user="current_user"();


	
	
	
DROP VIEW IF EXISTS v_anl_review_arc_x_node;
CREATE OR REPLACE VIEW v_anl_review_arc_x_node AS 
SELECT
arc_id,
arc_type,
node_id,
node_type,
context,
exploitation.name AS expl_name,
the_geom
FROM selector_expl, anl_review_arc_x_node
	JOIN exploitation ON node.expl_id=exploitation.expl_id
	WHERE anl_review_arc_x_node.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_review_arc_x_node.cur_user="current_user"();

	
	
	
DROP VIEW IF EXISTS v_anl_review_arc_x_node_point;
CREATE OR REPLACE VIEW v_anl_review_arc_x_node_point AS 
SELECT
arc_id,
arc_type,
node_id,
node_type,
context,
exploitation.name AS expl_name,
the_geom_p
FROM selector_expl, anl_review_arc_x_node
	JOIN exploitation ON node.expl_id=exploitation.expl_id
	WHERE anl_review_arc_x_node.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_review_arc_x_node.cur_user="current_user"();

