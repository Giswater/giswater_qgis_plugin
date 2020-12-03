/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
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
"feature":{"tableName":"v_edit_node", "idName":"node_id", "id":"2001", "feature_type":"JUNCTION"},
"data":{"fields":{"builtdate": "2020-05-05", "id": "21XY1111", "descript":"test 54", "link":null,"workid_key1": "132", "workid_key2": "vdf"}}}$$);


SELECT SCHEMA_NAME.gw_fct_setcatalog($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{"formName":"new_workcat"},
"feature":{"tableName":"v_edit_node"},
"data":{"fields":{"builtdate": "2020-05-05", "id": "21XY1111", "descript":"test 54", "link":null,"workid_key1": "132", "workid_key2": "vdf"}}}$$);



SELECT SCHEMA_NAME.gw_fct_setcatalog($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{"formName":"new_mapzone", "tabName":"data", "editable":"TRUE"},
"feature":{"tableName":"v_edit_node", "idName":"node_id", "id":"2001", "feature_type":"JUNCTION"},
"data":{"fields":{"mapzoneType": "DMA", "name": "test", "id":"12", "expl_id":"1","stylesheet":null}}}$$)


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
	SELECT giswater INTO v_version FROM sys_version;		
      
	-- Get input parameters:
	v_formname := json_extract_path_text (p_data,'form','formName')::text;
	v_fields := json_extract_path_text (p_data,'data','fields')::json;
	v_feature_table := json_extract_path_text (p_data,'feature','tableName')::text;

	--set cat table to upate
	IF v_formname = 'new_workcat' THEN
		v_catname = 'cat_work';
	ELSIF v_formname = 'new_mapzone' THEN
		v_catname = lower(json_extract_path_text(v_fields, 'mapzoneType'))::text;
		IF v_catname IS NULL THEN
			EXECUTE 'SELECT lower(graf_delimiter) FROM cat_feature JOIN cat_feature_node USING (id)
			WHERE child_layer = '||quote_literal(v_feature_table)||';'
			INTO v_catname;
		END IF;
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
	raise notice 'v_querytext1,%',v_querytext;
	
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
				"data":{"message":"3166", "function":"3010","debug_msg":"'||v_value||'"}}$$);'
				INTO v_audit_result;
			END IF;
		END IF;
		-- Get column type
		EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(v_catname) || ' AND column_name = $2'
			USING v_schemaname, v_field
			INTO v_columntype;

		-- control column_type
		IF v_columntype IS NULL THEN
			v_columntype='text';
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
	EXECUTE 'SELECT dv_querytext,columnname FROM config_form_fields WHERE dv_querytext ILIKE ''%FROM '||v_catname||'%'' AND formname = '||quote_literal(v_feature_table)||''
	INTO v_dvquery, v_columnname;

	EXECUTE 'SELECT json_build_object (''widgetname'', '||quote_literal(concat('data_',v_columnname))||',''comboIds'',id,''comboNames'',idval, ''selectedId'','||quote_literal(v_newid)||') as fields
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
	'"data": {"fields":['||v_returnfields||']}}}')::json, 3010);


	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


