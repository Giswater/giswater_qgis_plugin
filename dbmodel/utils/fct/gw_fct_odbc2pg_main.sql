/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2762

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_odbc2pg_main(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_odbc2pg_main(p_data json)
  RETURNS json AS
$BODY$


/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_odbc2pg_main($${
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
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_expl := (((p_data ->>'data')::json->>'parameters')::json->>'exploitation')::integer;
	v_year := (((p_data ->>'data')::json->>'parameters')::json->>'year')::integer;
	v_period := (((p_data ->>'data')::json->>'parameters')::json->>'period')::text;
	
	-- select config values
	SELECT wsoftware, giswater INTO v_project_type, v_version FROM version order by id desc limit 1;

	-- move data from audit table to other table
	-- SELECT audit_log_data.feature_id, log_message->>'year' AS year, log_message->>'period' AS period, log_message->>'m3value' AS m3value FROM audit_log_data WHERE fprocesscat_id = 73;	
	VALUES (73, 1, 'DMA - NUMBER OF CONNECS IMPORTED WITH NOT NULL VALUES');
	INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message)  
	SELECT 73, 1, concat(dma_id, ' - ', count(*)) FROM v_edit_connec
	JOIN audit_log_data ON connec_id=audit_log_data.feature_id AND feature_type='CONNEC' 
	WHERE expl_id=v_expl
	GROUP BY dma_id; 

	-- check data and get result
	SELECT gw_fct_odbc2pg_check_data(p_data) INTO v_result;

	-- process data
	v_result_info = (((v_result->>'body')::json->>'data')::json->>'info')::json;	
			
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	
--  Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"ODBC connection analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}'||'}}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
