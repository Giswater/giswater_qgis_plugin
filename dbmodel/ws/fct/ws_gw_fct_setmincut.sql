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
SELECT gw_fct_setmincut('{"data":{"action":"mincutAccept", "mincutClass":1, "mincutId":"3", "usePsectors":false}}');

-- Button Accept when is mincutClass = 2
SELECT gw_fct_setmincut('{"data":{"action":"mincutAccept", "mincutClass":2, "mincutId":"3"}}');

-- Button Accept when is mincutClass = 3
SELECT gw_fct_setmincut('{"data":{"action":"mincutAccept", "mincutClass":3, "mincutId":"3"}}');

fid = 216

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
v_minsector_id integer;

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
v_mincut_conflict_array text;
v_mincut_conflict_count integer;
v_geometry text;
v_count_unselected_psectors integer;
v_default_key text;
v_default_value text;

v_mincut_record record;
v_mincut_group_record record;
v_mincut_conflict_record record;
v_mincut_affected_id integer;
v_mincut_affected_ids text;
v_mincut_conflict_group_id uuid;
v_arc_count integer;
v_overlap_status text := 'Ok'; -- Ok, Conflict

v_mincut_plannified_state integer := 0; -- Plannified mincut state
v_mincut_in_progress_state integer := 1; -- In progress mincut state
v_mincut_finished_state integer := 2; -- Finished mincut state
v_mincut_cancel_state integer := 3; -- Cancel mincut state
v_mincut_on_planning_state integer := 4; -- On planning mincut state
v_mincut_conflict_state integer := 5; -- Conflict mincut state

v_mincut_network_class integer := 1; -- Network mincut class

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

v_mode text;
v_temp_arc_table regclass;
v_temp_node_table regclass;

