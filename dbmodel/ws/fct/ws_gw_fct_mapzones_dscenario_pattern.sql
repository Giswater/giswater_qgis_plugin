/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:3258


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mapzones_dscenario_pattern(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_mapzones_dscenario_pattern($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{}}$$)

--fid:v_fid

*/

DECLARE

v_fid integer =502;
v_dscenario_mapzone integer;
v_dscenario_demand integer;
v_class text;


v_result_id text= 'Insert demands for mapzones';
v_result json;
v_result_info json;
v_project_type text;
v_version text;


v_count integer;

v_error_context text;
v_level integer;
v_status text;
v_message text;
v_audit_result text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;



  v_dscenario_mapzone = (((p_data ->>'data')::json->>'parameters')::json->>'dscenario_mapzone')::text;
  v_class = (((p_data ->>'data')::json->>'parameters')::json->>'graphClass')::text;
  v_dscenario_demand = (((p_data ->>'data')::json->>'parameters')::json->>'dscenario_demand')::integer;
  
	-- manage log (fid:  v_fid)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('INSERT FEATURES WITH PATTERN INTO DEMAND DSCENARIO'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('------------------------------'));

	--check if all mapzones have assigned pattern_id

	EXECUTE 'SELECT count(*) FROM inp_dscenario_mapzone WHERE mapzone_type = '||quote_literal(v_class)||' AND dscenario_id = '||quote_literal(v_dscenario_mapzone)||'
	and pattern_id IS NULL;'
	INTO v_count;

	IF v_count = 0 THEN
		
		EXECUTE 'INSERT INTO inp_dscenario_demand( dscenario_id, feature_id, feature_type, pattern_id)
		SELECT '||v_dscenario_demand||', unnest(connecs), ''CONNEC'', pattern_id FROM inp_dscenario_mapzone
		WHERE mapzone_type = '||quote_literal(v_class)||' AND dscenario_id = '||quote_literal(v_dscenario_mapzone)||';';

		EXECUTE 'SELECT count(*) from inp_dscenario_demand
		WHERE dscenario_id =  '||v_dscenario_demand||' AND feature_type = ''CONNEC'''
		INTO v_count;

		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat(v_count,' connecs  were inserted into demand table.'));

		EXECUTE 'INSERT INTO inp_dscenario_demand( dscenario_id, feature_id, feature_type, pattern_id)
		SELECT '||v_dscenario_demand||', unnest(nodes), ''NODE'', pattern_id FROM inp_dscenario_mapzone
		WHERE mapzone_type = '||quote_literal(v_class)||' AND dscenario_id = '||quote_literal(v_dscenario_mapzone)||';';

		EXECUTE 'SELECT count(*) from inp_dscenario_demand
		WHERE dscenario_id =  '||v_dscenario_demand||' AND feature_type = ''NODE'''
		INTO v_count;

		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat(v_count,' nodes were inserted into demand table.'));
	ELSE
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Exists ',v_count,' mapzones without assigned pattern_id. Fill the data before executing the process.'));
	END IF;
	-- get log (fid: v_fid)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid) row;

	IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
        v_message = 'Process done successfully';
    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;


	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
				
	-- Control nulls
	v_version := COALESCE(v_version, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 
	
	-- Return
	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
            ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;
	    
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


