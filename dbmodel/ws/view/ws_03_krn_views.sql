/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

	 
DROP VIEW IF EXISTS v_ui_workcat_x_feature;
 CREATE VIEW v_ui_workcat_x_feature as
 SELECT
	arc.feature_type,
	arc.arccat_id as featurecat_id,
	arc.arc_id as feature_id,
	arc.code as code,
	arc.state,
	arc.workcat_id,
	arc.workcat_id_end
	FROM arc
UNION
	SELECT
	node.feature_type,
	node.nodecat_id as featurecat_id,
	node.node_id as feature_id,
	node.code as code,
	node.state,
	node.workcat_id,
	node.workcat_id_end
	FROM node
UNION
	SELECT
	connec.feature_type,
	connec.connecat_id as featurecat_id,
	connec.connec_id as feature_id,
	connec.code as code,
	connec.state,
	connec.workcat_id,
	connec.workcat_id_end	
	FROM connec;

	
DROP VIEW IF EXISTS v_ui_arc_x_relations;
CREATE OR REPLACE VIEW v_ui_arc_x_relations AS 
 SELECT row_number() OVER (ORDER BY v_edit_node.node_id) AS rid,
    v_edit_node.arc_id,
    v_edit_node.node_id AS node_id,
    v_edit_node.code AS node_code,
    v_edit_node.nodetype_id,
    v_edit_node.nodecat_id
   FROM v_edit_node where arc_id is not null;
   


DROP VIEW IF EXISTS v_ui_node_x_relations;
CREATE OR REPLACE VIEW v_ui_node_x_relations AS 
  SELECT row_number() OVER (ORDER BY v_edit_node.node_id) AS rid,
    v_edit_node.parent_id,
    v_edit_node.node_id AS node_id,
    v_edit_node.code AS node_code,
    v_edit_node.nodetype_id,
    v_edit_node.nodecat_id
   FROM v_edit_node where parent_id is not null and parent_id in (select node_id from SCHEMA_NAME.v_edit_node);