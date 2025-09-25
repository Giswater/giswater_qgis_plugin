/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3302

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getgraphconfig(p_data json)
RETURNS json AS
$BODY$

/*

SELECT gw_fct_getgraphconfig('{"data":{"context":"OPERATIVE", "mapzone":"presszone"}}');
SELECT gw_fct_getgraphconfig('{"data":{"context":"OPERATIVE", "mapzone":"sector"}}');
SELECT gw_fct_getgraphconfig('{"data":{"context":"OPERATIVE", "mapzone":"dma"}}');

SELECT gw_fct_getgraphconfig('{"data":{"context":"NETSCENARIO", "mapzone":"dma"}}');
SELECT gw_fct_getgraphconfig('{"data":{"context":"NETSCENARIO", "mapzone":"presszone"}}');

*/

DECLARE

v_context text;
v_mapzone text;
v_mapzone_id text;
v_mapzone_name text = 'name';
v_version text;
v_error_context text;
v_querytext text;
v_querytext_add text = '';
v_querytext_end text = ' ORDER BY 2 ASC';
v_result text;
v_result_point json;
v_result_line json;
v_project_type text;


BEGIN
	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- Get version
	SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version order by id desc limit 1;

	-- Get input data
	v_context := p_data -> 'data' ->> 'context';
	v_mapzone := p_data ->'data' ->> 'mapzone';

	-- definition of mapzone layer and pkey
	IF v_context = 'OPERATIVE' THEN
		v_mapzone_id = concat(v_mapzone, '_id');
		v_mapzone = concat('v_ui_',v_mapzone);

	ELSIF v_context = 'NETSCENARIO' THEN
		v_mapzone_id = concat(v_mapzone, '_id');
		v_mapzone = concat('ve_plan_netscenario_',v_mapzone);

	END IF;

	-- POINTS:
	IF lower(v_project_type) = 'ws' THEN

		v_querytext = concat ('WITH mapzone_query as (select * from ',v_mapzone,' WHERE active)
				SELECT n.node_id::text AS feature_id, ''nodeParent''::text AS graph_type, a.',v_mapzone_id,'::integer, a.name, NULL::float  AS rotation, n.the_geom
				FROM ( SELECT (json_array_elements_text((graphconfig::json ->> ''use''::text)::json)::json ->>''nodeParent'')::integer AS node_id, ',v_mapzone_id,'::integer, ',v_mapzone_name,' FROM mapzone_query) a
				JOIN node n USING (node_id)
			UNION
				SELECT n.node_id::text AS feature_id, ''forceClosed''::text AS graph_type, a.',v_mapzone_id,'::integer, a.name,NULL AS rotation, n.the_geom
				FROM ( SELECT (json_array_elements_text((graphconfig::json ->> ''forceClosed''::text)::json))::integer AS node_id, ',v_mapzone_id,'::integer, ',v_mapzone_name,' FROM mapzone_query) a
				JOIN node n USING (node_id)
			UNION
				SELECT n.node_id::text AS feature_id,''forceOpen''::text AS graph_type, a.',v_mapzone_id,'::integer, a.name, NULL AS rotation, n.the_geom
				FROM ( SELECT (json_array_elements_text((graphconfig::json ->> ''forceOpen''::text)::json))::integer AS node_id, ',v_mapzone_id,'::integer, ',v_mapzone_name,' FROM mapzone_query) a
				JOIN node n USING (node_id)
			UNION
				SELECT node_id::text AS feature_id, ''closedValve''::text AS graph_type, ',v_mapzone_id,'::integer, ',v_mapzone_name,', NULL AS rotation, n.the_geom
				FROM ve_node n JOIN ',v_mapzone ,' USING (',v_mapzone_id,') WHERE closed_valve IS TRUE
			UNION
				SELECT arc_id::text AS feature_id, ''toArc''::text AS graph_type, mp.',v_mapzone_id,'::integer, mp.',v_mapzone_name,',
				CASE WHEN node_1 IN (SELECT (json_array_elements_text((mp.graphconfig::json ->> ''use''::text)::json)::json ->> ''nodeParent'')::integer AS node_id) THEN
					st_azimuth(st_lineinterpolatepoint(a.the_geom, 0.01), st_lineinterpolatepoint(a.the_geom, 0.02))*400/6.28
				else
					st_azimuth(st_lineinterpolatepoint(a.the_geom, 0.99), st_lineinterpolatepoint(a.the_geom, 0.98))*400/6.28
				end as rotation,
		
				CASE WHEN node_1 IN (SELECT (json_array_elements_text((mp.graphconfig::json ->> ''use''::text)::json)::json ->> ''nodeParent'')::integer AS node_id) THEN
					st_lineinterpolatepoint(a.the_geom, 0.01::double precision)
				else
					st_lineinterpolatepoint(a.the_geom, 0.99::double precision)
				end as the_geom
				FROM
				(SELECT (json_array_elements_text((json_array_elements_text((mapzone_query.graphconfig::json ->> ''use''::text)::json)::json ->> ''toArc''::text)::json))::integer AS arc_id, ',v_mapzone_id,'::integer, ',v_mapzone_name,', graphconfig
				FROM mapzone_query) mp
				JOIN arc a USING (arc_id)');

		IF v_context = 'NETSCENARIO' THEN

			v_querytext_add = concat ('
						UNION
							SELECT concat (''NS-'',v.node_id)::text AS feature_id,''netscenOpenedValve''::text AS graph_type, nd.',v_mapzone_id,'::integer, nd.name, NULL AS rotation, v.the_geom
							FROM ve_plan_netscenario_valve v
							left JOIN arc ON node_1 = node_id
							left JOIN v_plan_netscenario_arc na USING (arc_id)
							left JOIN ',v_mapzone,' nd ON nd.',v_mapzone_id,' = na.',v_mapzone_id,' WHERE v.closed IS FALSE
						UNION
							SELECT concat (''NS-'',v.node_id)::text AS feature_id,''netscenClosedValve''::text AS graph_type, 0, ''UNDEFINED'', NULL AS rotation, v.the_geom
							FROM ve_plan_netscenario_valve v  WHERE v.closed IS TRUE ');
		END IF;

		v_querytext = concat (v_querytext, v_querytext_add, v_querytext_end);

		v_querytext = concat('SELECT jsonb_agg(features.feature)
				FROM (
				SELECT jsonb_build_object(
				''type'',       ''Feature'',
				''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
				''properties'', to_jsonb(row) - ''the_geom''
				) AS feature
				FROM (', v_querytext, ') row) features');

		EXECUTE v_querytext INTO v_result;
	ELSE
		-- TODO: for ud

	END IF;

	-- profilactic nulls;
	v_result := COALESCE(v_result, '{}');
	IF v_result = '{}' THEN
		v_result_point = '{"layerName": "Graphconfig", "geometryType":"", "features":[]}';
	ELSE
		v_result_point = concat ('{"layerName": "Graphconfig", "geometryType":"Point", "features":',v_result, '}');
	END IF;

	v_result = null;
	-- LINES:
	IF lower(v_project_type) = 'ws' THEN

	ELSE
		-- TODO: for ud
	END IF;

	-- profilactic nulls;
	-- v_result := COALESCE(v_result, '{}');
	-- IF v_result = '{}' THEN
	-- 	v_result_line = '{"layerName": "Graphconfig", "geometryType":"", "features":[]}';
	-- ELSE
	-- 	v_result_line = concat ('{"layerName": "Graphconfig", "geometryType":"LineString", "features":',v_result, '}');
	-- END IF;

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
	     ',"body":{"form":{}'||
		     ',"data":{ "info":{},'||
				'"point":'||v_result_point||','||
				'"line":{},'||
				'"polygon":{}}'||
	    '}}')::json, 3302, null, null, null);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;