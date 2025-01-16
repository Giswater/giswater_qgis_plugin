-- DROP FUNCTION SCHEMA_NAME.gw_fct_check_fprocess(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_check_fprocess(p_data json)
  RETURNS json AS
$BODY$
/*
select gw_fct_check_fprocess($${"data":{"parameters":{"functionFid": '||v_fid||', "checkFid":"103", "prefixTable": "'||v_edit||'"}}}$$)';

select gw_fct_check_fprocess($${"data":{"parameters":{"functionFid": '||v_fid||', "checkFid":"103", "prefixTable": "'||v_edit||'",
"graphClass":"DMA"}}}$$)';
*/

DECLARE
	v_function_fid integer;
	v_check_fid integer;

	v_rec record;
	v_rec_anl record;
	v_count integer;
	v_geom_type text;
	v_sql text;
	v_text_aux text;
	v_exc_msg text;
	v_iscount boolean;
	v_process text;
	v_exceptable_id text;
	v_exceptable_catalog text;
	v_querytext text;
	v_graphClass text;
BEGIN

	-- get input params
	v_function_fid := (((p_data ->>'data')::json->>'parameters')::json->>'functionFid')::integer;
	v_check_fid := (((p_data ->> 'data')::json->>'parameters')::json->> 'checkFid')::integer;
	v_process := (((p_data ->> 'data')::json->>'parameters')::json->> 'process');
	v_graphClass := (((p_data ->> 'data')::json->>'parameters')::json->> 'graphClass');

	-- get fprocess data
	select * into v_rec from sys_fprocess where fid = v_check_fid;
	v_exceptable_id = concat(replace (v_rec.except_table, 'anl_', ''), '_id');
	v_exceptable_catalog = concat(replace (v_rec.except_table, 'anl_', ''), 'cat_id');

	-- replace graphClass in query_text, info_msg and except_msg: v_graphClass -> dma, dqa, sector, presszone and drainzone.
	v_rec.query_text = replace(v_rec.query_text, 'v_graphClass', v_graphClass);
	v_rec.info_msg = replace(v_rec.info_msg, 'v_graphClass', v_graphClass);
	v_rec.except_msg = replace(v_rec.except_msg, 'v_graphClass', v_graphClass);

	-- manage query count
	if v_rec.query_text ilike '%string_agg%' and v_rec.fid <> 317 then
		execute 'with mec as ('||v_rec.query_text||'),
		b as (select unnest(string_to_array("string_agg", ''; '')) as "string_agg" from mec)
		select count(*) from b'
		into v_count;
	else
		execute 'select count(*) from ('||v_rec.query_text||')a'
		into v_count;
	end if;

	-- get text variables according to singular/plural values
	v_exc_msg = v_rec.except_msg;
	if v_count = 1 then
		v_text_aux = 'There is ';
		v_exc_msg =
		concat(
			substring(split_part(v_rec.except_msg, ' ', 1) FROM 1 FOR length(split_part(v_rec.except_msg, ' ', 1)) - 1),
			' ',
			substring(v_rec.except_msg FROM length(split_part(v_rec.except_msg, ' ', 1)) + 2)
		);
	elsif v_count > 1 then
		v_text_aux = 'There are ';
	end if;

	-- manage result (audit_check_data)
	IF v_count > 0 and v_rec.except_level > 1 then

		IF v_rec.except_table is null then

			INSERT INTO t_audit_check_data (fid, criticity, result_id, error_message, fcount)
			values (v_function_fid, v_rec.except_level, v_check_fid, concat(
			case when v_rec.except_level = 2 then 'WARNING-' when v_rec.except_level = 3 then 'ERROR-' end ,
			v_check_fid, ': ', concat(v_text_aux, v_count, ' ', v_exc_msg)), v_count);

		ELSE
			INSERT INTO t_audit_check_data (fid, criticity, result_id, error_message, fcount)
			values (v_function_fid, v_rec.except_level, v_check_fid, concat(
			case when v_rec.except_level = 2 then 'WARNING-' when v_rec.except_level = 3 then 'ERROR-' end ,
			v_check_fid, ' (',v_rec.except_table,'): ', concat(v_text_aux, v_count, ' ', v_exc_msg)), v_count);

			v_querytext = 'INSERT INTO t_'||v_rec.except_table||' ('||v_exceptable_id||', '||v_exceptable_catalog||', 
					expl_id, fid, the_geom, descript)	SELECT '||v_exceptable_id||', '||v_exceptable_catalog||', 
					expl_id, '||v_check_fid||', the_geom, '||quote_literal(v_rec.fprocess_name)||' FROM ('||v_rec.query_text||')a';

			RAISE NOTICE 'v_querytext %', v_querytext;
			EXECUTE v_querytext;

		END IF;

	ELSE
		INSERT INTO t_audit_check_data (fid, criticity, result_id, error_message, fcount)
		values (v_function_fid, 1, v_check_fid, concat('INFO: ', v_rec.info_msg), 0);

		IF v_rec.except_table is not null then

			v_querytext = 'INSERT INTO t_'||v_rec.except_table||' ('||v_exceptable_id||', '||v_exceptable_catalog||', 
					expl_id, fid, the_geom, descript)	SELECT '||v_exceptable_id||', '||v_exceptable_catalog||', 
					expl_id, '||v_check_fid||', the_geom, '||quote_literal(v_rec.fprocess_name)||' FROM ('||v_rec.query_text||')a';

			RAISE NOTICE 'v_querytext %', v_querytext;
			EXECUTE v_querytext;
		END IF;

	END IF;

	-- Return
	RETURN '{"status":"ok"}';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;