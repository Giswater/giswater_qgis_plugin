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
INSERT INTO SCHEMA_NAME.om_mincut VALUES (-1);
SELECT SCHEMA_NAME.gw_fct_mincut('134706', 'arc', -1)

--fid: 199

*/

DECLARE

node_1_aux text;
node_2_aux text;
controlValue integer;
exists_id text;
polygon_aux public.geometry;
polygon_aux2 public.geometry;
arc_aux public.geometry;
node_aux public.geometry;    
srid_schema text;
expl_id_arg integer;
macroexpl_id_arg integer;
v_return json;
cont1 integer default 0;
v_publish_user text;
v_muni_id integer;
v_debug Boolean;
v_geometry text;
v_data json;
v_mincutversion integer;
v_mincutdetails	json;
v_visiblelayer text = '"v_om_mincut_arc", "v_om_mincut_node", "v_om_mincut_connec", "v_anl_mincut_init_point"';

v_result text;
v_result_info text;
v_error_context text;
v_error_message text;
v_level integer;
v_status text;
v_message text;
v_version text;

v_numarcs integer;
v_length double precision;
v_numconnecs integer;
v_numhydrometer integer;
v_volume float;
v_priority json;

BEGIN

	-- Search path
	SET search_path = SCHEMA_NAME, public;

	SELECT value::boolean INTO v_debug FROM config_param_system WHERE parameter='om_mincut_debug';
	SELECT value::int2 INTO v_mincutversion FROM config_param_system WHERE parameter='om_mincut_version';

	-- Get project version
	SELECT giswater INTO  v_version FROM sys_version LIMIT 1;

	--set current process as users parameter
	DELETE FROM config_param_user  WHERE  parameter = 'utils_cur_trans' AND cur_user =current_user;

	INSERT INTO config_param_user (value, parameter, cur_user)
	VALUES (txid_current(),'utils_cur_trans',current_user );

	IF v_debug THEN
		RAISE NOTICE '1-Delete previous data from same result_id';
	END IF;
	DELETE FROM "om_mincut_node" where result_id=result_id_arg;

	DELETE FROM "om_mincut_arc" where result_id=result_id_arg;
	DELETE FROM "om_mincut_polygon" where result_id=result_id_arg;
	DELETE FROM "om_mincut_connec" where result_id=result_id_arg;
	DELETE FROM "om_mincut_hydrometer" where result_id=result_id_arg; 
	DELETE FROM "om_mincut_valve" where result_id=result_id_arg;

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

	UPDATE om_mincut SET muni_id=v_muni_id WHERE id=result_id_arg;

	IF v_debug THEN
		RAISE NOTICE '3-Update user selectors';
	END IF; 

	-- set exploitation selector
	INSERT INTO selector_expl (expl_id, cur_user)
	SELECT expl_id, current_user from exploitation 
	where macroexpl_id=macroexpl_id_arg and expl_id not in (select expl_id from selector_expl);

	-- save state selector 
	DELETE FROM temp_table WHERE fid=199 AND cur_user=current_user;
	INSERT INTO temp_table (fid, text_column)
	SELECT 199, (array_agg(state_id)) FROM selector_state WHERE cur_user=current_user;

	-- save & reset psector selector
	IF 'role_master' IN (SELECT rolname FROM pg_roles WHERE pg_has_role( current_user, oid, 'member')) THEN
		DELETE FROM selector_psector WHERE cur_user = current_user;
		DELETE FROM temp_table WHERE fid=287 AND cur_user=current_user;
		INSERT INTO temp_table (fid, text_column)  
		SELECT 287, (array_agg(psector_id)) FROM selector_psector WHERE cur_user=current_user;
	END IF;
	
	-- set state selector
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id ,cur_user) VALUES (1, current_user);

	IF v_debug THEN
		RAISE NOTICE '4-update values of mincut cat table';
	END IF;
	UPDATE om_mincut SET expl_id=expl_id_arg WHERE id=result_id_arg;
	UPDATE om_mincut SET macroexpl_id=macroexpl_id_arg WHERE id=result_id_arg;

	IF v_debug THEN
		RAISE NOTICE '5-Start mincut process';
	END IF;     

	INSERT INTO om_mincut_valve (result_id, node_id, unaccess, closed, broken, the_geom) 
	SELECT result_id_arg, node.node_id, false::boolean, closed, broken, node.the_geom
	FROM v_om_mincut_selected_valve
	JOIN node on node.node_id=v_om_mincut_selected_valve.node_id
	JOIN exploitation ON node.expl_id=exploitation.expl_id
	WHERE macroexpl_id=macroexpl_id_arg;

	IF v_debug THEN
		RAISE NOTICE '6-Identify unaccess valves';
	END IF;

	UPDATE om_mincut_valve SET unaccess=true, proposed = false WHERE result_id=result_id_arg AND node_id IN 
	(SELECT node_id FROM om_mincut_valve_unaccess WHERE result_id=result_id_arg);

	-- The element to isolate could be an arc or a node
	IF type_element_arg = 'arc' OR type_element_arg='ARC' THEN
	
		IF (SELECT state FROM arc WHERE (arc_id = element_id_arg))=0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3002", "function":"2304","debug_msg":"'||element_id_arg::text||'"}}$$);' INTO v_error_message;
		END IF;
		
		-- Check an existing arc
		SELECT COUNT(*) INTO controlValue FROM v_edit_arc JOIN value_state_type ON state_type=value_state_type.id 
		WHERE (arc_id = element_id_arg) AND (is_operative IS TRUE);
		
		IF controlValue = 1 THEN
		
			-- Select public.geometry
			SELECT the_geom INTO arc_aux FROM v_edit_arc WHERE arc_id = element_id_arg;

			-- call engine to determinate the isolated area
			IF v_mincutversion = 4 OR v_mincutversion = 5 THEN
			
				-- call graf analytics function (step:1)
				v_data = concat ('{"data":{"grafClass":"MINCUT", "arc":"', element_id_arg ,'", "step":1, "parameters":{"id":', result_id_arg, '}}}');
				RAISE NOTICE 'v_data MINCUT %', v_data;
				PERFORM gw_fct_grafanalytics_mincut(v_data);
			
			ELSIF v_mincutversion = 3 THEN
			
				-- insert the initial arc
				INSERT INTO om_mincut_arc (arc_id, the_geom, result_id) 
				SELECT arc_id, the_geom, result_id_arg FROM arc WHERE arc_id = element_id_arg;
		
				-- Run for extremes node
				SELECT node_1, node_2 INTO node_1_aux, node_2_aux FROM v_edit_arc WHERE arc_id = element_id_arg;

				IF node_1_aux IS NULL OR node_2_aux IS NULL THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3006", "function":"2304","debug_msg":"'||element_id_arg::text||'"}}$$);' INTO v_error_message;
				END IF;

				-- Check extreme being a valve
				SELECT COUNT(*) INTO controlValue FROM om_mincut_valve 
				WHERE node_id = node_1_aux AND result_id=result_id_arg AND ((unaccess = FALSE AND broken = FALSE) OR (closed = TRUE));

				IF controlValue = 1 THEN
					-- Set proposed valve
					UPDATE om_mincut_valve SET proposed = TRUE WHERE node_id=node_1_aux AND result_id=result_id_arg;
					
				ELSE
					-- Check if extreme if being a inlet
					SELECT COUNT(*) INTO controlValue FROM config_mincut_inlet WHERE node_id = node_1_aux;
				
					IF controlValue = 0 THEN
						-- Compute the tributary area using DFS
						PERFORM gw_fct_mincut_engine(node_1_aux, result_id_arg);	
					ELSE
						SELECT the_geom INTO node_aux FROM v_edit_node WHERE node_id = node_1_aux;
						INSERT INTO om_mincut_node (node_id, the_geom, result_id) VALUES (node_1_aux, node_aux, result_id_arg);	
					END IF;
				END IF;

				-- Check other extreme being a valve
				SELECT COUNT(*) INTO controlValue FROM om_mincut_valve 
				WHERE node_id = node_2_aux AND result_id=result_id_arg AND ((unaccess = FALSE AND broken = FALSE) OR (closed = TRUE));
				IF controlValue = 1 THEN

					-- Check if the valve is already computed
					SELECT node_id INTO exists_id FROM om_mincut_valve 
					WHERE node_id = node_2_aux AND (proposed = TRUE) AND result_id=result_id_arg;
		
					-- Compute proceed
					IF NOT FOUND THEN
						-- Set proposed valve
						UPDATE om_mincut_valve SET proposed = TRUE 
						WHERE node_id=node_2_aux AND result_id=result_id_arg;
					END IF;
				ELSE
					-- Check if extreme if being a inlet
					SELECT COUNT(*) INTO controlValue FROM config_mincut_inlet WHERE node_id = node_2_aux;
					IF controlValue = 0 THEN
						-- Compute the tributary area using DFS
						PERFORM gw_fct_mincut_engine(node_2_aux, result_id_arg);	
					ELSE 
						SELECT the_geom INTO node_aux FROM v_edit_node WHERE node_id = node_2_aux;
						INSERT INTO om_mincut_node (node_id, the_geom, result_id) VALUES(node_2_aux, node_aux, result_id_arg);		
					END IF;	
				END IF;	
			END IF;
			
		-- The arc_id was not found
		ELSE 
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1082", "function":"2304","debug_msg":"'||element_id_arg::text||'"}}$$);' INTO v_error_message;
		END IF;

	ELSE
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3092", "function":"2304","debug_msg":null}}$$);' INTO v_error_message;
	END IF;

	IF v_debug THEN	RAISE NOTICE '7-Compute flow trace on network';	END IF;	
	
	SELECT gw_fct_mincut_inverted_flowtrace(result_id_arg) into cont1;

	IF v_debug THEN RAISE NOTICE '8-Delete valves not proposed, not unaccessible, not closed and not broken'; END IF;
	
	DELETE FROM om_mincut_valve WHERE node_id NOT IN (SELECT node_1 FROM arc JOIN om_mincut_arc ON om_mincut_arc.arc_id=arc.arc_id 
		WHERE result_id=result_id_arg UNION 
		SELECT node_2 FROM arc JOIN om_mincut_arc ON om_mincut_arc.arc_id=arc.arc_id WHERE result_id=result_id_arg)
		AND result_id=result_id_arg;
					
	UPDATE om_mincut_valve SET proposed = FALSE WHERE closed = TRUE AND result_id=result_id_arg ;

	IF v_debug THEN	RAISE NOTICE '10-Update mincut selector'; END IF;
	
	-- Update the selector
	-- current user
	DELETE FROM selector_mincut_result WHERE result_id = result_id_arg AND cur_user = current_user;
	INSERT INTO selector_mincut_result(cur_user, result_id) VALUES (current_user, result_id_arg);

	-- publish user
	SELECT value FROM config_param_system WHERE parameter='admin_publish_user' INTO v_publish_user;
	
	IF v_publish_user IS NOT NULL THEN
		DELETE FROM selector_mincut_result WHERE result_id = result_id_arg AND cur_user = v_publish_user;
		INSERT INTO selector_mincut_result(cur_user, result_id) VALUES (v_publish_user, result_id_arg);
	END IF;

	IF v_debug THEN	RAISE NOTICE '11-Insert into om_mincut_connec table ';	END IF;			
	
	INSERT INTO om_mincut_connec (result_id, connec_id, the_geom)
	SELECT result_id_arg, connec_id, connec.the_geom FROM connec JOIN om_mincut_arc ON connec.arc_id=om_mincut_arc.arc_id WHERE result_id=result_id_arg AND state=1;

	IF v_debug THEN RAISE NOTICE '12-Insert into om_mincut_hydrometer table ';	END IF;
	
	INSERT INTO om_mincut_hydrometer (result_id, hydrometer_id)
	SELECT result_id_arg,rtc_hydrometer_x_connec.hydrometer_id FROM rtc_hydrometer_x_connec 
	JOIN om_mincut_connec ON rtc_hydrometer_x_connec.connec_id=om_mincut_connec.connec_id 
	LEFT JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
	WHERE result_id=result_id_arg;

	-- fill connnec & hydrometer details on om_mincut.output
	-- count arcs
	SELECT count(arc_id), sum(st_length(arc.the_geom))::numeric(12,2) INTO v_numarcs, v_length 
	FROM om_mincut_arc JOIN arc USING (arc_id) WHERE result_id=result_id_arg group by result_id;
	
	SELECT sum(area*st_length(arc.the_geom))::numeric(12,2) INTO v_volume 
	FROM om_mincut_arc JOIN arc USING (arc_id) JOIN cat_arc ON arccat_id=cat_arc.id 
	WHERE result_id=result_id_arg;

	-- count connec
	SELECT count(connec_id) INTO v_numconnecs FROM om_mincut_connec WHERE result_id=result_id_arg;

	-- count hydrometers
	SELECT count (rtc_hydrometer_x_connec.hydrometer_id) INTO v_numhydrometer 
	FROM rtc_hydrometer_x_connec JOIN om_mincut_connec ON rtc_hydrometer_x_connec.connec_id=om_mincut_connec.connec_id 
	JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
	JOIN connec ON connec.connec_id=v_rtc_hydrometer.connec_id WHERE result_id=result_id_arg;

	-- priority hydrometers
	v_priority = 	(SELECT (array_to_json(array_agg((b)))) FROM 
	(SELECT concat('{"category":"',hc.observ,'","number":"', count(rtc_hydrometer_x_connec.hydrometer_id), '"}')::json as b FROM rtc_hydrometer_x_connec 
			JOIN om_mincut_connec ON rtc_hydrometer_x_connec.connec_id=om_mincut_connec.connec_id 
			JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
			LEFT JOIN ext_hydrometer_category hc ON hc.id::text=v_rtc_hydrometer.category_id::text
			JOIN connec ON connec.connec_id=v_rtc_hydrometer.connec_id WHERE result_id=result_id_arg 
			GROUP BY hc.observ ORDER BY hc.observ)a);
				
	IF v_priority IS NULL THEN v_priority='{}'; END IF;
	
	v_mincutdetails = (concat('{"minsector_id":"',element_id_arg,'","arcs":{"number":"',v_numarcs,'", "length":"',v_length,'", "volume":"', 
	v_volume, '"}, "connecs":{"number":"',v_numconnecs,'","hydrometers":{"total":"',v_numhydrometer,'","classified":',v_priority,'}}}'));
			
	--update output results
	UPDATE om_mincut SET output = v_mincutdetails WHERE id = result_id_arg;

	-- calculate the boundary of mincut using arcs and valves
	EXECUTE ' SELECT st_astext(st_envelope(st_extent(st_buffer(the_geom,20)))) FROM (SELECT the_geom FROM om_mincut_arc WHERE result_id='||result_id_arg||
		' UNION SELECT the_geom FROM om_mincut_valve WHERE result_id='||result_id_arg||') a'    
	        INTO v_geometry;
	
	-- restore state selector
	INSERT INTO selector_state (state_id, cur_user)
	select unnest(text_column::integer[]), current_user from temp_table where fid=199 and cur_user=current_user
	ON CONFLICT (state_id, cur_user) DO NOTHING;
	
	-- restore psector selector
	IF 'role_master' IN (SELECT rolname FROM pg_roles WHERE pg_has_role( current_user, oid, 'member')) THEN
		INSERT INTO selector_psector (psector_id, cur_user)
		select unnest(text_column::integer[]), current_user from temp_table where fid=287 and cur_user=current_user
		ON CONFLICT (psector_id, cur_user) DO NOTHING;
	END IF;

	-- returning
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');


	IF v_error_message is null THEN
		v_status = 'Accepted';
		v_level = 3;
		v_message = 'Mincut done successfully';
	ELSE
		v_status = ((((v_error_message::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text;
		v_level = ((((v_error_message::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer;
		v_message = ((((v_error_message::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text;
	END IF;

	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
	',"body":{"form":{}'||
			',"data":{ '||
			'  "info":'||v_result_info||
			', "geometry":"'||v_geometry||'"'||
			', "mincutDetails":'||v_mincutdetails||
			', "setVisibleLayers":['||v_visiblelayer||']}'||
			'}'||
	'}')::json;

    EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
    RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;