/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;




DROP VIEW IF EXISTS v_anl_flow_arc;
CREATE OR REPLACE VIEW v_anl_flow_arc AS 
SELECT
anl_flow_arc.id,
arc_id,
arc_type,
context,
anl_flow_arc.expl_id,
the_geom
FROM selector_expl, anl_flow_arc
	WHERE anl_flow_arc.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_flow_arc.cur_user="current_user"();



DROP VIEW IF EXISTS v_anl_flow_node;
CREATE OR REPLACE VIEW v_anl_flow_node AS 
SELECT
anl_flow_node.id,
node_id,
node_type,
context,
anl_flow_node.expl_id,
the_geom
FROM selector_expl, anl_flow_node
	WHERE anl_flow_node.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_flow_node.cur_user="current_user"();




DROP VIEW IF EXISTS v_anl_flow_connec;
CREATE OR REPLACE VIEW v_anl_flow_connec AS 
SELECT
anl_flow_arc.id
connec_id,
context,
anl_flow_arc.expl_id,
v_edit_connec.the_geom
FROM selector_expl, anl_flow_arc
	JOIN v_edit_connec on v_edit_connec.arc_id=anl_flow_arc.arc_id
	WHERE anl_flow_arc.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_flow_arc.cur_user="current_user"();

	


DROP VIEW IF EXISTS v_anl_flow_hydrometer;
CREATE OR REPLACE VIEW v_anl_flow_hydrometer AS 
SELECT
anl_flow_arc.id,
hydrometer_id,
v_edit_connec.connec_id,
code,
context,
anl_flow_arc.expl_id,
anl_flow_arc.arc_id
FROM selector_expl, anl_flow_arc
	JOIN v_edit_connec on v_edit_connec.arc_id=anl_flow_arc.arc_id
	JOIN rtc_hydrometer_x_connec on rtc_hydrometer_x_connec.connec_id=v_edit_connec.connec_id
	WHERE anl_flow_arc.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"()
	AND anl_flow_arc.cur_user="current_user"();