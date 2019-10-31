/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2764

DROP FUNCTION IF EXISTS proyecto_prueba.gw_fct_odbc2pg_check_data(json);
CREATE OR REPLACE FUNCTION proyecto_prueba.gw_fct_odbc2pg_check_data(p_data json)
  RETURNS json AS
$BODY$


/*EXAMPLE

SELECT proyecto_prueba.gw_fct_odbc2pg_check_data($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},"data":{"parameters":{"exploitation":"557", "period":"4T", "year":"2019"}}}$$)

*/


DECLARE
	v_expl			integer;
	v_period		text;
	v_year			integer;
	v_project_type		text;
	v_version		text;
	v_result 		json;
	v_result_info		json;
	v_querytext		text;
	v_count			integer;

BEGIN

	--  Search path	
	SET search_path = "proyecto_prueba", public;

	-- getting input data 	
	v_expl := (((p_data ->>'data')::json->>'parameters')::json->>'exploitation')::integer;
	v_year := (((p_data ->>'data')::json->>'parameters')::json->>'year')::integer;
	v_period := (((p_data ->>'data')::json->>'parameters')::json->>'period')::text;
	
	-- select config values
	SELECT wsoftware, giswater INTO v_project_type, v_version FROM version order by id desc limit 1;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id=89 AND user_name=current_user;
	
	
	-- Starting process
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 4, concat('DATA ANALYSIS ACORDING ODBC IMPORT-EXPORT RULES'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 4, '--------------------------------------------------------------');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 3, 'CRITICAL ERRORS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 3, '----------------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 2, 'WARNINGS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 1, '-------');	
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 0, 'NETWORK ANALYSIS');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 0, '-------------------------');	


	-- TODO
	-- connecs export through odbc system
	
	-- TODO
	-- connecs with period volume values imported through odbc system
	
	-- FAKE
	v_querytext = 'SELECT node_id FROM node';

	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (89, 1, concat('INFO: ',v_count,' connec(s) with flow values have been inserted trhough ODBC connection.'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (89, 2, 'WARNING: No values for connec(s) have been received using ODBC system.');
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (89, 1, concat('HINT: Take a look on the ODBC system. It seems something is not going on'));
	END IF;


	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 4, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 3, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 2, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (89, NULL, 1, '');
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=89 order by criticity desc, id asc) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
			
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	
--  Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"ODBC connection analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}'||'}}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
