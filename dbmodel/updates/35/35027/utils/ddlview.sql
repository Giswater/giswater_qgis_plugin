/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/08/04

ALTER VIEW v_anl_graf RENAME TO v_anl_graph;

--2022/08/10
DROP VIEW ve_pol_connec;

CREATE OR REPLACE VIEW ve_pol_connec AS 
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom
   FROM connec
     JOIN v_state_connec USING (connec_id)
     JOIN polygon ON polygon.feature_id::text = connec.connec_id::text;

DROP VIEW ve_pol_node;

CREATE OR REPLACE VIEW ve_pol_node AS 
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom
   FROM node
     JOIN v_state_node USING (node_id)
     JOIN polygon ON polygon.feature_id::text = node.node_id::text;
