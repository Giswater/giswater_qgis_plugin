/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3482

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_macromapzones(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_macromapzones(p_data json)
RETURNS json AS
$BODY$

DECLARE

	-- system variables
	v_version TEXT;
	v_srid INTEGER;
	v_project_type TEXT;

	v_fid integer = 3482;

	-- dialog variables
	v_class text;
	v_expl_id text;
	v_expl_id_array integer[];
	v_commitchanges boolean;

	v_visible_layer text;

	v_level integer;
	v_status text;
	v_message text;

	v_result JSON;
	v_result_info json;
	v_result_polygon json;

	-- dynamic mapping
	v_macro_table text;
	v_child_table text;
	v_child_fk text;
	v_macro_id_field text;
	v_query_geom TEXT;

	-- mapzone geometry modes (aligned with gw_fct_graphanalytics_mapzones_v1)
	v_update_map_zone integer := 0;
	v_geom_param_update float;
	v_geom_param_update_divide float;
	v_concave_hull float := 0.9;
	v_query_text text;
	v_query_text_aux text;

	v_error_context text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
	SELECT giswater, epsg, UPPER(project_type) INTO v_version, v_srid, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
	v_class := p_data->'data'->'parameters'->>'graphClass';
	v_expl_id := p_data->'data'->'parameters'->>'exploitation';
	v_update_map_zone := p_data->'data'->'parameters'->>'updateMapZone';
	v_commitchanges := p_data->'data'->'parameters'->>'commitChanges';
	v_geom_param_update := p_data->'data'->'parameters'->>'geomParamUpdate';


	-- Dynamic mapping for macro/child tables and fields
	IF v_class NOT IN ('MACROSECTOR', 'MACROOMZONE','MACRODMA','MACRODQA') THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"3090", "function":"3482","parameters":null, "is_process":true}}$$)';
		RETURN NULL;
	END IF;

	v_macro_table := lower(v_class);
	v_child_table := replace(v_macro_table, 'macro', '');
	v_macro_id_field := v_macro_table || '_id';
	v_child_fk := v_child_table || '_id';
	v_visible_layer := 've_' || v_macro_table;

	-- Parse expl_id array
	v_expl_id_array := gw_fct_get_expl_id_array(v_expl_id);

	IF v_expl_id_array IS NULL THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"4478", "function":"3482","parameters":null}}$$);';
		RETURN NULL;
	END IF;

	DROP TABLE IF EXISTS temp_audit_check_data;
	CREATE TEMP TABLE IF NOT EXISTS temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);

	-- Log
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3482", "is_header":true, "separator_id":2049, "parameters":{"class":"'||concat(' - ', v_class)||'"}, "tempTable":"temp_", "fid": '||v_fid||'}}$$);';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4594","function":"3482", "parameters":{"commitChanges":"'||upper(v_commitchanges::text)||'"}, "criticity":"3", "tempTable":"temp_", "fid": '||v_fid||'}}$$);';
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, '');
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3482", "is_header":true, "label_id":3003, "separator_id":2010, "tempTable":"temp_", "criticity":"3", "fid": '||v_fid||'}}$$);';
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, '');
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3482", "is_header":true, "label_id":3002, "separator_id":2014, "tempTable":"temp_", "criticity":"2", "fid": '||v_fid||'}}$$);';
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, '');
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3482", "is_header":true, "label_id":3001, "separator_id":2008, "tempTable":"temp_", "criticity":"1", "fid": '||v_fid||'}}$$);';
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 0, '');
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3482", "is_header":true, "label_id":3012, "separator_id":2010, "tempTable":"temp_", "criticity":"0", "fid": '||v_fid||'}}$$);';

	IF v_child_table = 'sector' THEN
		v_query_geom = '
		SELECT '||v_macro_id_field||' AS mapzone_id, '||v_child_table||'_id, name as '||v_child_table||'_name ,
		'||v_child_table||'_type, descript, st_union(the_geom) as the_geom, UNNEST(expl_id) as expl_id,
		UNNEST(muni_id) as muni_id FROM '|| v_child_table ||'
		WHERE '||v_macro_id_field||' IS NOT NULL AND (cardinality($1) = 0 OR $1::integer[] && ARRAY[expl_id])
		GROUP BY '||v_macro_id_field||', '||v_child_table||'_id,  name, '||v_child_table||'_type, descript';
	ELSE
		v_query_geom = '
		SELECT '||v_macro_id_field||' AS mapzone_id, '||v_child_table||'_id, name as '||v_child_table||'_name ,
		'||v_child_table||'_type, descript, st_union(the_geom) as the_geom, UNNEST(expl_id) as expl_id,
		UNNEST(muni_id) as muni_id, UNNEST(sector_id) as sector_id FROM '|| v_child_table ||'
		WHERE '||v_macro_id_field||' IS NOT NULL AND (cardinality($1) = 0 OR $1::integer[] && ARRAY[expl_id])
		GROUP BY '||v_macro_id_field||', '||v_child_table||'_id,  name, '||v_child_table||'_type, descript';
	END IF;

	IF v_update_map_zone > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4608","function":"3482","parameters":{"graphClass":"'
			|| upper(v_class) || '"}, "tempTable":"temp_", "criticity":"1", "fid": '||v_fid||'}}$$);';

		DROP TABLE IF EXISTS temp_macromapzone_geom;
		CREATE TEMP TABLE temp_macromapzone_geom (mapzone_id integer, the_geom public.geometry);

		IF v_update_map_zone = 1 THEN
			v_query_text := '
				INSERT INTO temp_macromapzone_geom (mapzone_id, the_geom)
				WITH polygon AS (
					SELECT ch.'||v_macro_id_field||' AS mapzone_id,
						ST_Collect(ar.the_geom) AS g
					FROM arc ar
					JOIN '||v_child_table||' ch ON ar.'||v_child_fk||' = ch.'||v_child_fk||'
					WHERE ch.'||v_macro_id_field||' IS NOT NULL AND ch.'||v_macro_id_field||' > 0
					AND (cardinality($1) = 0 OR ar.expl_id = ANY($1))
					GROUP BY ch.'||v_macro_id_field||'
				)
				SELECT mapzone_id,
					ST_Multi(
						CASE
							WHEN ST_GeometryType(ST_ConcaveHull(g, '||v_concave_hull||')) = ''ST_Polygon'' THEN
								ST_Buffer(ST_ConcaveHull(g, '||v_concave_hull||'), 2)::geometry(Polygon,'||v_srid||')
							ELSE
								ST_Expand(ST_Buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,'||v_srid||')
						END
					) AS the_geom
				FROM polygon
			';
			EXECUTE v_query_text USING v_expl_id_array;

		ELSIF v_update_map_zone = 2 THEN
			v_query_text := '
				INSERT INTO temp_macromapzone_geom (mapzone_id, the_geom)
				SELECT ch.'||v_macro_id_field||',
					ST_Multi(ST_Buffer(ST_Collect(ar.the_geom), '||v_geom_param_update||')) AS the_geom
				FROM arc ar
				JOIN '||v_child_table||' ch ON ar.'||v_child_fk||' = ch.'||v_child_fk||'
				WHERE ch.'||v_macro_id_field||' IS NOT NULL AND ch.'||v_macro_id_field||' > 0
				AND (cardinality($1) = 0 OR ar.expl_id = ANY($1))
				GROUP BY ch.'||v_macro_id_field||'
			';
			EXECUTE v_query_text USING v_expl_id_array;

		ELSIF v_update_map_zone = 3 THEN
			v_query_text := '
				INSERT INTO temp_macromapzone_geom (mapzone_id, the_geom)
				SELECT mapzone_id, ST_Multi(ST_Buffer(ST_Collect(geom), 0.01)) AS geom
				FROM (
					SELECT ch.'||v_macro_id_field||' AS mapzone_id,
						ST_Buffer(ar.the_geom, '||v_geom_param_update||') AS geom
					FROM arc ar
					JOIN '||v_child_table||' ch ON ar.'||v_child_fk||' = ch.'||v_child_fk||'
					WHERE ch.'||v_macro_id_field||' IS NOT NULL AND ch.'||v_macro_id_field||' > 0
					AND (cardinality($1) = 0 OR ar.expl_id = ANY($1))
					UNION ALL
					SELECT ch.'||v_macro_id_field||' AS mapzone_id,
						ep.the_geom AS geom
					FROM connec vc
					JOIN '||v_child_table||' ch ON vc.'||v_child_fk||' = ch.'||v_child_fk||'
					LEFT JOIN ext_plot ep
						ON vc.plot_code = ep.plot_code
						AND ST_DWithin(vc.the_geom, ep.the_geom, 0.001)
					WHERE ch.'||v_macro_id_field||' IS NOT NULL AND ch.'||v_macro_id_field||' > 0
					AND (cardinality($1) = 0 OR vc.expl_id = ANY($1))
					AND ep.the_geom IS NOT NULL
				) a
				GROUP BY mapzone_id
			';
			EXECUTE v_query_text USING v_expl_id_array;

		ELSIF v_update_map_zone = 4 THEN
			v_geom_param_update_divide := v_geom_param_update / 2;

			IF v_project_type = 'UD' THEN
				v_query_text_aux := '
					UNION ALL
					SELECT ch.'||v_macro_id_field||' AS mapzone_id,
						ST_Buffer(ST_Collect(l.the_geom), '||v_geom_param_update_divide||', ''endcap=flat join=round'') AS geom
					FROM gully g
					JOIN '||v_child_table||' ch ON g.'||v_child_fk||' = ch.'||v_child_fk||'
					JOIN link l ON l.feature_id = g.gully_id AND l.feature_type = ''GULLY''
					WHERE ch.'||v_macro_id_field||' IS NOT NULL AND ch.'||v_macro_id_field||' > 0
					AND (cardinality($1) = 0 OR g.expl_id = ANY($1))
					GROUP BY ch.'||v_macro_id_field||'
				';
			ELSE
				v_query_text_aux := '';
			END IF;

			v_query_text := '
				INSERT INTO temp_macromapzone_geom (mapzone_id, the_geom)
				SELECT mapzone_id, ST_Multi(ST_Buffer(ST_Collect(geom), 0.01)) AS geom
				FROM (
					SELECT ch.'||v_macro_id_field||' AS mapzone_id,
						ST_Buffer(ST_Collect(ar.the_geom), '||v_geom_param_update||') AS geom
					FROM arc ar
					JOIN '||v_child_table||' ch ON ar.'||v_child_fk||' = ch.'||v_child_fk||'
					WHERE ch.'||v_macro_id_field||' IS NOT NULL AND ch.'||v_macro_id_field||' > 0
					AND (cardinality($1) = 0 OR ar.expl_id = ANY($1))
					GROUP BY ch.'||v_macro_id_field||'
					UNION ALL
					SELECT ch.'||v_macro_id_field||' AS mapzone_id,
						ST_Buffer(ST_Collect(l.the_geom), '||v_geom_param_update_divide||', ''endcap=flat join=round'') AS geom
					FROM connec vc
					JOIN '||v_child_table||' ch ON vc.'||v_child_fk||' = ch.'||v_child_fk||'
					JOIN link l ON l.feature_id = vc.connec_id
					WHERE ch.'||v_macro_id_field||' IS NOT NULL AND ch.'||v_macro_id_field||' > 0
					AND (cardinality($1) = 0 OR vc.expl_id = ANY($1))
					GROUP BY ch.'||v_macro_id_field||'
					'||v_query_text_aux||'
				) u
				GROUP BY mapzone_id
			';
			EXECUTE v_query_text USING v_expl_id_array;
		END IF;
	END IF;

	IF v_commitchanges THEN -- update macromapzone table

		IF v_update_map_zone = 0 THEN
			EXECUTE '
			UPDATE '|| v_macro_table ||' t SET the_geom = a.the_geom , expl_id = a.expl_id, muni_id = a.muni_id
			FROM (
				SELECT mapzone_id, ST_Union(the_geom) as the_geom, array_agg(DISTINCT expl_id) as expl_id,
				 array_agg(DISTINCT muni_id) as muni_id
				FROM ('||v_query_geom||')
				GROUP BY mapzone_id
			) a
			WHERE t.'||v_macro_id_field||' = a.mapzone_id
			' USING v_expl_id_array;
		ELSE
			EXECUTE '
			UPDATE '|| v_macro_table ||' t SET the_geom = COALESCE(g.the_geom, a.the_geom), expl_id = a.expl_id, muni_id = a.muni_id
			FROM (
				SELECT mapzone_id, ST_Union(the_geom) as the_geom, array_agg(DISTINCT expl_id) as expl_id,
				 array_agg(DISTINCT muni_id) as muni_id
				FROM ('||v_query_geom||')
				GROUP BY mapzone_id
			) a
			LEFT JOIN temp_macromapzone_geom g ON g.mapzone_id = a.mapzone_id
			WHERE t.'||v_macro_id_field||' = a.mapzone_id
			' USING v_expl_id_array;
		END IF;

	ELSE -- temporal layer

		IF v_update_map_zone = 0 THEN
			EXECUTE '
			SELECT jsonb_build_object(
				''type'', ''FeatureCollection'',
				''features'', COALESCE(jsonb_agg(f.feature), ''[]''::jsonb)
			)
			FROM (
				SELECT jsonb_build_object(
					''type'',       ''Feature'',
					''geometry'',   ST_AsGeoJSON(ST_Transform(a.the_geom, 4326))::jsonb,
					''properties'', to_jsonb(m) - ''the_geom''
				) AS feature
				FROM (
					SELECT mapzone_id, ST_Union(the_geom) AS the_geom
					FROM ('||v_query_geom||')
					GROUP BY mapzone_id
				) a
				JOIN '|| v_macro_table ||' m ON m.'||v_macro_id_field||' = a.mapzone_id
			) f
			' INTO v_result USING v_expl_id_array;
		ELSE
			EXECUTE '
			SELECT jsonb_build_object(
				''type'', ''FeatureCollection'',
				''features'', COALESCE(jsonb_agg(f.feature), ''[]''::jsonb)
			)
			FROM (
				SELECT jsonb_build_object(
					''type'',       ''Feature'',
					''geometry'',   ST_AsGeoJSON(ST_Transform(COALESCE(g.the_geom, a.the_geom), 4326))::jsonb,
					''properties'', to_jsonb(m) - ''the_geom''
				) AS feature
				FROM (
					SELECT mapzone_id, ST_Union(the_geom) AS the_geom
					FROM ('||v_query_geom||')
					GROUP BY mapzone_id
				) a
				LEFT JOIN temp_macromapzone_geom g ON g.mapzone_id = a.mapzone_id
				JOIN '|| v_macro_table ||' m ON m.'||v_macro_id_field||' = a.mapzone_id
			) f
			' INTO v_result USING v_expl_id_array;
		END IF;

	v_result_polygon := v_result;

	END IF;

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message AS message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid IN (v_fid) ORDER BY criticity DESC, id ASC) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info := concat ('{"values":',v_result, '}');


	-- return
	v_status := coalesce(v_status, 'Accepted');
	v_level := COALESCE(v_level, 0);
	v_message := COALESCE(v_message, '{}');
	v_version := COALESCE(v_version, '');
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_polygon := COALESCE(v_result_polygon, '{}');

	RETURN gw_fct_json_create_return(('{
		"status":"'||v_status||'",
		"message":{
			"level":'||v_level||',
			"text":"'||v_message||'"
		},
		"version":"'||v_version||'",
		"body":{
			"form":{},
			"data":{
				"graphClass": "'||v_class||'",
				"info":'||v_result_info||',
				"polygon":'||v_result_polygon||'
			}
		}
	}')::json, 3482, null, ('{"visible": ["'||v_visible_layer||'"]}')::json, null)::json;

	EXCEPTION WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
		RETURN json_build_object(
		'status', 'Failed',
		'NOSQLERRM', SQLERRM,
		'message', json_build_object(
			'level', right(SQLSTATE, 1),
			'text', SQLERRM
		),
		'SQLSTATE', SQLSTATE,
		'SQLCONTEXT', v_error_context
	);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
