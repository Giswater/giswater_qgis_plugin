/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Claudia Dragoste (Aigues de Manresa, S.A.)

--FUNCTION CODE: 2710

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_mapzones(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_mapzones_v1(p_data json)
RETURNS json AS
$BODY$

/* Example usage:

-- QUERY SAMPLE
SELECT gw_fct_graphanalytics_mapzones('
{
	"data":{
		"parameters":{
			"graphClass":"DRAINZONE",
			"exploitation":[1],
			"macroExploitation":[1],
			"commitChanges":true,
			"updateMapZone":2,
			"geomParamUpdate":15,
			"usePlanPsector":false,
			"forceOpen":[1,2,3],
			"forceClosed":[2,3,4]
		}
	}
}');
SELECT gw_fct_graphanalytics_mapzones('
{
	"data":{
		"parameters":{
			"graphClass":"PRESSZONE",
			"exploitation":[1,2],
			"commitChanges":true,
			"updateMapZone":2,
			"geomParamUpdate":15,
			"usePlanPsector":false
		}
	}
}');

Query to visualize arcs with their geometries:

SELECT p.*, a.the_geom
FROM temp_pgr_arc p JOIN arc a ON p.arc_id = a.arc_id
WHERE p.pgr_arc_id = p.arc_id::INT;

Query to visualize nodes with their geometries:

SELECT p.*, n.the_geom FROM temp_pgr_node p
JOIN node n ON p.node_id = n.node_id
WHERE p.pgr_node_id = p.node_id::INT;

Query to calculate the factor for adding/subtracting flow in a DMA:

SELECT a.zone_id AS dma_id, d.name, d.descript, n.zone_id AS node_zone_id,
CASE WHEN n.zone_id = a.zone_id THEN 1 ELSE -1 END AS flow_sign, n.node_id
FROM temp_pgr_node n
JOIN temp_pgr_arc a ON n.node_id IN (a.node_1, a.node_2)
JOIN dma d ON d.dma_id = a.zone_id::INT
WHERE n.graph_delimiter = 'dma' AND a.zone_id::INT > 0 AND a.pgr_arc_id = a.arc_id::INT AND n.pgr_node_id = n.node_id::INT
ORDER BY a.zone_id, n.zone_id;
*/

DECLARE


	-- system variables
	v_version TEXT;
	v_srid INTEGER;
	v_project_type TEXT;

	v_fid integer;

	v_islastupdate BOOLEAN;

	-- dialog variables
	v_class text;
	v_expl_id text;
	v_macroexpl json;
	v_floodonlymapzone text;
	v_valuefordisconnected integer;
	v_updatemapzgeom integer = 0;
	v_geomparamupdate float;
	v_usepsector boolean;
	v_parameters json;
	v_commitchanges boolean;
	v_checkdata text;  -- FULL / PARTIAL / NONE
	v_dscenario_valve text;
	v_netscenario text;

	--
	v_audit_result text;
	v_has_conflicts boolean = false;


	v_mapzone_name text;
	v_mapzone_field text;
	v_pgr_distance integer;
	v_pgr_root_vids int[];

	v_level integer;
	v_status text;
	v_message text;

	v_querytext text;
	v_data json;

	v_result text;
	v_result_info json;
	v_result_point json;
	v_result_line json;
	v_result_polygon json;

	v_response JSON;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
	SELECT giswater, epsg, UPPER(project_type) INTO v_version, v_srid, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;
	SELECT value::boolean INTO v_islastupdate FROM config_param_system WHERE parameter='edit_mapzones_set_lastupdate';

	-- Get variables from input JSON
	v_class = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'graphClass');
	v_expl_id = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_macroexpl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'macroExploitation');
	v_floodonlymapzone = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'floodOnlyMapzone');
	v_valuefordisconnected = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'valueForDisconnected');
	v_updatemapzgeom = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_geomparamupdate = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');
	v_usepsector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePlanPsector');
	v_parameters = (SELECT ((p_data::json->>'data')::json->>'parameters'));
	v_commitchanges = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'commitChanges');
	v_checkdata = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'checkData');
	v_dscenario_valve = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'dscenario_valve');
	v_netscenario = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'netscenario');

	-- profilactic controls
	IF v_dscenario_valve = '' THEN v_dscenario_valve = NULL; END IF;
	IF v_netscenario = '' THEN v_netscenario = NULL; END IF;
	IF v_floodonlymapzone = '' THEN v_floodonlymapzone = NULL; END IF;
    v_floodonlymapzone := TRIM(BOTH '[]' FROM v_floodonlymapzone);

	IF v_class = 'PRESSZONE' THEN
		v_fid=146;
	ELSIF v_class = 'DMA' THEN
		v_fid=145;
	ELSIF v_class = 'DQA' THEN
		v_fid=144;
	ELSIF v_class = 'SECTOR' THEN
		v_fid=130;
	ELSIF v_class = 'DRAINZONE' THEN
		v_fid=481;
	ELSE
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3090", "function":"2710","debug_msg":null, "is_process":true}}$$);' INTO v_audit_result;
	END IF;

	-- Create temporary tables
	-- =======================
	v_data := '{"data":{"fct_name":"'|| v_class ||'"}}';
	SELECT gw_fct_graphanalytics_create_temptables(v_data) INTO v_response;
	-- temp_anl_arc -> temp_pgr_arc
	-- temp_anl_node -> temp_pgr_node
	-- temp_anl_connec -> temp_pgr_connec
	-- temp_audit_check_data -> temp_audit_check_data

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	v_mapzone_name = LOWER(v_class);

	-- Initialize process
	-- =======================
	v_data := '{"data":{"expl_id":"' || v_expl_id || '"}}';
    SELECT gw_fct_graphanalytics_initnetwork(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;


	IF v_project_type = 'WS' THEN
		UPDATE temp_pgr_node t SET graph_delimiter = lower(cf.graph_delimiter)
		FROM node n 
		JOIN cat_node cn ON cn.id=n.nodecat_id
		JOIN cat_feature_node cf ON cf.id=cn.nodetype_id
		WHERE t.node_id=n.node_id AND cf.graph_delimiter='MINSECTOR';

		-- UPDATE "closed", "broken", "to_arc" only if the values make sense - check the explanations/rules for the possible valve scenarios MINSECTOR/to_arc/closed/broken 
		-- valves to modify: 
		-- closed valves
		UPDATE temp_pgr_node n SET closed = v.closed, broken = v.broken, modif = TRUE
		FROM man_valve v 
		WHERE n.node_id = v.node_id AND n.graph_delimiter = 'minsector' AND v.closed = TRUE;

		--valves with to_arc NOT NULL
		UPDATE temp_pgr_node n SET to_arc = v.to_arc, broken = v.broken, modif = TRUE
		FROM man_valve v
		WHERE n.node_id = v.node_id  AND v.to_arc IS NOT NULL AND v.broken = FALSE;

		-- arcs to modify:
		-- for the closed valves when to_arc IS NULL, one of the arcs that connect to the valve 
		UPDATE temp_pgr_arc t set modif=true
		FROM
		(SELECT DISTINCT ON (n.node_id) n.node_id, a.arc_id
		FROM temp_pgr_node n
		join temp_pgr_arc a ON n.node_id IN (a.node_1, a.node_2)
		WHERE n.modif = TRUE AND n.to_arc IS NULL
		) a
		WHERE t.arc_id = a.arc_id;

		-- for the valves with to_arc NOT NULL; 
		UPDATE temp_pgr_arc a SET modif = TRUE
		FROM temp_pgr_node n
		WHERE a.arc_id = n.to_arc
		-- AND n.modif = TRUE AND n.to_arc IS NOT NULL -- not necessaries
		;

	-- cost/reverse_cost for the open valves with to_arc will be update after gw_fct_graphanalytics_arrangenetwork with the correct values
	END IF;

	-- get mapzone field name
    v_mapzone_field = v_mapzone_name || '_id';

	-- Nodes forceClosed
    v_querytext =
		'UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = ''forceClosed'' 
		FROM (
			SELECT json_array_elements_text((graphconfig->>''forceClosed'')::json) AS node_id
			FROM ' || v_mapzone_name || ' 
			WHERE graphconfig IS NOT NULL 
			AND active IS TRUE
		) s 
		WHERE n.node_id = s.node_id';
    EXECUTE v_querytext;

	-- Arcs forceClosed - all arcs that are connected to forceClosed nodes
    v_querytext =
		'UPDATE temp_pgr_arc a SET modif = TRUE 
		FROM temp_pgr_node n
		WHERE n.node_id IN (a.node_1, a.node_2) 
		AND n.graph_delimiter = ''forceClosed''';
    EXECUTE v_querytext;

	-- Nodes that are the starting points of mapzones
    v_querytext =
		'UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = ''' || v_mapzone_name || ''', zone_id = ' || v_mapzone_field || '
		FROM (
			SELECT ' || v_mapzone_field || ', (json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'' AS node_id
			FROM ' || v_mapzone_name || ' 
			WHERE graphconfig IS NOT NULL 
			AND active IS TRUE
		) AS s 
		WHERE s.node_id <> '''' AND n.node_id = s.node_id';
    EXECUTE v_querytext;

	-- Disconnect the InletArc (those that are not to_arc)
    v_querytext =
		'UPDATE temp_pgr_arc a SET modif = TRUE
		FROM (
			SELECT a.arc_id, n.node_id
			FROM temp_pgr_node n
			JOIN temp_pgr_arc a ON n.node_id IN (a.node_1, a.node_2) 
			AND n.graph_delimiter = ''' || v_mapzone_name || '''
			LEFT JOIN (
				SELECT json_array_elements_text(((json_array_elements_text((graphconfig->>''use'')::json))::json->>''toArc'')::json) AS to_arc
				FROM ' || v_mapzone_name || ' 
				WHERE graphconfig IS NOT NULL 
				AND active IS TRUE
			) sa ON sa.to_arc = a.arc_id
			WHERE sa.to_arc IS NULL
		) s
		WHERE a.arc_id = s.arc_id';
	EXECUTE v_querytext;

	-- Nodes "ignore", should not be disconnected
    v_querytext =
		'UPDATE temp_pgr_node n SET modif = FALSE, graph_delimiter = ''ignore'' 
		FROM (
			SELECT json_array_elements_text((graphconfig->>''ignore'')::json) AS node_id
			FROM ' || v_mapzone_name || ' 
			WHERE graphconfig IS NOT NULL 
			AND active IS TRUE 
		) s 
		WHERE n.node_id = s.node_id';
    EXECUTE v_querytext;

	-- Generate new arcs and disconnect arcs with modif = TRUE
	-- =======================
    SELECT gw_fct_graphanalytics_arrangenetwork() INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Update the cost/reverse_cost with the correct values for the open valves with to_arc NOT NULL 
	-- and graph_delimiter 'minsector' or null (it wasn't changed for 'forceClosed' for example)
	-- Note: node_1 = node_2 for the new arcs generated at the nodes
    IF v_project_type = 'WS' THEN
        UPDATE temp_pgr_arc a SET cost = 1
		FROM temp_pgr_node n
        WHERE a.node_1 = n.node_id AND n.pgr_node_id = n.node_id::INT 
		AND a.cost = -1 AND (a.graph_delimiter = 'minsector' OR a.graph_delimiter is null) 
		AND n.to_arc IS NOT NULL AND n.closed is null 
		AND a.pgr_node_1=a.node_1::INT;

        UPDATE temp_pgr_arc a SET reverse_cost = 1
		FROM temp_pgr_node n
        WHERE a.node_1 = n.node_id AND n.pgr_node_id = n.node_id::INT 
		AND a.cost = -1 AND (a.graph_delimiter = 'minsector' OR a.graph_delimiter is null) 
		AND n.to_arc IS NOT NULL AND n.closed is null 
		AND pgr_node_2 = node_2::INT;
    END IF;

    EXECUTE 'SELECT COUNT(*)::INT FROM temp_pgr_arc'
    INTO v_pgr_distance;

	EXECUTE 'SELECT array_agg(pgr_node_id)::INT[] 
			FROM temp_pgr_node 
			WHERE graph_delimiter = ''' || v_mapzone_name || ''' 
			AND pgr_node_id = node_id::INT'
	INTO v_pgr_root_vids;


	-- Execute pgr_drivingDistance function
    TRUNCATE temp_pgr_drivingdistance;
    v_querytext = 'SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, cost, reverse_cost FROM temp_pgr_arc a';
    INSERT INTO temp_pgr_drivingdistance(seq, "depth", start_vid, pred, node, edge, "cost", agg_cost)
    (
		SELECT seq, "depth", start_vid, pred, node, edge, "cost", agg_cost
		FROM pgr_drivingdistance(v_querytext, v_pgr_root_vids, v_pgr_distance)
    );
	-- Update zone_id
	-- Update nodes with mapzone conflicts; nodes that are heads of mapzones in conflict with other mapzones are overwritten;
	UPDATE temp_pgr_node n SET zone_id = -1
    FROM (
		SELECT d.node, array_agg(DISTINCT n.zone_id)::int[] AS maps
		FROM temp_pgr_drivingdistance d
		JOIN temp_pgr_node n ON d.start_vid = n.pgr_node_id
		GROUP BY d.node
		HAVING COUNT(DISTINCT n.zone_id) > 1
	) AS s
    WHERE n.pgr_node_id = s.node;

	-- Update nodes with a single mapzone
    UPDATE temp_pgr_node n SET zone_id = s.zone_id
    FROM
    (SELECT d.node, n.zone_id
    FROM temp_pgr_drivingdistance d
    JOIN temp_pgr_node n ON d.start_vid = n.pgr_node_id
    ) AS s
    WHERE n.pgr_node_id = s.node AND n.zone_id = 0;

	-- Update arcs
    UPDATE temp_pgr_arc a SET zone_id = n.zone_id
    FROM temp_pgr_node n
    WHERE (a.pgr_node_1 = n.pgr_node_id AND a.cost >= 0)
	OR (a.pgr_node_2 = n.pgr_node_id AND reverse_cost >= 0);

	-- Now set to '0' the nodes that connect arcs with different zone_id
	-- Note: if a closed valve, for example, is between sector 2 and sector 3, it means it is a boundary, it will have '0' as zone_id; if it is between -1 and 2 it will also have 0;
	-- However, if a closed valve is between arcs with the same sector, it retains it; if it is between 1 and 1, it retains 1, meaning it is not a boundary; if it is between -1 and -1, it does not change, it retains Conflict

	-- Set to '0' the boundary nodes of mapzones
    UPDATE temp_pgr_node n SET zone_id = 0
    FROM (
		SELECT node_id, COUNT(DISTINCT zone_id)
    	FROM temp_pgr_node
    	GROUP BY node_id
   		HAVING COUNT(DISTINCT zone_id) > 1
	) s
	WHERE n.node_id = s.node_id;

	-- The connecs take the zone_id of the arc they are associated with and the link takes the zone_id of the gully
    UPDATE temp_pgr_connec c SET zone_id = a.zone_id
    FROM temp_pgr_arc a
    WHERE c.arc_id::int = a.pgr_arc_id
	AND a.zone_id <> 0;

    UPDATE temp_pgr_link l SET zone_id = c.zone_id
    FROM temp_pgr_connec c
    WHERE l.feature_id = c.connec_id
	AND l.feature_type = 'CONNEC'
	AND c.zone_id <> 0;

	-- For sanitation, the gully takes the zone_id of the arc they are associated with and the link takes the zone_id of the gully
    IF v_project_type = 'UD' THEN
        UPDATE temp_pgr_gully g SET zone_id = a.zone_id
        FROM temp_pgr_arc a
        WHERE g.arc_id::int = a.pgr_arc_id
		AND a.zone_id <> 0;

        UPDATE temp_pgr_link l SET zone_id = g.zone_id
        FROM temp_pgr_gully g
        WHERE l.feature_id = g.gully_id
		AND l.feature_type = 'GULLY'
		AND g.zone_id <> 0;
    END IF;




	IF v_audit_result is null THEN
		v_status = 'Accepted';
		v_level = 3;
		v_message = 'Mapzones dynamic analysis done succesfull';
	ELSE
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;
	END IF;


	IF v_commitchanges IS FALSE THEN
		-- arc elements
		IF v_floodonlymapzone IS NULL THEN
			EXECUTE 'SELECT jsonb_agg(features.feature) 
			FROM (
				SELECT jsonb_build_object(
					''type'',       ''Feature'',
					''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
					''properties'', to_jsonb(row) - ''the_geom''
				) AS feature
				FROM (
					SELECT t.arc_id, a.arccat_id, a.state, a.expl_id, a.'||v_mapzone_field||'::TEXT AS mapzone_id, a.the_geom, m.name AS descript 
					FROM temp_pgr_arc t
					JOIN arc a USING (arc_id)
					JOIN '|| v_mapzone_name ||' m USING ('|| v_mapzone_field ||')
					WHERE '|| v_mapzone_field ||'::integer > 0
					AND t.pgr_arc_id = t.arc_id::INT
				) row 
			) features'
			INTO v_result;
		ELSE
			EXECUTE 'SELECT jsonb_agg(features.feature) 
			FROM (
				SELECT jsonb_build_object(
					''type'',       ''Feature'',
					''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
					''properties'', to_jsonb(row) - ''the_geom''
				) AS feature
				FROM (
					SELECT t.arc_id, a.arccat_id, a.state, a.expl_id, a.'||v_mapzone_field||'::TEXT AS mapzone_id, a.the_geom, m.name AS descript 
					FROM temp_pgr_arc t
					JOIN arc a USING (arc_id)
					JOIN '|| v_mapzone_name ||' m USING ('|| v_mapzone_field ||')
					WHERE '|| v_mapzone_field ||'::integer IN ('||v_floodonlymapzone||')
					AND t.pgr_arc_id = t.arc_id::INT
				) row 
			) features'
			INTO v_result;
		END IF;
		v_result := COALESCE(v_result, '{}');
		v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}');

		v_result = null;

		-- polygon elements
		EXECUTE 'SELECT jsonb_agg(features.feature) 
			FROM (
				SELECT jsonb_build_object(
					''type'',       ''Feature'',
					''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
					''properties'', to_jsonb(row) - ''the_geom''
				) AS feature
				FROM (
					SELECT n.'||v_mapzone_field||'::TEXT AS mapzone_id, m.name AS descript, '||v_fid||' as fid, n.expl_id, n.the_geom
					FROM temp_pgr_node t
					JOIN node n USING (node_id)
					JOIN '|| v_mapzone_name ||' m USING ('|| v_mapzone_field ||')
					WHERE t.pgr_node_id = t.node_id::INT
				) row 
			) features'
			INTO v_result;

		v_result := COALESCE(v_result, '{}');
		v_result_polygon = concat ('{"geometryType":"Polygon", "features":',v_result, '}');

	END IF;


	-- Delete temporary tables
	-- =======================
	v_data := '{"data":{"fct_name":"'|| v_class ||'"}}';
	SELECT gw_fct_graphanalytics_delete_temptables(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Control NULL values
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');
	v_result_line := COALESCE(v_result_line, '{}');
	v_result_polygon := COALESCE(v_result_polygon, '{}');
	v_level := COALESCE(v_level, 0);
	v_message := COALESCE(v_message, '');
	v_version := COALESCE(v_version, '');
	v_netscenario := COALESCE(v_netscenario, '');

	--  Return
	RETURN json_build_object(
		'status', v_status,
		'message', json_build_object(
			'level', v_level,
			'text', v_message
		),
		'version', v_version,
		'body', json_build_object(
			'form', json_build_object(),
			'data', json_build_object(
				'graphClass', v_class,
				'netscenarioId', v_netscenario,
				'hasConflicts', v_has_conflicts,
				'info', v_result_info,
				'point', v_result_point,
				'line', v_result_line,
				'polygon', v_result_polygon
			)
		)
	);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

