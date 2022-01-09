/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2894

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(character varying, boolean, boolean, boolean);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(character varying, boolean, boolean);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2epa_main(p_data json)  
RETURNS json AS 
$BODY$

/*example
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES","epsg":25831}, "data":{"resultId":"test1", "dumpSubcatch":"true","step":"0"}}$$) -- FULL PROCESS

SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES","epsg":25831}, "data":{"resultId":"test1", "dumpSubcatch":"true","step":"1"}}$$) -- STRUCTURE DATA (GRAF AND BOUNDARY)
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES","epsg":25831}, "data":{"resultId":"test1", "dumpSubcatch":"true","step":"2"}}$$) -- ANALYZE GRAF
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES","epsg":25831}, "data":{"resultId":"test1", "dumpSubcatch":"true","step":"3"}}$$) -- CREATE JSON

SELECT "SCHEMA_NAME".gw_fct_pg2epa_fill_data ('r1');


-- fid: 227

*/

DECLARE

v_networkmode integer = 1;
v_return json;
v_result text;
v_dumpsubcatch boolean;
v_inpoptions json;
v_file json;
v_body json;
v_advancedsettings boolean;
v_input json;
v_vdefault boolean;
v_error_context text;
v_count integer;
v_response text;
v_message text;
v_step integer=0;
v_autorepair boolean;
v_expl integer = null;


