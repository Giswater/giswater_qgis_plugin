/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 2646  
-- FPROCESSCAT : 35

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa_main(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_main(p_data json)  
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"iterative":"start", "resultId":"test1", "useNetworkGeom":"true", "dumpSubcatch":"true"}}$$)

SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"iterative":"ongoing", "resultId":"test1", "useNetworkGeom":"true", "dumpSubcatch":"true"}}$$)

SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"iterative":"off", "resultId":"test1", "useNetworkGeom":"true", "dumpSubcatch":"true"}}$$)

*/

DECLARE
v_iterative text;
v_result text;
v_id integer;
v_data json;
v_functionid text;
v_functionname text;
v_steps integer;
v_currentstep integer;
v_storeallresults boolean;
v_tableid text;
v_return json;
v_rownumber integer = 0;
v_count integer;
v_querytext text;


BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

--  Get input data
	v_iterative = (p_data->>'data')::json->>'iterative';
	v_result =  (p_data->>'data')::json->>'resultId';
	
	IF v_iterative='off' THEN -- normal call
			SELECT gw_fct_pg2epa(p_data) INTO v_return;
			
	ELSE -- iterative call 
	
		-- get values of iterative function
		-- forced values for dev
		--v_functionid = (SELECT (value::json->>'id') FROM config_param_user WHERE parameter='inp_options_iterative' AND cur_user=current_user);
		v_functionid = '1'; 
		v_functionname = (SELECT (addparam->>'functionName') FROM inp_typevalue WHERE typevalue='inp_iterative_function' AND id = v_functionid);
		v_steps = (SELECT ((addparam::json->>'systemParameters')::json->>'steps') FROM inp_typevalue WHERE typevalue='inp_iterative_function' AND id = '1');

		raise notice ' v_functionname % v_steps % ', v_functionname, v_steps;

		-- setting temp_table with any rows any calls using steps number defined on inp_typevalue parameter
		IF v_iterative='start' THEN

			-- delete values from tables
			DELETE FROM temp_table WHERE fprocesscat_id = 35 AND user_name=current_user;
			DELETE FROM audit_log_data WHERE fprocesscat_id = 35 AND user_name=current_user;

			-- inserting process rows
			LOOP 
				raise notice ' loop %', v_rownumber;
				
				v_rownumber = v_rownumber + 1;
				INSERT INTO temp_table (fprocesscat_id, text_column) VALUES (35, concat('{"data":{"step":"',v_rownumber,'", "resultId":"',v_result,'"}}'));
				EXIT WHEN v_rownumber = v_steps;						
			END LOOP;
		
		ELSIF v_iterative='ongoing' THEN
		
			DELETE FROM temp_table WHERE id = (SELECT id FROM temp_table WHERE fprocesscat_id=35 AND user_name=current_user ORDER BY id asc LIMIT 1);
											
		END IF;

		-- get counter
		SELECT count(*) INTO v_count FROM temp_table WHERE fprocesscat_id=35 AND user_name=current_user;
		
		-- set counter
		v_currentstep = v_steps - v_count;
				
		-- setting v_data to call iterative function
		v_data = (SELECT text_column FROM SCHEMA_NAME.temp_table WHERE fprocesscat_id=35 AND user_name=current_user order by id asc LIMIT 1);
		
		-- call iterative function selected by user
		v_querytext = 'SELECT '||quote_ident(v_functionname)||'('||quote_literal(v_data)||')';
		EXECUTE v_querytext INTO v_return;
		
		-- call go2epa function
		SELECT gw_fct_pg2epa(p_data) INTO v_return;
		
 		-- replace message
		v_return = replace(v_return::text, '"message":{"priority":1, "text":"Data quality analysis done succesfully"}', '"message":{"priority":1, "text":"Inp export done succesfully"}')::json;

	END IF;
	
	--continue (or not)        
	IF v_count > 1 THEN
	    -- force true the return to make signal to client that there are more than one pending calls. Return from gw_fct_pg2epa is always false
	    v_return =  gw_fct_json_object_set_key (v_return::json, 'continue', true);                                
	    -- setting counter
	    v_return =  gw_fct_json_object_set_key (v_return, 'steps', v_steps);
	ELSE
	    --force true the return to make signal to client that there are more than one pending calls. Return from gw_fct_pg2epa is always false
	    v_return =  gw_fct_json_object_set_key (v_return::json, 'continue', false);                                
	    -- setting counter
	    v_return =  gw_fct_json_object_set_key (v_return, 'steps', 0);
		END IF;   
		
RETURN v_return;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;