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
"data":{"status":"start", "result_id":"test1"}}$$)

SELECT SCHEMA_NAME.gw_fct_pg2epa_recursive($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"status":"ongoing", "result_id":"test1"}}$$)
*/

DECLARE
v_status text;
v_result text;
v_id integer;
v_data json;

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;


--  Get input data
	v_status = (p_data->>'data')::json->>'status';
	v_result =  (p_data->>'data')::json->>'result_id';
	v_recursive_function = (SELECT value FROM config_param_user WHERE parameter='inp_options_recursive' AND cur_user=current_user);

	IF v_status='start' THEN
	
		IF v_recursive_function = 'gw_fct_pg2epa_hydrant' THEN
		
			INSERT INTO temp_table (fprocesscat_id, text_column) VALUES (35,concat('"data":{"step":0, "resultId":"',v_result,'"}');
			INSERT INTO temp_table (fprocesscat_id, text_column) VALUES (35,concat('"data":{"step":1, "resultId":"',v_result,'"}');
			INSERT INTO temp_table (fprocesscat_id, text_column) VALUES (35,concat('"data":{"step":2, "resultId":"',v_result,'"}');
			INSERT INTO temp_table (fprocesscat_id, text_column) VALUES (35,concat('"data":{"step":3, "resultId":"',v_result,'"}');
			INSERT INTO temp_table (fprocesscat_id, text_column) VALUES (35,concat('"data":{"step":4, "resultId":"',v_result,'"}');
			
			RETURN 4;
			
		END IF;
		
	ELSIF v_status='ongoing' THEN
	
		IF v_recursive_function = 'gw_fct_pg2epa_hydrant' THEN
	
			-- setting recursive function
			v_data = SELECT text_column FROM temp_table WHERE fprocesscat_id=35 AND user_name=current_user order by id asc LIMIT 1;
			PERFORM gw_fct_pg2epa_hydrant(v_data);
			
		END IF;	
		
		-- deleting row
		DELETE FROM temp_table WHERE fprocesscat_id=35 AND user_name=current_user  order by id asc LIMIT 1;
			
		-- couting rows to show user
		SELECT count(*) INTO v_count FROM temp_table WHERE fprocesscat_id=35 AND user_name=current_user;
			
		RETURN v_count; -- WHEN v_count is 0 python client stop the process
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;