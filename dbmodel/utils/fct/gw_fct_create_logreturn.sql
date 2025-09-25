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

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	-- get input parameters
	v_returntype := ((p_data->>'data')::json->>'parameters')::json->>'type';
	v_querytext := ((p_data->>'data')::json->>'parameters')::json->>'queryText';

	v_result = NULL;
	IF v_returntype = 'fillExcepTables' THEN -- delete and insert on anl tables

		DELETE FROM audit_check_data WHERE fid in (select fid from t_audit_check_data) and cur_user=current_user;
		INSERT INTO audit_check_data SELECT * FROM t_audit_check_data;

		DELETE FROM anl_node WHERE fid in (select fid from t_anl_node) and cur_user=current_user;
		INSERT INTO anl_node SELECT * FROM t_anl_node;

		DELETE FROM anl_connec WHERE fid in (select fid from t_anl_connec) and cur_user=current_user;
		INSERT INTO anl_connec SELECT * FROM t_anl_connec;

		DELETE FROM anl_arc WHERE fid in (select fid from t_anl_arc) and cur_user=current_user;
		INSERT INTO anl_arc SELECT * FROM t_anl_arc;

		DELETE FROM anl_polygon WHERE fid in (select fid from t_anl_polygon) and cur_user=current_user;
		INSERT INTO anl_polygon SELECT * FROM t_anl_polygon;

	ELSIF v_returntype = 'info' THEN

		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
		FROM (
			SELECT 
				ROW_NUMBER() OVER (ORDER BY criticity DESC, error_message ASC) AS id,
				error_message AS message,
				criticity
			FROM (
				SELECT DISTINCT error_message, criticity
				FROM t_audit_check_data
			) t
			ORDER BY criticity DESC, message ASC
		) row;
		v_result := COALESCE(v_result, '{}');
		v_result := concat ('{"geometryType":"", "values":',v_result, '}');

	ELSIF v_returntype = 'point' THEN

		SELECT jsonb_agg(features.feature) INTO v_result
		FROM (
		SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, fid, the_geom FROM t_anl_node
		UNION
		SELECT id, connec_id, conneccat_id, state, expl_id, descript,fid, the_geom FROM t_anl_connec
		) row) features;
		v_result := COALESCE(v_result, '{}');
		v_result := concat ('{"geometryType":"Point", "features":',v_result,'}');

	ELSIF v_returntype = 'line' THEN

		SELECT jsonb_agg(features.feature) INTO v_result
		FROM (
		SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, fid, the_geom FROM t_anl_arc
		) row) features;
		v_result := COALESCE(v_result, '{}');
		v_result = concat ('{"geometryType":"LineString", "features":',v_result,'}');

	ELSIF v_returntype = 'polygon' THEN

		SELECT jsonb_agg(features.feature) INTO v_result
		FROM (
		SELECT jsonb_build_object(
		'type',       'Feature',
		'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (SELECT pol_id, descript, the_geom
		FROM  t_anl_polygon WHERE cur_user="current_user"() AND fid=216) row) features;
		v_result := COALESCE(v_result, '{}');
		v_result := concat ('{"geometryType":"MultiPolygon", "features":',v_result,'}');

	END IF;

	v_result := COALESCE(v_result, '{}');

	--  Return
	RETURN v_result;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;