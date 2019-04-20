/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2510

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_dbprices(integer, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_dbprices(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_dbprices($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},"data":{}}$$)
*/

DECLARE
	v_units record;
	v_result_id text= 'import db prices';
	v_result json;
	v_result_info json;
	v_project_type text;
	v_version text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1;
   
	-- manage log (fprocesscat = 42)
	DELETE FROM audit_check_data WHERE fprocesscat_id=42 AND user_name=current_user;
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('IMPORT DB PRICES FILE'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('------------------------------'));

	-- starting process

	-- control of price code (csv1)
	SELECT csv1 INTO v_units FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1;

	IF v_units IS NULL THEN
		RETURN audit_function(2086,2440);
	END IF;
	
	-- control of price units (csv2)
	SELECT csv2 INTO v_units FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1
	AND csv2 IS NOT NULL AND csv2 NOT IN (SELECT unit FROM price_simple);

	IF v_units IS NOT NULL THEN
		RETURN audit_function(2088,2440,(v_units)::text);
	END IF;

	-- control of price descript (csv3)
	SELECT csv3 INTO v_units FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1;

	IF v_units IS NULL THEN
		RETURN audit_function(2090,2440);
	END IF;

	-- control of null prices(csv5)
	SELECT csv5 INTO v_units FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1;

	IF v_units IS NULL THEN
		RETURN audit_function(2092,2440);
	END IF;
	
	-- Insert into audit table
	INSERT INTO audit_log_csv2pg  (csv2pgcat_id, user_name, csv1, csv2, csv3, csv4, csv5)
	SELECT csv2pgcat_id, user_name, csv1, csv2, csv3, csv4, csv5
	FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1;

	-- Insert into price_cat_simple table
	IF label_aux NOT IN (SELECT id FROM price_cat_simple) THEN
		INSERT INTO price_cat_simple (id) VALUES (label_aux);
	END IF;

	-- Upsert into price_simple table
	INSERT INTO price_simple (id, pricecat_id, unit, descript, text, price)
	SELECT csv1, label_aux, csv2, csv3, csv4, csv5::numeric(12,4)
	FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1
	AND csv1 NOT IN (SELECT id FROM price_simple);

	UPDATE price_simple SET pricecat_id=label_aux, price=csv5::numeric(12,4) FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1 AND price_simple.id=csv1;
		
	-- Delete values on temporal table
	DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1;	

	-- manage log (fprocesscat 42)
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Reading values from temp_csv2pg table -> Done'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, error_message) VALUES (42, v_result_id, concat('Inserting values on price_simple table -> Done'));
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
	EXCEPTION WHEN OTHERS THEN 
	RETURN ('{"status":"Failed","message":{"priority":2, "text":' || to_json(SQLERRM) || '}, "version":"'|| v_version ||'","SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
