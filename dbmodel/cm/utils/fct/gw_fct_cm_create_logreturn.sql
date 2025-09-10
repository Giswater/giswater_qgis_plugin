/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3430

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_create_logreturn(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
SELECT gw_fct_cm_create_logreturn($${"data":{"parameters":{"type":"info"}}}$$);
SELECT gw_fct_cm_create_logreturn($${"data":{"parameters":{"type":"point"}}}$$);
SELECT gw_fct_cm_create_logreturn($${"data":{"parameters":{"type":"line"}}}$$);
SELECT gw_fct_cm_create_logreturn($${"data":{"parameters":{"type":"polygon"}}}$$);
*/

DECLARE
v_schemaname text;
v_result json;
v_returntype text;
v_querytext text;
v_rec record;
v_prev_search_path text;

BEGIN

	-- search path (transaction-local)
	v_prev_search_path := current_setting('search_path');
	PERFORM set_config('search_path', 'cm,public', true);
	v_schemaname = 'cm';

	-- get input parameters
	v_returntype := ((p_data->>'data')::json->>'parameters')::json->>'type';
	v_querytext := ((p_data->>'data')::json->>'parameters')::json->>'queryText';

	v_result = NULL;

	IF v_returntype = 'fillExcepTables' THEN
		DELETE FROM audit_check_data WHERE fid in (select fid from t_audit_check_data) and cur_user=current_user;
		INSERT INTO audit_check_data SELECT * FROM t_audit_check_data;

	ELSIF v_returntype = 'info' THEN

		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
		FROM (SELECT id, error_message as message FROM t_audit_check_data order by criticity desc, id asc) row;
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
		FROM (SELECT node_id, nodecat_id, expl_id, descript, fid, the_geom FROM t_cm_node
		UNION
		SELECT connec_id, conneccat_id, expl_id, descript,fid, the_geom FROM t_cm_connec
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
	PERFORM set_config('search_path', v_prev_search_path, true);
	RETURN v_result;

EXCEPTION WHEN OTHERS THEN
	PERFORM set_config('search_path', v_prev_search_path, true);
	RAISE;
END;

$function$
;

-- Permissions

ALTER FUNCTION cm.gw_fct_cm_create_logreturn(json) OWNER TO postgres;
GRANT ALL ON FUNCTION cm.gw_fct_cm_create_logreturn(json) TO public;
GRANT ALL ON FUNCTION cm.gw_fct_cm_create_logreturn(json) TO postgres;
GRANT ALL ON FUNCTION cm.gw_fct_cm_create_logreturn(json) TO role_basic;
