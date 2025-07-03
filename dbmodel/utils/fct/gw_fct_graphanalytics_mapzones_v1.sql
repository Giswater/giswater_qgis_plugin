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
	v_fromzero boolean = FALSE;

	v_dscenario_valve text;
	v_checkdata text;  -- FULL / PARTIAL / NONE
	v_netscenario text;

	--
	v_audit_result text;
	v_visible_layer text;
	v_has_conflicts boolean = false;
	v_source text;
	v_target text;

	v_arcs_count integer;
	v_nodes_count integer;
	v_connecs_count integer;
	v_gullies_count integer;
	v_mapzones_count text;

	v_mapzone_name text;
	v_mapzone_field text;
	v_mapzone_id int4;
	v_ignore_broken_valves BOOLEAN = TRUE; 
	v_pgr_distance integer;
	v_pgr_root_vids int[];

	v_level integer;
	v_status text;
	v_message text;

	v_query_text text;
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
	v_usepsector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePlanPsector')::BOOLEAN;
	v_valuefordisconnected = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'valueForDisconnected');
	v_floodonlymapzone = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'floodOnlyMapzone');
	v_commitchanges = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'commitChanges')::BOOLEAN;

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
 	IF v_usepsector THEN
		v_commitchanges := FALSE;
	END IF;

	-- it's not allowed to commit changes when flood only mapzone is activated
	IF v_floodonlymapzone IS NOT NULL THEN
		v_commitchanges := FALSE;
	END IF;

	IF v_class = 'PRESSZONE' THEN
		v_fid=146;
	ELSIF v_class = 'DMA' THEN
		v_fid=145;
	ELSIF v_class = 'DQA' THEN
		v_fid=144;
	ELSIF v_class = 'SECTOR' THEN
		v_fid=130;
	ELSIF v_class = 'DWFZONE' THEN
		-- dwfzone and drainzone are calculated in the same process
		v_fid=481;
	ELSE
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3090", "function":"2710","parameters":null, "is_process":true}}$$);' INTO v_audit_result;
	END IF;

	-- SECTION[epic=mapzones]: SET VARIABLES
	v_mapzone_name = LOWER(v_class);
    v_mapzone_field = v_mapzone_name || '_id';
	v_visible_layer = 'v_edit_' || v_mapzone_name;
	v_mapzone_name = UPPER(v_mapzone_name);


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
	v_data := '{"data":{"action":"CREATE", "fct_name":"'|| v_class ||'", "use_psector":"'|| v_usepsector ||'"}}';
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
	IF v_project_type = 'WS' THEN

		-- NODES VALVES
		-- closed valves
		UPDATE temp_pgr_node n  SET modif = TRUE
		WHERE  n.graph_delimiter = 'MINSECTOR'
		AND n.closed = TRUE;

		-- valves with to_arc NOT NULL and NOT broken
		UPDATE temp_pgr_node n SET modif = TRUE
		WHERE n.graph_delimiter = 'MINSECTOR' 
		AND n.closed = FALSE
		AND n.to_arc IS NOT NULL 
		AND n.closed = FALSE
		AND n.broken = FALSE;
	END IF;

	-- NODES MAPZONES
	-- Nodes that are the starting/ending points of mapzones
	IF v_fromzero THEN 
		IF v_project_type = 'UD' AND v_mapzone_name = 'DWFZONE' THEN
            v_query_text =
                'UPDATE temp_pgr_node n SET modif = TRUE
                WHERE  graph_delimiter  = ''' || v_mapzone_name || '''
                AND NOT EXISTS (SELECT 1 FROM temp_pgr_arc a WHERE n.pgr_node_id = a.pgr_node_1)
                '; 
        ELSE
            v_query_text =
                'UPDATE temp_pgr_node n SET modif = TRUE
                WHERE  graph_delimiter  = ''' || v_mapzone_name || '''
                '; 
        END IF;  
		EXECUTE v_query_text;    
	ELSE
		IF v_project_type = 'WS' THEN
			v_query_text = 
				'UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = ''' || v_mapzone_name || ''', mapzone_id = s.mapzone_id, to_arc = s.to_arc
				FROM (
					SELECT 
						' || v_mapzone_field || ' AS mapzone_id,
						ARRAY(
							SELECT value::int
							FROM json_array_elements_text(use_item->''toArc'') AS elem(value)
						) AS to_arc,
						(use_item->>''nodeParent'')::int AS node_id
					FROM ' || v_mapzone_name || ',
						LATERAL json_array_elements(graphconfig->''use'') AS use_item
					WHERE graphconfig IS NOT NULL 
					AND active
				) AS s 
				WHERE n.node_id = s.node_id
				';
		ELSE
			v_query_text =
                'UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = ''' || v_mapzone_name || ''', mapzone_id = s.mapzone_id
                FROM (
                    SELECT ' || v_mapzone_field || ' AS mapzone_id,
                    nullif ((json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'','''')::int4 AS node_id
                    FROM ' || v_mapzone_name || ' 
                    WHERE graphconfig IS NOT NULL 
                    AND active
                ) AS s 
                WHERE n.node_id = s.node_id';
		END IF;
		EXECUTE v_query_text; 
		-- Nodes forceClosed
		v_query_text =
			'UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = ''FORCECLOSED'' 
			FROM (
				SELECT (json_array_elements_text((graphconfig->>''forceClosed'')::json))::int4 AS node_id
				FROM ' || v_mapzone_name || ' 
				WHERE graphconfig IS NOT NULL 
				AND active
			) s 
			WHERE n.node_id = s.node_id';
		EXECUTE v_query_text;

		-- Nodes "ignore", should not be disconnected
		v_query_text =
			'UPDATE temp_pgr_node n SET modif = FALSE, graph_delimiter = ''IGNORE'' 
			FROM (
				SELECT (json_array_elements_text((graphconfig->>''ignore'')::json))::int4 AS node_id
				FROM ' || v_mapzone_name || ' 
				WHERE graphconfig IS NOT NULL 
				AND active 
			) s 
			WHERE n.node_id = s.node_id';
		EXECUTE v_query_text;             
    END IF;

	IF v_project_type = 'UD' THEN
        UPDATE temp_pgr_node t
        SET to_arc = a.to_arc
        FROM (
                SELECT pgr_node_1, array_agg(arc_id) AS to_arc
                FROM temp_pgr_arc
                GROUP BY pgr_node_1
            ) a
        WHERE t.graph_delimiter = v_mapzone_name AND t.modif = TRUE AND t.pgr_node_id = a.pgr_node_1;

		-- save as graph_delimiter the arcs 'INITOVERFLOWPATH', without creating new arcs (modif will not be set to TRUE neither for node_1 nor for the arc)
		UPDATE temp_pgr_arc t
        SET graph_delimiter = 'INITOVERFLOWPATH'
        FROM v_temp_arc v
        WHERE v.arc_id = t.arc_id AND v.initoverflowpath; 
    END IF;
    
	-- Nodes forceClosed acording init parameters
	UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = 'FORCECLOSED'
	WHERE n.node_id IN (SELECT (json_array_elements_text((v_parameters->>'forceClosed')::json))::int4);

	-- Nodes forceOpen acording init parameters
	UPDATE temp_pgr_node n SET modif = FALSE, graph_delimiter = 'IGNORE'
	WHERE n.node_id IN (SELECT (json_array_elements_text((v_parameters->>'forceOpen')::json))::int4);


	-- Generate new arcs

	-- =======================
    SELECT gw_fct_graphanalytics_arrangenetwork() INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Note: node_id IS NULL AND arc_id IS NULL for the new nodes/arcs generated
	
	-- for nodes graph_delimiter
    IF v_project_type = 'WS' THEN
		-- disconect InletArcs for nodes graph_delimiter
		UPDATE temp_pgr_arc  SET cost = -1, reverse_cost = -1
		WHERE graph_delimiter = v_mapzone_name
		AND old_arc_id <> ALL (to_arc);
	ELSE
		-- for UD - disconnect the to_arc arcs
        UPDATE temp_pgr_arc  SET cost = -1, reverse_cost = -1
        WHERE graph_delimiter = v_mapzone_name
        AND old_arc_id = ANY (to_arc);

		-- arcs that connects with nodes IGNORE
        UPDATE temp_pgr_arc t
	    SET cost = 1, reverse_cost = 1
	    FROM temp_pgr_node n 
	    WHERE n.pgr_node_id IN (t.pgr_node_1, t.pgr_node_2) AND n.graph_delimiter = 'IGNORE';
	END IF;

    EXECUTE 'SELECT COUNT(*)::INT FROM temp_pgr_arc'
    INTO v_pgr_distance;

	EXECUTE 'SELECT array_agg(pgr_node_id)::INT[] 
			FROM temp_pgr_node 
			WHERE graph_delimiter = ''' || v_mapzone_name || ''' 
			AND modif = TRUE'
	INTO v_pgr_root_vids;

	IF v_project_type = 'WS' THEN
		v_source= 'pgr_node_1';
		v_target= 'pgr_node_2';
	ELSE
		v_source= 'pgr_node_2';
		v_target= 'pgr_node_1';
	END IF;

	-- Execute pgr_drivingDistance function
	IF v_project_type = 'UD' AND v_mapzone_name = 'DWFZONE' THEN
		v_query_text = 'SELECT pgr_arc_id AS id, ' || v_source || ' AS source, ' || v_target || ' AS target, cost, reverse_cost 
			FROM temp_pgr_arc
			WHERE graph_delimiter <> ''INITOVERFLOWPATH'' AND reverse_cost < 0'; -- if pgr_node_1 or pgr_node_2 have graph_delimiter = IGNORE, the arcs will not be ignored
	ELSE
		v_query_text = 'SELECT pgr_arc_id AS id, ' || v_source || ' AS source, ' || v_target || ' AS target, cost, reverse_cost 
			FROM temp_pgr_arc';
	END IF;

    INSERT INTO temp_pgr_drivingdistance(seq, "depth", start_vid, pred, node, edge, "cost", agg_cost)
    (
		SELECT seq, "depth", start_vid, pred, node, edge, "cost", agg_cost
		FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
    );

	v_query_text = '
		SELECT seq AS id, start_vid AS source, node AS target, 1 AS COST
		FROM temp_pgr_drivingdistance t
	';
	INSERT INTO temp_pgr_connectedcomponents (seq,component, node)
	SELECT seq,component, node
	FROM pgr_connectedComponents(v_query_text);

	-- generating zones
	INSERT INTO temp_pgr_mapzone (component, mapzone_id)
	SELECT component, array_agg(DISTINCT n.mapzone_id)
	FROM temp_pgr_connectedcomponents c
	JOIN temp_pgr_node n ON n.pgr_node_id = c.node
	WHERE n.graph_delimiter = v_mapzone_name AND modif = TRUE 
	GROUP BY c.component;

	-- Update mapzone_id
	IF v_fromzero = TRUE THEN
		EXECUTE 'SELECT max( ' || v_mapzone_field || ') FROM '|| v_mapzone_name
		INTO v_mapzone_id;
		UPDATE temp_pgr_mapzone m SET mapzone_id = ARRAY[v_mapzone_id + m.id];
	END IF;

	IF v_updatemapzgeom > 0 THEN
		-- message
		INSERT INTO temp_audit_check_data (fid, criticity, error_message)
		VALUES (v_fid, 1, concat('INFO: ',v_class,' values for features and geometry of the mapzone has been modified by this process'));
	END IF;

	-- Update nodes and arcs: "mapzone_id" = temp_pgr_mapzone."component"!
	-- in the temp_pgr_mapzone, the components that contain mapzones in conflict are the ones with CARDINALITY(m.mapzone_id)>1
	UPDATE temp_pgr_node n SET mapzone_id = c.component
	FROM temp_pgr_connectedcomponents c
	WHERE c.node = n.pgr_node_id;

	-- Update arcs
	EXECUTE 'UPDATE temp_pgr_arc a SET mapzone_id = n.mapzone_id
	FROM temp_pgr_node n
	WHERE ((a.' || v_source || ' = n.pgr_node_id AND a.cost >= 0)
	OR (a.' || v_target || ' = n.pgr_node_id AND reverse_cost >= 0))
	AND n.mapzone_id <> 0
	';

	-- Now set to 0 the nodes that connect arcs with different mapzone_id
	-- Note: if a closed valve, for example, is between sector 2 and sector 3, it means it is a boundary, it will have '0' as mapzone_id; if it is between -1 and 2 it will also have 0;
	-- However, if a closed valve is between arcs with the same sector, it retains it; if it is between 1 and 1, it retains 1, meaning it is not a boundary; if it is between -1 and -1, it does not change, it retains Conflict

	IF v_project_type = 'WS' THEN
		-- Set to 0 the boundary nodes of mapzones
		WITH boundary AS (
			SELECT COALESCE(n1.node_id, n2.node_id) AS node_id
			FROM temp_pgr_arc a
			JOIN temp_pgr_node n1 on a.pgr_node_1 = n1.pgr_node_id
			JOIN temp_pgr_node n2 on a.pgr_node_2 = n2.pgr_node_id
			WHERE a.graph_delimiter = 'MINSECTOR'
			AND n1.mapzone_id <> 0 AND n2.mapzone_id <> 0
			AND n1.mapzone_id <> n2.mapzone_id
			)
		UPDATE temp_pgr_node n SET mapzone_id = 0
		FROM boundary AS s
		WHERE n.node_id = s.node_id AND n.graph_delimiter = 'MINSECTOR';
	END IF;

	IF v_updatemapzgeom > 0 THEN
		-- message
		INSERT INTO temp_audit_check_data (fid, criticity, error_message)
		VALUES (v_fid, 1, concat('INFO: ',v_class,' values for features and geometry of the mapzone has been modified by this process'));
	END IF;



	-- CONFLICT COUNTS
	IF v_floodonlymapzone IS NULL THEN
		IF v_class != 'DWFZONE' THEN
				SELECT count(*) 
				INTO v_arcs_count 
				FROM temp_pgr_arc a
				JOIN temp_pgr_mapzone m ON m.component = a.mapzone_id 
				WHERE a.arc_id IS NOT NULL AND CARDINALITY(m.mapzone_id) >1;

				SELECT count(*) 
				INTO v_connecs_count 
				FROM temp_pgr_arc a 
				JOIN temp_pgr_mapzone m ON m.component = a.mapzone_id 
				JOIN v_temp_connec vc USING (arc_id) 
				WHERE CARDINALITY(m.mapzone_id) >1;

				-- log TODO DANIs: v_mapzones_count no esta calculat; què interesa? numero? o retornem un string amb l'array de totes les mapzones en conflicte? 
				IF v_arcs_count > 0 OR v_connecs_count > 0 THEN
					INSERT INTO temp_audit_check_data (fid,  criticity, error_message)
					VALUES (v_fid, 2, concat('WARNING-395: There is a conflict against ',v_mapzone_name,'''s (',v_mapzones_count,') with ',v_arcs_count,' arc(s) and ',v_connecs_count,' connec(s) affected.'));
				END IF;
		END IF;
	END IF;

	-- DISCONECTED COUNTS
	IF v_floodonlymapzone IS NULL THEN

		RAISE NOTICE 'Disconnected arcs';
		SELECT COUNT(t.*) INTO v_arcs_count
		FROM temp_pgr_arc t
		WHERE  a.arc_id IS NOT NULL AND t.mapzone_id = 0;

		IF v_arcs_count > 0 THEN
			INSERT INTO temp_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 2, concat('WARNING-',v_fid,': ', v_count ,' arc''s have been disconnected'));
		ELSE
			INSERT INTO temp_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 1, concat('INFO: 0 arc''s have been disconnected'));
		END IF;

		RAISE NOTICE 'Disconnected connecs';
		IF v_arcs_count > 0 THEN
			SELECT COUNT(ta.*) INTO v_connecs_count
			FROM temp_pgr_arc ta
			JOIN v_temp_connec vc USING (arc_id)
			WHERE ta.mapzone_id = 0;

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

	RAISE NOTICE 'Creating geometry of mapzones';
	-- SECTION: Creating geometry of mapzones

	IF v_updatemapzgeom = 0 THEN
		-- do nothing

	ELSIF  v_updatemapzgeom = 1 THEN

		-- concave polygon
		v_query_text = '
			UPDATE temp_pgr_mapzone m SET the_geom = ST_Multi(a.the_geom) 
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
			WHERE a.mapzone_id = m.component
			AND CARDINALITY(m.mapzone_id) = 1';
		EXECUTE v_query_text;

	ELSIF  v_updatemapzgeom = 2 THEN

		-- pipe buffer
		v_query_text = '
			UPDATE temp_pgr_mapzone m SET the_geom = geom 
			FROM (
				SELECT mapzone_id, ST_Multi(ST_Buffer(ST_Collect(the_geom),'||v_geomparamupdate||')) AS geom 
				FROM temp_pgr_arc a 
				JOIN v_temp_arc USING (arc_id)
				GROUP BY mapzone_id
			) a 
			WHERE a.mapzone_id = m.component
			AND CARDINALITY(m.mapzone_id) = 1';
		EXECUTE v_query_text;

	ELSIF  v_updatemapzgeom = 3 THEN

		-- use plot and pipe buffer
		v_query_text = '
			UPDATE temp_pgr_mapzone m SET the_geom = geom FROM (
				SELECT mapzone_id, ST_Multi(ST_Buffer(ST_Collect(geom),0.01)) AS geom FROM (
					SELECT mapzone_id, ST_Buffer(ST_Collect(the_geom), '||v_geomparamupdate||') AS geom FROM temp_pgr_arc a
					JOIN v_temp_arc USING (arc_id) 
					GROUP BY mapzone_id
					UNION
					SELECT mapzone_id, ST_Collect(ext_plot.the_geom) AS geom FROM temp_pgr_arc ta
					JOIN v_temp_connec vc USING (arc_id) 
					LEFT JOIN ext_plot ON vc.plot_code = ext_plot.plot_code
					LEFT JOIN ext_plot ON ST_DWithin(vc.the_geom, ext_plot.the_geom, 0.001)
					GROUP BY mapzone_id	
				) a 
				GROUP BY mapzone_id 
			) b 
			WHERE b.mapzone_id= m.component
			AND CARDINALITY(m.mapzone_id) = 1';
		EXECUTE v_query_text;

	ELSIF  v_updatemapzgeom = 4 THEN

		v_geomparamupdate_divide = v_geomparamupdate / 2;

		-- use link and pipe buffer
		v_query_text = '
			UPDATE temp_pgr_mapzone m SET the_geom = b.geom FROM (
				SELECT c.mapzone_id, ST_Multi(ST_Buffer(ST_Collect(c.geom),0.01)) AS geom FROM (
					SELECT a.mapzone_id, ST_Buffer(ST_Collect(va.the_geom), '||v_geomparamupdate||') AS geom 
					FROM temp_pgr_arc a 
					JOIN v_temp_arc va ON a.arc_id = va.arc_id
					GROUP BY a.mapzone_id
					UNION
					SELECT ta.mapzone_id, (ST_Buffer(ST_Collect(vlc.the_geom),'||v_geomparamupdate_divide||',''endcap=flat join=round'')) AS geom 
					FROM temp_pgr_arc ta
					JOIN v_temp_link_connec vlc ON ta.arc_id = vlc.arc_id
					GROUP BY ta.mapzone_id
				) c 
				GROUP BY c.mapzone_id 
			) b
			WHERE b.mapzone_id = m.component
			AND CARDINALITY(m.mapzone_id) = 1';

		EXECUTE v_query_text;
	END IF;


	--TODO DANI: REVISAR amb Claudia a partir d'aquesta linia, em sembla que es repeteix codi; falta afegir gully

	IF v_floodonlymapzone IS NULL THEN
		v_result = NULL;
		IF v_commitchanges IS TRUE THEN
			-- disconnected and conflict arcs TODO DANI - en cas de Conflict, en el select, passar el temp_pgr_mapzone.mapzone_id - és un array que a lo millor es pot transformar en string
			EXECUTE '
				SELECT jsonb_agg(features.feature) 
				FROM (
					SELECT jsonb_build_object(
						''type'',       ''Feature'',
						''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
						''properties'', to_jsonb(row) - ''the_geom''
					) AS feature
					FROM (
						SELECT ta.arc_id, va.arccat_id, va.state, va.expl_id, NULL AS mapzone_id, va.the_geom, ''Disconnected''::text AS descript 
						FROM temp_pgr_arc ta
						JOIN v_temp_arc va USING (arc_id)
						WHERE ta.mapzone_id = 0
						UNION
						SELECT DISTINCT ON (ta.arc_id) ta.arc_id, va.arccat_id, va.state, va.expl_id, NULL AS mapzone_id, va.the_geom, ''Conflict''::text AS descript 
						FROM temp_pgr_arc ta
						JOIN v_temp_arc va USING (arc_id)
						JOIN temp_pgr_mapzone m ON m.component = ta.mapzone_id 
						WHERE CARDINALITY(m.mapzone_id) >1
					) row 
				) features
			' INTO v_result;
			
			SELECT EXISTS (
				SELECT 1
				FROM (
					SELECT ta.arc_id, va.arccat_id, va.state, va.expl_id, NULL AS mapzone_id, va.the_geom, 'Conflict'::text AS descript
					FROM temp_pgr_arc ta
					JOIN v_temp_arc va USING (arc_id)
					JOIN temp_pgr_mapzone m ON m.component = ta.mapzone_id 
					WHERE CARDINALITY(m.mapzone_id) >1
				) s
			) INTO v_has_conflicts;

			v_result := COALESCE(v_result, '{}');
			v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}');
		END IF;
		--DANI - DUBTE: perquè disconnected and conflicts arcs esta a dins del IF v_commitchanges IS TRUE, en canvi isconnected and conflict connecs no?
		
		-- disconnected and conflict connecs
		v_result = NULL;
		-- TODO[epic=mapzones]: add orphan connecs DANI: com en el cas dels arcs, en cas de Conflict, en el select, passar el temp_pgr_mapzone.mapzone_id - és un array que a lo millor es pot transformar en string
		EXECUTE '
			SELECT jsonb_agg(features.feature)
			FROM (
				SELECT jsonb_build_object(
					''type'',       ''Feature'',
					''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
					''properties'', to_jsonb(row) - ''the_geom''
				) AS feature
				FROM (
					SELECT vc.connec_id, vc.conneccat_id, vc.state, vc.expl_id, NULL AS mapzone_id, vc.the_geom, ''Disconnected''::text AS descript
					FROM temp_pgr_arc ta
					JOIN v_temp_connec vc USING (arc_id)
					WHERE ta.mapzone_id = 0
					UNION
					SELECT vc.connec_id, vc.conneccat_id, vc.state, vc.expl_id, NULL AS mapzone_id, vc.the_geom, ''Conflict''::text AS descript
					FROM temp_pgr_arc ta
					JOIN v_temp_connec vc USING (arc_id)
					JOIN temp_pgr_mapzone m ON m.component = ta.mapzone_id 
					WHERE CARDINALITY(m.mapzone_id) >1
				) row
			) features
		' INTO v_result;

		v_result := COALESCE(v_result, '{}');
		v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}');
	END IF;


	IF v_commitchanges IS FALSE THEN
		-- arc elements
		IF v_floodonlymapzone IS NULL THEN
			v_query_text = '
			SELECT jsonb_agg(features.feature) 
			FROM (
				SELECT jsonb_build_object(
					''type'',       ''Feature'',
					''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
					''properties'', to_jsonb(row) - ''the_geom''
				) AS feature
				FROM (
					SELECT DISTINCT ON (ta.arc_id) ta.arc_id, vc.conneccat_id, vc.state, vc.expl_id, NULL AS mapzone_id, vc.the_geom, ''Disconnected''::text AS descript 
					FROM temp_pgr_arc ta
					JOIN v_temp_connec vc USING (arc_id)
					WHERE ta.mapzone_id = 0
					AND ta.arc_id IS NOT NULL
					UNION
					SELECT DISTINCT ON (ta.arc_id) ta.arc_id, vc.conneccat_id, vc.state, vc.expl_id, NULL AS mapzone_id, vc.the_geom, ''Conflict''::text AS descript 
					FROM temp_pgr_arc ta
					JOIN v_temp_connec vc USING (arc_id)
					WHERE ta.mapzone_id = -1
					AND ta.arc_id IS NOT NULL
					UNION
					SELECT ta.arc_id, vc.conneccat_id, vc.state, vc.expl_id, ta.mapzone_id::TEXT AS mapzone_id, vc.the_geom, m.name AS descript 
					FROM temp_pgr_arc ta
					JOIN v_temp_connec vc USING (arc_id)
					JOIN '|| v_mapzone_name ||' m ON ta.mapzone_id = m.'|| v_mapzone_field ||'
					WHERE m.'|| v_mapzone_field ||'::integer > 0
					AND ta.arc_id IS NOT NULL
				) row 
			) features';
			EXECUTE v_query_text INTO v_result;

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
						SELECT ta.arc_id, va.arccat_id, va.state, va.expl_id, ta.mapzone_id::TEXT AS mapzone_id, va.the_geom, m.name AS descript 
						FROM temp_pgr_arc ta
						JOIN v_temp_arc va USING (arc_id)
						JOIN '|| v_mapzone_name ||' m ON ta.mapzone_id = m.'|| v_mapzone_field ||'
						WHERE '|| v_mapzone_field ||'::integer IN ('||v_floodonlymapzone||')
						AND ta.arc_id IS NOT NULL
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
					SELECT tn.mapzone_id::TEXT AS mapzone_id, m.name AS descript, '||v_fid||' AS fid, vn.expl_id, vn.the_geom
					FROM temp_pgr_node tn
					JOIN v_temp_node vn USING (node_id)
					JOIN '|| v_mapzone_name ||' m ON tn.mapzone_id = m.'|| v_mapzone_field ||'
					WHERE tn.node_id IS NOT NULL
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

			IF v_fromzero = TRUE THEN
				IF v_project_type = 'WS' THEN
					v_query_text = 'INSERT INTO '||v_mapzone_name||' ('||v_mapzone_field||',code, name, the_geom, created_at, created_by, updated_at, updated_by, graphconfig) 
					SELECT m.mapzone_id[1], m.mapzone_id[1], m.mapzone_id[1], m.the_geom, now(), current_user, now(), current_user,
					json_build_object(
						''use'', json_agg(
						json_build_object(
							''nodeParent'', node_id::text,
							''toArc'', to_arc
						)
						),
						''ignore'', ''[]''::json,
						''forceClosed'', ''[]''::json
					) as graphconfig
					FROM temp_pgr_mapzone m
					JOIN temp_pgr_node n ON n.mapzone_id = m.component 
					WHERE n.graph_delimiter = ' || v_mapzone_name || ' AND n.modif = TRUE
					GROUP BY m.mapzone_id[1]';
				ELSE
					v_query_text = 'INSERT INTO '||v_mapzone_name||' ('||v_mapzone_field||',code, name, the_geom, created_at, created_by, updated_at, updated_by, graphconfig) 
					SELECT m.mapzone_id[1], m.mapzone_id[1], m.mapzone_id[1], m.the_geom, now(), current_user, now(), current_user,
					json_build_object(
						''use'', json_agg(
						json_build_object(
							''nodeParent'', node_id::text
						)
						),
						''ignore'', ''[]''::json,
						''forceClosed'', ''[]''::json
					) as graphconfig
					FROM temp_pgr_mapzone m
					JOIN temp_pgr_node n ON n.mapzone_id = m.component 
					WHERE n.graph_delimiter = ' || v_mapzone_name || ' AND n.modif = TRUE
					GROUP BY m.mapzone_id[1]';
				END IF;
			ELSE
				v_query_text = 'UPDATE '||v_mapzone_name||' m SET 
					the_geom = t.the_geom, 
					updated_at = now(), 
					updated_by = current_user 
				FROM (SELECT component, UNNEST (mapzone_id) AS mapzone_id, the_geom FROM temp_pgr_mapzone) t 
				WHERE t.mapzone_id = m.'||v_mapzone_field;
			END IF;
			EXECUTE v_query_text;

			v_query_text = 'UPDATE '||v_mapzone_name||' SET 
				expl_id = subq.expl_ids,
				muni_id = subq.muni_ids,
				sector_id = subq.sector_ids,
				updated_at = now(), 
				updated_by = current_user 
			FROM (
				SELECT 
					tm.mapzone_id,
					array_agg(DISTINCT vn.expl_id)::int[] AS expl_ids,
					array_agg(DISTINCT vn.muni_id)::int[] AS muni_ids,
					array_agg(DISTINCT vn.sector_id)::int[] AS sector_ids
				FROM temp_pgr_node tn
				JOIN v_temp_node vn USING (node_id)
				JOIN (SELECT component, UNNEST (mapzone_id) AS mapzone_id FROM temp_pgr_mapzone) tm ON tn.mapzone_id = tm.component
				WHERE tn.mapzone_id > 0 
				GROUP BY tm.component
			) subq
			WHERE subq.mapzone_id = '||v_mapzone_name||'.'||v_mapzone_field;
			EXECUTE v_query_text;

			-- old zone id array
			SELECT string_agg(a.old_mapzone_id::text, ',') INTO v_old_mapzone_id_array
			FROM (
				SELECT DISTINCT old_mapzone_id FROM temp_pgr_node
			) a
			WHERE a.old_mapzone_id > 0;

			v_query_text = '
				WITH arcs AS (
					SELECT 
						a.arc_id,
						CASE WHEN CARDINALITY(m.mapzone_id)  = 1 THEN m.mapzone_id[1]
						ELSE 0
						END AS mapzone_id
					FROM temp_pgr_arc a
					JOIN temp_pgr_mapzone m ON a.mapzone_id = m.component
				)
				UPDATE arc SET '||quote_ident(v_mapzone_field)||' = arcs.mapzone_id
				FROM arcs
				WHERE arc.arc_id = arcs.arc_id
				AND arc.'||quote_ident(v_mapzone_field)||' <> arcs.mapzone_id;
			';
			EXECUTE v_query_text;

			v_query_text = '
				WITH nodes AS (
					SELECT 
						n.node_id,
						CASE WHEN CARDINALITY(m.mapzone_id)  = 1 THEN m.mapzone_id[1]
						ELSE 0
						END AS mapzone_id
					FROM temp_pgr_node n
					JOIN temp_pgr_mapzone m ON n.mapzone_id = m.component
				)
				UPDATE node SET '||quote_ident(v_mapzone_field)||' = nodes.mapzone_id
				FROM nodes
				WHERE node.node_id = nodes.node_id
				AND node.'||quote_ident(v_mapzone_field)||' <> nodes.mapzone_id;
			';
			EXECUTE v_query_text;

			v_query_text = '
				WITH connecs AS (
					SELECT 
						c.connec_id,
						CASE WHEN CARDINALITY(m.mapzone_id)  = 1 THEN m.mapzone_id[1]
						ELSE 0
						END AS mapzone_id
					FROM temp_pgr_arc a
					JOIN temp_pgr_mapzone m ON a.mapzone_id = m.component
					JOIN v_temp_connec c ON a.arc_id = c.arc_id
				)
				UPDATE connec SET '||quote_ident(v_mapzone_field)||' = connecs.mapzone_id
				FROM connecs
				WHERE connec.connec_id = connecs.connec_id
				AND connec.'||quote_ident(v_mapzone_field)||' <> connecs.mapzone_id;
			';
			EXECUTE v_query_text;

			v_query_text = '
				WITH links AS (
					SELECT 
						c.link_id,
						CASE WHEN CARDINALITY(m.mapzone_id)  = 1 THEN m.mapzone_id[1]
						ELSE 0
						END AS mapzone_id
					FROM temp_pgr_arc a
					JOIN temp_pgr_mapzone m ON a.mapzone_id = m.component
					JOIN v_temp_link_connec c ON a.arc_id = c.arc_id
				)
				UPDATE link SET '||quote_ident(v_mapzone_field)||' = links.mapzone_id
				FROM links
				WHERE link.link_id = links.link_id
				AND link.'||quote_ident(v_mapzone_field)||' <> links.mapzone_id;
			';
			EXECUTE v_query_text;

			IF v_old_mapzone_id_array IS NOT NULL THEN
				v_query_text = 'UPDATE arc SET '||quote_ident(v_mapzone_field)||' = 0
					WHERE '||quote_ident(v_mapzone_field)||' IN ('||v_old_mapzone_id_array||')
					AND NOT EXISTS (
						SELECT 1 FROM temp_pgr_arc tpa WHERE tpa.arc_id = arc.arc_id
					)
				';
				EXECUTE v_query_text;

				v_query_text = 'UPDATE node SET '||quote_ident(v_mapzone_field)||' = 0
					WHERE '||quote_ident(v_mapzone_field)||' IN ('||v_old_mapzone_id_array||')
					AND NOT EXISTS (
						SELECT 1 FROM temp_pgr_node tpn WHERE tpn.node_id = node.node_id
					)
				';
				EXECUTE v_query_text;

				v_query_text = 'UPDATE connec SET '||quote_ident(v_mapzone_field)||' = 0
					WHERE '||quote_ident(v_mapzone_field)||' IN ('||v_old_mapzone_id_array||')
					AND NOT EXISTS (
						SELECT 1 FROM temp_pgr_arc ta JOIN v_temp_connec vc USING (arc_id) WHERE vc.connec_id = connec.connec_id
					)
				';
				EXECUTE v_query_text;

				v_query_text = 'UPDATE link SET '||quote_ident(v_mapzone_field)||' = 0
					WHERE '||quote_ident(v_mapzone_field)||' IN ('||v_old_mapzone_id_array||')
					AND NOT EXISTS (
						SELECT 1 FROM temp_pgr_arc ta JOIN v_temp_link_connec vc USING (arc_id) WHERE vc.link_id = link.link_id
					)
				';
				EXECUTE v_query_text;
			END IF;

			-- static pressure for
			IF v_class = 'PRESSZONE' THEN
				v_query_text = '
					UPDATE temp_pgr_node SET staticpressure = (a.head - a.top_elev + (CASE WHEN a.depth IS NULL THEN 0 ELSE a.depth END)::float)
					FROM (
						SELECT n.node_id, p.head, vn.top_elev, vn.depth
						FROM temp_pgr_node n
						JOIN v_temp_node vn ON vn.node_id = n.node_id
						JOIN '||v_mapzone_name||' p ON vn.mapzone_id = p.'||v_mapzone_field||'
					) a
					WHERE temp_pgr_node.node_id = a.node_id
					AND temp_pgr_node.staticpressure <> (a.head - a.top_elev + (CASE WHEN a.depth IS NULL THEN 0 ELSE a.depth END)::float)
				';
				EXECUTE v_query_text;
				-- arcs
				UPDATE arc SET staticpress1 = n.staticpressure 
				FROM temp_pgr_node n 
				WHERE node_id = node_1 
				AND (staticpress1 <> n.staticpressure OR staticpress1 IS NULL);
				UPDATE arc SET staticpress2 = n.staticpressure 
				FROM temp_pgr_node n 
				WHERE node_id = node_2 
				AND (staticpress2 <> n.staticpressure OR staticpress2 IS NULL);
				-- nodes
				UPDATE node n
				SET staticpressure = t.staticpressure 
				FROM temp_pgr_node t 
				WHERE n.node_id=t.node_id
				AND (n.staticpressure <> t.staticpressure OR n.staticpressure IS NULL);
				-- connecs todo claudia corregir
				v_query_text = '
					UPDATE connec SET staticpressure = (a.head - a.top_elev + (CASE WHEN a.depth IS NULL THEN 0 ELSE a.depth END)::float)
					FROM (
						SELECT vc.connec_id, p.head, vc.top_elev, vc.depth
						FROM temp_pgr_arc ta JOIN v_temp_connec vc USING (arc_id)
						JOIN '||v_mapzone_name||' p ON ta.mapzone_id = p.'||v_mapzone_field||'
					) a
					WHERE connec.connec_id = a.connec_id;
				';
				EXECUTE v_query_text;
				-- links
				v_query_text = '
					UPDATE link SET staticpressure = (a.head - a.top_elev + (CASE WHEN a.depth IS NULL THEN 0 ELSE a.depth END)::float)
					FROM (
						SELECT vc.link_id, p.head, vc.top_elev, vc.depth
						FROM temp_pgr_arc ta JOIN v_temp_link_connec vc USING (arc_id)
						JOIN '||v_mapzone_name||' p ON ta.mapzone_id = p.'||v_mapzone_field||'
					) a
					WHERE link.link_id = a.link_id;
				';
				EXECUTE v_query_text;
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

