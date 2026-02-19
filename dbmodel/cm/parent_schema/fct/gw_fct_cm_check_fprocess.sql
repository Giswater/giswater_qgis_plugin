/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3428

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_check_fprocess(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_function_fid integer;
	v_check_fid integer;
	v_replace_params jsonb;

	v_count integer;
	v_text_aux text;
	v_process text;
	v_exceptable_id text;
	v_exceptable_catalog text;
	v_querytext text;
	v_graphClass text;

	--
	v_process_name text;
	v_process_except_table text;
	v_process_query_text text;
	v_process_info_msg text;
	v_process_except_msg text;
	v_process_fid integer;
	v_process_except_level integer;

	v_schemaname text;
	v_id integer;
	v_cat varchar;
	v_expl_id integer;
	v_fid integer;
	v_prev_search_path text;
	v_lot_id_array integer[];

BEGIN

	-- Save current search_path and switch to cm (transaction-local)
	v_prev_search_path := current_setting('search_path');
	PERFORM set_config('search_path', 'cm,public', true);
	v_schemaname := 'cm';

    v_check_fid := (p_data->'data'->'parameters'->>'checkFid')::integer;
    v_function_fid := (p_data->'data'->'parameters'->>'functionFid')::integer;
	v_replace_params := (p_data->'data'->'parameters'->>'replaceParams')::json;
	v_lot_id_array := string_to_array((p_data->'data'->'parameters'->>'lot_id_array'), ',')::integer[];

	-- get fprocess data
	SELECT
		fprocess_name,
		except_table,
		query_text,
		info_msg,
		except_msg,
		fid,
		except_level
	INTO
		v_process_name,
		v_process_except_table,
		v_process_query_text,
		v_process_info_msg,
		v_process_except_msg,
		v_process_fid,
		v_process_except_level
	FROM sys_fprocess WHERE fid = v_check_fid;

	-- replace variables (usando COALESCE para evitar NULLs)
	v_exceptable_id = concat(replace (v_process_except_table, 'cm_', ''), '_id');
	v_exceptable_catalog = concat(replace (v_process_except_table, 'cm_', ''), 'cat_id');

	IF v_replace_params IS NOT NULL THEN
		-- SELECT * FROM %table_name% WHERE %feature_column% IN (%feature_ids%) AND %check_column% IS NULL
		v_process_query_text = regexp_replace(v_process_query_text, '%table_name%', v_replace_params->>'table_name', 'gi');
		v_process_query_text = regexp_replace(v_process_query_text, '%feature_column%', v_replace_params->>'feature_column', 'gi');
		v_process_query_text = regexp_replace(v_process_query_text, '%feature_ids%', v_replace_params->>'feature_ids', 'gi');
		v_process_query_text = regexp_replace(v_process_query_text, '%check_column%', v_replace_params->>'check_column', 'gi');

		-- value/s on column '%check_column%' in the '%table_name%' table.
		v_process_except_msg = regexp_replace(v_process_except_msg, '%table_name%', v_replace_params->>'table_name', 'gi');
		v_process_except_msg = regexp_replace(v_process_except_msg, '%feature_column%', v_replace_params->>'feature_column', 'gi');
		v_process_except_msg = regexp_replace(v_process_except_msg, '%feature_ids%', v_replace_params->>'feature_ids', 'gi');
		v_process_except_msg = regexp_replace(v_process_except_msg, '%check_column%', v_replace_params->>'check_column', 'gi');

		-- The '%check_column%' column on '%table_name%' have correct values.
		v_process_info_msg = regexp_replace(v_process_info_msg, '%table_name%', v_replace_params->>'table_name', 'gi');
		v_process_info_msg = regexp_replace(v_process_info_msg, '%feature_column%', v_replace_params->>'feature_column', 'gi');
		v_process_info_msg = regexp_replace(v_process_info_msg, '%feature_ids%', v_replace_params->>'feature_ids', 'gi');
		v_process_info_msg = regexp_replace(v_process_info_msg, '%check_column%', v_replace_params->>'check_column', 'gi');
	END IF;
	
	IF v_lot_id_array IS NOT NULL THEN
		-- Check if the lot_id column exists in the query result
		BEGIN
			EXECUTE 'CREATE TEMP TABLE tmp_lot_check_q AS SELECT * FROM (' || v_process_query_text || ') as qq LIMIT 0;';
			PERFORM 1 FROM information_schema.columns
			WHERE table_schema = (SELECT nspname FROM pg_namespace WHERE oid = pg_my_temp_schema())
			  AND table_name = 'tmp_lot_check_q'
			  AND column_name = 'lot_id';
			IF FOUND THEN
				v_process_query_text := 'SELECT * FROM (' || v_process_query_text || ') q WHERE lot_id = ANY(ARRAY[' || array_to_string(v_lot_id_array, ',') || ']::integer[])';
			END IF;
			EXECUTE 'DROP TABLE IF EXISTS tmp_lot_check_q;';
		EXCEPTION WHEN OTHERS THEN
			EXECUTE 'DROP TABLE IF EXISTS tmp_lot_check_q;';
		END;
	END IF;
    -- manage query count
	IF v_process_query_text ILIKE '%string_agg%' THEN
		EXECUTE 'WITH mec AS ('||v_process_query_text||'),
		b AS (SELECT unnest(string_to_array("string_agg", ''; '')) AS "string_agg" FROM mec)
		SELECT count(*) FROM b'
		INTO v_count;
	ELSE
		EXECUTE 'SELECT count(*) FROM ('||v_process_query_text||')a'
		INTO v_count;
	END IF;

	-- get text variables according to singular/plural values
	IF v_count = 1 THEN
		EXECUTE 'SELECT PARENT_SCHEMA.gw_fct_getmessage($${"data":{"message":"-2", "function":"3428", "is_process":true}}$$)::JSON->>''text''' INTO v_text_aux;
	ELSIF v_count > 1 OR v_count = 0 THEN
		EXECUTE 'SELECT PARENT_SCHEMA.gw_fct_getmessage($${"data":{"message":"-3", "function":"3428", "is_process":true}}$$)::JSON->>''text''' INTO v_text_aux;
	END IF;
	v_text_aux := concat(substring(v_text_aux, 1, 1), lower(substring(v_text_aux, 2, char_length(v_text_aux) -1)));

	-- manage result (audit_check_data)
	IF v_count > 0 AND v_process_except_level > 1 THEN

		IF v_process_except_table IS NULL THEN

			INSERT INTO t_audit_check_data (fid, criticity, result_id, error_message, fcount, cur_user)
			VALUES (v_function_fid, v_process_except_level, v_check_fid, concat(
			CASE WHEN v_process_except_level = 2 THEN 'WARNING-' WHEN v_process_except_level = 3 THEN 'ERROR-' END,
			v_check_fid, ': ', concat(v_text_aux, v_count, ' ', v_process_except_msg)), v_count, current_user);

		ELSE
			INSERT INTO t_audit_check_data (fid, criticity, result_id, error_message, fcount, cur_user)
			VALUES (v_function_fid, v_process_except_level, v_check_fid, concat(
			CASE WHEN v_process_except_level = 2 THEN 'WARNING-' WHEN v_process_except_level = 3 THEN 'ERROR-' END,
			v_check_fid, ' (',v_process_except_table,'): ', concat(v_text_aux, v_count, ' ', v_process_except_msg)), v_count, current_user);

			v_querytext = 'INSERT INTO t_'||v_process_except_table||' ('||v_exceptable_id||', '||v_exceptable_catalog||', 
					expl_id, fid, the_geom, descript)	SELECT '||v_exceptable_id||', '||v_exceptable_catalog||', 
					expl_id, '||v_check_fid||', the_geom, '||quote_literal(v_process_name)||' FROM ('||v_process_query_text||')a';

			EXECUTE v_querytext;

		END IF;

	ELSE
		INSERT INTO t_audit_check_data (fid, criticity, result_id, error_message, fcount, cur_user)
		VALUES (v_function_fid, 1, v_check_fid, concat('INFO: ', v_process_info_msg), 0, current_user);

		IF v_process_except_table IS NOT NULL THEN

			v_querytext = 'INSERT INTO t_'||v_process_except_table||' ('||v_exceptable_id||', '||v_exceptable_catalog||', 
					expl_id, fid, the_geom, descript)	SELECT '||v_exceptable_id||', '||v_exceptable_catalog||', 
					expl_id, '||v_check_fid||', the_geom, '||quote_literal(v_process_name)||' FROM ('||v_process_query_text||')a';

			EXECUTE v_querytext;
		END IF;

	END IF;

	-- Restore previous search_path before returning
	PERFORM set_config('search_path', v_prev_search_path, true);
	RETURN '{}';

EXCEPTION WHEN OTHERS THEN
	-- Ensure restoration on error
	PERFORM set_config('search_path', v_prev_search_path, true);
	RAISE;
END;
$function$
;
