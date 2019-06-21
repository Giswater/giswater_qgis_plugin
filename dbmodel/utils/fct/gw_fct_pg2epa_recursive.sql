/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2646

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_recursive(p_data json)  
RETURNS integer AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_recursive($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"status":"start", "resultId":"test1", "useNetworkGeom":"true", "dumpSubcatch":"true"}}$$)

SELECT SCHEMA_NAME.gw_fct_pg2epa_recursive($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"status":"ongoing", "resultId":"test1", "useNetworkGeom":"true", "dumpSubcatch":"true" "}}$$)

SELECT SCHEMA_NAME.gw_fct_pg2epa_recursive($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"status":"off", "resultId":"test1", "useNetworkGeom":"true", "dumpSubcatch":"true" "}}$$)

*/

DECLARE
v_status text;
v_result text;
v_id integer;
v_data json;
v_recursive_id integer;
v_fprocesscat integer;
v_functionname text;
v_steps integer;


BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

--  Get input data
	v_status = (p_data->>'data')::json->>'status';
	v_result =  (p_data->>'data')::json->>'resultId';
	
	IF v_status='off' THEN -- normal call
			SELECT gw_fct_pg2epa(p_data) INTO v_return;
	ELSE -- recursive call 
	
		-- get values of recursive function
		v_recursive_id = (SELECT (value->>'id') FROM config_param_user WHERE parameter='inp_options_recursive' AND cur_user=current_user);
		v_fprocesscat = (SELECT (addparam->>'fprocessCat') FROM inp_typevalue WHERE inp_recursive_function AND id= v_recursive_id;
		v_functionname = (SELECT (addparam->>'functionName') FROM inp_typevalue WHERE inp_recursive_function AND id= v_recursive_id;
		v_steps = (SELECT (addparam->>'steps') FROM inp_typevalue WHERE inp_recursive_function AND id= v_recursive_id;

		-- setting temp_table with any rows any calls using steps number defined on inp_typevalue parameter
		IF v_status='start' THEN
			LOOP 
				v_rownumber = v_rownumber + 1
				INSERT INTO temp_table (fprocesscat_id, text_column) VALUES (v_fprocesscat, concat('"data":{"step":',v_rownumber,', "resultId":"',v_result,'"}'
				EXIT WHEN v_rownumber = v_steps;
		
		END LOOP;

		ELSIF v_status='ongoing' THEN
		
			DELETE FROM temp_table WHERE fprocesscat_id=v_fprocesscat AND user_name=current_user  order by id asc LIMIT 1;
											
		END IF;

		-- setting v_data to call recursive function
		v_data = SELECT text_column FROM temp_table WHERE fprocesscat_id=v_fprocesscat AND user_name=current_user order by id asc LIMIT 1;
		
		-- call recursive function
		EXECUTE 'PERFORM '||v_functionname||'('||v_data||')';
		
		-- call go2epa function
		SELECT gw_fct_pg2epa(p_data) INTO v_return;
		
		-- force true the return to make signal to client that there are more than one pending calls
		SELECT count(*) INTO v_count FROM temp_table WHERE fprocesscat_id=v_fprocesscat AND user_name=current_user;
		IF v_count > 1 THEN
			v_return =  gw_fct_json_set_key (v_return, "continue", "true");								
		END IF;
	
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;