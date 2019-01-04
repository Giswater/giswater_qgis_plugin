/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2598

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getrowinsert(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
--configured
SELECT SCHEMA_NAME.gw_api_getrowinsert($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"tableName":"v_edit_man_pipe"},
"data":{}}$$)

--NOT configured
SELECT SCHEMA_NAME.gw_api_getrowinsert($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"tableName":"arc"},
"data":{}}$$)
*/

DECLARE
	v_apiversion text;
	v_schemaname text;
	v_tablename text;
	v_id text;
	v_device integer;
	v_formname text;
	v_fields json [];
	v_fields_json json;
	v_formheader text;
	v_configtabledefined boolean;
	v_idname text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;

	--  get parameters from input
	v_tablename = ((p_data ->>'feature')::json->>'tableName')::text;
	v_device = ((p_data ->>'client')::json->>'device')::integer;


	-- get if it's cofigured
	IF (SELECT distinct formname from config_api_form_fields WHERE formname=v_tablename AND formtype='listrow') IS NOT NULL THEN 
		v_configtabledefined = TRUE;
	ELSE 
		v_configtabledefined = FALSE;
	END IF;

	-- getting primary key
	 EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
		INTO v_idname
		USING v_tablename;
        
	-- For views it suposse pk is the first column
	IF v_idname ISNULL THEN
		EXECUTE '
		SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
		AND t.relname = $1 
		AND s.nspname = $2
		ORDER BY a.attnum LIMIT 1'
		INTO v_idname
		USING v_tablename, v_schemaname;
	END IF;

	-- executing form fields
	IF  v_configtabledefined is TRUE THEN 
		raise notice 'Configuration fields are defined on config_api_layer_field';
		
		-- Call the function of feature fields generation
		SELECT gw_api_get_formfields( v_tablename, 'listrow', null, null, null, null, null, 'INSERT', null, v_device) INTO v_fields; 
		
	ELSE
		raise notice 'Configuration fields are NOT defined on config_api_layer_field. System values will be used';
	
		-- Get fields
		EXECUTE 'SELECT array_agg(row_to_json(a)) FROM 
			(SELECT a.attname as label, a.attname as column_id, a.attname as name, concat(''data'',''_'',a.attname) AS widgetname,
			''text'' as widgettype, ''text'' as "type" , ''string'' as "datatype", ''string'' as "dataType", ''::TEXT AS tooltip, ''::TEXT as placeholder, 
			true AS iseditable,
			row_number()over() AS orderby, 
			1 AS layout_id, 
			row_number()over() AS layout_order, 
			FALSE AS dv_parent_id, FALSE AS isparent, FALSE AS button_function, ''::TEXT AS dv_querytext, ''::TEXT AS dv_querytext_filterc, FALSE AS action_function, FALSE AS isautoupdate
			FROM pg_attribute a
			JOIN pg_class t on a.attrelid = t.oid
			JOIN pg_namespace s on t.relnamespace = s.oid
			WHERE a.attnum > 0 
			AND NOT a.attisdropped
			AND t.relname = $1 
			AND s.nspname = $2
			AND a.attname !=''the_geom''
			AND a.attname !=''geom''
			ORDER BY a.attnum) a'
				INTO v_fields
				USING v_tablename, v_schemaname; 
	END IF;

	v_fields_json = array_to_json (v_fields);
	v_formheader = 'NEW FORM';
	

   --  Control NULL's
	v_fields_json := COALESCE(v_fields_json, '{}');
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_formheader := COALESCE(v_formheader, '{}');
	  
--    Return
    RETURN ('{"status":"Accepted", "message":{"priority":0, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"form":{"headerText":"'||v_formheader||'"},"data":{"fields":' || v_fields_json || '}'||
			'}'||
	    '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
