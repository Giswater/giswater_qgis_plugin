/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2980

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setmincut(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setmincut(p_data json)
RETURNS json AS
$BODY$

/*
-- Button networkMincut on mincut dialog
SELECT gw_fct_setmincut('{"data":{"action":"mincutNetwork", "arcId":"2001", "mincutId":"3", "usePsectors":false}}');

-- Button valveUnaccess on mincut dialog
SELECT gw_fct_setmincut('{"data":{"action":"mincutValveUnaccess", "nodeId":1001, "mincutId":"3", "usePsectors":false}}');

-- Button Accept on mincut dialog
SELECT gw_fct_setmincut('{"data":{"action":"mincutAccept", "mincutClass":1, "mincutId":"3", "status":"check", "usePsectors":false}}');

-- Button Accept on mincut conflict dialog
SELECT gw_fct_setmincut('{"data":{"action":"mincutAccept", "mincutClass":1, "mincutId":"3", "status":"continue"}}');

-- Button Accept when is mincutClass = 2
SELECT gw_fct_setmincut('{"data":{"action":"mincutAccept", "mincutClass":2, "mincutId":"3"}}');

-- Button Accept when is mincutClass = 3
SELECT gw_fct_setmincut('{"data":{"action":"mincutAccept", "mincutClass":3, "mincutId":"3"}}');

fid = 216


mincut states:
0	Planified
1	In Progress
2	Finished
3	Canceled
4	On planning

*/

DECLARE

-- Parameters
v_cur_user text;
v_device integer;
v_tiled boolean;
v_action text;
v_mincut_id integer;
v_mincut_class integer;
v_valve_node_id integer;
v_pgr_node_id integer;
v_arc_id integer;
v_use_plan_psectors boolean;
v_mincut_version text;
-- 6.0 - normal mincut
-- 6.1 - mincut with minsectors
v_vdefault json;
v_ignore_check_valves boolean;
v_root_vid integer;

v_action_aux text;

-- dialog parameters
v_dialog_mincut_type text;
v_dialog_forecast_start timestamp;
v_dialog_forecast_end timestamp;


v_xcoord double precision;
v_ycoord double precision;
v_epsg integer;
v_client_epsg integer;
v_zoomratio float;

v_sensibility_f float;
v_sensibility float;
v_point public.geometry;

v_id integer;
v_version text;
v_days integer;
v_querytext text;
v_pgr_distance integer;
v_cost_field text;
v_reverse_cost_field text;
v_pgr_root_vids int[];

-- mincut details
v_mincut_details json;
v_num_arcs integer;
v_length double precision;
v_volume float;
v_num_connecs integer;
v_num_hydrometer integer;
v_num_valve_proposed integer;
v_num_valve_closed integer;
v_priority json;
v_geometry text;
v_count_unselected_psectors integer;
v_default_key text;
v_default_value text;

v_mincut_record record;
v_mincut_group_record record;
v_mincut_conflict_record record;
v_mincut_affected_id integer;
v_mincut_conflict_group_id uuid;
v_arc_count integer;
v_overlap_status text := 'Ok'; -- Ok, Conflict
v_mincut_conflict_class integer := 4; -- Conflict mincut class

v_query_text text;
v_data json;
v_result json;
v_result_info json;
v_result_init json;
v_result_valve json;
v_result_node json;
v_result_connec json;
v_result_arc json;

v_response json;
v_message text;
v_error_context text;

v_row_count integer;

v_init_mincut boolean := FALSE;
v_prepare_mincut boolean := FALSE;
v_core_mincut boolean := FALSE;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	SELECT giswater INTO v_version FROM sys_version order by id desc limit 1;

	--return current_user;
	-- get input parameters
	v_cur_user := p_data->'client'->>'cur_user';
	v_device := p_data->'client'->>'device';
	v_tiled := p_data->'client'->>'tiled';
	v_action := p_data->'data'->>'action';
	v_mincut_id := p_data->'data'->>'mincutId';
	v_mincut_class := p_data->'data'->>'mincutClass';
	v_valve_node_id := p_data->'data'->>'nodeId';
	v_arc_id := p_data->'data'->>'arcId';
	v_use_plan_psectors := p_data->'data'->>'usePsectors';
	-- get dialog parameters (IMPORTANT to execute mincut with dialog data)
	v_dialog_mincut_type := p_data->'data'->>'dialogMincutType';
	v_dialog_forecast_start := p_data->'data'->>'dialogForecastStart';
	v_dialog_forecast_end := p_data->'data'->>'dialogForecastEnd';

	v_mincut_version := (SELECT value::json->>'version' FROM config_param_system WHERE parameter = 'om_mincut_config');
	v_vdefault := (SELECT value::json FROM config_param_system WHERE parameter = 'om_mincut_vdefault');
	v_ignore_check_valves := (SELECT value::boolean FROM config_param_system WHERE parameter = 'ignoreCheckValvesMincut');

	v_xcoord := p_data->'data'->'coordinates'->>'xcoord';
	v_ycoord := p_data->'data'->'coordinates'->>'ycoord';
	v_epsg := (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);
	v_client_epsg := p_data->'client'->>'epsg';
	v_zoomratio := p_data->'data'->'coordinates'->>'zoomRatio';

	IF v_client_epsg IS NULL THEN v_client_epsg = v_epsg; END IF;
	IF v_cur_user IS NULL THEN v_cur_user = current_user; END IF;

	
	-- Create temporary tables if not exists
	-- =======================
	v_data := '{"data":{"action":"CREATE", "fct_name":"MINCUT", "use_psector":"'|| v_use_plan_psectors ||'"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

	IF v_response->>'status' <> 'Accepted' THEN
		RETURN v_response;
	END IF;

	-- get arc_id from click
	IF v_xcoord IS NOT NULL THEN
		v_sensibility_f := (SELECT (value::json->>'web')::float FROM config_param_system WHERE parameter = 'basic_info_sensibility_factor');
		v_sensibility = (v_zoomratio / 500 * v_sensibility_f);

		-- Make point
		SELECT ST_Transform(ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_client_epsg),v_epsg) INTO v_point;

		SELECT arc_id INTO v_arc_id FROM v_temp_arc WHERE ST_DWithin(the_geom, v_point,v_sensibility) LIMIT 1;
	END IF;

	-- CHECK
	--check if arc exists in database or look for a new arc_id in the same location
	IF v_arc_id IS NULL THEN
		SELECT anl_feature_id INTO v_arc_id FROM om_mincut WHERE id = v_mincut_id;
	END IF;

	IF (SELECT count(*) FROM v_temp_arc WHERE arc_id = v_arc_id) = 0 THEN
		SELECT a.arc_id INTO v_arc_id 
		FROM v_temp_arc a
		WHERE EXISTS (SELECT 1 FROM om_mincut om WHERE om.id = v_mincut_id AND ST_DWithin(a.the_geom, om.anl_the_geom,0.1))
		LIMIT 1;

		IF v_arc_id IS NULL THEN
			RETURN ('{"status":"Failed", "message":{"level":2, "text":"Arc not found."}}')::json;
		ELSE
			UPDATE om_mincut SET 
				anl_feature_id = v_arc_id,
				anl_feature_type = 'ARC',
				anl_the_geom = (SELECT ST_LineInterpolatePoint(the_geom, 0.5) FROM v_temp_arc WHERE arc_id = v_arc_id)
			WHERE id = v_mincut_id;
		END IF;
	END IF;

	IF v_action IN ('mincutValveUnaccess', 'mincutChangeValveStatus') AND v_valve_node_id IS NULL THEN
		RETURN ('{"status":"Failed", "message":{"level":2, "text":"Node not found."}}')::json;
	END IF;

	-- manage actions
	IF v_action IN ('mincutNetwork', 'mincutRefresh') THEN
		-- check if the arc exists in the cluster:
			-- true: refresh mincut
			-- false: init and refresh mincut

		IF (SELECT count(*) FROM temp_pgr_arc WHERE arc_id = v_arc_id) = 0 THEN
			v_init_mincut := TRUE;
			v_prepare_mincut := FALSE;
		ELSE
			v_init_mincut := FALSE;
			v_prepare_mincut := TRUE;
		END IF;
		v_core_mincut := TRUE;
	ELSIF v_action = 'mincutValveUnaccess' THEN
		UPDATE om_mincut_valve 
		SET unaccess = 
			CASE 
				WHEN proposed = TRUE THEN TRUE 
				WHEN proposed = FALSE AND unaccess = TRUE THEN FALSE 
				ELSE unaccess 
			END
		WHERE node_id = v_valve_node_id
		AND result_id = v_mincut_id;

		GET DIAGNOSTICS v_row_count = ROW_COUNT;

		IF v_row_count = 0 THEN
			-- do nothing because the previous result is exactly the same
			v_init_mincut := FALSE;
			v_prepare_mincut := FALSE;
			v_core_mincut := FALSE;
		ELSE 
			IF (SELECT count(*) FROM temp_pgr_arc WHERE arc_id = v_arc_id) = 0 THEN
				v_init_mincut := TRUE;
				v_prepare_mincut := FALSE;
			ELSE
				v_init_mincut := FALSE;
				v_prepare_mincut := TRUE;
			END IF;
			v_core_mincut := TRUE;
		END IF;
	ELSIF v_action = 'mincutChangeValveStatus' THEN
		UPDATE man_valve SET closed = NOT closed 
		WHERE node_id = v_valve_node_id
		AND EXISTS (
			SELECT 1 FROM v_temp_node 
			WHERE node_id = v_valve_node_id
				AND 'MINSECTOR' = ANY(graph_delimiter)
		)
		AND to_arc IS NULL;

		GET DIAGNOSTICS v_row_count = ROW_COUNT;

		IF v_row_count = 0 THEN
			-- do nothing because the previous result is exactly the same
			v_init_mincut := FALSE;
			v_prepare_mincut := FALSE;
			v_core_mincut := FALSE;
		ELSE 
			IF (SELECT count(*) FROM temp_pgr_arc WHERE arc_id = v_arc_id) = 0 THEN
				v_init_mincut := TRUE;
				v_prepare_mincut := FALSE;
			ELSE
				UPDATE temp_pgr_node 
				SET closed = NOT closed
				WHERE COALESCE(node_id, old_node_id) = v_valve_node_id;

				UPDATE temp_pgr_arc 
				SET closed = NOT closed 
				WHERE COALESCE(node_1, node_2) = v_valve_node_id
					AND graph_delimiter = 'MINSECTOR';

				UPDATE temp_pgr_arc a
				SET cost = -1, 
					reverse_cost = -1
				WHERE COALESCE(a.node_1, a.node_2) = v_valve_node_id
					AND a.graph_delimiter  = 'MINSECTOR'
					AND a.closed = TRUE;
				
				UPDATE temp_pgr_arc a
				SET cost = 0, 
					reverse_cost = 0
				WHERE COALESCE(a.node_1, a.node_2) = v_valve_node_id
					AND a.graph_delimiter  = 'MINSECTOR'
					AND a.closed = FALSE;

				v_init_mincut := FALSE;
				v_prepare_mincut := TRUE;
			END IF;
			v_core_mincut := TRUE;
		END IF;
	ELSIF v_action = 'mincutStart' THEN
		v_message = '{"text": "Start mincut", "level": 3}';
		IF v_device = 5 THEN
			IF (SELECT mincut_state FROM om_mincut WHERE id = v_mincut_id) IN (0, 4) THEN
				UPDATE om_mincut SET mincut_state = 1 WHERE id = v_mincut_id;
			END IF;
		END IF;

		IF (SELECT json_extract_path_text(value::json, 'redoOnStart','status')::boolean FROM config_param_system WHERE parameter='om_mincut_settings') is true THEN
			--reexecuting mincut on clicking start
			SELECT json_extract_path_text(value::json, 'redoOnStart','days')::integer INTO v_days FROM config_param_system WHERE parameter='om_mincut_settings';

			IF (SELECT date(anl_tstamp) + v_days FROM om_mincut WHERE id = v_mincut_id) <= date(now()) THEN
				IF (SELECT count(*) FROM temp_pgr_arc WHERE arc_id = v_arc_id) = 0 THEN
					v_init_mincut := TRUE;
					v_prepare_mincut := FALSE;
				ELSE
					v_init_mincut := FALSE;
					v_prepare_mincut := TRUE;
				END IF;
				v_core_mincut := TRUE;
			END IF;
		ELSE
			-- do nothing
			IF v_device = 5 THEN
				RETURN gw_fct_getmincut(p_data);
			ELSE
				v_init_mincut := FALSE;
				v_prepare_mincut := FALSE;
				v_core_mincut := FALSE;
			END IF;
		END IF;
	ELSIF v_action IN ('mincutAccept', 'endMincut') THEN

		-- call setfields
		v_message = '{"text": "Mincut accepted.", "level": 1}';
		IF v_device = 5 THEN
			IF v_action = 'mincutAccept' THEN
				v_querytext = concat('SELECT gw_fct_setfields($$', p_data, '$$);');
				EXECUTE v_querytext;
				IF (select mincut_state from om_mincut where id = v_mincut) = 4 THEN
					UPDATE om_mincut SET mincut_state = 0 WHERE id = v_mincut;
				END IF;
			ELSIF v_action = 'endMincut' THEN
				IF (SELECT mincut_state FROM om_mincut WHERE id = v_mincut) = 1 THEN
					UPDATE om_mincut SET mincut_state = 2 WHERE id = v_mincut;
				END IF;
			END IF;
		END IF;

		-- Manage the selector
		DELETE FROM selector_mincut_result WHERE cur_user = v_cur_user;
		INSERT INTO selector_mincut_result (result_id, cur_user, result_type)
		VALUES (v_mincut_id, current_user, 'current') ON CONFLICT (result_id, cur_user) DO NOTHING;

		SELECT id INTO v_mincut_conflict_group_id FROM om_mincut_conflict WHERE mincut_id = v_mincut_id;

		INSERT INTO selector_mincut_result (result_id, cur_user, result_type)
		SELECT omc.mincut_id, current_user, 'conflict' 
		FROM om_mincut_conflict omc
		JOIN om_mincut om ON om.id = omc.mincut_id 
		WHERE omc.id = v_mincut_conflict_group_id
		AND omc.mincut_id <> v_mincut_id
		AND om.mincut_class  <> v_mincut_conflict_class
		ON CONFLICT (result_id, cur_user) DO NOTHING;

		INSERT INTO selector_mincut_result (result_id, cur_user, result_type)
		SELECT omc.mincut_id, current_user, 'affected' 
		FROM om_mincut_conflict omc
		JOIN om_mincut om ON om.id = omc.mincut_id 
		WHERE omc.id = v_mincut_conflict_group_id
		AND omc.mincut_id <> v_mincut_id
		AND om.mincut_class = v_mincut_conflict_class
		ON CONFLICT (result_id, cur_user) DO NOTHING;

		IF v_device = 5 THEN
			SELECT gw_fct_getmincut(p_data) INTO v_response;

			-- Set the info to the info from v_result body data info
			v_response = jsonb_set(v_response::jsonb, '{body,data,info}', v_result::jsonb->'body'->'data'->'info');
			RETURN v_response;
		END IF;

		SELECT * INTO v_mincut_record FROM om_mincut WHERE id = v_mincut_id;

		IF v_mincut_conflict_group_id IS NOT NULL THEN
		-- there are conflicts
			v_overlap_status = 'Conflict';
			--TODO: revise this counts for maybe add the affected zone?
			-- creating log
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, 'WARNING-216: Mincut have been executed with conflicts. All additional affetations have been joined to present mincut');
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, '');
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, 'Mincut stats (with additional affectations)');
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, '-----------------------------------------------');
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, concat('Number of arcs: ', (v_mincut_record.output->>'arcs')::json->>'number'));
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, concat('Length of affected network: ', (v_mincut_record.output->>'arcs')::json->>'length', ' mts'));
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, concat('Total water volume: ', (v_mincut_record.output->>'arcs')::json->>'volume', ' m3'));
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, concat('Number of connecs affected: ', (v_mincut_record.output->>'connecs')::json->>'number'));
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, concat('Total of hydrometers affected: ', ((v_mincut_record.output->>'connecs')::json->>'hydrometers')::json->>'total'));
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, concat('Hydrometers classification: ', ((v_mincut_record.output->>'connecs')::json->>'hydrometers')::json->>'classified'));
		ELSE
		-- there are no conflicts
			v_overlap_status = 'Ok';
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, '');
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, 'Mincut stats');
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, '--------------');
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, concat('Number of arcs: ', (v_mincut_record.output->>'arcs')::json->>'number'));
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, concat('Length of affected network: ', (v_mincut_record.output->>'arcs')::json->>'length', ' mts'));
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, concat('Total water volume: ', (v_mincut_record.output->>'arcs')::json->>'volume', ' m3'));
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, concat('Number of connecs affected: ', (v_mincut_record.output->>'connecs')::json->>'number'));
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, concat('Total of hydrometers affected: ', ((v_mincut_record.output->>'connecs')::json->>'hydrometers')::json->>'total'));
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (216, concat('Hydrometers classification: ', ((v_mincut_record.output->>'connecs')::json->>'hydrometers')::json->>'classified'));
		END IF;

		-- get results
		-- info
		v_result = null;
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
		FROM (SELECT id, error_message as message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=216 order by id) row;
		v_result := COALESCE(v_result, '{}');
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

		-- geometry (the boundary of mincut using arcs and valves)
		EXECUTE ' SELECT st_astext(st_envelope(st_extent(st_buffer(the_geom,20)))) FROM (SELECT the_geom FROM om_mincut_arc WHERE result_id='||v_mincut_id||
		' UNION SELECT the_geom FROM om_mincut_valve WHERE result_id='||v_mincut_id||') a'
		INTO v_geometry;

		-- Control nulls
		v_result_info := COALESCE(v_result_info, '{}');
		v_geometry := COALESCE(v_geometry, '{}');

		-- return
		RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
			',"body":{"form":{}'||
			',"overlapStatus":"'||v_overlap_status||'"'||
			',"data":{ "info":'||v_result_info||','||
				  '"geometry":"'||v_geometry||'"'||
			'}}'||
			'}')::json, 2244,null,null,null);
	ELSIF v_action = 'mincutCancel' THEN
		v_message = '{"text": "Mincut to cancel not found.", "level": 2}';
		IF (SELECT id FROM om_mincut WHERE id = v_mincut_id) IS NOT NULL THEN
			IF (SELECT mincut_state FROM om_mincut WHERE id = v_mincut_id) = 4 THEN
				DELETE FROM om_mincut WHERE id = v_mincut_id;
			ELSE
				UPDATE om_mincut SET mincut_state = 3 WHERE id = v_mincut_id;
			END IF;
			v_message = '{"text": "Mincut cancelled.", "level": 1}';
		END IF;
	ELSIF v_action = 'mincutDelete' THEN
		v_message = '{"text": "Mincut to delete not found.", "level": 2}';
		IF (SELECT id FROM om_mincut WHERE id = v_mincut_id) IS NOT NULL THEN
			DELETE FROM om_mincut WHERE id = v_mincut_id;
			v_message = '{"text": "Mincut deleted.", "level": 1}';
		END IF;
	END IF;

	-- CORE MINCUT CODE
	IF v_init_mincut THEN
		IF v_mincut_version = '6.1' THEN
			v_root_vid := (SELECT minsector_id FROM v_temp_arc WHERE arc_id = v_arc_id);
		ELSE 
			v_root_vid := (SELECT node_1 FROM v_temp_arc WHERE arc_id = v_arc_id);
		END IF;
		-- Initialize process
		-- =======================
		v_data := '{"data":{"mapzone_name":"MINCUT", "node_id":"'|| v_root_vid ||'", "mincut_version":"'|| v_mincut_version ||'"}}';
		SELECT gw_fct_graphanalytics_initnetwork(v_data) INTO v_response;

		IF v_response->>'status' <> 'Accepted' THEN
			RETURN v_response;
		END IF;

		IF v_mincut_version = '6.1' THEN
			-- TODO: prepare tables for minsector algorithm
		END IF;

		UPDATE temp_pgr_node t
		SET modif = TRUE
		WHERE graph_delimiter = 'MINSECTOR'
		OR graph_delimiter = 'SECTOR';

		-- Generate new arcs
		-- =======================
		v_data := '{"data":{"mapzone_name":"MINCUT"}}';
		SELECT gw_fct_graphanalytics_arrangenetwork(v_data) INTO v_response;

		IF v_response->>'status' <> 'Accepted' THEN
			RETURN v_response;
		END IF;

		-- the broken valves
		UPDATE temp_pgr_arc a
		SET cost = 0, reverse_cost = 0
		WHERE a.graph_delimiter = 'MINSECTOR'
		AND a.closed = FALSE 
		AND a.to_arc IS NOT NULL
		AND a.broken = TRUE;

		-- establishing the borders of the mincut (update cost_mincut/reverse_cost_mincut for the new arcs)
		-- new arcs MINSECTOR AND SECTOR
		UPDATE temp_pgr_arc a
		SET cost_mincut = -1, reverse_cost_mincut = -1
		WHERE graph_delimiter IN ('MINSECTOR', 'SECTOR');

		-- check valves
		IF v_ignore_check_valves THEN
			v_cost_field = '0';
			v_reverse_cost_field = '0';
		ELSE 
			v_cost_field = 'cost';
			v_reverse_cost_field = 'reverse_cost';
		END IF;

		v_query_text = 'UPDATE temp_pgr_arc a
			SET cost_mincut = '||v_cost_field||', reverse_cost_mincut = '||v_reverse_cost_field||'
			WHERE a.graph_delimiter = ''MINSECTOR''
			AND a.closed = FALSE 
			AND a.to_arc IS NOT NULL';
		EXECUTE v_query_text;
	END IF;

	IF v_prepare_mincut THEN
		-- prepare mincut 
		UPDATE temp_pgr_arc 
		SET mapzone_id = 0 
		WHERE mapzone_id <> 0;

		UPDATE temp_pgr_node 
		SET mapzone_id = 0 
		WHERE mapzone_id <> 0;

		UPDATE temp_pgr_arc 
		SET proposed = FALSE 
		WHERE proposed = TRUE;
		--TODO parlar amb en Dani, aquesta condició no crec que hauria de ser
		UPDATE temp_pgr_arc
		SET unaccess = FALSE, cost_mincut = -1, reverse_cost_mincut = -1
		WHERE unaccess = TRUE;

		UPDATE temp_pgr_arc
		SET proposed = FALSE, cost = 0, reverse_cost = 0, old_mapzone_id = 0
		WHERE proposed = TRUE
			AND old_mapzone_id <> 0;
		
		UPDATE temp_pgr_arc
		SET unaccess = FALSE, cost_mincut = -1, reverse_cost_mincut = -1, old_mapzone_id = 0
		WHERE unaccess = TRUE
			AND old_mapzone_id <> 0;
	END IF;

	IF v_core_mincut THEN

		-- update unaccess valves
		UPDATE temp_pgr_arc tpa
		SET unaccess = TRUE, cost_mincut = 0, reverse_cost_mincut = 0
		FROM om_mincut_valve omv
		WHERE omv.result_id = v_mincut_id
		AND omv.unaccess = TRUE
		AND COALESCE(tpa.node_1, tpa.node_2) = omv.node_id
		AND tpa.graph_delimiter = 'MINSECTOR';

		-- mincut
		SELECT count(*)::int INTO v_pgr_distance 
		FROM temp_pgr_arc;

		v_pgr_node_id := (SELECT pgr_node_1 FROM temp_pgr_arc WHERE arc_id = v_arc_id);

		-- Use jsonb_build_object for cleaner and safer JSON construction
		v_data := jsonb_build_object(
			'data', jsonb_build_object(
				'pgrDistance', v_pgr_distance,
				'pgrRootVids', ARRAY[v_pgr_node_id],
				'ignoreCheckValvesMincut', v_ignore_check_valves
			)
		)::text;
		v_response := gw_fct_mincut_core(v_data);

		DELETE FROM om_mincut_node where result_id=v_mincut_id;
		DELETE FROM om_mincut_arc where result_id=v_mincut_id;
		DELETE FROM om_mincut_polygon where result_id=v_mincut_id;
		DELETE FROM om_mincut_connec where result_id=v_mincut_id;
		DELETE FROM om_mincut_hydrometer where result_id=v_mincut_id;
		DELETE FROM om_mincut_valve where result_id=v_mincut_id;

		DELETE FROM selector_mincut_result WHERE cur_user = current_user;

		WITH groups_conflict AS (
			SELECT DISTINCT id FROM om_mincut_conflict WHERE mincut_id = v_mincut_id
		),
		mincuts_to_delete AS (
			SELECT omc.mincut_id 
			FROM om_mincut_conflict omc
			JOIN om_mincut om ON om.id = omc.mincut_id
			WHERE om.mincut_class = 4
			AND omc.id IN (SELECT id FROM groups_conflict)
		)
		DELETE FROM om_mincut WHERE id IN (SELECT mincut_id FROM mincuts_to_delete);


		WITH groups_conflict AS (
			SELECT DISTINCT id FROM om_mincut_conflict WHERE mincut_id = v_mincut_id
		)
		DELETE FROM om_mincut_conflict
		WHERE id IN (SELECT id FROM groups_conflict);

		-- delete this rows, and for the mincut conflict delete it in the om_mincut table. CASCADE.

		INSERT INTO om_mincut_arc (result_id, arc_id, the_geom)
		SELECT v_mincut_id, vta.arc_id, vta.the_geom 
		FROM temp_pgr_arc tpa
		JOIN v_temp_arc vta ON vta.arc_id = tpa.arc_id
		WHERE tpa.mapzone_id <> 0;

		INSERT INTO om_mincut_node (result_id, node_id, the_geom, node_type)
		SELECT v_mincut_id, vtn.node_id, vtn.the_geom, vtn.node_type
		FROM temp_pgr_node tpn
		JOIN v_temp_node vtn ON vtn.node_id = tpn.node_id
		WHERE tpn.mapzone_id <> 0;

		INSERT INTO om_mincut_valve (result_id, node_id, closed, broken, unaccess, proposed, the_geom, to_arc)
		SELECT v_mincut_id, COALESCE(tpa.node_1, tpa.node_2) AS node_id, tpa.closed, tpa.broken, tpa.unaccess, tpa.proposed, vtn.the_geom, tpa.to_arc[0]
		FROM temp_pgr_arc tpa
		JOIN v_temp_node vtn ON vtn.node_id = COALESCE(tpa.node_1, tpa.node_2)
		WHERE tpa.mapzone_id <> 0
		AND tpa.graph_delimiter = 'MINSECTOR';

		INSERT INTO om_mincut_polygon (result_id, polygon_id, the_geom)
		SELECT v_mincut_id, p.pol_id, p.the_geom
		FROM om_mincut_node omn
		JOIN v_temp_node vtn ON vtn.node_id = omn.node_id
		JOIN polygon p ON p.feature_id = vtn.node_id
		WHERE omn.result_id = v_mincut_id;

		INSERT INTO om_mincut_connec (result_id, connec_id, the_geom, customer_code)
		SELECT v_mincut_id, vtc.connec_id, vtc.the_geom, vtc.customer_code
		FROM om_mincut_arc oma 
		JOIN v_temp_connec vtc ON vtc.arc_id = oma.arc_id
		WHERE oma.result_id = v_mincut_id;

		-- insert hydrometer from connec
		INSERT INTO om_mincut_hydrometer (result_id, hydrometer_id)
		SELECT v_mincut_id, rhxc.hydrometer_id 
		FROM rtc_hydrometer_x_connec rhxc
		JOIN om_mincut_connec omc ON rhxc.connec_id = omc.connec_id 
		JOIN ext_rtc_hydrometer erh ON rhxc.hydrometer_id=erh.id
		WHERE result_id = v_mincut_id 
			AND rhxc.connec_id = omc.connec_id
			AND erh.state_id IN (SELECT (json_array_elements_text((value::json->>'1')::json))::INTEGER FROM config_param_system where parameter  = 'admin_hydrometer_state');

		-- insert hydrometer from node
		INSERT INTO om_mincut_hydrometer (result_id, hydrometer_id)
		SELECT v_mincut_id, rhxn.hydrometer_id FROM rtc_hydrometer_x_node rhxn
		JOIN om_mincut_node omn ON rhxn.node_id = omn.node_id 
		JOIN ext_rtc_hydrometer erh ON rhxn.hydrometer_id = erh.id
		WHERE result_id = v_mincut_id 
			AND rhxn.node_id = omn.node_id
			AND erh.state_id IN (SELECT (json_array_elements_text((value::json->>'1')::json))::INTEGER FROM config_param_system where parameter  = 'admin_hydrometer_state');

		-- fill connnec & hydrometer details on om_mincut.output
		-- count arcs
		SELECT count(arc_id), sum(ST_Length(arc.the_geom))::numeric(12,2) INTO v_num_arcs, v_length
		FROM om_mincut_arc 
		JOIN arc USING (arc_id) 
		WHERE result_id = v_mincut_id 
		GROUP BY result_id;

		SELECT sum(pi() * (dint * dint / 4_000_000) * ST_Length(arc.the_geom))::numeric(12,2) INTO v_volume
		FROM om_mincut_arc 
		JOIN arc USING (arc_id) 
		JOIN cat_arc ON arccat_id = cat_arc.id
		WHERE result_id = v_mincut_id;

		-- count valves
		SELECT count(node_id) INTO v_num_valve_proposed 
		FROM om_mincut_valve 
		WHERE result_id = v_mincut_id 
			AND proposed IS TRUE;

		SELECT count(node_id) INTO v_num_valve_closed 
		FROM om_mincut_valve 
		WHERE result_id = v_mincut_id 
			AND closed IS TRUE;

		-- count connec
		SELECT count(connec_id) INTO v_num_connecs 
		FROM om_mincut_connec 
		WHERE result_id = v_mincut_id;

		-- count hydrometers
		SELECT count(*) INTO v_num_hydrometer 
		FROM om_mincut_hydrometer 
		WHERE result_id = v_mincut_id;

		-- priority hydrometers
		v_priority := (
			SELECT array_to_json(array_agg(b))
			FROM (
				SELECT 
					json_build_object(
						'category', hc.observ,
						'number', count(rtc_hydrometer_x_connec.hydrometer_id)
					) AS b
				FROM rtc_hydrometer_x_connec
				JOIN om_mincut_connec 
					ON rtc_hydrometer_x_connec.connec_id = om_mincut_connec.connec_id
				JOIN v_rtc_hydrometer 
					ON v_rtc_hydrometer.hydrometer_id = rtc_hydrometer_x_connec.hydrometer_id
				LEFT JOIN ext_hydrometer_category hc 
					ON hc.id::text = v_rtc_hydrometer.category_id::text
				JOIN connec 
					ON connec.connec_id = v_rtc_hydrometer.feature_id
				WHERE result_id = v_mincut_id
				GROUP BY hc.observ
				ORDER BY hc.observ
			) a
		);

		IF v_priority IS NULL THEN v_priority='{}'; END IF;
		v_count_unselected_psectors := COALESCE(v_count_unselected_psectors, 0);


		v_mincut_details = json_build_object(
			'arcs', json_build_object(
				'number', v_num_arcs,
				'length', v_length,
				'volume', v_volume
			),
			'connecs', json_build_object(
				'number', v_num_connecs,
				'hydrometers', json_build_object(
					'total', v_num_hydrometer,
					'classified', v_priority
				)
			),
			'valve', json_build_object(
				'proposed', v_num_valve_proposed,
				'closed', v_num_valve_closed
			)
		);

		--update output results
		UPDATE om_mincut SET output = v_mincut_details WHERE id = v_mincut_id;


		-- calculate the boundary of mincut using arcs and valves
		v_query_text := format(
			$fmt$
			SELECT ST_AsText(
				ST_Envelope(
					ST_Extent(
						ST_Buffer(the_geom, 20)
					)
				)
			)
			FROM (
				SELECT the_geom FROM om_mincut_arc WHERE result_id = %s
				UNION
				SELECT the_geom FROM om_mincut_valve WHERE result_id = %s
			) a
			$fmt$,
			v_mincut_id, v_mincut_id
		);
		EXECUTE v_query_text INTO v_geometry;

		-- FIRST MINCUT FINISHED

		--SELECT * into v_mincut_record FROM om_mincut WHERE id = v_mincut_id;

		IF v_dialog_forecast_start IS NOT NULL AND v_dialog_forecast_end IS NOT NULL THEN

			v_query_text := format($fmt$
				WITH mincut_conflicts AS (
					SELECT o.id, o.anl_feature_type, o.anl_feature_id, 
						tsrange(o.forecast_start, o.forecast_end, '[]') * tsrange(%L, %L, '[]') AS seg_mincut
					FROM om_mincut o
					JOIN om_mincut_cat_type c ON o.mincut_type = c.id 
					WHERE o.mincut_state IN (0, 1)
						AND o.mincut_class = 1
						AND c.virtual = FALSE 
						AND o.forecast_start <= o.forecast_end 
						AND tsrange(o.forecast_start, o.forecast_end, '[]') && tsrange(%L, %L, '[]')
						AND o.id <> %s
						-- removing EXISTS for grouping all the conflicts
						AND EXISTS (
							SELECT 1 FROM temp_pgr_arc tpa
							WHERE tpa.arc_id::text = o.anl_feature_id
						)
				), 
				mincut_times AS (
					-- put togther all the limits of all the intervals for mincuts in conflict
					SELECT LOWER(seg_mincut) AS forecast_date
					FROM mincut_conflicts
					UNION 
					SELECT UPPER(seg_mincut) AS forecast_date
					FROM mincut_conflicts
				), 
				mincut_times_before AS (
					-- generate the previous limit time
					SELECT 
						LAG(forecast_date) OVER (ORDER BY forecast_date) AS forecast_date_before, 
						forecast_date 
					FROM mincut_times
				),
				mincut_segments AS (
					-- create all the atomic intervals of all the intervals [prev, actual)
					SELECT  
						tsrange(forecast_date_before, forecast_date, '()') AS seg
					FROM mincut_times_before
					WHERE forecast_date_before IS NOT NULL
				),
				mincut_covers AS (
					-- for every segment, group the ids
					SELECT *
					FROM mincut_conflicts m
					JOIN mincut_segments s ON m.seg_mincut && s.seg
				),
				mincut_groups AS (
					SELECT seg, array_agg(DISTINCT id ORDER BY id) AS mincut_group
					FROM mincut_covers
					GROUP BY seg
				)
				SELECT g.seg, g.mincut_group
				FROM mincut_groups g
				WHERE NOT EXISTS (
					SELECT 1 FROM mincut_groups g1 
					WHERE g.mincut_group <@ g1.mincut_group
					AND g.mincut_group <> g1.mincut_group
				);
			$fmt$, 
			v_dialog_forecast_start, v_dialog_forecast_end, 
			v_dialog_forecast_start, v_dialog_forecast_end,
			v_mincut_id,
			v_dialog_forecast_start, v_dialog_forecast_end
			);
			RAISE NOTICE 'v_query_text: %', v_query_text;

			FOR v_mincut_group_record IN EXECUTE v_query_text LOOP

				-- prepare mincut 
				UPDATE temp_pgr_arc 
				SET mapzone_id = 0 
				WHERE mapzone_id <> 0;

				UPDATE temp_pgr_node 
				SET mapzone_id = 0 
				WHERE mapzone_id <> 0;

				UPDATE temp_pgr_arc 
				SET proposed = FALSE 
				WHERE proposed = TRUE;

				UPDATE temp_pgr_arc tpa
				SET proposed = omv.proposed, cost = -1, reverse_cost = -1, old_mapzone_id = omv.result_id
				FROM om_mincut_valve omv
				WHERE omv.result_id = ANY(v_mincut_group_record.mincut_group)
					AND omv.proposed = TRUE
					AND omv.node_id = COALESCE(tpa.node_1, tpa.node_2)
					AND tpa.graph_delimiter = 'MINSECTOR';

				UPDATE temp_pgr_arc tpa
				SET unaccess = omv.unaccess, cost_mincut = 0, reverse_cost_mincut = 0, old_mapzone_id = omv.result_id
				FROM om_mincut_valve omv
				WHERE omv.result_id = ANY(v_mincut_group_record.mincut_group)
					AND omv.unaccess = TRUE
					AND omv.node_id = COALESCE(tpa.node_1, tpa.node_2)
					AND tpa.graph_delimiter = 'MINSECTOR';


				v_data := format('{"data":{"pgrDistance":%s, "pgrRootVids":["%s"], "ignoreCheckValvesMincut":"%s"}}',
				v_pgr_distance, array_to_string(ARRAY[v_pgr_node_id], ','), v_ignore_check_valves);

				RAISE NOTICE 'v_data: %', v_data;
				v_response := gw_fct_mincut_core(v_data);

				IF v_response->>'status' <> 'Accepted' THEN
					RETURN v_response;
				END IF;

				SELECT count(*) INTO v_arc_count
				FROM temp_pgr_arc tpa
				WHERE tpa.mapzone_id <> 0
					AND tpa.arc_id IS NOT NULL
					AND NOT EXISTS (
						SELECT 1
						FROM om_mincut_arc oma
						WHERE oma.result_id = v_mincut_id
							AND oma.arc_id = tpa.arc_id
					);

				IF v_arc_count > 0 THEN
					v_overlap_status = 'Conflict';


					v_query_text := format($fmt$
						SELECT tpa.pgr_arc_id AS id, tpa.pgr_node_1 AS source, tpa.pgr_node_2 AS target, 1 as cost
						FROM temp_pgr_arc tpa
						WHERE tpa.mapzone_id <> 0
							AND NOT EXISTS (
								SELECT 1
								FROM om_mincut_arc oma
								WHERE oma.result_id = %s
									AND oma.arc_id = tpa.arc_id
							)
					$fmt$, v_mincut_id);
					TRUNCATE temp_pgr_connectedcomponents;
					INSERT INTO temp_pgr_connectedcomponents (seq, component, node)
					SELECT seq, component, node FROM pgr_connectedcomponents(v_query_text);

					v_query_text := '
						SELECT DISTINCT c1.component
						FROM temp_pgr_arc a
						JOIN temp_pgr_connectedcomponents c1 ON a.pgr_node_1 = c1.node
						JOIN temp_pgr_connectedcomponents c2 ON a.pgr_node_2 = c2.node
						WHERE a.mapzone_id <> 0 AND a.arc_id IS NOT NULL
						AND c1.component = c2.component
					';

					
					FOR v_mincut_conflict_record IN EXECUTE v_query_text LOOP
						-- create the new mincut virtual: [onPlanning and Conflict]
						INSERT INTO om_mincut (mincut_state, mincut_class)
						VALUES (4, 4)
						RETURNING id INTO v_mincut_affected_id;

						INSERT INTO om_mincut_arc (result_id, arc_id, the_geom) 
						SELECT v_mincut_affected_id, a.arc_id, the_geom
						FROM temp_pgr_arc a
						JOIN v_temp_arc va USING (arc_id)
						WHERE a.mapzone_id <> 0
							AND EXISTS (SELECT 1 FROM temp_pgr_connectedcomponents c WHERE c.node = a.pgr_node_1 AND c.component = v_mincut_conflict_record.component)
							AND EXISTS (SELECT 1 FROM temp_pgr_connectedcomponents c WHERE c.node = a.pgr_node_2 AND c.component = v_mincut_conflict_record.component); 

						INSERT INTO om_mincut_node (result_id, node_id, node_type, the_geom) 
						SELECT v_mincut_affected_id, n.node_id, node_type, the_geom
						FROM temp_pgr_node n
						JOIN v_temp_node vn USING (node_id)
						WHERE n.mapzone_id <> 0
							AND EXISTS (
								SELECT 1 
								FROM temp_pgr_connectedcomponents c 
								WHERE c.node = n.pgr_node_id 
									AND c.component = v_mincut_conflict_record.component
								)
							AND NOT EXISTS (
								SELECT 1 
								FROM om_mincut_node om 
								WHERE (
									om.result_id = v_mincut_id OR om.result_id = ANY(v_mincut_group_record.mincut_group)
									) 
									AND n.node_id = om.node_id
								);

						INSERT INTO om_mincut_valve (result_id, node_id, closed, broken, to_arc, unaccess, proposed) 
						SELECT v_mincut_affected_id, COALESCE (node_1, node_2), closed, broken, to_arc[0], unaccess, proposed
						FROM temp_pgr_arc a
						WHERE a.mapzone_id <> 0 
							AND graph_delimiter = 'MINSECTOR'
							AND EXISTS (
								SELECT 1 
								FROM temp_pgr_connectedcomponents c 
								WHERE c.node = a.pgr_node_1 
									AND c.component = v_mincut_conflict_record.component
								)
							AND EXISTS (
								SELECT 1 
								FROM temp_pgr_connectedcomponents c 
								WHERE c.node = a.pgr_node_2 
									AND c.component = v_mincut_conflict_record.component
								)
							AND NOT EXISTS (
								SELECT 1 
								FROM om_mincut_valve om 
								WHERE (
										om.result_id = v_mincut_id OR om.result_id = ANY(v_mincut_group_record.mincut_group)
									) 
									AND om.node_id = COALESCE(a.node_1, a.node_2) 
								);

						INSERT INTO om_mincut_polygon (result_id, polygon_id, the_geom)
						SELECT v_mincut_affected_id, p.pol_id, p.the_geom
						FROM om_mincut_node omn
						JOIN v_temp_node vtn ON vtn.node_id = omn.node_id
						JOIN polygon p ON p.feature_id = vtn.node_id
						WHERE omn.result_id = v_mincut_affected_id;

						INSERT INTO om_mincut_connec (result_id, connec_id, the_geom, customer_code)
						SELECT v_mincut_affected_id, vtc.connec_id, vtc.the_geom, vtc.customer_code
						FROM om_mincut_arc oma 
						JOIN v_temp_connec vtc ON vtc.arc_id = oma.arc_id
						WHERE oma.result_id = v_mincut_affected_id;

						-- insert hydrometer from connec
						INSERT INTO om_mincut_hydrometer (result_id, hydrometer_id)
						SELECT v_mincut_affected_id, rhxc.hydrometer_id 
						FROM rtc_hydrometer_x_connec rhxc
						JOIN om_mincut_connec omc ON rhxc.connec_id = omc.connec_id 
						JOIN ext_rtc_hydrometer erh ON rhxc.hydrometer_id=erh.id
						WHERE result_id = v_mincut_affected_id 
							AND rhxc.connec_id = omc.connec_id
							AND erh.state_id IN (SELECT (json_array_elements_text((value::json->>'1')::json))::INTEGER FROM config_param_system where parameter  = 'admin_hydrometer_state');

						-- insert hydrometer from node
						INSERT INTO om_mincut_hydrometer (result_id, hydrometer_id)
						SELECT v_mincut_affected_id, rhxn.hydrometer_id FROM rtc_hydrometer_x_node rhxn
						JOIN om_mincut_node omn ON rhxn.node_id = omn.node_id 
						JOIN ext_rtc_hydrometer erh ON rhxn.hydrometer_id = erh.id
						WHERE result_id = v_mincut_affected_id 
							AND rhxn.node_id = omn.node_id
							AND erh.state_id IN (SELECT (json_array_elements_text((value::json->>'1')::json))::INTEGER FROM config_param_system where parameter  = 'admin_hydrometer_state');



						v_mincut_conflict_group_id := gen_random_uuid();

						-- insert affected zone mincut first
						INSERT INTO om_mincut_conflict (id, mincut_id)
						VALUES (v_mincut_conflict_group_id, v_mincut_affected_id);

						-- insert original mincut
						INSERT INTO om_mincut_conflict (id, mincut_id)
						VALUES (v_mincut_conflict_group_id, v_mincut_id);

						-- insert conflict mincut
						WITH mincuts_conflicts AS (
							SELECT DISTINCT om.result_id
							FROM temp_pgr_arc a
							JOIN om_mincut_valve om ON om.node_id = COALESCE(a.node_1, a.node_2)
								AND om.result_id = ANY(v_mincut_group_record.mincut_group)
							WHERE a.mapzone_id <> 0 
								AND graph_delimiter = 'MINSECTOR'
								AND EXISTS (
									SELECT 1 
									FROM temp_pgr_connectedcomponents c 
									WHERE c.node = a.pgr_node_1 
										AND c.component = v_mincut_conflict_record.component
									)
								AND EXISTS (
									SELECT 1 
									FROM temp_pgr_connectedcomponents c 
									WHERE c.node = a.pgr_node_2 
										AND c.component = v_mincut_conflict_record.component
									)
						)
						INSERT INTO om_mincut_conflict (id, mincut_id)
						SELECT v_mincut_conflict_group_id::uuid, m.result_id
						FROM mincuts_conflicts m;

						-- update forecast_start and forecast_end for the affected zone mincut
						WITH forecast_time AS (
							SELECT 
								GREATEST(MAX (forecast_start),v_dialog_forecast_start)  AS forecast_start, 
								LEAST(MIN (forecast_end), v_dialog_forecast_end) AS forecast_end
							FROM om_mincut om
							WHERE EXISTS (
								SELECT 1 FROM om_mincut_conflict omc
								WHERE omc.id = v_mincut_conflict_group_id
								AND omc.mincut_id <> v_mincut_affected_id
								AND omc.mincut_id <> v_mincut_id
								AND omc.mincut_id = om.id
							)
						) 
						UPDATE om_mincut om SET 
							forecast_start = ft.forecast_start,
							forecast_end = ft.forecast_end
						FROM forecast_time ft
						WHERE om.id = v_mincut_affected_id;

						-- insert selector mincut result
						INSERT INTO selector_mincut_result (result_id, cur_user, result_type)
						VALUES (v_mincut_affected_id, current_user, 'affected') ON CONFLICT (result_id, cur_user) DO NOTHING;

						INSERT INTO selector_mincut_result (result_id, cur_user, result_type)
						SELECT omc.mincut_id, current_user, 'conflict' 
						FROM om_mincut_conflict omc
						WHERE omc.id = v_mincut_conflict_group_id
						AND omc.mincut_id <> v_mincut_id
						AND omc.mincut_id <> v_mincut_affected_id
						ON CONFLICT (result_id, cur_user) DO NOTHING;

					END LOOP;

				ELSE
					v_overlap_status = 'Ok';
				END IF;


				
				UPDATE temp_pgr_arc
				SET proposed = FALSE, cost = 0, reverse_cost = 0, old_mapzone_id = 0
				WHERE proposed = TRUE
					AND old_mapzone_id <> 0;
				
				UPDATE temp_pgr_arc
				SET unaccess = FALSE, cost_mincut = -1, reverse_cost_mincut = -1, old_mapzone_id = 0
				WHERE unaccess = TRUE
					AND old_mapzone_id <> 0;
			END LOOP;

		END IF;
		-- select current mincut
		INSERT INTO selector_mincut_result (result_id, cur_user, result_type)
		VALUES (v_mincut_id, current_user, 'current') ON CONFLICT (result_id, cur_user) DO NOTHING;
	END IF;
	-- END CORE MINCUT CODE


	-- build geojson
	IF v_device = 5 THEN
		--v_om_mincut
		SELECT jsonb_agg(features.feature) INTO v_result
			FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(anl_the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'anl_the_geom' - 'srid',
	    'crs',concat('EPSG:',srid)
	  	) AS feature
	  	FROM (SELECT id, ST_AsText(anl_the_geom) as anl_the_geom, ST_SRID(anl_the_geom) as srid
	  	FROM  v_om_mincut) row) features;

		v_result := COALESCE(v_result, '{}');
		v_result_init = concat('{"geometryType":"Point", "features":',v_result, '}');

		--v_om_mincut_valve
		SELECT jsonb_agg(features.feature) INTO v_result
			FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom' - 'srid',
	    'crs',concat('EPSG:',srid)
	  	) AS feature
	  	FROM (SELECT id, ST_AsText(the_geom) as the_geom, ST_SRID(the_geom) as srid
	  	FROM  v_om_mincut_valve) row) features;

		v_result := COALESCE(v_result, '{}');
		v_result_valve = concat('{"geometryType":"Point", "features":',v_result, '}');

		--v_om_mincut_node
		SELECT jsonb_agg(features.feature) INTO v_result
			FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom' - 'srid',
	    'crs',concat('EPSG:',srid)
	  	) AS feature
	  	FROM (SELECT id, ST_AsText(the_geom) as the_geom, ST_SRID(the_geom) as srid
	  	FROM  v_om_mincut_node) row) features;

		v_result := COALESCE(v_result, '{}');
		v_result_node = concat('{"geometryType":"Point", "features":',v_result, '}');

		--v_om_mincut_connec
		SELECT jsonb_agg(features.feature) INTO v_result
			FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom' - 'srid',
	    'crs',concat('EPSG:',srid)
	  	) AS feature
	  	FROM (SELECT id, ST_AsText(the_geom) as the_geom, ST_SRID(the_geom) as srid
	  	FROM  v_om_mincut_connec) row) features;

		v_result := COALESCE(v_result, '{}');
		v_result_connec = concat('{"geometryType":"Point", "features":',v_result, '}');

		--v_om_mincut_arc
		SELECT jsonb_agg(features.feature) INTO v_result
			FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom' - 'srid',
	    'crs',concat('EPSG:',srid)
	  	) AS feature
	  	FROM (SELECT id, arc_id, ST_AsText(the_geom) as the_geom, ST_SRID(the_geom) as srid
	  	FROM  v_om_mincut_arc) row) features;

		v_result := COALESCE(v_result, '{}');
		v_result_arc = concat('{"geometryType":"LineString", "features":',v_result, '}');
	END IF;

	-- manage null values
	v_message = COALESCE(v_message, '{}');
	v_result_init := COALESCE(v_result_init, '{}');
	v_result_valve := COALESCE(v_result_valve, '{}');
	v_result_node := COALESCE(v_result_node, '{}');
	v_result_connec := COALESCE(v_result_connec, '{}');
	v_result_arc := COALESCE(v_result_arc, '{}');
	v_tiled := COALESCE(v_tiled, 'false');

	v_response = ('{
	    "status": "Accepted",
        "message": ' || v_message || ',
	    "version": "' || v_version || '",
	    "body": {
	      "form": {},
	      "feature": {},
		  "overlapStatus":"'||v_overlap_status|| '",
	      "data": {
	        "mincutId": ' || v_mincut_id ||','||
			  '"mincutInit":'||v_result_init||','||
			  '"valve":'||v_result_valve||','||
			  '"mincutNode":'||v_result_node||','||
			  '"mincutConnec":'||v_result_connec||','||
			  '"mincutArc":'||v_result_arc||','||
			  '"tiled":'||v_tiled|| '
	      }
	    }
	}');
	return v_response;

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;