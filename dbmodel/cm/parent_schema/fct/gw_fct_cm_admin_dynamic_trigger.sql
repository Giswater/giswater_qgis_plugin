/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3388

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_admin_dynamic_trigger(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
SELECT gw_fct_cm_admin_dynamic_trigger($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
"data":{"parameters":{"parentTable":"element", "action":"INSERT", }}}$$)::json;

SELECT gw_fct_cm_admin_dynamic_trigger($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{
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
v_prev_search_path TEXT;

BEGIN

	-- Save current search_path
	v_prev_search_path := current_setting('search_path');

	SET search_path = "cm", public;

	v_origin_table :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'tgTableName';
	v_sql_feature :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'sqlFeature';

	v_json_data :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'jsonData';

	v_action :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'action';

	v_update_where :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'updateWhere';


	DROP TABLE IF EXISTS temp_new_vals;

	-- for 1-level-dependencies (non-restricted tables to basic users)
	v_sql = '
	CREATE TABLE temp_new_vals AS 
	WITH aaa AS (
		WITH aux AS (
	   		SELECT 1 AS id, '||QUOTE_LITERAL(v_json_data)||'::json AS js
		), json_vals AS (
			SELECT key AS col, replace(value::text, ''"'', '''''''') AS val
			FROM aux,
			jsonb_each(aux.js::jsonb) AS keys_values
		)
		SELECT v.*, NULL as data_type, NULL AS exec_order 
		FROM json_vals v
	), bbb AS (
		SELECT distinct
		    v.relname AS vista,
		    t.relname AS table_name,
		    n_table.nspname AS table_schema,
		    a.attname AS columna
		FROM pg_rewrite r
		JOIN pg_class v ON r.ev_class = v.oid
		JOIN pg_depend d ON r.oid = d.objid
		JOIN pg_class t ON d.refobjid = t.oid
		JOIN pg_namespace n_table ON t.relnamespace = n_table.oid
		JOIN pg_attribute a ON a.attrelid = t.oid
		JOIN pg_namespace n ON v.relnamespace = n.oid
		WHERE v.relname = '||quote_literal(v_origin_table)||'
	    AND a.attnum > 0
	    AND NOT a.attisdropped
	    AND t.relkind = ''r''
 		AND n.nspname = '||quote_literal(current_schema)||'
	)
	SELECT b.table_name, b.table_schema, a.* FROM aaa a JOIN bbb b ON a.col = b.columna;
	';

	EXECUTE v_sql;

	-- discard non-updatable tables from INSERT/UPDATE statement
	DELETE FROM temp_new_vals WHERE table_name ILIKE '%selector_%' OR table_name ILIKE 'cat_%';
	DELETE FROM temp_new_vals WHERE table_name IS NULL;
	
	DELETE FROM temp_new_vals 
	WHERE table_name in ('om_campaign_x_node', 'om_campaign_x_arc', 'om_campaign_x_connec', 'om_campaign_lot');


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

		-- EXCLUDE PRIMARY KEY FROM UPDATE
		DELETE FROM temp_new_vals t
		WHERE EXISTS (
			SELECT 1
			FROM pg_constraint con
			JOIN pg_class c ON c.oid = con.conrelid
			JOIN pg_namespace n ON n.oid = c.relnamespace
			JOIN pg_attribute a ON a.attrelid = con.conrelid AND a.attnum = ANY(con.conkey)
			WHERE con.contype = 'p'
			AND n.nspname = t.table_schema
			AND c.relname = t.table_name
			AND a.attname = t.col
		);

		v_sql = 'SELECT CONCAT(
		''UPDATE '', table_schema, ''.'', table_name, '' SET '', string_agg(concat(col, '' = '', val, data_type), '', ''), '' WHERE '', '||quote_literal(v_update_where)||') AS trigger_sentence 
		FROM temp_new_vals GROUP BY table_schema, table_name, exec_order ORDER BY exec_order';

	ELSEIF v_action = 'DELETE' THEN

		v_sql = 'SELECT CONCAT(
		''DELETE FROM '', table_schema, ''.'', table_name, '' WHERE '', '||quote_literal(v_update_where)||') AS trigger_sentence 
		FROM temp_new_vals GROUP BY table_schema, table_name, exec_order ORDER BY exec_order';

	END IF;

	v_sql = REPLACE(REPLACE(replace(v_sql, E'\n', ''), E'\t', ''), E'\r', '');

	-- built statements of the necessary tables ordered by exec_order

	FOR v_rec_sentence IN EXECUTE v_sql
	LOOP

		EXECUTE v_rec_sentence.trigger_sentence;

	END LOOP;

	v_result := json_build_object('insert', '{}', 'update', '{}', 'delete', '{}');

	DROP TABLE IF EXISTS temp_new_vals;

	-- Restore previous search_path before returning
	PERFORM set_config('search_path', v_prev_search_path, true);
RETURN v_result;

EXCEPTION WHEN OTHERS THEN
	-- Ensure restoration on error
	PERFORM set_config('search_path', v_prev_search_path, true);
	RAISE;
END;
$function$
;
