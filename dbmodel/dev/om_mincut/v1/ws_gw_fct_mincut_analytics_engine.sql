﻿/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2306

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut_analytics_engine(character varying, integer);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_analytics_engine(   arc_id_arg character varying,  node_id_arg character varying,    result_id_arg integer)
RETURNS void AS
$BODY$
DECLARE
    exists_id      character varying;
    rec_table      record;
    controlValue   integer;
    node_aux       public.geometry;
    arc_aux        public.geometry;
    stack          varchar[];


BEGIN


    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    --Push first element into the array
    stack := array_append(stack, node_id_arg);

    --Main loop
    WHILE (array_length(stack, 1) > 0) LOOP

        --Get next element
        node_id_arg = stack[array_length(stack, 1)];

        -- Get node public.geometry
        SELECT the_geom INTO node_aux FROM v_edit_node  JOIN value_state_type ON state_type=value_state_type.id WHERE (node_id = node_id_arg) AND (is_operative IS TRUE);

        -- Check node_id being a valve
        SELECT node_id INTO exists_id FROM anl_mincut_result_valve WHERE node_id = node_id_arg 
        AND (unaccess = FALSE) AND (broken  = FALSE) AND result_id=result_id_arg;
        
        IF FOUND THEN
            UPDATE anl_mincut_result_valve SET proposed = TRUE WHERE node_id=node_id_arg AND result_id=result_id_arg;
            --Remove element form array
            stack := stack[1:(array_length(stack,1) - 1)];

        ELSE

            -- Check if extreme is being a inlet
	    SELECT COUNT(*) INTO controlValue FROM anl_mincut_inlet_x_exploitation WHERE node_id = node_id_arg;
	    IF controlValue = 1 THEN
	    END IF;

		  RAISE NOTICE ' Inserting into anl_mincut_result_node; %', node_id_arg;
                  INSERT INTO anl_mincut_result_node (node_id, the_geom, result_id) VALUES(node_id_arg, node_aux, result_id_arg);
		
            -- Check if the anl_mincut_result_valve is already computed
            SELECT node_id INTO exists_id FROM anl_mincut_result_node WHERE node_id = node_id_arg AND result_id=result_id_arg;

            -- Compute proceed
            IF NOT FOUND THEN
            
                -- Update value
		RAISE NOTICE ' Inserting into anl_mincut_result_node; %', node_id_arg;
                INSERT INTO anl_mincut_result_node (node_id, the_geom, result_id) VALUES(node_id_arg, node_aux, result_id_arg);         
                                       
                -- Loop for all the upstream nodes
                FOR rec_table IN SELECT arc_id, node_1 FROM v_edit_arc JOIN value_state_type ON state_type=value_state_type.id 
                WHERE (node_2 = node_id_arg) AND (is_operative IS TRUE)
                LOOP

			SELECT arc_id INTO exists_id FROM anl_mincut_result_arc WHERE arc_id = rec_table.arc_id AND result_id=result_id_arg;

                    -- Compute proceed
                    IF NOT FOUND THEN
					
			RAISE NOTICE ' Inserting into anl_arc; %', rec_table.arc_id;
                      	INSERT INTO "anl_arc" (arc_id, arc_id_aux, the_geom, fid) VALUES(rec_table.arc_id, arc_id_arg, arc_aux, 30);

                   	RAISE NOTICE ' Inserting into anl_mincut_result_arc; %', rec_table.arc_id;
			INSERT INTO "anl_mincut_result_arc" (arc_id, the_geom, result_id) VALUES(rec_table.arc_id, rec_table.the_geom, result_id_arg);

                    END IF;

                    --Push element into the array
                    stack := array_append(stack, rec_table.node_1);
                
                END LOOP;

                -- Loop for all the downstream nodes
                FOR rec_table IN SELECT arc_id, node_2 FROM v_edit_arc JOIN value_state_type ON state_type=value_state_type.id 
                WHERE (node_1 = node_id_arg) AND (is_operative IS TRUE)
                LOOP
                    -- Insert into tables
                    SELECT arc_id INTO exists_id FROM anl_mincut_result_arc WHERE arc_id = rec_table.arc_id AND result_id=result_id_arg;

					-- Compute proceed
                    IF NOT FOUND THEN
			RAISE NOTICE ' Inserting into anl_arc; %', rec_table.arc_id;
                      	INSERT INTO "anl_arc" (arc_id, arc_id_aux, the_geom, fid) VALUES(rec_table.arc_id, arc_id_arg, arc_aux, 30);

			RAISE NOTICE ' Inserting into anl_mincut_result_arc; %', rec_table.arc_id;
			INSERT INTO "anl_mincut_result_arc" (arc_id, the_geom, result_id) VALUES(rec_table.arc_id, rec_table.the_geom, result_id_arg);   
                      	              
                    END IF;

                    --Push element into the array
                    stack := array_append(stack, rec_table.node_2);

                END LOOP;

            ELSE

                --Remove element form array
                stack := stack[1:(array_length(stack,1) - 1)];

            END IF;
        END IF;

    END LOOP;

    RETURN;

        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;