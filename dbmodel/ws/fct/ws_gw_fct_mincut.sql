/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2304

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut(character varying, character varying, integer, text);
CREATE OR REPLACE FUNCTION gw_fct_mincut(    element_id_arg character varying,    type_element_arg character varying,    result_id_arg integer,    cur_user_var text)
  RETURNS text AS
$BODY$
DECLARE
    node_1_aux		text;
    node_2_aux		text;
    controlValue	integer;
    exists_id		text;
    polygon_aux		public.geometry;
    polygon_aux2	public.geometry;
    arc_aux         public.geometry;
    node_aux        public.geometry;    
    srid_schema		text;
    expl_id_arg         integer;
    macroexpl_id_arg	integer;
    conflict_text	text;
    cont1 		integer default 0;

BEGIN
    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Delete previous data from same result_id
    DELETE FROM "anl_mincut_result_node" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_arc" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_polygon" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_connec" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_hydrometer" where result_id=result_id_arg; 
    DELETE FROM "anl_mincut_result_valve" where result_id=result_id_arg;


    -- Identification of exploitation and macroexploitation
    IF type_element_arg='node' OR type_element_arg='NODE' THEN
	SELECT expl_id INTO expl_id_arg FROM node WHERE node_id=element_id_arg;
    ELSE
	SELECT expl_id INTO expl_id_arg FROM arc WHERE arc_id=element_id_arg;
    END IF;
    
    SELECT macroexpl_id INTO macroexpl_id_arg FROM exploitation WHERE expl_id=expl_id_arg;


    -- Reset exploitation selector (of user) according the macroexploitation system
    INSERT INTO selector_expl (expl_id, cur_user)
    SELECT expl_id, current_user from exploitation 
    where macroexpl_id=macroexpl_id_arg and expl_id not in (select expl_id from selector_expl);

    DELETE FROM selector_expl WHERE cur_user=current_user AND expl_id IN (select expl_id from exploitation 
    where macroexpl_id!=macroexpl_id_arg);


    -- update values of mincut cat table
    UPDATE anl_mincut_result_cat SET expl_id=expl_id_arg;
    UPDATE anl_mincut_result_cat SET macroexpl_id=macroexpl_id_arg;

     
    -- Start process
    INSERT INTO anl_mincut_result_valve (result_id, node_id, unaccess, closed, broken, the_geom) 
    SELECT result_id_arg, node.node_id, false::boolean, closed, broken, node.the_geom
    FROM v_anl_mincut_selected_valve
    JOIN node on node.node_id=v_anl_mincut_selected_valve.node_id
    JOIN exploitation ON node.expl_id=exploitation.expl_id
    WHERE macroexpl_id=macroexpl_id_arg;

    -- Identify unaccess valves
    UPDATE anl_mincut_result_valve SET unaccess=true WHERE result_id=result_id_arg AND node_id IN 
    (SELECT node_id FROM anl_mincut_result_valve_unaccess WHERE result_id=result_id_arg);


     -- The element to isolate could be an arc or a node
    IF type_element_arg = 'arc' OR type_element_arg='ARC' THEN

        -- Check an existing arc
        SELECT COUNT(*) INTO controlValue FROM v_edit_arc JOIN value_state_type ON state_type=value_state_type.id 
        WHERE (arc_id = element_id_arg) AND (is_operative IS TRUE);
        IF controlValue = 1 THEN

            -- Select public.geometry
            SELECT the_geom INTO arc_aux FROM v_edit_arc WHERE arc_id = element_id_arg;

            -- Insert arc id
            INSERT INTO "anl_mincut_result_arc" (arc_id, the_geom, result_id) VALUES (element_id_arg, arc_aux, result_id_arg);
        
            -- Run for extremes node
            SELECT node_1, node_2 INTO node_1_aux, node_2_aux FROM v_edit_arc WHERE arc_id = element_id_arg;

            -- Check extreme being a valve
            SELECT COUNT(*) INTO controlValue FROM anl_mincut_result_valve 
            WHERE node_id = node_1_aux AND (unaccess = FALSE) AND (broken  = FALSE) AND (closed = FALSE) AND result_id=result_id_arg;
            IF controlValue = 1 THEN
                -- Set proposed valve
                UPDATE anl_mincut_result_valve SET proposed = TRUE WHERE node_id=node_1_aux AND result_id=result_id_arg;
                
            ELSE
                -- Compute the tributary area using DFS
                PERFORM gw_fct_mincut_engine(node_1_aux, result_id_arg);
            END IF;

            -- Check other extreme being a valve
            SELECT COUNT(*) INTO controlValue FROM anl_mincut_result_valve 
            WHERE node_id = node_2_aux AND (unaccess = FALSE) AND (broken  = FALSE) AND (closed = FALSE) AND result_id=result_id_arg;
            IF controlValue = 1 THEN

                -- Check if the valve is already computed
               SELECT node_id INTO exists_id FROM anl_mincut_result_valve 
               WHERE node_id = node_2_aux AND (proposed = TRUE) AND result_id=result_id_arg;

                -- Compute proceed
                IF NOT FOUND THEN
			-- Set proposed valve
			UPDATE anl_mincut_result_valve SET proposed = TRUE 
			WHERE node_id=node_2_aux AND result_id=result_id_arg;
                END IF;
                
            ELSE
                -- Compute the tributary area using DFS
                PERFORM gw_fct_mincut_engine(node_2_aux, result_id_arg);

            END IF;

        -- The arc_id was not found
        ELSE 
            PERFORM audit_function(1082,2304,element_id_arg);
        END IF;

    ELSE

        -- Check an existing node
        SELECT COUNT(*) INTO controlValue FROM v_edit_node JOIN value_state_type ON state_type=value_state_type.id  
        WHERE node_id = element_id_arg AND (is_operative IS TRUE);
        IF controlValue = 1 THEN
            -- Compute the tributary area using DFS
            PERFORM gw_fct_mincut_engine(element_id_arg, result_id_arg);
        -- The arc_id was not found
        ELSE 
            PERFORM audit_function(1084,2304);
        END IF;

    END IF;

    -- Compute flow trace on network using the tanks and sources that belong on the macroexpl_id 
	IF (select value::boolean from config_param_system where parameter='om_mincut_use_pgrouting')  IS NOT TRUE THEN 
		SELECT gw_fct_mincut_inlet_flowtrace (result_id_arg) into cont1;
	ELSE
		SELECT gw_fct_mincut_inverted_flowtrace(result_id_arg) into cont1;
	END IF;
	
    -- Update the rest of the values of not proposed valves to FALSE
    UPDATE anl_mincut_result_valve SET proposed=FALSE WHERE proposed IS NULL AND result_id=result_id_arg;

    -- Check tempopary overlap control against other planified mincuts 
    SELECT gw_fct_mincut_result_overlap(result_id_arg, cur_user_var) INTO conflict_text;

    IF conflict_text IS NULL THEN 

	-- Update mincut selector
	DELETE FROM "anl_mincut_result_selector" where cur_user=cur_user_var;
	INSERT INTO "anl_mincut_result_selector" (result_id, cur_user) VALUES (result_id_arg, cur_user_var);

	INSERT INTO anl_mincut_result_connec (result_id, connec_id, the_geom)
	SELECT result_id_arg, connec_id, connec.the_geom FROM connec JOIN anl_mincut_result_arc ON connec.arc_id=anl_mincut_result_arc.arc_id WHERE result_id=result_id_arg AND state=1;
	
	INSERT INTO anl_mincut_result_hydrometer (result_id, hydrometer_id)
	SELECT result_id_arg,hydrometer_id FROM rtc_hydrometer_x_connec JOIN anl_mincut_result_connec ON rtc_hydrometer_x_connec.connec_id=anl_mincut_result_connec.connec_id WHERE result_id=result_id_arg;
	

   END IF;

		
-- End of process
RETURN conflict_text;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;