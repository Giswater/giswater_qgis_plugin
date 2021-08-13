-- Function: ws_sample35.gw_fct_getlist(json)

-- DROP FUNCTION ws_sample35.gw_fct_getlist(json);

CREATE OR REPLACE FUNCTION ws_sample35.gw_fct_getlist(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:

TOC
----------
-- attribute table using custom filters
SELECT ws_sample35.gw_fct_getlist($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"v_edit_man_pipe", "idName":"arc_id"},
"data":{"filterFields":{"arccat_id":"PVC160-PN10", "limit":5},"filterFeatureField":{"arc_id":"2001"},
        "pageInfo":{"orderBy":"arc_id", "orderType":"DESC", "currentPage":3}}}$$)

-- attribute table using canvas filter
SELECT ws_sample35.gw_fct_getlist($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"ve_arc_pipe", "idName":"arc_id"},"filterFeatureField":{"arc_id":"2001"},
"data":{"canvasExtend":{"canvascheck":true, "x1coord":12131313,"y1coord":12131313,"x2coord":12131313,"y2coord":12131313},
        "pageInfo":{"orderBy":"arc_id", "orderType":"DESC", "currentPage":1}}}$$)

VISIT
----------
-- Visit -> visites
SELECT ws_sample35.gw_fct_getlist($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"om_visit_x_arc" ,"idName":"id"},
"data":{"filterFields":{"arc_id":2001, "limit":10},"filterFeatureField":{"arc_id":"2001"},
    "pageInfo":{"orderBy":"visit_id", "orderType":"DESC", "offsset":"10", "currentPage":null}}}$$)


-- Visit -> events
SELECT ws_sample35.gw_fct_getlist($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"v_ui_om_event" ,"idName":"id"},
"data":{"filterFields":{"visit_id":232, "limit":10},"filterFeatureField":{"arc_id":"2001"},
    "pageInfo":{"orderBy":"tstamp", "orderType":"DESC", "currentPage":3}}}$$)

-- Visit -> files
-- first call
SELECT ws_sample35.gw_fct_getlist($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"om_visit_file"},
"data":{"filterFields":{},
	"pageInfo":{}}}$$)

-- not first call
SELECT ws_sample35.gw_fct_getlist($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"om_visit_file"},
"data":{"filterFields":{"filetype":"jpg","limit":15, "visit_id":1135},"filterFeatureField":{"arc_id":"2001"},
	"pageInfo":{"orderBy":"tstamp", "orderType":"DESC", "currentPage":3}}}$$)

SELECT ws_sample35.gw_fct_getlist($$
{"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"featureType":"visit","tableName":"ve_visit_arc_insp","idname":"visit_id","id":10002},
"form":{"tabData":{"active":false}, "tabFiles":{"active":true}},
"data":{"relatedFeature":{"type":"arc"},
	"pageInfo":{"orderBy":"tstamp", "orderType":"DESC", "currentPage":3},
	"filterFields":{"filetype":"doc","limit":10,"visit_id":"10002"}}}$$)


FEATURE FORMS
-------------
-- Arc -> elements
SELECT ws_sample35.gw_fct_getlist($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"v_ui_element_x_arc", "idName":"id"},
"data":{"filterFields":{"arc_id":"2001"},
    "pageInfo":{"orderBy":"element_id", "orderType":"DESC", "currentPage":3}}}$$)


MANAGER FORMS
-------------
-- Lots
SELECT ws_sample35.gw_fct_getlist($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"om_visit_lot"},
"data":{"filterFields":{"limit":10},
	"pageInfo":{"currentPage":null}}}$$)
*/


DECLARE

v_version text;
v_filter_fields  json[];
v_footer_fields json[];
v_filter_feature json;
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
v_listclass text;
v_sign text;
v_data json;
v_default json;
v_listtype text;
v_isattribute boolean;
v_attribute_filter text;
v_audit_result text;
v_status text;
v_level integer;
v_message text;
v_value_type text;
v_widgetname text;
BEGIN

	-- Set search path to local schema
    SET search_path = "ws_sample35", public;
    v_schemaname := 'ws_sample35';

	--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

	-- fix diferent ways to say null on client
	p_data = REPLACE (p_data::text, '"NULL"', 'null');
	p_data = REPLACE (p_data::text, '"null"', 'null');
	p_data = REPLACE (p_data::text, '""', 'null');
    p_data = REPLACE (p_data::text, '''''', 'null');

    SELECT epsg INTO v_srid FROM sys_version ORDER BY id DESC LIMIT 1;

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
	v_offset := ((p_data ->> 'data')::json->> 'pageInfo')::json->>'offset';
	v_filter_feature := (p_data ->> 'data')::json->> 'filterFeatureField';
	v_isattribute := (p_data ->> 'data')::json->> 'isAttribute';
	v_widgetname := (p_data ->> 'form')::json->> 'widgetname';

	IF v_tabname IS NULL THEN
		v_tabname = 'data';
	END IF;

	-- control nulls
	IF v_tablename IS NULL THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3156", "function":"2592","debug_msg":"tableName"}}$$);'INTO v_audit_result;
	END IF;

	RAISE NOTICE 'gw_fct_getlist - Init Values: v_tablename %  v_filter_values  % v_filter_feature %', v_tablename, v_filter_values, v_filter_feature;


	-- setting value default for filter fields
	IF v_filter_values::text IS NULL OR v_filter_values::text = '{}' THEN

		v_data = '{"client":{"device":4, "infoType":1, "lang":"ES"},"data":{"formName": "'||v_tablename||'"}}';

		SELECT gw_fct_getfiltervaluesvdef(v_data) INTO v_filter_values;

		RAISE NOTICE 'gw_fct_getlist - Init Values setted by default %', v_filter_values;

	END IF;

