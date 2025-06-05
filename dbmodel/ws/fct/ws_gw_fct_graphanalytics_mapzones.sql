/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
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
				"exploitation":"1,2,0",
				"updateMapZone":2,
				"geomParamUpdate":15,
				"commitChanges":true,
				"usePlanPsector":false,
				"forceOpen":"1,2,3",
				"forceClosed":"2,3,4"
			}
		}
	}
');
SELECT gw_fct_graphanalytics_mapzones('
	{
		"data":{
			"parameters":{
				"graphClass":"PRESSZONE",
				"exploitation":"1,2,0",
				"updateMapZone":2,
				"geomParamUpdate":15,
				"commitChanges":true,
				"usePlanPsector":false
			}
		}
	}
');

Query to visualize arcs with their geometries:

SELECT p.*, a.the_geom
FROM temp_pgr_arc p
JOIN arc a ON p.arc_id = a.arc_id;

Query to visualize nodes with their geometries:

SELECT p.*, n.the_geom
FROM temp_pgr_node p
JOIN node n ON p.node_id = n.node_id;

Query to calculate the factor for adding/subtracting flow in a DMA:

WITH
temp_dma_graph AS (
	SELECT
		COALESCE (a.node_1, a.node_2) AS node_id,
		n.mapzone_id AS dma_id,
		CASE WHEN n.node_id IS NOT NULL THEN 1 ELSE -1 END AS flow_sign
	FROM temp_pgr_node n
	JOIN temp_pgr_arc a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
	WHERE n.graph_delimiter = 'dma'
	AND a.graph_delimiter ='dma'
	AND n.mapzone_id::int > 0
	)
SELECT DISTINCT ON (node_id, dma_id) node_id, dma_id, flow_sign
FROM temp_dma_graph
ORDER BY node_id, dma_id;
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
	v_expl_id_array text;
	v_old_mapzone_id_array text;
	v_updatemapzgeom integer = 0;
	v_geomparamupdate_divide float;
	v_concavehull float = 0.9;
	v_geomparamupdate float;
    v_parameters json;
	v_usepsector boolean;
	v_valuefordisconnected integer;
	v_floodonlymapzone text;
	v_commitchanges boolean;
	v_fromzero boolean;

	v_dscenario_valve text;
	v_checkdata text;  -- FULL / PARTIAL / NONE
	v_netscenario text;

	--
	v_audit_result text;
	v_visible_layer text;
	v_has_conflicts boolean = false;

	v_arcs_count integer;
	v_nodes_count integer;
	v_connecs_count integer;
	v_gullies_count integer;
	v_mapzones_count text;

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
	v_updatemapzgeom = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_geomparamupdate = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');
	v_parameters = (SELECT ((p_data::json->>'data')::json->>'parameters'));
	-- to use forceopen and forceclosed -> WHERE X IN (SELECT json_array_elements_text((v_parameters->>'forceClosed')::JSON))
	v_usepsector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePlanPsector');
	v_valuefordisconnected = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'valueForDisconnected');
	v_floodonlymapzone = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'floodOnlyMapzone');
	v_commitchanges = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'commitChanges');

	v_checkdata = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'checkData');
	v_dscenario_valve = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'dscenario_valve');
	v_netscenario = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'netscenario');

	-- TODO: add new param to calculate mapzones from zero
	v_fromzero = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'fromZero');

	-- profilactic controls
	IF v_dscenario_valve = '' THEN v_dscenario_valve = NULL; END IF;
	IF v_netscenario = '' THEN v_netscenario = NULL; END IF;
	IF v_floodonlymapzone = '' THEN v_floodonlymapzone = NULL; END IF;
    v_floodonlymapzone := TRIM(BOTH '[]' FROM v_floodonlymapzone);


	-- it's not allowed to commit changes when psectors are used
 	IF v_usepsector = 'true' THEN
		v_commitchanges = 'false';
	END IF;

	-- it's not allowed to commit changes when flood only mapzone is activated
	IF v_floodonlymapzone IS NOT NULL THEN
		v_commitchanges = 'false';
	END IF;


	IF v_class = 'PRESSZONE' THEN
		v_fid=146;
	ELSIF v_class = 'DMA' THEN
		v_fid=145;
	ELSIF v_class = 'DQA' THEN
		v_fid=144;
	ELSIF v_class = 'SECTOR' THEN
		v_fid=130;
	ELSE
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3090", "function":"2710","parameters":null, "is_process":true}}$$);' INTO v_audit_result;
	END IF;

	-- SECTION[epic=mapzones]: SET VARIABLES
	v_mapzone_name = LOWER(v_class);
    v_mapzone_field = v_mapzone_name || '_id';
	v_visible_layer = 'v_edit_' || v_mapzone_name;


	-- MANAGE EXPL ARR

    -- For user selected exploitations
    IF v_expl_id = '-901' THEN
        SELECT string_to_array(string_agg(DISTINCT expl_id::text, ','), ',') INTO v_expl_id_array
		FROM selector_expl;
    -- For all exploitations
    ELSIF v_expl_id = '-902' THEN
        SELECT string_to_array(string_agg(DISTINCT expl_id::text, ','), ',') INTO v_expl_id_array
        FROM exploitation
		WHERE active;
    -- For a specific exploitation/s
    ELSE
		v_expl_id_array = string_to_array(v_expl_id, ',');
    END IF;

	-- Delete temporary tables
	-- =======================
	v_data := '{"data":{"action":"DROP", "fct_name":"'|| v_class ||'"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

	-- Create temporary tables
	-- =======================
	v_data := '{"data":{"action":"CREATE", "fct_name":"'|| v_class ||'", "use_psector":"'|| v_usepsector ||'", "expl_id_array":"'|| v_expl_id_array ||'"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Start Building Log Message
	-- =======================
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('MAPZONES DYNAMIC SECTORITZATION - ', upper(v_class)));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('------------------------------------------------------------------'));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Use psectors: ', upper(v_usepsector::text)));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Mapzone constructor method: ', upper(v_updatemapzgeom::text)));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Update feature mapzone attributes: ', upper(v_commitchanges::text)));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Previous data quality control: ', v_checkdata));

	IF v_floodonlymapzone IS NOT NULL THEN
		INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Flood only mapzone have been ACTIVATED, ',v_mapzone_field, ':',v_floodonlymapzone,'.'));
	END IF;

	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat(''));
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, 'ERRORS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, '-----------');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, 'WARNINGS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, '--------------');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, 'INFO');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, '-------');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 0, 'DETAILS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 0, '----------');



	-- Initialize process
	-- =======================
	v_data := '{"data":{"expl_id_array":"' || v_expl_id_array || '", "mapzone_name":"'|| v_mapzone_name ||'"}}';
    SELECT gw_fct_graphanalytics_initnetwork(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- NODES TO MODIFY
	-- NODES VALVES

	-- UPDATE "closed", "broken", "to_arc" only if the values make sense - check the explanations/rules for the possible valve scenarios MINSECTOR/to_arc/closed/broken

	-- closed valves - with or without to_arc
	UPDATE temp_pgr_node t SET graph_delimiter = 'valve', closed = v.closed, broken = v.broken, modif = TRUE
	FROM v_temp_node n
	JOIN man_valve v ON n.node_id = v.node_id
	WHERE t.node_id = n.node_id AND 'MINSECTOR' = ANY(n.graph_delimiter) AND v.closed = TRUE;

	-- valves with to_arc NOT NULL and with the property to_arc valid ( broken = FALSE, v.closed = FALSE )
	UPDATE temp_pgr_node n SET graph_delimiter = 'valve', closed = v.closed, broken = v.broken, to_arc = v.to_arc, modif = TRUE
	FROM man_valve v
	WHERE n.node_id = v.node_id AND v.to_arc IS NOT NULL AND v.closed = FALSE AND v.broken = FALSE;

	-- cost/reverse_cost for the open valves with to_arc will be update after gw_fct_graphanalytics_arrangenetwork with the correct values



	-- NODES MAPZONES
	-- Nodes that are the starting points of mapzones
    v_querytext =
		'UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = ''' || v_mapzone_name || ''', mapzone_id = ' || v_mapzone_field || '
		FROM (
			SELECT ' || v_mapzone_field || ', ((json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'')::int4 AS node_id
			FROM ' || v_mapzone_name || ' 
			WHERE graphconfig IS NOT NULL 
			AND active
		) AS s 
		WHERE n.node_id = s.node_id';
    EXECUTE v_querytext;

	-- Nodes forceClosed
    v_querytext =
		'UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = ''forceClosed'' 
		FROM (
			SELECT (json_array_elements_text((graphconfig->>''forceClosed'')::json))::int4 AS node_id
			FROM ' || v_mapzone_name || ' 
			WHERE graphconfig IS NOT NULL 
			AND active
		) s 
		WHERE n.node_id = s.node_id';
    EXECUTE v_querytext;

	-- Nodes "ignore", should not be disconnected
    v_querytext =
		'UPDATE temp_pgr_node n SET modif = FALSE, graph_delimiter = ''ignore'' 
		FROM (
			SELECT (json_array_elements_text((graphconfig->>''ignore'')::json))::int4 AS node_id
			FROM ' || v_mapzone_name || ' 
			WHERE graphconfig IS NOT NULL 
			AND active 
		) s 
		WHERE n.node_id = s.node_id';
    EXECUTE v_querytext;

	-- Nodes forceClosed acording init parameters
	UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = 'forceClosed'
	WHERE n.node_id IN (SELECT (json_array_elements_text((v_parameters->>'forceClosed')::json))::int4);

	-- Nodes forceOpen acording init parameters
	UPDATE temp_pgr_node n SET modif = FALSE, graph_delimiter = 'ignore'
	WHERE n.node_id IN (SELECT (json_array_elements_text((v_parameters->>'forceOpen')::json))::int4);

	-- ARCS TO MODIFY
	-- ARCS VALVES
	-- for the closed valves (WHEN "closed" IS TRUE), one of the arcs that connect to the valve
	WITH
	arcs_selected AS (
		SELECT DISTINCT ON (n.pgr_node_id)
			a.pgr_arc_id,
			n.pgr_node_id,
			a.pgr_node_1,
			a.pgr_node_2
		FROM temp_pgr_node n
		JOIN temp_pgr_arc a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
		WHERE n.graph_delimiter = 'valve' AND n.closed = TRUE
	),
	arcs_modif AS (
		SELECT
			pgr_arc_id,
			bool_or(pgr_node_id = pgr_node_1) AS modif1,
			bool_or( pgr_node_id = pgr_node_2) AS modif2
		FROM arcs_selected
		GROUP BY pgr_arc_id
	)
	UPDATE temp_pgr_arc t
	SET
		modif1 = s.modif1,
		modif2 = s.modif2
	FROM arcs_modif s
	WHERE t.pgr_arc_id = s.pgr_arc_id;

	-- for the valves with to_arc NOT NULL that are not closed ('valve'); the InletArc - the one that is not to_arc
	WITH
	arcs_selected AS (
		SELECT
			a.pgr_arc_id,
			n.pgr_node_id,
			a.pgr_node_1,
			a.pgr_node_2
		FROM  temp_pgr_node n
		JOIN temp_pgr_arc a on n.pgr_node_id in (a.pgr_node_1, a.pgr_node_2)
		WHERE n.graph_delimiter = 'valve' AND n.to_arc IS NOT NULL AND a.arc_id <> n.to_arc
	),
	arcs_modif AS (
		SELECT
			pgr_arc_id,
			bool_or(pgr_node_id = pgr_node_1) AS modif1,
			bool_or( pgr_node_id = pgr_node_2) AS modif2
		FROM arcs_selected
		GROUP BY pgr_arc_id
	)
	UPDATE temp_pgr_arc t
	SET modif1= s.modif1,
		modif2= s.modif2
	FROM arcs_modif s
	WHERE t.pgr_arc_id= s.pgr_arc_id;

	-- cost/reverse_cost for the open valves with to_arc will be update after gw_fct_graphanalytics_arrangenetwork with the correct values

	-- ARCS MAPZONES
	-- Disconnect the InletArc (those that are not to_arc)
    v_querytext =
		'WITH 
		arcs_selected AS (
			SELECT 
				a.pgr_arc_id, 
				n.pgr_node_id, 
				a.pgr_node_1, 
				a.pgr_node_2
			FROM temp_pgr_node n
			JOIN temp_pgr_arc a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2) 
			LEFT JOIN (
				SELECT (json_array_elements_text(((json_array_elements_text((graphconfig->>''use'')::json))::json->>''toArc'')::json))::int4 AS to_arc
				FROM ' || v_mapzone_name || ' 
				WHERE graphconfig IS NOT NULL 
				AND active
			) sa ON sa.to_arc = a.arc_id
			WHERE n.graph_delimiter = ''' || v_mapzone_name || '''
			AND sa.to_arc IS NULL
		),
		arcs_modif AS (
			SELECT
				pgr_arc_id,
				bool_or(pgr_node_id = pgr_node_1) AS modif1,
				bool_or( pgr_node_id = pgr_node_2) AS modif2
			FROM arcs_selected
			GROUP BY pgr_arc_id
		)
		UPDATE temp_pgr_arc t
		SET modif1= s.modif1,
			modif2= s.modif2
		FROM arcs_modif s
		WHERE t.pgr_arc_id= s.pgr_arc_id';
	EXECUTE v_querytext;

	-- Arcs forceClosed - all arcs that are connected to forceClosed nodes
	WITH
		arcs_selected AS (
			SELECT
				a.pgr_arc_id,
				n.pgr_node_id,
				a.pgr_node_1,
				a.pgr_node_2
			FROM temp_pgr_node n
			JOIN temp_pgr_arc a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
			WHERE n.graph_delimiter = 'forceClosed'
		),
		arcs_modif AS (
			SELECT
				pgr_arc_id,
				bool_or(pgr_node_id = pgr_node_1) AS modif1,
				bool_or( pgr_node_id = pgr_node_2) AS modif2
			FROM arcs_selected
			GROUP BY pgr_arc_id
		)
		UPDATE temp_pgr_arc t
		SET modif1= s.modif1,
			modif2= s.modif2
		FROM arcs_modif s
		WHERE t.pgr_arc_id= s.pgr_arc_id;

	-- Generate new arcs and disconnect arcs with modif = TRUE
	-- =======================
    SELECT gw_fct_graphanalytics_arrangenetwork() INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Note: node_id IS NULL AND arc_id IS NULL for the new nodes/arcs generated
	-- Update cost/reverse_cost=-1 for the new arcs:
	UPDATE temp_pgr_arc
	SET cost = -1, reverse_cost = -1
	WHERE arc_id IS NULL;

	-- Update the cost/reverse_cost with the correct values for the open valves with to_arc NOT NULL
	-- and graph_delimiter 'valve' (it wasn't changed for 'forceClosed' or 'ignore' for example)
	UPDATE temp_pgr_arc a
	SET reverse_cost = CASE WHEN a.pgr_node_1=n.pgr_node_id THEN 0 ELSE a.reverse_cost END, -- for inundation process, better to be 0 instead of 1; these arcs don't exist
		cost = CASE WHEN a.pgr_node_2=n.pgr_node_id THEN 0 ELSE a.cost END -- for inundation process, better to be 0 instead of 1; these arcs don't exist
	FROM temp_pgr_node n
	WHERE n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
	AND a.graph_delimiter = 'valve' AND n.to_arc IS NOT NULL;

    EXECUTE 'SELECT COUNT(*)::INT FROM temp_pgr_arc'
    INTO v_pgr_distance;

	EXECUTE 'SELECT array_agg(pgr_node_id)::INT[] 
			FROM temp_pgr_node 
			WHERE graph_delimiter = ''' || v_mapzone_name || ''' 
			AND node_id IS NOT NULL'
	INTO v_pgr_root_vids;

	-- Execute pgr_drivingDistance function
    v_querytext = 'SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, cost, reverse_cost 
		FROM temp_pgr_arc a
		WHERE a.pgr_node_1 IS NOT NULL AND a.pgr_node_2 IS NOT NULL
		AND (cost<> -1 OR reverse_cost <> -1)';
    INSERT INTO temp_pgr_drivingdistance(seq, "depth", start_vid, pred, node, edge, "cost", agg_cost)
    (
		SELECT seq, "depth", start_vid, pred, node, edge, "cost", agg_cost
		FROM pgr_drivingdistance(v_querytext, v_pgr_root_vids, v_pgr_distance)
    );

	IF v_updatemapzgeom > 0 THEN
		-- message
		INSERT INTO temp_audit_check_data (fid, criticity, error_message)
		VALUES (v_fid, 1, concat('INFO: ',v_class,' values for features and geometry of the mapzone has been modified by this process'));
	END IF;

	-- Update mapzone_id
	-- Update nodes with mapzone conflicts; nodes that are heads of mapzones in conflict with other mapzones are overwritten;
	UPDATE temp_pgr_node n SET mapzone_id = -1
    FROM (
		SELECT d.node, array_agg(DISTINCT n.mapzone_id)::int[] AS maps
		FROM temp_pgr_drivingdistance d
		JOIN temp_pgr_node n ON d.start_vid = n.pgr_node_id
		GROUP BY d.node
		HAVING COUNT(DISTINCT n.mapzone_id) > 1
	) AS s
    WHERE n.pgr_node_id = s.node;

	-- Update nodes with a single mapzone
    UPDATE temp_pgr_node n SET mapzone_id = s.mapzone_id
    FROM
    (
		SELECT d.node, n.mapzone_id
    	FROM temp_pgr_drivingdistance d
    	JOIN temp_pgr_node n ON d.start_vid = n.pgr_node_id
    ) AS s
    WHERE n.pgr_node_id = s.node AND n.mapzone_id = 0;

	-- Update arcs
    UPDATE temp_pgr_arc a SET mapzone_id = n.mapzone_id
    FROM temp_pgr_node n
    WHERE ((a.pgr_node_1 = n.pgr_node_id AND a.cost >= 0)
	OR (a.pgr_node_2 = n.pgr_node_id AND reverse_cost >= 0))
	AND n.mapzone_id <> 0;

	-- Now set to 0 the nodes that connect arcs with different mapzone_id
	-- Note: if a closed valve, for example, is between sector 2 and sector 3, it means it is a boundary, it will have '0' as mapzone_id; if it is between -1 and 2 it will also have 0;
	-- However, if a closed valve is between arcs with the same sector, it retains it; if it is between 1 and 1, it retains 1, meaning it is not a boundary; if it is between -1 and -1, it does not change, it retains Conflict

	-- Set to 0 the boundary nodes of mapzones
	WITH boundary AS (
		SELECT COALESCE(n1.node_id, n2.node_id) AS node_id
		FROM temp_pgr_arc a
		JOIN temp_pgr_node n1 on a.pgr_node_1 = n1.pgr_node_id
		JOIN temp_pgr_node n2 on a.pgr_node_2 = n2.pgr_node_id
		WHERE a.graph_delimiter = 'valve'
		AND n1.mapzone_id <> 0 AND n2.mapzone_id <> 0
		AND n1.mapzone_id <> n2.mapzone_id
		)
	UPDATE temp_pgr_node n SET mapzone_id = 0
	FROM boundary AS s
	WHERE n.node_id =s.node_id AND n.graph_delimiter = 'valve';

	-- The connecs take the mapzone_id of the arc they are associated with and the link takes the mapzone_id of the gully
    UPDATE temp_pgr_connec c SET mapzone_id = a.mapzone_id
    FROM temp_pgr_arc a
    WHERE c.arc_id::int = a.pgr_arc_id
	AND a.mapzone_id <> 0;

    UPDATE temp_pgr_link l SET mapzone_id = c.mapzone_id
    FROM temp_pgr_connec c
    WHERE l.feature_id = c.connec_id
	AND l.feature_type = 'CONNEC'
	AND c.mapzone_id <> 0;


	-- SECTION: recalculate staticpressure (fid=147)
	IF v_fid=146 THEN
		-- update on node table those elements connected on connectedcomponents
		v_querytext = '
			UPDATE temp_pgr_node SET staticpressure = (a.head - a.top_elev + (CASE WHEN a.depth IS NULL THEN 0 ELSE a.depth END)::float)
			FROM (
				SELECT n.node_id, p.head, vn.top_elev, vn.depth
				FROM temp_pgr_node n
				JOIN v_temp_node vn ON vn.node_id = n.node_id
				JOIN '||v_mapzone_name||' p ON vn.mapzone_id = p.'||v_mapzone_field||'
				JOIN temp_pgr_connectedcomponents cc ON cc.node = n.node_id::int
			) a
			WHERE temp_pgr_node.node_id = a.node_id;
		';

		RAISE NOTICE 'v_querytext update node table (only on-connectedcomponents nodes):: %', v_querytext;
		EXECUTE v_querytext;

		-- update connec table
		v_querytext = '
			UPDATE temp_pgr_connec SET staticpressure = (a.head - a.top_elev + (CASE WHEN a.depth IS NULL THEN 0 ELSE a.depth END)::float)
			FROM (
				SELECT c.connec_id, p.head, vc.top_elev, vc.depth
				FROM temp_pgr_connec c
				JOIN v_temp_connec vc ON vc.connec_id = c.connec_id
				JOIN '||v_mapzone_name||' p ON vc.mapzone_id = p.'||v_mapzone_field||'
			) a
			WHERE temp_pgr_connec.connec_id = a.connec_id;
		';

		RAISE NOTICE 'v_querytext update connec table:: %', v_querytext;
		EXECUTE v_querytext;

		-- update link table
		v_querytext = '
			UPDATE temp_pgr_link SET staticpressure = (a.head - a.top_elev + (CASE WHEN a.depth IS NULL THEN 0 ELSE a.depth END)::float)
			FROM (
				SELECT l.link_id, p.head, vc.top_elev, vc.depth
				FROM temp_pgr_link l
				JOIN v_temp_connec vc ON vc.connec_id = l.feature_id
				JOIN '||v_mapzone_name||' p ON vc.mapzone_id = p.'||v_mapzone_field||'
				WHERE l.feature_type = ''CONNEC''
			) a
			WHERE temp_pgr_link.link_id = a.link_id;
		';

		RAISE NOTICE 'v_querytext update link table:: %', v_querytext;
		EXECUTE v_querytext;
	END IF;

	IF v_updatemapzgeom > 0 THEN
		-- message
		INSERT INTO temp_audit_check_data (fid, criticity, error_message)
		VALUES (v_fid, 1, concat('INFO: ',v_class,' values for features and geometry of the mapzone has been modified by this process'));
	END IF;



	-- CONFLICT COUNTS
	IF v_floodonlymapzone IS NULL THEN
		IF v_class != 'DRAINZONE' THEN
				SELECT count(*) INTO v_arcs_count FROM temp_pgr_arc tpa WHERE mapzone_id = -1;
				SELECT count(*) INTO v_connecs_count FROM temp_pgr_connec tpc WHERE mapzone_id = -1;

				-- log
				IF v_arcs_count > 0 OR v_connecs_count > 0 THEN
					INSERT INTO temp_audit_check_data (fid,  criticity, error_message)
					VALUES (v_fid, 2, concat('WARNING-395: There is a conflict against ',upper(v_mapzone_name),'''s (',v_mapzones_count,') with ',v_arcs_count,' arc(s) and ',v_connecs_count,' connec(s) affected.'));
				END IF;
		END IF;
	END IF;

	-- DISCONECTED COUNTS
	IF v_floodonlymapzone IS NULL THEN

		RAISE NOTICE 'Disconnected arcs';
		SELECT COUNT(t.*) INTO v_arcs_count
		FROM temp_pgr_arc t
		WHERE t.mapzone_id = 0
		and t.pgr_arc_id = t.arc_id::INT;

		IF v_arcs_count > 0 THEN
			INSERT INTO temp_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 2, concat('WARNING-',v_fid,': ', v_count ,' arc''s have been disconnected'));
		ELSE
			INSERT INTO temp_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 1, concat('INFO: 0 arc''s have been disconnected'));
		END IF;

		RAISE NOTICE 'Disconnected connecs';
		IF v_arcs_count > 0 THEN
			SELECT COUNT(tc.*) INTO v_connecs_count
			FROM temp_pgr_connec tc
			JOIN temp_pgr_arc t
			ON tc.arc_id::INT = t.arc_id::INT
			WHERE tc.mapzone_id = 0
			and t.pgr_arc_id = t.arc_id::INT;

			IF v_connecs_count > 0 THEN
				INSERT INTO temp_audit_check_data (fid, criticity, error_message)
				VALUES (v_fid, 2, concat('WARNING-',v_fid,': ', v_count ,' connec''s have been disconnected'));
			ELSE
				INSERT INTO temp_audit_check_data (fid, criticity, error_message)
				VALUES (v_fid, 1, concat('INFO: 0 connec''s have been disconnected'));
			END IF;
		ELSE
			INSERT INTO temp_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 1, concat('INFO: 0 connec''s have been disconnected'));
		END IF;
	END IF;

	-- insert spacer for warning and info
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  3, '');
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  2, '');
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  1, '');
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  0, '');


	-- Get Info for the audit
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message AS message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid IN (v_fid) ORDER BY criticity DESC, id ASC) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	IF v_audit_result is null THEN
		v_status = 'Accepted';
		v_level = 3;
		v_message = 'Mapzones dynamic analysis done succesfull';
	ELSE
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;
	END IF;

	-- generating zones
	INSERT INTO temp_pgr_mapzone (mapzone_id)
	SELECT DISTINCT mapzone_id FROM temp_pgr_node a
	WHERE a.mapzone_id > 0;


	RAISE NOTICE 'Creating geometry of mapzones';
	-- SECTION: Creating geometry of mapzones

	IF v_updatemapzgeom = 0 THEN
		-- do nothing

	ELSIF  v_updatemapzgeom = 1 THEN

		-- concave polygon
		v_querytext = '
			UPDATE temp_pgr_mapzone SET the_geom = ST_Multi(a.the_geom) 
			FROM (
				WITH polygon AS (
					SELECT ST_Collect(the_geom) AS g, mapzone_id 
					FROM temp_pgr_arc a
					JOIN v_temp_arc USING (arc_id)
					GROUP BY mapzone_id
				) 
			SELECT mapzone_id,
			CASE WHEN ST_GeometryType(ST_ConcaveHull(g, '||v_concavehull||')) = ''ST_Polygon''::text THEN 
				ST_Buffer(ST_ConcaveHull(g, '||v_concavehull||'), 2)::geometry(Polygon,'||(v_srid)||')
				ELSE ST_Expand(ST_Buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,'||(v_srid)||') 
				END AS the_geom 
			FROM polygon
			)a 
			WHERE a.mapzone_id = temp_pgr_mapzone.mapzone_id 
			AND temp_pgr_mapzone.mapzone_id > 0';
		RAISE NOTICE 'CONCAVE POLYGON v_querytext:: %', v_querytext;
		EXECUTE v_querytext;

	ELSIF  v_updatemapzgeom = 2 THEN

		-- pipe buffer
		v_querytext = '
			UPDATE temp_pgr_mapzone SET the_geom = geom 
			FROM (
				SELECT mapzone_id, ST_Multi(ST_Buffer(ST_Collect(the_geom),'||v_geomparamupdate||')) AS geom 
				FROM temp_pgr_arc a 
				JOIN v_temp_arc USING (arc_id)
				WHERE mapzone_id > 0
				GROUP BY mapzone_id
			) a 
			WHERE a.mapzone_id = temp_pgr_mapzone.mapzone_id;';
		RAISE NOTICE 'PIPE BUFFER v_querytext:: %', v_querytext;
		EXECUTE v_querytext;

	ELSIF  v_updatemapzgeom = 3 THEN

		-- use plot and pipe buffer
		v_querytext = '
			UPDATE temp_pgr_mapzone set the_geom = geom FROM (
				SELECT mapzone_id, ST_Multi(ST_Buffer(ST_Collect(geom),0.01)) AS geom FROM (
					SELECT mapzone_id, ST_Buffer(ST_Collect(the_geom), '||v_geomparamupdate||') AS geom FROM temp_pgr_arc a
					JOIN v_temp_arc USING (arc_id) 
					WHERE mapzone_id > 0
					GROUP BY mapzone_id
					UNION
					SELECT mapzone_id, ST_Collect(ext_plot.the_geom) AS geom FROM temp_pgr_connec c
					JOIN v_temp_connec vc USING (connec_id) 
					LEFT JOIN ext_plot ON vc.plot_code = ext_plot.plot_code
					LEFT JOIN ext_plot ON ST_DWithin(vc.the_geom, ext_plot.the_geom, 0.001)
					WHERE mapzone_id > 0
					GROUP BY mapzone_id	
				) a 
				GROUP BY mapzone_id 
			) b 
			WHERE b.mapzone_id= temp_pgr_mapzone.mapzone_id;';
		RAISE NOTICE 'PLOT AND PIPE BUFFER v_querytext:: %', v_querytext;
		EXECUTE v_querytext;

	ELSIF  v_updatemapzgeom = 4 THEN

		v_geomparamupdate_divide = v_geomparamupdate / 2;

		-- use link and pipe buffer
		v_querytext = '
			UPDATE temp_pgr_mapzone SET the_geom = b.geom FROM (
				SELECT c.mapzone_id, ST_Multi(ST_Buffer(ST_Collect(c.geom),0.01)) AS geom FROM (
					SELECT a.mapzone_id, ST_Buffer(ST_Collect(va.the_geom), '||v_geomparamupdate||') AS geom 
					FROM temp_pgr_arc a 
					JOIN v_temp_arc va ON a.arc_id = va.arc_id
					WHERE a.mapzone_id > 0
					GROUP BY a.mapzone_id
					UNION
					SELECT tl.mapzone_id, (ST_Buffer(ST_Collect(vlc.the_geom),'||v_geomparamupdate_divide||',''endcap=flat join=round'')) AS geom 
					FROM temp_pgr_link tl
					JOIN v_temp_link_connec vlc ON tl.link_id = vlc.link_id
					WHERE tl.mapzone_id > 0
					GROUP BY tl.mapzone_id
				) c 
				GROUP BY c.mapzone_id 
			) b
			WHERE b.mapzone_id = temp_pgr_mapzone.mapzone_id;';

		RAISE NOTICE 'LINK AND PIPE BUFFER v_querytext:: %', v_querytext;
		EXECUTE v_querytext;
	END IF;




	IF v_floodonlymapzone IS NULL THEN
		v_result = NULL;
		IF v_commitchanges IS TRUE THEN
			-- disconnected and conflict arcs
			EXECUTE '
				SELECT jsonb_agg(features.feature) 
				FROM (
					SELECT jsonb_build_object(
						''type'',       ''Feature'',
						''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
						''properties'', to_jsonb(row) - ''the_geom''
					) AS feature
					FROM (
						SELECT DISTINCT ON (t.arc_id) t.arc_id, a.arccat_id, a.state, a.expl_id, NULL AS mapzone_id, a.the_geom, ''Disconnected''::text AS descript 
						FROM temp_pgr_arc t
						JOIN arc a USING (arc_id)
						WHERE t.mapzone_id = 0
						AND t.arc_id IS NOT NULL
						UNION
						SELECT DISTINCT ON (t.arc_id) t.arc_id, a.arccat_id, a.state, a.expl_id, NULL AS mapzone_id, a.the_geom, ''Conflict''::text AS descript 
						FROM temp_pgr_arc t
						JOIN arc a USING (arc_id)
						WHERE t.mapzone_id = -1
						AND t.arc_id IS NOT NULL
					) row 
				) features
			' INTO v_result;

			SELECT EXISTS (
				SELECT 1
				FROM (
					SELECT DISTINCT ON (t.arc_id) t.arc_id, a.arccat_id, a.state, a.expl_id, NULL AS mapzone_id, a.the_geom, 'Conflict'::text AS descript
					FROM temp_pgr_arc t
					JOIN arc a USING (arc_id)
					WHERE t.mapzone_id = -1
					AND t.arc_id IS NOT NULL
				) s
			) INTO v_has_conflicts;

			v_result := COALESCE(v_result, '{}');
			v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}');
		END IF;

		-- disconnected and conflict connecs
		v_result = NULL;
		-- TODO[epic=mapzones]: add orphan connecs
		EXECUTE '
			SELECT jsonb_agg(features.feature)
			FROM (
				SELECT jsonb_build_object(
					''type'',       ''Feature'',
					''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
					''properties'', to_jsonb(row) - ''the_geom''
				) AS feature
				FROM (
					SELECT DISTINCT ON (t.connec_id) t.connec_id, c.conneccat_id, c.state, c.expl_id, NULL AS mapzone_id, c.the_geom, ''Disconnected''::text AS descript
					FROM temp_pgr_connec t
					JOIN connec c USING (connec_id)
					WHERE t.mapzone_id = 0
					UNION
					SELECT DISTINCT ON (t.connec_id) t.connec_id, c.conneccat_id, c.state, c.expl_id, NULL AS mapzone_id, c.the_geom, ''Conflict''::text AS descript
					FROM temp_pgr_connec t
					JOIN connec c USING (connec_id)
					WHERE t.mapzone_id = -1
				) row
			) features
		' INTO v_result;

		v_result := COALESCE(v_result, '{}');
		v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}');
	END IF;


	IF v_commitchanges IS FALSE THEN
		-- arc elements
		IF v_floodonlymapzone IS NULL THEN
			v_querytext = '
			SELECT jsonb_agg(features.feature) 
			FROM (
				SELECT jsonb_build_object(
					''type'',       ''Feature'',
					''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
					''properties'', to_jsonb(row) - ''the_geom''
				) AS feature
				FROM (
					SELECT DISTINCT ON (t.arc_id) t.arc_id, a.arccat_id, a.state, a.expl_id, NULL AS mapzone_id, a.the_geom, ''Disconnected''::text AS descript 
					FROM temp_pgr_arc t
					JOIN arc a USING (arc_id)
					WHERE t.mapzone_id = 0
					AND t.arc_id IS NOT NULL
					UNION
					SELECT DISTINCT ON (t.arc_id) t.arc_id, a.arccat_id, a.state, a.expl_id, NULL AS mapzone_id, a.the_geom, ''Conflict''::text AS descript 
					FROM temp_pgr_arc t
					JOIN arc a USING (arc_id)
					WHERE t.mapzone_id = -1
					AND t.arc_id IS NOT NULL
					UNION
					SELECT t.arc_id, a.arccat_id, a.state, a.expl_id, t.mapzone_id::TEXT AS mapzone_id, a.the_geom, m.name AS descript 
					FROM temp_pgr_arc t
					JOIN arc a USING (arc_id)
					JOIN '|| v_mapzone_name ||' m ON t.mapzone_id = m.'|| v_mapzone_field ||'
					WHERE m.'|| v_mapzone_field ||'::integer > 0
					AND t.arc_id IS NOT NULL
				) row 
			) features';
			RAISE NOTICE 'v_querytext:: %', v_querytext;
			EXECUTE v_querytext INTO v_result;

		ELSE
			EXECUTE '
				SELECT jsonb_agg(features.feature) 
				FROM (
					SELECT jsonb_build_object(
						''type'',       ''Feature'',
						''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
						''properties'', to_jsonb(row) - ''the_geom''
					) AS feature
					FROM (
						SELECT t.arc_id, a.arccat_id, a.state, a.expl_id, t.mapzone_id::TEXT AS mapzone_id, a.the_geom, m.name AS descript 
						FROM temp_pgr_arc t
						JOIN arc a USING (arc_id)
						JOIN '|| v_mapzone_name ||' m USING ('|| v_mapzone_field ||')
						WHERE '|| v_mapzone_field ||'::integer IN ('||v_floodonlymapzone||')
						AND t.arc_id IS NOT NULL
					) row 
				) features
			' INTO v_result;
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
					SELECT t.mapzone_id::TEXT AS mapzone_id, m.name AS descript, '||v_fid||' AS fid, n.expl_id, n.the_geom
					FROM temp_pgr_node t
					JOIN node n USING (node_id)
					JOIN '|| v_mapzone_name ||' m USING ('|| v_mapzone_field ||')
					WHERE t.node_id IS NOT NULL
				) row 
			) features'
			INTO v_result;

		v_result := COALESCE(v_result, '{}');
		v_result_polygon = concat ('{"geometryType":"Polygon", "features":',v_result, '}');

		v_visible_layer = NULL;

	ELSIF v_commitchanges IS TRUE THEN

		IF v_netscenario IS NOT NULL THEN
			-- TODO[epic=mapzones]: netscnearios
		ELSE

			IF v_class = 'DMA' THEN
				-- before inserted on om_waterbalance_dma_graph, remove obsolete nodes.
				-- TODO[epic=mapzones]: fill om_waterbalance_dma_graph


			END IF;

			v_querytext = 'UPDATE '||v_mapzone_name||' SET 
				the_geom = t.the_geom, 
				updated_at = now(), 
				updated_by = current_user 
			FROM temp_pgr_mapzone t 
			WHERE t.mapzone_id = '||v_mapzone_name||'.'||v_mapzone_field;
			EXECUTE v_querytext;


			-- old zone id array
			SELECT string_agg(a.old_mapzone_id::text, ',') INTO v_old_mapzone_id_array
			FROM (
				SELECT DISTINCT old_mapzone_id FROM temp_pgr_node
				UNION
				SELECT DISTINCT old_mapzone_id FROM temp_pgr_connec
				UNION
				SELECT DISTINCT old_mapzone_id FROM temp_pgr_arc
			) a
			WHERE a.old_mapzone_id IS NOT NULL
			AND a.old_mapzone_id > 0;

			RAISE NOTICE 'v_old_mapzone_id_array:: %', v_old_mapzone_id_array;

			v_querytext = 'UPDATE arc SET '||quote_ident(v_mapzone_field)||' = 0
			FROM temp_pgr_arc ta
			WHERE ta.mapzone_id <= 0
			AND ta.arc_id IS NOT NULL
			AND arc.'||quote_ident(v_mapzone_field)||' <> 0
			' || CASE WHEN v_old_mapzone_id_array IS NULL THEN '' ELSE 'AND arc.'||quote_ident(v_mapzone_field)||' IN ('||v_old_mapzone_id_array||')' END || '';
			RAISE NOTICE 'v_querytext:: UPDATE arc %', v_querytext;
			EXECUTE v_querytext;

			v_querytext = 'UPDATE connec SET '||quote_ident(v_mapzone_field)||' = 0
			FROM temp_pgr_connec tc
			WHERE tc.mapzone_id <= 0
			AND tc.connec_id IS NOT NULL
			AND connec.'||quote_ident(v_mapzone_field)||' <> 0
			' || CASE WHEN v_old_mapzone_id_array IS NULL THEN '' ELSE 'AND connec.'||quote_ident(v_mapzone_field)||' IN ('||v_old_mapzone_id_array||')' END || '';
			RAISE NOTICE 'v_querytext:: UPDATE connec %', v_querytext;
			EXECUTE v_querytext;

			v_querytext = 'UPDATE node SET '||quote_ident(v_mapzone_field)||' = 0
			FROM temp_pgr_node tn
			WHERE tn.mapzone_id <= 0
			AND tn.node_id IS NOT NULL
			AND node.'||quote_ident(v_mapzone_field)||' <> 0
			' || CASE WHEN v_old_mapzone_id_array IS NULL THEN '' ELSE 'AND node.'||quote_ident(v_mapzone_field)||' IN ('||v_old_mapzone_id_array||')' END || '';
			RAISE NOTICE 'v_querytext:: UPDATE node %', v_querytext;
			EXECUTE v_querytext;

			v_querytext = 'UPDATE link SET '||quote_ident(v_mapzone_field)||' = 0
			FROM temp_pgr_link tl
			WHERE tl.mapzone_id <= 0
			AND tl.link_id IS NOT NULL
			AND link.'||quote_ident(v_mapzone_field)||' <> 0
			' || CASE WHEN v_old_mapzone_id_array IS NULL THEN '' ELSE 'AND link.'||quote_ident(v_mapzone_field)||' IN ('||v_old_mapzone_id_array||')' END || '';
			RAISE NOTICE 'v_querytext:: UPDATE link %', v_querytext;
			EXECUTE v_querytext;


			v_querytext = 'UPDATE arc SET '||quote_ident(v_mapzone_field)||' = ta.mapzone_id
			FROM temp_pgr_arc ta
			WHERE ta.arc_id = arc.arc_id
			AND ta.mapzone_id IS NOT NULL
			AND ta.mapzone_id <> 0
			AND arc.'||quote_ident(v_mapzone_field)||' = ta.old_mapzone_id;';
			RAISE NOTICE 'v_querytext:: UPDATE arc dynamic mapzone %', v_querytext;
			EXECUTE v_querytext;

			v_querytext = 'UPDATE node SET '||quote_ident(v_mapzone_field)||' = ta.mapzone_id
			FROM temp_pgr_node ta
			WHERE ta.node_id = node.node_id
			AND ta.mapzone_id IS NOT NULL
			AND ta.mapzone_id <> 0
			AND node.'||quote_ident(v_mapzone_field)||' = ta.old_mapzone_id;';
			RAISE NOTICE 'v_querytext:: UPDATE node dynamic mapzone %', v_querytext;
			EXECUTE v_querytext;

			v_querytext = 'UPDATE connec SET '||quote_ident(v_mapzone_field)||' = tpa.mapzone_id
			FROM temp_pgr_connec tpc
			JOIN temp_pgr_arc tpa ON tpc.arc_id = tpa.arc_id
			WHERE tpc.connec_id = connec.connec_id
			AND tpa.mapzone_id IS NOT NULL
			AND tpa.mapzone_id <> 0
			AND connec.'||quote_ident(v_mapzone_field)||' = tpa.old_mapzone_id;';
			RAISE NOTICE 'v_querytext:: UPDATE connec dynamic mapzone %', v_querytext;
			EXECUTE v_querytext;

			v_querytext = 'UPDATE link SET '||quote_ident(v_mapzone_field)||' = tpa.mapzone_id
			FROM temp_pgr_link tpl
			JOIN v_temp_link_connec v ON v.link_id = tpl.link_id::int
			JOIN temp_pgr_arc tpa ON tpa.arc_id = v.arc_id
			WHERE tpl.link_id::int = link.link_id
			AND tpa.mapzone_id IS NOT NULL
			AND tpa.mapzone_id <> 0
			AND link.'||quote_ident(v_mapzone_field)||' = tpa.old_mapzone_id;';
			RAISE NOTICE 'v_querytext:: UPDATE link connec dynamic mapzone %', v_querytext;
			EXECUTE v_querytext;

			-- static pressure for
			IF v_class = 'PRESSZONE' THEN
				-- arcs
				UPDATE arc SET staticpress1 = n.staticpressure FROM temp_pgr_node n WHERE node_id = node_1;
				UPDATE arc SET staticpress2 = n.staticpressure FROM temp_pgr_node n WHERE node_id = node_2;
				-- nodes
				UPDATE node SET staticpressure = n.staticpressure FROM temp_pgr_node n WHERE n.node_id=node.node_id;
				-- connecs
				UPDATE connec SET staticpressure = c.staticpressure FROM temp_pgr_connec c WHERE c.connec_id=connec.connec_id;
				-- links
				UPDATE link SET staticpressure = l.staticpressure FROM temp_t_link l WHERE l.link_id=link.link_id;
			END IF;

		END IF;

	END IF;


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

	-- Return JSON
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
				"netscenarioId": "'||v_netscenario||'", 
				"hasConflicts": '||v_has_conflicts||', 
				"info":'||v_result_info||',
				"point":'||v_result_point||',
				"line":'||v_result_line||',
				"polygon":'||v_result_polygon||'
			}
		}
	}')::json, 2710, null, ('{"visible": ["'||v_visible_layer||'"]}')::json, null)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

