/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3366

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_create_logreturn (p_data json)
  RETURNS json AS
$BODY$

/*
SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"info"}}}$$);
SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"point"}}}$$);
SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"line"}}}$$);
SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"polygon"}}}$$);
*/

DECLARE
v_schemaname text;
v_result json;
v_returntype text;
v_querytext text;
v_rec record;
v_project_type text;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;


	-- get input parameters
	v_returntype := ((p_data->>'data')::json->>'parameters')::json->>'type';
	v_querytext := ((p_data->>'data')::json->>'parameters')::json->>'queryText';

	v_result = NULL;
	IF v_returntype = 'fillExcepTables' THEN -- delete and insert on anl tables

		DELETE FROM audit_check_data WHERE fid in (select fid from t_audit_check_data) and cur_user=current_user;
		INSERT INTO audit_check_data (fid, result_id, table_id, column_id, criticity, enabled, error_message, tstamp, cur_user, feature_type, feature_id, addparam, fcount)
		SELECT fid, result_id, table_id, column_id, criticity, enabled, error_message, tstamp, cur_user, feature_type, feature_id, addparam, fcount
		FROM t_audit_check_data;

		DELETE FROM anl_node WHERE fid in (select fid from t_anl_node) and cur_user=current_user;
		DELETE FROM anl_connec WHERE fid in (select fid from t_anl_connec) and cur_user=current_user;
		DELETE FROM anl_arc WHERE fid in (select fid from t_anl_arc) and cur_user=current_user;
		DELETE FROM anl_polygon WHERE fid in (select fid from t_anl_polygon) and cur_user=current_user;

		IF v_project_type = 'WS' THEN

			INSERT INTO anl_node (node_id, nodecat_id, state, num_arcs, node_id_aux, nodecat_id_aux, state_aux, expl_id, fid, cur_user, the_geom, arc_distance, arc_id, descript, result_id, total_distance, sys_type, code, cat_geom1, top_elev, elev, "depth", state_type, sector_id, losses, dma_id, presszone_id, dqa_id, minsector_id, demand, addparam)
			SELECT node_id, nodecat_id, state, num_arcs, node_id_aux, nodecat_id_aux, state_aux, expl_id, fid, cur_user, the_geom, arc_distance, arc_id, descript, result_id, total_distance, sys_type, code, cat_geom1, top_elev, elev, "depth", state_type, sector_id, losses, dma_id, presszone_id, dqa_id, minsector_id, demand, addparam
			FROM t_anl_node;

			INSERT INTO anl_connec (connec_id, conneccat_id, state, connec_id_aux, connecat_id_aux, state_aux, expl_id, fid, cur_user, the_geom, descript, result_id, dma_id, addparam)
			SELECT connec_id, conneccat_id, state, connec_id_aux, connecat_id_aux, state_aux, expl_id, fid, cur_user, the_geom, descript, result_id, dma_id, addparam
			FROM t_anl_connec;

			INSERT INTO anl_arc (arc_id, arccat_id, state, arc_id_aux, expl_id, fid, cur_user, the_geom, the_geom_p, descript, result_id, node_1, node_2, sys_type, code, cat_geom1, length, slope, total_length, z1, z2, y1, y2, elev1, elev2, losses, dma_id, presszone_id, dqa_id, minsector_id, addparam, sector_id)
			SELECT arc_id, arccat_id, state, arc_id_aux, expl_id, fid, cur_user, the_geom, the_geom_p, descript, result_id, node_1, node_2, sys_type, code, cat_geom1, length, slope, total_length, z1, z2, y1, y2, elev1, elev2, losses, dma_id, presszone_id, dqa_id, minsector_id, addparam, sector_id
			FROM t_anl_arc;

			INSERT INTO anl_polygon (pol_id, pol_type, state, expl_id, fid, cur_user, the_geom, result_id, descript)
			SELECT pol_id, pol_type, state, expl_id, fid, cur_user, the_geom, result_id, descript
			FROM t_anl_polygon;
		ELSEIF v_project_type = 'UD' THEN

			INSERT INTO anl_node (node_id, nodecat_id, state, num_arcs, node_id_aux, nodecat_id_aux, state_aux, expl_id, fid, cur_user, the_geom, arc_distance, arc_id, descript, result_id, total_distance, sys_type, code, cat_geom1, top_elev, elev, ymax, state_type, sector_id, addparam, drainzone_id, dwfzone_id)
			SELECT node_id, nodecat_id, state, num_arcs, node_id_aux, nodecat_id_aux, state_aux, expl_id, fid, cur_user, the_geom, arc_distance, arc_id, descript, result_id, total_distance, sys_type, code, cat_geom1, top_elev, elev, ymax, state_type, sector_id, addparam, drainzone_id, dwfzone_id
			FROM t_anl_node;

			INSERT INTO anl_connec (connec_id, conneccat_id, state, connec_id_aux, connecat_id_aux, state_aux, expl_id, fid, cur_user, the_geom, descript, result_id, dma_id, addparam, dwfzone_id, drainzone_id)
			SELECT connec_id, conneccat_id, state, connec_id_aux, connecat_id_aux, state_aux, expl_id, fid, cur_user, the_geom, descript, result_id, dma_id, addparam, dwfzone_id, drainzone_id
			FROM t_anl_connec;

			INSERT INTO anl_arc (arc_id, arccat_id, state, arc_id_aux, expl_id, fid, cur_user, the_geom, the_geom_p, descript, result_id, node_1, node_2, sys_type, code, cat_geom1, length, slope, total_length, z1, z2, y1, y2, elev1, elev2, dma_id, addparam, sector_id, drainzone_id, dwfzone_id)
			SELECT arc_id, arccat_id, state, arc_id_aux, expl_id, fid, cur_user, the_geom, the_geom_p, descript, result_id, node_1, node_2, sys_type, code, cat_geom1, length, slope, total_length, z1, z2, y1, y2, elev1, elev2, dma_id, addparam, sector_id, drainzone_id, dwfzone_id
			FROM t_anl_arc;

			INSERT INTO anl_polygon (pol_id, pol_type, state, expl_id, fid, cur_user, the_geom, result_id, descript)
			SELECT pol_id, pol_type, state, expl_id, fid, cur_user, the_geom, result_id, descript
			FROM t_anl_polygon;

		END IF;

	ELSIF v_returntype = 'info' THEN

		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
		FROM (
			SELECT
				ROW_NUMBER() OVER (ORDER BY criticity DESC, CASE WHEN id < 0 THEN 0 ELSE 1 END, tstamp ASC, error_message ASC) AS id,
				error_message AS message,
				criticity
			FROM (
				SELECT DISTINCT error_message, criticity, tstamp, id
				FROM t_audit_check_data
				WHERE criticity IN (
					SELECT criticity
					FROM t_audit_check_data
					WHERE error_message NOT ILIKE '%-----%' AND error_message NOT IN ('')
					GROUP BY criticity
					HAVING COUNT(*) > 1
				)
			) t
			ORDER BY id ASC
		) row;
		v_result := COALESCE(v_result, '{}');
		v_result := concat ('{"values":',v_result, '}');

	ELSIF v_returntype = 'point' THEN

	SELECT jsonb_build_object(
	    'type', 'FeatureCollection',
	    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
	) INTO v_result
	FROM (
	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
	) AS feature
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, fid, ST_Transform(the_geom, 4326) as the_geom FROM t_anl_node
	UNION
	SELECT id, connec_id, conneccat_id, state, expl_id, descript,fid, ST_Transform(the_geom, 4326) as the_geom FROM t_anl_connec
	) row) features;

	ELSIF v_returntype = 'line' THEN

	SELECT jsonb_build_object(
	    'type', 'FeatureCollection',
	    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
	) INTO v_result
	FROM (
	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
	) AS feature
	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, fid, ST_Transform(the_geom, 4326) as the_geom FROM t_anl_arc
	) row) features;

	ELSIF v_returntype = 'polygon' THEN

	SELECT jsonb_build_object(
	    'type', 'FeatureCollection',
	    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
	) INTO v_result
	FROM (
	SELECT jsonb_build_object(
	'type',       'Feature',
	'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	'properties', to_jsonb(row) - 'the_geom'
	) AS feature
	FROM (SELECT pol_id, descript, ST_Transform(the_geom, 4326) as the_geom
	FROM  t_anl_polygon WHERE cur_user="current_user"() AND fid=216) row) features;

	END IF;

	v_result := COALESCE(v_result, '{}');

	--  Return
	RETURN v_result;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;