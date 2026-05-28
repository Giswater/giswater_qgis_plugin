/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3010

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setcatalog(p_data json)
  RETURNS json AS
$BODY$

/* example

-- directs
feature:

SELECT SCHEMA_NAME.gw_fct_setcatalog($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{"formName":"new_workcat", "tabName":"data", "editable":"TRUE"},
"feature":{"tableName":"ve_node", "idName":"node_id", "id":"2001", "feature_type":"JUNCTION"},
"data":{"fields":{"builtdate": "2020-05-05", "id": "21XY1111", "descript":"test 54", "link":null,"workid_key1": "132", "workid_key2": "vdf"}}}$$);


SELECT SCHEMA_NAME.gw_fct_setcatalog($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{"formName":"new_workcat"},
"feature":{"tableName":"ve_node"},
"data":{"fields":{"builtdate": "2020-05-05", "id": "21XY1111", "descript":"test 54", "link":null,"workid_key1": "132", "workid_key2": "vdf"}}}$$);



SELECT SCHEMA_NAME.gw_fct_setcatalog($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{"formName":"new_mapzone", "tabName":"data", "editable":"TRUE"},
"feature":{"tableName":"ve_node_flowmeter", "idName":"node_id", "id":"2001", "feature_type":"FLOWMETER"},
"data":{"fields":{"mapzoneType": "DMA", "name": "test", "dma_id":"126", "expl_id":"1","stylesheet":null}}}$$)


*/

DECLARE

v_catname text;
v_fields json;
v_columntype character varying;
v_querytext varchar;
v_columntype_id character varying;
v_text text[];
v_jsonfield json;
rec_text text;
i integer=1;
v_field text;
v_value text;
v_schemaname text;
v_newid text;
v_first boolean;
v_pkey text;
v_formname text;
v_feature_table text;
v_dvquery text;
v_returnfields json;
v_columnname text;
v_checkpkey integer;
v_expl integer;
v_id_x_expl integer;
v_mapzone_config json;
v_idname text;
v_id text;
v_dma_id integer;
v_presszone_id text;

v_version text;
v_error_context text;
v_audit_result text;
v_level integer;
v_status text;
v_message text;

