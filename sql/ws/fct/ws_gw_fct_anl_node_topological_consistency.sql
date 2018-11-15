/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2302

SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE OR REPLACE FUNCTION gw_fct_anl_node_topological_consistency() RETURNS void AS $BODY$
DECLARE
    rec_node record;
    rec record;

BEGIN

    SET search_path = "SCHEMA_NAME", public;


    -- Reset values
    DELETE FROM anl_node WHERE cur_user="current_user"() AND anl_node.fprocesscat_id=8;

    
    -- Computing process
   INSERT INTO anl_node (node_id, nodecat_id, state, num_arcs, expl_id, fprocesscat_id, the_geom)
	
    SELECT node_id, nodecat_id, node.state, COUNT(*), node.expl_id, 8, node.the_geom FROM node INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
	GROUP BY node.node_id, nodecat_id, node.state, node.expl_id, node.the_geom HAVING COUNT(*) != 4
    UNION
    SELECT node_id, nodecat_id, node.state, COUNT(*),  node.expl_id, 8, node.the_geom FROM node INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
	GROUP BY node.node_id, nodecat_id, node.state, node.expl_id, node.the_geom HAVING COUNT(*) != 3
    UNION
    SELECT node_id, nodecat_id, node.state, COUNT(*), node.expl_id, 8, node.the_geom FROM node INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
	GROUP BY node.node_id, nodecat_id, node.state, node.expl_id, node.the_geom HAVING COUNT(*) != 2
    UNION
    SELECT node_id, nodecat_id, node.state, COUNT(*), node.expl_id, 8, node.the_geom FROM node INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
	GROUP BY node.node_id, nodecat_id, node.state, node.expl_id, node.the_geom HAVING COUNT(*) != 1;
    
    DELETE FROM selector_audit WHERE fprocesscat_id=8 AND cur_user=current_user;	
    INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (8, current_user);

    RETURN;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;