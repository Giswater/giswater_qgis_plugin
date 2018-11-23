/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2304

------------------------------------------
-- Mincut function with massive parameters
------------------------------------------

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut(p_feature_id character varying, p_feature_type character varying, p_result_id integer, counter int8, total int8)
  RETURNS void AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_mincut(arc_id, 'arc', 1, (row_number() over (order by arc_id)), (select count(*) from SCHEMA_NAME.v_edit_arc)) FROM SCHEMA_NAME.v_edit_arc;
*/

DECLARE

BEGIN
    -- Search path
    SET search_path = SCHEMA_NAME, public;
  	
	PERFORM gw_fct_mincut (p_feature_id, p_feature_type, p_result_id, current_user);
	
	-- raise notice
	IF counter>0 AND total>0 THEN
		RAISE NOTICE '[%/%]  Feature id: % ', counter, total, p_feature_id;
	ELSIF counter>0 THEN
		RAISE NOTICE '[%] Feature id: % ', counter, p_feature_id;
	ELSE
		RAISE NOTICE 'Feature id: % ', p_feature_id;
	END IF;
	
	
	RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

	
	
------------------------------------------
-- Mincut function (with nornal parameters)
------------------------------------------
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut( element_id_arg character varying, type_element_arg character varying, result_id_arg integer, cur_user_var text)
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
    v_return_text	text;
    cont1 		integer default 0;
    v_publish_user 	text;
    v_muni_id 		integer;
    v_numarcs		integer;
    v_length 		double precision;
    v_numconnecs 	integer;
    v_numhydrometer	integer;
    v_debug		Boolean;

