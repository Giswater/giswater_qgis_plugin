/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_mincut_recursive(node_id_arg character varying) RETURNS void AS $BODY$
DECLARE
    exists_id      character varying;
    rec_table      record;
    controlValue   integer;
    node_aux       public.geometry;
    arc_aux        public.geometry;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Get node public.geometry
    SELECT the_geom INTO node_aux FROM node WHERE node_id = node_id_arg;

    -- Check node being a valve
    SELECT node_id INTO exists_id FROM v_edit_valve WHERE node_id = node_id_arg AND (acessibility = FALSE) AND (broken  = FALSE);
    IF FOUND THEN

        -- Check if the node is already computed
        SELECT valve_id INTO exists_id FROM anl_mincut_valve WHERE valve_id = node_id_arg;

        -- Compute proceed
        IF NOT FOUND THEN

            -- Insert valve id
            INSERT INTO anl_mincut_valve VALUES(node_id_arg, node_aux);

        END IF;

    ELSE

        -- Check if the node is already computed
        SELECT node_id INTO exists_id FROM anl_mincut_node WHERE node_id = node_id_arg;

        -- Compute proceed
        IF NOT FOUND THEN

            -- Update value
            INSERT INTO anl_mincut_node VALUES(node_id_arg, node_aux);
        
            -- Loop for all the upstream nodes
            FOR rec_table IN SELECT arc_id, node_1 FROM arc WHERE node_2 = node_id_arg
            LOOP

                -- Insert into tables
                SELECT arc_id INTO exists_id FROM anl_mincut_arc WHERE arc_id = rec_table.arc_id;

                -- Compute proceed
                IF NOT FOUND THEN
                    SELECT the_geom INTO arc_aux FROM arc WHERE arc_id = rec_table.arc_id;
                    INSERT INTO anl_mincut_arc VALUES(rec_table.arc_id, arc_aux);
                END IF;

                -- Call recursive function weighting with the pipe capacity
                PERFORM gw_fct_mincut_recursive(rec_table.node_1);
                
            END LOOP;

            -- Loop for all the downstream nodes
            FOR rec_table IN SELECT arc_id, node_2 FROM arc WHERE node_1 = node_id_arg
            LOOP

                -- Insert into tables
                SELECT arc_id INTO exists_id FROM anl_mincut_arc WHERE arc_id = rec_table.arc_id;

                -- Compute proceed
                IF NOT FOUND THEN
                    SELECT the_geom INTO arc_aux FROM arc WHERE arc_id = rec_table.arc_id;
                    INSERT INTO anl_mincut_arc VALUES(rec_table.arc_id, arc_aux);
                END IF;

                -- Call recursive function weighting with the pipe capacity
                PERFORM gw_fct_mincut_recursive(rec_table.node_2);

            END LOOP;

        END IF;
    END IF;

    RETURN;

        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

