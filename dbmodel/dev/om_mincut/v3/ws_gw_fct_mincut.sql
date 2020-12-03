/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2304

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut( element_id_arg character varying, type_element_arg character varying, result_id_arg integer)
  RETURNS json AS
$BODY$

/*EXAMPLE
INSERT INTO SCHEMA_NAME.anl_mincut_result_cat VALUES (1);
SELECT SCHEMA_NAME.gw_fct_mincut('2205', 'arc', 1)
*/

DECLARE
    node_1_aux		text;
    node_2_aux		text;
    controlValue	integer;
    exists_id		text;
    polygon_aux		public.geometry;
    polygon_aux2	public.geometry;
    arc_aux        	 public.geometry;
    node_aux        	public.geometry;    
    srid_schema		text;
    expl_id_arg         integer;
    macroexpl_id_arg	integer;
    v_return		json;
    cont1 		integer default 0;
    v_publish_user 	text;
    v_muni_id 		integer;
    v_numarcs		integer;
    v_length 		double precision;
    v_numconnecs 	integer;
    v_numhydrometer	integer;
    v_debug		Boolean;
    v_overlap		text;
    v_geometry 		text;
    v_data		json;
    v_volume 		float;
    v_priority		json;
    v_count		int2;
    
BEGIN
    -- Search path
    SET search_path = SCHEMA_NAME, public;

    SELECT value::boolean INTO v_debug FROM config_param_system WHERE parameter='om_mincut_debug';

    IF v_debug THEN RAISE NOTICE '1-Delete previous data from same result_id'; END IF;
    
    DELETE FROM "anl_mincut_result_node" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_arc" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_polygon" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_connec" where result_id=result_id_arg;
    DELETE FROM "anl_mincut_result_hydrometer" where result_id=result_id_arg; 
    DELETE FROM "anl_mincut_result_valve" where result_id=result_id_arg;

    IF v_debug THEN RAISE NOTICE '2-Identification exploitation, macroexploitation and municipality'; END IF;
    
    IF type_element_arg='node' OR type_element_arg='NODE' THEN
		SELECT expl_id INTO expl_id_arg FROM node WHERE node_id=element_id_arg;
		SELECT muni_id INTO v_muni_id FROM node WHERE node_id=element_id_arg;
    ELSE
		SELECT expl_id INTO expl_id_arg FROM arc WHERE arc_id=element_id_arg;
		SELECT muni_id INTO v_muni_id FROM arc WHERE arc_id=element_id_arg;
    END IF;
    
    SELECT macroexpl_id INTO macroexpl_id_arg FROM exploitation WHERE expl_id=expl_id_arg;

    UPDATE anl_mincut_result_cat SET muni_id=v_muni_id WHERE id=result_id_arg;
    
    IF v_debug THEN RAISE NOTICE '3-Update exploitation selector (of user) according the macroexploitation system';   END IF;    
    
    INSERT INTO selector_expl (expl_id, cur_user)
    SELECT expl_id, current_user from exploitation 
    where macroexpl_id=macroexpl_id_arg and expl_id not in (select expl_id from selector_expl);

    -- Delete from state selector (0)
    SELECT count(*) INTO v_count FROM selector_state WHERE cur_user=current_user AND state_id=0;
    DELETE FROM selector_state WHERE cur_user=current_user AND state_id=0;

    IF v_debug THEN RAISE NOTICE '4-update values of mincut cat table'; END IF;
 
    UPDATE anl_mincut_result_cat SET expl_id=expl_id_arg WHERE id=result_id_arg;
    UPDATE anl_mincut_result_cat SET macroexpl_id=macroexpl_id_arg WHERE id=result_id_arg;

    IF v_debug THEN RAISE NOTICE '5-Start mincut process'; END IF;     
    
    INSERT INTO anl_mincut_result_valve (result_id, node_id, unaccess, closed, broken, the_geom) 
    SELECT result_id_arg, node.node_id, false::boolean, closed, broken, node.the_geom
    FROM v_anl_mincut_selected_valve
    JOIN node on node.node_id=v_anl_mincut_selected_valve.node_id
    JOIN exploitation ON node.expl_id=exploitation.expl_id
    WHERE macroexpl_id=macroexpl_id_arg;

    IF v_debug THEN RAISE NOTICE '6-Identify unaccess valves'; END IF;
    
    UPDATE anl_mincut_result_valve SET unaccess=true WHERE result_id=result_id_arg AND node_id IN 
    (SELECT node_id FROM anl_mincut_result_valve_unaccess WHERE result_id=result_id_arg);

     -- The element to isolate must be an arc 
    IF type_element_arg = 'arc' OR type_element_arg='ARC' THEN
	
		IF (SELECT state FROM arc WHERE (arc_id = element_id_arg))=0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
       		"data":{"message":"3002", "function":"2304","debug_msg":"'||element_id_arg||'"}}$$);';
		END IF;
		
        -- Check an existing arc
        SELECT COUNT(*) INTO controlValue FROM v_edit_arc JOIN value_state_type ON state_type=value_state_type.id 
        WHERE (arc_id = element_id_arg) AND (is_operative IS TRUE);
        IF controlValue = 1 THEN

		-- Select public.geometry
		SELECT the_geom INTO arc_aux FROM v_edit_arc WHERE arc_id = element_id_arg;
       
		-- call graf analytics function (MCBASE)
		v_data = concat ('{"data":{"grafClass":"MINCUT", "arc":"', element_id_arg ,'", "parameters":{"id":', result_id_arg ,', "process":"base"}}}');
		RAISE NOTICE 'v_data MINCUT %', v_data;
		PERFORM gw_fct_grafanalytics_mincut(v_data);

		IF v_debug THEN RAISE NOTICE '7-Compute flow trace on network';	END IF;		

		-- call inlet function
		SELECT gw_fct_mincut_inverted_flowtrace(result_id_arg) into cont1;
		
		IF v_debug THEN RAISE NOTICE '8-Delete valves not proposed, not unaccessible, not closed and not broken'; END IF;
		
		DELETE FROM anl_mincut_result_valve WHERE node_id NOT IN (SELECT node_1 FROM arc JOIN anl_mincut_result_arc ON anl_mincut_result_arc.arc_id=arc.arc_id 
						WHERE result_id=result_id_arg UNION 
						SELECT node_2 FROM arc JOIN anl_mincut_result_arc ON anl_mincut_result_arc.arc_id=arc.arc_id WHERE result_id=result_id_arg)
						AND result_id=result_id_arg;
						
		UPDATE anl_mincut_result_valve SET proposed = FALSE WHERE closed = TRUE AND result_id=result_id_arg ;

		IF (select value::boolean from config_param_system where parameter='om_mincut_disable_check_temporary_overlap')  IS NOT TRUE THEN 
		
			IF v_debug THEN	RAISE NOTICE '9-Check temporary overlap control against other planified mincuts'; END IF;
			
			SELECT gw_fct_mincut_result_overlap(result_id_arg, current_user) INTO v_overlap;	
		END IF;

		IF v_debug THEN	RAISE NOTICE '10-Update mincut selector';END IF;
		
		--    Update the selector
		-- current user
		DELETE FROM anl_mincut_result_selector WHERE result_id = result_id_arg AND cur_user = current_user;
		INSERT INTO anl_mincut_result_selector(cur_user, result_id) VALUES (current_user, result_id_arg);

		-- publish user
		SELECT value FROM config_param_system WHERE parameter='admin_publish_user'
		INTO v_publish_user;
		IF v_publish_user IS NOT NULL THEN
			DELETE FROM anl_mincut_result_selector WHERE result_id = result_id_arg AND cur_user = v_publish_user;
			INSERT INTO anl_mincut_result_selector(cur_user, result_id) VALUES (v_publish_user, result_id_arg);
		END IF;	
		
		IF v_debug THEN RAISE NOTICE '11-Insert into anl_mincut_result_connec table ';	END IF;			
		
		INSERT INTO anl_mincut_result_connec (result_id, connec_id, the_geom)
		SELECT result_id_arg, connec_id, connec.the_geom FROM connec JOIN anl_mincut_result_arc ON connec.arc_id=anl_mincut_result_arc.arc_id WHERE result_id=result_id_arg AND state=1;

		IF v_debug THEN RAISE NOTICE '12-Insert into anl_mincut_result_hydrometer table ';END IF;
		
		INSERT INTO anl_mincut_result_hydrometer (result_id, hydrometer_id)
		SELECT result_id_arg,rtc_hydrometer_x_connec.hydrometer_id FROM rtc_hydrometer_x_connec 
		JOIN anl_mincut_result_connec ON rtc_hydrometer_x_connec.connec_id=anl_mincut_result_connec.connec_id 
		LEFT JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
		WHERE result_id=result_id_arg;

		-- Insert hazard values on audit_log_data table
		-- arcs
		SELECT count(arc_id), sum(st_length(arc.the_geom))::numeric(12,2) INTO v_numarcs, v_length FROM anl_mincut_result_arc JOIN arc USING (arc_id) WHERE result_id=result_id_arg group by result_id;
		SELECT sum(area*st_length(arc.the_geom))::numeric(12,2) INTO v_volume FROM anl_mincut_result_arc JOIN arc USING (arc_id) JOIN cat_arc ON arccat_id=cat_arc.id WHERE result_id=result_id_arg group by result_id, arccat_id;

		--connec
		SELECT count(connec_id) INTO v_numconnecs FROM connec JOIN anl_mincut_result_arc ON connec.arc_id=anl_mincut_result_arc.arc_id WHERE result_id=result_id_arg AND state=1;

		-- total hydrometers
		SELECT count (rtc_hydrometer_x_connec.hydrometer_id) INTO v_numhydrometer FROM rtc_hydrometer_x_connec JOIN anl_mincut_result_connec ON rtc_hydrometer_x_connec.connec_id=anl_mincut_result_connec.connec_id 
		JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
		JOIN connec ON connec.connec_id=v_rtc_hydrometer.connec_id WHERE result_id=result_id_arg;

		-- priority hydrometers
		v_priority = 	(SELECT (array_to_json(array_agg((b)))) FROM (SELECT concat('{"category":"',category_id,'","number":"', count(rtc_hydrometer_x_connec.hydrometer_id), '"}')::json as b FROM rtc_hydrometer_x_connec 
				JOIN anl_mincut_result_connec ON rtc_hydrometer_x_connec.connec_id=anl_mincut_result_connec.connec_id 
				JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
				JOIN connec ON connec.connec_id=v_rtc_hydrometer.connec_id WHERE result_id=result_id_arg GROUP BY category_id limit 1)a);
				
		IF v_priority IS NULL THEN v_priority='{}'; END IF;
	
		v_return = concat('{"minsector_id":"',element_id_arg,'","arcs":{"number":"',v_numarcs,'", "length":"',v_length,'", "volume":"', 
		v_volume, '"}, "connecs":{"number":"',v_numconnecs,'","hydrometers":{"number":"',v_numhydrometer,'","priority":',v_priority,'}}}');
			
		INSERT INTO audit_log_data (fid, feature_type, feature_id, log_message) VALUES (29, 'arc', element_id_arg, v_return);

		-- calculate the boundary of mincut using arcs and valves
		EXECUTE ' SELECT st_astext(st_envelope(st_extent(st_buffer(the_geom,20)))) FROM (SELECT the_geom FROM anl_mincut_result_arc WHERE result_id='||result_id_arg||
			' UNION SELECT the_geom FROM anl_mincut_result_valve WHERE result_id='||result_id_arg||') a'    
			INTO v_geometry;

		-- restore state selector
		IF v_count = 1 THEN
			INSERT INTO selector_state (cur_user, state_id) VALUES (current_user, 0);
		END IF;

		-- returning
		v_return = concat('{"mincutOverlap":"',v_overlap,'", "geometry":"',v_geometry,'"}');

		IF v_debug THEN RAISE NOTICE 'End of process';	END IF;
	END IF;

END IF;

RETURN v_return;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



