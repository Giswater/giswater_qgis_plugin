/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2568

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getcatalog(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_api_getcatalog($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{"formName":"upsert_catalog_arc", "tabName":"data", "editable":"TRUE"},
"feature":{"tableName":"ve_arc_pipe", "idName":"arc_id", "id":"2001", "feature_type":"PIPE"},
"data":{"fields":{"matcat_id":"PVC", "pnom":"16", "dnom":"160"}}}$$)
*/


DECLARE
	api_version text;
	v_schemaname text;
	formTabs text;
	v_device integer;
	v_formname varchar;
	v_tabname varchar;
	fields_array json[];
	fields json;   
	field json;
	query_result character varying;
	query_result_ids json;
	query_result_names json;
	v_parameter text;
	v_query_result text;
	v_filter_values json;
	v_text text[];
	i integer;
	v_json_field json;
	v_field text;
	v_value text;
	text text;
	v_matcat text;
	v_feature_type text;
	v_featurecat_id text;
	v_project_type text;

BEGIN
-- 	Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	SELECT wsoftware INTO v_project_type FROM version LIMIT 1;

--  	get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO api_version;

--	getting input data 
	v_device := ((p_data ->>'client')::json->>'device')::text;
	v_formname :=  ((p_data ->>'form')::json->>'formName')::text;
	v_tabname :=  ((p_data ->>'form')::json->>'tabName')::text;
	v_feature_type :=  (((p_data ->>'feature')::json->>'feature_type')::text);
	v_matcat :=  ((((p_data ->>'data')::json->>'fields')::json)->>'matcat_id');

	-- Set 1st parent field
	fields_array[1] := gw_fct_json_object_set_key(fields_array[1], 'selectedId', v_matcat);

-- 	Calling function to build form fields
	SELECT gw_api_get_formfields(v_formname, 'catalog', v_tabname, v_feature_type, null, null, null, 'INSERT',v_matcat, v_device)
		INTO fields_array;

--	Remove selectedId form fields
	FOREACH field in ARRAY fields_array
	LOOP
		fields_array[(field->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(field->>'orderby')::INT], 'selectedId', ''::text);
	END LOOP;
	
	-- Set featuretype_id
	IF v_project_type = 'WS' THEN
	
		IF v_formname='upsert_catalog_arc' THEN
			v_featurecat_id = 'arctype_id';
		ELSIF v_formname='upsert_catalog_node' THEN
			v_featurecat_id = 'nodetype_id';
		ELSIF v_formname='upsert_catalog_connec' THEN
			v_featurecat_id = 'connectype_id';
		END IF;
		
	ELSIF v_project_type = 'UD' THEN
	
		IF v_formname='upsert_catalog_arc' THEN
			v_featurecat_id = 'arc_type';
		ELSIF v_formname='upsert_catalog_node' THEN
			v_featurecat_id = 'node_type';
		ELSIF v_formname='upsert_catalog_connec' THEN
			v_featurecat_id = 'connec_type';
		END IF;
		
	END IF;
	
--	Setting the catalog 'id' value  (hard coded for catalogs, fixed objective field as id on 4th position
	IF v_formname='upsert_catalog_arc' OR v_formname='upsert_catalog_node' OR v_formname='upsert_catalog_connec' THEN

		--  get querytext
		EXECUTE 'SELECT dv_querytext FROM config_api_form_fields WHERE formname = $1 and column_id=''id'''
			INTO v_query_result
			USING v_formname;

		--  add filters
		v_filter_values := (p_data ->> 'data')::json->> 'fields';
		SELECT array_agg(row_to_json(a)) into v_text from json_each(v_filter_values) a;
		i=1;
		IF v_text IS NOT NULL THEN
			FOREACH text IN ARRAY v_text
			LOOP
				
				-- Get field and value from json
				SELECT v_text [i] into v_json_field;
				IF v_json_field ->> 'value' != '' THEN
					
					v_field:= (SELECT (v_json_field ->> 'key')) ;
					v_value:= (SELECT (v_json_field ->> 'value')) ;
				END IF;
				
				i=i+1;
				
				-- creating the query_text (it's supossed that with field id there is no creation of query text filter)
				IF v_value IS NOT NULL AND v_field != 'id' THEN
					v_query_result := v_query_result || ' AND '||v_field||'::text = '|| quote_literal(v_value) ||'::text';
				END IF;
				
			END LOOP;
			
			IF v_project_type = 'WS' THEN
				v_query_result := v_query_result || ' AND '|| quote_ident(v_featurecat_id) ||' = '|| quote_literal(v_feature_type) ||'';
			ELSIF v_project_type = 'UD' THEN
				v_query_result := v_query_result || ' AND '|| quote_ident(v_featurecat_id) ||' = '|| quote_literal(v_feature_type) ||' OR '|| quote_ident(v_featurecat_id) ||' = null';
			END IF;
			
		END IF;
		raise notice 'v_query_result %', v_query_result;

		EXECUTE 'SELECT array_to_json(array_agg(id)) FROM (' || (v_query_result) || ') a'
			INTO query_result_ids;

		EXECUTE 'SELECT array_to_json(array_agg(idval)) FROM (' || (v_query_result) || ') a'
		INTO query_result_names;

		-- Set new values json of id's (it's supossed that id is on 4th position on json)	
		fields_array[4] := gw_fct_json_object_set_key(fields_array[4], 'queryText', v_query_result);
		fields_array[4] := gw_fct_json_object_set_key(fields_array[4], 'comboIds', query_result_ids);
		fields_array[4] := gw_fct_json_object_set_key(fields_array[4], 'comboNames', query_result_names);
		fields_array[4] := gw_fct_json_object_set_key(fields_array[4], 'selectedId',  query_result_ids -> 0);	
		
	END IF;
  
--     	Convert to json
	fields := array_to_json(fields_array);

--     	Control nulls
	fields := COALESCE(fields, '[]');
	api_version := COALESCE(api_version, '[]');

--      Return
	RETURN ('{"status":"Accepted", "apiVersion":'||api_version||
	      ',"body":{"message":{"priority":1, "text":"This is a test message"}'||
		      ',"form":'||(p_data->>'form')::json||
		      ',"feature":'||(p_data->>'feature')::json||
		      ',"data":{"fields":' || fields ||'}}'||		     
	       '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

