/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3340

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getpsectorfeatures(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getpsectorfeatures(p_data json)
RETURNS json AS
$BODY$

/*
--EXAMPLE
SELECT SCHEMA_NAME.gw_fct_getpsectorfeatures($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":SRID_VALUE},
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "psector_id":"[1, 2]"}}$$);

SELECT SCHEMA_NAME.gw_fct_getpsectorfeatures($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":SRID_VALUE},
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "psector_id":"[1]"}}$$);

*/

DECLARE

v_project_type text;
v_version text;
v_psector_id text;
v_psector_id_aux int[];
v_result json;
v_result_point json;
v_result_line json;



BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

    -- Get input data
    v_psector_id := (SELECT (p_data->>'data')::json->>'psector_id');
    v_psector_id = replace(v_psector_id , '[', '');
    v_psector_id = replace(v_psector_id , ']', '');
    v_psector_id = replace(v_psector_id , '''', '');
    SELECT string_to_array(v_psector_id , ',') into v_psector_id_aux;

    -- Get project type
    SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

    -- Get results
    -- Points
    v_result = null;
    IF v_project_type = 'WS' THEN
        SELECT jsonb_build_object(
            'type', 'FeatureCollection',
            'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
        ) INTO v_result
        FROM (
            SELECT jsonb_build_object(
                'type', 'Feature',
                'geometry', ST_AsGeoJSON(the_geom)::jsonb,
                'properties', to_jsonb(row) - 'the_geom_p'
            ) AS feature
            FROM (
                SELECT pn.node_id AS feature_id, pn.psector_id, pn.state, 'NODE' AS feature_type, ST_Transform(n.the_geom, 4326) as the_geom
                FROM plan_psector_x_node pn
                JOIN node n ON n.node_id = pn.node_id
                WHERE pn.psector_id = ANY(v_psector_id_aux)
                UNION
                SELECT pc.link_id AS feature_id, pc.psector_id, pc.state, 'CONNEC' AS feature_type, ST_Transform(c.the_geom, 4326) as the_geom
                FROM plan_psector_x_connec pc
                JOIN connec c ON c.connec_id = pc.connec_id
                WHERE pc.psector_id = ANY(v_psector_id_aux)
            ) row
        ) features;
    ELSIF v_project_type = 'UD' THEN
        SELECT jsonb_build_object(
            'type', 'FeatureCollection',
            'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
        ) INTO v_result
        FROM (
            SELECT jsonb_build_object(
                'type', 'Feature',
                'geometry', ST_AsGeoJSON(the_geom)::jsonb,
                'properties', to_jsonb(row) - 'the_geom_p'
            ) AS feature
            FROM (
                SELECT pn.node_id AS feature_id, pn.psector_id, pn.state, 'NODE' AS feature_type, ST_Transform(n.the_geom, 4326) as the_geom
                FROM plan_psector_x_node pn
                JOIN node n ON n.node_id = pn.node_id
                WHERE pn.psector_id = ANY(v_psector_id_aux)
                UNION
                SELECT pc.link_id AS feature_id, pc.psector_id, pc.state, 'CONNEC' AS feature_type, ST_Transform(c.the_geom, 4326) as the_geom
                FROM plan_psector_x_connec pc
                JOIN connec c ON c.connec_id = pc.connec_id
                WHERE pc.psector_id = ANY(v_psector_id_aux)
                UNION
                SELECT pg.gully_id AS feature_id, pg.psector_id, pg.state, 'GULLY' AS feature_type, ST_Transform(g.the_geom, 4326) as the_geom
                FROM plan_psector_x_gully pg
                JOIN gully g ON g.gully_id = pg.gully_id
                WHERE pg.psector_id = ANY(v_psector_id_aux)
            ) row
        ) features;
    END IF;

    v_result_point := v_result;

    -- Lines
    v_result = null;
    SELECT jsonb_build_object(
        'type', 'FeatureCollection',
        'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
    ) INTO v_result
    FROM (
        SELECT jsonb_build_object(
            'type', 'Feature',
            'geometry', ST_AsGeoJSON(the_geom)::jsonb,
            'properties', to_jsonb(row) - 'the_geom'
        ) AS feature
        FROM (
            SELECT pa.arc_id AS feature_id, pa.psector_id, pa.state, 'ARC' AS feature_type, ST_Transform(a.the_geom, 4326) as the_geom
            FROM plan_psector_x_arc pa
            JOIN arc a ON a.arc_id = pa.arc_id
            WHERE pa.psector_id = ANY(v_psector_id_aux)
            UNION
            SELECT ppxc.link_id AS feature_id, ppxc.psector_id, ppxc.state, 'LINK' AS feature_type, ST_Transform(l.the_geom, 4326) as the_geom
            FROM plan_psector_x_connec ppxc
            JOIN link l ON l.link_id = ppxc.link_id
            WHERE ppxc.psector_id = ANY(v_psector_id_aux)
        ) row
    ) features;

    v_result_line := v_result;

    -- Control nulls
    v_result_point := COALESCE(v_result_point, '{}');
    v_result_line := COALESCE(v_result_line, '{}');


	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Psector done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{"point":'||v_result_point||','||
				'"line":'||v_result_line||
		       '}}'||
	    '}')::json, 3340, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
