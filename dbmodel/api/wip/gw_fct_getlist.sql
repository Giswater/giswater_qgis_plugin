/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION ws_sample.gw_api_getlist(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
-- ToC list with custom filters
SELECT ws_sample.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_edit_man_pipe"},
"data":{"filterFields":{"arccat_id":"PVC160-PN16", "limit":5},
    "pageInfo":{"orderby":"arc_id", "orderType":"DESC", "limit":"10", "offsset":"10", "pageNumber":3}}}$$)


-- ToC list with custom filters and canvas
SELECT ws_sample.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_edit_man_pipe"},
"data":{"filterFields":{"arccat_id":"PVC160-PN16", "limit":5},
    "canvasExtend":{"x1coord":12131313,"y1coord":12131313,"x2coord":12131313,"y2coord":12131313},
    "pageInfo":{"orderby":"arc_id", "orderType":"DESC", "limit":"10", "offsset":"10", "pageNumber":3}}}$$)


*/

DECLARE
	v_apiversion text;
	v_filter_fields  json[];
	v_filter_fields_json json;
	v_filter_values  json;
	v_schema_name text;
	aux_json json;
	v_result_list json;
	v_query_result text;
	v_tablename varchar;
	v_id  varchar;
	v_device integer;
	v_infotype integer;
	v_idname varchar;
	v_column_type varchar;
	v_field varchar;
	v_value text;
	v_orderby varchar;
	v_ordertype varchar;
	v_limit integer;
	v_offset integer;
	v_text text[];
	v_json_field json;
	text text;
	i integer=1;
	v_tabname text;
	v_action_column_index json;
	v_formname text;
	
BEGIN

-- Set search path to local schema
    SET search_path = "ws_sample", public;
    v_schema_name := 'ws_sample';

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;


--  Creating the list fields
----------------------------
	-- Get input parameters:
	v_device := (p_data ->> 'client')::json->> 'device';
	v_infotype := (p_data ->> 'client')::json->> 'infoType';
	v_tabname := (p_data ->> 'form')::json->> 'tabName';
	v_formname := (p_data ->> 'feature')::json->> 'tableName';
	
	-- Get idname column
	EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
		INTO v_idname
		USING v_formname;
        
	-- For views it suposse pk is the first column
	IF v_idname ISNULL THEN
		EXECUTE 'SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
			AND t.relname = $1 
			AND s.nspname = $2
			ORDER BY a.attnum LIMIT 1'
			INTO v_idname
			USING v_formname, v_schema_name;
	END IF;

	-- Get column type
	EXECUTE 'SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) FROM pg_attribute a
	    JOIN pg_class t on a.attrelid = t.oid
	    JOIN pg_namespace s on t.relnamespace = s.oid
	    WHERE a.attnum > 0 
	    AND NOT a.attisdropped
	    AND a.attname = $3
	    AND t.relname = $2 
	    AND s.nspname = $1
	    ORDER BY a.attnum'
            USING v_schema_name, v_formname, v_idname
            INTO v_column_type;


	-- getting the list of filters fields
	SELECT gw_api_get_formfields(v_formname, 'list', null, null, null, null, null,'INSERT', null, v_device)
		INTO v_filter_fields;

	v_filter_fields_json = array_to_json (v_filter_fields);

	raise notice ' v_filter_fields_json %', v_filter_fields_json;

	
	/* getting value defaults for filters fields
	To do: Use widgettype to put on the audit_cat_param_user the name of the filter
	FOREACH aux_json IN ARRAY fields_array 
        LOOP           
        	--  Index
		array_index := array_index + 1;
		field_value :=null;

		v_vdefault:=quote_ident(aux_json->>'widgettype');
		EXECUTE 'SELECT value::text FROM audit_cat_param_user JOIN config_param_user ON audit_cat_param_user.id=parameter 
			 WHERE cur_user=current_user AND feature_field_id='||quote_literal(v_vdefault)
			 INTO field_value;
        END LOOP;  
        */

