/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2220


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_flow_trace_recursive(node_id_arg character varying) RETURNS void AS $BODY$
DECLARE
    exists_id character varying;
    rec_table record;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;
    
    -- Check if the node is already computed
    SELECT node_id INTO exists_id FROM anl_flow_node WHERE node_id = node_id_arg AND cur_user="current_user"() AND context='Flow trace';

    -- Compute proceed
    IF NOT FOUND THEN
    
        -- Update value
        INSERT INTO anl_flow_node (node_id, expl_id, context, the_geom) VALUES
        (node_id_arg, (SELECT expl_id FROM v_edit_node WHERE node_id = node_id_arg), 'Flow trace', (SELECT the_geom FROM v_edit_node WHERE node_id = node_id_arg));
        
        -- Loop for all the upstream arcs
        FOR rec_table IN SELECT arc_id, node_1, the_geom, expl_id FROM v_edit_arc WHERE node_2 = node_id_arg
        LOOP

            -- Insert into tables
            INSERT INTO anl_flow_arc (arc_id, expl_id, context, the_geom) VALUES
            (rec_table.arc_id, rec_table.expl_id, 'Flow trace', rec_table.the_geom);

            -- Call recursive function weighting with the pipe capacity
            PERFORM gw_fct_flow_trace_recursive(rec_table.node_1);

        END LOOP;
    
    END IF;
    RETURN;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
