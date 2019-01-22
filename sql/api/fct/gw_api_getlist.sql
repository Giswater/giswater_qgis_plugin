/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2592

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getlist(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:

TOC
----------
-- attribute table using custom filters
SELECT SCHEMA_NAME.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_edit_man_pipe", "idName":"arc_id"},
"data":{"filterFields":{"arccat_id":"PVC160-PN10", "limit":5},
        "pageInfo":{"orderBy":"arc_id", "orderType":"DESC", "currentPage":3}}}$$)

-- attribute table using canvas filter
SELECT SCHEMA_NAME.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"ve_arc_pipe", "idName":"arc_id"},
"data":{"canvasExtend":{"canvascheck":true, "x1coord":12131313,"y1coord":12131313,"x2coord":12131313,"y2coord":12131313},
        "pageInfo":{"orderBy":"arc_id", "orderType":"DESC", "currentPage":1}}}$$)

VISIT
----------
-- Visit -> visites
SELECT SCHEMA_NAME.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"om_visit_x_arc" ,"idName":"id"},
"data":{"filterFields":{"arc_id":2001, "limit":10},
    "pageInfo":{"orderBy":"visit_id", "orderType":"DESC", "offsset":"10", "currentPage":null}}}$$)


-- Visit -> events
SELECT SCHEMA_NAME.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_ui_om_event" ,"idName":"id"},
"data":{"filterFields":{"visit_id":232, "limit":10},
    "pageInfo":{"orderBy":"tstamp", "orderType":"DESC", "currentPage":3}}}$$)

-- Visit -> files
-- first call
SELECT SCHEMA_NAME.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"om_visit_file"},
"data":{"filterFields":{},
	"pageInfo":{}}}$$)
	
-- not first call
SELECT SCHEMA_NAME.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"om_visit_file"},
"data":{"filterFields":{"filetype":"jpg","limit":15, "visit_id":1135},
	"pageInfo":{"orderBy":"tstamp", "orderType":"DESC", "currentPage":3}}}$$)

SELECT SCHEMA_NAME.gw_api_getlist($$
{"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"featureType":"visit","tableName":"ve_visit_arc_insp","idname":"visit_id","id":10002},
"form":{"tabData":{"active":false}, "tabFiles":{"active":true}},
"data":{"relatedFeature":{"type":"arc"},
	"pageInfo":{"orderBy":"tstamp", "orderType":"DESC", "currentPage":3},
	"filterFields":{"filetype":"doc","limit":10,"visit_id":"10002"}}}$$)


FEATURE FORMS
-------------
-- Arc -> elements
SELECT SCHEMA_NAME.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_ui_element_x_arc", "idName":"id"},
"data":{"filterFields":{"arc_id":"2001"},
    "pageInfo":{"orderBy":"element_id", "orderType":"DESC", "currentPage":3}}}$$)


MANAGER FORMS
-------------
-- Lots
SELECT SCHEMA_NAME.gw_api_getlist($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"om_visit_lot"},
"data":{"filterFields":{"limit":10},
	"pageInfo":{"currentPage":null}}}$$)
*/


DECLARE
	v_apiversion text;
	v_filter_fields  json[];
	v_fields_json json;
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
	v_currentpage integer;
	v_lastpage integer;
	v_text text[];
	v_json_field json;
	text text;
	i integer=1;
	v_tabname text;
	v_tablename text;
	v_formactions json;
	v_x1 float;
	v_y1 float;
	v_x2 float;
	v_y2 float;
	v_canvas public.geometry;
	v_the_geom text;
	v_canvasextend json;
	v_canvascheck boolean;
	v_srid integer;
	v_i integer;
	v_buttonname text;
	v_featuretype text;
	v_pageinfo json;
	v_vdefault text;
BEGIN

-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    v_schemaname := 'SCHEMA_NAME';
  
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
	v_featuretype:= (p_data ->> 'feature')::json->> 'featureType';
	v_canvasextend := (p_data ->> 'data')::json->> 'canvasExtend';
	v_canvascheck := ((p_data ->> 'data')::json->> 'canvasExtend')::json->>'canvasCheck';
	v_orderby := ((p_data ->> 'data')::json->> 'pageInfo')::json->>'orderBy';
	v_filter_values := (p_data ->> 'data')::json->> 'filterFields';
	v_ordertype := ((p_data ->> 'data')::json->> 'pageInfo')::json->>'orderType';
	v_currentpage := ((p_data ->> 'data')::json->> 'pageInfo')::json->>'currentPage';

	raise notice 'v_filter_values %', v_filter_values;

	IF v_tabname IS NULL THEN
		v_tabname = 'data';
	END IF;

	-- control nulls
	IF v_tablename IS NULL THEN
		RAISE EXCEPTION 'The config table is bad configured. v_tablename is null';
	END IF;

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
	EXECUTE 'SELECT query_text FROM config_api_list WHERE tablename = $1 AND device = $2'
		INTO v_query_result
		USING v_tablename, v_device;

	-- if v_device is not configured on config_api_list table
	IF v_query_result IS NULL THEN
		EXECUTE 'SELECT query_text FROM config_api_list WHERE tablename = $1 LIMIT 1'
			INTO v_query_result
			USING v_tablename;
	END IF;

	-- if v_tablename is not configured on config_api_list table
	IF v_query_result IS NULL THEN
		v_query_result = 'SELECT * FROM '||v_tablename||' WHERE '||v_idname||' IS NOT NULL ';
	END IF;

	--  add filters
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
	IF v_orderby IS NOT NULL THEN
		v_query_result := v_query_result || ' ORDER BY '||v_orderby;

		-- adding ordertype
		IF v_ordertype IS NOT NULL THEN
			v_query_result := v_query_result ||' '||v_ordertype;
		END IF;
		
	END IF;

	IF v_limit IS NULL THEN
		v_limit = 10;
	END IF;
	
	-- calculating last page
	EXECUTE 'SELECT count(*)/'||v_limit||' FROM (' || v_query_result || ') a'
		INTO v_lastpage;
	
	-- add limit
	v_query_result := v_query_result || ' LIMIT '|| v_limit;

	-- calculating current page
	IF v_currentpage IS NULL THEN 
		v_currentpage=1;
	END IF;
	
	v_offset := (v_currentpage-1)*v_limit;

	-- add offset
	IF v_offset IS NOT NULL THEN
		v_query_result := v_query_result || ' OFFSET '|| v_offset;
	END IF;

	RAISE NOTICE '--- QUERY LIST % ---', v_query_result;

	-- Execute query result
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || v_query_result || ') a'
		INTO v_result_list;

	RAISE NOTICE '--- RESULT LIST % ---', v_result_list;

	-- building pageinfo
	v_pageinfo := json_build_object('orderBy',v_orderby, 'orderType', v_ordertype, 'currentPage', v_currentpage, 'lastPage', v_lastpage);

   
