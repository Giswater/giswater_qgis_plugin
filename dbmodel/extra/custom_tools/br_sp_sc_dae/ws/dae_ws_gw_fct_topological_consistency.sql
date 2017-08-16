/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION gw_saa.gw_fct_anl_topological_consistency()
  RETURNS void AS
$BODY$
DECLARE
    rec_node record;
    rec record;

BEGIN

    -- Search path
    SET search_path = "gw_saa", public;

    -- Clear tables
    DELETE FROM anl_topological_consistency;
    DELETE FROM anl_geometrical_consistency;

    -- Check number of connected pipes to node depending on node type
    INSERT INTO anl_topological_consistency (node_id, node_type, num_arcs, the_geom)
    SELECT node_id, node_type, COUNT(*), node.the_geom FROM node INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
	JOIN cat_node ON nodecat_id=id	WHERE cat_node.num_arcs = 4 GROUP BY node.node_id HAVING COUNT(*) != 4
    UNION
    SELECT node_id, node_type, COUNT(*), node.the_geom FROM node INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
	JOIN cat_node ON nodecat_id=id	WHERE cat_node.num_arcs = 3 GROUP BY node.node_id HAVING COUNT(*) != 3
    UNION
    SELECT node_id, node_type, COUNT(*), node.the_geom FROM node INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
	JOIN cat_node ON nodecat_id=id	WHERE cat_node.num_arcs = 2 GROUP BY node.node_id HAVING COUNT(*) != 2
    UNION
    SELECT node_id, node_type, COUNT(*), node.the_geom FROM node INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
	JOIN cat_node ON nodecat_id=id	WHERE cat_node.num_arcs = 1 GROUP BY node.node_id HAVING COUNT(*) != 1;
        
   -- Check diameters
    INSERT INTO anl_geometrical_consistency (node_id, node_type, node_dnom, num_arcs, arc_dnom1, arc_dnom2, the_geom)
    SELECT node_id, node_type, cat_node.dnom, num_arcs, (array_agg(cat_arc.dnom))[1], (array_agg(cat_arc.dnom))[2], node.the_geom 
        FROM node 
        INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
        INNER JOIN cat_node ON cat_node.id = nodecat_id 
	INNER JOIN node_type ON node_type.id=cat_node.nodetype_id
        INNER JOIN cat_arc ON cat_arc.id = arc.arccat_id
        GROUP BY node.node_id, cat_node.dnom, node_type.id, num_arcs
        HAVING COUNT(*) = 2 AND (((array_agg(cat_arc.dnom))[1] != (array_agg(cat_arc.dnom))[2] AND node_type.id != 'REDUÇÃO') OR ((array_agg(cat_arc.dnom))[1] = (array_agg(cat_arc.dnom))[2] AND node_type.id = 'REDUÇÃO'));

    INSERT INTO anl_geometrical_consistency (node_id, node_type, node_dnom, num_arcs, arc_dnom1, arc_dnom2, arc_dnom3, the_geom)
    SELECT node_id, node_type, cat_node.dnom, num_arcs, (array_agg(cat_arc.dnom))[1], (array_agg(cat_arc.dnom))[2], (array_agg(cat_arc.dnom))[3], node.the_geom 
        FROM node 
        INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
        INNER JOIN cat_node ON cat_node.id = nodecat_id
	INNER JOIN node_type ON node_type.id=cat_node.nodetype_id
        INNER JOIN cat_arc ON cat_arc.id = arc.arccat_id
        GROUP BY node.node_id, cat_node.dnom, node_type.type, num_arcs
        HAVING COUNT(*) = 3 AND cat_node.num_arcs = 3 AND COUNT(DISTINCT cat_arc.dnom) > 2;

    INSERT INTO anl_geometrical_consistency (node_id, node_type, node_dnom, num_arcs, arc_dnom1, arc_dnom2, arc_dnom3, arc_dnom4, the_geom)
    SELECT node_id, node_type, cat_node.dnom, num_arcs, (array_agg(cat_arc.dnom))[1], (array_agg(cat_arc.dnom))[2], (array_agg(cat_arc.dnom))[3], (array_agg(cat_arc.dnom))[4], node.the_geom 
        FROM node 
        INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id 
        INNER JOIN cat_node ON cat_node.id = nodecat_id
	INNER JOIN node_type ON node_type.id=cat_node.nodetype_id
        INNER JOIN cat_arc ON cat_arc.id = arc.arccat_id
        GROUP BY node.node_id, cat_node.dnom, node_type.type, num_arcs
        HAVING COUNT(*) = 4 AND cat_node.num_arcs = 4 AND COUNT(DISTINCT cat_arc.dnom) > 2;    

    --PERFORM audit_function(0,30);
    RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;