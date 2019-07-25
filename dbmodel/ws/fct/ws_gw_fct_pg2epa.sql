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
"data":{"status":"start", "resultId":"Prueba1", "useNetworkGeom":"true"}}$$)
*/

DECLARE
	v_networkmode integer = 1;
	v_return json;
	v_input json;
	v_result text;
	v_usenetworkgeom boolean;
	v_onlymandatory_nodarc boolean = false;
	v_vnode_trimarcs boolean = false;
	v_response integer;
	v_message text;
      
BEGIN

	--  Get input data
	v_result =  (p_data->>'data')::json->>'resultId';
	v_usenetworkgeom =  (p_data->>'data')::json->>'useNetworkGeom';
	
	
	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- Getting user parameteres
	v_networkmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user);

	-- only mandatory nodarc
	IF v_networkmode = 1 OR v_networkmode = 3 THEN 
		v_onlymandatory_nodarc = TRUE;
	END IF;

	RAISE NOTICE 'Starting pg2epa process.';

	-- Upsert on rpt_cat_table
	DELETE FROM rpt_cat_result WHERE result_id=v_result;
	INSERT INTO rpt_cat_result (result_id) VALUES (v_result);
	
	-- Upsert on node rpt_inp result manager table
	DELETE FROM inp_selector_result WHERE cur_user=current_user;
	INSERT INTO inp_selector_result (result_id, cur_user) VALUES (v_result, current_user);
	
	IF v_usenetworkgeom IS FALSE THEN
		-- Fill inprpt tables
		PERFORM gw_fct_pg2epa_fill_data(v_result);
	END IF;
	
	-- Update demand values filtering by dscenario
	PERFORM gw_fct_pg2epa_dscenario(v_result);
	
	-- first message on user's pannel
	v_message = concat ('INFO: Network geometry have been used taking another one from previous result. It is suposed network geometry from previous result it is ok');

	IF v_usenetworkgeom IS FALSE THEN
	
		-- setting first message on user's pannel
		v_message = concat ('INFO: The process to check vnodes over nodarcs is disabled because on this export mode arcs will not trimed using vnodes');
	
		-- Calling for gw_fct_pg2epa_nod2arc function
		PERFORM gw_fct_pg2epa_nod2arc(v_result, v_onlymandatory_nodarc);
			
		-- Calling for gw_fct_pg2epa_pump_additional function;
		PERFORM gw_fct_pg2epa_pump_additional(v_result);

		-- Calling for gw_fct_pg2epa_vnodetrimarcs function;
		IF v_networkmode = 3 OR v_networkmode = 4 THEN
			SELECT gw_fct_pg2epa_vnodetrimarcs(v_result) INTO v_response;
			
			-- setting first message again on user's pannel
			IF v_response = 0 THEN
				v_message = concat ('INFO: vnodes over nodarcs have been checked without any inconsistency. In terms of vnode/nodarc topological relation network is ok');
			
			ELSE
				v_message = concat ('WARNING: vnodes over nodarcs have been checked. In order to keep inlet flows from connecs using vnode_id, ' , v_response, ' nodarc nodes have been renamed using vnode_id');
			
			END IF;
	
		END IF;
		
	END IF;

	-- set demand and patterns in function of demand type and pattern method choosed
	SELECT gw_fct_pg2epa_rtc(v_result) INTO v_response;	

		IF v_response = 1 THEN -- when it is trying to use connec pattern method without network using vnodes to trim arcs
			-- manage return message
			v_input = concat('{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"parameters":{"resultId":"',v_result,'"},"saveOnDatabase":true}}')::json;
			SELECT gw_fct_pg2epa_check_data(v_input) INTO v_return;
				
			v_return = replace(v_return::text, '"message":{"priority":1, "text":"Data quality analysis done succesfully"}', 
			'"message":{"priority":2, "text":"You are trying to use pattern method with connects but your network geometry is not defined with vnodes treaming arcs. Please check pattern method and/or network geometry generator mode"}')::json;
			RETURN v_return;
		END IF;

	-- Calling for modify the valve status
	PERFORM gw_fct_pg2epa_valve_status(v_result);
	
	-- Calling for the export function
	PERFORM gw_fct_utils_csv2pg_export_epanet_inp(v_result, null);
	
	-- manage return message
	v_input = concat('{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"parameters":{"resultId":"',v_result,'"}, "message":"',v_message,'","saveOnDatabase":true}}')::json;
	SELECT gw_fct_pg2epa_check_data(v_input) INTO v_return;

	v_return = replace(v_return::text, '"message":{"priority":1, "text":"Data quality analysis done succesfully"}', '"message":{"priority":1, "text":"Inp export done succesfully"}')::json;
	
RETURN v_return;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;