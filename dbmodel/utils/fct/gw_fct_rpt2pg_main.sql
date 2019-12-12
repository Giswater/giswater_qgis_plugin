/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2726


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_rpt2pg_main(character varying );
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_rpt2pg_main(p_data json)  
RETURNS json AS $BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_rpt2pg_main($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"iterative":"disabled", "resultId":"test1"}}$$)

SELECT SCHEMA_NAME.gw_fct_rpt2pg_main($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"iterative":"enabled", "resultId":"test1", "currentStep":"2", "continue":"true"}}$$)
*/

DECLARE
   
	v_result text;
	v_usenetworkgeom boolean;
	v_tableid text;
	v_functionid text;
	v_functionname text;
	v_steps integer;
	v_currentstep integer;
	v_return json;
	v_projecttype text;
	v_iterative text;
	v_continue text;

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	--  Get input data
	v_result =  (p_data->>'data')::json->>'resultId';
	v_currentstep =  (p_data->>'data')::json->>'currentStep';
	v_iterative =  (p_data->>'data')::json->>'iterative';
	v_continue =  (p_data->>'data')::json->>'continue';

	
	-- get variables
	v_projecttype = (SELECT wsoftware FROM version LIMIT 1);

	-- get if function is on iterative mode
	IF v_iterative = 'enabled' THEN 
		--v_functionid = (SELECT (value::json->>'id') FROM config_param_user WHERE parameter='inp_options_iterative' AND cur_user=current_user);
		v_functionid = '1'; 
		v_functionname = (SELECT (addparam->>'functionName') FROM inp_typevalue WHERE typevalue='inp_iterative_function' AND id = v_functionid);
		v_steps = (SELECT ((addparam::json->>'systemParameters')::json->>'steps') FROM inp_typevalue WHERE typevalue='inp_iterative_function' AND id = '1');
		
	END IF;

	-- call rpt2pg function
	IF v_projecttype = 'WS' THEN
		PERFORM gw_fct_utils_csv2pg_import_epanet_rpt(p_data);
	
	ELSIF v_projecttype = 'UD' THEN
		PERFORM gw_fct_utils_csv2pg_import_swmm_rpt(p_data);
	
	END IF;

	-- get if function is on iterative mode
	IF v_iterative = 'enabled' THEN 
		v_functionid = (SELECT (value::json->>'id') FROM config_param_user WHERE parameter='inp_options_iterative' AND cur_user=current_user);
		v_functionname = (SELECT (addparam->>'functionName') FROM inp_typevalue WHERE typevalue='inp_iterative_function' AND id = v_functionid);

		-----------------------------------



		-----------------------------------

		IF v_continue = FALSE THEN
			EXECUTE 'PERFORM '||v_functionname'($${"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"parameters":{"step":"last", "resultId":"'||v_result||'"}}}$$';
		END IF;		
		
	END IF;

	-- TO MOVE FROM HERE TO UPPER POSITION
	--------------------------------------------------------------------------------------------------
	FOR v_tableid IN SELECT id FROM audit_cat_table WHERE id IN ('rpt_node', 'rpt_arc')
	LOOP
		EXECUTE 'INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message)
			 SELECT 35, '||quote_literal(v_tableid)||','||v_currentstep||',
			 row_to_json(a) FROM ( SELECT * FROM '||quote_ident(v_tableid)||' WHERE result_id = '||quote_literal(v_result)||')a';
	END LOOP;
	-------------------------------------------------------------------------------------------------

	-- set selectors
	SELECT gw_fct_rpt2pg (v_result) INTO v_return;

RETURN v_return;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;