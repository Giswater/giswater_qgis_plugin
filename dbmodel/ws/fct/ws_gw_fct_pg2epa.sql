/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2314

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(character varying, boolean, boolean);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(character varying, boolean);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa(p_data json)  
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},"data":{"geometryLog":false, "resultId":"v41", "useNetworkGeom":"false"}}$$)

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
v_usenetworkdemand boolean;
v_buildupmode integer;
v_usenetworkgeom boolean;
v_inpoptions json;
v_advancedsettings boolean;
v_file json;
v_body json;
v_export boolean;
v_checkdata boolean;
	
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;
	
	--  Get input data
	v_result = (p_data->>'data')::json->>'resultId';
	v_usenetworkgeom = (p_data->>'data')::json->>'useNetworkGeom';  -- use network previously defined

	-- Get user parameteres
	v_networkmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user);
	v_buildupmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_buildup_mode' AND cur_user=current_user);

	-- Get debug parameters (settings)
	v_usenetworkdemand = (SELECT (value::json->>'debug')::json->>'isOperative' FROM config_param_user WHERE parameter='inp_options_settings' AND cur_user=current_user)::boolean;
	v_export = (SELECT (value::json->>'debug')::json->>'export' FROM config_param_user WHERE parameter='inp_options_settings' AND cur_user=current_user)::boolean;
	v_checkdata = (SELECT (value::json->>'debug')::json->>'checkData' FROM config_param_user WHERE parameter='inp_options_settings' AND cur_user=current_user)::boolean;

	-- Get advanced parameters (settings)
	v_advancedsettings = (SELECT (value::json->>'avanced')::json->>'status' FROM config_param_user WHERE parameter='inp_options_settings' AND cur_user=current_user)::boolean;
	
	-- only mandatory nodarc
	IF v_networkmode = 1 OR v_networkmode = 3 THEN 
		v_onlymandatory_nodarc = TRUE;
	END IF;

	RAISE NOTICE '1 - Starting pg2epa process.';

	-- use previous network geometry
	IF v_usenetworkgeom IS NOT TRUE THEN

		v_inpoptions = (SELECT (replace (replace (replace (array_to_json(array_agg(json_build_object((t.parameter),(t.value))))::text,'},{', ' , '),'[',''),']',''))::json 
				FROM (SELECT parameter, value FROM config_param_user 
				JOIN audit_cat_param_user a ON a.id=parameter	WHERE cur_user=current_user AND formname='epaoptions')t);

		-- Upsert on rpt_cat_table
		DELETE FROM rpt_cat_result WHERE result_id=v_result;
		INSERT INTO rpt_cat_result (result_id, inpoptions) VALUES (v_result, v_inpoptions);

		-- setting first message on user's pannel
		v_message = concat ('INFO: The process to check vnodes over nodarcs is disabled because on this export mode arcs will not trimed using vnodes');

		RAISE NOTICE '2 - Fill inprpt tables';
		PERFORM gw_fct_pg2epa_fill_data(v_result);

		RAISE NOTICE '3 - Calling for gw_fct_pg2epa_nod2arc function';
		PERFORM gw_fct_pg2epa_nod2arc(v_result, v_onlymandatory_nodarc);

		RAISE NOTICE '4 - Calling for gw_fct_pg2epa_doublenod2arc';
		PERFORM gw_fct_pg2epa_nod2arc_double(v_result);
				
		RAISE NOTICE '5 - Calling for gw_fct_pg2epa_pump_additional function';
		PERFORM gw_fct_pg2epa_pump_additional(v_result);

		RAISE NOTICE '6 - Calling for gw_fct_pg2epa_vnodetrimarcs function';
		IF v_networkmode = 3 OR v_networkmode = 4 THEN
			SELECT gw_fct_pg2epa_vnodetrimarcs(v_result) INTO v_response;
				
			-- setting first message again on user's pannel
			IF v_response = 0 THEN
				v_message = concat ('INFO: vnodes over nodarcs have been checked without any inconsistency. In terms of vnode/nodarc topological relation network is ok');
			ELSE
				v_message = concat ('WARNING: vnodes over nodarcs have been checked. In order to keep inlet flows from connecs using vnode_id, ' , 
				v_response, ' nodarc nodes have been renamed using vnode_id');
			END IF;
		END IF;

		RAISE NOTICE '7 - profilactic issue to repair topology when length has no longitude';
		UPDATE rpt_inp_arc SET length=0.05 WHERE length=0 AND result_id=v_result;
		

		IF v_checkdata THEN -- (only debug mode no network check data)
			RAISE NOTICE '8 - Calling gw_fct_pg2epa_check_data';
			v_input = concat('{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"parameters":{"geometryLog":false, 
			"resultId":"',v_result,'", "useNetworkGeom":"', v_usenetworkgeom,'"}, "saveOnDatabase":true}}')::json;
			SELECT gw_fct_pg2epa_check_data(v_input) INTO v_return;			
			
		ELSE	
			RAISE NOTICE '8 - checking all arcs/node disconnected from any reservoir';
			PERFORM gw_fct_pg2epa_inlet_flowtrace(v_result);
			DELETE FROM rpt_inp_node WHERE node_id IN (SELECT node_id FROM anl_node WHERE fprocesscat_id=39 AND cur_user=current_user) and result_id = v_result;
			DELETE FROM rpt_inp_arc WHERE arc_id IN (SELECT arc_id FROM anl_arc WHERE fprocesscat_id=39 AND cur_user=current_user) and result_id = v_result;

			-- setting the minimun expression of return json
			RAISE NOTICE '9 - Ignoring gw_fct_pg2epa_check_data';
			SELECT gw_fct_get_jsonbody('{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},
			"data":{"parameters":{"text":"Inp export done succesfully"}}}'::json) INTO v_return;
		END IF;
		
		IF v_buildupmode = 1 THEN
			RAISE NOTICE '10 - Use supply buildup model (modifying values in order to force buildupmode 1)';
			PERFORM gw_fct_pg2epa_buildup_supply(v_result);
			
		ELSIF v_buildupmode = 2 THEN
			RAISE NOTICE '10 - Use transport buildup model (modifying values in order to force buildupmode 2)';
			PERFORM gw_fct_pg2epa_buildup_transport(v_result);
		END IF;

		IF v_advancedsettings THEN
			RAISE NOTICE '11 - Fixing advanced settings';
			PERFORM gw_fct_pg2epa_advancedsettings(v_result);
		END IF;

		RAISE NOTICE '12 - Default values';
		PERFORM gw_fct_pg2epa_vdefault(v_result);

		RAISE NOTICE '13 - Fixing inconsistency values on network data';
		-- deleting nodes disconnected from any reservoir
		DELETE FROM rpt_inp_node WHERE node_id IN (SELECT arc.node_1 FROM anl_arc JOIN arc USING (arc_id) WHERE fprocesscat_id=39 AND cur_user=current_user 
							UNION SELECT arc.node_2 FROM anl_arc JOIN arc USING (arc_id) WHERE fprocesscat_id=39 AND cur_user=current_user) AND result_id=p_result;

		-- deleting arcs disconnected from any reservoir';
		DELETE FROM rpt_inp_arc WHERE arc_id IN (SELECT arc_id FROM anl_arc WHERE fprocesscat_id=39 AND cur_user=current_user) AND result_id=p_result;

		-- delete orphan nodes'
		DELETE FROM rpt_inp_node WHERE node_id IN (SELECT node_id FROM anl_node WHERE fprocesscat_id=7 AND cur_user=current_user) AND result_id=p_result;

		-- deleting arcs without extremal nodes'
		DELETE FROM rpt_inp_arc WHERE arc_id IN (SELECT arc_id FROM anl_arc WHERE fprocesscat_id=3 AND cur_user=current_user) AND result_id=p_result;	

		-- setting cero on elevation those have null values in spite of previous processes (profilactic issue in order to do not crash the epanet file)';
		UPDATE rpt_inp_node SET elevation = 0 WHERE elevation IS NULL AND result_id=p_result;
		
	ELSE 
		-- delete rpt_* tables keeping rpt_inp_tables
		DELETE FROM rpt_arc WHERE result_id = v_result;
		DELETE FROM rpt_node WHERE result_id = v_result;
		DELETE FROM rpt_energy_usage WHERE result_id = v_result;
		DELETE FROM rpt_hydraulic_status WHERE result_id = v_result;
		DELETE FROM rpt_node WHERE result_id = v_result;	
		DELETE FROM rpt_inp_pattern_value WHERE result_id = v_result;

		SELECT gw_fct_get_jsonbody('{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},
		"data":{"parameters":{"text":"Inp export using existing gesometry from previous result done succesfully"}}}'::json) INTO v_return;
	END IF;

	RAISE NOTICE '14 - update demands & patterns';
	IF v_usenetworkdemand IS NOT FALSE THEN
	
		-- set demand and patterns in function of demand type and pattern method choosed
		PERFORM gw_fct_pg2epa_demand(v_result);	
		
		-- Update demand values filtering by dscenario
		PERFORM gw_fct_pg2epa_dscenario(v_result);

	END IF;

	RAISE NOTICE '15 - Calling for modify the valve status';
	PERFORM gw_fct_pg2epa_valve_status(v_result);

	-- Upsert on node rpt_inp result manager table
	DELETE FROM inp_selector_result WHERE cur_user=current_user;
	INSERT INTO inp_selector_result (result_id, cur_user) VALUES (v_result, current_user);
	
	IF v_export IS NOT FALSE THEN  -- debug mode
	
		RAISE NOTICE '16 - Calling for the export function';
		SELECT gw_fct_utils_csv2pg_export_epanet_inp(v_result, null) INTO v_file;
	END IF;
	
	v_body = gw_fct_json_object_set_key((v_return->>'body')::json, 'file', v_file);
	v_return = gw_fct_json_object_set_key(v_return, 'body', v_body);
	
	v_return = replace(v_return::text, '"message":{"priority":1, "text":"Data quality analysis done succesfully"}', '"message":{"priority":1, "text":"Inp export done succesfully"}')::json;

	RETURN v_return;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;