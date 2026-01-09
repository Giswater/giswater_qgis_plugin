/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
-- The code of this inundation function have been provided by Claudia Dragoste (Aigues de Manresa, S.A.)

--FUNCTION CODE: 3508

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_mapzones_v1(json);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_mapzones_v1(jsonb);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_mapzones_v1(p_data jsonb)
RETURNS jsonb AS
$BODY$

/* Example usage:

-- QUERY SAMPLE
SELECT gw_fct_graphanalytics_mapzones('
	{
		"data":{
			"parameters":{
				"graphClass":"DWFZONE",
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
*/

DECLARE

	-- system variables
	v_version text;
	v_srid integer;
	v_project_type text;
	v_fid integer;

	-- dialog variables
	v_class text;
	v_expl_id text;
	v_expl_id_array text[];
	v_update_map_zone integer = 0;
	v_geom_param_update float;
	v_use_plan_psector boolean;
	v_commit_changes boolean;
	v_netscenario integer;
	v_reverse_cost INTEGER;
	v_reverse_cost_new_arcs INTEGER;

	-- geometry variables
	v_geom_param_update_divide float;
	v_concave_hull float = 0.9;

	-- TODO: finish v_from_zero
	v_from_zero boolean = FALSE;

    v_parameters json;
	--
	v_audit_result text;
	v_has_conflicts boolean = false;
	v_source text;
	v_target text;

	v_mapzone_count integer;
	v_arcs_count integer;
	v_nodes_count integer;
	v_connecs_count integer;
	v_gullies_count integer;
	v_mapzones_ids text;

	v_mapzone_name text;
	v_table_name text;
	v_mapzone_field text;
	v_visible_layer text;
	v_mapzone_id int4;
	v_pgr_distance integer;
	v_pgr_root_vids int[];
	v_count INTEGER;

	-- query variables
	v_query_text text;
	v_query_text_aux text;
	v_data json;
	rec_man record;

	-- result variables
	v_result text;
	v_result_info json;
	v_result_point json;
	v_result_line json;
	v_result_polygon json;

	-- response variables
	v_level integer;
	v_status text;
	v_message text;
	v_response JSON;

	v_error_context text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
	SELECT giswater, epsg, UPPER(project_type) INTO v_version, v_srid, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
	v_class := p_data->'data'->'parameters'->>'graphClass';
	v_expl_id := p_data->'data'->'parameters'->>'exploitation';
	v_update_map_zone := p_data->'data'->'parameters'->>'updateMapZone';
	v_geom_param_update := p_data->'data'->'parameters'->>'geomParamUpdate';
	v_use_plan_psector := p_data->'data'->'parameters'->>'usePlanPsector';
	v_commit_changes := p_data->'data'->'parameters'->>'commitChanges';
	v_netscenario := p_data->'data'->'parameters'->>'netscenario';

	-- TODO: add new param to calculate mapzones from zero
	v_from_zero := p_data->'data'->'parameters'->>'fromZero';

	-- extra parameters
	v_parameters := p_data->'data'->'parameters';


	-- it's not allowed to commit changes when psectors are used
 	IF v_use_plan_psector THEN
		v_commit_changes := FALSE;
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
		"data":{"message":"3090", "function":"3508","parameters":null, "is_process":true}}$$);' INTO v_audit_result;
	END IF;

	-- SECTION[epic=mapzones]: SET VARIABLES
	v_mapzone_name = LOWER(v_class);
	v_table_name = v_mapzone_name;
    v_mapzone_field = v_mapzone_name || '_id';
	v_visible_layer = 've_' || v_mapzone_name;
	IF v_netscenario IS NOT NULL THEN
		v_table_name = 'plan_netscenario_' || v_mapzone_name;
		v_visible_layer = 've_plan_netscenario_' || v_mapzone_name;
		v_from_zero = FALSE; -- from zero is not allowed for netscenario
	END IF;
	v_mapzone_name = UPPER(v_mapzone_name);

    -- Get exploitation ID array
    v_expl_id_array = gw_fct_get_expl_id_array(v_expl_id);

	IF v_from_zero THEN
		v_query_text := 'SELECT count (*) FROM '|| v_table_name ||' 
		WHERE active
		AND '|| v_mapzone_field ||' NOT IN (0, -1) -- 0 and -1 are conflict and undefined
		AND expl_id && ARRAY['||array_to_string(v_expl_id_array, ',')||']';
		EXECUTE v_query_text INTO v_mapzone_count;
		IF v_mapzone_count > 0 AND v_commit_changes = TRUE THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	        "data":{"message":"4346", "function":"3508","parameters":{"mapzone_name":"'|| v_mapzone_name ||'"}, "is_process":true}}$$)';
		END IF;
	END IF;

	-- Delete temporary tables
	-- =======================
	v_data := '{"data":{"action":"DROP", "fct_name":"'|| v_class ||'"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

	-- Create temporary tables
	-- =======================
	v_data := '{"data":{"action":"CREATE", "fct_name":"'|| v_class ||'", "use_psector":"'|| v_use_plan_psector ||'", "netscenario":"'|| quote_nullable(v_netscenario) ||'"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Start Building Log Message
	-- =======================
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('MAPZONES DYNAMIC SECTORITZATION - ', upper(v_class)));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('------------------------------------------------------------------'));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Use psectors: ', upper(v_use_plan_psector::text)));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Mapzone constructor method: ', upper(v_update_map_zone::text)));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Update feature mapzone attributes: ', upper(v_commit_changes::text)));

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
	IF v_project_type = 'WS' THEN
		v_reverse_cost := 1;
	ELSE
		v_reverse_cost := -1;
    END IF;

    v_data := jsonb_build_object(
        'data', jsonb_build_object(
            'expl_id_array', array_to_string(v_expl_id_array, ','),
            'mapzone_name', v_mapzone_name,
			'cost', 1,
			'reverse_cost', v_reverse_cost
        )
    )::text;

    SELECT gw_fct_graphanalytics_initnetwork(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	EXECUTE '
		UPDATE temp_pgr_node n SET old_mapzone_id = ' || v_mapzone_field || '
		FROM v_temp_node t WHERE n.node_id = t.node_id; 
	';

	EXECUTE '
		UPDATE temp_pgr_arc a SET old_mapzone_id = ' || v_mapzone_field || '
		FROM v_temp_arc t WHERE a.arc_id = t.arc_id;
	';

	-- NODES TO MODIFY
	IF v_project_type = 'WS' THEN

		-- NODES VALVES (MINSECTOR)
		UPDATE temp_pgr_node t
		SET
			graph_delimiter = 'MINSECTOR',
			closed = v.closed,
			broken = v.broken,
			to_arc = v.to_arc
		FROM (
			SELECT
			n.node_id,
			v.closed,
			v.broken,
			CASE
				WHEN to_arc IS NULL THEN NULL
				ELSE ARRAY[to_arc]
			END AS to_arc
			FROM v_temp_node n
			JOIN man_valve v ON v.node_id = n.node_id
			WHERE 'MINSECTOR' = ANY(n.graph_delimiter)
		) v
		WHERE t.node_id = v.node_id; 

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

	-- CLOSED AND OPEN VALVES FROM NETSCENARIO
	-- ======================================
	IF v_netscenario IS NOT NULL THEN
		-- closed valves
		UPDATE temp_pgr_node n
		SET closed = TRUE, broken = FALSE, graph_delimiter = 'MINSECTOR', modif = TRUE
		FROM plan_netscenario_valve v
		WHERE n.node_id = v.node_id
		AND v.netscenario_id = v_netscenario
		AND v.closed IS TRUE;

		-- open valves
		UPDATE temp_pgr_node n
		SET closed = FALSE, broken = FALSE, to_arc = NULL, graph_delimiter = 'MINSECTOR', modif = FALSE
		FROM plan_netscenario_valve v
		WHERE n.node_id = v.node_id
		AND v.netscenario_id = v_netscenario
		AND v.closed IS FALSE;
	END IF;

	-- save as graph_delimiter the arcs 'INITOVERFLOWPATH', without creating new arcs (modif will not be set to TRUE neither for node_1 nor for the arc)
	IF v_project_type = 'UD' THEN
		UPDATE temp_pgr_arc t
        SET graph_delimiter = 'INITOVERFLOWPATH'
        FROM v_temp_arc v
        WHERE v.arc_id = t.arc_id AND v.initoverflowpath;
    END IF;

	-- NODES MAPZONES
	-- Nodes that are the starting/ending points of mapzones
	IF v_from_zero THEN

		EXECUTE format($$
            UPDATE temp_pgr_node t
            SET graph_delimiter = %L, modif = TRUE
            FROM v_temp_node n
            WHERE %L = ANY(n.graph_delimiter)
            AND t.node_id = n.node_id;
        $$, v_mapzone_name, v_mapzone_name);

		IF v_project_type = 'WS' THEN
			-- water source (SECTOR) graph_delimiter
            UPDATE temp_pgr_node t
            SET graph_delimiter = 'SECTOR', modif = TRUE
            FROM v_temp_node n
            WHERE t.node_id = n.node_id
            AND t.graph_delimiter = 'NONE'
            AND 'SECTOR' = ANY(n.graph_delimiter);
		END IF;

		IF v_project_type = 'WS' THEN
			-- update to_arc for nodes that are graph_delimiter or water source
            -- SET TO_ARC from TANK
            EXECUTE format($$
                UPDATE temp_pgr_node t
                SET to_arc = a.to_arc
                FROM  (
                    SELECT m.node_id, array_agg(a.arc_id) AS to_arc
                    FROM man_tank m
                    JOIN v_temp_arc a ON m.node_id IN (a.node_1, a.node_2)
                    WHERE m.inlet_arc IS NULL OR a.arc_id <> ALL(m.inlet_arc)
                    GROUP BY m.node_id
                ) a
                WHERE t.graph_delimiter IN (%L, 'SECTOR') AND t.node_id = a.node_id;
            $$, v_mapzone_name);

			-- SET TO_ARC from SOURCE
            EXECUTE format($$
                UPDATE temp_pgr_node t
                SET to_arc = a.to_arc
                FROM
                    (SELECT m.node_id, array_agg(a.arc_id) AS to_arc
                    FROM man_source m
                    JOIN v_temp_arc a ON m.node_id IN (a.node_1, a.node_2)
                    WHERE m.inlet_arc IS NULL OR a.arc_id <> ALL(m.inlet_arc)
                    GROUP BY m.node_id
                    )a
                WHERE t.graph_delimiter IN (%L, 'SECTOR') AND t.node_id = a.node_id;
            $$, v_mapzone_name);

			-- SET TO_ARC from WATERWELL
            EXECUTE format($$
                UPDATE temp_pgr_node t
                SET to_arc = a.to_arc
                FROM
                    (SELECT m.node_id, array_agg(a.arc_id) AS to_arc
                    FROM man_waterwell m
                    JOIN v_temp_arc a ON m.node_id IN (a.node_1, a.node_2)
                    WHERE m.inlet_arc IS NULL OR a.arc_id <> ALL(m.inlet_arc)
                    GROUP BY m.node_id
                    )a
                WHERE t.graph_delimiter IN (%L, 'SECTOR') AND t.node_id = a.node_id;
            $$, v_mapzone_name);

            -- SET TO_ARC from WTP
            EXECUTE format($$
                UPDATE temp_pgr_node t
                SET to_arc = a.to_arc
                FROM
                    (SELECT m.node_id, array_agg(a.arc_id) AS to_arc
                    FROM man_wtp m
                    JOIN v_temp_arc a ON m.node_id IN (a.node_1, a.node_2)
                    WHERE m.inlet_arc IS NULL OR a.arc_id <> ALL(m.inlet_arc)
                    GROUP BY m.node_id
                    )a
                WHERE t.graph_delimiter IN (%L, 'SECTOR') AND t.node_id = a.node_id;
            $$, v_mapzone_name);

			-- SET TO_ARC from METER
            EXECUTE format($$
                UPDATE temp_pgr_node t
                SET to_arc = a.to_arc
                FROM
                    (SELECT node_id,
                        CASE WHEN to_arc IS NULL THEN NULL
                        ELSE ARRAY[to_arc]
                        END AS to_arc
                    FROM man_meter m
                    ) a
                WHERE t.graph_delimiter = %L AND t.node_id = a.node_id;
            $$, v_mapzone_name);

            -- SET TO_ARC from PUMP
            EXECUTE format($$
                UPDATE temp_pgr_node t
                SET to_arc = a.to_arc
                FROM
                    (SELECT node_id,
                        CASE WHEN to_arc IS NULL THEN NULL
                        ELSE ARRAY[to_arc]
                        END AS to_arc
                    FROM man_pump m
                    ) a
                WHERE t.graph_delimiter = %L AND t.node_id = a.node_id;
            $$, v_mapzone_name);	

		ELSE
			EXECUTE format($$
				UPDATE temp_pgr_node t
				SET to_arc = a.to_arc
				FROM (
					SELECT pgr_node_1,
						array_agg(arc_id) AS to_arc
					FROM temp_pgr_arc
					GROUP BY pgr_node_1
				) a
				WHERE t.graph_delimiter = %L
				AND t.pgr_node_id = a.pgr_node_1;
			$$, v_mapzone_name);
		END IF;
	ELSE
		-- netscenario query
		IF v_netscenario IS NOT NULL THEN
			v_query_text_aux := ' AND netscenario_id = ' || v_netscenario;
		ELSE 
			v_query_text_aux := '';
		END IF;

		IF v_project_type = 'WS' THEN
			EXECUTE format($$
				WITH graphconfig AS (
					SELECT DISTINCT
						%s AS mapzone_id,
						(use_item->>'nodeParent')::int AS node_id,
						elem_to_arc.value::int AS to_arc
					FROM %I,
						LATERAL json_array_elements(graphconfig->'use') AS use_item,
						LATERAL json_array_elements_text(use_item->'toArc') AS elem_to_arc(value)
					WHERE (use_item->>'nodeParent') <> ''
					AND graphconfig IS NOT NULL
					AND active
					AND json_array_length(use_item->'toArc') > 0
					%s
				)
				UPDATE temp_pgr_node n
				SET modif = TRUE,
					graph_delimiter = %L,
					mapzone_id = s.mapzone_id,
					to_arc = s.to_arc
				FROM (
					SELECT mapzone_id,
						node_id,
						array_agg(to_arc)::int[] AS to_arc
					FROM graphconfig
					GROUP BY mapzone_id, node_id
				) s
				WHERE n.node_id = s.node_id;
			$$, v_mapzone_field, v_table_name, v_query_text_aux, v_mapzone_name);
		ELSE
			EXECUTE format($$
				UPDATE temp_pgr_node n
				SET modif = TRUE,
					graph_delimiter = %L,
					mapzone_id = s.mapzone_id
				FROM (
					SELECT %s AS mapzone_id,
						(use_item->>'nodeParent')::int AS node_id
					FROM %I,
						LATERAL json_array_elements(graphconfig->'use') AS use_item
					WHERE (use_item->>'nodeParent') <> ''
					AND graphconfig IS NOT NULL
					AND active
					%s
				) AS s
				WHERE n.node_id = s.node_id;
			$$, v_mapzone_name, v_mapzone_field, v_table_name, v_query_text_aux);
			
			EXECUTE format($$
				UPDATE temp_pgr_node t
				SET to_arc = a.to_arc
				FROM (
					SELECT pgr_node_1,
						array_agg(arc_id) AS to_arc
					FROM temp_pgr_arc
					GROUP BY pgr_node_1
				) a
				WHERE t.graph_delimiter = %L
				AND t.pgr_node_id = a.pgr_node_1;
			$$, v_mapzone_name);
		END IF;

		-- Nodes forceClosed acording init parameters - for ws; for ud forceClosed are arcs
		IF v_project_type = 'WS' THEN
			v_query_text :=
				'UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = ''FORCECLOSED'' 
				FROM (
					SELECT (json_array_elements_text(graphconfig->''forceClosed''))::int4 AS node_id
					FROM ' || v_table_name || ' 
				';

			-- netscenario query
			IF v_netscenario IS NOT NULL THEN
				v_query_text := v_query_text || 'WHERE netscenario_id = ' || v_netscenario || ' AND graphconfig IS NOT NULL AND active';
			ELSE
				v_query_text := v_query_text || 'WHERE graphconfig IS NOT NULL AND active';
			END IF;

			-- common query
			v_query_text := v_query_text || ') AS s WHERE n.node_id = s.node_id';
			EXECUTE v_query_text;

		ELSE
			v_query_text :=
				'UPDATE temp_pgr_arc a SET graph_delimiter = ''FORCECLOSED'' 
				FROM (
					SELECT (json_array_elements_text(graphconfig->''forceClosed''))::int4 AS arc_id
					FROM ' || v_table_name || ' 
				';

			-- netscenario query
			IF v_netscenario IS NOT NULL THEN
				v_query_text := v_query_text || 'WHERE netscenario_id = ' || v_netscenario || ' AND graphconfig IS NOT NULL AND active';
			ELSE
				v_query_text := v_query_text || 'WHERE graphconfig IS NOT NULL AND active';
			END IF;

			-- common query
			v_query_text := v_query_text || ') AS s WHERE a.arc_id = s.arc_id';
			EXECUTE v_query_text;
		END IF;

		-- Nodes forceOpen acording init parameters - only for ws; for ud forceOpen are arcs
		IF v_project_type = 'WS' THEN
			v_query_text :=
				'UPDATE temp_pgr_node n SET modif = FALSE, graph_delimiter = ''IGNORE'' 
				FROM (
					SELECT (json_array_elements_text(graphconfig->''ignore''))::int4 AS node_id
					FROM ' || v_table_name || ' 
				';

			-- netscenario query
			IF v_netscenario IS NOT NULL THEN
				v_query_text := v_query_text || 'WHERE netscenario_id = ' || v_netscenario || ' AND graphconfig IS NOT NULL AND active';
			ELSE
				v_query_text := v_query_text || 'WHERE graphconfig IS NOT NULL AND active';
			END IF;

			-- common query
			v_query_text := v_query_text || ') AS s WHERE n.node_id = s.node_id';
			EXECUTE v_query_text;
		ELSE
			v_query_text :=
				'UPDATE temp_pgr_arc a SET cost = 1, reverse_cost = 1, graph_delimiter = ''IGNORE'' 
				FROM (
					SELECT (json_array_elements_text(graphconfig->''ignore''))::int4 AS arc_id
					FROM ' || v_table_name || ' 
				';

			-- netscenario query
			IF v_netscenario IS NOT NULL THEN
				v_query_text := v_query_text || 'WHERE netscenario_id = ' || v_netscenario || ' AND graphconfig IS NOT NULL AND active';
			ELSE
				v_query_text := v_query_text || 'WHERE graphconfig IS NOT NULL AND active';
			END IF;

			-- common query
			v_query_text := v_query_text || ') AS s WHERE a.arc_id = s.arc_id';
			EXECUTE v_query_text;
		END IF;

    END IF;

	-- Nodes forceClosed acording init parameters - for ws; for ud forceClosed are arcs
	IF v_project_type = 'WS' THEN
		UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = 'FORCECLOSED'
		WHERE n.node_id IN (SELECT (json_array_elements_text((v_parameters->>'forceClosed')::json))::int4);
	ELSE
		UPDATE temp_pgr_arc a SET graph_delimiter = 'FORCECLOSED'
		WHERE a.arc_id IN (SELECT (json_array_elements_text((v_parameters->>'forceClosed')::json))::int4);
	END IF;

	-- Nodes forceOpen acording init parameters - for ws; for ud forceOpen are arcs
	IF v_project_type = 'WS' THEN
		UPDATE temp_pgr_node n SET modif = FALSE, graph_delimiter = 'IGNORE'
		WHERE n.node_id IN (SELECT (json_array_elements_text((v_parameters->>'forceOpen')::json))::int4);
	ELSE
		UPDATE temp_pgr_arc a SET cost = 1, reverse_cost = 1, graph_delimiter = 'IGNORE'
		WHERE a.arc_id IN (SELECT (json_array_elements_text((v_parameters->>'forceOpen')::json))::int4);
	END IF;


	-- Generate new arcs
	IF v_project_type = 'WS' THEN
		v_reverse_cost_new_arcs := 0;
	ELSE
		v_reverse_cost_new_arcs := -1;
    END IF;

	-- =======================
	v_data := jsonb_build_object(
        'data', jsonb_build_object(
            'mapzone_name', v_mapzone_name,
			'cost', 0,
			'reverse_cost', v_reverse_cost_new_arcs
        )
    )::text;
    SELECT gw_fct_graphanalytics_arrangenetwork(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Note: node_id IS NULL AND arc_id IS NULL for the new nodes/arcs generated

	-- calculate to_arc of nodeParents in from zero mode
    IF v_from_zero AND v_project_type = 'WS' AND v_mapzone_name <> 'SECTOR' THEN

		-- for mapzone graph_delimiter - the inlet arcs behave also like checkvalves
		EXECUTE format('
			UPDATE temp_pgr_arc a
			SET cost = CASE WHEN a.node_1 IS NOT NULL THEN -1 ELSE a.cost END,
				reverse_cost = CASE WHEN a.node_2 IS NOT NULL THEN -1 ELSE a.reverse_cost END
			WHERE a.graph_delimiter = %L
			AND a.old_arc_id <> ALL (a.to_arc);
		', v_mapzone_name);

        EXECUTE format('
            SELECT COUNT(*)::INT FROM temp_pgr_arc
            WHERE to_arc IS NULL AND graph_delimiter = %L
        ', v_mapzone_name)
        INTO v_count;

        IF v_count > 0 THEN
            v_query_text := '
                SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, cost, reverse_cost 
                FROM temp_pgr_arc
            ';

			SELECT array_agg(pgr_node_id)::INT[] 
			INTO v_pgr_root_vids
			FROM temp_pgr_node n
			JOIN v_temp_node v ON v.node_id = n.node_id
			WHERE 'SECTOR' = ANY(v.graph_delimiter);

            SELECT COUNT(*)::INT 
			INTO v_pgr_distance 
			FROM temp_pgr_arc;

            INSERT INTO temp_pgr_drivingdistance(seq, "depth", start_vid, pred, node, edge, "cost", agg_cost)
            (
                SELECT seq, "depth", start_vid, pred, node, edge, "cost", agg_cost
                FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
            );
            -- update to_arc of nodes in from zero mode
            EXECUTE format('
                WITH node_parents AS (
                    SELECT pgr_node_id
                    FROM temp_pgr_node
                    WHERE graph_delimiter = %L
                    AND to_arc IS NULL
					AND node_id IS NOT NULL
                ), 
                nodes_to_update AS (
                    SELECT DISTINCT ON (d.pred) d.pred as pgr_node_id, COALESCE(arc_id, old_arc_id) AS to_arc
                    FROM temp_pgr_drivingdistance d
                    JOIN node_parents n ON d.pred = n.pgr_node_id
                    JOIN temp_pgr_arc a ON d.edge = a.pgr_arc_id
                )
                UPDATE temp_pgr_node t
                SET to_arc = array[n.to_arc]
                FROM nodes_to_update n
                WHERE t.pgr_node_id = n.pgr_node_id;
            ',
            v_mapzone_name,
            v_mapzone_name);

            EXECUTE format('
                UPDATE temp_pgr_node t
                SET to_arc = n.to_arc
                FROM temp_pgr_node n
                WHERE t.old_node_id = n.node_id
                AND t.graph_delimiter = %L
                AND t.to_arc IS NULL
				AND n.to_arc IS NOT NULL;
            ', v_mapzone_name);

            EXECUTE format('
                UPDATE temp_pgr_arc t
                SET to_arc = n.to_arc
                FROM  temp_pgr_node n
                WHERE COALESCE(t.node_1, t.node_2) = n.node_id
                AND t.graph_delimiter = %L
                AND n.graph_delimiter = %L
                AND t.to_arc IS NULL
                AND n.to_arc IS NOT NULL;
            ', v_mapzone_name, v_mapzone_name);
        END IF;
    END IF;

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
	END IF;

	-- disconnect FORCECLOSED
	UPDATE temp_pgr_arc a
	SET cost = -1, reverse_cost = -1
	WHERE a.graph_delimiter  = 'FORCECLOSED';

    EXECUTE 'SELECT COUNT(*)::INT FROM temp_pgr_arc'
    INTO v_pgr_distance;

	EXECUTE 'SELECT array_agg(pgr_node_id)::INT[] 
			FROM temp_pgr_node 
			WHERE graph_delimiter = ''' || v_mapzone_name || ''' 
			AND modif = TRUE'
	INTO v_pgr_root_vids;

	IF v_project_type = 'WS' THEN
		v_source := 'pgr_node_1';
		v_target := 'pgr_node_2';
	ELSE
		v_source := 'pgr_node_2';
		v_target := 'pgr_node_1';
	END IF;

	-- Execute pgr_drivingDistance function
	IF v_project_type = 'UD' AND v_mapzone_name = 'DWFZONE' THEN
		v_query_text := 'SELECT pgr_arc_id AS id, ' || v_source || ' AS source, ' || v_target || ' AS target, cost, reverse_cost 
			FROM temp_pgr_arc
			WHERE graph_delimiter <> ''INITOVERFLOWPATH''';
	ELSE
		v_query_text := 'SELECT pgr_arc_id AS id, ' || v_source || ' AS source, ' || v_target || ' AS target, cost, reverse_cost 
			FROM temp_pgr_arc';
	END IF;

	TRUNCATE temp_pgr_drivingdistance;
    INSERT INTO temp_pgr_drivingdistance(seq, "depth", start_vid, pred, node, edge, "cost", agg_cost)
    (
		SELECT seq, "depth", start_vid, pred, node, edge, "cost", agg_cost
		FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
    );

	v_query_text := '
		SELECT seq AS id, start_vid AS source, node AS target, 1 AS COST
		FROM temp_pgr_drivingdistance t
	';
	INSERT INTO temp_pgr_connectedcomponents (seq,component, node)
	SELECT seq,component, node
	FROM pgr_connectedComponents(v_query_text);

	-- generating zones
	INSERT INTO temp_pgr_mapzone (component, mapzone_id)
	SELECT component, array_agg(DISTINCT n.mapzone_id ORDER BY n.mapzone_id)
	FROM temp_pgr_connectedcomponents c
	JOIN temp_pgr_node n ON n.pgr_node_id = c.node
	WHERE n.graph_delimiter = v_mapzone_name AND modif = TRUE
	GROUP BY c.component
	ORDER BY c.component;

	-- Update mapzone_id
	IF v_from_zero = TRUE THEN
		IF v_project_type = 'WS' AND v_class IN ('DMA', 'PRESSZONE') THEN
			EXECUTE
				'SELECT GREATEST(
					(SELECT max(' || v_mapzone_field || ') FROM '|| v_mapzone_name || '),
					(SELECT max(' || v_mapzone_field || ') FROM plan_netscenario_'|| v_mapzone_name || ')
				)'
			INTO v_mapzone_id;
		ELSE
			EXECUTE 'SELECT max(' || v_mapzone_field || ') FROM '|| v_table_name
			INTO v_mapzone_id;
		END IF;
		UPDATE temp_pgr_mapzone m SET mapzone_id = ARRAY[v_mapzone_id + m.id], name = concat(LOWER(v_mapzone_name), (v_mapzone_id + m.id));
	ELSE
		IF v_netscenario IS NOT NULL THEN
			IF v_mapzone_name = 'DMA' THEN
				EXECUTE 'UPDATE temp_pgr_mapzone m SET name = mz.'||LOWER(v_class)||'_name, pattern_id = mz.pattern_id
				FROM ' || v_table_name || ' mz
				WHERE m.mapzone_id[1] = mz.' || v_mapzone_field || '
				AND CARDINALITY(m.mapzone_id) = 1';
			ELSE
				EXECUTE 'UPDATE temp_pgr_mapzone m SET name = mz.'||LOWER(v_class)||'_name
				FROM ' || v_table_name || ' mz
				WHERE m.mapzone_id[1] = mz.' || v_mapzone_field || '
				AND CARDINALITY(m.mapzone_id) = 1';
			END IF;
		ELSE
			EXECUTE 'UPDATE temp_pgr_mapzone m SET name = mz.name
			FROM ' || v_table_name || ' mz
			WHERE m.mapzone_id[1] = mz.' || v_mapzone_field || '
			AND CARDINALITY(m.mapzone_id) = 1
			';
		END IF;
	END IF;

	IF v_update_map_zone > 0 THEN
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
	WHERE (a.' || v_source || ' = n.pgr_node_id AND a.cost >= 0)
	AND n.mapzone_id <> 0';

	EXECUTE 'UPDATE temp_pgr_arc a SET mapzone_id = n.mapzone_id
	FROM temp_pgr_node n
	WHERE (a.' || v_target || ' = n.pgr_node_id AND reverse_cost >= 0)
	AND n.mapzone_id <> 0 AND a.mapzone_id = 0
	';

	-- Now set to 0 the nodes that connect arcs with different mapzone_id
	-- Note: if a closed valve, for example, is between sector 2 and sector 3, it means it is a boundary, it will have '0' as mapzone_id; if it is between -1 and 2 it will also have 0;
	-- However, if a closed valve is between arcs with the same sector, it retains it; if it is between 1 and 1, it retains 1, meaning it is not a boundary; if it is between -1 and -1, it does not change, it retains Conflict

	IF v_project_type = 'WS' THEN
		-- Set to 0 the boundary valves of mapzones
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
	ELSE
		IF v_mapzone_name = 'DWFZONE' THEN
			UPDATE temp_pgr_mapzone m SET min_node = agg.min_node
			FROM (
				SELECT c.component, MIN(n.node_id) AS min_node
				FROM temp_pgr_connectedcomponents c
				JOIN temp_pgr_node n on n.pgr_node_id = c.node
				GROUP BY c.component
			) AS agg
			WHERE m.component = agg.component;

			TRUNCATE temp_pgr_connectedcomponents;

			v_query_text := '
				WITH 
					nodes AS (
						SELECT n.pgr_node_id, m.min_node 
						FROM temp_pgr_node n
						JOIN temp_pgr_mapzone m ON m.component = n.mapzone_id
					),
					components AS (
						SELECT min_node AS source, min_node AS target
						FROM temp_pgr_mapzone m
						UNION 
						SELECT n1.min_node AS source, n2.min_node AS target
						FROM temp_pgr_arc a
						JOIN nodes n1 on a.pgr_node_1 = n1.pgr_node_id
						JOIN nodes n2 on a.pgr_node_2 = n2.pgr_node_id
						WHERE a.graph_delimiter = ''INITOVERFLOWPATH''
					)
				SELECT ROW_NUMBER () OVER (ORDER BY source, target) AS id,
					source,
					target,
					1 AS cost
				FROM components
			';
			INSERT INTO temp_pgr_connectedcomponents (seq,component, node)
			SELECT seq,component, node
			FROM pgr_connectedComponents(v_query_text);

			UPDATE temp_pgr_mapzone m set drainzone_id = c.component
			FROM temp_pgr_connectedcomponents c
			WHERE m.min_node = c.node;
		END IF;
	END IF;

	IF v_update_map_zone > 0 THEN
		-- message
		INSERT INTO temp_audit_check_data (fid, criticity, error_message)
		VALUES (v_fid, 1, concat('INFO: ',v_class,' values for features and geometry of the mapzone has been modified by this process'));
	END IF;

	-- CONFLICT COUNTS
	SELECT count(*)
	INTO v_arcs_count
	FROM temp_pgr_arc a
	JOIN temp_pgr_mapzone m ON m.component = a.mapzone_id
	WHERE a.arc_id IS NOT NULL AND CARDINALITY(m.mapzone_id) > 1;

	SELECT count(*)
	INTO v_connecs_count
	FROM temp_pgr_arc a
	JOIN temp_pgr_mapzone m ON m.component = a.mapzone_id
	JOIN v_temp_connec vc USING (arc_id)
	WHERE CARDINALITY(m.mapzone_id) > 1;

	SELECT string_agg(unnest_id::text, ',') INTO v_mapzones_ids
	FROM (
		SELECT UNNEST(m.mapzone_id) AS unnest_id
		FROM temp_pgr_mapzone m
		WHERE CARDINALITY(m.mapzone_id) > 1
		ORDER BY unnest_id
	) sub;

	IF v_arcs_count > 0 OR v_connecs_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid,  criticity, error_message)
		VALUES (v_fid, 2, concat('WARNING-395: There is a conflict against ',v_mapzone_name,'''s (',v_mapzones_ids,') with ',v_arcs_count,' arc(s) and ',v_connecs_count,' connec(s) affected.'));
	END IF;

	IF v_project_type='UD' THEN
		v_query_text = ' INSERT INTO temp_audit_check_data (fid, criticity, error_message)
		SELECT '||v_fid||', 0, concat(m.name,'' with '', arcs, '' Arcs, '', nodes, '' Nodes and '', CASE WHEN connecs IS NULL THEN 0 ELSE connecs END, '' Connecs and'',
		CASE WHEN gullies IS NULL THEN 0 ELSE gullies END, '' Gullies'')
		FROM (SELECT mapzone_id, count(*) AS arcs FROM temp_pgr_arc ta WHERE mapzone_id::integer > 0 GROUP BY mapzone_id) a
		LEFT JOIN (SELECT mapzone_id, count(*) AS nodes FROM temp_pgr_node tn WHERE mapzone_id::integer > 0 GROUP BY mapzone_id) b USING (mapzone_id)
		LEFT JOIN (SELECT mapzone_id, count(*) AS connecs FROM temp_pgr_arc ta JOIN v_temp_connec vc USING (arc_id) WHERE mapzone_id::integer > 0 GROUP BY mapzone_id) c USING (mapzone_id)
		LEFT JOIN (SELECT mapzone_id, count(*) AS gullies FROM temp_pgr_arc ta JOIN v_temp_gully vg USING (arc_id) WHERE mapzone_id::integer > 0 GROUP BY mapzone_id) d USING (mapzone_id)
		JOIN temp_pgr_mapzone m ON a.mapzone_id = m.component
		GROUP BY m.name, arcs, nodes, connecs, gullies';
		EXECUTE v_query_text;
	ELSE
		v_query_text = ' INSERT INTO temp_audit_check_data (fid, criticity, error_message)
		SELECT '||v_fid||', 0, concat(m.name,'' with '', arcs, '' Arcs, '', nodes, '' Nodes and '', CASE WHEN connecs IS NULL THEN 0 ELSE connecs END, '' Connecs'')
		FROM (SELECT mapzone_id, count(*) AS arcs FROM temp_pgr_arc ta WHERE mapzone_id::integer > 0 GROUP BY mapzone_id) a
		LEFT JOIN (SELECT mapzone_id, count(*) AS nodes FROM temp_pgr_node tn WHERE mapzone_id::integer > 0 GROUP BY mapzone_id) b USING (mapzone_id)
		LEFT JOIN (SELECT mapzone_id, count(*) AS connecs FROM temp_pgr_arc ta JOIN v_temp_connec vc USING (arc_id) WHERE mapzone_id::integer > 0 GROUP BY mapzone_id) c USING (mapzone_id)
		JOIN temp_pgr_mapzone m ON a.mapzone_id = m.component
		GROUP BY m.name, arcs, nodes, connecs';
		EXECUTE v_query_text;
	END IF;

	-- DISCONECTED COUNTS
	RAISE NOTICE 'Disconnected arcs';
	SELECT COUNT(t.*) INTO v_arcs_count
	FROM temp_pgr_arc t
	WHERE t.arc_id IS NOT NULL AND t.mapzone_id = 0;

	IF v_arcs_count > 0 THEN
		INSERT INTO temp_audit_check_data (fid, criticity, error_message)
		VALUES (v_fid, 2, concat('WARNING-',v_fid,': ', v_arcs_count ,' arc''s have been disconnected'));
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
			VALUES (v_fid, 2, concat('WARNING-',v_fid,': ', v_connecs_count ,' connec''s have been disconnected'));
		ELSE
			INSERT INTO temp_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 1, concat('INFO: 0 connec''s have been disconnected'));
		END IF;
	ELSE
		INSERT INTO temp_audit_check_data (fid, criticity, error_message)
		VALUES (v_fid, 1, concat('INFO: 0 connec''s have been disconnected'));
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
	v_result_info := concat ('{"values":',v_result, '}');

	IF v_audit_result is null THEN
		v_status := 'Accepted';
		v_level := 3;
		v_message := 'Mapzones dynamic analysis done succesfull';
	ELSE
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;
	END IF;

	RAISE NOTICE 'Creating geometry of mapzones';
	-- SECTION: Creating geometry of mapzones

	IF v_update_map_zone = 0 THEN
		-- do nothing

	ELSIF  v_update_map_zone = 1 THEN

		-- concave polygon
		v_query_text := '
			UPDATE temp_pgr_mapzone m SET the_geom = ST_Multi(a.the_geom)
			FROM (
				WITH polygon AS (
					SELECT ST_Collect(va.the_geom) AS g, m.mapzone_id
					FROM temp_pgr_arc a
					JOIN v_temp_arc va USING (arc_id)
					JOIN temp_pgr_mapzone m ON m.component = a.mapzone_id
					GROUP BY m.mapzone_id
				)
				SELECT mapzone_id,
				CASE WHEN ST_GeometryType(ST_ConcaveHull(g, '||v_concave_hull||')) = ''ST_Polygon''::text THEN
					ST_Buffer(ST_ConcaveHull(g, '||v_concave_hull||'), 2)::geometry(Polygon,'||(v_srid)||')
					ELSE ST_Expand(ST_Buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,'||(v_srid)||')
					END AS the_geom
				FROM polygon
				)a
			WHERE a.mapzone_id = m.mapzone_id
			AND CARDINALITY(m.mapzone_id) = 1';
		EXECUTE v_query_text;

	ELSIF  v_update_map_zone = 2 THEN

		-- pipe buffer
		v_query_text := '
			UPDATE temp_pgr_mapzone m SET the_geom = geom
			FROM (
				SELECT m.mapzone_id, ST_Multi(ST_Buffer(ST_Collect(va.the_geom),'||v_geom_param_update||')) AS geom
				FROM temp_pgr_arc a
				JOIN v_temp_arc va USING (arc_id)
				JOIN temp_pgr_mapzone m ON m.component = a.mapzone_id
				GROUP BY m.mapzone_id
			) a
			WHERE a.mapzone_id = m.mapzone_id
			AND CARDINALITY(m.mapzone_id) = 1';
		EXECUTE v_query_text;

	ELSIF  v_update_map_zone = 3 THEN

		-- use plot and pipe buffer
		v_query_text := '
			UPDATE temp_pgr_mapzone m SET the_geom = geom FROM (
				SELECT mapzone_id, ST_Multi(ST_Buffer(ST_Collect(geom),0.01)) AS geom FROM (
					SELECT m.mapzone_id, ST_Buffer(ST_Collect(va.the_geom), '||v_geom_param_update||') AS geom 
					FROM temp_pgr_arc a
					JOIN v_temp_arc va USING (arc_id)
					JOIN temp_pgr_mapzone m ON m.component = a.mapzone_id
					GROUP BY m.mapzone_id
					UNION
					SELECT m.mapzone_id, ST_Collect(ep.the_geom) AS geom 
					FROM temp_pgr_arc ta
					JOIN v_temp_connec vc USING (arc_id)
					JOIN temp_pgr_mapzone m ON m.component = ta.mapzone_id
					LEFT JOIN ext_plot ep ON vc.plot_code = ep.plot_code 
						AND ST_DWithin(vc.the_geom, ep.the_geom, 0.001)
					GROUP BY m.mapzone_id
				) a
				GROUP BY mapzone_id
			) b
			WHERE b.mapzone_id= m.mapzone_id
			AND CARDINALITY(m.mapzone_id) = 1';
		EXECUTE v_query_text;

	ELSIF  v_update_map_zone = 4 THEN

		v_geom_param_update_divide := v_geom_param_update / 2;

		IF v_project_type = 'UD' THEN
			v_query_text_aux := '
				UNION
				SELECT m.mapzone_id, (ST_Buffer(ST_Collect(vlg.the_geom),'||v_geom_param_update_divide||',''endcap=flat join=round'')) AS geom
				FROM temp_pgr_arc ta
				JOIN v_temp_link_gully vlg ON ta.arc_id = vlg.arc_id
				JOIN temp_pgr_mapzone m ON m.component = ta.mapzone_id
				GROUP BY m.mapzone_id
			';
		ELSE
			v_query_text_aux = '';
		END IF;

		-- use link and pipe buffer
		v_query_text := '
			UPDATE temp_pgr_mapzone m SET the_geom = b.geom FROM (
				SELECT c.mapzone_id, ST_Multi(ST_Buffer(ST_Collect(c.geom),0.01)) AS geom FROM (
					SELECT m.mapzone_id, ST_Buffer(ST_Collect(va.the_geom), '||v_geom_param_update||') AS geom
					FROM temp_pgr_arc a
					JOIN v_temp_arc va ON a.arc_id = va.arc_id
					JOIN temp_pgr_mapzone m ON m.component = a.mapzone_id
					GROUP BY m.mapzone_id
					UNION
					SELECT m.mapzone_id, (ST_Buffer(ST_Collect(vlc.the_geom),'||v_geom_param_update_divide||',''endcap=flat join=round'')) AS geom
					FROM temp_pgr_arc ta
					JOIN v_temp_link_connec vlc ON ta.arc_id = vlc.arc_id
					JOIN temp_pgr_mapzone m ON m.component = ta.mapzone_id
					GROUP BY m.mapzone_id
					'||v_query_text_aux||'
				) c
				GROUP BY c.mapzone_id
			) b
			WHERE b.mapzone_id = m.component
			AND CARDINALITY(m.mapzone_id) = 1';

		EXECUTE v_query_text;
	END IF;

	-- SECTION[epic=mapzones]: Creating temporal layers
	IF v_commit_changes IS TRUE THEN
	EXECUTE '
		SELECT jsonb_build_object(
		    ''type'', ''FeatureCollection'',
		    ''features'', COALESCE(jsonb_agg(features.feature), ''[]''::jsonb)
		)
		FROM (
			SELECT jsonb_build_object(
				''type'',       ''Feature'',
				''geometry'',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
				''properties'', to_jsonb(row) - ''the_geom''
			) AS feature
			FROM (
				SELECT ta.arc_id, va.arccat_id, va.state, va.expl_id, 
					mapzone_id::text AS '||v_mapzone_field||', 
					ta.old_mapzone_id::text AS old_'||v_mapzone_field||',
					va.the_geom, ''Disconnected''::text AS descript
				FROM temp_pgr_arc ta
				JOIN v_temp_arc va USING (arc_id)
				WHERE ta.mapzone_id = 0
				UNION
				SELECT ta.arc_id, va.arccat_id, va.state, va.expl_id, 
					array_to_string(m.mapzone_id, '','') AS '||v_mapzone_field||', 
					ta.old_mapzone_id::text AS old_'||v_mapzone_field||',
					va.the_geom, ''Conflict''::text AS descript
				FROM temp_pgr_arc ta
				JOIN v_temp_arc va USING (arc_id)
				JOIN temp_pgr_mapzone m ON m.component = ta.mapzone_id
				WHERE CARDINALITY(m.mapzone_id) > 1
			) row
		) features
	' INTO v_result;

	v_result_line := v_result;

		IF v_project_type = 'UD' THEN
			v_query_text_aux := '
				UNION
				SELECT vg.gully_id, vg.gullycat_id, vg.state, vg.expl_id, 
					mapzone_id::text AS '||v_mapzone_field||', 
					tc.old_mapzone_id::text AS old_'||v_mapzone_field||',
					vg.the_geom, ''Disconnected''::text AS descript
				FROM temp_pgr_arc tc
				JOIN v_temp_gully vg USING (arc_id)
				WHERE tc.mapzone_id = 0
				UNION
				SELECT vg.gully_id, vg.gullycat_id, vg.state, vg.expl_id, 
					array_to_string(m.mapzone_id, '','') AS '||v_mapzone_field||', 
					tc.old_mapzone_id::text AS old_'||v_mapzone_field||',
					vg.the_geom, ''Conflict''::text AS descript
				FROM temp_pgr_arc tc
				JOIN v_temp_gully vg USING (arc_id)
				JOIN temp_pgr_mapzone m ON m.component = tc.mapzone_id
				WHERE CARDINALITY(m.mapzone_id) > 1
			';
		ELSE
			v_query_text_aux := '';
		END IF;

	EXECUTE '
		SELECT jsonb_build_object(
		    ''type'', ''FeatureCollection'',
		    ''features'', COALESCE(jsonb_agg(features.feature), ''[]''::jsonb)
		)
		FROM (
			SELECT jsonb_build_object(
				''type'',       ''Feature'',
				''geometry'',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
				''properties'', to_jsonb(row) - ''the_geom''
			) AS feature
			FROM (
				SELECT vc.connec_id, vc.conneccat_id, vc.state, vc.expl_id, 
					mapzone_id::text AS '||v_mapzone_field||', 
					tc.old_mapzone_id::text AS old_'||v_mapzone_field||',
					vc.the_geom, ''Disconnected''::text AS descript
				FROM temp_pgr_arc tc
				JOIN v_temp_connec vc USING (arc_id)
				WHERE tc.mapzone_id = 0
				UNION
				SELECT vc.connec_id, vc.conneccat_id, vc.state, vc.expl_id, 
					array_to_string(m.mapzone_id, '','') AS '||v_mapzone_field||', 
					tc.old_mapzone_id::text AS old_'||v_mapzone_field||',
					vc.the_geom, ''Conflict''::text AS descript
				FROM temp_pgr_arc tc
				JOIN v_temp_connec vc USING (arc_id)
				JOIN temp_pgr_mapzone m ON m.component = tc.mapzone_id
				WHERE CARDINALITY(m.mapzone_id) > 1
				'||v_query_text_aux||'
			) row
		) features
	' INTO v_result;

	v_result_point := v_result;

		SELECT EXISTS (
			SELECT 1
			FROM temp_pgr_arc ta
			JOIN v_temp_arc va USING (arc_id)
			JOIN temp_pgr_mapzone m ON m.component = ta.mapzone_id
			WHERE CARDINALITY(m.mapzone_id) > 1
		) INTO v_has_conflicts;
	ELSE

	EXECUTE '
		SELECT jsonb_build_object(
		    ''type'', ''FeatureCollection'',
		    ''features'', COALESCE(jsonb_agg(features.feature), ''[]''::jsonb)
		)
		FROM (
			SELECT jsonb_build_object(
				''type'',       ''Feature'',
				''geometry'',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
				''properties'', to_jsonb(row) - ''the_geom''
			) AS feature
			FROM (
				SELECT ta.arc_id, va.arccat_id, va.state, va.expl_id, 
					ta.mapzone_id::text AS '||v_mapzone_field||', 
					ta.old_mapzone_id::text AS old_'||v_mapzone_field||',
					va.the_geom, ''Disconnected''::text AS descript
				FROM temp_pgr_arc ta
				JOIN v_temp_arc va USING (arc_id)
				WHERE ta.mapzone_id = 0
				UNION ALL
				SELECT ta.arc_id, va.arccat_id, va.state, va.expl_id, 
					array_to_string(m.mapzone_id, '','') AS '||v_mapzone_field||', 
					ta.old_mapzone_id::text AS old_'||v_mapzone_field||',
					va.the_geom,
					''Conflict ('' || array_to_string(m.mapzone_id, '','') || '')''::text AS descript
				FROM temp_pgr_arc ta
				JOIN v_temp_arc va USING (arc_id)
				JOIN temp_pgr_mapzone m ON m.component = ta.mapzone_id
				WHERE CARDINALITY(m.mapzone_id) > 1
				UNION ALL
				SELECT ta.arc_id, va.arccat_id, va.state, va.expl_id, 
					m.mapzone_id[1]::text AS '||v_mapzone_field||', 
					ta.old_mapzone_id::text AS old_'||v_mapzone_field||',
					va.the_geom,
					COALESCE(m.name, '''') AS descript
				FROM temp_pgr_arc ta
				JOIN v_temp_arc va USING (arc_id)
				JOIN temp_pgr_mapzone m ON m.component = ta.mapzone_id
				WHERE CARDINALITY(m.mapzone_id) = 1
			) AS row
		) AS features
	' INTO v_result;

	v_result_line := v_result;


		IF v_project_type = 'UD' THEN
			v_query_text_aux := '
				UNION
				SELECT vg.gully_id AS feature_id, vg.gullycat_id AS cat_id, ''GULLY'' AS feature_type, vg.state, vg.expl_id, 
					tc.mapzone_id::text AS '||v_mapzone_field||', 
					tc.old_mapzone_id::text AS old_'||v_mapzone_field||',
					vg.the_geom, ''Disconnected''::text AS descript
				FROM temp_pgr_arc tc
				JOIN v_temp_gully vg USING (arc_id)
				WHERE tc.mapzone_id = 0
				UNION
				SELECT vg.gully_id AS feature_id, vg.gullycat_id AS cat_id, ''GULLY'' AS feature_type, vg.state, vg.expl_id, 
					array_to_string(m.mapzone_id, '','') AS '||v_mapzone_field||', 
					tc.old_mapzone_id::text AS old_'||v_mapzone_field||',
					vg.the_geom, ''Conflict ('' || array_to_string(m.mapzone_id, '','') || '')''::text AS descript
				FROM temp_pgr_arc tc
				JOIN v_temp_gully vg USING (arc_id)
				JOIN temp_pgr_mapzone m ON m.component = tc.mapzone_id
				WHERE CARDINALITY(m.mapzone_id) > 1
				UNION
				SELECT vg.gully_id AS feature_id, vg.gullycat_id AS cat_id, ''GULLY'' AS feature_type, vg.state, vg.expl_id, 
					m.mapzone_id[1]::text AS '||v_mapzone_field||', 
					tc.old_mapzone_id::text AS old_'||v_mapzone_field||',
					vg.the_geom, COALESCE(m.name, '''') AS descript
				FROM temp_pgr_arc tc
				JOIN v_temp_gully vg USING (arc_id)
				JOIN temp_pgr_mapzone m ON m.component = tc.mapzone_id
				WHERE CARDINALITY(m.mapzone_id) = 1
			';
		ELSE
			v_query_text_aux := '';
		END IF;

	EXECUTE '
		SELECT jsonb_build_object(
		    ''type'', ''FeatureCollection'',
		    ''features'', COALESCE(jsonb_agg(features.feature), ''[]''::jsonb)
		)
		FROM (
			SELECT jsonb_build_object(
				''type'',       ''Feature'',
				''geometry'',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
				''properties'', to_jsonb(row) - ''the_geom''
			) AS feature
			FROM (
				SELECT vc.connec_id AS feature_id, vc.conneccat_id AS cat_id, ''CONNEC'' AS feature_type, vc.state, vc.expl_id, 
					tc.mapzone_id::text AS '||v_mapzone_field||', 
					tc.old_mapzone_id::text AS old_'||v_mapzone_field||',
					vc.the_geom, ''Disconnected''::text AS descript
				FROM temp_pgr_arc tc
				JOIN v_temp_connec vc USING (arc_id)
				WHERE tc.mapzone_id = 0
				UNION ALL
				SELECT vc.connec_id AS feature_id, vc.conneccat_id AS cat_id, ''CONNEC'' AS feature_type, vc.state, vc.expl_id, 
					array_to_string(m.mapzone_id, '','') AS '||v_mapzone_field||', 
					tc.old_mapzone_id::text AS old_'||v_mapzone_field||',
					vc.the_geom, ''Conflict ('' || array_to_string(m.mapzone_id, '','') || '')''::text AS descript
				FROM temp_pgr_arc tc
				JOIN v_temp_connec vc USING (arc_id)
				JOIN temp_pgr_mapzone m ON m.component = tc.mapzone_id
				WHERE CARDINALITY(m.mapzone_id) > 1
				UNION ALL
				SELECT vc.connec_id AS feature_id, vc.conneccat_id AS cat_id, ''CONNEC'' AS feature_type, vc.state, vc.expl_id, 
					m.mapzone_id[1]::text AS '||v_mapzone_field||', 
					tc.old_mapzone_id::text AS old_'||v_mapzone_field||',
					vc.the_geom, COALESCE(m.name, '''') AS descript
				FROM temp_pgr_arc tc
				JOIN v_temp_connec vc USING (arc_id)
				JOIN temp_pgr_mapzone m ON m.component = tc.mapzone_id
				WHERE CARDINALITY(m.mapzone_id) = 1
				'||v_query_text_aux||'
			) row
		) features
	' INTO v_result;

		v_result_point := COALESCE(v_result, '{}');

		v_visible_layer := NULL;
	END IF;
	-- ENDSECTION

	IF v_commit_changes IS TRUE THEN
		IF v_netscenario IS NOT NULL THEN
			v_query_text := '
				WITH 
					mapzone AS (
						SELECT
							mapzone_id, 
							CASE WHEN CARDINALITY(mapzone_id) = 1 THEN the_geom
							ELSE NULL
							END AS the_geom
						FROM temp_pgr_mapzone
						GROUP BY mapzone_id, the_geom
					)
				UPDATE '||v_table_name||' m SET the_geom = tm.the_geom
				FROM mapzone tm
				WHERE m.'||v_mapzone_field || ' = ANY (tm.mapzone_id)';
			EXECUTE v_query_text;

			DELETE FROM plan_netscenario_arc WHERE netscenario_id = v_netscenario::integer;
			DELETE FROM plan_netscenario_node WHERE netscenario_id = v_netscenario::integer;
			DELETE FROM plan_netscenario_connec WHERE netscenario_id = v_netscenario::integer;

			v_query_text := '
				WITH mapzones AS (
					SELECT
						component,
						CASE WHEN CARDINALITY(mapzone_id) = 1 THEN mapzone_id[1]
						ELSE -1
						END AS mapzone_id
					FROM temp_pgr_mapzone
					UNION ALL
    				SELECT 0 AS component, 0 AS mapzone_id
				)
				INSERT INTO plan_netscenario_arc(netscenario_id, arc_id, '||quote_ident(v_mapzone_field)||', the_geom)
				SELECT '|| v_netscenario||', va.arc_id, m.mapzone_id, va.the_geom
				FROM temp_pgr_arc t
				JOIN v_temp_arc va USING (arc_id)
				JOIN mapzones m ON m.component = t.mapzone_id
			';
			EXECUTE v_query_text;

			v_query_text := '
				WITH mapzones AS (
					SELECT
						component,
						CASE WHEN CARDINALITY(mapzone_id) = 1 THEN mapzone_id[1]
						ELSE -1
						END AS mapzone_id
					FROM temp_pgr_mapzone
					UNION ALL
    				SELECT 0 AS component, 0 AS mapzone_id
				)
				INSERT INTO plan_netscenario_node(netscenario_id, node_id, '||quote_ident(v_mapzone_field)||', the_geom)
				SELECT '|| v_netscenario||', vn.node_id, m.mapzone_id, vn.the_geom
				FROM temp_pgr_node tn
				JOIN v_temp_node vn USING (node_id)
				JOIN mapzones m ON m.component = tn.mapzone_id
			';
			EXECUTE v_query_text;

			v_query_text := '
				WITH mapzones AS (
					SELECT
						component,
						CASE WHEN CARDINALITY(mapzone_id) = 1 THEN mapzone_id[1]
						ELSE -1
						END AS mapzone_id
					FROM temp_pgr_mapzone
					UNION ALL
    				SELECT 0 AS component, 0 AS mapzone_id
				)
				INSERT INTO plan_netscenario_connec(netscenario_id, connec_id, '||quote_ident(v_mapzone_field)||', the_geom)
				SELECT '|| v_netscenario||', vc.connec_id, m.mapzone_id, vc.the_geom
				FROM temp_pgr_arc t
				JOIN v_temp_connec vc USING (arc_id)
				JOIN mapzones m ON m.component = t.mapzone_id
			';
			EXECUTE v_query_text;


			IF v_class = 'PRESSZONE' THEN

				-- nodes
				v_query_text = '
					UPDATE plan_netscenario_node n SET staticpressure = t.staticpressure
					FROM (
						SELECT pn.node_id,
						CASE
							WHEN pn.'||v_mapzone_field||' > 0 THEN
								(p.head - COALESCE (n.custom_top_elev, n.top_elev) + COALESCE (n.depth, 0))::numeric(12,3)
							ELSE NULL
						END AS staticpressure
						FROM plan_netscenario_node pn 
						JOIN node n ON pn.node_id = n.node_id
						JOIN '||v_table_name||' p ON pn.'||v_mapzone_field||' = p.'||v_mapzone_field||'
						WHERE EXISTS (SELECT 1 FROM temp_pgr_node t WHERE t.node_id= n.node_id)
					) t
					WHERE n.node_id = t.node_id
					AND (n.staticpressure IS DISTINCT FROM t.staticpressure)
				';
				EXECUTE v_query_text;

				-- connec
				v_query_text := '
					UPDATE plan_netscenario_connec c SET staticpressure = t.staticpressure
					FROM (
						SELECT pc.connec_id,
							CASE
								WHEN pc.' || v_mapzone_field || ' > 0 THEN
									(p.head - c.top_elev + COALESCE(c.depth, 0))::numeric(12,3)
								ELSE NULL
							END AS staticpressure
						FROM plan_netscenario_connec pc
						JOIN connec c ON pc.connec_id = c.connec_id
						JOIN ' || v_table_name || ' p ON pc.' || v_mapzone_field || ' = p.' || v_mapzone_field || '
						WHERE EXISTS (
							SELECT 1 FROM temp_pgr_arc t WHERE t.arc_id = c.arc_id
						)
					) t
					WHERE c.connec_id = t.connec_id
					AND (c.staticpressure IS DISTINCT FROM t.staticpressure);
				';
				EXECUTE v_query_text;

			ELSIF v_class = 'DMA' THEN

				UPDATE plan_netscenario_node SET pattern_id = t.pattern_id
				FROM temp_pgr_mapzone t
				WHERE (
					CARDINALITY(t.mapzone_id) = 1 AND plan_netscenario_node.dma_id = t.mapzone_id[1]
				) OR (
					CARDINALITY(t.mapzone_id) > 1 AND plan_netscenario_node.dma_id = ANY (t.mapzone_id)
				);

				UPDATE plan_netscenario_connec SET pattern_id = t.pattern_id
				FROM temp_pgr_mapzone t
				WHERE (
					CARDINALITY(t.mapzone_id) = 1 AND plan_netscenario_connec.dma_id = t.mapzone_id[1]
				) OR (
					CARDINALITY(t.mapzone_id) > 1 AND plan_netscenario_connec.dma_id = ANY (t.mapzone_id)
				);

			END IF;
		ELSE
			IF v_from_zero = TRUE THEN
				IF v_project_type = 'WS' AND v_mapzone_name <> 'SECTOR' THEN
					v_query_text := 'INSERT INTO '||v_table_name||' ('||v_mapzone_field||',code, name, expl_id, the_geom, created_at, created_by, graphconfig)
					SELECT m.mapzone_id[1], m.mapzone_id[1], m.name, ARRAY[0], m.the_geom, now(), current_user,
					json_build_object(
						''use'', json_agg(
							json_build_object(
								''nodeParent'', node_id::text,
								''toArc'', to_arc
							)
						)
					) as graphconfig
					FROM temp_pgr_mapzone m
					JOIN temp_pgr_node n ON n.mapzone_id = m.component
					WHERE n.graph_delimiter = ''' || v_mapzone_name || ''' AND n.modif = TRUE
					GROUP BY m.mapzone_id[1], m.name, m.the_geom';

					-- update to_arc in man_ tables due to the new to_arc getted from the arrange network
					UPDATE man_pump m SET to_arc = tn.to_arc[1]
					FROM temp_pgr_node tn
					WHERE tn.node_id = m.node_id
					AND tn.graph_delimiter = v_mapzone_name
					AND tn.to_arc IS NOT NULL
					AND m.to_arc IS NULL;

					UPDATE man_meter m SET to_arc = tn.to_arc[1]
					FROM temp_pgr_node tn
					WHERE tn.node_id = m.node_id
					AND tn.graph_delimiter = v_mapzone_name
					AND tn.to_arc IS NOT NULL
					AND m.to_arc IS NULL;

					UPDATE man_valve m SET to_arc = tn.to_arc[1]
					FROM temp_pgr_node tn
					WHERE tn.node_id = m.node_id
					AND tn.graph_delimiter = v_mapzone_name
					AND tn.to_arc IS NOT NULL
					AND m.to_arc IS NULL;

				ELSE
					v_query_text := 'INSERT INTO '||v_table_name||' ('||v_mapzone_field||',code, name, expl_id, the_geom, created_at, created_by, graphconfig)
					SELECT m.mapzone_id[1], m.mapzone_id[1], m.name, ARRAY[0], m.the_geom, now(), current_user,
					json_build_object(
						''use'', json_agg(
							json_build_object(
								''nodeParent'', node_id::text
							)
						)
					) as graphconfig
					FROM temp_pgr_mapzone m
					JOIN temp_pgr_node n ON n.mapzone_id = m.component
					WHERE n.graph_delimiter = ''' || v_mapzone_name || ''' AND n.modif = TRUE
					GROUP BY m.mapzone_id[1], m.name, m.the_geom';
				END IF;
				EXECUTE v_query_text;

				-- ignore
				v_query_text := '
					UPDATE '||v_table_name||' m
					SET graphconfig = jsonb_set(
						graphconfig::jsonb,
						''{ignore}'',
						to_jsonb(a.node_id),
						true
					)
					FROM (
						SELECT n.node_id, m.mapzone_id[1] AS mapzone_id
						FROM temp_pgr_node n
						JOIN temp_pgr_mapzone m ON m.component = n.mapzone_id
						WHERE n.graph_delimiter = ''INGORE''
					) a
					WHERE m.'||v_mapzone_field||' = a.mapzone_id';
				EXECUTE v_query_text;

				-- forceclosed
				v_query_text := '
					UPDATE '||v_table_name||' m
					SET graphconfig = jsonb_set(
						graphconfig::jsonb,
						''{forceClosed}'',
						to_jsonb(a.node_id),
						true
					)
				FROM (
					SELECT DISTINCT ON (n.old_node_id) n.old_node_id AS node_id, m.mapzone_id[1] AS mapzone_id
					FROM temp_pgr_node n
					JOIN temp_pgr_mapzone m ON m.component = n.mapzone_id
					WHERE n.graph_delimiter = ''FORCECLOSED''
					AND n.old_mapzone_id IS NOT NULL
				) a
				WHERE m.'||v_mapzone_field||' = a.mapzone_id';
				EXECUTE v_query_text;

			ELSE
				v_query_text := '
					WITH 
						mapzone AS (
							SELECT
								mapzone_id, 
								CASE WHEN CARDINALITY(mapzone_id) = 1 THEN the_geom
								ELSE NULL
								END AS the_geom
							FROM temp_pgr_mapzone
							GROUP BY mapzone_id, the_geom
						)
					UPDATE '||v_table_name||' m SET the_geom = tm.the_geom
					FROM mapzone tm
					WHERE m.'||v_mapzone_field || ' = ANY (tm.mapzone_id)';
				EXECUTE v_query_text;
			END IF;

			IF v_mapzone_name <> 'SECTOR' THEN
				v_query_text_aux := '
					sector_id = CASE
						WHEN CARDINALITY(subq.mapzone_id) = 1 THEN subq.sector_ids
						ELSE ARRAY[0]
					END,
				';
			ELSE
				v_query_text_aux := '';
			END IF;

			v_query_text := '
			UPDATE '||v_table_name||' m
				SET expl_id = CASE
    				WHEN CARDINALITY(subq.mapzone_id) = 1 THEN subq.expl_ids
    				ELSE ARRAY[0] 
				END,
				muni_id = CASE
    				WHEN CARDINALITY(subq.mapzone_id) = 1 THEN subq.muni_ids
					ELSE ARRAY[0]
				END,
				'||v_query_text_aux||'
				updated_at = now(),
				updated_by = current_user
			FROM (
				SELECT
					tm.mapzone_id,
					array_agg(DISTINCT vn.expl_id) FILTER (WHERE vn.expl_id IS NOT NULL)::int[] AS expl_ids,
					array_agg(DISTINCT vn.muni_id) FILTER (WHERE vn.muni_id IS NOT NULL)::int[] AS muni_ids,
					array_agg(DISTINCT vn.sector_id) FILTER (WHERE vn.sector_id IS NOT NULL)::int[] AS sector_ids
				FROM temp_pgr_node tn
				JOIN v_temp_node vn USING (node_id)
				JOIN temp_pgr_mapzone tm ON tn.mapzone_id = tm.component
				GROUP BY tm.mapzone_id
			) subq
			WHERE (
				CARDINALITY (subq.mapzone_id) = 1 AND subq.mapzone_id[1] = m.'||v_mapzone_field||'
			) OR (
				CARDINALITY (subq.mapzone_id) > 1 AND m.'||v_mapzone_field || ' = ANY (subq.mapzone_id)
			)';
			EXECUTE v_query_text;

			-- Update mapzone addparam with kmLength calculation
			v_query_text := '
				UPDATE '||v_table_name||' m SET addparam = 
					(COALESCE(addparam::jsonb, ''{}''::jsonb) || jsonb_build_object(''kmLength'', COALESCE(a.km, 0)))::json
				FROM (
					SELECT mz.mapzone_id[1] AS '||v_mapzone_field||', 
						sum(st_length(va.the_geom)/1000)::numeric(12,3) AS km 
					FROM temp_pgr_arc ta
					JOIN ve_arc va ON ta.arc_id = va.arc_id
					JOIN temp_pgr_mapzone mz ON ta.mapzone_id = mz.component
					WHERE ta.mapzone_id > 0
					AND CARDINALITY(mz.mapzone_id) = 1
					GROUP BY mz.mapzone_id[1]
				) a 
				WHERE a.'||v_mapzone_field||' = m.'||v_mapzone_field||'
			';
			EXECUTE v_query_text;

			-- Insert into selector_sector all sectors that match muni_id and expl_id from selectors
			IF v_class = 'SECTOR' THEN

				DELETE FROM selector_sector ss
				WHERE NOT EXISTS (
				    SELECT 1 
				    FROM sector s
				    JOIN selector_municipality sm ON sm.muni_id = ANY(s.muni_id)
				    WHERE s.active
				        AND EXISTS (
				            SELECT 1
				            FROM selector_expl se 
				            WHERE se.expl_id = ANY(s.expl_id) AND se.cur_user = sm.cur_user
				        )
				      AND ss.sector_id = s.sector_id
				      AND ss.cur_user = sm.cur_user
				);
				
				INSERT INTO selector_sector (sector_id, cur_user)
				SELECT DISTINCT s.sector_id, sm.cur_user
				FROM sector s
				JOIN selector_municipality sm ON sm.muni_id = ANY(s.muni_id)
				WHERE s.active
					AND EXISTS (
						SELECT 1 
						FROM selector_expl se 
						WHERE se.expl_id = ANY(s.expl_id) AND se.cur_user = sm.cur_user
					)
					AND NOT EXISTS (
						SELECT 1
						FROM selector_sector ss
						WHERE ss.sector_id = s.sector_id AND ss.cur_user = ss.cur_user
					);
			END IF;

			-- for DISCONNECTED, mapzone_id is 0, for  CONFLICT mapzone_id is -1
			v_query_text := '
				WITH mapzones AS (
					SELECT
						component,
						CASE WHEN CARDINALITY(mapzone_id) = 1 THEN mapzone_id[1]
						ELSE -1
						END AS mapzone_id
					FROM temp_pgr_mapzone
					UNION ALL
    				SELECT 0 AS component, 0 AS mapzone_id
				)
				UPDATE arc a SET '||quote_ident(v_mapzone_field)||' = m.mapzone_id
				FROM temp_pgr_arc ta
				JOIN mapzones m ON m.component = ta.mapzone_id
				WHERE a.arc_id = ta.arc_id
				AND a.'||quote_ident(v_mapzone_field)||' IS DISTINCT FROM m.mapzone_id
			';
			EXECUTE v_query_text;

			v_query_text := '
				WITH mapzones AS (
					SELECT
						component,
						CASE WHEN CARDINALITY(mapzone_id) = 1 THEN mapzone_id[1]
						ELSE -1
						END AS mapzone_id
					FROM temp_pgr_mapzone
					UNION ALL
    				SELECT 0 AS component, 0 AS mapzone_id
				)
				UPDATE node n SET '||quote_ident(v_mapzone_field)||' = m.mapzone_id
				FROM temp_pgr_node tn
				JOIN mapzones m ON m.component = tn.mapzone_id
				WHERE n.node_id = tn.node_id
				AND n.'||quote_ident(v_mapzone_field)||' IS DISTINCT FROM m.mapzone_id
			';
			EXECUTE v_query_text;

			v_query_text := '
				WITH mapzones AS (
					SELECT
						component,
						CASE WHEN CARDINALITY(mapzone_id) = 1 THEN mapzone_id[1]
						ELSE -1
						END AS mapzone_id
					FROM temp_pgr_mapzone
					UNION ALL
    				SELECT 0 AS component, 0 AS mapzone_id
				)
				UPDATE connec c SET '||quote_ident(v_mapzone_field)||' = m.mapzone_id
				FROM temp_pgr_arc ta
				JOIN mapzones m ON m.component = ta.mapzone_id
				WHERE c.arc_id = ta.arc_id
				AND EXISTS (SELECT 1 FROM v_temp_connec t WHERE t.connec_id = c.connec_id)
				AND c.'||quote_ident(v_mapzone_field)||' IS DISTINCT FROM m.mapzone_id
			';
			EXECUTE v_query_text;

			v_query_text := '
				WITH mapzones AS (
					SELECT
						component,
						CASE WHEN CARDINALITY(mapzone_id) = 1 THEN mapzone_id[1]
						ELSE -1
						END AS mapzone_id
					FROM temp_pgr_mapzone
					UNION ALL
    				SELECT 0 AS component, 0 AS mapzone_id
				)
				UPDATE link l SET '||quote_ident(v_mapzone_field)||' = m.mapzone_id
				FROM temp_pgr_arc ta
				JOIN mapzones m ON m.component = ta.mapzone_id
				JOIN v_temp_link_connec c ON ta.arc_id = c.arc_id
				WHERE l.link_id = c.link_id
				AND l.'||quote_ident(v_mapzone_field)||' IS DISTINCT FROM m.mapzone_id
			';
			EXECUTE v_query_text;

			IF v_project_type = 'UD' THEN
				v_query_text := '
					WITH mapzones AS (
						SELECT
							component,
							CASE WHEN CARDINALITY(mapzone_id) = 1 THEN mapzone_id[1]
							ELSE -1
							END AS mapzone_id
						FROM temp_pgr_mapzone
						UNION ALL
    					SELECT 0 AS component, 0 AS mapzone_id
					)
					UPDATE gully g SET '||quote_ident(v_mapzone_field)||' = m.mapzone_id
					FROM temp_pgr_arc ta
					JOIN mapzones m ON m.component = ta.mapzone_id
					WHERE g.arc_id = ta.arc_id
					AND EXISTS (SELECT 1 FROM v_temp_gully t WHERE t.gully_id = g.gully_id)
					AND g.'||quote_ident(v_mapzone_field)||' IS DISTINCT FROM m.mapzone_id
				';
				EXECUTE v_query_text;

				v_query_text := '
					WITH mapzones AS (
						SELECT
							component,
							CASE WHEN CARDINALITY(mapzone_id) = 1 THEN mapzone_id[1]
							ELSE -1
							END AS mapzone_id
						FROM temp_pgr_mapzone
						UNION ALL
    					SELECT 0 AS component, 0 AS mapzone_id
					)
					UPDATE link l SET '||quote_ident(v_mapzone_field)||' = m.mapzone_id
					FROM temp_pgr_arc ta
					JOIN mapzones m ON m.component = ta.mapzone_id
					JOIN v_temp_link_gully g ON ta.arc_id = g.arc_id
					WHERE l.link_id = g.link_id
					AND l.'||quote_ident(v_mapzone_field)||' IS DISTINCT FROM m.mapzone_id
				';
				EXECUTE v_query_text;
			END IF;

			IF EXISTS (SELECT 1 FROM v_temp_pgr_mapzone_old LIMIT 1) THEN
				IF v_mapzone_name = 'PRESSZONE' THEN
					v_query_text_aux := ', staticpressure1 = NULL, staticpressure2 = NULL';
				ELSIF v_mapzone_name = 'DWFZONE' THEN
					v_query_text_aux := ', drainzone_outfall = NULL, dwfzone_outfall = NULL';
				ELSE
					v_query_text_aux := '';
				END IF;

				v_query_text := '
				UPDATE arc a SET '||quote_ident(v_mapzone_field)||' = 0
				'||v_query_text_aux||'
				WHERE EXISTS (
					SELECT 1 FROM v_temp_pgr_mapzone_old tm
					WHERE a.'||quote_ident(v_mapzone_field)||' = tm.old_mapzone_id
				)
				AND NOT EXISTS (
					SELECT 1 FROM temp_pgr_arc ta WHERE ta.arc_id = a.arc_id
				)
				AND a.'||quote_ident(v_mapzone_field)||' IS DISTINCT FROM 0
				';
				EXECUTE v_query_text;

				v_query_text := '
				UPDATE link l SET '||quote_ident(v_mapzone_field)||' = 0
				'||v_query_text_aux||'
				WHERE EXISTS (
					SELECT 1 FROM v_temp_pgr_mapzone_old tm
					WHERE l.'||quote_ident(v_mapzone_field)||' = tm.old_mapzone_id
				)
				AND NOT EXISTS (
					SELECT 1 FROM temp_pgr_arc ta
					JOIN v_temp_link_connec vc USING (arc_id) WHERE vc.link_id = l.link_id
					)
				AND l.'||quote_ident(v_mapzone_field)||' IS DISTINCT FROM 0
				';
				EXECUTE v_query_text;

				IF v_mapzone_name = 'PRESSZONE' THEN
					v_query_text_aux := ', staticpressure = NULL';
				ELSIF v_mapzone_name = 'DWFZONE' THEN
					v_query_text_aux := ', drainzone_outfall = NULL, dwfzone_outfall = NULL';
				ELSE
					v_query_text_aux := '';
				END IF;

				v_query_text := '
				UPDATE node n SET '||quote_ident(v_mapzone_field)||' = 0
				'||v_query_text_aux||'
				WHERE EXISTS (
					SELECT 1 FROM v_temp_pgr_mapzone_old tm
					WHERE n.'||quote_ident(v_mapzone_field)||' = tm.old_mapzone_id
				)
				AND NOT EXISTS (
					SELECT 1 FROM temp_pgr_node tn WHERE tn.node_id = n.node_id
				)
				AND n.'||quote_ident(v_mapzone_field)||' IS DISTINCT FROM 0
				';
				EXECUTE v_query_text;

				v_query_text := '
				UPDATE connec c SET '||quote_ident(v_mapzone_field)||' = 0
				'||v_query_text_aux||'
				WHERE EXISTS (
					SELECT 1 FROM v_temp_pgr_mapzone_old tm
					WHERE c.'||quote_ident(v_mapzone_field)||' = tm.old_mapzone_id
				)
				AND NOT EXISTS (
					SELECT 1 FROM temp_pgr_arc ta JOIN v_temp_connec vc USING (arc_id) WHERE vc.connec_id = c.connec_id
				)
				AND c.'||quote_ident(v_mapzone_field)||' IS DISTINCT FROM 0
				';
				EXECUTE v_query_text;

				IF v_project_type = 'UD' THEN
					v_query_text := '
					UPDATE gully g SET '||quote_ident(v_mapzone_field)||' = 0
					'||v_query_text_aux||'
					WHERE EXISTS (
						SELECT 1 FROM v_temp_pgr_mapzone_old tm
						WHERE g.'||quote_ident(v_mapzone_field)||' = tm.old_mapzone_id
					)
					AND NOT EXISTS (
						SELECT 1 FROM temp_pgr_arc ta JOIN v_temp_gully vg USING (arc_id) WHERE vg.gully_id = g.gully_id
					)
					AND g.'||quote_ident(v_mapzone_field)||' IS DISTINCT FROM 0
					';
					EXECUTE v_query_text;

					v_query_text := '
					UPDATE link l SET '||quote_ident(v_mapzone_field)||' = 0
					'||v_query_text_aux||'
					WHERE EXISTS (
						SELECT 1 FROM v_temp_pgr_mapzone_old tm
						WHERE l.'||quote_ident(v_mapzone_field)||' = tm.old_mapzone_id
					)
					AND NOT EXISTS (
						SELECT 1 FROM temp_pgr_arc ta
						JOIN v_temp_link_gully vg USING (arc_id)
						WHERE vg.link_id = l.link_id
					)
					AND l.'||quote_ident(v_mapzone_field)||' IS DISTINCT FROM 0
				';
				EXECUTE v_query_text;
				END IF;
			END IF;

			-- static pressure
			IF v_mapzone_name = 'PRESSZONE' THEN
				-- nodes
				v_query_text = '
					UPDATE node n SET staticpressure = t.staticpressure
					FROM (
						SELECT n.node_id,
						CASE
							WHEN n.'||v_mapzone_field||' > 0 THEN
								(p.head - COALESCE (n.custom_top_elev, n.top_elev) + COALESCE (n.depth, 0))::numeric(12,3)
							ELSE NULL
						END AS staticpressure
						FROM node n
						JOIN '||v_table_name||' p USING ('||v_mapzone_field||')
						WHERE EXISTS (SELECT 1 FROM temp_pgr_node t WHERE t.node_id= n.node_id)
					) t
					WHERE n.node_id = t.node_id
					AND (n.staticpressure IS DISTINCT FROM t.staticpressure)
				';
				EXECUTE v_query_text;

				-- arcs
				v_query_text := '
					UPDATE arc a SET
						staticpressure1 = t.staticpressure1,
						staticpressure2 = t.staticpressure2
					FROM (
						SELECT a.arc_id,
							CASE
								WHEN a.' || v_mapzone_field || ' > 0 THEN
									(p.head - a.elevation1 + COALESCE(a.depth1, 0))::numeric(12,3)
								ELSE NULL
							END AS staticpressure1,
							CASE
								WHEN a.' || v_mapzone_field || ' > 0 THEN
									(p.head - a.elevation2 + COALESCE(a.depth2, 0))::numeric(12,3)
								ELSE NULL
							END AS staticpressure2
						FROM arc a
						JOIN ' || v_table_name || ' p USING (' || v_mapzone_field || ')
						WHERE EXISTS (
							SELECT 1 FROM temp_pgr_arc t WHERE t.arc_id = a.arc_id
						)
					) t
					WHERE a.arc_id = t.arc_id
					AND (
						a.staticpressure1 IS DISTINCT FROM t.staticpressure1 OR
						a.staticpressure2 IS DISTINCT FROM t.staticpressure2
					);
				';
				EXECUTE v_query_text;

				-- connec
				v_query_text := '
					UPDATE connec c SET staticpressure = t.staticpressure
					FROM (
						SELECT c.connec_id,
							CASE
								WHEN c.' || v_mapzone_field || ' > 0 THEN
									(p.head - c.top_elev + COALESCE(c.depth, 0))::numeric(12,3)
								ELSE NULL
							END AS staticpressure
						FROM connec c
						JOIN ' || v_table_name || ' p USING (' || v_mapzone_field || ')
						WHERE EXISTS (
							SELECT 1 FROM temp_pgr_arc t WHERE t.arc_id = c.arc_id
						)
						AND EXISTS (SELECT 1 FROM v_temp_connec t WHERE t.connec_id = c.connec_id)
					) t
					WHERE c.connec_id = t.connec_id
					AND (c.staticpressure IS DISTINCT FROM t.staticpressure);
				';

				EXECUTE v_query_text;

				-- links
				v_query_text := '
					UPDATE link l SET
						staticpressure1 = t.staticpressure1,
						staticpressure2 = t.staticpressure2
					FROM (
						SELECT l.link_id,
							CASE
								WHEN l.' || v_mapzone_field || ' > 0 THEN
									(p.head - l.top_elev1 + COALESCE(l.depth1, 0))::numeric(12,3)
								ELSE NULL
							END AS staticpressure1,
							CASE
								WHEN l.' || v_mapzone_field || ' > 0 THEN
									(p.head - l.top_elev2 + COALESCE(l.depth2, 0))::numeric(12,3)
								ELSE NULL
							END AS staticpressure2
						FROM link l
						JOIN ' || v_table_name || ' p USING (' || v_mapzone_field || ')
						WHERE EXISTS (
							SELECT 1 FROM v_temp_link_connec c
							JOIN temp_pgr_arc t USING (arc_id)
							WHERE l.link_id = c.link_id
						)
					) t
					WHERE l.link_id = t.link_id
					AND (
						l.staticpressure1 IS DISTINCT FROM t.staticpressure1 OR
						l.staticpressure2 IS DISTINCT FROM t.staticpressure2
					);
				';
				EXECUTE v_query_text;
			ELSIF v_class = 'DMA' THEN
				RAISE NOTICE 'Filling temp_pgr_om_waterbalance_dma_graph ';

				WITH
					n AS (
						SELECT
							n.node_id,
							n.old_node_id,
							m.mapzone_id[1] AS mapzone_id
						FROM temp_pgr_node n
						JOIN temp_pgr_mapzone m ON n.mapzone_id = m.component
						WHERE n.graph_delimiter = 'DMA'
						AND CARDINALITY(m.mapzone_id) = 1
						GROUP BY n.node_id, n.old_node_id, m.mapzone_id
					)
				INSERT INTO temp_pgr_om_waterbalance_dma_graph (node_id, dma_id, flow_sign)
				SELECT
					n_node.node_id,
					n_dma.mapzone_id,
					CASE
						WHEN n_dma.mapzone_id = n_node.mapzone_id THEN 1
						ELSE -1
					END AS flow_sign
				FROM n as n_node
				JOIN n AS n_dma ON n_node.node_id = n_dma.old_node_id;

				WITH
				dma AS (
					SELECT DISTINCT dma_id FROM temp_pgr_om_waterbalance_dma_graph
					UNION
					SELECT DISTINCT old_mapzone_id AS dma_id FROM v_temp_pgr_mapzone_old
				)
				DELETE FROM om_waterbalance_dma_graph o
				WHERE EXISTS (SELECT 1 FROM dma d WHERE o.dma_id =d.dma_id);

				WITH
					node AS (
						SELECT DISTINCT node_id FROM temp_pgr_om_waterbalance_dma_graph
					)
				DELETE FROM om_waterbalance_dma_graph o
				WHERE EXISTS (SELECT 1 FROM node n WHERE o.node_id = n.node_id);

				INSERT INTO om_waterbalance_dma_graph
				SELECT * FROM temp_pgr_om_waterbalance_dma_graph
				WHERE dma_id <> -1
				ON CONFLICT (dma_id, node_id) DO NOTHING;

			ELSIF v_mapzone_name = 'DWFZONE' THEN
				-- update dwfzone_outfall (in one querry are updated DISCONNECTED and CONFLICT too - o.dwfzone_outfall = NULL)
				WITH outfalls AS (
					SELECT d.node AS pgr_node_id, array_agg(n.node_id  ORDER BY n.node_id) AS dwfzone_outfall
					FROM temp_pgr_drivingdistance d
					JOIN temp_pgr_node n ON d.start_vid = n.pgr_node_id
					WHERE EXISTS (
						SELECT 1 FROM temp_pgr_mapzone m
						WHERE CARDINALITY(m.mapzone_id) = 1
						AND m.component = n.mapzone_id
					)
					GROUP BY d.node
				)
				UPDATE node n SET dwfzone_outfall = o.dwfzone_outfall
				FROM temp_pgr_node pn
				LEFT JOIN  outfalls o USING (pgr_node_id)
				WHERE n.node_id = pn.node_id
				AND n.dwfzone_outfall IS DISTINCT FROM o.dwfzone_outfall;

				UPDATE arc a SET dwfzone_outfall = n.dwfzone_outfall
				FROM node n
				WHERE EXISTS (SELECT 1 FROM temp_pgr_arc t WHERE t.arc_id = a.arc_id)
				AND a.node_2 = n.node_id
				AND a.dwfzone_outfall IS DISTINCT FROM n.dwfzone_outfall;

				UPDATE connec c SET dwfzone_outfall = a.dwfzone_outfall
				FROM arc a
				WHERE EXISTS (SELECT 1 FROM temp_pgr_arc t WHERE t.arc_id = c.arc_id)
				AND EXISTS (SELECT 1 FROM v_temp_connec t WHERE t.connec_id = c.connec_id)
				AND c.arc_id = a.arc_id
				AND c.dwfzone_outfall IS DISTINCT FROM a.dwfzone_outfall;

				UPDATE gully g SET dwfzone_outfall = a.dwfzone_outfall
				FROM arc a
				WHERE EXISTS (SELECT 1 FROM temp_pgr_arc t WHERE t.arc_id = g.arc_id)
				AND EXISTS (SELECT 1 FROM v_temp_gully t WHERE t.gully_id = g.gully_id)
				AND g.arc_id = a.arc_id
				AND g.dwfzone_outfall IS DISTINCT FROM a.dwfzone_outfall;

				UPDATE link l SET dwfzone_outfall = c.dwfzone_outfall
				FROM connec c
				WHERE EXISTS (SELECT 1 FROM temp_pgr_arc t WHERE t.arc_id = c.arc_id)
				AND EXISTS (SELECT 1 FROM v_temp_link_connec t WHERE t.link_id = l.link_id)
				AND l.feature_id = c.connec_id
				AND l.dwfzone_outfall IS DISTINCT FROM c.dwfzone_outfall;

				UPDATE link l SET dwfzone_outfall = g.dwfzone_outfall
				FROM gully g
				WHERE EXISTS (SELECT 1 FROM temp_pgr_arc t WHERE t.arc_id = g.arc_id)
				AND EXISTS (SELECT 1 FROM v_temp_link_gully t WHERE t.link_id = l.link_id)
				AND l.feature_id = g.gully_id
				AND l.dwfzone_outfall IS DISTINCT FROM g.dwfzone_outfall;

				-- update DRAINZONE table
				INSERT INTO drainzone (drainzone_id, code, name, created_at, created_by)
				SELECT m.drainzone_id, m.drainzone_id, concat('drainzone',m.drainzone_id), now(), current_user
				FROM temp_pgr_mapzone m
				GROUP BY m.drainzone_id
				HAVING max(CARDINALITY(m.mapzone_id)) = 1
				AND NOT EXISTS (SELECT 1 FROM drainzone d WHERE d.drainzone_id = m.drainzone_id );

				-- clear geometries of drainzones that are not assigned before updating dwfzone.drainzone_id
				UPDATE drainzone d SET the_geom = NULL,
				updated_at = now(),
				updated_by = current_user
				WHERE EXISTS (
					SELECT 1
					FROM v_temp_pgr_mapzone_old m
					JOIN dwfzone dw ON m.old_mapzone_id = dw.dwfzone_id
					WHERE d.drainzone_id = dw.drainzone_id
				)
				AND NOT EXISTS (
					SELECT 1 FROM temp_pgr_mapzone m
					WHERE m.drainzone_id = d.drainzone_id
				);

				-- clear the geometries of drainzones that have at least on dwfzone in conflict in dwfzone
				UPDATE drainzone d SET the_geom = NULL,
				updated_at = now(),
				updated_by = current_user
				WHERE EXISTS (
					SELECT 1
					FROM (
						SELECT drainzone_id from temp_pgr_mapzone
						GROUP BY drainzone_id
						HAVING max(CARDINALITY(mapzone_id)) > 1
					) m
					WHERE m.drainzone_id = d.drainzone_id
				);

				UPDATE dwfzone d SET drainzone_id =
					CASE
						WHEN m.max_dwfzones = 1 then m.drainzone_id
						ELSE -1
					END,
					updated_at = now(),
					updated_by = current_user
				FROM (
					SELECT mapzone_id,
						drainzone_id,
						max(CARDINALITY(mapzone_id)) over(PARTITION BY drainzone_id) AS max_dwfzones
					FROM temp_pgr_mapzone) m
				WHERE d.dwfzone_id = ANY (m.mapzone_id);

				UPDATE dwfzone d SET drainzone_id = 0,
					updated_at = now(),
					updated_by = current_user
				WHERE NOT EXISTS (SELECT 1 FROM temp_pgr_mapzone m WHERE d.dwfzone_id = ANY (m.mapzone_id))
				AND EXISTS (SELECT 1 FROM temp_pgr_mapzone m WHERE d.drainzone_id = m.drainzone_id);

				WITH
					temp_dwfzone AS (
						SELECT d.dwfzone_id, d.drainzone_id, d.the_geom,
						expl_id, muni_id, sector_id
						FROM temp_pgr_mapzone m
						JOIN dwfzone d ON d.dwfzone_id = m.mapzone_id[1]
						WHERE d.drainzone_id >0
					),
					geom AS (
						SELECT drainzone_id, ST_Multi(ST_CollectionExtract(ST_Collect(the_geom), 3)) AS the_geom
						FROM temp_dwfzone
						GROUP BY drainzone_id
					),
					expl AS (
						SELECT a.drainzone_id, array_agg(DISTINCT a.expl_id ORDER BY a.expl_id) AS expl_id
						FROM (
							SELECT drainzone_id, unnest(expl_id) AS expl_id FROM temp_dwfzone
						) a
						GROUP BY a.drainzone_id
					),
					muni AS (
						SELECT a.drainzone_id, array_agg(DISTINCT a.muni_id ORDER BY a.muni_id)AS muni_id
						FROM (
							SELECT drainzone_id, unnest(muni_id) AS muni_id FROM temp_dwfzone
						) a
						GROUP BY a.drainzone_id
					),
					sector AS (
						SELECT a.drainzone_id, array_agg(DISTINCT a.sector_id ORDER BY a.sector_id)AS sector_id
						FROM (
							SELECT drainzone_id, unnest(sector_id) AS sector_id FROM temp_dwfzone
						) a
						GROUP BY a.drainzone_id
					)
				UPDATE drainzone d
				SET the_geom = g.the_geom,
					expl_id = e.expl_id,
					muni_id =m.muni_id,
					sector_id = s.sector_id,
					updated_at = now(),
					updated_by = current_user
				FROM geom g
				JOIN expl e USING(drainzone_id)
				JOIN muni m USING(drainzone_id)
				JOIN sector s USING(drainzone_id)
				WHERE d.drainzone_id =g.drainzone_id;

				--update drainzone_outfall
				-- flood from node_1 of arcs initoverflowpath TRUE that are not in a conflict drainzone
				EXECUTE 'SELECT array_agg(a.pgr_node_1)::INT[] 
					FROM temp_pgr_arc a
					WHERE a.graph_delimiter = ''INITOVERFLOWPATH''
					AND EXISTS (
						SELECT 1 
						FROM temp_pgr_mapzone m
						JOIN (SELECT drainzone_id from temp_pgr_mapzone 
								GROUP BY drainzone_id
								HAVING max(CARDINALITY(mapzone_id)) = 1
						) d ON d.drainzone_id = m.drainzone_id
						WHERE a.mapzone_id = m.component
					)'
				INTO v_pgr_root_vids;

				v_query_text := 'SELECT pgr_arc_id AS id, ' || v_source || ' AS source, ' || v_target || ' AS target, cost, reverse_cost 
					FROM temp_pgr_arc';

				INSERT INTO temp_pgr_drivingdistance_initoverflowpath(seq, "depth", start_vid, pred, node, edge, "cost", agg_cost)
					(
						SELECT seq, "depth", start_vid, pred, node, edge, "cost", agg_cost
						FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
					);

				WITH outfalls_start_vid AS (
					SELECT di.start_vid, n.node_id
					FROM (SELECT DISTINCT start_vid FROM temp_pgr_drivingdistance_initoverflowpath) di
					JOIN temp_pgr_arc a ON a.pgr_node_1 = di.start_vid
					JOIN temp_pgr_drivingdistance d ON a.pgr_node_2 = d.node
					JOIN  temp_pgr_node n ON d.start_vid = n.pgr_node_id
					WHERE a.graph_delimiter = 'INITOVERFLOWPATH'
				),
				outfalls AS (
					SELECT di.node AS pgr_node_id, array_agg(DISTINCT o.node_id  ORDER BY o.node_id) AS drainzone_outfall
					FROM temp_pgr_drivingdistance_initoverflowpath di
					JOIN outfalls_start_vid o ON o.start_vid = di.start_vid
					GROUP BY di.node
				)
				UPDATE node n SET drainzone_outfall = o.drainzone_outfall
				FROM temp_pgr_node pn
				LEFT JOIN outfalls o USING (pgr_node_id)
				WHERE n.node_id = pn.node_id
				AND n.drainzone_outfall IS DISTINCT FROM o.drainzone_outfall;

				UPDATE arc a SET drainzone_outfall = n.drainzone_outfall
				FROM node n
				WHERE EXISTS (SELECT 1 FROM temp_pgr_arc t WHERE t.arc_id = a.arc_id)
				AND a.node_2 = n.node_id
				AND a.drainzone_outfall IS DISTINCT FROM n.drainzone_outfall;

				UPDATE connec c SET drainzone_outfall = a.drainzone_outfall
				FROM arc a
				WHERE EXISTS (SELECT 1 FROM temp_pgr_arc t WHERE t.arc_id = c.arc_id)
				AND EXISTS (SELECT 1 FROM v_temp_connec t WHERE t.connec_id = c.connec_id)
				AND c.arc_id = a.arc_id
				AND c.drainzone_outfall IS DISTINCT FROM a.drainzone_outfall;

				UPDATE gully g SET drainzone_outfall = a.drainzone_outfall
				FROM arc a
				WHERE EXISTS (SELECT 1 FROM temp_pgr_arc t WHERE t.arc_id = g.arc_id)
				AND EXISTS (SELECT 1 FROM v_temp_gully t WHERE t.gully_id = g.gully_id)
				AND g.arc_id = a.arc_id
				AND g.drainzone_outfall IS DISTINCT FROM a.drainzone_outfall;

				UPDATE link l SET drainzone_outfall = c.drainzone_outfall
				FROM connec c
				WHERE EXISTS (SELECT 1 FROM temp_pgr_arc t WHERE t.arc_id = c.arc_id)
				AND EXISTS (SELECT 1 FROM v_temp_link_connec t WHERE t.link_id = l.link_id)
				AND l.feature_id = c.connec_id
				AND l.drainzone_outfall IS DISTINCT FROM c.drainzone_outfall;

				UPDATE link l SET drainzone_outfall = g.drainzone_outfall
				FROM gully g
				WHERE EXISTS (SELECT 1 FROM temp_pgr_arc t WHERE t.arc_id = g.arc_id)
				AND EXISTS (SELECT 1 FROM v_temp_link_gully t WHERE t.link_id = l.link_id)
				AND l.feature_id = g.gully_id
				AND l.drainzone_outfall IS DISTINCT FROM g.drainzone_outfall;

			END IF;
		END IF;

		-- clear geometries of mapzones that are not assigned to any featureNG EXISTS IN v_temp_pgr_mapzone_old and NOT EXISTS in temp_pgr_mapzone
		v_query_text = '
			UPDATE '||v_table_name||' SET the_geom = NULL,
				updated_at = now(),
				updated_by = current_user
			WHERE EXISTS (
				SELECT 1
				FROM v_temp_pgr_mapzone_old m
				WHERE m.old_mapzone_id = '||v_table_name||'.'||v_mapzone_field||'
			)
			AND NOT EXISTS (
				SELECT 1
				FROM temp_pgr_mapzone m
				WHERE '||v_table_name||'.'||v_mapzone_field||' = ANY(m.mapzone_id)
			);';
		EXECUTE v_query_text;
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
	v_netscenario := COALESCE(v_netscenario, -1);

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
				"netscenarioId": "'||v_netscenario::text||'", 
				"hasConflicts": '||v_has_conflicts||', 
				"info":'||v_result_info||',
				"point":'||v_result_point||',
				"line":'||v_result_line||',
				"polygon":'||v_result_polygon||'
			}
		}
	}')::json, 3508, null, ('{"visible": ["'||v_visible_layer||'"]}')::json, null)::json;

	EXCEPTION WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
		RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
