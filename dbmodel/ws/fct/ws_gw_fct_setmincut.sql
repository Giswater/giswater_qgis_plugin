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

*/

DECLARE

-- Parameters
v_cur_user text;
v_device integer;
v_tiled boolean;
v_action text;
v_mincut integer;
v_mincut_class integer;
v_node_id integer;
v_pgr_node_id integer;
v_arc integer;
v_usepsectors boolean;
v_mincut_version text;
-- 6.0 - normal mincut
-- 6.1 - mincut with minsectors
v_vdefault json;
v_ignore_check_valves boolean;

v_xcoord double precision;
v_ycoord double precision;
v_epsg integer;
v_client_epsg integer;
v_zoomratio float;

v_sensibility_f float;
v_sensibility float;
v_point public.geometry;

v_connec text;
v_id integer;
v_version text;
v_days integer;
v_querytext text;
v_pgr_distance integer;
v_cost_field text;
v_reverse_cost_field text;
v_pgr_root_vids int[];

v_default_key text;
v_default_value text;

v_query_text text;
v_data json;
v_result json;
v_result_init json;
v_result_valve json;
v_result_node json;
v_result_connec json;
v_result_arc json;

v_response json;
v_message text;
v_error_context text;

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
	v_mincut := p_data->'data'->>'mincutId';
	v_mincut_class := p_data->'data'->>'mincutClass';
	v_arc := p_data->'data'->>'arcId';
	v_usepsectors := p_data->'data'->>'usePsectors';
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

	-- get arc_id from click
	IF v_xcoord IS NOT NULL THEN
		v_sensibility_f := (SELECT (value::json->>'web')::float FROM config_param_system WHERE parameter = 'basic_info_sensibility_factor');
		v_sensibility = (v_zoomratio / 500 * v_sensibility_f);

		-- Make point
		SELECT ST_Transform(ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_client_epsg),v_epsg) INTO v_point;

		SELECT arc_id INTO v_arc FROM ve_arc WHERE ST_DWithin(the_geom, v_point,v_sensibility) LIMIT 1;

		IF v_arc IS NULL THEN
			SELECT connec_id INTO v_connec FROM ve_connec WHERE ST_DWithin(the_geom, v_point,v_sensibility) LIMIT 1;
		END IF;
	END IF;

	-- TODO: in python code we need to call manage_temporary function to drop tables when user close the dialog.
	-- TODO: if new mincut is onPlanning and user close the dialog with the icon X, we need to delete the mincut from the om_mincut table.
	-- TODO: new apply button to save data on om_mincut table.


	IF v_action = 'mincutNetwork' THEN
	-- create mincut


		-- Delete temporary tables
		-- =======================
		v_data := '{"data":{"action":"DROP", "fct_name":"MINCUT"}}';
		SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

		-- Create temporary tables
		-- =======================
		v_data := '{"data":{"action":"CREATE", "fct_name":"MINCUT", "use_psector":"'|| v_usepsectors ||'"}}';
		SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

		IF v_response->>'status' <> 'Accepted' THEN
			RETURN v_response;
		END IF;

		-- the logic save the data on om_mincut table with status onPlanning.
		IF v_device = 5 and v_mincut IS NULL THEN
			IF v_arc IS NULL AND v_connec IS NULL THEN
				RETURN ('{"status":"Failed", "message":{"level":2, "text":"No arc or connec found."}, "version":"'||v_version||'","body":{"form":{},"data":{ "info":null,"geometry":null, "mincutDetails":null}}}')::json;
			END IF;

			SELECT setval('om_mincut_seq', COALESCE((SELECT max(id::integer)+1 FROM om_mincut), 1), true) INTO v_mincut;
			INSERT INTO om_mincut (id, mincut_state) VALUES (v_mincut, 4);

			-- Set default values
			FOR v_default_key, v_default_value IN SELECT * FROM jsonb_each_text(v_vdefault::jsonb) LOOP
				EXECUTE 'UPDATE om_mincut SET '||v_default_key||' = '||v_default_value||' WHERE id = '||v_mincut||';';
			END LOOP;
		END IF;

		--check if arc exists in database or look for a new arc_id in the same location
		IF (SELECT arc_id FROM arc WHERE arc_id::integer=v_arc) IS NULL THEN
			SELECT arc_id::integer INTO v_arc 
			FROM arc a
			JOIN om_mincut om ON om.anl_feature_id::integer = a.arc_id
			WHERE ST_DWithin(a.the_geom, om.anl_the_geom,0.1) 
			AND state=1;

			IF v_arc IS NULL AND v_usepsectors THEN
				SELECT arc_id::integer INTO v_arc 
				FROM arc a
				JOIN om_mincut om ON om.anl_feature_id::integer = a.arc_id
				WHERE ST_DWithin(a.the_geom, om.anl_the_geom,0.1) 
				AND state=2;
			END IF;
		END IF;


		IF v_mincut_version = '6.1' THEN
			v_node_id := (SELECT minsector_id FROM v_temp_arc WHERE arc_id = v_arc);
		ELSE 
			v_node_id := (SELECT node_1 FROM v_temp_arc WHERE arc_id = v_arc);
		END IF;

		-- Initialize process
		-- =======================
		v_data := '{"data":{"mapzone_name":"MINCUT", "node_id":"'|| v_node_id ||'", "mincut_version":"'|| v_mincut_version ||'"}}';
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

		-- prepare mincut 
		UPDATE temp_pgr_arc 
		SET mapzone_id = 0 
		WHERE mapzone_id <> 0;

		UPDATE temp_pgr_node 
		SET mapzone_id = 0 
		WHERE mapzone_id <> 0;

		-- mincut
		SELECT count(*)::int INTO v_pgr_distance 
		FROM temp_pgr_arc;
		
		UPDATE temp_pgr_arc 
		SET proposed = FALSE 
		WHERE proposed = TRUE;


		IF v_node_id IS NULL THEN
			v_pgr_node_id := (SELECT pgr_node_id FROM temp_pgr_node WHERE node_id = v_node_id);
		END IF;

		-- TODO: revise if this can be passed with other format
		v_data := format('{"data":{"pgrDistance":%s, "pgrRootVids":["%s"], "ignoreCheckValvesMincut":"%s"}}',
		v_pgr_distance, array_to_string(ARRAY[v_pgr_node_id], ','), v_ignore_check_valves);

		RAISE NOTICE 'v_data: %', v_data;
		v_response := gw_fct_mincut_core(v_data);

		-- TODO: insert results on om_mincut tables
		INSERT INTO om_mincut_arc (result_id, arc_id, the_geom)
		SELECT v_mincut, vta.arc_id, vta.the_geom 
		FROM temp_pgr_arc tpa
		JOIN v_temp_arc vta ON vta.arc_id = tpa.arc_id
		WHERE mapzone_id <> 0;







	ELSIF v_action = 'mincutRefresh' THEN

		-- Create temporary tables 
		-- =======================
		v_data := '{"data":{"action":"CREATE", "fct_name":"MINCUT", "use_psector":"'|| v_usepsectors ||'"}}';
		SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

		IF v_response->>'status' <> 'Accepted' THEN
			RETURN v_response;
		END IF;
		

	ELSIF v_action = 'mincutValveUnaccess' THEN
	-- change the valve status
	ELSIF v_action IN ('mincutAccept', 'endMincut') THEN
	-- accept mincut

		-- TODO: when usePsectors is true, we need to delete the minsectors from the om_mincut table.
		-- TODO: when user accepts mincut the state of the mincut change from onPlanning to Planned.

	ELSIF v_action = 'mincutCancel' THEN
		v_message = '{"text": "Mincut to cancel not found.", "level": 2}';
		IF (SELECT id FROM om_mincut WHERE id = v_mincut) IS NOT NULL THEN
			if (select mincut_state from om_mincut where id = v_mincut) = 4 then
				DELETE FROM om_mincut WHERE id = v_mincut;
			else
				update om_mincut set mincut_state = 3 where id = v_mincut;
			end if;
			v_message = '{"text": "Mincut cancelled.", "level": 1}';
		END IF;

	ELSIF v_action = 'mincutDelete' THEN
		v_message = '{"text": "Mincut to delete not found.", "level": 2}';
		IF (SELECT id FROM om_mincut WHERE id = v_mincut) IS NOT NULL THEN
			DELETE FROM om_mincut WHERE id = v_mincut;
			v_message = '{"text": "Mincut deleted.", "level": 1}';
		END IF;
	END IF;


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
	      "data": {
	        "mincutId": ' || v_mincut ||','||
			  '"mincutInit":'||v_result_init||','||
			  '"valve":'||v_result_valve||','||
			  '"mincutNode":'||v_result_node||','||
			  '"mincutConnec":'||v_result_connec||','||
			  '"mincutArc":'||v_result_arc||','||
			  '"tiled":'||v_tiled|| '
	      }
	    }
	}');

	RAISE NOTICE 'v_message: %', v_message;
	RAISE NOTICE 'v_version: %', v_version;
	RAISE NOTICE 'v_mincut: %', v_mincut;
	RAISE NOTICE 'v_result_init: %', v_result_init;
	RAISE NOTICE 'v_result_valve: %', v_result_valve;
	RAISE NOTICE 'v_result_node: %', v_result_node;
	RAISE NOTICE 'v_result_connec: %', v_result_connec;
	RAISE NOTICE 'v_result_arc: %', v_result_arc;
	RAISE NOTICE 'v_tiled: %', v_tiled;
	RAISE NOTICE 'v_response: %', v_response;

	return v_response::json;

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;