/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3100

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_copy_hydrology_values(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_copy_hydrology_values($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"source":1, "target":2}}$$)

-- fid: 398

*/


DECLARE

v_version text;
v_result json;
v_result_info json;
v_source_id integer;
v_target_id integer;
v_error_context text;
v_count integer;
v_projecttype text;
v_fid integer = 398;
v_source_name text;
v_target_name text;


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- getting input data 	
	v_source_id :=  ((p_data ->>'data')::json->>'source');
	v_target_id :=  ((p_data ->>'data')::json->>'target');
	
	-- getting scenario name
	v_source_name := (SELECT name FROM cat_dscenario WHERE id = v_source_id);
	v_target_name := (SELECT name FROM cat_dscenario WHERE id = v_target_id);
	
	
	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;	
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('COPY DSCENARIO VALUES FROM ', v_source_name, ' TO ', v_target_name));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '---------------------------------------------------------------------------------------');

    
	-- Computing process
	IF v_projecttype = 	'UD' THEN
	
			
	ELSIF v_projecttype = 'WS' THEN
	
		
	END IF;
		
		-- set selector
	INSERT INTO selector_dscenario (dscenario_id,cur_user) VALUES (v_target_id, current_user);
	
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3100, null, null, null); 

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;