--  Create filter if is attribute table list
----------------------------
	IF v_isattribute THEN
		v_attribute_filter = ' AND listtype = ''attributeTable''';
	ELSE
		v_attribute_filter = '';
	END IF;

--  Creating the list fields
----------------------------
	-- control not existing table
	IF v_tablename IN (SELECT table_name FROM information_schema.tables WHERE table_schema = v_schemaname) THEN

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
		EXECUTE concat('SELECT query_text, vdefault, listtype FROM config_form_list WHERE listname = $1 AND device = $2', v_attribute_filter)
			INTO v_query_result, v_default, v_listtype
			USING v_tablename, v_device;

		-- if v_device is not configured on config_form_list table
		IF v_query_result IS NULL THEN
			EXECUTE concat('SELECT query_text, vdefault, listtype FROM config_form_list WHERE listname = $1 LIMIT 1', v_attribute_filter)
				INTO v_query_result, v_default, v_listtype
				USING v_tablename;
		END IF;

		-- if v_tablename is not configured on config_form_list table
		IF v_query_result IS NULL THEN
			v_query_result = 'SELECT * FROM '||v_tablename||' WHERE '||v_idname||' IS NOT NULL ';
		END IF;

	ELSE
		--  get querytext
		EXECUTE concat('SELECT query_text, vdefault, listtype FROM config_form_list WHERE listname = $1 AND device = $2', v_attribute_filter)
			INTO v_query_result, v_default, v_listtype
			USING v_tablename, v_device;

		-- if v_device is not configured on config_form_list table
		IF v_query_result IS NULL THEN
			EXECUTE concat('SELECT query_text, vdefault, listtype FROM config_form_list WHERE listname = $1 LIMIT 1', v_attribute_filter)
				INTO v_query_result, v_default, v_listtype
				USING v_tablename;
		END IF;
	END IF;

	--  add filters (fields)
	SELECT array_agg(row_to_json(a)) into v_text from json_each(v_filter_values) a;

	IF v_text IS NOT NULL THEN
		FOREACH text IN ARRAY v_text
		LOOP
			-- Get field and value from json
			SELECT v_text [i] into v_json_field;
			v_field:= (SELECT (v_json_field ->> 'key')) ;
			v_value:= (SELECT (v_json_field ->> 'value')) ;

			-- Getting the sign of the filter
			IF v_value::json->>'filterSign' is not null THEN
				v_sign = v_value::json->>'filterSign';
				v_value = v_value::json->>'value';
				IF upper(v_sign) IN ('LIKE', 'ILIKE') THEN
					v_value = '''%'||v_value||'%''';
				END IF;
			ELSE
				IF v_listtype = 'attributeTable' THEN
					v_sign = 'ILIKE';
				ELSIF v_sign IS NULL THEN
					v_sign = '=';
				END IF;
			END IF;

			i=i+1;

			raise notice 'v_field % v_value %', v_field, v_value;


			-- creating the query_text
			IF v_value IS NOT NULL AND v_field != 'limit' THEN
				v_query_result := v_query_result || ' AND '||v_field||'::text '||v_sign||' '||v_value ||'::text';

			ELSIF v_field='limit' THEN
				v_query_result := v_query_result;
				v_limit := v_value;
			END IF;
		END LOOP;
	END IF;
	raise notice '00 -> %',v_query_result;
	-- add feature filter
	SELECT array_agg(row_to_json(a)) into v_text from json_each(v_filter_feature) a;
	IF v_text IS NOT NULL THEN
		FOREACH text IN ARRAY v_text
		LOOP
			-- Get field and value from json
			SELECT v_text [1] into v_json_field;
			v_field:= (SELECT (v_json_field ->> 'key')) ;
			v_value:= (SELECT (v_json_field ->> 'value')) ;

			-- creating the query_text
			v_query_result := v_query_result || ' AND '||v_field||'::text = '||quote_literal(v_value) ||'::text';
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

	IF v_orderby IS NULL THEN
		v_orderby = v_default->>'orderBy';
		v_ordertype = v_default->>'orderType';
	END IF;


	IF v_orderby IS NOT NULL THEN
		v_query_result := v_query_result || ' ORDER BY '||v_orderby;
	END IF;

	-- adding ordertype
	IF v_ordertype IS NOT NULL THEN
		v_query_result := v_query_result ||' '||v_ordertype;
	END IF;
	-- calculating last page
	IF v_limit IS NULL THEN
		v_limit = 10;
	END IF;

	EXECUTE 'SELECT count(*)/'||v_limit||' FROM (' || v_query_result || ') a'
		INTO v_lastpage;

	-- add limit
	IF v_device != 4 THEN
	    v_query_result := v_query_result || ' LIMIT '|| v_limit;
	END IF;

	-- calculating current page
	IF v_currentpage IS NULL THEN
		v_currentpage=1;
	END IF;

	-- add offset
	IF v_offset IS NULL THEN
		v_offset := (v_currentpage-1)*v_limit;
	END IF;
	IF v_offset IS NOT NULL THEN
		v_query_result := v_query_result || ' OFFSET '|| v_offset;
	END IF;

	RAISE NOTICE '--- gw_fct_getlist - Query Result: % ---', v_query_result;

	-- Execute query result
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || v_query_result || ') a'
		INTO v_result_list;

	RAISE NOTICE '--- gw_fct_getlist - List: % ---', v_result_list;

	-- building pageinfo
	v_pageinfo := json_build_object('orderBy',v_orderby, 'orderType', v_ordertype, 'currentPage', v_currentpage, 'lastPage', v_lastpage);
