-- Function: SCHEMA_NAME.gw_api_getcolumnfromid(json)

-- DROP FUNCTION SCHEMA_NAME.gw_api_getcolumnfromid(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getcolumnfromid(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_api_getcolumnfromid($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"tableName":"ve_arc_pipe", "columnId":"elevation1", "id":"114050"},
"data":{}}$$)
*/

DECLARE

--    Variables
    v_result text;
    v_fields json;
    v_childs text;
    v_fields_array text[];
    v_field text;
    v_json_array json[];
    schemas_array name[];
    api_version json;
    v_tablename text;
    v_feature_id integer;
    v_column_id text;
    i integer = 0;


BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- Get schema name
	schemas_array := current_schemas(FALSE);

	-- get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO api_version;

	--  get parameters from input
	v_tablename = ((p_data ->>'feature')::json->>'tableName')::text;
	v_feature_id = ((p_data ->>'feature')::json->>'id')::text;
	v_column_id =((p_data ->>'feature')::json->>'columnId')::text;

	-- Get value result
	EXECUTE 'SELECT '||quote_ident(v_column_id)||' FROM '||quote_ident(v_tablename)||' WHERE arc_id = '||quote_literal(v_feature_id::text)||''
		INTO v_result;
	
	-- Get fields array
	EXECUTE 'SELECT isreload FROM config_api_form_fields WHERE formname = '''||quote_ident(v_tablename)||''' AND column_id = '''||quote_ident(v_column_id::text)||''''
		INTO v_fields_array;
				
	FOREACH v_field IN array v_fields_array
	LOOP	
		v_json_array[i] := gw_fct_json_object_set_key(v_json_array[i], v_field, v_result);
		i = i+1;
	END LOOP;
	
	--    Convert to json
	    v_fields := array_to_json(v_json_array);

	--    Control NULL's
	    api_version := COALESCE(api_version, '[]');
	    v_fields := COALESCE(v_fields, '[]');   
	    
	--    Return
	    RETURN ('{"status":"Accepted"' ||
	       ', "apiVersion":'|| api_version ||
		', "data":' || v_fields || '}')::json;

--    Exception handling
 --   EXCEPTION WHEN OTHERS THEN 
   --     RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_api_getcolumnfromid(json)
  OWNER TO postgres;
