/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2222

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(character varying, boolean, boolean, boolean);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(character varying, boolean, boolean);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2epa(p_data json)  
RETURNS json AS 
$BODY$

/*example
SELECT SCHEMA_NAME.gw_fct_pg2epa_recursive($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"status":"off", "resultId":"test1", "useNetworkGeom":"true", "dumpSubcatch":"true" "}}$$)
*/

DECLARE
	v_return json;
	v_input json;
	v_result text;
	v_usnetworkgeom boolean;
	v_dumpsubcatch boolean;
	
BEGIN


--  Get input data
	v_result =  (p_data->>'data')::json->>'resultId';
	v_usnetworkgeom =  (p_data->>'data')::json->>'useNetworkGeom';
	v_dumpsubcatch =  (p_data->>'data')::json->>'dumpSubcatch';

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa process.';
	
	--Set value default
	UPDATE inp_outfall SET outfall_type=(SELECT value FROM config_param_user WHERE parameter='epa_outfall_type_vdefault' AND cur_user=current_user) WHERE outfall_type IS NULL;
	UPDATE inp_conduit SET q0=(SELECT value FROM config_param_user WHERE parameter='epa_conduit_q0_vdefault' AND cur_user=current_user)::float WHERE q0 IS NULL;
	UPDATE inp_conduit SET barrels=(SELECT value FROM config_param_user WHERE parameter='epa_conduit_barrels_vdefault' AND cur_user=current_user)::integer WHERE barrels IS NULL;
	UPDATE inp_junction SET y0=(SELECT value FROM config_param_user WHERE parameter='epa_junction_y0_vdefault' AND cur_user=current_user)::float WHERE y0 IS NULL;
	UPDATE raingage SET scf=(SELECT value FROM config_param_user WHERE parameter='epa_rgage_scf_vdefault' AND cur_user=current_user)::float WHERE scf IS NULL;
		
	-- Upsert on rpt_cat_table
	DELETE FROM rpt_cat_result WHERE result_id=result_id_var;
	INSERT INTO rpt_cat_result (result_id) VALUES (result_id_var);
		
	-- Upsert on node rpt_inp result manager table
	DELETE FROM inp_selector_result WHERE cur_user=current_user;
	INSERT INTO inp_selector_result (result_id, cur_user) VALUES (result_id_var, current_user);
	
	IF v_usenetworkgeom IS FALSE THEN

		-- Fill inprpt tables
		PERFORM gw_fct_pg2epa_fill_data(result_id_var);
	
		-- Make virtual arcs (EPA) transparents for hydraulic model
		PERFORM gw_fct_pg2epa_join_virtual(result_id_var);
		
		-- Call nod2arc function
		PERFORM gw_fct_pg2epa_nod2arc_geom(result_id_var);
		
		-- Calling for gw_fct_pg2epa_flowreg_additional function
		PERFORM gw_fct_pg2epa_nod2arc_data(result_id_var);
	
	END IF;
	
	IF v_dumpsubcatch THEN
		-- Dump subcatchments
		PERFORM gw_fct_pg2epa_dump_subcatch ();
	END IF;
		
	-- Calling for the export function
	PERFORM gw_fct_utils_csv2pg_export_swmm_inp(result_id_var, null);
	
	-- manage return message
	v_input = concat('{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"parameters":{"resultId":"',result_id_var,'"},"saveOnDatabase":true}}')::json;
	SELECT gw_fct_pg2epa_check_data(v_input) INTO v_return;

	v_return = replace(v_return::text, '"message":{"priority":1, "text":"Data quality analysis done succesfully"}', '"message":{"priority":1, "text":"Inp export done succesfully"}')::json;
	
RETURN v_return;

	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;