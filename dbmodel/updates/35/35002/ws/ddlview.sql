/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/02/12
CREATE OR REPLACE VIEW  v_ui_arc_x_relations AS 
 SELECT row_number() OVER (ORDER BY v_node.node_id) + 1000000 AS rid,
	v_node.arc_id,
	v_node.nodetype_id AS featurecat_id,
	v_node.nodecat_id AS catalog,
	v_node.node_id AS feature_id,
	v_node.code AS feature_code,
	v_node.sys_type,
	v_arc.state AS arc_state,
	v_node.state AS feature_state,
	st_x(v_node.the_geom) AS x,
	st_y(v_node.the_geom) AS y,
	'v_edit_node'::text AS sys_table_id
   FROM v_node
	 JOIN v_arc ON v_arc.arc_id::text = v_node.arc_id::text
  WHERE v_node.arc_id IS NOT NULL
UNION
 SELECT row_number() OVER () + 2000000 AS rid,
	v_arc.arc_id,
	v_connec.connectype_id AS featurecat_id,
	v_connec.connecat_id AS catalog,
	v_connec.connec_id AS feature_id,
	v_connec.code AS feature_code,
	v_connec.sys_type,
	v_arc.state AS arc_state,
	v_connec.state AS feature_state,
	st_x(v_connec.the_geom) AS x,
	st_y(v_connec.the_geom) AS y,
	'v_edit_connec'::text AS sys_table_id
   FROM v_connec
	 JOIN v_arc ON v_arc.arc_id::text = v_connec.arc_id::text
  WHERE v_connec.arc_id IS NOT NULL;



CREATE OR REPLACE VIEW v_ui_node_x_relations AS 
 SELECT row_number() OVER (ORDER BY v_node.node_id) AS rid,
	v_node.parent_id AS node_id,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.node_id AS child_id,
	v_node.code,
	v_node.sys_type,
	'v_edit_node' AS sys_table_id
   FROM v_node
  WHERE v_node.parent_id IS NOT NULL;