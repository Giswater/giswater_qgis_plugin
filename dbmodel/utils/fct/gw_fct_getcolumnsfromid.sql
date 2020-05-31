/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2874

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_getcolumnsfrom_id(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getcolumnsfromid(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_getcolumnsfrom_id($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},
"feature":{"tableName":"ve_arc_pipe", "columnId":"elevation1", "id":"114050"},
"data":{}}$$)
*/

DECLARE

v_fields json;
v_childs text;
v_json json;
v_fields_array text[];
v_field text;
v_json_array json[];
schemas_array name[];
v_version json;
v_tablename text;
v_feature_id integer;
i integer = 0;
v_fieldsreload text;
v_result text;
v_exists text;
v_message text;
v_parentname text;
v_parentid integer;
v_featureType text;
v_iseditable boolean;
    
BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- Get schema name
	schemas_array := current_schemas(FALSE);

	-- get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;

	--  get parameters from input
	v_tablename = ((p_data ->>'feature')::json->>'tableName')::text;
	v_feature_id = ((p_data ->>'feature')::json->>'id')::text;
	v_fieldsreload =((p_data ->>'feature')::json->>'fieldsReload')::text;
	v_parentname =((p_data ->>'feature')::json->>'parentField')::text;

	SELECT ARRAY(SELECT json_array_elements((replace(v_fieldsreload, '''','"'))::json))
	FROM  config_form_fields LIMIT 1 INTO v_fields_array;
	
	FOREACH v_field IN array v_fields_array
	LOOP	
		EXECUTE 'SELECT column_name  FROM information_schema.columns WHERE table_name='''||v_tablename||''' and column_name='''|| replace(v_field, '"','') ||''' LIMIT 1' INTO v_exists;
		v_json_array[i] := gw_fct_json_object_set_key(v_json_array[i], 'widgetname', 'data_' || replace(v_field, '"',''));
		IF v_exists is not null THEN
			EXECUTE 'SELECT LOWER(feature_type) FROM cat_feature WHERE child_layer = '''||v_tablename||'''' INTO v_featureType;
			EXECUTE 'SELECT '|| replace(v_field, '"','') ||' FROM ' || v_tablename ||' WHERE '||v_featureType||'_id = '''|| v_feature_id ||'''' INTO v_result;
			EXECUTE 'SELECT iseditable FROM config_form_fields WHERE formname = '''|| v_tablename ||''' AND columnname = '''|| replace(v_field, '"','') ||'''' INTO v_iseditable;
			v_json_array[i] := gw_fct_json_object_set_key(v_json_array[i], 'value', COALESCE(v_result, ''));
			v_json_array[i] := gw_fct_json_object_set_key(v_json_array[i], 'iseditable', v_iseditable);
			i = i+1;
		ELSE
			EXECUTE 'SELECT id FROM config_form_fields WHERE formname ='''||v_tablename||''' AND columnname = '''||v_parentname||'''' INTO v_parentid;
			v_message := 'API is bad configurated. Check column ''reloadfields'' for parameter '''|| v_parentname ||''' with id -> '''||v_parentid||''' on config_form_fields';
			v_result := '{"level":0, "text":"'||v_message||'"}';
			v_json_array[i] := gw_fct_json_object_set_key(v_json_array[i], 'value', ''::text);
			v_json_array[i] := gw_fct_json_object_set_key(v_json_array[i], 'message', v_result::json);
			i = i+1;
		END IF;
	END LOOP;
	
	-- Convert to json
	v_fields := array_to_json(v_json_array);

	-- Control NULL's
	v_version := COALESCE(v_version, '[]');
	v_fields := COALESCE(v_fields, '[]');   
	    
	-- Return
	RETURN v_fields::json;

	--Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
