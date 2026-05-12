-- DROP FUNCTION cm.gw_fct_cm_check_data_context(json);

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_check_data_context(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE

SELECT cm.gw_fct_cm_check_data_context($${"client":{"device":4, "lang":"es_ES", "version":"4.5.3", "infoType":1, "epsg":8908}, "form":{}, 
"feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"campaignId":"4", "nodeTolerance":"1", "demTolerance":"2", "dnomTolerance":"3"}, "aux_params":null}}$$);

*/

DECLARE

-- Init params
v_campaign_id integer;
v_commit_changes boolean = false;
v_excluded_features text;
v_percent_data numeric = 50;

-- Vars
v_sql_rec text;


v_campaign_name text;

v_param_name text;
v_threshold numeric;
rec_feature_type text;

v_sql_result TEXT;
v_sql_node text;
v_sql_excluded_features text;


-- aux/std vars
v_sql text;
v_aux_text text;
rec record;
v_exists boolean;

-- Return and sys params
v_version text;
v_srid integer;
v_parent_schema text = 'ap';
v_project_type TEXT = 'ws'; -- NOTE: WS is mandatory to create temp tables
v_function_id INT = 3556;
v_fid int = 999;
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_check_sum numeric;




BEGIN

    --SET search_path = "cm","ap",public;
	-- Search path (transaction-local)
	PERFORM set_config('search_path', 'cm,ap,public', true);


	-- Init params
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;
   
   	v_campaign_id := (p_data ->'data' ->'parameters'->>'campaignId')::integer;
    v_percent_data := coalesce((p_data ->'data' ->'parameters'->>'percentData'), 50::text)::numeric;
    v_commit_changes := (p_data ->'data' ->'parameters'->>'commitChanges')::boolean;
	v_excluded_features := (p_data ->'data' ->'parameters'->>'excludedFeatures')::text;

	v_sql_excluded_features = 'SELECT concat('||quote_literal(v_parent_schema)||', ''_'', trim(lower(val))) 
	FROM regexp_split_to_table('||quote_literal(v_excluded_features)||', '','') AS val'; 

	INSERT INTO config_qindex_suspicious (param_name, threshold, weight, addparam, cur_user, tooltip) VALUES('om_state_mpicture', 0, 0.2, NULL, CURRENT_USER, NULL) ON CONFLICT DO NOTHING;
	INSERT INTO config_qindex_suspicious (param_name, threshold, weight, addparam, cur_user, tooltip) VALUES('node_proximity', 0.1, 0.2, NULL, CURRENT_USER, 'Sus unidades son metros y expresa el valor máximo que consideramemos nodos cercanos. El valor mínimo es de sistema (0.1). Por debajo de esta medida se considera nodos duplicados. A más distancia menos qindex.') ON CONFLICT DO NOTHING;
	INSERT INTO config_qindex_suspicious (param_name, threshold, weight, addparam, cur_user, tooltip) VALUES('arc_diam_jump', 50, 0.2, NULL, CURRENT_USER, 'Sus unidades son milimetros y expresa la diferencia los diametres de las dos tuberías que le llegan al nodo. A más diferencia más qindex') ON CONFLICT DO NOTHING;
	INSERT INTO config_qindex_suspicious (param_name, threshold, weight, addparam, cur_user, tooltip) VALUES('valve_dn_wrong', 30, 0.2, NULL, CURRENT_USER, 'Sus unidades son milimetros y expresa la diferencia de los diametros de las tuberias que le llegan en comparación de la propia de la valvula. A más diferencia más qindex') ON CONFLICT DO NOTHING;
	INSERT INTO config_qindex_suspicious (param_name, threshold, weight, addparam, cur_user, tooltip) VALUES('elev_inconsistency', 50, 0.2, NULL, CURRENT_USER, 'Se expresa en metros y el umbral expresa la diferencia entre la cota gps y la cota dem a partir de la cual es sospechoso. A más diferencia más qindex') ON CONFLICT DO NOTHING;


	

	-- NOTE: temp tables and header to show in tab_info
	EXECUTE 'SELECT '||v_parent_schema||'.gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"LOG"}}}$$)';
	EXECUTE 'SELECT '||v_parent_schema||'.gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"ANL"}}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"'||v_function_id||'", "fid":"'||v_fid||'", "tempTable":"t_", "is_header":true,"separator_id":"2022"}}$$)';



	SELECT sum(weight) INTO v_check_sum FROM cm.config_qindex_suspicious
	WHERE cur_user = current_user;

	--raise exception '%', v_check_sum;

	IF v_check_sum != 1 THEN
/*
		 EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	 	"data":{"message":"4588", "function":"3556","parameters":null, "is_process":true}}$$)';
*/

		RAISE EXCEPTION 'La suma de los pesos es diferente a 1';

	END IF;




	alter table t_anl_node add column delta numeric;
	alter table t_anl_node add column param_name text;
	alter table t_anl_node add column candidate boolean;
	alter table t_anl_node add column qindex numeric;

	alter table t_anl_arc add column delta numeric;
	alter table t_anl_arc add column param_name text;
	alter table t_anl_arc add column candidate boolean;
	alter table t_anl_arc add column qindex numeric;

	v_sql := format(
	'SELECT campaign_id, node_id, node_type, nodecat_id, a.status, 
	null::numeric as qindex, null::text as observ, 
	now() as created_at, current_user as created_by, now() as updated_at, current_user as updated_by, 
	the_geom
	FROM cm.om_campaign_x_node a
	JOIN cm.om_campaign_lot_x_node c USING (node_id)
	where campaign_id = %s 
	and the_geom is not null and a.status != 1
	AND c.ACTION <> 3',
	v_campaign_id
	);


	execute '
	select STRING_AGG(''SELECT uuid, node_id, node_type, top_elev, nodecat_id, om_state, conserv_state, the_geom, '' || quote_literal(concat('||quote_literal(v_parent_schema)||', ''_'', lower(id))) || '' as child_table FROM '' || concat(''cm.ap'', ''_'', lower(id)) || '' WHERE the_geom IS NOT NULL'', '' UNION '')
	from PARENT_SCHEMA.cat_feature where feature_type = ''NODE'''
	into v_sql_node;

		
	IF v_excluded_features is NOT null then
		v_sql_excluded_features = ' AND child_table NOT IN ('||v_sql_excluded_features||')';
	else
		v_sql_excluded_features = '';
	end if;


	execute 'CREATE TEMP TABLE IF NOT EXISTS t_om_campaign_x_node AS '||v_sql||'';


	select name into v_campaign_name from cm.om_campaign where campaign_id = v_campaign_id;

   -- Comparison between elevs and DEM
	SELECT param_name, threshold INTO v_param_name, v_threshold FROM cm.config_qindex_suspicious
	WHERE param_name = 'elev_inconsistency' and cur_user = current_user LIMIT 1;

	raise notice '%', v_param_name;

    v_sql_result := format(
    'WITH nods as (%s
	), raster AS (
        SELECT t.rast
        FROM utils.raster_dem r, ST_Tile(r.rast, 100, 100) AS t(rast)
    ), bounding_box as (
       SELECT st_extent(a.the_geom) AS bbox FROM nods a
        join t_om_campaign_x_node c using (node_id)
        WHERE top_elev IS NOT null
    ), raster_recortado as (
        SELECT r.rast
        FROM raster r, bounding_box a
        WHERE r.rast && a.bbox
    )
    SELECT DISTINCT node_id, top_elev, n.nodecat_id, n.the_geom, abs(ST_Value(r.rast, 1, n.the_geom) - top_elev) as delta, child_table,
	concat(''DEM: '', ST_Value(r.rast, 1, n.the_geom), ''. top_elev: '', top_elev, ''. Diferencia: '', round(abs(ST_Value(r.rast, 1, n.the_geom) - top_elev)::numeric, 3)) as descript
    FROM nods n
    JOIN raster_recortado r ON st_intersects(r.rast, n.the_geom)
    WHERE n.top_elev IS NOT null
    and abs(ST_Value(r.rast, 1, n.the_geom) - top_elev) > %s',
	v_sql_node,
    v_threshold
    );


	execute  '
	INSERT INTO t_anl_node (node_id, nodecat_id, fid, descript, the_geom, delta, param_name)
	select node_id, nodecat_id, 999, descript, the_geom, delta, '||quote_literal(v_param_name)||' from ('||v_sql_result||')
	';

	execute'
	INSERT INTO t_audit_check_data (fid, criticity, error_message)
	select 999, 1, concat(''Hay '', count(*), '' nodos en la capa '', child_table, '' cuya elevación se distancia más de '', '||v_threshold||', '' metros.'') from ('||v_sql_result||')
	GROUP BY child_table
	';

    -- om_state and conserv_state, but without document
	SELECT param_name, threshold INTO v_param_name, v_threshold FROM cm.config_qindex_suspicious
	WHERE param_name = 'om_state_mpicture' and cur_user = current_user LIMIT 1;

	raise notice '%', v_param_name;

    v_sql_result := format(
    'select node_id, nodecat_id, node_type, om_state, conserv_state, child_table, the_geom,
	''Con estado de conservación pero sin foto'' as descript
 	from (%s)
    where om_state is not null and conserv_state is not null
    and (om_state <> ''DESCONOCIDO'' or conserv_state <> ''DESCONOCIDO'')
    and uuid not in (select node_uuid from cm.doc_x_node)
	AND node_id in (select node_id from t_om_campaign_x_node) %s',
    v_sql_node,
	v_sql_excluded_features
    );

	
	execute '
	INSERT INTO t_anl_node (node_id, nodecat_id, fid, descript, the_geom, delta, param_name)
	select node_id, nodecat_id, 999, descript, the_geom, 1, '||quote_literal(v_param_name)||' from ('||v_sql_result||')
	';

	execute '
	INSERT INTO t_audit_check_data (fid, criticity, error_message)
	select 999, 1, concat(''Hay '', count(*), '' nodos en la capa '', child_table, '' que tienen estado de conservación y estado funcional, pero no tienen foto.'') from ('||v_sql_result||')
	GROUP BY child_table
	';

    -- NOTE: node_proximity
	SELECT param_name, threshold INTO v_param_name, v_threshold FROM cm.config_qindex_suspicious
	WHERE param_name = 'node_proximity' and cur_user = current_user LIMIT 1;

	raise notice '%', v_param_name;


    v_sql_result := format(
    'WITH nods as (%s), 
	mec AS (
        SELECT a.node_id, a.nodecat_id, b.child_table, a.the_geom
		FROM t_om_campaign_x_node a
		JOIN nods b using (node_id)
    )
    SELECT a.node_id, a.nodecat_id, string_agg(b.node_id::text, '','') AS node_id_duplicated, a.the_geom, a.child_table,
	concat(''Nodos cercanos entre 0.1 m y '', %L, '' m.'') as descript,
	(1/st_distance(a.the_geom, b.the_geom)) as delta
    FROM mec a 
	LEFT JOIN mec b ON st_dwithin(a.the_geom, b.the_geom, %L) 
    WHERE a.node_id != b.node_id and st_distance(a.the_geom, b.the_geom) between 0.1 and %s
    GROUP BY a.node_id, a.nodecat_id, a.the_geom, b.the_geom, a.child_table
    ORDER BY a.nodecat_id',
	v_sql_node,
	v_threshold,
    v_threshold,
	v_threshold
    );

	
		
	execute '
	INSERT INTO t_anl_node (node_id, nodecat_id, fid, descript, the_geom, delta, param_name)
	select node_id, nodecat_id, 999, descript, the_geom, delta, '||quote_literal(v_param_name)||' from ('||v_sql_result||')
	';

	execute '
	INSERT INTO t_audit_check_data (fid, criticity, error_message)
	select 999, 1, concat(''Hay '', count(*), '' nodos en la capa '', child_table, '' a menos de '', '||v_threshold||', '' metros.'') from ('||v_sql_result||')
	GROUP BY child_table
	';



    -- NOTE: arc_diam_jump (diameter change without any reason)
	SELECT param_name, threshold INTO v_param_name, v_threshold FROM cm.config_qindex_suspicious
	WHERE param_name = 'arc_diam_jump' and cur_user = current_user LIMIT 1;

	raise notice '%', v_param_name;

    v_sql_result := format(
    'with mec as (
	    select row_number() over(partition by a.node_id order by node_id) as num_nodes_intersected, 
		a.node_id, a.the_geom, a.nodecat_id
	    from t_om_campaign_x_node a
	    join cm.om_campaign_x_arc b on st_dwithin(a.the_geom, b.the_geom, 0.01)
    ), final_nodes as (
    	select node_id, nodecat_id, ''Cambio de diametro sin razón aparente.'' as descript, the_geom 
		from mec group by nodecat_id, node_id, the_geom having max(num_nodes_intersected)=2
    )
    select a.*, 
	substring(b.arccat_id FROM ''\d+'') as dnom_1, 
	substring(c.arccat_id FROM ''\d+'') as dnom_2,
	abs(substring(b.arccat_id FROM ''\d+'')::numeric - substring(c.arccat_id FROM ''\d+'')::numeric) as delta
	from final_nodes a
    left join cm.om_campaign_x_arc b on a.node_id = b.node_1
    left join cm.om_campaign_x_arc c on a.node_id = c.node_2
    where b.id is not null and c.id is not null
    and abs(substring(b.arccat_id FROM ''\d+'')::numeric - substring(c.arccat_id FROM ''\d+'')::numeric) > %s',
    v_campaign_id,
    v_threshold
    );

	
	
	execute '
	INSERT INTO t_anl_node (node_id, nodecat_id, fid, descript, the_geom, delta, param_name)
	select node_id, nodecat_id, 999, descript, the_geom, delta, '||quote_literal(v_param_name)||' from ('||v_sql_result||')
	';

	execute '
	INSERT INTO t_audit_check_data (fid, criticity, error_message)
	select 999, 1, concat(''Hay '', count(*), '' cambio(s) de diametro sin razón aparente. '') from ('||v_sql_result||')
	';


    -- NOTE: valve_dn_wrong (valve diameter not according to the arc's diameter)
	SELECT param_name, threshold INTO v_param_name, v_threshold FROM cm.config_qindex_suspicious
	WHERE param_name = 'valve_dn_wrong' and cur_user = current_user LIMIT 1;

	raise notice '%', v_param_name;

    v_sql_result := format(
    'with mec as (
        select row_number() over(partition by a.node_id order by node_id) as num_nodes_intersected, 
        a.node_id, a.nodecat_id, a.node_type, a.the_geom 
        from t_om_campaign_x_node a
        join cm.om_campaign_x_arc b on st_dwithin(a.the_geom, b.the_geom, 0.01)
    ), final_nodes as (
        select node_id, nodecat_id, node_type, the_geom 
        from mec 
        group by nodecat_id, node_type, node_id, the_geom having max(num_nodes_intersected)=2
    )
    select a.*, ''Diametro de válvula incoherente con sus tramos adyacentes.'' as descript, 
	substring(b.arccat_id FROM ''\d+'') as dnom_1, 
    substring(c.arccat_id FROM ''\d+'') as dnom_2,
	abs(substring(b.arccat_id FROM ''\d+'')::numeric - substring(c.arccat_id FROM ''\d+'')::numeric) as delta
	from final_nodes a
    left join cm.om_campaign_x_arc b on a.node_id = b.node_1
    left join cm.om_campaign_x_arc c on a.node_id = c.node_2
    where b.id is not null and c.id is not null
    and node_type in (select id from PARENT_SCHEMA.cat_feature where feature_class = ''VALVE'')
    and (substring(a.nodecat_id FROM ''\d+'') <> substring(b.arccat_id FROM ''\d+'')
    OR  substring(a.nodecat_id FROM ''\d+'') <> substring(c.arccat_id FROM ''\d+''))',
    v_campaign_id
    );



	execute '
	INSERT INTO t_anl_node (node_id, nodecat_id, fid, descript, the_geom, delta, param_name)
	select node_id, nodecat_id, 999, descript, the_geom, delta, '||quote_literal(v_param_name)||' from ('||v_sql_result||')
	';

	execute '
	INSERT INTO t_audit_check_data (fid, criticity, error_message)
	select 999, 1, concat(''Hay '', count(*), '' válvulas cuyo diametro no coincide con sus tramos adyacentes.'') from ('||v_sql_result||')
	';




    -- return results
    -- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT error_message as message FROM t_audit_check_data order by id) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	FOREACH rec_feature_type IN ARRAY ARRAY['arc', 'node']
	LOOP

	    -- temp tables
		execute format('SELECT jsonb_build_object(
			''type'', ''FeatureCollection'',
			''features'', COALESCE(jsonb_agg(features.feature), ''[]''::jsonb)
		) 
		FROM (
			SELECT jsonb_build_object(
				''type'',       ''Feature'',
				''geometry'',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
				''properties'', to_jsonb(row) - ''the_geom''
			) AS feature FROM (
				SELECT id, %s, %s, state, expl_id, descript, the_geom FROM %s) row) features',
			rec_feature_type || '_id',
			rec_feature_type || 'cat_id',
			't_anl_' || rec_feature_type
			) INTO v_result;
raise notice '%', v_result;
		
		if v_result is not null then
			IF rec_feature_type = 'arc' then v_result_line = concat ('{"geometryType":"LineString", "features":',coalesce(v_result, '{}'),'}'); 
			ELSIF rec_feature_type = 'node' then v_result_point = concat ('{"geometryType":"Point", "features":',coalesce(v_result, '{}'), '}');
			END IF;
		end if;

		if v_commit_changes then

			execute format('
			delete from %s where campaign_id = %s',
			'cm.om_campaign_qc_' || rec_feature_type,
			v_campaign_id
			);
			
			-- insert into quality tables all the nodes from the campaign
			execute format('
			insert into %s (uuid, campaign_id, %s, status, created_at, created_by, the_geom)
			select gen_random_uuid(), %s as campaign_id, %s::int as feature_id, 0 as status, 
			now() as created_at, current_user as created_by, the_geom
			from %s
			WHERE campaign_id = %s',
			'cm.om_campaign_qc_' || rec_feature_type, -- INSERT INTO cm.om_campaign_qc_node 
			rec_feature_type || '_id', --node_id
			v_campaign_id,
			rec_feature_type || '_id', --node_id
			'cm.om_campaign_x_' || rec_feature_type, -- FROM cm.om_campaign_qc_node 
			v_campaign_id
			);

			

			v_sql := format('update %s t set indexq = m.final_index from (
			WITH mec AS (
				SELECT c.param_name, c.weight,
				c.threshold::numeric AS min_value, 
				max(delta)::numeric AS max_value 
				FROM %s 
				LEFT JOIN cm.config_qindex_suspicious c USING (param_name)
				GROUP BY c.param_name, c.threshold, c.weight
			), moc as (
				select c.%s::int, b.weight,
				case when min_value > delta then 0 
				else round(1+((delta - min_value) * 9.0) / COALESCE(NULLIF((max_value - min_value), 0), 1)::NUMERIC, 2) 
				end AS scaled_values
				FROM %s c 
				LEFT JOIN mec b USING (param_name)
			)
			SELECT %s, round(weight * scaled_values, 2) AS final_index FROM moc
			)m WHERE t.campaign_id = %s AND t.%s = m.%s',
			'cm.om_campaign_qc_' || rec_feature_type, -- UPDATE cm.om_campaign_qc_node
			't_anl_' || rec_feature_type,
			rec_feature_type || '_id', -- SELECT node_id
			't_anl_' || rec_feature_type,
			rec_feature_type || '_id::int', -- SELECT node_id
			v_campaign_id,
			rec_feature_type || '_id::int', -- t.node_id
			rec_feature_type || '_id::int' -- a.node_id
			);


			execute v_sql;

			execute format('
			UPDATE %s SET indexq = 0
			where campaign_id = %s and indexq is null',
			'cm.om_campaign_qc_' || rec_feature_type, -- om_campaign_x_node
			v_campaign_id
			);
	 			
			execute format('
			UPDATE %s SET candidate = false
			where campaign_id = %s and candidate is null',
			'cm.om_campaign_qc_' || rec_feature_type, -- om_campaign_x_node
			v_campaign_id
			);

			execute FORMAT('
			UPDATE %s SET candidate = true WHERE campaign_id = %s and %s in (
				with mec as (SELECT %s FROM %s WHERE campaign_id = %s ORDER BY indexq DESC)
				select * from mec			
				LIMIT (SELECT count(*) * %s FROM %s WHERE campaign_id = %s))',
			'cm.om_campaign_qc_' || rec_feature_type, -- UPDATE cm.om_campaign_qc_node
			v_campaign_id, -- SET campaign_id = 4
			rec_feature_type || '_id', -- WHERE node_id IN
			rec_feature_type || '_id', -- SELECT node_id
			'cm.om_campaign_qc_' || rec_feature_type, -- FROM cm.om_campaign_qc_node
			v_campaign_id, -- WHERE campaign_id = 4
			v_percent_data/100, -- select count(*) * 0.8 
			'cm.om_campaign_qc_' || rec_feature_type, -- FROM cm.om_campaign_qc_node
			v_campaign_id -- WHERE campaign_id = 4
			);
	
			execute format('
			update %s set addparam = (
				SELECT coalesce(json_agg(to_json(t)), ''{}''::json)
				FROM cm.config_qindex_suspicious AS t
				where cur_user = current_user
			) where created_at = now()',
			'cm.om_campaign_qc_' || rec_feature_type
			);		

			execute format('
			update %s q set pre_observ = a.descript from(
				select %s, string_agg(descript, '' ; '') as descript from %s
				group by %s)a where a.%s = q.%s',
			'cm.om_campaign_qc_' || rec_feature_type,
			rec_feature_type || '_id',
			't_anl_' || rec_feature_type,
			rec_feature_type || '_id',
			rec_feature_type || '_id::int',
			rec_feature_type || '_id::int'
			);	
			


		end if;

	END LOOP;

	--create table cm._bgeo_anl_node as selecT*from t_anl_node;


	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
    v_result_point := COALESCE(v_result_point, '{}');
 	v_result_line := COALESCE(v_result_line, '{}');

	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"LOG"}}}$$)';
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"ANL"}}}$$)';
	DROP TABLE IF EXISTS t_om_campaign_x_node;

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, 
    "version":"'||v_version||'","body":{"form":{},"data":{"info":'||v_result_info||',"point":'||v_result_point||', "line":'||v_result_line||'}}}')::json, 2110, null, null, null);
   
END;
$function$
;
