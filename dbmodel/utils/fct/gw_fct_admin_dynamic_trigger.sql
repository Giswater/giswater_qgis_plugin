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
v_json_new_data JSON;
v_json_old_data JSON;
v_parent_layer TEXT;
v_feature_type TEXT;

BEGIN

	SET search_path = "SCHEMA_NAME", public;
	
	v_origin_table :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'originTable';
	v_column_pkey := ((p_data ->> 'data')::json->>'parameters')::json->> 'pkeyColumn';
	v_value_pkey :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'pkeyValue';

	v_json_new_data :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'jsonNewData';
	v_json_old_data :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'jsonOldData';

	v_action :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'action';

	SELECT parent_layer, lower(feature_type) INTO v_parent_layer, v_feature_type FROM cat_feature 
	WHERE child_layer = v_origin_table;

	DROP TABLE IF EXISTS temp_new_vals;

    CREATE TEMP TABLE temp_new_vals AS 
	WITH aaa AS (
   		WITH aux AS (
   			SELECT 1 AS id, v_json_new_data AS js
   		), json_vals AS (
			SELECT key AS col, replace(value::text, '"', '''') AS val
			FROM aux,
			jsonb_each(aux.js::jsonb) AS keys_values
		), mapping_cols AS (	
			select c.column_name AS col, c.table_name
			FROM information_schema.view_column_usage c
			JOIN pg_views v 
			    ON c.view_schema = v.schemaname 
			    AND c.view_name = v.viewname
			WHERE v.viewname = v_origin_table
			AND table_schema = CURRENT_SCHEMA 
		)
		SELECT v.*, c.table_name, NULL AS exec_order 
		FROM json_vals v LEFT JOIN mapping_cols c USING (col)
	), bbb AS (
	select c.column_name AS col, c.table_name FROM information_schema.view_column_usage c
	JOIN pg_views v ON c.view_schema = v.schemaname AND c.view_name = v.viewname
	WHERE v.viewname = v_parent_layer AND table_schema = CURRENT_SCHEMA
	)
	SELECT CASE WHEN aaa.table_name = v_parent_layer THEN bbb.table_name ELSE aaa.table_name END AS table_name, 
	aaa.col, aaa.val, aaa.exec_order FROM aaa LEFT JOIN bbb USING (col);



	-- clean table
	DELETE FROM temp_new_vals WHERE table_name ILIKE 'selector_%' OR table_name ILIKE 'cat_%';


	-- prepare table
	UPDATE temp_new_vals SET val = st_astext(st_geomfromgeojson(val)) WHERE col = 'the_geom' AND val <> 'null';
	UPDATE temp_new_vals SET val = quote_literal(val) WHERE col = 'the_geom';

	UPDATE temp_new_vals SET exec_order = 1 WHERE table_name = v_feature_type;
	UPDATE temp_new_vals SET exec_order = 2 WHERE exec_order is null;

	IF v_action = 'INSERT' THEN

	    v_sql = 'SELECT concat(
	    ''INSERT INTO '', table_name, '' ('', string_agg(col, '', ''), '') 
		VALUES ('', string_agg(val, '', ''), '')''
		) AS insert_sentence FROM temp_new_vals GROUP BY table_name, exec_order ORDER BY exec_order';
	
		v_sql = REPLACE(REPLACE(replace(v_sql, E'\n', ''), E'\t', ''), E'\r', '');
	
		
	    EXECUTE v_sql INTO v_rec_insert;
			
	   	SELECT json_agg(row_to_json(v_rec_insert)) INTO v_json_insert;
	   
	    FOR v_rec_sentence IN EXECUTE v_sql
	    LOOP
		    
	        EXECUTE v_rec_sentence.insert_sentence;
	      	       
	    END LOOP;
	   
	ELSIF v_action = 'UPDATE' THEN

		v_sql = 'SELECT CONCAT(
		''UPDATE '', table_name, '' SET '', string_agg(concat(col, '' = '', val), '', ''), '' WHERE '', '||quote_literal(v_column_pkey)||', '' = '', '||quote_literal(quote_literal(v_value_pkey))||') AS update_sentence 
		FROM temp_new_vals GROUP BY table_name, exec_order ORDER BY exec_order';
		
		v_sql = REPLACE(REPLACE(replace(v_sql, E'\n', ''), E'\t', ''), E'\r', '');
	
		EXECUTE v_sql INTO v_rec_update;
	
		FOR v_rec_sentence IN EXECUTE v_sql
		LOOP
			
			EXECUTE v_rec_sentence.update_sentence;
		
		END LOOP;
	
		-- keep results
		SELECT json_agg(row_to_json(v_rec_update)) INTO v_json_update;

	END IF;

	DROP TABLE IF EXISTS temp_new_vals;

	v_result := json_build_object('insert', v_json_insert, 'update', v_json_update);

RETURN v_result;

END;
$function$
;

