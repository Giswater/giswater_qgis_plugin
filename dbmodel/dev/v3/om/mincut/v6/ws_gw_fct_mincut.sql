/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2304

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setmincut(p_data JSON)
RETURNS JSON AS
$BODY$

/*EXAMPLE

-- parameters explain
epsg: integer (optional)
cur_user: string (optional)
device: integer (optional)
tiled: boolean (optional)

xcoord: float (optional)
ycoord: float (optional)
zoomRatio: float (optional)

action: string in [mincutNetwork, mincutValveUnaccess, mincutAccept, mincutCancel, mincutDelete] (mandatory)
mincutId: integer (mandatory)
arcId: integer (optional)
nodeId: integer (optional)
usePsectors: boolean (mandatory)


SELECT gw_fct_setmincut($${
	"client":{
		"device":4,
		"lang":"es_ES",
		"version":"4.0.001",
		"infoType":1,
		"epsg":25831
		"cur_user":"admin"
	},
	"coordinates":{
		"xcoord":100000,
		"ycoord":100000,
		"zoomRatio":1
	},
	"data":{
		"parameters":{
			"action":"mincutNetwork",
			"mincutId":"3",
			"arcId":"2001",
			"usePsectors":"False"
		}
	}
}$$);

-- fid: XXX

*/

DECLARE

-- SECTION 01: Variables

-- parameters
v_client_epsg varchar;
v_cur_user varchar;
v_device integer;
v_tiled boolean;
v_mincut integer;
v_mincut_class integer;
v_node integer;
v_arc integer;
v_use_psectors boolean;

-- coordinates parameters
v_xcoord float;
v_ycoord float;
v_zoomratio float;

-- config parameters
v_epsg integer;
v_mincut_version integer;
v_vdefault json;
v_sensibility_f float;

-- extra variables
v_point geometry;
v_connec integer;
v_query_text text;

-- controls
v_version varchar;
v_srid integer;
v_project_type varchar;

-- result variables
v_result jsonb;
v_result_init jsonb;
v_result_valve jsonb;
v_result_node jsonb;
v_result_connec jsonb;
v_result_arc jsonb;