raise notice 'AAA - % --- %',v_tablename, v_tabname;
	-- getting filter fields
	SELECT gw_fct_getformfields(v_tablename, 'form_list_header', v_tabname, null, null, null, null,'INSERT', null, v_device, null)
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

				-- set value (from v_value)
				IF v_filter_fields[i] IS NOT NULL THEN

					IF (v_filter_fields[i]->>'widgettype')='combo' THEN
						v_filter_fields[i] := gw_fct_json_object_set_key(v_filter_fields[i], 'selectedId', v_value);
					ELSE
						v_filter_fields[i] := gw_fct_json_object_set_key(v_filter_fields[i], 'value', v_value);
					END IF;
				END IF;

				--raise notice 'v_value % v_filter_fields %', v_value, v_filter_fields[i];

				i=i+1;

			END LOOP;
		END IF;

	-- adding the widget of list
	v_i = cardinality(v_filter_fields) ;

	EXECUTE 'SELECT listclass FROM config_form_list WHERE listname = $1 LIMIT 1'
		INTO v_listclass
		USING v_tablename;

	-- setting new element
	IF v_device = 4 THEN
		v_filter_fields[v_i+1] := json_build_object('widgetname',v_widgetname,'widgettype',v_listclass,'datatype','icon','columnname','fileList','orderby', v_i+3, 'position','body', 'value', v_result_list);
	ELSE
		v_filter_fields[v_i+1] := json_build_object('type',v_listclass,'dataType','icon','name','fileList','orderby', v_i+3, 'position','body', 'value', v_result_list);
	END IF;

	-- converting to json
	v_fields_json = array_to_json (v_filter_fields);

	-- Control NULL's
	v_version := COALESCE(v_version, '{}');
	v_featuretype := COALESCE(v_featuretype, '');
	v_tablename := COALESCE(v_tablename, '');
	v_idname := COALESCE(v_idname, '');
	v_fields_json := COALESCE(v_fields_json, '{}');
	v_pageinfo := COALESCE(v_pageinfo, '{}');


	IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
        v_message = 'Process done successfully';
    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;

	-- Return
    RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":'||v_version||
             ',"body":{"form":{}'||
		     ',"feature":{"featureType":"' || v_featuretype || '","tableName":"' || v_tablename ||'","idName":"'|| v_idname ||'"}'||
		     ',"data":{"fields":' || v_fields_json ||
			     ',"pageInfo":' || v_pageinfo ||
			     '}'||
		       '}'||
	    '}')::json;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
    RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION ws_sample35.gw_fct_getlist(json)
  OWNER TO role_admin;
GRANT EXECUTE ON FUNCTION ws_sample35.gw_fct_getlist(json) TO public;
GRANT EXECUTE ON FUNCTION ws_sample35.gw_fct_getlist(json) TO role_admin;
GRANT EXECUTE ON FUNCTION ws_sample35.gw_fct_getlist(json) TO role_basic;