v_update_map_zone integer := 0;
v_concave_hull float = 0.9;
v_srid integer;
v_geom_param_update float := 10;
v_geom_param_update_divide float;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version order by id desc limit 1;

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
	v_update_map_zone := (SELECT value::json->>'bufferType' FROM config_param_system WHERE parameter = 'om_mincut_config');
	v_geom_param_update := (SELECT value::json->>'geomParamUpdate' FROM config_param_system WHERE parameter = 'om_mincut_config');

	IF v_client_epsg IS NULL THEN v_client_epsg = v_epsg; END IF;
	IF v_cur_user IS NULL THEN v_cur_user = current_user; END IF;

	
	-- Create temporary tables if not exists
	-- =======================
	v_data := jsonb_build_object(
		'data', jsonb_build_object(
			'action', 'CREATE',
			'fct_name', 'MINCUT',
			'use_psector', v_use_plan_psectors
		)
	)::text;
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

	-- get node_id from coordinates
	IF v_valve_node_id IS NULL AND v_xcoord IS NOT NULL THEN
		v_sensibility_f := (SELECT (value::json->>'web')::float FROM config_param_system WHERE parameter = 'basic_info_sensibility_factor');
		v_sensibility = (v_zoomratio / 500 * v_sensibility_f);

		-- Make point
		SELECT ST_Transform(ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_client_epsg),v_epsg) INTO v_point;

		SELECT node_id INTO v_valve_node_id FROM ve_node WHERE ST_DWithin(the_geom, v_point,v_sensibility) LIMIT 1;
	END IF;

	-- CHECK
	-- check if use psectors is active with minsector version
	IF v_use_plan_psectors AND v_mincut_version = '6.1' THEN
		v_mincut_version = '6';
	END IF;

	IF v_mincut_version = '6.1' THEN
		v_mode := 'MINSECTOR';
        v_temp_arc_table = 'temp_pgr_arc_minsector'::regclass;
        v_temp_node_table = 'temp_pgr_node_minsector'::regclass;
    ELSE
		v_mode := '';
        v_temp_arc_table = 'temp_pgr_arc'::regclass;
        v_temp_node_table = 'temp_pgr_node'::regclass;
    END IF;

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
	
	IF v_mincut_version = '6.1' THEN
		v_minsector_id := (SELECT minsector_id FROM v_temp_arc WHERE arc_id = v_arc_id);

		IF v_minsector_id IS NULL OR v_minsector_id = 0 THEN
			RETURN jsonb_build_object(
				'status', 'Failed',
				'message', jsonb_build_object(
					'level', 3,
					'text', 'You MUST execute the minsector analysis before executing the mincut analysis with 6.1 version.'
				)
			);
		END IF;
	END IF;

	IF v_action IN ('mincutValveUnaccess', 'mincutChangeValveStatus') AND v_valve_node_id IS NULL THEN
		RETURN ('{"status":"Failed", "message":{"level":2, "text":"Node not found."}}')::json;
	END IF;

	-- manage actions
	IF v_action = 'mincutNetwork' THEN
		-- check if the arc exists in the cluster:
			-- true: refresh mincut
			-- false: init and refresh mincut
		IF v_mincut_version = '6.1' THEN
			EXECUTE format('SELECT count(*) FROM %I WHERE node_id = %L;', v_temp_node_table, v_minsector_id) INTO v_row_count;
		ELSE 
			EXECUTE format('SELECT count(*) FROM %I WHERE arc_id = %L', v_temp_arc_table, v_arc_id) INTO v_row_count;
		END IF;
		IF v_row_count = 0 THEN
			v_init_mincut := TRUE;
			v_prepare_mincut := FALSE;
		ELSE
			v_init_mincut := FALSE;
			v_prepare_mincut := TRUE;
		END IF;
		v_core_mincut := TRUE;

		IF v_device = 5 AND v_mincut_id IS NULL THEN
			SELECT setval('om_mincut_seq', COALESCE((SELECT max(id::integer)+1 FROM om_mincut), 1), true) INTO v_mincut_id;
			INSERT INTO om_mincut (id, mincut_state) VALUES (v_mincut_id, v_mincut_on_planning_state);

			-- Set default values
			FOR v_default_key, v_default_value IN SELECT * FROM jsonb_each_text(v_vdefault::jsonb) LOOP
				EXECUTE 'UPDATE om_mincut SET '||v_default_key||' = '||v_default_value||' WHERE id = '||v_mincut_id||';';
			END LOOP;
			p_data = jsonb_set(p_data::jsonb, '{data,mincutId}', to_jsonb(v_mincut_id))::json;

			v_query_text := format(
				'UPDATE om_mincut SET mincut_class = %s, anl_the_geom = %L, anl_user = %L, anl_feature_type = %L, anl_feature_id = %s WHERE id = %s',
				v_mincut_network_class,
				ST_SetSRID(ST_Point(v_xcoord, v_ycoord), v_client_epsg),
				v_cur_user,
				'ARC',
				v_arc_id,
				v_mincut_id
			);
			EXECUTE v_query_text;
		END IF;
	
	ELSIF v_action = 'mincutRefresh' THEN 
		-- check if the arc exists in the cluster:
			-- true: refresh mincut
			-- false: init and refresh mincut
		IF v_mincut_version = '6.1' THEN
			EXECUTE format('SELECT count(*) FROM %I WHERE node_id = %L;', v_temp_node_table, v_minsector_id) INTO v_row_count;
		ELSE 
			EXECUTE format('SELECT count(*) FROM %I WHERE arc_id = %L', v_temp_arc_table, v_arc_id) INTO v_row_count;
		END IF;
		IF v_row_count = 0 THEN
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
				WHEN unaccess = TRUE THEN FALSE 
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
			IF v_mincut_version = '6.1' THEN
				EXECUTE format('SELECT count(*) FROM %I WHERE node_id = %L;', v_temp_node_table, v_minsector_id) INTO v_row_count;
			ELSE 
				EXECUTE format('SELECT count(*) FROM %I WHERE arc_id = %L', v_temp_arc_table, v_arc_id) INTO v_row_count;
			END IF;
			IF v_row_count = 0 THEN
				v_init_mincut := TRUE;
				v_prepare_mincut := FALSE;
			ELSE
				v_init_mincut := FALSE;
				v_prepare_mincut := TRUE;
			END IF;
			v_core_mincut := TRUE;
		END IF;
	ELSIF v_action = 'mincutChangeValveStatus' THEN
		UPDATE om_mincut_valve
		SET changestatus =
			CASE 
				WHEN changestatus = TRUE THEN FALSE 
				WHEN closed = TRUE AND broken = FALSE AND to_arc IS NULL THEN TRUE 
				ELSE changestatus 
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
			IF v_mincut_version = '6.1' THEN
				EXECUTE format('SELECT count(*) FROM %I WHERE node_id = %L;', v_temp_node_table, v_minsector_id) INTO v_row_count;
			ELSE 
				EXECUTE format('SELECT count(*) FROM %I WHERE arc_id = %L', v_temp_arc_table, v_arc_id) INTO v_row_count;
			END IF;
			IF v_row_count = 0 THEN
				v_init_mincut := TRUE;
				v_prepare_mincut := FALSE;
			ELSE
				v_init_mincut := FALSE;
				v_prepare_mincut := TRUE;
			END IF;
			v_core_mincut := TRUE;
		END IF;
	ELSIF v_action = 'mincutStart' THEN
		v_message = json_build_object(
			'text', 'Start mincut',
			'level', 3
		);
		IF v_device = 5 THEN
			IF (SELECT mincut_state FROM om_mincut WHERE id = v_mincut_id) IN (v_mincut_plannified_state, v_mincut_on_planning_state) THEN
				UPDATE om_mincut SET mincut_state = 1 WHERE id = v_mincut_id;
			END IF;
		END IF;

		IF (SELECT json_extract_path_text(value::json, 'redoOnStart','status')::boolean FROM config_param_system WHERE parameter='om_mincut_settings') is true THEN
			--reexecuting mincut on clicking start
			SELECT json_extract_path_text(value::json, 'redoOnStart','days')::integer INTO v_days FROM config_param_system WHERE parameter='om_mincut_settings';

			IF (SELECT date(anl_tstamp) + v_days FROM om_mincut WHERE id = v_mincut_id) <= date(now()) THEN
				IF v_mincut_version = '6.1' THEN
					EXECUTE format('SELECT count(*) FROM %I WHERE node_id = %L;', v_temp_node_table, v_minsector_id) INTO v_row_count;
				ELSE 
					EXECUTE format('SELECT count(*) FROM %I WHERE arc_id = %L', v_temp_arc_table, v_arc_id) INTO v_row_count;
				END IF;				
				IF v_row_count = 0 THEN
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
		v_message = json_build_object(
			'text', 'Mincut accepted.',
			'level', 1
		);
		IF v_device = 5 THEN
			IF v_action = 'mincutAccept' THEN
				v_querytext = concat('SELECT gw_fct_setfields($$', p_data, '$$);');
				EXECUTE v_querytext;
				IF (select mincut_state from om_mincut where id = v_mincut_id) = v_mincut_on_planning_state THEN
					UPDATE om_mincut SET mincut_state = v_mincut_plannified_state WHERE id = v_mincut_id;
				END IF;
			ELSIF v_action = 'endMincut' THEN
				IF (SELECT mincut_state FROM om_mincut WHERE id = v_mincut_id) = v_mincut_in_progress_state THEN
					UPDATE om_mincut SET mincut_state = v_mincut_finished_state WHERE id = v_mincut_id;
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
		AND om.mincut_state  <> v_mincut_conflict_state
		ON CONFLICT (result_id, cur_user) DO NOTHING;

		INSERT INTO selector_mincut_result (result_id, cur_user, result_type)
		SELECT omc.mincut_id, current_user, 'affected' 
		FROM om_mincut_conflict omc
		JOIN om_mincut om ON om.id = omc.mincut_id 
		WHERE omc.id = v_mincut_conflict_group_id
		AND omc.mincut_id <> v_mincut_id
		AND om.mincut_state = v_mincut_conflict_state
		ON CONFLICT (result_id, cur_user) DO NOTHING;

		IF v_device = 5 THEN
			RETURN gw_fct_getmincut(p_data);
		END IF;

		SELECT * INTO v_mincut_record FROM om_mincut WHERE id = v_mincut_id;

        DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=216;
		IF v_mincut_conflict_group_id IS NOT NULL THEN
			v_overlap_status = 'Conflict';

			-- creating log
			SELECT string_agg(result_id::text, ',') INTO v_mincut_affected_ids FROM selector_mincut_result WHERE cur_user = current_user AND result_type = 'affected';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4406", "prefix_id": "1002", "function":"2244", "fid":"216", "criticity":"2", "is_process":true, "parameters":{"state_type":"'||v_mincut_conflict_state||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4422", "function":"2244", "fid":"216", "criticity":"2", "is_process":true, "parameters":{"array":"'||v_mincut_affected_ids||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';

			-- mincut details
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"separator_id": "2000", "function":"2244", "fid":"216", "criticity":"3", "is_process":true, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4362", "function":"2244", "fid":"216", "criticity":"3", "is_process":true, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"separator_id": "2030", "function":"2244", "fid":"216", "criticity":"3", "is_process":true, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			
			-- Stats
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4364", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"number":"'||COALESCE((v_mincut_record.output->'arcs'->>'number'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4366", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"length":"'||COALESCE((v_mincut_record.output->'arcs'->>'length'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4368", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"volume":"'||COALESCE((v_mincut_record.output->'arcs'->>'volume'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4370", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"number":"'||COALESCE((v_mincut_record.output->'connecs'->>'number'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4372", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"total":"'||COALESCE((v_mincut_record.output->'connecs'->'hydrometers'->>'total'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4374", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"classified":"'||COALESCE(replace((v_mincut_record.output->'connecs'->'hydrometers'->>'classified'), '"', '\"'), '[]')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';

			
			FOR v_mincut_affected_id IN SELECT result_id FROM selector_mincut_result WHERE cur_user = current_user AND result_type = 'affected' LOOP
				-- mincut extra details
				SELECT * INTO v_mincut_record FROM om_mincut WHERE id = v_mincut_affected_id;
				-- mincut affected details
				EXECUTE 'SELECT gw_fct_getmessage($${"data":{"separator_id": "2000", "function":"2244", "fid":"216", "criticity":"3", "is_process":true, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
				EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4420", "function":"2244", "fid":"216", "criticity":"3", "is_process":true, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
				EXECUTE 'SELECT gw_fct_getmessage($${"data":{"separator_id": "2030", "function":"2244", "fid":"216", "criticity":"3", "is_process":true, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
				
				-- Extra details
				EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4424", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"id":"'||v_mincut_affected_id||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
				EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4418", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"array":"'||COALESCE((v_mincut_record.output->'conflicts'->>'array'), '')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
				EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4426", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"interval":"'||COALESCE(v_mincut_record.forecast_start::text, '0')||' - '||COALESCE(v_mincut_record.forecast_end::text, '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
				EXECUTE 'SELECT gw_fct_getmessage($${"data":{"separator_id": "2007", "function":"2244", "fid":"216", "criticity":"3", "is_process":true, "tempTable":"temp_", "cur_user":"current_user"}}$$)';

				-- Stats
				EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4364", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"number":"'||COALESCE((v_mincut_record.output->'arcs'->>'number'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
				EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4366", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"length":"'||COALESCE((v_mincut_record.output->'arcs'->>'length'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
				EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4368", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"volume":"'||COALESCE((v_mincut_record.output->'arcs'->>'volume'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
				EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4370", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"number":"'||COALESCE((v_mincut_record.output->'connecs'->>'number'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
				EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4372", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"total":"'||COALESCE((v_mincut_record.output->'connecs'->'hydrometers'->>'total'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
				EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4374", "function":"2244", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"classified":"'||COALESCE(replace((v_mincut_record.output->'connecs'->'hydrometers'->>'classified'), '"', '\"'), '[]')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			END LOOP;

		ELSE
			v_overlap_status = 'Ok';

			-- mincut details
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4362", "function":"2244", "fid":"216", "criticity":"3", "is_process":true, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"separator_id": "2030", "function":"2244", "fid":"216", "criticity":"3", "is_process":true, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			
			-- Stats
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4364", "function":"2988", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"number":"'||COALESCE((v_mincut_record.output->'arcs'->>'number'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4366", "function":"2988", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"length":"'||COALESCE((v_mincut_record.output->'arcs'->>'length'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4368", "function":"2988", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"volume":"'||COALESCE((v_mincut_record.output->'arcs'->>'volume'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4370", "function":"2988", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"number":"'||COALESCE((v_mincut_record.output->'connecs'->>'number'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4372", "function":"2988", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"total":"'||COALESCE((v_mincut_record.output->'connecs'->'hydrometers'->>'total'), '0')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4374", "function":"2988", "fid":"216", "criticity":"1", "is_process":true, "parameters":{"classified":"'||COALESCE(replace((v_mincut_record.output->'connecs'->'hydrometers'->>'classified'), '"', '\"'), '[]')||'"}, "tempTable":"temp_", "cur_user":"current_user"}}$$)';
			END IF;

		-- get results
		-- info
		v_result = null;
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
		FROM (SELECT id, error_message as message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=216 order by id) row;
		v_result := COALESCE(v_result, '{}');
		v_result_info = concat ('{"values":',v_result, '}');

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
		v_message = json_build_object(
			'text', 'Mincut to cancel not found.',
			'level', 2
		);
		IF (SELECT id FROM om_mincut WHERE id = v_mincut_id) IS NOT NULL THEN
			WITH groups_conflict AS (
				SELECT DISTINCT id FROM om_mincut_conflict WHERE mincut_id = v_mincut_id
			),
			mincuts_to_delete AS (
				SELECT omc.mincut_id 
				FROM om_mincut_conflict omc
				JOIN om_mincut om ON om.id = omc.mincut_id
				WHERE om.mincut_state = v_mincut_conflict_state
				AND omc.id IN (SELECT id FROM groups_conflict)
			)
			DELETE FROM om_mincut WHERE id IN (SELECT mincut_id FROM mincuts_to_delete);

			WITH groups_conflict AS (
				SELECT DISTINCT id FROM om_mincut_conflict WHERE mincut_id = v_mincut_id
			)
			DELETE FROM om_mincut_conflict
			WHERE id IN (SELECT id FROM groups_conflict);

			IF (SELECT mincut_state FROM om_mincut WHERE id = v_mincut_id) = v_mincut_on_planning_state THEN
				DELETE FROM om_mincut WHERE id = v_mincut_id;
			ELSE
				UPDATE om_mincut SET mincut_state = v_mincut_cancel_state WHERE id = v_mincut_id;
			END IF;
			v_message = json_build_object(
				'text', 'Mincut cancelled.',
				'level', 1
			);
			
		END IF;
		-- manage null values
		v_message = COALESCE(v_message, '{}');

		v_response = json_build_object(
			'status', 'Accepted',
			'message', v_message,
			'version', v_version
		);
		RETURN v_response;
	ELSIF v_action = 'mincutDelete' THEN
		v_message = json_build_object(
			'text', 'Mincut to delete not found.',
			'level', 2
		);
		IF (SELECT id FROM om_mincut WHERE id = v_mincut_id) IS NOT NULL THEN
			DELETE FROM om_mincut WHERE id = v_mincut_id;
			v_message = json_build_object(
				'text', 'Mincut deleted.',
				'level', 1
			);
		END IF;

		-- manage null values
		v_message = COALESCE(v_message, '{}');

		v_response = json_build_object(
			'status', 'Accepted',
			'message', v_message,
			'version', v_version
		);
		RETURN v_response;
	END IF;

	-- CORE MINCUT CODE
	IF v_init_mincut THEN
		-- Initialize process
		-- =======================
		v_data := jsonb_build_object(
			'data', jsonb_build_object(
				'mapzone_name', 'MINCUT',
				'arc_id', v_arc_id,
				'mode', v_mode
			)
		)::text;
		SELECT gw_fct_graphanalytics_initnetwork(v_data) INTO v_response;

		IF v_response->>'status' <> 'Accepted' THEN
			RETURN v_response;
		END IF;

		-- Generate new arcs and update to_arc, closed, broken and cost
		-- =======================
		IF v_mincut_version <> '6.1' THEN
			EXECUTE format('
				UPDATE %I t
				SET modif = TRUE
				WHERE graph_delimiter = ''MINSECTOR''
				OR graph_delimiter = ''SECTOR'';
			', v_temp_node_table);
		END IF;

		v_data := jsonb_build_object(
			'data', jsonb_build_object(
				'mapzone_name', 'MINCUT',
				'mode', v_mode
			)
		)::text;
		SELECT gw_fct_graphanalytics_arrangenetwork(v_data) INTO v_response;

		IF v_response->>'status' <> 'Accepted' THEN
			RETURN v_response;
		END IF;
		
		-- the broken valves
		EXECUTE format('
			UPDATE %I a
			SET cost = 0, reverse_cost = 0
			WHERE a.graph_delimiter = ''MINSECTOR''
			AND a.closed = FALSE 
			AND a.to_arc IS NOT NULL
			AND a.broken = TRUE;
		', v_temp_arc_table);

		-- establishing the borders of the mincut (update cost_mincut/reverse_cost_mincut for the new arcs)
		-- new arcs MINSECTOR AND SECTOR
		EXECUTE format('
			UPDATE %I a
			SET cost_mincut = -1, reverse_cost_mincut = -1
			WHERE a.graph_delimiter IN (''MINSECTOR'', ''SECTOR'');
		', v_temp_arc_table);

		-- the broken open valves
		EXECUTE format('
			UPDATE %I a
			SET cost_mincut = 0, reverse_cost_mincut = 0
			WHERE a.graph_delimiter = ''MINSECTOR''
			AND a.closed = FALSE 
			AND a.broken = TRUE;
		', v_temp_arc_table);

		-- check valves
		IF v_ignore_check_valves THEN
			EXECUTE format('
				UPDATE %I a
				SET cost_mincut = 0, reverse_cost_mincut = 0
				WHERE a.graph_delimiter = ''MINSECTOR''
				AND a.closed = FALSE 
				AND a.cost <> a.reverse_cost
			', v_temp_arc_table);
		ELSE 
			EXECUTE format('
				UPDATE %I a
				SET cost_mincut = cost, reverse_cost_mincut = reverse_cost
				WHERE a.graph_delimiter = ''MINSECTOR''
				AND a.closed = FALSE 
				AND a.cost <> a.reverse_cost
			', v_temp_arc_table);
		END IF;
	END IF;

	IF v_prepare_mincut THEN
		-- prepare mincut 
		EXECUTE format('
			UPDATE %I 
			SET mapzone_id = 0 
			WHERE mapzone_id <> 0;
		', v_temp_arc_table);

		EXECUTE format('
			UPDATE %I 
			SET mapzone_id = 0 
			WHERE mapzone_id <> 0;
		', v_temp_node_table);

		-- set the default values for proposed valves for current mincut (old_mapzone_id = 0) and adjacents mincuts, if they exist (old_mapzone_id <> 0)
		EXECUTE format('
			UPDATE %I 
			SET proposed = FALSE
			WHERE proposed = TRUE
				AND old_mapzone_id = 0;
		', v_temp_arc_table);

		EXECUTE format('
			UPDATE %I 
			SET proposed = FALSE, cost = 0, reverse_cost = 0, old_mapzone_id = 0
            WHERE proposed = TRUE
                AND old_mapzone_id <> 0;
		', v_temp_arc_table);

		-- set the default values for unaccess valves for current mincut, the unaccess valves of the adjacents valves are not taken in account
		EXECUTE format('
            UPDATE %I 
            SET unaccess = FALSE, cost_mincut = -1, reverse_cost_mincut = -1
            WHERE unaccess = TRUE;
        ', v_temp_arc_table);

		-- set the default values for changestatus valves for current mincut (old_mapzone_id = 0) and adjacents mincuts, if they exist (old_mapzone_id <> 0)
		EXECUTE format('
            UPDATE %I 
            SET changestatus = FALSE, cost = 0, reverse_cost = 0, old_mapzone_id = 0
            WHERE changestatus = TRUE;
        ', v_temp_arc_table);
	END IF;

	IF v_core_mincut THEN

		-- update unaccess valves
		IF v_mincut_version = '6.1' THEN
			v_query_text := 'tpa.arc_id';
		ELSE
			v_query_text := 'COALESCE(tpa.node_1, tpa.node_2)';
		END IF;
		EXECUTE format('
			UPDATE %I tpa
			SET unaccess = TRUE, cost_mincut = 0, reverse_cost_mincut = 0
			FROM om_mincut_valve omv
			WHERE omv.result_id = %L
			AND omv.unaccess = TRUE
			AND omv.node_id = %s
			AND tpa.graph_delimiter = ''MINSECTOR'';
		', v_temp_arc_table, v_mincut_id, v_query_text);

		-- update changestatus valves (temporary open the closed valves that belong to the mincut)
		EXECUTE format('
			UPDATE %I tpa
			SET changestatus = TRUE, cost = 0, reverse_cost = 0
			FROM om_mincut_valve omv
			WHERE omv.result_id = %L
			AND omv.node_id = %s
			AND omv.changestatus = TRUE
			AND tpa.closed = TRUE AND tpa.broken = FALSE AND tpa.to_arc IS NULL
			AND tpa.graph_delimiter = ''MINSECTOR'';
		', v_temp_arc_table, v_mincut_id, v_query_text);

		-- mincut
		EXECUTE format('SELECT count(*)::int FROM %I;', v_temp_arc_table) INTO v_pgr_distance;
		IF v_mincut_version = '6.1' THEN
			EXECUTE format('SELECT pgr_node_id FROM %I WHERE node_id = %L;', v_temp_node_table, v_minsector_id) INTO v_pgr_node_id;
		ELSE 
			EXECUTE format('SELECT pgr_node_1 FROM %I WHERE arc_id = %L;', v_temp_arc_table, v_arc_id) INTO v_pgr_node_id;
		END IF;

		-- Use jsonb_build_object for cleaner and safer JSON construction
		v_data := jsonb_build_object(
			'data', jsonb_build_object(
				'pgrDistance', v_pgr_distance,
				'pgrRootVids', ARRAY[v_pgr_node_id],
				'mode', v_mode
			)
		)::text;
		v_response := gw_fct_mincut_core(v_data);

		-- include in the mincut the valves with changestatus TRUE that are out of the mincut
		EXECUTE format('
			UPDATE %I tpa
			SET mapzone_id = %L
			WHERE tpa.mapzone_id = 0
			AND tpa.changestatus = TRUE;
		', v_temp_arc_table, v_mincut_id);

		-- if a valve with changestatus = TRUE is proposed, remove changestatus 
		EXECUTE format('
			UPDATE %I tpa
			SET changestatus = FALSE, cost = -1, reverse_cost = -1
			WHERE tpa.changestatus = TRUE
				AND tpa.proposed = TRUE;
		', v_temp_arc_table);

		DELETE FROM om_mincut_node where result_id=v_mincut_id;
		DELETE FROM om_mincut_arc where result_id=v_mincut_id;
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
			WHERE om.mincut_state = v_mincut_conflict_state
			AND omc.id IN (SELECT id FROM groups_conflict)
		)
		DELETE FROM om_mincut WHERE id IN (SELECT mincut_id FROM mincuts_to_delete);


		WITH groups_conflict AS (
			SELECT DISTINCT id FROM om_mincut_conflict WHERE mincut_id = v_mincut_id
		)
		DELETE FROM om_mincut_conflict
		WHERE id IN (SELECT id FROM groups_conflict);

		-- delete this rows, and for the mincut conflict delete it in the om_mincut table. CASCADE.

		IF v_mincut_version = '6.1' THEN
			EXECUTE format('
				INSERT INTO om_mincut_arc (result_id, arc_id, the_geom)
				SELECT %L, vta.arc_id, vta.the_geom 
				FROM %I tpn
				JOIN v_temp_arc vta ON vta.minsector_id = tpn.node_id
				WHERE tpn.mapzone_id <> 0
				AND tpn.graph_delimiter = ''MINSECTOR'';
			', v_mincut_id, v_temp_node_table);

			EXECUTE format('
				INSERT INTO om_mincut_node (result_id, node_id, the_geom, node_type)
				SELECT %L, vtn.node_id, vtn.the_geom, vtn.node_type
				FROM %I tpn
				JOIN v_temp_node vtn ON vtn.minsector_id = tpn.node_id
				WHERE tpn.mapzone_id <> 0
				AND tpn.graph_delimiter = ''MINSECTOR'';
			', v_mincut_id, v_temp_node_table);

			EXECUTE format('
				INSERT INTO om_mincut_valve (result_id, node_id, closed, broken, unaccess, changestatus, proposed, the_geom, to_arc)
				SELECT %L, tpa.arc_id AS node_id, tpa.closed, tpa.broken, tpa.unaccess, tpa.changestatus, tpa.proposed, vtn.the_geom, tpa.to_arc[1]
				FROM %I tpa
				JOIN v_temp_node vtn ON vtn.node_id = tpa.arc_id
				WHERE tpa.mapzone_id <> 0
				AND tpa.graph_delimiter = ''MINSECTOR'';
			', v_mincut_id, v_temp_arc_table);
		ELSE

			EXECUTE format('
				INSERT INTO om_mincut_arc (result_id, arc_id, the_geom)
				SELECT %L, vta.arc_id, vta.the_geom 
				FROM %I tpa
				JOIN v_temp_arc vta ON vta.arc_id = tpa.arc_id
				WHERE tpa.mapzone_id <> 0;
			', v_mincut_id, v_temp_arc_table);

			EXECUTE format('
				INSERT INTO om_mincut_node (result_id, node_id, the_geom, node_type)
				SELECT %L, vtn.node_id, vtn.the_geom, vtn.node_type
				FROM %I tpn
				JOIN v_temp_node vtn ON vtn.node_id = tpn.node_id
				WHERE tpn.mapzone_id <> 0;
			', v_mincut_id, v_temp_node_table);

			EXECUTE format('
				INSERT INTO om_mincut_valve (result_id, node_id, closed, broken, unaccess, changestatus, proposed, the_geom, to_arc)
				SELECT %L, COALESCE(tpa.node_1, tpa.node_2) AS node_id, tpa.closed, tpa.broken, tpa.unaccess, tpa.changestatus, tpa.proposed, vtn.the_geom, tpa.to_arc[1]
				FROM %I tpa
				JOIN v_temp_node vtn ON vtn.node_id = COALESCE(tpa.node_1, tpa.node_2)
				WHERE tpa.mapzone_id <> 0
				AND tpa.graph_delimiter = ''MINSECTOR'';
			', v_mincut_id, v_temp_arc_table);
		END IF;

		IF v_update_map_zone = 0 THEN
			-- do nothing

		ELSIF  v_update_map_zone = 1 THEN

			-- concave polygon
			v_query_text := '
				UPDATE om_mincut m SET polygon_the_geom = ST_Multi(a.the_geom)
				FROM (
					WITH polygon AS (
						SELECT ST_Collect(a.the_geom) AS g
						FROM om_mincut_arc a
						WHERE result_id = '||v_mincut_id||'
					)
					SELECT
					CASE WHEN ST_GeometryType(ST_ConcaveHull(g, '||v_concave_hull||')) = ''ST_Polygon''::text THEN
						ST_Buffer(ST_ConcaveHull(g, '||v_concave_hull||'), 2)::geometry(Polygon,'||(v_srid)||')
						ELSE ST_Expand(ST_Buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,'||(v_srid)||')
						END AS the_geom
					FROM polygon
					)a
				WHERE m.id = '||v_mincut_id||';';
			EXECUTE v_query_text;

		ELSIF  v_update_map_zone = 2 THEN

			-- pipe buffer
			v_query_text := '
				UPDATE om_mincut m SET polygon_the_geom = the_geom
				FROM (
					SELECT ST_Multi(ST_Buffer(ST_Collect(a.the_geom),'||v_geom_param_update||')) AS the_geom
					FROM om_mincut_arc a
					WHERE result_id = '||v_mincut_id||'
				) a
				WHERE m.id = '||v_mincut_id||';';
			EXECUTE v_query_text;

		ELSIF  v_update_map_zone = 3 THEN

			-- use plot and pipe buffer
			v_query_text := '
				UPDATE om_mincut m SET polygon_the_geom = the_geom FROM (
					SELECT ST_Multi(ST_Buffer(ST_Collect(the_geom),0.01)) AS the_geom FROM (
						SELECT ST_Buffer(ST_Collect(a.the_geom), '||v_geom_param_update||') AS the_geom 
						FROM om_mincut_arc a
						WHERE result_id = '||v_mincut_id||'
						UNION
						SELECT ST_Collect(ep.the_geom) AS the_geom 
						FROM om_mincut_arc a
						JOIN connec c ON a.arc_id = c.arc_id
						LEFT JOIN ext_plot ep ON c.plot_code = ep.plot_code 
							AND ST_DWithin(c.the_geom, ep.the_geom, 0.001)
						WHERE a.result_id = '||v_mincut_id||'
					) a
				) b
				WHERE m.id = '||v_mincut_id||';';
			EXECUTE v_query_text;

		ELSIF  v_update_map_zone = 4 THEN

			v_geom_param_update_divide := v_geom_param_update / 2;

			-- use link and pipe buffer
			v_query_text := '
				UPDATE om_mincut m SET polygon_the_geom = the_geom FROM (
					SELECT ST_Multi(ST_Buffer(ST_Collect(c.the_geom),0.01)) AS the_geom FROM (
						SELECT ST_Buffer(ST_Collect(a.the_geom), '||v_geom_param_update||') AS the_geom
						FROM om_mincut_arc a
						WHERE result_id = '||v_mincut_id||'
						UNION
						SELECT (ST_Buffer(ST_Collect(l.the_geom),'||v_geom_param_update_divide||',''endcap=flat join=round'')) AS the_geom
						FROM om_mincut_arc a
						JOIN link l ON a.arc_id = l.exit_id
						WHERE l.exit_type = ''ARC''
						AND a.result_id = '||v_mincut_id||'
					) c
				) b
				WHERE m.id = '||v_mincut_id||';';

			EXECUTE v_query_text;
		END IF;

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
		JOIN ext_rtc_hydrometer erh ON rhxc.hydrometer_id=erh.hydrometer_id
		WHERE result_id = v_mincut_id 
			AND rhxc.connec_id = omc.connec_id
			AND erh.state_id IN (SELECT (json_array_elements_text((value::json->>'1')::json))::INTEGER FROM config_param_system where parameter  = 'admin_hydrometer_state');

		-- insert hydrometer from node
		INSERT INTO om_mincut_hydrometer (result_id, hydrometer_id)
		SELECT v_mincut_id, rhxn.hydrometer_id FROM rtc_hydrometer_x_node rhxn
		JOIN om_mincut_node omn ON rhxn.node_id = omn.node_id 
		JOIN ext_rtc_hydrometer erh ON rhxn.hydrometer_id = erh.hydrometer_id
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
			AND closed IS TRUE AND changestatus = FALSE;

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

		IF v_dialog_forecast_start IS NOT NULL AND v_dialog_forecast_end IS NOT NULL THEN

			v_query_text := format($fmt$
				WITH mincut_conflicts AS (
					SELECT o.id, o.anl_feature_type, o.anl_feature_id, 
						tsrange(o.forecast_start, o.forecast_end, '[]') * tsrange(%L, %L, '[]') AS seg_mincut
					FROM om_mincut o
					JOIN om_mincut_cat_type c ON o.mincut_type = c.id 
					WHERE o.mincut_state IN (%s, %s)
						AND o.mincut_class = %s
						AND c.virtual = FALSE 
						AND o.forecast_start <= o.forecast_end 
						AND tsrange(o.forecast_start, o.forecast_end, '[]') && tsrange(%L, %L, '[]')
						AND o.id <> %s
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
			v_mincut_plannified_state, v_mincut_in_progress_state,
			v_mincut_network_class,
			v_dialog_forecast_start, v_dialog_forecast_end,
			v_mincut_id,
			v_temp_arc_table,
			v_dialog_forecast_start, v_dialog_forecast_end
			);

			FOR v_mincut_group_record IN EXECUTE v_query_text LOOP

				-- prepare mincut
				EXECUTE format('
					UPDATE %I 
					SET mapzone_id = 0 
					WHERE mapzone_id <> 0;
				', v_temp_arc_table);

				EXECUTE format('
					UPDATE %I 
					SET mapzone_id = 0 
					WHERE mapzone_id <> 0;
				', v_temp_node_table);

				EXECUTE format('
					UPDATE %I 
					SET proposed = FALSE 
					WHERE proposed = TRUE
						AND old_mapzone_id = 0;
				', v_temp_arc_table);

				EXECUTE format('
					UPDATE %I
					SET proposed = FALSE, cost = 0, reverse_cost = 0, old_mapzone_id = 0
					WHERE proposed = TRUE
						AND old_mapzone_id <> 0;
				', v_temp_arc_table);

				EXECUTE format('
					UPDATE %I
					SET changestatus = FALSE, cost = -1, reverse_cost = -1, old_mapzone_id = 0
					WHERE changestatus = TRUE
						AND old_mapzone_id <> 0;
				', v_temp_arc_table);

				IF v_mincut_version = '6.1' THEN
					v_query_text := 'tpa.arc_id';
				ELSE
					v_query_text := 'COALESCE(tpa.node_1, tpa.node_2)';
				END IF;

				EXECUTE format('
					UPDATE %I tpa
					SET changestatus = omv.changestatus, cost = 0, reverse_cost = 0, old_mapzone_id = omv.result_id
					FROM om_mincut_valve omv
					WHERE omv.result_id = ANY(%L)
						AND omv.node_id = %s
						AND omv.changestatus = TRUE
						AND tpa.closed = TRUE AND tpa.broken = FALSE AND tpa.to_arc IS NULL
						AND tpa.graph_delimiter = ''MINSECTOR'';
				', v_temp_arc_table, v_mincut_group_record.mincut_group, v_query_text);

				EXECUTE format('
					UPDATE %I tpa
					SET proposed = omv.proposed, cost = -1, reverse_cost = -1, old_mapzone_id = omv.result_id
					FROM om_mincut_valve omv
					WHERE omv.result_id = ANY(%L)
						AND omv.proposed = TRUE
						AND omv.node_id = %s
						AND tpa.graph_delimiter = ''MINSECTOR'';
				', v_temp_arc_table, v_mincut_group_record.mincut_group, v_query_text);

				GET DIAGNOSTICS v_row_count = ROW_COUNT;

				IF v_row_count = 0 THEN
					continue;
				END IF;

				v_data := jsonb_build_object(
					'data', jsonb_build_object(
						'pgrDistance', v_pgr_distance,
						'pgrRootVids', ARRAY[v_pgr_node_id],
						'ignoreCheckValvesMincut', v_ignore_check_valves,
						'mode', v_mode
					)
				)::text;
				
				v_response := gw_fct_mincut_core(v_data);

				IF v_response->>'status' <> 'Accepted' THEN
					RETURN v_response;
				END IF;

				IF v_mincut_version = '6.1' THEN
					EXECUTE format('
						SELECT count(*)
						FROM %I tpn
						WHERE tpn.mapzone_id <> 0
						AND NOT EXISTS (
							SELECT 1
							FROM om_mincut_arc oma
							JOIN v_temp_arc vta ON oma.arc_id = vta.arc_id
							WHERE (oma.result_id = %L OR oma.result_id = ANY(%L))
								AND vta.minsector_id = tpn.node_id
						);
					', v_temp_node_table, v_mincut_id, v_mincut_group_record.mincut_group) INTO v_arc_count;
				ELSE
					EXECUTE format('
						SELECT count(*)
						FROM %I tpa
						WHERE tpa.mapzone_id <> 0
							AND tpa.arc_id IS NOT NULL
							AND NOT EXISTS (
								SELECT 1
								FROM om_mincut_arc oma
								WHERE (oma.result_id = %L OR oma.result_id = ANY(%L))
									AND oma.arc_id = tpa.arc_id
							);
					', v_temp_arc_table, v_mincut_id, v_mincut_group_record.mincut_group) INTO v_arc_count;
				END IF;

				IF v_arc_count > 0 THEN
					v_overlap_status = 'Conflict';

					IF v_mincut_version = '6.1' THEN
						v_query_text := format($fmt$
							SELECT tpa.pgr_arc_id AS id, tpa.pgr_node_1 AS source, tpa.pgr_node_2 AS target, 1 as cost
							FROM %I tpa
							WHERE tpa.mapzone_id <> 0
								AND NOT EXISTS (
									SELECT 1
									FROM %I tpn
									JOIN v_temp_arc vta ON vta.minsector_id = tpn.node_id
									JOIN om_mincut_arc oma ON oma.arc_id = vta.arc_id
									WHERE tpn.pgr_node_id = tpa.pgr_node_1
										AND oma.result_id = %L
								)
								AND NOT EXISTS (
									SELECT 1
									FROM %I tpn
									JOIN v_temp_arc vta ON vta.minsector_id = tpn.node_id
									JOIN om_mincut_arc oma ON oma.arc_id = vta.arc_id
									WHERE tpn.pgr_node_id = tpa.pgr_node_2
										AND oma.result_id = %L
								)
						$fmt$, v_temp_arc_table, v_temp_node_table, v_mincut_id, v_temp_node_table, v_mincut_id);
					ELSE
						v_query_text := format($fmt$
							SELECT tpa.pgr_arc_id AS id, tpa.pgr_node_1 AS source, tpa.pgr_node_2 AS target, 1 as cost
							FROM %I tpa
							WHERE tpa.mapzone_id <> 0
								AND NOT EXISTS (
									SELECT 1
									FROM om_mincut_arc oma
									WHERE oma.result_id = %s
										AND oma.arc_id = tpa.arc_id
								)
						$fmt$, v_temp_arc_table, v_mincut_id);
					END IF;
					TRUNCATE temp_pgr_connectedcomponents;
					INSERT INTO temp_pgr_connectedcomponents (seq, component, node)
					SELECT seq, component, node FROM pgr_connectedcomponents(v_query_text);

					v_query_text := format('
						SELECT DISTINCT c1.component
						FROM %I a
						JOIN temp_pgr_connectedcomponents c1 ON a.pgr_node_1 = c1.node
						JOIN temp_pgr_connectedcomponents c2 ON a.pgr_node_2 = c2.node
						WHERE a.mapzone_id <> 0 AND a.arc_id IS NOT NULL
						AND c1.component = c2.component
					', v_temp_arc_table);

					
					FOR v_mincut_conflict_record IN EXECUTE v_query_text LOOP
						-- create the new mincut virtual: [onPlanning and Conflict]
						INSERT INTO om_mincut (mincut_class, mincut_state)
						VALUES (v_mincut_network_class, v_mincut_conflict_state)
						RETURNING id INTO v_mincut_affected_id;

						IF v_mincut_version = '6.1' THEN
							EXECUTE format('
								INSERT INTO om_mincut_arc (result_id, arc_id, the_geom) 
								SELECT %L, vta.arc_id, vta.the_geom
								FROM %I tpn
								JOIN v_temp_arc vta ON vta.minsector_id = tpn.node_id
								WHERE tpn.mapzone_id <> 0
									AND tpn.graph_delimiter = ''MINSECTOR''
									AND EXISTS (SELECT 1 FROM temp_pgr_connectedcomponents c WHERE c.node = tpn.pgr_node_id AND c.component = %L)
							', v_mincut_affected_id, v_temp_node_table, v_mincut_conflict_record.component);

							EXECUTE format('
								INSERT INTO om_mincut_node (result_id, node_id, node_type, the_geom) 
								SELECT %L, vtn.node_id, vtn.node_type, vtn.the_geom
								FROM %I tpn
								JOIN v_temp_node vtn ON vtn.minsector_id = tpn.node_id
								WHERE tpn.mapzone_id <> 0
									AND tpn.graph_delimiter = ''MINSECTOR''
									AND EXISTS (SELECT 1 FROM temp_pgr_connectedcomponents c WHERE c.node = tpn.pgr_node_id AND c.component = %L)
							', v_mincut_affected_id, v_temp_node_table, v_mincut_conflict_record.component);

							EXECUTE format('
								INSERT INTO om_mincut_valve (result_id, node_id, closed, broken, to_arc, unaccess, changestatus, proposed) 
								SELECT %L, arc_id, closed, broken, to_arc[0], unaccess, changestatus, proposed
								FROM %I tpa
								WHERE tpa.mapzone_id <> 0 
									AND tpa.graph_delimiter = ''MINSECTOR''
									AND EXISTS (
										SELECT 1 
										FROM temp_pgr_connectedcomponents c 
										WHERE c.node = tpa.pgr_node_1 
											AND c.component = %L
										)
									AND EXISTS (
										SELECT 1 
										FROM temp_pgr_connectedcomponents c 
										WHERE c.node = tpa.pgr_node_2 
											AND c.component = %L
										)
									AND NOT EXISTS (
										SELECT 1 
										FROM om_mincut_valve om 
										WHERE (
												om.result_id = %L OR om.result_id = ANY(%L)
											) 
											AND om.node_id = tpa.arc_id 
										);
							', v_mincut_affected_id, v_temp_arc_table, 
							v_mincut_conflict_record.component, v_mincut_conflict_record.component,
							v_mincut_id, v_mincut_group_record.mincut_group);
						ELSE
							EXECUTE format('
								INSERT INTO om_mincut_arc (result_id, arc_id, the_geom) 
								SELECT %L, a.arc_id, the_geom
								FROM %I a
								JOIN v_temp_arc va USING (arc_id)
								WHERE a.mapzone_id <> 0
									AND EXISTS (SELECT 1 FROM temp_pgr_connectedcomponents c WHERE c.node = a.pgr_node_1 AND c.component = %L)
									AND EXISTS (SELECT 1 FROM temp_pgr_connectedcomponents c WHERE c.node = a.pgr_node_2 AND c.component = %L); 
							', v_mincut_affected_id, v_temp_arc_table, v_mincut_conflict_record.component, v_mincut_conflict_record.component);

							EXECUTE format('
								INSERT INTO om_mincut_node (result_id, node_id, node_type, the_geom) 
								SELECT %L, n.node_id, node_type, the_geom
								FROM %I n
								JOIN v_temp_node vn USING (node_id)
								WHERE n.mapzone_id <> 0
									AND EXISTS (
										SELECT 1 
										FROM temp_pgr_connectedcomponents c 
										WHERE c.node = n.pgr_node_id 
											AND c.component = %L
										)
									AND NOT EXISTS (
										SELECT 1 
										FROM om_mincut_node om 
										WHERE (
											om.result_id = %L OR om.result_id = ANY(%L)
											) 
											AND n.node_id = om.node_id
										);
							', v_mincut_affected_id, v_temp_node_table,
							v_mincut_conflict_record.component, 
							v_mincut_id, v_mincut_group_record.mincut_group);

							EXECUTE format('
								INSERT INTO om_mincut_valve (result_id, node_id, closed, broken, to_arc, unaccess, changestatus, proposed) 
								SELECT %L, COALESCE (node_1, node_2), closed, broken, to_arc[0], unaccess, changestatus, proposed
								FROM %I a
								WHERE a.mapzone_id <> 0 
									AND graph_delimiter = ''MINSECTOR''
									AND EXISTS (
										SELECT 1 
										FROM temp_pgr_connectedcomponents c 
										WHERE c.node = a.pgr_node_1 
											AND c.component = %L
										)
									AND EXISTS (
										SELECT 1 
										FROM temp_pgr_connectedcomponents c 
										WHERE c.node = a.pgr_node_2 
											AND c.component = %L
										)
									AND NOT EXISTS (
										SELECT 1 
										FROM om_mincut_valve om 
										WHERE (
												om.result_id = %L OR om.result_id = ANY(%L)
											) 
											AND om.node_id = COALESCE(a.node_1, a.node_2) 
										);
							', v_mincut_affected_id, v_temp_arc_table, 
							v_mincut_conflict_record.component, v_mincut_conflict_record.component,
							v_mincut_id, v_mincut_group_record.mincut_group);
						END IF;

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
						JOIN ext_rtc_hydrometer erh ON rhxc.hydrometer_id=erh.hydrometer_id
						WHERE result_id = v_mincut_affected_id 
							AND rhxc.connec_id = omc.connec_id
							AND erh.state_id IN (SELECT (json_array_elements_text((value::json->>'1')::json))::INTEGER FROM config_param_system where parameter  = 'admin_hydrometer_state');

						-- insert hydrometer from node
						INSERT INTO om_mincut_hydrometer (result_id, hydrometer_id)
						SELECT v_mincut_affected_id, rhxn.hydrometer_id FROM rtc_hydrometer_x_node rhxn
						JOIN om_mincut_node omn ON rhxn.node_id = omn.node_id 
						JOIN ext_rtc_hydrometer erh ON rhxn.hydrometer_id = erh.hydrometer_id
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
						IF v_mincut_version = '6.1' THEN
							v_query_text := 'a.arc_id';
						ELSE
							v_query_text := 'COALESCE(a.node_1, a.node_2)';
						END IF;
						EXECUTE format('
							WITH mincuts_conflicts AS (
								SELECT DISTINCT om.result_id
								FROM %I a
								JOIN om_mincut_valve om ON om.node_id = %s
									AND om.result_id = ANY(%L)
								WHERE a.mapzone_id <> 0 
									AND graph_delimiter = ''MINSECTOR''
									AND EXISTS (
										SELECT 1 
										FROM temp_pgr_connectedcomponents c 
										WHERE c.node = a.pgr_node_1 
											AND c.component = %L
										)
									AND EXISTS (
										SELECT 1 
										FROM temp_pgr_connectedcomponents c 
										WHERE c.node = a.pgr_node_2 
											AND c.component = %L
										)
							)
							INSERT INTO om_mincut_conflict (id, mincut_id)
							SELECT %L, m.result_id
							FROM mincuts_conflicts m;
						', v_temp_arc_table, v_query_text, v_mincut_group_record.mincut_group,
						v_mincut_conflict_record.component, v_mincut_conflict_record.component,
						v_mincut_conflict_group_id::uuid);

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

						-- fill connnec & hydrometer details on om_mincut.output
						-- count arcs
						SELECT count(arc_id), sum(ST_Length(arc.the_geom))::numeric(12,2) INTO v_num_arcs, v_length
						FROM om_mincut_arc 
						JOIN arc USING (arc_id) 
						WHERE result_id = v_mincut_affected_id 
						GROUP BY result_id;

						SELECT sum(pi() * (dint * dint / 4_000_000) * ST_Length(arc.the_geom))::numeric(12,2) INTO v_volume
						FROM om_mincut_arc 
						JOIN arc USING (arc_id) 
						JOIN cat_arc ON arccat_id = cat_arc.id
						WHERE result_id = v_mincut_affected_id;

						-- count valves
						SELECT count(node_id) INTO v_num_valve_proposed 
						FROM om_mincut_valve 
						WHERE result_id = v_mincut_affected_id 
							AND proposed IS TRUE;

						SELECT count(node_id) INTO v_num_valve_closed 
						FROM om_mincut_valve 
						WHERE result_id = v_mincut_affected_id 
							AND closed IS TRUE AND changestatus IS FALSE;

						-- count connec
						SELECT count(connec_id) INTO v_num_connecs 
						FROM om_mincut_connec 
						WHERE result_id = v_mincut_affected_id;

						-- count hydrometers
						SELECT count(*) INTO v_num_hydrometer 
						FROM om_mincut_hydrometer 
						WHERE result_id = v_mincut_affected_id;

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
								WHERE result_id = v_mincut_affected_id
								GROUP BY hc.observ
								ORDER BY hc.observ
							) a
						);

						-- mincut conflict array
						SELECT count(*), string_agg(omc.mincut_id::text, ',' ORDER BY omc.mincut_id) 
						INTO v_mincut_conflict_count, v_mincut_conflict_array 
						FROM om_mincut_conflict omc
						WHERE omc.id = v_mincut_conflict_group_id
						AND omc.mincut_id <> v_mincut_id
						AND omc.mincut_id <> v_mincut_affected_id;

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
							),
							'conflicts', json_build_object(
								'number', v_mincut_conflict_count,
								'array', v_mincut_conflict_array
							)
						);
						UPDATE om_mincut SET output = v_mincut_details WHERE id = v_mincut_affected_id;

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

			END LOOP;

		END IF;
		-- select current mincut
		INSERT INTO selector_mincut_result (result_id, cur_user, result_type)
		VALUES (v_mincut_id, current_user, 'current') ON CONFLICT (result_id, cur_user) DO NOTHING;
	END IF;
	-- END CORE MINCUT CODE


	-- build geojson
	IF v_device = 5 THEN
		RETURN gw_fct_getmincut(p_data);
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
			  '"mincutArc":'||v_result_arc|| '
	      }
	    }
	}');
	RETURN v_response;

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;