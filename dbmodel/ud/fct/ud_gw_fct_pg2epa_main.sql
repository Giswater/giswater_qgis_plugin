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
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "dumpSubcatch":"true","step":"1"}}$$); -- PRE-PROCESS
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "dumpSubcatch":"true","step":"2"}}$$); -- AUTOREPAIR
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "dumpSubcatch":"true","step":"3"}}$$); -- CHECK DATA
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "dumpSubcatch":"true","step":"4"}}$$); -- STRUCTURE DATA
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "dumpSubcatch":"true","step":"5"}}$$); -- CHECK GRAPH
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "dumpSubcatch":"true","step":"6"}}$$); -- BUILD INP 
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "dumpSubcatch":"true","step":"7"}}$$); -- POST-PROCESS

-- fid: 227

*/

DECLARE

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
v_message text;
v_step integer=0;
v_autorepair boolean;
v_expl integer = null;
v_sector_0 boolean = false;



BEGIN

	-- set search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input data
	v_result =  (p_data->>'data')::json->>'resultId';
	v_dumpsubcatch =  (p_data->>'data')::json->>'dumpSubcatch';
	v_step = (p_data->>'data')::json->>'step';		
	v_input = concat('{"data":{"parameters":{"resultId":"',v_result,'", "dumpSubcatch":"',v_dumpsubcatch,'", "fid":227}}}')::json;
	
		
	-- get user parameters
	v_advancedsettings = (SELECT value::json->>'status' FROM config_param_user WHERE parameter='inp_options_advancedsettings' AND cur_user=current_user)::boolean;
	v_vdefault = (SELECT value::json->>'status' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
	v_autorepair = (SELECT (value::json->>'autoRepair') FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;
	IF (SELECT count(expl_id) FROM selector_expl WHERE cur_user = current_user) = 1 THEN
		v_expl = (SELECT expl_id FROM selector_expl WHERE cur_user = current_user);
	END IF;
	

	-- step 1: pre-process
	IF v_step = 1 THEN
	
		-- check consistency for user options 
		SELECT gw_fct_pg2epa_check_options(v_input) INTO v_return;
		IF v_return->>'status' = 'Failed' THEN
			RETURN v_return;
		END IF;
		
		-- force sector =0 disabled
		DELETE FROM selector_sector  WHERE sector_id = 0 and cur_user = current_user;
			
		-- check sector selector
		SELECT count(*) INTO v_count FROM selector_sector WHERE cur_user = current_user AND sector_id > 0;
		IF v_count = 0 THEN
			RETURN ('{"status":"Failed","message":{"level":1, "text":"There is no sector selected. Please select at least one"}}')::json;
		END IF;
					
		-- force only state 1 selector
		DELETE FROM selector_state WHERE cur_user=current_user;
		INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);
		
		CREATE TEMP TABLE temp_t_arc_flowregulator (LIKE SCHEMA_NAME.temp_arc_flowregulator INCLUDING ALL);
		CREATE TEMP TABLE temp_t_lid_usage (LIKE SCHEMA_NAME.temp_lid_usage INCLUDING ALL);
		CREATE TEMP TABLE temp_t_node_other (LIKE SCHEMA_NAME.temp_node_other INCLUDING ALL);
		
		CREATE TEMP TABLE temp_t_csv (LIKE SCHEMA_NAME.temp_csv INCLUDING ALL);
		CREATE TEMP TABLE temp_t_table (LIKE SCHEMA_NAME.temp_table INCLUDING ALL);
		CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);
		CREATE TEMP TABLE temp_audit_log_data (LIKE SCHEMA_NAME.audit_log_data INCLUDING ALL);
		CREATE TEMP TABLE temp_t_node (LIKE SCHEMA_NAME.temp_node INCLUDING ALL);
		CREATE TEMP TABLE temp_t_arc (LIKE SCHEMA_NAME.temp_arc INCLUDING ALL);
		CREATE TEMP TABLE temp_t_gully (LIKE SCHEMA_NAME.temp_arc INCLUDING ALL);
		CREATE TEMP TABLE temp_t_anlgraph (LIKE SCHEMA_NAME.temp_anlgraph INCLUDING ALL);

		CREATE TEMP TABLE temp_anl_arc (LIKE SCHEMA_NAME.anl_arc INCLUDING ALL);
		CREATE TEMP TABLE temp_anl_node (LIKE SCHEMA_NAME.anl_node INCLUDING ALL);
		CREATE TEMP TABLE temp_anl_gully (LIKE SCHEMA_NAME.anl_gully INCLUDING ALL);
		CREATE TEMP TABLE temp_rpt_inp_raingage (LIKE SCHEMA_NAME.rpt_inp_raingage INCLUDING ALL);

		CREATE TEMP TABLE temp_t_go2epa (LIKE SCHEMA_NAME.temp_go2epa INCLUDING ALL);
		
		
		-- setting selectors
		v_inpoptions = (SELECT (replace (replace (replace (array_to_json(array_agg(json_build_object((t.parameter),(t.value))))::text,'},{', ' , '),'[',''),']',''))::json 
				FROM (SELECT parameter, value FROM config_param_user 
				JOIN sys_param_user a ON a.id=parameter	WHERE cur_user=current_user AND formname='epaoptions')t);

		-- setting selectors
		DELETE FROM rpt_cat_result WHERE result_id=v_result;
		INSERT INTO rpt_cat_result (result_id, inp_options, status, expl_id) VALUES (v_result, v_inpoptions, 1, v_expl);
		DELETE FROM selector_inp_result WHERE cur_user=current_user;
		INSERT INTO selector_inp_result (result_id, cur_user) VALUES (v_result, current_user);

		v_return = '{"status": "Accepted", "message":{"level":1, "text":"Export INP file 1/7 - Preprocess workflow...... done succesfully"}}'::json;
		RETURN v_return;

	ELSIF v_step = 2 THEN 

		PERFORM gw_fct_pg2epa_autorepair_epatype($${"client":{"device":4, "infoType":1, "lang":"ES"}}$$);
		v_return = '{"status": "Accepted", "message":{"level":1, "text":"Export INP file 2/7 - Autorepair epa_type...... done succesfully"}}'::json;
		RETURN v_return;

	-- step 3: check data
	ELSIF v_step = 3 THEN 
		
		PERFORM gw_fct_pg2epa_check_data(v_input);
		v_return = '{"status": "Accepted", "message":{"level":1, "text":"Export INP file 3/7 - Check according EPA rules...... done succesfully"}}'::json;
		RETURN v_return;
		
	-- step 4: structure data
	ELSIF v_step = 4 THEN 
	
		RAISE NOTICE '4.1 - Fill temp tables';
		PERFORM gw_fct_pg2epa_fill_data(v_result);
		
		RAISE NOTICE '4.2 - Manage varcs';
		PERFORM gw_fct_pg2epa_manage_varc(v_result);
		
		RAISE NOTICE '4.3 - Call nod2arc function';
		PERFORM gw_fct_pg2epa_nod2arc(v_result);
		
		RAISE NOTICE '4.4 - Dump subcatchments';
		IF v_dumpsubcatch THEN
			PERFORM gw_fct_pg2epa_dump_subcatch(p_data);
		END IF;

		RAISE NOTICE '4.5 - Set default values';
		IF v_vdefault THEN
			PERFORM gw_fct_pg2epa_vdefault(v_input);
		END IF;

		RAISE NOTICE '4.6 - dscenario';
		PERFORM gw_fct_pg2epa_dscenario(v_result);
		
		RAISE NOTICE '4.7 - Advanced settings';
		IF v_advancedsettings THEN
			PERFORM gw_fct_pg2epa_advancedsettings(v_result);
		END IF;
		
		RAISE NOTICE '4.8 - Update values for temp table';
		UPDATE temp_t_arc SET result_id  = v_result;
		UPDATE temp_t_node SET result_id  = v_result;
		
		v_return = '{"status": "Accepted", "message":{"level":1, "text":"Export INP file 4/7 - Structure data...... done succesfully"}}'::json;
		RETURN v_return;
		
		
	-- step 5: analyze graph
	ELSIF v_step=5 THEN
		
		PERFORM gw_fct_pg2epa_check_network(v_input);		
		v_return = '{"status": "Accepted", "message":{"level":1, "text":"Export INP file 5/7 - Graph analysis...... done succesfully"}}'::json;
		RETURN v_return;

	-- step 6: create json return
	ELSIF v_step=6 THEN

		SELECT gw_fct_pg2epa_check_result(v_input) INTO v_return;
		SELECT gw_fct_pg2epa_export_inp(p_data) INTO v_file;
		v_body = gw_fct_json_object_set_key((v_return->>'body')::json, 'file', v_file);
		v_return = gw_fct_json_object_set_key(v_return, 'body', v_body);
		v_return = replace(v_return::text, '"message":{"level":1, "text":"Data quality analysis done succesfully"}', 
		'"message":{"level":1, "text":"Export INP file 6/7 - Writing the INP file...... done succesfully"}')::json;

		RETURN v_return;	
	
	-- step 7: post-proces
	ELSIF v_step=7 THEN
			
		-- move arcs data
		INSERT INTO rpt_inp_arc (result_id, arc_id, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, 
		length, n, the_geom, expl_id, addparam, arcparent, q0, qmax, barrels, slope, culvert, kentry, kexit, kavg, flap, seepage)
		SELECT
		result_id, arc_id, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation,
		length, n, the_geom, expl_id, addparam, arcparent, q0, qmax, barrels, slope, culvert, kentry, kexit, kavg, flap, seepage 
		FROM temp_t_arc;

		-- move nodes data
		INSERT INTO rpt_inp_node (result_id, node_id, top_elev, ymax, elev, node_type, nodecat_id,
		epa_type, sector_id, state, state_type, annotation, y0, ysur, apond, the_geom, expl_id, addparam, parent, arcposition, fusioned_node)
		SELECT result_id, node_id, top_elev, ymax, elev, node_type, nodecat_id, epa_type,
		sector_id, state, state_type, annotation, y0, ysur, apond, the_geom, expl_id, addparam, parent, arcposition, fusioned_node
		FROM temp_t_node;
		
		-- drop temp tables
		DROP TABLE IF EXISTS temp_t_arc_flowregulator;
		DROP TABLE IF EXISTS temp_t_lid_usage;
		DROP TABLE IF EXISTS temp_t_node_other;

		DROP TABLE IF EXISTS temp_t_csv;	
		DROP TABLE IF EXISTS temp_t_table;	
		DROP TABLE IF EXISTS temp_audit_check_data;
		DROP TABLE IF EXISTS temp_audit_log_data;
		DROP TABLE IF EXISTS temp_t_table;
		DROP TABLE IF EXISTS temp_t_node;
		DROP TABLE IF EXISTS temp_t_arc;
		DROP TABLE IF EXISTS temp_t_gully;
		DROP TABLE IF EXISTS temp_t_anlgraph;

		DROP TABLE IF EXISTS temp_anl_arc;
		DROP TABLE IF EXISTS temp_anl_node;		
		DROP TABLE IF EXISTS temp_anl_gully;
		DROP TABLE IF EXISTS temp_rpt_inp_raingage;
		
		DROP TABLE IF EXISTS temp_t_go2epa;
		
		v_return = '{"status": "Accepted", "message":{"level":1, "text":"Export INP file 7/7 - Postprocess workflow...... done succesfully"}}'::json;
		RETURN v_return;

	END IF;

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed", "body":{"data":{"info":{"values":[{"message":'||to_json(SQLERRM)||'}]}}}, "NOSQLERR":' || 
	to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;