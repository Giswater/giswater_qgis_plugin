-- Function: ws_sample.gw_api_gettoolbox(json)

-- DROP FUNCTION ws_sample.gw_api_gettoolbox(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_gettoolbox(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_api_gettoolbox($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"filterText":""}}$$)
*/


DECLARE
	v_apiversion text;
	v_role text;
	v_projectype text;
	v_filter text;
	v_edit_fields json;
	v_admin_fields json;
	v_master_fields json;

		
BEGIN

-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
  
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;

-- get input parameter
	v_filter := (p_data ->> 'data')::json->> 'filterText';
	v_filter := COALESCE(v_filter, '');
-- get project type
        SELECT wsoftware INTO v_projectype FROM version LIMIT 1;

-- get edit toolbox parameters

	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		 SELECT alias, descript, function_type_,input_params_, sys_role_id, function_name as functionname
		 FROM audit_cat_function
		 WHERE istoolbox is TRUE AND alias LIKE ''%'|| v_filter ||'%'' AND sys_role_id =''role_edit'') a'
		USING v_filter
		INTO v_edit_fields;
		raise notice 'aaa - %',v_edit_fields;

-- get admin toolbox parameters

	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		 SELECT alias, descript, function_type_,input_params_, sys_role_id, function_name as functionname
		 FROM audit_cat_function
		 WHERE istoolbox is TRUE AND alias LIKE ''%'|| v_filter ||'%'' AND sys_role_id =''role_admin'') a'
		USING v_filter
		INTO v_admin_fields;

-- get master toolbox parameters

	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		 SELECT alias, descript, function_type_,input_params_, sys_role_id, function_name as functionname
		 FROM audit_cat_function
		 WHERE istoolbox is TRUE AND alias LIKE ''%'|| v_filter ||'%'' AND sys_role_id =''role_master'') a'
		USING v_filter
		INTO v_master_fields;

        

--    Control NULL's
	v_edit_fields := COALESCE(v_edit_fields, '{}');
	v_admin_fields := COALESCE(v_admin_fields, '{}');
	v_master_fields := COALESCE(v_master_fields, '{}');
	
--    Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"form":{}'||
		     ',"feature":{}'||
		     ',"data":{"fields":{"edit":' || v_edit_fields ||'' ||
					',"master":' || v_admin_fields ||'' ||
					',"admin":' || v_master_fields ||'}}}'||
	    '}')::json;
       
--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_api_gettoolbox(json)
  OWNER TO postgres;