BEGIN
    -- Search path
    SET search_path = SCHEMA_NAME, public;

    SELECT value::boolean INTO v_debug FROM config_param_system WHERE parameter='om_mincut_debug';

    IF v_debug THEN
	RAISE NOTICE '1-Delete previous data from same result_id';
    END IF;
    DELETE FROM "anl_mincut_result_node" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_arc" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_polygon" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_connec" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_hydrometer" where result_id=result_id_arg; 
    DELETE FROM "anl_mincut_result_valve" where result_id=result_id_arg;

    IF v_debug THEN
	RAISE NOTICE '2-Identification exploitation, macroexploitation and municipality';
    END IF;
    IF type_element_arg='node' OR type_element_arg='NODE' THEN
		SELECT expl_id INTO expl_id_arg FROM node WHERE node_id=element_id_arg;
		SELECT muni_id INTO v_muni_id FROM node WHERE node_id=element_id_arg;
    ELSE
		SELECT expl_id INTO expl_id_arg FROM arc WHERE arc_id=element_id_arg;
		SELECT muni_id INTO v_muni_id FROM arc WHERE arc_id=element_id_arg;
    END IF;
    
    SELECT macroexpl_id INTO macroexpl_id_arg FROM exploitation WHERE expl_id=expl_id_arg;

    UPDATE anl_mincut_result_cat SET muni_id=v_muni_id WHERE id=result_id_arg;
    
    IF v_debug THEN
	RAISE NOTICE '3-Update exploitation selector (of user) according the macroexploitation system';
    END IF;    
    INSERT INTO selector_expl (expl_id, cur_user)
    SELECT expl_id, current_user from exploitation 
    where macroexpl_id=macroexpl_id_arg and expl_id not in (select expl_id from selector_expl);

    IF v_debug THEN
	RAISE NOTICE '4-update values of mincut cat table';
    END IF;
    UPDATE anl_mincut_result_cat SET expl_id=expl_id_arg WHERE id=result_id_arg;
    UPDATE anl_mincut_result_cat SET macroexpl_id=macroexpl_id_arg WHERE id=result_id_arg;

    IF v_debug THEN
	RAISE NOTICE '5-Start mincut process';
    END IF;     
    INSERT INTO anl_mincut_result_valve (result_id, node_id, unaccess, closed, broken, the_geom) 
    SELECT result_id_arg, node.node_id, false::boolean, closed, broken, node.the_geom
    FROM v_anl_mincut_selected_valve
    JOIN node on node.node_id=v_anl_mincut_selected_valve.node_id
    JOIN exploitation ON node.expl_id=exploitation.expl_id
    WHERE macroexpl_id=macroexpl_id_arg;

    IF v_debug THEN
	RAISE NOTICE '6-Identify unaccess valves';
    END IF;
    UPDATE anl_mincut_result_valve SET unaccess=true WHERE result_id=result_id_arg AND node_id IN 
    (SELECT node_id FROM anl_mincut_result_valve_unaccess WHERE result_id=result_id_arg);

     -- The element to isolate could be an arc or a node
    IF type_element_arg = 'arc' OR type_element_arg='ARC' THEN
	
		IF (SELECT state FROM arc WHERE (arc_id = element_id_arg))=0 THEN
			PERFORM audit_function(3002,2304,element_id_arg);
		END IF;
		
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

            IF node_1_aux IS NULL OR node_2_aux IS NULL THEN
		PERFORM audit_function(3006,2304);
            END IF;
            

            -- Check extreme being a valve
            SELECT COUNT(*) INTO controlValue FROM anl_mincut_result_valve 
            WHERE node_id = node_1_aux AND (unaccess = FALSE) AND (broken  = FALSE) AND result_id=result_id_arg;

            IF controlValue = 1 THEN
                -- Set proposed valve
                UPDATE anl_mincut_result_valve SET proposed = TRUE WHERE node_id=node_1_aux AND result_id=result_id_arg;
                
            ELSE
				-- Check if extreme if being a inlet
				SELECT COUNT(*) INTO controlValue FROM anl_mincut_inlet_x_exploitation WHERE node_id = node_1_aux;
			
				IF controlValue = 0 THEN
					-- Compute the tributary area using DFS
					PERFORM gw_fct_mincut_engine(node_1_aux, result_id_arg);	
				ELSE
					SELECT the_geom INTO node_aux FROM v_edit_node WHERE node_id = node_1_aux;
					INSERT INTO anl_mincut_result_node (node_id, the_geom, result_id) VALUES(node_1_aux, node_aux, result_id_arg);	
				END IF;
			END IF;

			-- Check other extreme being a valve
            SELECT COUNT(*) INTO controlValue FROM anl_mincut_result_valve 
            WHERE node_id = node_2_aux AND (unaccess = FALSE) AND (broken  = FALSE) AND result_id=result_id_arg;
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
				-- Check if extreme if being a inlet
				SELECT COUNT(*) INTO controlValue FROM anl_mincut_inlet_x_exploitation WHERE node_id = node_2_aux;
				IF controlValue = 0 THEN
					-- Compute the tributary area using DFS
					PERFORM gw_fct_mincut_engine(node_2_aux, result_id_arg);	
				ELSE 
					SELECT the_geom INTO node_aux FROM v_edit_node WHERE node_id = node_2_aux;
					INSERT INTO anl_mincut_result_node (node_id, the_geom, result_id) VALUES(node_2_aux, node_aux, result_id_arg);		
				END IF;	
			END IF;
		
		-- The arc_id was not found
		ELSE 
				PERFORM audit_function(1082,2304,element_id_arg);
		END IF;

    ELSE

		IF (SELECT state FROM node WHERE (node_id = element_id_arg))=0 THEN
            PERFORM audit_function(3004,2304,element_id_arg);
		END IF;
	
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

	-- Working with the normal case (om_mincut_analysis_dminsector NOT TRUE)--> This variable is reserved to use mincut as tool to identify the mininum agrupation of elements of network
	IF (SELECT value::boolean from config_param_user where parameter='om_mincut_analysis_dminsector' and cur_user=current_user) IS NOT TRUE THEN 
		IF v_debug THEN
			RAISE NOTICE '7-Compute flow trace on network using the tanks and sources that belong on the macroexpl_id using inlet function or inverted flowtrace function';
		END IF;		
		IF (select value::boolean from config_param_system where parameter='om_mincut_use_pgrouting')  IS NOT TRUE THEN 
			SELECT gw_fct_mincut_inlet_flowtrace (result_id_arg) into cont1;
		ELSE
			SELECT gw_fct_mincut_inverted_flowtrace(result_id_arg) into cont1;
		END IF;
		
		IF v_debug THEN
			RAISE NOTICE '8-Delete valves not proposed, not unaccessible, not closed and not broken';
		END IF;
		DELETE FROM anl_mincut_result_valve WHERE node_id NOT IN (SELECT node_1 FROM arc JOIN anl_mincut_result_arc ON anl_mincut_result_arc.arc_id=arc.arc_id 
						WHERE result_id=result_id_arg UNION 
						SELECT node_2 FROM arc JOIN anl_mincut_result_arc ON anl_mincut_result_arc.arc_id=arc.arc_id WHERE result_id=result_id_arg)
						AND result_id=result_id_arg;
						
		UPDATE anl_mincut_result_valve SET proposed = FALSE WHERE closed = TRUE AND result_id=result_id_arg ;

		IF (select value::boolean from config_param_system where parameter='om_mincut_disable_check_temporary_overlap')  IS NOT TRUE THEN 
			IF v_debug THEN
				RAISE NOTICE '9-Check temporary overlap control against other planified mincuts';
			END IF;
			SELECT gw_fct_mincut_result_overlap(result_id_arg, current_user) INTO v_return_text;
	
		END IF;

		IF v_debug THEN
			RAISE NOTICE '10-Update mincut selector';
		END IF;
		--    Update the selector
		IF (SELECT COUNT(*) FROM anl_mincut_result_selector WHERE cur_user = current_user) > 0 THEN
			UPDATE anl_mincut_result_selector SET result_id = result_id_arg WHERE cur_user = current_user;
		ELSE
			INSERT INTO anl_mincut_result_selector(cur_user, result_id) VALUES (current_user, result_id_arg);
		END IF;
		--    Update the selector for publish_user
		-- Get publish user
		SELECT value FROM config_param_system WHERE parameter='api_publish_user' 
		INTO v_publish_user;
		IF v_publish_user IS NOT NULL THEN
			IF (SELECT COUNT(*) FROM anl_mincut_result_selector WHERE cur_user = v_publish_user AND result_id=result_id_arg) = 0 THEN
				INSERT INTO anl_mincut_result_selector(cur_user, result_id) VALUES (v_publish_user, result_id_arg);
			END IF;
		END IF;	
		
		IF v_debug THEN
			RAISE NOTICE '11-Insert into anl_mincut_result_connec table ';
		END IF;			
		INSERT INTO anl_mincut_result_connec (result_id, connec_id, the_geom)
		SELECT result_id_arg, connec_id, connec.the_geom FROM connec JOIN anl_mincut_result_arc ON connec.arc_id=anl_mincut_result_arc.arc_id WHERE result_id=result_id_arg AND state=1;

		IF v_debug THEN
			RAISE NOTICE '12-Insert into anl_mincut_result_hydrometer table ';
		END IF;
		INSERT INTO anl_mincut_result_hydrometer (result_id, hydrometer_id)
		SELECT result_id_arg,rtc_hydrometer_x_connec.hydrometer_id FROM rtc_hydrometer_x_connec 
		JOIN anl_mincut_result_connec ON rtc_hydrometer_x_connec.connec_id=anl_mincut_result_connec.connec_id 
		JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
		WHERE result_id=result_id_arg;

		-- Working with the case of study of mincut pipe hazard analysis  (om_mincut_analysis_pipehazard=true)
		IF (SELECT value::boolean FROM config_param_user WHERE parameter='om_mincut_analysis_pipehazard' AND cur_user=current_user) IS TRUE THEN

			-- Insert values on audit_log_data table
			SELECT count(arc_id), sum(st_length(the_geom))::numeric(12,2) INTO v_numarcs, v_length FROM anl_mincut_result_arc WHERE result_id=result_id_arg group by result_id;
			SELECT count(connec_id) INTO v_numconnecs FROM connec JOIN anl_mincut_result_arc ON connec.arc_id=anl_mincut_result_arc.arc_id WHERE result_id=result_id_arg AND state=1;
			SELECT count (rtc_hydrometer_x_connec.hydrometer_id) INTO v_numhydrometer FROM rtc_hydrometer_x_connec JOIN anl_mincut_result_connec ON rtc_hydrometer_x_connec.connec_id=anl_mincut_result_connec.connec_id 
			JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
			JOIN connec ON connec.connec_id=v_rtc_hydrometer.connec_id WHERE result_id=result_id_arg;
			
			v_return_text = concat('{"arcs":',v_numarcs,', "length":',v_length, ', "connecs":',v_numconnecs,', "hydrometers":',v_numhydrometer,'}');
			
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) 
			VALUES (29, 'arc', element_id_arg, v_return_text);
		END IF;
	ELSE
		-- Insert values on audit_log_data table when case of study of mincut minimum sector analysis (om_mincut_analysis_dminsector=true)
		INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) 
		SELECT 34, element_id_arg, arc_id, concat('{"dminsector":',element_id_arg,'}') FROM anl_mincut_result_arc WHERE result_id=result_id_arg AND arc_id 
		NOT IN (SELECT feature_id FROM audit_log_data WHERE fprocesscat_id=34 AND user_name=current_user);
	END IF;

	IF v_debug THEN
		RAISE NOTICE 'End of process ';
	END IF;
	RETURN v_return_text;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



