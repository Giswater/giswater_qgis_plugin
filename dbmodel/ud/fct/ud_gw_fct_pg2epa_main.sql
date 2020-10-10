/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2894

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(character varying, boolean, boolean, boolean);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(character varying, boolean, boolean);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(p_data);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2epa_main(p_data json)  
RETURNS json AS 
$BODY$

/*example
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"resultId":"test1", "useNetworkGeom":"false", "dumpSubcatch":"true"}}$$)

-- fid: 227

*/

DECLARE
v_return json;
v_result text;
v_usenetworkgeom boolean;
v_dumpsubcatch boolean;
v_inpoptions json;
v_file json;
v_body json;
v_onlyexport boolean;
v_checkdata boolean;
v_checknetwork boolean;
v_advancedsettings boolean;
v_input json;
v_vdefault boolean;


BEGIN

	-- set search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input data
	v_result =  (p_data->>'data')::json->>'resultId';
	v_usenetworkgeom =  (p_data->>'data')::json->>'useNetworkGeom';
	v_dumpsubcatch =  (p_data->>'data')::json->>'dumpSubcatch';

	-- get user parameters
	v_advancedsettings = (SELECT value::json->>'status' FROM config_param_user WHERE parameter='inp_options_advancedsettings' AND cur_user=current_user)::boolean;
	v_vdefault = (SELECT value::json->>'status' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);

	-- get debug parameters (settings)
	v_onlyexport = (SELECT value::json->>'onlyExport' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;
	v_checkdata = (SELECT value::json->>'checkData' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;
	v_checknetwork = (SELECT value::json->>'checkNetwork' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;

	-- delete aux table
	DELETE FROM audit_check_data WHERE fid = 227 AND cur_user=current_user;
	DELETE FROM temp_table WHERE fid = 117 AND cur_user=current_user;

	-- force only state 1 selector
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);

	v_inpoptions = (SELECT (replace (replace (replace (array_to_json(array_agg(json_build_object((t.parameter),(t.value))))::text,'},{', ' , '),'[',''),']',''))::json 
				FROM (SELECT parameter, value FROM config_param_user 
				JOIN sys_param_user a ON a.id=parameter	WHERE cur_user=current_user AND formname='epaoptions')t);
	-- setting variables
	v_input = concat('{"data":{"parameters":{"resultId":"',v_result,'", "dumpSubcatch":"',v_dumpsubcatch,'", "fid":227}}}')::json;

	-- only export
	IF v_onlyexport THEN
		SELECT gw_fct_pg2epa_check_resultoptions(v_input) INTO v_return ;
		SELECT gw_fct_pg2epa_create_inp(v_result, null) INTO v_file;
		
		v_body = gw_fct_json_object_set_key((v_return->>'body')::json, 'file', v_file);
		v_return = gw_fct_json_object_set_key(v_return, 'body', v_body);
		v_return = replace(v_return::text, '"message":{"level":1, "text":"Data quality analysis done succesfully"}', 
		'"message":{"level":1, "text":"Inp export done succesfully"}')::json;
		RETURN v_return;
	END IF;

	RAISE NOTICE '1 - check system data';
	IF v_checkdata THEN
		PERFORM gw_fct_pg2epa_check_data(v_input);
	END IF;

	PERFORM gw_fct_pg2epa_check_options(v_input);

	RAISE NOTICE '2 - Upsert on rpt_cat_table and set selectors';
	DELETE FROM rpt_cat_result WHERE result_id=v_result;
	INSERT INTO rpt_cat_result (result_id, inpoptions) VALUES (v_result, v_inpoptions);
	DELETE FROM selector_inp_result WHERE cur_user=current_user;
	INSERT INTO selector_inp_result (result_id, cur_user) VALUES (v_result, current_user);
	
	RAISE NOTICE '3 - Fill temp tables';
	PERFORM gw_fct_pg2epa_fill_data(v_result);
	
	RAISE NOTICE '4 - manage varcs';
	PERFORM gw_fct_pg2epa_manage_varc(v_result);
	
	RAISE NOTICE '5 - Call nod2arc function';
	PERFORM gw_fct_pg2epa_nod2arc_geom(v_result);
	
	RAISE NOTICE '6 - Calling for gw_fct_pg2epa_flowreg_additional function';
	PERFORM gw_fct_pg2epa_nod2arc_data(v_result);
	
	RAISE NOTICE '7 - Try to dump subcatchments';
	IF v_dumpsubcatch THEN
		PERFORM gw_fct_pg2epa_dump_subcatch();
	END IF;

	RAISE NOTICE '8 - Set default values';
	IF v_vdefault THEN
		PERFORM gw_fct_pg2epa_vdefault(v_input);
	END IF;

	RAISE NOTICE '19 - Check result network';
	IF v_checknetwork THEN
		PERFORM gw_fct_pg2epa_check_network(v_input);
	END IF;
	
	RAISE NOTICE '10 - Advanced settings';
	IF v_advancedsettings THEN
		PERFORM gw_fct_pg2epa_advancedsettings(v_result);
	END IF;

	RAISE NOTICE '11 - check result previous exportation';
	SELECT gw_fct_pg2epa_check_result(v_input) INTO v_return ;
	
	RAISE NOTICE '12 - Move from temp tables';
	UPDATE temp_arc SET result_id  = v_result;
	UPDATE temp_node SET result_id  = v_result;
	INSERT INTO rpt_inp_arc (result_id, arc_id, flw_code, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, 
	length, n, the_geom, expl_id, minorloss, addparam, arcparent, q0, qmax, barrels, slope)
	SELECT
	result_id, arc_id, flw_code, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation,
	length, n, the_geom, expl_id, minorloss, addparam, arcparent, q0, qmax, barrels, slope
	FROM temp_arc;
	INSERT INTO rpt_inp_node (result_id, node_id, flw_code, top_elev, ymax, elev, node_type, nodecat_id,
	epa_type, sector_id, state, state_type, annotation, y0, ysur, apond, the_geom, expl_id, addparam, nodeparent, arcposition)
	SELECT result_id, node_id, flw_code, top_elev, ymax, elev, node_type, nodecat_id, epa_type,
	sector_id, state, state_type, annotation, y0, ysur, apond, the_geom, expl_id, addparam, nodeparent, arcposition
	FROM temp_node;

	RAISE NOTICE '13 - Create the inp file structure';	
	SELECT gw_fct_pg2epa_export_inp(v_result, null) INTO v_file;

	-- manage return message
	v_body = gw_fct_json_object_set_key((v_return->>'body')::json, 'file', v_file);
	v_return = gw_fct_json_object_set_key(v_return, 'body', v_body);
	v_return =  gw_fct_json_object_set_key (v_return, 'continue', false);                                
	v_return =  gw_fct_json_object_set_key (v_return, 'steps', 0);
	v_return = replace(v_return::text, '"message":{"level":1, "text":"Data quality analysis done succesfully"}', '
	"message":{"level":1, "text":"Inp export done succesfully"}')::json;
	
	RETURN v_return;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;