--  Creating the list value
---------------------------
	--  get querytext
	EXECUTE 'SELECT query_text, action_fields FROM config_api_list WHERE tablename = $1 AND device = $2'
		INTO v_query_result, v_action_column_index
		USING v_formname, v_device;

	-- if v_device is not configured on config_api_list table
	IF v_query_result IS NULL THEN
		EXECUTE 'SELECT query_text, action_fields  FROM config_api_list WHERE tablename = $1 LIMIT 1'
			INTO v_query_result, v_action_column_index
			USING v_formname;
	END IF;

	-- if v_formname is not configured on config_api_list table
	IF v_query_result IS NULL THEN
		v_query_result = 'SELECT * FROM '||v_formname||' WHERE '||v_idname||' IS NOT NULL ';
	END IF;

	--  add filters
	v_filter_values := (p_data ->> 'data')::json->> 'filterFields';
	SELECT array_agg(row_to_json(a)) into v_text from json_each(v_filter_values) a;

	i=1;

	IF v_text IS NOT NULL THEN

		FOREACH text IN ARRAY v_text
		LOOP
			-- Get field and value from json
			SELECT v_text [i] into v_json_field;
			v_field:= (SELECT (v_json_field ->> 'key')) ;
			v_value:= (SELECT (v_json_field ->> 'value')) ;
			i=i+1;
			-- creating the query_text
			IF v_value IS NOT NULL AND v_field != 'limit' THEN
				v_query_result := v_query_result || ' AND '||v_field||'::text = '|| quote_literal(v_value) ||'::text';
			ELSIF v_field='limit' THEN
				v_query_result := v_query_result;
				v_limit := v_value;
			END IF;
		END LOOP;
	END IF;

	-- add extend filter
	-- to do (working with extend parameter of inputdaa)

	-- add orderby
	v_orderby := ((p_data ->> 'data')::json->> 'pageInfo')::json->>'orderby';
	IF v_orderby IS NOT NULL THEN
		v_query_result := v_query_result || ' ORDER BY '||v_orderby;
	END IF;

	RAISE NOTICE 'v_query_result %', v_query_result;

	v_ordertype := ((p_data ->> 'data')::json->> 'pageInfo')::json->>'orderType';
	IF v_ordertype IS NOT NULL THEN
		v_query_result := v_query_result ||' '||v_ordertype;
	END IF;

	RAISE NOTICE 'v_query_result %', v_query_result;

	-- add limit
	-- comment due we use limit as a parameter from filters not from the other body of json
	--IF v_limit IS NULL THEN 
	--	v_limit := ((p_data ->> 'data')::json->> 'pageInfo')::json->>'limit';
	--END IF;
	
	IF v_limit IS NOT NULL THEN
		v_query_result := v_query_result || ' LIMIT '|| v_limit;
	END IF;
	RAISE NOTICE 'v_query_result %', v_query_result;

	-- add offset
	v_offset := ((p_data ->> 'data')::json->> 'pageInfo')::json->>'offset';
	IF v_offset IS NOT NULL THEN
		v_query_result := v_query_result || ' LIMIT '|| v_offset;
	END IF;

	-- Execute query result
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || v_query_result || ') a'
		INTO v_result_list;

	raise notice 'v_filter_fields  %', v_filter_fields ;
	raise notice 'v_result_list % ', v_result_list;

--    Control NULL's
	v_filter_fields := COALESCE(v_filter_fields, '{}');
	v_result_list := COALESCE(v_result_list, '{}');
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_action_column_index := COALESCE(v_action_column_index, '{}');

--    Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"form":{"formName":"", "formHeaderText":"", "formBodyText":""'|| 
				',"formTabs":[{"tabName":"","tabHeaderText":"","tabBodyText":""}]'||
				',"formActions":[{"actionName":"actionZoom","actionTooltip":"Zoom"}'||
					       ',{"actionName":"actionLink","actionTooltip":"Link"}'||
					       ',{"actionName":"actionDelete","actionTooltip":"Delete"}]}'||
			',"feature":{"tableName":"' || v_formname ||'","idName":"'|| v_idname ||'","actionFields":'||v_action_column_index||'}'||
			',"data":{"filterFields":' || v_filter_fields_json ||
				',"listValues":' || v_result_list ||'}}'||
	    '}')::json;
       

--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION ws_sample.gw_api_getlist(json)
  OWNER TO geoadmin;
