/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 3126
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setchangefeaturetype(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setchangefeaturetype (p_data json)
RETURNS json AS
$BODY$

/*
SELECT gw_fct_setchangefeaturetype($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, 
"form":{}, "feature":{"type":"node"}, "data":{"filterFields":{}, "pageInfo":{}, 
"old_feature_id":"1109", "feature_type_new":"HYDRANT", "featurecat_id":"HYDRANT 1X110"}}$$);

-- fid: 436

*/
 
DECLARE

v_id_column text;
v_feature_id varchar;
v_cat_column text;
v_feature_type text;
v_project_type text;
v_version text;
v_feature_type_new text;
v_featurecat_id_new text;
v_fid integer = 436;
v_category text;
v_function text;
v_fluid text;
v_location text;
v_feature_layer text;

v_result_id text= 'Change feature type';
v_result text;
v_result_info text;
v_error_context text;
v_audit_result text;
v_level integer;
v_status text;
v_message text;

BEGIN

	-- Search path
	SET search_path = 'SCHEMA_NAME', public;

	SELECT upper(project_type), giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	--set current process as users parameter
	DELETE FROM config_param_user  WHERE  parameter = 'utils_cur_trans' AND cur_user =current_user;

	INSERT INTO config_param_user (value, parameter, cur_user)
	VALUES (txid_current(),'utils_cur_trans',current_user );
    
	
	-- manage log (fid: 143)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('REPLACE FEATURE'));
	INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('------------------------------'));

	-- get input parameters
	
	v_feature_type = lower(((p_data ->>'feature')::json->>'type'))::text;
	v_feature_id = ((p_data ->>'data')::json->>'feature_id')::text; -- en vez de old_feature_id
	v_feature_type_new = ((p_data ->>'data')::json->>'feature_type_new')::text;
	v_featurecat_id_new = ((p_data ->>'data')::json->>'featurecat_id')::text;

	--define columns used for feature_cat
	v_feature_layer = concat('v_edit_',v_feature_type);
	v_id_column:=concat(v_feature_type,'_id');

	IF v_feature_type='connec' THEN
		v_cat_column='connecat_id';
	ELSIF  v_feature_type='gully' THEN
		v_cat_column = 'gratecat_id';
	ELSIF  v_feature_type='node' THEN
		v_cat_column='nodecat_id';
	ELSIF  v_feature_type='arc' THEN
		v_cat_column='arccat_id';
	END IF;

	EXECUTE 'SELECT n.category_type FROM '||v_feature_layer||' n JOIN man_type_category m ON n.category_type=m.category_type
	WHERE  feature_type = '''||upper(v_feature_type)||''' AND 
	(featurecat_id IS NULL OR '''||v_feature_type_new||''' = ANY(featurecat_id::text[])) AND '||v_id_column||'='''||v_feature_id||''';'
	INTO v_category;
	IF v_category IS NULL THEN
		EXECUTE 'UPDATE '||v_feature_layer||' SET category_type=NULL WHERE '||v_feature_type||'_id=v_feature_id;';
	END IF;

	EXECUTE 'SELECT n.function_type FROM '||v_feature_layer||' n JOIN man_type_function m ON n.function_type=m.function_type
	WHERE  feature_type = '''||upper(v_feature_type)||''' AND 
	(featurecat_id IS NULL OR '''||v_feature_type_new||''' = ANY(featurecat_id::text[])) AND '||v_id_column||'='''||v_feature_id||''';'
	INTO v_function;
	IF v_function IS NULL THEN
		EXECUTE 'UPDATE '||v_feature_layer||' SET function_type=NULL WHERE '||v_feature_type||'_id=v_feature_id;';
	END IF;
	
	EXECUTE 'SELECT n.fluid_type FROM '||v_feature_layer||' n JOIN man_type_fluid m ON n.fluid_type=m.fluid_type
	WHERE  feature_type = '''||upper(v_feature_type)||''' AND 
	(featurecat_id IS NULL OR '''||v_feature_type_new||''' = ANY(featurecat_id::text[])) AND '||v_id_column||'='''||v_feature_id||''';'
	INTO v_fluid;
	IF v_fluid IS NULL THEN
		EXECUTE 'UPDATE '||v_feature_layer||' SET fluid_type=NULL WHERE '||v_feature_type||'_id=v_feature_id;';
	END IF;

	EXECUTE 'SELECT n.location_type FROM '||v_feature_layer||' n JOIN man_type_location m ON n.location_type=m.location_type
	WHERE  feature_type = '''||upper(v_feature_type)||''' AND 
	(featurecat_id IS NULL OR '''||v_feature_type_new||''' = ANY(featurecat_id::text[])) AND '||v_id_column||'='''||v_feature_id||''';'
	INTO v_location;
	IF v_location IS NULL THEN
		EXECUTE 'UPDATE '||v_feature_layer||' SET location_type=NULL WHERE '||v_feature_type||'_id=v_feature_id;';
	END IF;

	IF v_project_type = 'WS' THEN
		EXECUTE 'UPDATE '||v_feature_layer||' SET '||v_cat_column||'='||quote_literal(v_featurecat_id_new)||'
		WHERE '||v_id_column||'='''||v_feature_id||''';';
	ELSE
		EXECUTE 'UPDATE '||v_feature_layer||' SET '||v_feature_type||'_type='||quote_literal(v_feature_type_new)||',
		'||v_cat_column||'='||quote_literal(v_featurecat_id_new)||'
		WHERE '||v_id_column||'='''||v_feature_id||''';';
	END IF;

	-- get log (fid: 143)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid) row;

	IF v_audit_result is null THEN
	v_status = 'Accepted';
	v_level = 3;
	v_message = 'Replace feature done successfully';
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
		     ',"data":{ "featureId":"'||v_feature_id||'",
				"info":'||v_result_info||'}}'||
	    '}')::json;
	    
	--    Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;  
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_error_context) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
