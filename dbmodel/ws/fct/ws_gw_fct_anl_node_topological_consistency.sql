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
    DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=8;

    
    -- Computing process
    INSERT INTO anl_node (node_id, node_type, state, num_arcs, expl_id, fprocesscat_id, the_geom)
	
    SELECT node_id, cat_node.nodetype_id, node.state, COUNT(*), node.expl_id, 8, node.the_geom FROM node INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
	JOIN cat_node ON nodecat_id=id	JOIN node_type ON cat_node.nodetype_id=node_type.id WHERE num_arcs = 4 
	GROUP BY node.node_id, nodetype_id, node.state, node.expl_id, node.the_geom, node_type.id HAVING COUNT(*) != 4
    UNION
    SELECT node_id, cat_node.nodetype_id, node.state, COUNT(*),  node.expl_id, 8, node.the_geom FROM node INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
	JOIN cat_node ON nodecat_id=id	JOIN node_type ON cat_node.nodetype_id=node_type.id WHERE num_arcs = 3 
	GROUP BY node.node_id, nodetype_id, node.state, node.expl_id, node.the_geom, node_type.id HAVING COUNT(*) != 3
    UNION
    SELECT node_id, cat_node.nodetype_id, node.state, COUNT(*), node.expl_id, 8, node.the_geom FROM node INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
	JOIN cat_node ON nodecat_id=id	JOIN node_type ON cat_node.nodetype_id=node_type.id WHERE num_arcs = 2 
	GROUP BY node.node_id, nodetype_id, node.state, node.expl_id, node.the_geom, node_type.id HAVING COUNT(*) != 2
    UNION
    SELECT node_id, cat_node.nodetype_id, node.state, COUNT(*), node.expl_id, 8, node.the_geom FROM node INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
	JOIN cat_node ON nodecat_id=id	JOIN node_type ON cat_node.nodetype_id=node_type.id WHERE num_arcs = 1 
	GROUP BY node.node_id, nodetype_id, node.state, node.expl_id, node.the_geom, node_type.id HAVING COUNT(*) != 1;
  
    RETURN;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;