BEGIN


	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	--  get version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get input parameters:
	v_formname := json_extract_path_text (p_data,'form','formName')::text;
	v_fields := json_extract_path_text (p_data,'data','fields')::json;
	v_feature_table := json_extract_path_text (p_data,'feature','tableName')::text;
	v_idname := json_extract_path_text (p_data,'feature','idName')::text;
	v_id := json_extract_path_text (p_data,'feature','id')::text;

	--set cat table to upate
	IF v_formname = 'new_workcat' THEN
		v_catname = 'cat_work';
	ELSIF v_formname = 'new_mapzone' THEN
		v_catname = lower(json_extract_path_text(v_fields, 'mapzoneType'))::text;
		v_expl = json_extract_path_text(v_fields, 'expl_id')::integer;
		v_dma_id := json_extract_path_text (v_fields,'dma_id')::integer;
		v_presszone_id := json_extract_path_text (v_fields,'v_presszone_id')::text;

		IF v_catname IS NULL THEN
			EXECUTE 'SELECT lower(graph_delimiter) FROM cat_feature JOIN cat_feature_node USING (id)
			WHERE graph_delimiter NOT IN (''MINSECTOR'', ''NONE'', ''CHECKVALVE'') AND child_layer = '||quote_literal(v_feature_table)||';'
			INTO v_catname;
		END IF;
		--get addmapzone config
		EXECUTE 'SELECT json_extract_path_text (value::json,'||quote_literal(LOWER(v_catname))||')::json FROM config_param_system WHERE parameter = ''admin_addmapzone'''
		INTO v_mapzone_config;
		--remove unnecessary key from insert json
		v_fields = v_fields::jsonb -'mapzoneType';
	END IF;

	--find catalog primary key
	EXECUTE 'SELECT a.attname FROM  pg_index i
	JOIN   pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
	WHERE  i.indrelid = '||quote_literal(v_catname)||'::regclass
	AND    i.indisprimary'
	INTO v_pkey;

	--replace 'id' with correct id name
	v_fields = replace(v_fields::text,'"id"',concat('"',v_pkey,'"'));

	select array_agg(row_to_json(a)) into v_text from json_each(v_fields)a;

	-- query text, step1
	v_querytext := 'INSERT INTO ' || quote_ident(v_catname) ||' (';

	-- query text, step2
	i=1;
	v_first=FALSE;
	FOREACH rec_text IN ARRAY v_text
	LOOP
		SELECT v_text [i] into v_jsonfield;
		v_field:= (SELECT (v_jsonfield ->> 'key')) ;
		v_value := (SELECT (v_jsonfield ->> 'value')) ; -- getting v_value in order to prevent null values

		IF v_value !='null' OR v_value !='NULL' OR v_value IS NOT NULL THEN

			--building the query text
			IF i=1 OR v_first IS FALSE THEN
				v_querytext := concat (v_querytext, v_field);
				v_first = TRUE;
			ELSIF i>1 THEN
				v_querytext := concat (v_querytext, ', ', quote_ident(v_field));
			END IF;

		END IF;
		i=i+1;
	END LOOP;

	-- query text, step3
	v_querytext := concat (v_querytext, ') VALUES (');

	-- query text, step4
	i=1;
	v_first=FALSE;
	FOREACH rec_text IN ARRAY v_text
	LOOP
		SELECT v_text [i] into v_jsonfield;
		v_field:= (SELECT (v_jsonfield ->> 'key')) ;
		v_value := (SELECT (v_jsonfield ->> 'value')) ;

		IF v_field = v_pkey THEN
			EXECUTE 'SELECT 1 FROM '||v_catname||' WHERE '||quote_literal(v_value)||' IN (SELECT '||v_pkey||'::text FROM  '||v_catname||')'
			INTO v_checkpkey;
			IF v_checkpkey = 1 THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3166", "function":"3010","parameters":{"value":"'||v_value||'"}, "is_process":true}}$$);'
				INTO v_audit_result;
			END IF;
		END IF;
		-- Get column type
		EXECUTE 'SELECT udt_name::regtype as data_type  FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(v_catname) || ' AND column_name = $2'
			USING v_schemaname, v_field
			INTO v_columntype;

		-- control column_type
		IF v_columntype IS NULL THEN
			v_columntype='text';
		END IF;

		-- Handle array types - format value with curly braces if it's an array
		IF v_columntype LIKE '%[]' AND v_value IS NOT NULL AND v_value != '' THEN
			-- Replace [ with { and ] with } for array input
			IF v_value LIKE '[%' THEN
				v_value := replace(replace(v_value, '[', '{'), ']', '}');
			ELSIF v_value NOT LIKE '{%}' THEN
				v_value := '{' || v_value || '}';
			END IF;
		END IF;

		IF v_value !='null' OR v_value !='NULL' THEN

			--building the query text
			IF i=1 OR v_first IS FALSE THEN
				v_querytext := concat (v_querytext, quote_literal(v_value),'::',v_columntype);
				v_first = TRUE;
			ELSIF i>1 THEN
				v_querytext := concat (v_querytext, ', ',  quote_literal(v_value),'::',v_columntype);
			END IF;

		END IF;
		i=i+1;

	END LOOP;

	-- query text, final step
	v_querytext := concat ((v_querytext),' )RETURNING ',quote_ident(v_pkey));

	-- execute query text
	EXECUTE v_querytext INTO v_newid;

	--find query that populates form combo
	IF v_formname = 'new_workcat' THEN
		EXECUTE 'SELECT dv_querytext,columnname FROM config_form_fields WHERE dv_querytext ILIKE ''%FROM '||v_catname||'%'' 
		AND formname = '||quote_literal(v_feature_table)||' AND columnname = ''workcat_id'''
		INTO v_dvquery, v_columnname;
	ELSE
		--change mapzone id depending on expl_id
		IF v_dma_id IS NOT NULL THEN
			EXECUTE 'UPDATE '||v_catname||' SET '||v_pkey||' = '||v_dma_id||' WHERE '||v_pkey||' = '||v_newid||';';
			v_newid = v_dma_id;
		ELSIF v_presszone_id IS NOT NULL THEN
			EXECUTE 'UPDATE '||v_catname||' SET '||v_pkey||' = '||v_presszone_id||' WHERE '||v_pkey||' = '||v_newid||';';
			v_newid = v_presszone_id;
		ELSIF json_extract_path_text (v_mapzone_config,'idXExpl')::boolean IS TRUE THEN
			EXECUTE 'SELECT max('||v_pkey||'::integer) + 1  FROM '||v_catname||' WHERE expl_id='||v_expl||' and '||v_pkey||'!='||v_newid||'' INTO v_id_x_expl;
			EXECUTE 'SELECT 1 FROM '||v_catname||' WHERE '||v_catname||'_id = '||v_id_x_expl||'' INTO v_checkpkey;
			IF v_checkpkey IS NULL THEN
				EXECUTE 'UPDATE '||v_catname||' SET '||v_pkey||' = '||v_id_x_expl||' WHERE '||v_pkey||' = '||v_newid||';';
				v_newid = v_id_x_expl;
			END IF;
		END IF;
		--update other fields defined as setUpdate
		IF json_extract_path_text(v_mapzone_config,'setUpdate')::text IS NOT NULL THEN
			EXECUTE 'UPDATE '||v_feature_table||' SET '||json_extract_path_text(v_mapzone_config,'setUpdate')::text||' 
			FROM '||v_catname||' WHERE '||v_catname||'.'||v_pkey||' = '||v_newid||' AND '||v_idname||'='||quote_literal(v_id)||';';
		END IF;

		--find query that populates form combo
		EXECUTE 'SELECT dv_querytext,columnname FROM config_form_fields WHERE dv_querytext ILIKE ''%FROM '||v_catname||'%'' 
		AND formname = '||quote_literal(v_feature_table)||''
		INTO v_dvquery, v_columnname;
	END IF;

	EXECUTE 'SELECT json_build_object (''widgetname'', '||quote_literal(concat('tab_data_',v_columnname))||',''comboIds'',id,''comboNames'',idval, ''selectedId'','||quote_literal(v_newid)||') as fields
	FROM (SELECT array_agg(id::text)as id, array_agg(idval) as idval FROM 
	('||v_dvquery||') a ORDER BY id) b'
	INTO v_returnfields;


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
	RETURN gw_fct_json_create_return( ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'",'||
	'"body": {"form":{},"feature":{},'||
	'"data": {"fields":['||v_returnfields||']}}}')::json, 3010, null, null, null);


	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


