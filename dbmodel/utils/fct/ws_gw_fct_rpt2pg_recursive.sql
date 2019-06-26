/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2322


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_rpt2pg_recursive(character varying );
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_rpt2pg_recursive(p_data json)  
RETURNS json AS $BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_rpt2pg_recursive($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"recursive":"off", "resultId":"test1"}}$$)

SELECT SCHEMA_NAME.gw_fct_rpt2pg_recursive($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"recursive":"ongoing", "resultId":"test1", "currentStep":"2"}}$$)
*/

DECLARE
   
	v_result text;
	v_usenetworkgeom boolean;
	v_tableid text;
	v_functionid text;
	v_functionname text;
	v_steps integer;
	v_currentstep integer;
	v_storeallresults boolean;
	v_return json;

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	--  Get input data
	v_result =  (p_data->>'data')::json->>'resultId';
	v_currentstep =  (p_data->>'data')::json->>'currentStep';

	
	-- get variables
	--v_functionid = (SELECT (value::json->>'id') FROM config_param_user WHERE parameter='inp_options_recursive' AND cur_user=current_user);
	v_functionid = '1'; 
	v_functionname = (SELECT (addparam->>'functionName') FROM inp_typevalue WHERE typevalue='inp_recursive_function' AND id = v_functionid);
	v_steps = (SELECT ((addparam::json->>'systemParameters')::json->>'steps') FROM inp_typevalue WHERE typevalue='inp_recursive_function' AND id = '1');
	v_storeallresults = (SELECT ((addparam::json->>'systemParameters')::json->>'storeAllResults') FROM inp_typevalue WHERE typevalue='inp_recursive_function' AND id = v_functionid);

	-- call rpt2pg function
	PERFORM gw_fct_rpt2pg(v_result);

/*  to do
	-- storing results into audit_log_data table (in case of recursive fuction is defined with true)
	IF v_storeallresults THEN
		FOR v_tableid IN SELECT id FROM audit_cat_table WHERE id like 'rpt_'
		LOOP
		
			EXECUTE 'INSERT INTO audit_log_data (fprocesscat_id, log_message)
					SELECT 35, concat (''"resultId":"'''||v_result||'''", "step":"'','||v_currentstep||'''", 
					"table":"'','||quote_ident(id)||'''", "values":{'',row_to_json(a),''}'')
					FROM ( SELECT * FROM '||quote_ident(id)||' WHERE result_id = v_result)';
		END LOOP;
	END IF;	

	-- enhance report message.
	showing step by step to user what is happening...	
*/

	-- return message
	v_return = '{"message":{"priority":0, "text":"Rpt import done succesfully"}}';

RETURN v_return;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;