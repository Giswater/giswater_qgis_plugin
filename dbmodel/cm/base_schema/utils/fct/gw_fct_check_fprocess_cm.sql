/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3428

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_check_fprocess_SCHEMA_NAME(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
DECLARE
	v_function_fid integer;
	v_check_fid integer;

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

BEGIN

	SET search_path = 'SCHEMA_NAME', public;
	v_schemaname := 'SCHEMA_NAME';

    v_check_fid := (p_data->'data'->'parameters'->>'checkFid')::integer;
    v_function_fid := (p_data->'data'->'parameters'->>'functionFid')::integer;


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

    -- manage query count
	RAISE NOTICE 'hola v_check_fid %', v_check_fid;
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
		v_text_aux = 'There is ';
		v_process_except_msg =
		concat(
			substring(split_part(v_process_except_msg, ' ', 1) FROM 1 FOR length(split_part(v_process_except_msg, ' ', 1)) - 1),
			' ',
			substring(v_process_except_msg FROM length(split_part(v_process_except_msg, ' ', 1)) + 2)
		);
	ELSIF v_count > 1 THEN
		v_text_aux = 'There are ';
	END IF;
	RAISE NOTICE 'v_count %', v_count;
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


	RETURN '{}';

END;
$function$
;