BEGIN

	-- set search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input data
	v_result =  (p_data->>'data')::json->>'resultId';
	v_dumpsubcatch =  (p_data->>'data')::json->>'dumpSubcatch';
	v_step = (p_data->>'data')::json->>'step';
	IF v_step IS NULL THEN v_step = 0; END IF;
		
	v_input = concat('{"data":{"parameters":{"resultId":"',v_result,'", "dumpSubcatch":"',v_dumpsubcatch,'", "fid":227}}}')::json;
	
	-- get user parameters
	v_advancedsettings = (SELECT value::json->>'status' FROM config_param_user WHERE parameter='inp_options_advancedsettings' AND cur_user=current_user)::boolean;
	v_vdefault = (SELECT value::json->>'status' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_networkmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user);
	v_autorepair = (SELECT (value::json->>'autoRepair') FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;
	IF (SELECT count(expl_id) FROM selector_expl WHERE cur_user = current_user) = 1 THEN
		v_expl = (SELECT expl_id FROM selector_expl WHERE cur_user = current_user);
	END IF;
	
	IF v_step=3 THEN

		SELECT gw_fct_pg2epa_check_result(v_input) INTO v_return ;
		SELECT gw_fct_pg2epa_export_inp(p_data) INTO v_file;
		v_body = gw_fct_json_object_set_key((v_return->>'body')::json, 'file', v_file);
		v_return = gw_fct_json_object_set_key(v_return, 'body', v_body);
		v_return = replace(v_return::text, '"message":{"level":1, "text":"Data quality analysis done succesfully"}', 
		'"message":{"level":1, "text":"Step-3: Create JSON of inp export done succesfully"}')::json;
		RETURN v_return;
		
	ELSIF v_step=2 THEN
	
		PERFORM gw_fct_pg2epa_check_network(v_input);	
		v_return = '{"message":{"level":1, "text":"Step-2: Analyze graf of inp export done succesfully"}}'::json;
		RETURN v_return;
		
	END IF;

	-- check sector selector
	SELECT count(*) INTO v_count FROM selector_sector WHERE cur_user = current_user AND sector_id > 0;
	IF v_count = 0 THEN
		RETURN ('{"status":"Failed","message":{"level":1, "text":"There is no sector selected. Please select at least one"}}')::json;
	END IF;

	-- delete used tables
	DELETE FROM audit_check_data WHERE fid = 227 AND cur_user=current_user;
	DELETE FROM audit_log_data WHERE fid = 227 AND cur_user=current_user;
	DELETE FROM temp_table;

	-- force only state 1 selector
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);

	-- setting variables
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
	
	RAISE NOTICE '4 - Manage varcs';
	PERFORM gw_fct_pg2epa_manage_varc(v_result);
	
	RAISE NOTICE '5 - Call nod2arc function';
	PERFORM gw_fct_pg2epa_nod2arc_geom(v_result);
	
	RAISE NOTICE '6 - Calling for gw_fct_pg2epa_flowreg_additional function';
	--PERFORM gw_fct_pg2epa_nod2arc_data(v_result);

	RAISE NOTICE '8 - Trim arcs';
	IF v_networkmode = 2 THEN
		SELECT gw_fct_pg2epa_vnodetrimarcs(v_result) INTO v_response;
	END IF;
	
	RAISE NOTICE '7 - Dump subcatchments';
	IF v_dumpsubcatch THEN
		PERFORM gw_fct_pg2epa_dump_subcatch(p_data);
	END IF;

	RAISE NOTICE '8 - Set default values';
	IF v_vdefault THEN
		PERFORM gw_fct_pg2epa_vdefault(v_input);
	END IF;

	RAISE NOTICE '9 - Check result network';
	IF v_step = 0 THEN
		PERFORM gw_fct_pg2epa_check_network(v_input);
	END IF;
		
	RAISE NOTICE '10 - Advanced settings';
	IF v_advancedsettings THEN
		PERFORM gw_fct_pg2epa_advancedsettings(v_result);
	END IF;

	RAISE NOTICE '11 - dscenario';
	PERFORM gw_fct_pg2epa_dscenario(v_result);

	RAISE NOTICE '12 - check result previous exportation';
	IF v_step=0 THEN
		SELECT gw_fct_pg2epa_check_result(v_input) INTO v_return ;
	END IF;

	RAISE NOTICE '13 - Move from temp tables to rpt_inp tables';
	UPDATE temp_arc SET result_id  = v_result;
	UPDATE temp_node SET result_id  = v_result;
	INSERT INTO rpt_inp_arc (result_id, arc_id, flw_code, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, 
	length, n, the_geom, expl_id, minorloss, addparam, arcparent, q0, qmax, barrels, slope, culvert, kentry, kexit, kavg, flap, seepage)
	SELECT
	result_id, arc_id, flw_code, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation,
	length, n, the_geom, expl_id, minorloss, addparam, arcparent, q0, qmax, barrels, slope, culvert, kentry, kexit, kavg, flap, seepage 
	FROM temp_arc;
	
	INSERT INTO rpt_inp_node (result_id, node_id, flw_code, top_elev, ymax, elev, node_type, nodecat_id,
	epa_type, sector_id, state, state_type, annotation, y0, ysur, apond, the_geom, expl_id, addparam, parent, arcposition, fusioned_node)
	SELECT result_id, node_id, flw_code, top_elev, ymax, elev, node_type, nodecat_id, epa_type,
	sector_id, state, state_type, annotation, y0, ysur, apond, the_geom, expl_id, addparam, parent, arcposition, fusioned_node
	FROM temp_node;
	
	RAISE NOTICE '14 - Manage return';
	IF v_step=1 THEN
	
		v_return = '{"message":{"level":1, "text":"Step-1: Structure data, graf and boundary of inp export done succesfully"}}'::json;
		RETURN v_return;	

	ELSIF v_step=0 THEN
	
		SELECT gw_fct_pg2epa_export_inp(p_data) INTO v_file;
		v_body = gw_fct_json_object_set_key((v_return->>'body')::json, 'file', v_file);
		v_return = gw_fct_json_object_set_key(v_return, 'body', v_body);
		v_return = replace(v_return::text, '"message":{"level":1, "text":"Data quality analysis done succesfully"}', '"message":{"level":1, "text":"Inp export done succesfully"}')::json;
		RETURN v_return;
		
	END IF;

	--  Exception handling
	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	--RETURN ('{"status":"Failed", "body":{"data":{"info":{"values":[{"message":'||to_json(SQLERRM)||'}]}}}, "NOSQLERR":' || 
	--to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;