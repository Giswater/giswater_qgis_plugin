/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
-- The code of this have been received helpfull assistance from Enric Amat (FISERSA) and Claudia Dragoste (Aigües de Girona SA)

--FUNCTION CODE: 2214

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_flow_exit (character varying);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_flow_exit (json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_graphanalytics_downstream(p_data json)
RETURNS json AS $BODY$

/*
example:
SELECT SCHEMA_NAME.gw_fct_graphanalytics_downstream($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"id":["20607"]},
"data":{}}$$);


SELECT SCHEMA_NAME.gw_fct_graphanalytics_downstream($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},
"data":{ "coordinates":{"xcoord":419277.7306855297,"ycoord":4576625.674511955, "zoomRatio":3565.9967217571534}}}$$)

--fid: upstream:220/downstream:221;

*/
DECLARE

v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result text;
v_version text;

v_debug boolean;
v_error_context text;
v_audit_result text;

v_level integer;
v_status text;
v_message text;

v_project_type text;
v_node integer;
v_point public.geometry;
v_sensibility_f float;
v_sensibility float;
v_zoomratio float;
v_fid integer;
v_device integer;
v_xcoord float;
v_ycoord float;
v_epsg integer;
v_client_epsg integer;

v_query text;
v_source text;
v_target text;
v_distance int;
v_mainstream text;
v_diverted_flow text;
v_context text;

v_symbology int;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	v_device := (p_data ->> 'client')::json->> 'device';
	v_xcoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'xcoord';
	v_ycoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'ycoord';
	v_epsg := (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);
	v_client_epsg := (p_data ->> 'client')::json->> 'epsg';
	v_zoomratio := ((p_data ->> 'data')::json->> 'coordinates')::json->>'zoomRatio';
	v_node = json_array_elements_text(json_extract_path_text(p_data,'feature','id')::json)::integer;

	v_context = 'Flow exit';
	v_fid = 221;
	v_symbology = 2214;

	-- pgrouting
	v_source= 'node_1';
	v_target= 'node_2';
	v_mainstream = 'mainstream';
	v_diverted_flow = 'diverted flow';

	IF v_client_epsg IS NULL THEN v_client_epsg = v_epsg; END IF;

	-- select config values
	SELECT giswater, upper(project_type) INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	--Look for closest node using coordinates
	IF v_node IS NULL THEN
		EXECUTE 'SELECT (value::json->>''web'')::float FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;
		v_sensibility = (v_zoomratio / 500 * v_sensibility_f);

		-- Make point
		SELECT ST_Transform(ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_client_epsg),v_epsg) INTO v_point;
		SELECT node_id INTO v_node FROM ve_node WHERE ST_DWithin(the_geom, v_point,v_sensibility) LIMIT 1;
		IF v_node IS NULL THEN
			SELECT node_2 INTO v_node FROM ve_arc WHERE ST_DWithin(the_geom, v_point, 100)  order by st_distance (the_geom, v_point) LIMIT 1;
		END IF;
	END IF;

	v_result := COALESCE(v_result, '{}');
	v_result_info := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result_info, '}');

	-- create temp tables
	DROP TABLE IF EXISTS t_anl_arc;
	DROP TABLE IF EXISTS t_anl_node;
	CREATE TEMP TABLE t_anl_arc (LIKE anl_arc INCLUDING ALL);
	CREATE TEMP TABLE t_anl_node (LIKE anl_node INCLUDING ALL);

	-- mainstream + diverted flow
	v_query = '
		WITH 
			arc_selected AS (
				SELECT a.arc_id, a.node_1, a.node_2
				FROM ve_arc a
				WHERE a.node_1 IS NOT NULL 
				AND a.node_2 IS NOT NULL 
				AND a.state > 0 
				AND a.is_operative = TRUE
			)
		SELECT 
			a.arc_id::int AS id, '||v_source||'::int AS source, '||v_target||'::int AS target,
			1 as cost, -1 as reverse_cost
			FROM arc_selected a
	';

	EXECUTE 'select count(*)::int from ve_arc'
	INTO v_distance;

	INSERT INTO t_anl_node (node_id, fid, nodecat_id, state, expl_id, drainzone_id, addparam, the_geom)
	SELECT n.node_id, v_fid, n.node_type, n.state, n.expl_id, n.drainzone_id, v_diverted_flow, n.the_geom
	FROM (
		SELECT node
		FROM pgr_drivingdistance(v_query, v_node, v_distance)
	) p
	JOIN ve_node n ON n.node_id =p.node;

	-- mainstream
	v_query = '
		WITH 
			arc_selected AS (
				SELECT a.arc_id, a.node_1, a.node_2
				FROM ve_arc a
				WHERE a.node_1 IS NOT NULL 
				AND a.node_2 IS NOT NULL 
				AND a.state > 0 
				AND a.is_operative = TRUE
				AND a.initoverflowpath IS DISTINCT FROM TRUE
				AND EXISTS (
					SELECT 1 FROM t_anl_node an 
					WHERE an.fid = '''||v_fid||'''
					AND an.node_id = a.'||v_source||'::text
				)
			)
		SELECT 
			a.arc_id::int AS id, '||v_source||'::int AS source, '||v_target||'::int AS target,
			1 as cost, -1 as reverse_cost
			FROM arc_selected a
	';

	UPDATE t_anl_node n set addparam = v_mainstream
	FROM (
		SELECT node
		FROM pgr_drivingdistance(v_query, v_node, v_distance)
	) p
	WHERE n.node_id::int4 = p.node;

	INSERT INTO t_anl_arc (arc_id, fid, arccat_id, state, expl_id, drainzone_id, addparam, the_geom)
	SELECT a.arc_id, v_fid, a.arc_type, a.state, a.expl_id, a.drainzone_id, n2.addparam, a.the_geom
	FROM ve_arc a
	JOIN t_anl_node n1 ON a.node_1::text = n1.node_id
	JOIN t_anl_node n2 ON a.node_2::text = n2.node_id;

	v_result_line := jsonb_build_object(
		'type', 'FeatureCollection',
		'layerName', 'Flowtrace arc',
		'features', COALESCE((
			SELECT jsonb_agg(features.feature)
			FROM (
				SELECT jsonb_build_object(
					'type',       'Feature',
					'geometry',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
					'properties', to_jsonb(row) - 'the_geom'
				) AS feature
				FROM (SELECT v_context as context, expl_id, arc_id, state, arccat_id as arc_type, 'ARC' AS feature_type, drainzone_id, addparam as stream_type, st_length(the_geom) as length, ST_Transform(the_geom, 4326) as the_geom
				FROM t_anl_arc) row
			) features
		), '[]'::jsonb)
	)::text;

	v_result_point := jsonb_build_object(
		'type', 'FeatureCollection',
		'layerName', 'Flowtrace node',
		'features', COALESCE((
			SELECT jsonb_agg(features.feature)
			FROM (
				SELECT jsonb_build_object(
					'type',       'Feature',
					'geometry',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
					'properties', to_jsonb(row) - 'the_geom'
				) AS feature
				FROM (SELECT v_context as context, expl_id, node_id as feature_id, state, nodecat_id as feature_type, 'NODE' AS feature_type, drainzone_id, addparam as stream_type, ST_Transform(the_geom, 4326) as the_geom
				FROM  t_anl_node
				UNION
				SELECT v_context as context, c.expl_id, c.connec_id::text, c.state, c.connec_type, 'CONNEC' as feature_type, c.drainzone_id, a.addparam as stream_type, ST_Transform(c.the_geom, 4326) as the_geom
				FROM t_anl_arc a JOIN ve_connec c ON c.arc_id::text = a.arc_id
				WHERE c.state > 0
				AND c.is_operative = TRUE
				UNION
				SELECT v_context as context, g.expl_id, g.gully_id::text, g.state, g.gully_type, 'GULLY' as feature_type, g.drainzone_id, a.addparam as stream_type, ST_Transform(g.the_geom, 4326) as the_geom
				FROM t_anl_arc a JOIN ve_gully g ON g.arc_id::text = a.arc_id
				WHERE g.state > 0
				AND g.is_operative = TRUE) row
			) features
		), '[]'::jsonb)
	)::text;

	v_result_polygon = '{}';

	v_status = 'Accepted';
	v_level = 3;
	v_message = 'Flow  analysis done succesfully';

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
				   ',"body":{"form":{}'||
				   ',"data":{ "info":'||v_result_info||','||
				      '"initPoint":'||v_node||','||
					  '"point":'||v_result_point||','||
					  '"line":'||v_result_line||','||
					  '"polygon":'||v_result_polygon||'}'||
					 '}'
		'}')::json, v_symbology, null, null, null);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
