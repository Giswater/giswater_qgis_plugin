/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2516

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_addfields(integer, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_addfields(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_addfields($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},"data":{}}$$)
*/


DECLARE
	v_addfields record;
	v_result_id text= 'import add fields';
	v_result json;
	v_result_info json;
	v_project_type text;
	v_version text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1;
   
	-- manage log (fprocesscat 42)
	DELETE FROM audit_check_data WHERE fprocesscat_id=42 AND user_name=current_user;
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('IMPORT ADD FIELDS FILE'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('------------------------------'));
   
 	-- starting process
	FOR v_addfields IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=4
	LOOP
		INSERT INTO man_addfields_value (feature_id, parameter_id, value_param) VALUES
		(v_addfields.csv1, v_addfields.csv2::integer, v_addfields.csv3);			
	END LOOP;

	-- Delete values on temporal table
	DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=4;

	-- manage log (fprocesscat 42)
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Reading values from temp_csv2pg table -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Inserting values on man_addfields_value table -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Deleting values from temp_csv2pg -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Process finished'));

	-- get log (fprocesscat 42)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=42) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
			
	-- Control nulls
	v_version := COALESCE(v_version, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 
 
	-- Return
	RETURN ('{"status":"Accepted", "message":{"priority":0, "text":"Process executed"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;
	    
	--    Exception handling
	--EXCEPTION WHEN OTHERS THEN 
	--RETURN ('{"status":"Failed","message":{"priority":2, "text":' || to_json(SQLERRM) || '}, "version":"'|| v_version ||'","SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
