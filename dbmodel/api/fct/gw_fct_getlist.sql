/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION ws_sample.gw_api_getlist(p_data json)  RETURNS json AS
$BODY$

/*EXAMPLE:

TOC
----------
-- attribute table using custom filters
SELECT ws_sample.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_edit_man_pipe", "idName":"arc_id"},
"data":{"filterFields":{"arccat_id":"PVC160-PN10", "limit":5},
    "pageInfo":{"orderby":"arc_id", "orderType":"DESC", "limit":"10", "offsset":"10", "pageNumber":3}}}$$)

-- attribute table using canvas filter
SELECT ws_sample.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"ve_arc_pipe", "idName":"arc_id"},
"data":{"filterFields":{"arccat_id":null, "limit":null},
    "canvasExtend":{"x1coord":12131313,"y1coord":12131313,"x2coord":12131313,"y2coord":12131313},
    "pageInfo":{"orderby":"arc_id", "orderType":"DESC", "offsset":"10", "pageNumber":3}}}$$)

VISIT
----------
-- Visit -> events
SELECT ws_sample.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_ui_om_event" ,"idName":"id"},
"data":{"filterFields":{"visit_id":232, "limit":10},
    "canvasExtend":{},
    "pageInfo":{"orderby":"tstamp", "orderType":"DESC", "offsset":"10", "pageNumber":3}}}$$)

-- Visit -> files
SELECT ws_sample.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_ui_om_visit_x_doc", "idName":"id"},
"data":{"filterFields":{"visit_id":232, "limit":10},
    "pageInfo":{"orderby":"doc_id", "orderType":"DESC", "offsset":"10", "pageNumber":3}}}$$)


FEATURE FORMS
-------------
-- Arc -> elements
SELECT ws_sample.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_ui_element_x_arc", "idName":"id"},
"data":{"filterFields":{"arc_id":"2001"},
    "pageInfo":{"orderby":"element_id", "orderType":"DESC", "offsset":"10", "pageNumber":3}}}$$)


MANAGER FORMS
-------------
-- Lots
SELECT ws_sample.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{"buttonName":"lotManager"},
"feature":{},
"data":{"filterFields":{"limit":10},
	"pageInfo":{"pageNumber":1}}}$$)
*/


DECLARE
	v_apiversion text;
	v_filter_fields  json[];
	v_filter_fields_json json;
	v_filter_values  json;
	v_schemaname text;
	aux_json json;
	v_result_list json;
	v_query_result text;
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
	v_action_column json;
	v_tablename text;
	v_formactions json;
	v_x1 float;
	v_y1 float;
	v_x2 float;
	v_y2 float;
	v_canvas public.geometry;
	v_the_geom text;
	v_canvasextend json;
	v_srid integer;
	v_i integer;
	v_buttonname text;
	v_layermanager json;
	v_featuretype text;
	
BEGIN

-- Set search path to local schema
    SET search_path = "ws_sample", public;
    v_schemaname := 'ws_sample';
  
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;

    SELECT epsg INTO v_srid FROM version LIMIT 1;

-- Get input parameters:
	v_device := (p_data ->> 'client')::json->> 'device';
	v_infotype := (p_data ->> 'client')::json->> 'infoType';
	v_tabname := (p_data ->> 'form')::json->> 'tabName';
	v_buttonname := (p_data ->> 'form')::json->> 'buttonName';
	v_tablename := (p_data ->> 'feature')::json->> 'tableName';
	v_canvasextend := (p_data ->> 'data')::json->> 'canvasExtend';

	IF v_tabname IS NULL THEN
		v_tabname = 'data';
	END IF;

	-- control nulls
	IF v_tablename IS NULL AND v_buttonname IS NULL THEN
		RAISE EXCEPTION 'bad configured';
	END IF;

	IF v_tablename IS NULL AND v_buttonname IS NOT NULL THEN
		v_tablename = (SELECT (buttonoptions->>'tableName') FROM config_api_button WHERE idval = v_buttonname);
		v_featuretype = (SELECT (buttonoptions->>'featureType') FROM config_api_button WHERE idval = v_buttonname);
		v_layermanager = (SELECT (buttonoptions->>'layerManager') FROM config_api_button WHERE idval = v_buttonname);
	END IF;

