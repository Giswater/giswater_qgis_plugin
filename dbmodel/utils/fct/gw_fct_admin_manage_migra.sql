/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3130

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_manage_migra(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_migra(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_admin_manage_migra($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, 
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"action":"DISABLE"}}}$$);

SELECT SCHEMA_NAME.gw_fct_admin_manage_migra($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, 
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"action":"ENABLE"}}}$$);

-- fid: 437

*/

DECLARE
v_fid integer=437;
v_schemaname text;
v_projectype text;
v_action boolean;
v_result json;
v_result_info text;
v_version text;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	SELECT project_type, giswater INTO v_projectype, v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	
	v_action = json_extract_path_text(p_data,'data','parameters','action')::boolean;
	
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('TOPOCONTROL FOR DATA MIGRATION'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '-------------------------------------------------------------');


	IF v_action IS TRUE THEN
		INSERT INTO config_param_user (parameter, value, cur_user)
		VALUES ('edit_disable_topocontrol', v_action::text, current_user )
		ON CONFLICT (parameter, cur_user) DO UPDATE SET value=v_action::text;
		INSERT INTO audit_check_data(fid,  error_message)
		VALUES (v_fid,  'Migration mode activated. Topocontrol is disabled');
	ELSE
		DELETE FROM config_param_user WHERE parameter='edit_disable_topocontrol' and cur_user =current_user;
		INSERT INTO audit_check_data(fid,  error_message)
		VALUES (v_fid,  'Work mode activated. Topocontrol is enabled');
	END IF;	

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Process done succesfully"}, "version":"'||v_version||'"'||
			 ',"body":{"form":{}'||
			 ',"data":{ "info":'||v_result_info||','||
				'"point":{"geometryType":"", "values":[]}'||','||
				'"line":{"geometryType":"", "values":[]}'||','||
				'"polygon":{"geometryType":"", "values":[]}'||
			   '}}'||
		'}')::json, 3130, null, null, null);

	
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ', "version":'|| v_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