-- !SECTION

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- Get project version
	SELECT giswater, epsg, UPPER(project_type) INTO v_version, v_srid, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
	-- client parameters
	v_client_epsg := (SELECT ((p_data ->> 'client')::json->>'epsg')::varchar);
	v_cur_user := (SELECT ((p_data ->> 'client')::json->> 'cur_user')::varchar);
	v_device := (SELECT ((p_data ->> 'client')::json ->> 'device')::integer);
	v_tiled := (SELECT ((p_data ->>'client')::json->>'tiled')::boolean);

	-- data parameters
	v_mincut := (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'mincutId')::integer;
	v_mincut_class := (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'mincutClass')::integer;
	v_node := (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'nodeId')::integer;
	v_arc := (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'arcId')::integer;
	v_use_psectors := (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePsectors')::boolean;


	-- coordinates parameters
	v_xcoord := (SELECT ((p_data::json->>'data')::json->>'coordinates')::json->>'xcoord');
	v_ycoord := (SELECT ((p_data::json->>'data')::json->>'coordinates')::json->>'ycoord');
	v_zoomratio := (SELECT ((p_data::json->>'data')::json->>'coordinates')::json->>'zoomRatio');

	-- config parameters
	v_epsg := (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);
	v_mincut_version := (SELECT value::json->>'version' FROM config_param_system WHERE parameter = 'om_mincut_config');
	v_vdefault := (SELECT value::json FROM config_param_system WHERE parameter = 'om_mincut_vdefault');
	v_sensibility_f := (SELECT value::float FROM config_param_system WHERE parameter = 'basic_info_sensibility_factor');

	-- controls
	IF v_client_epsg IS NULL THEN v_client_epsg = v_epsg; END IF;
	IF v_cur_user IS NULL THEN v_cur_user = current_user; END IF;

	-- get arc_id from click
	IF v_xcoord IS NOT NULL THEN
		v_sensibility = (v_zoomratio / 500 * v_sensibility_f);

		-- Make point
		SELECT ST_Transform(ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_client_epsg),v_epsg) INTO v_point;

		SELECT arc_id INTO v_arc FROM ve_arc WHERE ST_DWithin(the_geom, v_point,v_sensibility) LIMIT 1;

		IF v_arc IS NULL THEN
			SELECT connec_id INTO v_connec FROM ve_connec WHERE ST_DWithin(the_geom, v_point,v_sensibility) LIMIT 1;
		END IF;
	END IF;

	IF v_action NOT IN ('mincutNetwork', 'mincutValveUnaccess', 'mincutAccept', 'mincutCancel', 'mincutDelete') THEN
		RAISE EXCEPTION 'Invalid action: %', v_action;
	END IF;


	/*
		v_action:
			mincutNetwork
			mincutValveUnaccess
			mincutAccept
			mincutCancel
			mincutDelete

	*/


	-- SECTION[epic=mincut]: Build GeoJSON
	IF v_device = 5 THEN
		-- v_om_mincut
		v_result_init := jsonb_build_object(
			'type', 'FeatureCollection',
			'features', COALESCE((
				SELECT jsonb_agg(features.feature)
				FROM (
					SELECT jsonb_build_object(
						'type', 'Feature',
						'geometry', ST_AsGeoJSON(ST_Transform(anl_the_geom, 4326))::jsonb,
						'properties', to_jsonb(row) - 'anl_the_geom'
					) AS feature
					FROM (
						SELECT id, anl_the_geom
						FROM v_om_mincut
					) row
				) features
			), '[]'::jsonb)
		);

		-- v_om_mincut_valve
		v_result_valve := jsonb_build_object(
			'type', 'FeatureCollection',
			'features', COALESCE((
				SELECT jsonb_agg(features.feature)
				FROM (
					SELECT jsonb_build_object(
						'type', 'Feature',
						'geometry', ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
						'properties', to_jsonb(row) - 'the_geom'
					) AS feature
					FROM (
						SELECT id, the_geom
						FROM v_om_mincut_valve
					) row
				) features
			), '[]'::jsonb)
		);

		-- v_om_mincut_node
		v_result_node := jsonb_build_object(
			'type', 'FeatureCollection',
			'features', COALESCE((
				SELECT jsonb_agg(features.feature)
				FROM (
					SELECT jsonb_build_object(
						'type', 'Feature',
						'geometry', ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
						'properties', to_jsonb(row) - 'the_geom'
					) AS feature
					FROM (
						SELECT id, the_geom
						FROM v_om_mincut_node
					) row
				) features
			), '[]'::jsonb)
		);

		-- v_om_mincut_connec
		v_result_connec := jsonb_build_object(
			'type', 'FeatureCollection',
			'features', COALESCE((
				SELECT jsonb_agg(features.feature)
				FROM (
					SELECT jsonb_build_object(
						'type', 'Feature',
						'geometry', ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
						'properties', to_jsonb(row) - 'the_geom'
					) AS feature
					FROM (
						SELECT id, the_geom
						FROM v_om_mincut_connec
					) row
				) features
			), '[]'::jsonb)
		);

		-- v_om_mincut_arc
		v_result_arc := jsonb_build_object(
			'type', 'FeatureCollection',
			'features', COALESCE((
				SELECT jsonb_agg(features.feature)
				FROM (
					SELECT jsonb_build_object(
						'type', 'Feature',
						'geometry', ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
						'properties', to_jsonb(row) - 'the_geom'
					) AS feature
					FROM (
						SELECT id, arc_id, the_geom
						FROM v_om_mincut_arc
					) row
				) features
			), '[]'::jsonb)
		);
	END IF;

	-- SECTION[epic=mincut]: Controll Nulls
	v_message = COALESCE(v_message, '{}');
	v_version = COALESCE(v_version, '');
	v_mincut = COALESCE(v_mincut, 0);
	v_result_info = COALESCE(v_result_info, '{}');
	v_result_point = COALESCE(v_result_point, '{}');
	v_result_line = COALESCE(v_result_line, '{}');
	v_result_polygon = COALESCE(v_result_polygon, '{}');
	v_level = COALESCE(v_level, 0);
	v_netscenario = COALESCE(v_netscenario, '');

	-- SECTION[epic=mincut]: Return result
		v_response := jsonb_build_object(
			'status', 'Accepted',
			'message', v_message,
			'version', v_version,
			'body', jsonb_build_object(
				'form', jsonb_build_object(),
				'feature', jsonb_build_object(),
				'data', jsonb_build_object(
					'mincutId', v_mincut,
					'mincutInit', v_result_init,
					'valve', v_result_valve,
					'mincutNode', v_result_node,
					'mincutConnec', v_result_connec,
					'mincutArc', v_result_arc,
					'tiled', v_tiled
				)
			)
		);
		return v_response;


	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
	',"body":{"form":{}'||
			',"data":{ '||
			'  "info":'||v_result_info||
			', "geometry":"'||v_geometry||'"'||
			', "mincutDetails":'||v_mincutdetails||'}'||
			'}'
	'}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;