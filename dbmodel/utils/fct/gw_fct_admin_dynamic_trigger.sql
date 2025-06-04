/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3388

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_dynamic_trigger(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
SELECT gw_fct_admin_dynamic_trigger($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
"data":{"parameters":{"parentTable":"element", "action":"INSERT", }}}$$)::json;

SELECT gw_fct_admin_dynamic_trigger($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{
"parameters":{"parentTable":"'||TG_TABLE_SCHEMA||'", "jsonData":'||v_json_data||', "action":"INSERT"}}}$$)

*/


DECLARE

v_origin_table TEXT;
v_parent_table TEXT;
v_json_data JSON;
v_sql TEXT;
v_rec_sentence record;
v_rec_insert record;
v_rec_update record;
v_json_insert JSON;
v_json_update JSON;
v_action TEXT;
v_result JSON;
v_value_pkey TEXT;
v_column_pkey TEXT;
v_parent_layer TEXT;
v_feature_type TEXT;
v_sql_feature TEXT;
v_update_where TEXT;
v_search_schema TEXT;

BEGIN

	SET search_path = "SCHEMA_NAME", public;
	
	v_origin_table :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'tgTableName';
	v_sql_feature :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'sqlFeature';

	v_json_data :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'jsonData';

	v_action :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'action';

	v_update_where :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'updateWhere';


	DROP TABLE IF EXISTS temp_new_vals;

	v_sql = '
    CREATE TABLE temp_new_vals AS 
	WITH aaa AS (
   		WITH aux AS (
   			SELECT 1 AS id, '||QUOTE_LITERAL(v_json_data)||'::json AS js
   		), json_vals AS (
			SELECT key AS col, replace(value::text, ''"'', '''''''') AS val
			FROM aux,
			jsonb_each(aux.js::jsonb) AS keys_values
		), mapping_cols AS (	
			select c.column_name AS col, c.table_name, c.table_schema
			FROM information_schema.view_column_usage c
			JOIN pg_views v ON c.view_schema = v.schemaname AND c.view_name = v.viewname
			WHERE v.viewname = '||quote_literal(v_origin_table)||'
			AND table_schema IN ('||v_search_schema||')
		)
		SELECT v.*, concat(c.table_schema, ''.'', c.table_name) as table_name, NULL AS exec_order 
		FROM json_vals v LEFT JOIN mapping_cols c USING (col)
	), bbb AS (
		select c.column_name AS col,  concat(c.table_schema, ''.'', c.table_name) as table_name FROM information_schema.view_column_usage c
    	JOIN pg_views v ON c.view_schema = v.schemaname AND c.view_name = v.viewname
	WHERE v.viewname = '||quote_literal(v_origin_table)||' AND c.table_schema IN ('||v_search_schema||')
	)
	SELECT DISTINCT CASE WHEN aaa.table_name = '||quote_literal(v_origin_table)||' THEN bbb.table_name ELSE aaa.table_name END AS table_name, 
	aaa.col, aaa.val, null data_type, aaa.exec_order FROM aaa LEFT JOIN bbb USING (col)
	';

	
	EXECUTE v_sql;


	-- discard non-updatable tables from INSERT/UPDATE statement
	DELETE FROM temp_new_vals WHERE table_name ILIKE '%selector_%' OR table_name ILIKE 'cat_%';
	DELETE FROM temp_new_vals WHERE table_name IS NULL;


	-- adjust geometry column
	UPDATE temp_new_vals SET val = replace(val, '''', '"') WHERE col = 'the_geom' AND val <> 'null';
	UPDATE temp_new_vals SET val = quote_literal(st_astext(st_geomfromgeojson(val))) WHERE col = 'the_geom' AND val <> 'null';
	UPDATE temp_new_vals SET data_type = '::geometry' WHERE col = 'the_geom';

	-- adjust array columns	
	UPDATE temp_new_vals SET val = REPLACE(REPLACE(val, '[', '{'), ']', '}') WHERE val ILIKE '[%' AND val ILIKE '%]';
	UPDATE temp_new_vals SET val = concat('''', val, '''') WHERE val ILIKE '{%' AND val ILIKE '%}';
	
	-- set '' to data_type 
	UPDATE temp_new_vals SET data_type = '' WHERE data_type IS NULL;


	-- set execution order of INSERT statements
	UPDATE temp_new_vals SET exec_order = 1 WHERE table_name = v_feature_type;
	UPDATE temp_new_vals SET exec_order = 2 WHERE exec_order is null;


	IF v_action = 'INSERT' THEN

	    v_sql = 'SELECT concat(
	    ''INSERT INTO '', table_name, '' ('', string_agg(col, '', ''), '') 
    	VALUES ('', string_agg(concat(val, data_type), '', ''), '')''
		) AS trigger_sentence FROM temp_new_vals GROUP BY table_name, exec_order ORDER BY exec_order';
	
	ELSEIF v_action = 'UPDATE' THEN

		v_sql = 'SELECT CONCAT(
		''UPDATE '', table_name, '' SET '', string_agg(concat(col, '' = '', val, data_type), '', ''), '' WHERE '', '||quote_literal(v_update_where)||') AS trigger_sentence 
		FROM temp_new_vals GROUP BY table_name, exec_order ORDER BY exec_order';


	ELSEIF v_action = 'DELETE' THEN

		v_sql = 'SELECT CONCAT(
		''DELETE FROM '', table_name, '' WHERE '', '||quote_literal(v_update_where)||') AS trigger_sentence 
		FROM temp_new_vals GROUP BY table_name, exec_order ORDER BY exec_order';

	END IF;
	
	v_sql = REPLACE(REPLACE(replace(v_sql, E'\n', ''), E'\t', ''), E'\r', '');

	-- built statements of the necessary tables ordered by exec_order
	
	FOR v_rec_sentence IN EXECUTE v_sql
	LOOP
		
		EXECUTE v_rec_sentence.trigger_sentence;
				
	END LOOP;
	   
			

	v_result := json_build_object('insert', '{}', 'update', '{}', 'delete', '{}');

RETURN v_result;

END;
$function$
;

