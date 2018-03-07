/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

	 

DROP VIEW IF EXISTS v_ui_workcat_x_feature;
CREATE OR REPLACE VIEW v_ui_workcat_x_feature AS 
 SELECT arc.feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    arc.state,
    arc.workcat_id
   FROM arc
UNION
 SELECT node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    node.state,
    node.workcat_id
   FROM node
UNION
 SELECT connec.feature_type,
    connec.connecat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    connec.state,
    connec.workcat_id
   FROM connec
UNION
	SELECT element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    element.state,
    element.workcat_id
   FROM element;

   

DROP VIEW IF EXISTS v_ui_workcat_x_feature_end;
CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end AS 
 SELECT arc.feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    arc.state,
    arc.workcat_id_end as workcat_id
   FROM arc
UNION
 SELECT node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    node.state,
    node.workcat_id_end as workcat_id
   FROM node
UNION
 SELECT connec.feature_type,
    connec.connecat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    connec.state,
    connec.workcat_id_end as workcat_id
   FROM connec
UNION
 SELECT element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    element.state,
    element.workcat_id_end as workcat_id
   FROM element;
	
	
	
	


DROP VIEW IF EXISTS v_ui_node_x_relations;
CREATE OR REPLACE VIEW v_ui_node_x_relations AS 
SELECT row_number() OVER (ORDER BY node_id) AS rid,
parent_id,
nodetype_id,
nodecat_id,
node_id,
code,
sys_type
FROM v_edit_node where parent_id is not null and parent_id in (select node_id from SCHEMA_NAME.v_edit_node);