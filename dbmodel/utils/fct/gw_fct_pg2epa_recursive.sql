/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 2646  
-- FPROCESSCAT : 35

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa_recursive(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_recursive(p_data json)  
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_recursive($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"status":"start", "resultId":"test1", "useNetworkGeom":"true", "dumpSubcatch":"true"}}$$)

SELECT SCHEMA_NAME.gw_fct_pg2epa_recursive($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"status":"ongoing", "resultId":"test1", "useNetworkGeom":"true", "dumpSubcatch":"true"}}$$)

SELECT SCHEMA_NAME.gw_fct_pg2epa_recursive($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"status":"off", "resultId":"test1", "useNetworkGeom":"true", "dumpSubcatch":"true" "}}$$)

*/

DECLARE
v_status text;
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
	v_status = (p_data->>'data')::json->>'status';
	v_result =  (p_data->>'data')::json->>'resultId';
	
	IF v_status='off' THEN -- normal call
			SELECT gw_fct_pg2epa(p_data) INTO v_return;
			
	ELSE -- recursive call 
	
		-- get values of recursive function
		-- forced values for dev
		--v_functionid = (SELECT (value::json->>'id') FROM config_param_user WHERE parameter='inp_options_recursive' AND cur_user=current_user);
		v_functionid = '1'; 
		v_functionname = (SELECT (addparam->>'functionName') FROM inp_typevalue WHERE typevalue='inp_recursive_function' AND id = v_functionid);
		v_steps = (SELECT (addparam::json->>'steps') FROM SCHEMA_NAME.inp_typevalue WHERE typevalue='inp_recursive_function' AND id = '1');
		v_storeallresults = (SELECT (addparam::json->>'storeAllResults') FROM inp_typevalue WHERE typevalue='inp_recursive_function' AND id = v_functionid);

		-- setting temp_table with any rows any calls using steps number defined on inp_typevalue parameter
		IF v_status='start' THEN

			-- delete values from tables
			DELETE FROM temp_table WHERE fprocesscat_id = 35 AND user_name=current_user;
			DELETE FROM audit_log_data WHERE fprocesscat_id = 35 AND user_name=current_user;

			-- inserting process rows
			LOOP 
				v_rownumber = v_rownumber + 1;
				INSERT INTO temp_table (fprocesscat_id, text_column) VALUES (35, concat('{"data":{"step":"',v_rownumber,'", "resultId":"',v_result,'"}}'));
				EXIT WHEN v_rownumber = v_steps;						
			END LOOP;
		
		ELSIF v_status='ongoing' THEN
		
			DELETE FROM temp_table WHERE id = (SELECT id FROM temp_table WHERE fprocesscat_id=35 AND user_name=current_user ORDER BY id asc LIMIT 1);
											
		END IF;

		-- get counter
		SELECT count(*) INTO v_count FROM temp_table WHERE fprocesscat_id=35 AND user_name=current_user;
		
		-- set counter
		v_currentstep = v_steps - v_count;
				
		--continue (or not)		
		IF v_count > 0 THEN
			-- force true the return to make signal to client that there are more than one pending calls. Return from gw_fct_pg2epa is always false
			v_return =  gw_fct_json_object_set_key (v_return::json, 'continue', true);								
		
			-- setting counter
			v_return =  gw_fct_json_object_set_key (v_return, 'counter', v_currentstep);
		ELSE 
			RETURN '{"message":{"priority":1, "text":"Last inp export done succesfully"}}';
		END IF;	

	
		-- setting v_data to call recursive function
		v_data = (SELECT text_column FROM SCHEMA_NAME.temp_table WHERE fprocesscat_id=35 AND user_name=current_user order by id asc LIMIT 1);
		
		-- call recursive function selected by user
		v_querytext = 'SELECT '||quote_ident(v_functionname)||'('||quote_literal(v_data)||')';
		EXECUTE v_querytext INTO v_return;
		
		-- call go2epa function
		SELECT gw_fct_pg2epa(p_data) INTO v_return;

		-- replace message
		v_return = replace(v_return::text, '"message":{"priority":1, "text":"Data quality analysis done succesfully"}', '"message":{"priority":1, "text":"Inp export done succesfully"}')::json;
			
		-- storing results into audit_log_data table (in case of recursive fuction is defined with true)
		IF v_storeallresults THEN
			FOR v_tableid IN SELECT id FROM audit_cat_table WHERE id like 'rpt_'
			LOOP
		
			EXECUTE 'INSERT INTO audit_log_data (fprocesscat_id, log_message)
					SELECT 35, concat (''"resultId":"'''||result_id||'''", "step":"'','||v_currentstep||'''", 
					"table":"'','||quote_ident(id)||'''", "values":{'',row_to_json(a),''}'')
					FROM ( SELECT * FROM '||quote_ident(id)||' WHERE result_id = v_result)';
			END LOOP;
		END IF;

	END IF;

RETURN v_return;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;