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
--
v_rec record;
v_rec_anl record;
v_count integer;
v_geom_type text;
v_sql text;
v_text_aux text;
v_exc_msg text;
v_iscount boolean;
v_process text;

BEGIN

	-- get input params
	v_function_fid := (((p_data ->>'data')::json->>'parameters')::json->>'functionFid')::integer;
	v_check_fid := (((p_data ->> 'data')::json->>'parameters')::json->> 'checkFid')::integer;
	v_process := (((p_data ->> 'data')::json->>'parameters')::json->> 'process');
	
	-- get fprocess data
	select * into v_rec from sys_fprocess where fid = v_check_fid;

	IF v_process = 'check' THEN

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
	
			INSERT INTO t_audit_check_data (fid, criticity, result_id, error_message, fcount)
			values (v_function_fid, v_rec.except_level, v_check_fid, concat(
			case when v_rec.except_level = 2 then 'ERROR-' when v_rec.except_level = 3 then 'WARNING-' end ,
			v_check_fid, ': ', concat(v_text_aux, v_count, ' ', v_exc_msg)), 9999);
		ELSE
			INSERT INTO t_audit_check_data (fid, criticity, result_id, error_message, fcount)
			values (v_function_fid, 3, v_check_fid, concat('INFO: ', v_rec.info_msg), 7777);
	
		END IF;
	
		-- manage result (anl_tables)
		if v_rec.query_text ilike '%the_geom%' then
	
			v_sql = 'select a.*, '||quote_literal(v_exc_msg)||' from ('||v_rec.query_text||') a';
			execute 'select distinct st_geometrytype(the_geom) from ('||v_sql||')a limit 1' into v_geom_type;
			
			if v_geom_type = 'ST_LineString' then
				execute '
				insert into t_anl_arc (arc_id, arccat_id, expl_id, fid, the_geom, descript)
				select arc_id, arccat_id, expl_id, '||v_check_fid||', the_geom, '||quote_literal(v_exc_msg)||' from ('||v_sql||')b';
				
			elsif v_geom_type = 'ST_Point' then
			
				if v_rec.query_text ilike 'SELECT node_id%' then
					execute '
					insert into t_anl_node (node_id, nodecat_id, expl_id, fid, the_geom, descript)
					select node_id, nodecat_id, expl_id, '||v_check_fid||', the_geom, '||quote_literal(v_exc_msg)||' from ('||v_sql||')b';
				
				elsif v_rec.query_text ilike '% SELECT connec_id%' then
					execute '
					insert into t_anl_connec (connec_id, conneccat_id, expl_id, fid, the_geom, descript)
					select connec_id, conneccat_id, expl_id, '||v_check_fid||', the_geom, '||quote_literal(v_exc_msg)||' from ('||v_sql||')b';
				end if;
	
			elsif v_geom_type = 'ST_MultiPolygon' then
				execute '
				insert into t_anl_polygon (pol_id, pol_type, expl_id, fid, the_geom, descript)
				select pol_id, pol_type, expl_id, '||v_check_fid||', the_geom, '||quote_literal(v_exc_msg)||' from ('||v_sql||')b';
			end if;
		end if;

	ELSIF v_process = 'finish' THEN

		if v_rec.query_text ilike '%the_geom%' then
	
			v_sql = 'select a.*, '||quote_literal(v_exc_msg)||' from ('||v_rec.query_text||') a';
			execute 'select distinct st_geometrytype(the_geom) from ('||v_sql||')a limit 1' into v_geom_type;
			
			if v_geom_type = 'ST_LineString' then
				EXECUTE 'DELETE FROM anl_arc WHERE fid = '||v_rec.fid||' AND cur_user = current_user';
				EXECUTE 'insert into anl_arc (arc_id, arccat_id, expl_id, fid, the_geom, descript, cur_user)
						 SELECT arc_id, arccat_id, expl_id, fid, the_geom, descript, current_user FROM t_anl_arc WHERE fid = v_rec.fid';
				
			elsif v_geom_type = 'ST_Point' then
				if v_rec.query_text ilike 'SELECT node_id%' then
					EXECUTE 'DELETE FROM anl_node WHERE fid = '||v_rec.fid||' AND cur_user = current_user';
					EXECUTE 'insert into anl_node (node_id, nodecat_id, expl_id, fid, the_geom, descript, cur_user)
						 SELECT node_id, nodecat_id, expl_id, fid, the_geom, descript, current_user FROM t_anl_node WHERE fid = v_rec.fid';
				
				elsif v_rec.query_text ilike '% SELECT connec_id%' then
					EXECUTE 'DELETE FROM anl_connec WHERE fid = '||v_rec.fid||' AND cur_user = current_user';
					EXECUTE 'insert into anl_arc (connec_id, conneccat_id, expl_id, fid, the_geom, descript, cur_user)
						 SELECT connec_id, conneccat_id, expl_id, fid, the_geom, descript, current_user FROM t_anl_connec WHERE fid = v_rec.fid';

				elsif v_rec.query_text ilike '% SELECT gully_id%' then
					EXECUTE 'DELETE FROM anl_gully WHERE fid = '||v_rec.fid||' AND cur_user = current_user';
					EXECUTE 'insert into anl_gully (gully_id, gullycat_id, expl_id, fid, the_geom, descript, cur_user)
						 SELECT arc_id, gullycat_id, expl_id, fid, the_geom, descript, current_user FROM t_anl_gully WHERE fid = v_rec.fid';
				end if;
	
			elsif v_geom_type = 'ST_MultiPolygon' then
				EXECUTE 'DELETE FROM anl_polygon WHERE fid = '||v_rec.fid||' AND cur_user = current_user';
				EXECUTE 'insert into anl_polygon (pol_id, pol_type expl_id, fid, the_geom, descript, cur_user)
					 SELECT pol_id, pol_type, expl_id, fid, the_geom, descript, current_user FROM t_anl_polygon WHERE fid = v_rec.fid';
			end if;
		end if;

	END IF;

	-- Return
	RETURN '{"status":"ok"}';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;