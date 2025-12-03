/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3050

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfeaturegeom(p_data json)
  RETURNS json AS
$BODY$

/*
 SELECT SCHEMA_NAME.gw_fct_getfeaturegeom($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"feature_type":"gully", "ids":"[1,2,3,4]"}}$$);
*/

DECLARE
v_return json;
v_version text;
v_feature_type text;
v_ids text;
v_ids_aux text[];
v_id JSON;
v_the_geom text;
v_idname text;
v_geometry json;
fields_array json[];
v_count integer = 0;
v_error_context text;

BEGIN


	-- Search path
	SET search_path = 'SCHEMA_NAME', public;

	v_feature_type = ((p_data ->>'data')::json->>'feature_type');
	v_ids =  ((p_data ->>'data')::json->>'ids');

	v_idname = v_feature_type || '_id';

	v_ids = replace(v_ids, '[', '');
	v_ids = replace(v_ids, ']', '');
	v_ids = replace(v_ids, '''', '');

	SELECT string_to_array(v_ids, ',') into v_ids_aux;


	IF v_feature_type IN ('arc','node','connec', 'gully') THEN
		v_the_geom = 'the_geom';
	ELSE
		EXECUTE 'SELECT attname FROM pg_attribute a        
			JOIN pg_class t on a.attrelid = t.oid
			JOIN pg_namespace s on t.relnamespace = s.oid
			WHERE a.attnum > 0 
			AND nspname = ''SCHEMA_NAME''
			AND NOT a.attisdropped
			AND t.relname = $1
			AND left (pg_catalog.format_type(a.atttypid, a.atttypmod), 8)=''geometry''
			ORDER BY a.attnum
			LIMIT 1'
			INTO v_the_geom
			USING v_feature_type;
	END IF;

	FOR v_id IN SELECT * FROM json_array_elements(array_to_json(v_ids_aux))
	LOOP

		v_id = replace(v_id::text, '"', '');
		v_id = replace(v_id::text, ' ', '');

		IF v_the_geom IS NOT NULL AND v_id IS NOT NULL THEN
			EXECUTE 'SELECT row_to_json(row) FROM (SELECT St_AsText('||quote_ident(v_the_geom)||') FROM '||quote_ident(v_feature_type)||' WHERE '||quote_ident(v_idname)||' = '||quote_nullable(v_id)||')row'
			INTO v_geometry;

			fields_array[v_count] := gw_fct_json_object_set_key(fields_array[v_count], v_id::text, v_geometry);

		END IF;

	END LOOP;

	v_version := COALESCE(v_version, '{}');
	v_return := COALESCE(v_return, '{}');

	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Executed successfully"}, "version":"'||v_version||'"'||
            ',"body":{"form":{}'||
	     ',"data":'||fields_array[0]||''||
	     ',"styles":'||v_return||''||
	'}}')::json;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