-- getting the list of filters fields
-------------------------------------
   	SELECT gw_api_get_formfields(v_tablename, 'listfilter', v_tabname, null, null, null, null,'INSERT', null, v_device)
		INTO v_filter_fields;

	-- adding the right widgets, TODO
		--identifing the dimension of array
		--v_i = cardinality(v_filter_fields) ;

		-- setting new wigdets
		--v_filter_fields[v_i+1] := gw_fct_createwidgetjson('text', 'spacer', 'spacer', 'string', '', FALSE, '');
		--v_filter_fields[v_i+2] := gw_fct_createwidgetjson('Limit', 'limit', 'text', 'string', null, FALSE, '');
		--v_filter_fields[v_i+3] := gw_fct_createwidgetjson('Canvas extend', 'extend', 'check', 'string', 'TRUE', FALSE, '');

	-- converting to json
	v_filter_fields_json = array_to_json (v_filter_fields);

	/* getting value defaults for filters fields, TODO: Use widgettype to put on the audit_cat_param_user the name of the filter
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


--  Creating the list fields
----------------------------
	-- Get idname column
	EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
		INTO v_idname
		USING v_tablename;
        
	-- For views it suposse pk is the first column
	IF v_idname ISNULL THEN
		EXECUTE 'SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
			AND t.relname = $1 
			AND s.nspname = $2
			ORDER BY a.attnum LIMIT 1'
			INTO v_idname
			USING v_tablename, v_schemaname;
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
            USING v_schemaname, v_tablename, v_idname
            INTO v_column_type;

        -- Getting geometry column
        EXECUTE 'SELECT attname FROM pg_attribute a        
            JOIN pg_class t on a.attrelid = t.oid
            JOIN pg_namespace s on t.relnamespace = s.oid
            WHERE a.attnum > 0 
            AND NOT a.attisdropped
            AND t.relname = $1
            AND s.nspname = $2
            AND left (pg_catalog.format_type(a.atttypid, a.atttypmod), 8)=''geometry''
            ORDER BY a.attnum' 
            USING v_tablename, v_schemaname
            INTO v_the_geom;

	--  get querytext
	EXECUTE 'SELECT query_text, action_fields FROM config_api_list WHERE tablename = $1 AND device = $2'
		INTO v_query_result, v_action_column
		USING v_tablename, v_device;

	-- if v_device is not configured on config_api_list table
	IF v_query_result IS NULL THEN
		EXECUTE 'SELECT query_text, action_fields  FROM config_api_list WHERE tablename = $1 LIMIT 1'
			INTO v_query_result, v_action_column
			USING v_tablename;
	END IF;

	-- if v_tablename is not configured on config_api_list table
	IF v_query_result IS NULL THEN
		v_query_result = 'SELECT * FROM '||v_tablename||' WHERE '||v_idname||' IS NOT NULL ';
	END IF;

	--  add filters
	v_filter_values := (p_data ->> 'data')::json->> 'filterFields';
	SELECT array_agg(row_to_json(a)) into v_text from json_each(v_filter_values) a;

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
	IF v_the_geom IS NOT NULL AND v_canvasextend IS NOT NULL THEN
		
		-- getting coordinates values
		v_x1 = v_canvasextend->>'x1coord';
		v_y1 = v_canvasextend->>'y1coord';
		v_x2 = v_canvasextend->>'x2coord';
		v_y2 = v_canvasextend->>'y2coord';	

		-- adding on the query text the extend filter
		v_query_result := v_query_result || ' AND ST_dwithin ( '|| v_tablename || '.' || v_the_geom || ',' || 
		'ST_MakePolygon(ST_GeomFromText(''LINESTRING ('||v_x1||' '||v_y1||', '||v_x1||' '||v_y2||', '||v_x2||' '||v_y2||', '||v_x2||' '||v_y1||', '||v_x1||' '||v_y1||')'','||v_srid||')),1)';
		
	END IF;

	-- add orderby
	v_orderby := ((p_data ->> 'data')::json->> 'pageInfo')::json->>'orderby';
	IF v_orderby IS NOT NULL THEN
		v_query_result := v_query_result || ' ORDER BY '||v_orderby;
	END IF;

	v_ordertype := ((p_data ->> 'data')::json->> 'pageInfo')::json->>'orderType';
	IF v_ordertype IS NOT NULL THEN
		v_query_result := v_query_result ||' '||v_ordertype;
	END IF;

	-- add linit
	IF v_limit IS NOT NULL THEN
		v_query_result := v_query_result || ' LIMIT '|| v_limit;
	END IF;

	-- add offset
	v_offset := ((p_data ->> 'data')::json->> 'pageInfo')::json->>'offset';
	IF v_offset IS NOT NULL THEN
		v_query_result := v_query_result || ' LIMIT '|| v_offset;
	END IF;

	-- Execute query result
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || v_query_result || ') a'
		INTO v_result_list;

--    Control NULL's
	v_featuretype := COALESCE(v_featuretype, '{}');
	v_layermanager := COALESCE(v_layermanager, '{}');
	v_filter_fields := COALESCE(v_filter_fields, '{}');
	v_result_list := COALESCE(v_result_list, '{}');
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_action_column := COALESCE(v_action_column, '{}');

--    Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"form":{}'||
		     ',"feature":{"featureType":"' || v_featuretype || '","tableName":"' || v_tablename ||'","idName":"'|| v_idname ||'","actionFields":'||v_action_column||'}'||
		     ',"data":{"layerManager":' || v_layermanager ||
			     ',"filterFields":' || v_filter_fields_json ||
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