-- getting the list of filters fields
-------------------------------------
   	SELECT gw_api_get_formfields(v_tablename, 'listfilter', v_tabname, null, null, null, null,'INSERT', null, v_device)
		INTO v_filter_fields;

	--  setting values of filter fields
	SELECT array_agg(row_to_json(a)) into v_text from json_each(v_filter_values) a;
	i=1;
	IF v_text IS NOT NULL THEN
		FOREACH text IN ARRAY v_text
		LOOP
			-- get value
			SELECT v_text [i] into v_json_field;
			v_value:= (SELECT (v_json_field ->> 'value')) ;

			-- get value (vdefault)
			IF v_value IS NULL THEN
				v_vdefault:=quote_ident(v_filter_fields[i]->>'column_id');
				IF v_vdefault IS NOT NULL THEN
					EXECUTE 'SELECT value::text FROM audit_cat_param_user JOIN config_param_user ON audit_cat_param_user.id=parameter 
						WHERE cur_user=current_user AND feature_field_id='||quote_literal(v_vdefault)
						INTO v_value;
				END IF;
			END IF;

			-- set value (from v_value)
			IF v_filter_fields[i] IS NOT NULL THEN
				
				IF (v_filter_fields[i]->>'widgettype')='combo' THEN
					v_filter_fields[i] := gw_fct_json_object_set_key(v_filter_fields[i], 'selectedId', v_value);
				ELSE
					v_filter_fields[i] := gw_fct_json_object_set_key(v_filter_fields[i], 'value', v_value);
				END IF;
			END IF;

			raise notice 'v_value % v_filter_fields %', v_value, v_filter_fields[i];

			i=i+1;			
		END LOOP;
	END IF;

	raise notice 'v_filter_fields %', v_filter_fields;
	
	-- adding common filter fields
	-- adding spacer
	IF v_device=9 THEN
		-- getting cardinality
		v_i = cardinality(v_filter_fields) ;
		-- setting new element
		v_filter_fields[v_i+1] := gw_fct_createwidgetjson('text', 'spacer', 'spacer', 'string', null, FALSE, '');
	END IF;

	-- adding line text of limit
	IF v_limit IS NULL THEN 
		v_limit=20; 
	END IF;

	-- getting cardinality
	v_i = cardinality(v_filter_fields);
	-- setting new element
	v_filter_fields[v_i+1] := gw_fct_createwidgetjson('Limit', 'limit', 'text', 'integer', null, FALSE, v_limit::text);

	-- adding check of canvas extend
	IF v_the_geom IS NOT NULL THEN
		IF v_canvascheck IS NULL THEN 
			v_canvascheck = FALSE; 
		END IF;
		-- getting cardinality
		v_i = cardinality(v_filter_fields);
		-- setting new element
		v_filter_fields[v_i+2] := gw_fct_createwidgetjson('Canvas extend', 'canvasextend', 'check', 'boolean', null, FALSE, v_canvascheck::text);
	END IF;

	-- adding the widget of list
	-- getting cardinality
	v_i = cardinality(v_filter_fields) ;

	-- setting new element
	IF v_device =9 THEN
		v_filter_fields[v_i+1] := json_build_object('widgettype','iconList','datatype','icon','column_id','fileList','orderby', v_i+3, 'position','body', 'value', v_result_list);
	ELSE
		v_filter_fields[v_i+1] := json_build_object('type','iconList','dataType','icon','name','fileList','orderby', v_i+3, 'position','body', 'value', v_result_list);
	END IF;

	raise notice 'v_filter_fields %', v_filter_fields;


	-- converting to json
	v_fields_json = array_to_json (v_filter_fields);

--    Control NULL's
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_featuretype := COALESCE(v_featuretype, '');
	v_tablename := COALESCE(v_tablename, '');
	v_idname := COALESCE(v_idname, '');	
	v_fields_json := COALESCE(v_fields_json, '{}');
	v_pageinfo := COALESCE(v_pageinfo, '{}');

--    Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"form":{}'||
		     ',"feature":{"featureType":"' || v_featuretype || '","tableName":"' || v_tablename ||'","idName":"'|| v_idname ||'"}'||
		     ',"data":{"fields":' || v_fields_json ||
			     ',"pageInfo":' || v_pageinfo ||
			     '}'||
		       '}'||
	    '}')::json;
       
--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



