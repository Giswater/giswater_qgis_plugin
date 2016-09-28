/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_flow_trace_recursive(node_id_arg character varying)  RETURNS void AS $BODY$
DECLARE
    exists_id character varying;
    rec_table record;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;
    
    -- Check if the node is already computed
    SELECT node_id INTO exists_id FROM anl_flow_trace_node WHERE node_id = node_id_arg;

    -- Compute proceed
    IF NOT FOUND THEN
    
        -- Update value
        INSERT INTO anl_flow_trace_node VALUES(node_id_arg, (SELECT the_geom FROM node WHERE node_id = node_id_arg));
        
        -- Loop for all the upstream nodes
        FOR rec_table IN SELECT arc_id, node_1, the_geom FROM arc WHERE node_2 = node_id_arg
        LOOP

            -- Insert into tables
            INSERT INTO anl_flow_trace_arc VALUES(rec_table.arc_id, rec_table.the_geom);

            -- Call recursive function weighting with the pipe capacity
            PERFORM gw_fct_flow_trace_recursive(rec_table.node_1);

        END LOOP;
    
    END IF;
    RETURN;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
