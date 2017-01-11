/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION gw_ses.gw_fct_anl_topological_consistency()
  RETURNS void AS
$BODY$
DECLARE
    rec_node record;
    rec record;

BEGIN

    -- Search path
    SET search_path = "gw_ses", public;

    -- Clear tables
    DELETE FROM anl_topological_consistency;

    -- Check number of connected pipes to node depending on node type
    INSERT INTO anl_topological_consistency (node_id, node_type, num_arcs, the_geom)
    SELECT node_id, node_type, COUNT(*), node.the_geom FROM node INNER JOIN arc ON arc.node_1 = node.node_id OR arc.node_2 = node.node_id WHERE node.node_type != 'CAIXA' GROUP BY node.node_id HAVING COUNT(*) = 1;

    PERFORM audit_function(0,30);
    RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;