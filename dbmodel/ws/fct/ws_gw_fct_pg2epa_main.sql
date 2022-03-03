/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2646

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(character varying, boolean, boolean);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(character varying, boolean);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_main(p_data json)  
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "step":"0"}}$$) -- FULL PROCESS

SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "step":"1"}}$$) -- STRUCTURE DATA (GRAF AND BOUNDARY)
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "step":"2"}}$$) -- ANALYZE GRAF
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "step":"3"}}$$) -- CREATE JSON RETURN

--fid: 227

*/

DECLARE

v_networkmode integer = 1;
v_return json;
v_input json;
v_result text;
v_onlymandatory_nodarc boolean = false;
v_vnode_trimarcs boolean = false;
v_response integer;
v_message text;
v_setdemand boolean;
v_buildupmode integer;
v_inpoptions json;
v_advancedsettings boolean;
v_file json;
v_body json;
v_onlyexport boolean;
v_checkdata boolean;
v_checknetwork boolean;
v_vdefault boolean;
v_fid integer = 227;
v_error_context text;
v_breakpipes boolean;
v_count integer;
v_step integer=0;
v_autorepair boolean;
v_expl integer = null;
v_sector_0 boolean = false;
	
BEGIN

	-- set search path
	SET search_path = "SCHEMA_NAME", public;
	
	-- get input data
	v_result = (p_data->>'data')::json->>'resultId';
	v_step = (p_data->>'data')::json->>'step';  -- use network previously defined
	IF v_step is null then v_step = 0; END IF;
	
	-- get user parameteres
	v_networkmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user);
	v_buildupmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_buildup_mode' AND cur_user=current_user);
	v_advancedsettings = (SELECT value::json->>'status' FROM config_param_user WHERE parameter='inp_options_advancedsettings' AND cur_user=current_user)::boolean;
	v_vdefault = (SELECT value::json->>'status' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	IF (SELECT count(expl_id) FROM selector_expl WHERE cur_user = current_user) = 1 THEN
		v_expl = (SELECT expl_id FROM selector_expl WHERE cur_user = current_user);
	END IF;

	v_input = concat('{"data":{"parameters":{"resultId":"',v_result,'", "fid":227}}}')::json;

	-- get debug parameters (settings)
	v_setdemand = (SELECT value::json->>'setDemand' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;
	v_breakpipes = (SELECT (value::json->>'breakPipes')::json->>'status' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;
	v_autorepair = (SELECT (value::json->>'autoRepair') FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;

	IF v_step=3 THEN
	
		PERFORM gw_fct_pg2epa_dscenario(v_result);
		SELECT gw_fct_pg2epa_check_result(v_input) INTO v_return ;
		SELECT gw_fct_pg2epa_export_inp(p_data) INTO v_file;
		v_body = gw_fct_json_object_set_key((v_return->>'body')::json, 'file', v_file);
		v_return = gw_fct_json_object_set_key(v_return, 'body', v_body);
		v_return = replace(v_return::text, '"message":{"level":1, "text":"Data quality analysis done succesfully"}', 
		'"message":{"level":1, "text":"Step-3: Creation of json for export done succesfully"}')::json;
		RETURN v_return;
		
	ELSIF v_step=2 THEN
		PERFORM gw_fct_pg2epa_check_network(v_input);	
		v_return = '{"message":{"level":1, "text":"Step-2: Gragf analytics done succesfully"}}'::json;
		RETURN v_return;
	END IF;


	-- check sector selector
	SELECT count(*) INTO v_count FROM selector_sector WHERE cur_user = current_user;
	IF v_count = 0 THEN
		RETURN ('{"status":"Failed","message":{"level":1, "text":"There is no sector selected. Please select at least one"}}')::json;
	END IF;

	-- delete used tables
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;
	DELETE FROM audit_log_data WHERE fid = v_fid AND cur_user=current_user;
	DELETE FROM temp_table;
	
	-- force only state 1 selector
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);

	-- force only sector =0 disabled
	IF (SELECT count(*) FROM selector_sector WHERE sector_id = 0 and cur_user = current_user ) = 1 THEN
		v_sector_0 = true;
	END IF;
	DELETE FROM selector_sector  WHERE sector_id = 0 and cur_user = current_user;
		
	-- setting variables
	IF v_networkmode = 1 THEN 
		v_onlymandatory_nodarc = TRUE;
	END IF;
	v_inpoptions = (SELECT (replace (replace (replace (array_to_json(array_agg(json_build_object((t.parameter),(t.value))))::text,'},{', ' , '),'[',''),']',''))::json 
				FROM (SELECT parameter, value FROM config_param_user 
				JOIN sys_param_user a ON a.id=parameter	WHERE cur_user=current_user AND formname='epaoptions')t);

	-- check consistency for user options 
	SELECT gw_fct_pg2epa_check_options(v_input) INTO v_return;
	IF v_return->>'status' = 'Failed' THEN
		RETURN v_return;
	END IF;
	
	RAISE NOTICE '1 - Upsert on rpt_cat_table and set selectors';
	DELETE FROM rpt_cat_result WHERE result_id=v_result;
	INSERT INTO rpt_cat_result (result_id, inp_options, status, expl_id) VALUES (v_result, v_inpoptions, 1, v_expl);
	DELETE FROM selector_inp_result WHERE cur_user=current_user;
	INSERT INTO selector_inp_result (result_id, cur_user) VALUES (v_result, current_user);

	-- repair inp tables
	IF v_autorepair IS NOT FALSE THEN
		PERFORM gw_fct_pg2epa_autorepair_epatype($${"client":{"device":4, "infoType":1, "lang":"ES"}}$$);
	END IF;
	
	RAISE NOTICE '2 - check system data';
	PERFORM gw_fct_pg2epa_check_data(v_input);
	
	RAISE NOTICE '3 - Fill temp tables';
	PERFORM gw_fct_pg2epa_fill_data(v_result);

	RAISE NOTICE '4 - Call gw_fct_pg2epa_nod2arc function';
	PERFORM gw_fct_pg2epa_nod2arc(v_result, v_onlymandatory_nodarc, false);

	RAISE NOTICE '5 - Call gw_fct_pg2epa_doublenod2arc';
	PERFORM gw_fct_pg2epa_nod2arc_double(v_result);
			
	RAISE NOTICE '6 - Call gw_fct_pg2epa_pump_additional function';
	PERFORM gw_fct_pg2epa_pump_additional(v_result);

	RAISE NOTICE '7 - manage varcs';
	PERFORM gw_fct_pg2epa_manage_varc(v_result);	

	RAISE NOTICE '8 - Trim arcs';
	IF v_networkmode IN (3,4) THEN
	
		IF v_breakpipes THEN
			PERFORM gw_fct_pg2epa_breakpipes(v_result);
		END IF;

		-- execute vnodetrim arcs
		SELECT gw_fct_pg2epa_vnodetrimarcs(v_result) INTO v_response;

	END IF;

	RAISE NOTICE '9 - Execute buildup model';
	IF v_buildupmode = 1 THEN
		PERFORM gw_fct_pg2epa_buildup_supply(v_result);
		
	ELSIF v_buildupmode = 2 THEN
		PERFORM gw_fct_pg2epa_buildup_transport(v_result);
	END IF;

	RAISE NOTICE '10 - Set default values';
	IF v_vdefault THEN
		PERFORM gw_fct_pg2epa_vdefault(v_input);
	END IF;

	RAISE NOTICE '11 - Set ceros';
	UPDATE temp_node SET elevation = 0 WHERE elevation IS NULL;
	UPDATE temp_node SET addparam = replace (addparam, '""','null');
	
	RAISE NOTICE '12 - Set length > 0.05 when length is 0';
	UPDATE temp_arc SET length=0.05 WHERE length=0;

	RAISE NOTICE '13 - Set demands & patterns';
	TRUNCATE temp_demand;
	IF v_setdemand THEN
		PERFORM gw_fct_pg2epa_demand(v_result);		
	END IF;

	RAISE NOTICE '14 - Setting valve status';
	PERFORM gw_fct_pg2epa_valve_status(v_result);
	
	IF v_step = 0 THEN
	
		RAISE NOTICE '15 - Setting dscenarios';
		PERFORM gw_fct_pg2epa_dscenario(v_result);
			
		RAISE NOTICE '16 - Advanced settings';
		IF v_advancedsettings THEN
			PERFORM gw_fct_pg2epa_advancedsettings(v_result);
		END IF;
		
		RAISE NOTICE '17 - Check result network';
		PERFORM gw_fct_pg2epa_check_network(v_input);
		
		RAISE NOTICE '18- update values from inp_*_importinp tables';-- when delete network is enabled

		UPDATE temp_arc t SET status = b.status, diameter = b.diameter, epa_type ='VALVE',
		addparam = concat('{"valv_type":"',valv_type,'", "coef_loss":"',coef_loss,'", "curve_id":"',curve_id,'", "flow":"',flow,'", "pressure":"',pressure,'", "status":"',b.status,'", "minorloss":"',b.minorloss,'"}')
		FROM inp_valve_importinp b WHERE t.arc_id = b.arc_id;

		UPDATE temp_arc t SET status = b.status, epa_type ='PUMP',
		addparam = concat('{"power":"',power,'", "speed":"',speed,'", "curve_id":"',curve_id,'", "pattern_id":"',pattern_id,'", "effic_curve_id":"',effic_curve_id,'", "status":"',b.status,'", "energy_price":"',b.energy_price,'", "energy_pattern_id":"',b.energy_pattern_id,'"}')
		FROM inp_pump_importinp b WHERE t.arc_id = b.arc_id;

		RAISE NOTICE '19 - Check result previous exportation';
		SELECT gw_fct_pg2epa_check_result(v_input) INTO v_return;
		
	END IF;

	RAISE NOTICE '20 - Profilactic last control';

	-- arcs without nodes
	UPDATE temp_arc t SET epa_type = 'TODELETE' FROM (SELECT a.id FROM temp_arc a LEFT JOIN temp_node ON node_1=node_id WHERE temp_node.node_id is null) a WHERE t.id = a.id;
	UPDATE temp_arc t SET epa_type = 'TODELETE' FROM (SELECT a.id FROM temp_arc a LEFT JOIN temp_node ON node_2=node_id WHERE temp_node.node_id is null) a WHERE t.id = a.id;

	INSERT INTO audit_log_data (fid, feature_id, feature_type, log_message) 
	SELECT v_fid, arc_id, 'ARC', '23 - Profilactic last delete' FROM temp_arc WHERE epa_type  ='TODELETE';
	
	DELETE FROM temp_arc WHERE epa_type = 'TODELETE';

	-- nodes without arcs
	UPDATE temp_node t SET epa_type = 'TODELETE' FROM 
	(SELECT id FROM temp_node LEFT JOIN (SELECT node_1 as node_id FROM temp_arc UNION SELECT node_2 FROM temp_arc) a USING (node_id) WHERE a.node_id IS NULL) a 
	WHERE t.id = a.id;

	INSERT INTO audit_log_data (fid, feature_id, feature_type, log_message) 
	SELECT v_fid, node_id, 'NODE', '23 - Profilactic last delete' FROM temp_node WHERE epa_type  ='TODELETE';
		
	DELETE FROM temp_node WHERE epa_type = 'TODELETE';
	
	-- update diameter when is null USING neighbourg from node_1
	UPDATE temp_arc SET diameter = dint FROM (
	SELECT node_1 as n1, diameter dint FROM temp_arc UNION SELECT node_2, diameter FROM temp_arc
	)t WHERE t.dint IS NOT NULL AND t.n1 = node_1 AND diameter IS NULL;
	UPDATE temp_arc SET diameter = dint FROM (
	SELECT node_1 as n1, diameter dint FROM temp_arc UNION SELECT node_2, diameter FROM temp_arc
	)t WHERE t.dint IS NOT NULL AND t.n1 = node_2 AND diameter IS NULL;

	-- update diameter when is null USING neighbourg from node_2
	UPDATE temp_arc SET diameter = dint FROM (
	SELECT node_1 as n2, diameter dint FROM temp_arc UNION SELECT node_2, diameter FROM temp_arc
	)t WHERE t.dint IS NOT NULL AND t.n2 = node_1 AND diameter IS NULL;
	UPDATE temp_arc SET diameter = dint FROM (
	SELECT node_2 as n2, diameter dint FROM temp_arc UNION SELECT node_2, diameter FROM temp_arc
	)t WHERE t.dint IS NOT NULL AND t.n2 = node_2 AND diameter IS NULL;

	-- other null values
	UPDATE temp_arc SET minorloss = 0 WHERE minorloss IS NULL;

	-- for those elements like filter o flowmeter which they do not have the attribute on the inventory table
	UPDATE temp_arc SET status = 'OPEN' WHERE status IS NULL OR status = '';
	
	UPDATE temp_node SET dqa_id = 0 WHERE dqa_id IS NULL;
	UPDATE temp_arc SET dqa_id = 0 WHERE dqa_id IS NULL;
	
	UPDATE temp_node SET dma_id = 0 WHERE dma_id IS NULL;
	UPDATE temp_arc SET dma_id = 0 WHERE dma_id IS NULL;
	
	UPDATE temp_node SET presszone_id = 0 WHERE presszone_id IS NULL;
	UPDATE temp_arc SET presszone_id = 0 WHERE presszone_id IS NULL;

	-- remove pattern when breakPipes is enabled	
	IF v_breakpipes THEN
		UPDATE temp_node n SET pattern_id  = ';VNODE BRKPIPE' , demand = 0 FROM temp_table t WHERE n.node_id = concat('VN',t.id);				
	END IF;

	RAISE NOTICE '21 - Move from temp tables to rpt_inp tables';
	UPDATE temp_arc SET result_id  = v_result;
	UPDATE temp_node SET result_id  = v_result;
	INSERT INTO rpt_inp_node (result_id, node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, 
	the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition,dma_id, presszone_id, dqa_id, minsector_id)
	SELECT result_id, node_id, elevation, case when elev is null then elevation else elev end, node_type, nodecat_id, epa_type, sector_id, state, 
	state_type, annotation, demand, the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition,dma_id, presszone_id, dqa_id, minsector_id
	FROM temp_node;
	INSERT INTO rpt_inp_arc 
	(result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, status, 
	the_geom, expl_id, flw_code, minorloss, addparam, arcparent,dma_id, presszone_id, dqa_id, minsector_id)
	SELECT result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, 
	status, the_geom, expl_id, flw_code, minorloss, addparam, arcparent,dma_id, presszone_id, dqa_id, minsector_id
	FROM temp_arc;

	-- recover sector 0 (if exists previously)
	IF v_sector_0 = true THEN
		INSERT INTO selector_sector VALUES (0,current_user);
	END IF;
	
	RAISE NOTICE '22 - Manage return';
	IF v_step=1 THEN
	
		v_return = '{"message":{"level":1, "text":"Step-1: Structure data, graf and boundary conditions of inp created succesfully"}}'::json;
		RETURN v_return;	

	ELSIF v_step=0 THEN
	
		SELECT gw_fct_pg2epa_export_inp(p_data) INTO v_file;
		v_body = gw_fct_json_object_set_key((v_return->>'body')::json, 'file', v_file);
		v_return = gw_fct_json_object_set_key(v_return, 'body', v_body);
		v_return = replace(v_return::text, '"message":{"level":1, "text":"Data quality analysis done succesfully"}',
		'"message":{"level":1, "text":"Full process of inp export done succesfully"}')::json;
		RETURN v_return;
		
	END IF;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;