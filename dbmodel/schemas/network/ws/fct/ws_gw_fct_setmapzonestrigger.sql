/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3230

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setmapzonestrigger(p_data json)
  RETURNS json AS
$BODY$

/* example


-- MAPZONES

 SELECT SCHEMA_NAME.gw_fct_setmapzonestrigger($${"client":{"device":4, "lang":"ca_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{"id":"1088",
 "tableName":"ve_node_shutoff_valve", "featureType":"node" }, "data":{"filterFields":{}, "pageInfo":{}, "fields":{"closed": "false"}}}$$);
update SCHEMA_NAME.man_valve set closed = false where node_id = '1088'


*/

DECLARE
v_projecttype text;
v_featuretype text;
v_tablename text;
v_id text;
v_querytext text;
v_error_context text;
v_fid integer = 512;

-- variables only used on the automatic trigger mapzone
v_closedstatus boolean;
v_automaticmapzonetrigger boolean;
v_type text;
v_mapzone text;
v_mapzone_array json;
v_count integer;
v_count_2 integer;
v_mapzone_id text;
v_mapzone_id_2 integer;
v_nodeheader text;
v_message json;
v_geomparamupdate integer;
v_useplanpsector boolean;
v_updatemapzone float;
v_value integer;
v_geometry text;
v_exploitation text;
v_mapzones text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get project type
	SELECT project_type INTO v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get input parameters:
	v_featuretype := (p_data ->> 'feature')::json->> 'featureType';
	v_tablename := (p_data ->> 'feature')::json->> 'tableName';
	v_id := (p_data ->> 'feature')::json->> 'id';
	v_closedstatus := json_extract_path_text (p_data,'data','fields', 'closed')::text;

	SELECT type INTO v_type FROM cat_feature JOIN cat_feature_node USING (id) WHERE child_layer = v_tablename AND 'MINSECTOR' = ANY(graph_delimiter);

	-- getting exploitation
	v_exploitation = (SELECT array_agg(expl_id) FROM selector_expl where cur_user = current_user);
	v_exploitation = replace(replace (v_exploitation,'{',''), '}','');

	v_count = (SELECT COUNT(*) FROM (SELECT node_1 FROM ve_arc WHERE node_1 = v_id UNION ALL SELECT node_2 FROM ve_arc WHERE node_2 = v_id)a);

	IF v_type = 'VALVE' AND v_closedstatus IS NOT NULL AND v_count = 2 THEN

		-- create the log
		DROP TABLE IF EXISTS temp_audit_check_data_duplicate;
		CREATE TEMP TABLE temp_audit_check_data_duplicate (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);
		INSERT INTO temp_audit_check_data_duplicate (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 0, 'DETAILS');
		INSERT INTO temp_audit_check_data_duplicate (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 0, '----------');

		-- getting system variable
		v_automaticmapzonetrigger = (SELECT value::json->>'status' FROM config_param_system WHERE parameter = 'utils_graphanalytics_automatic_trigger');

		IF v_automaticmapzonetrigger THEN

			-- getting variables for trigger automatic mapzones
			v_geomparamupdate = (SELECT (value::json->>'parameters')::json->>'geomParamUpdate' FROM config_param_system WHERE parameter = 'utils_graphanalytics_automatic_trigger');
			v_useplanpsector = (SELECT (value::json->>'parameters')::json->>'usePlanPsector' FROM config_param_system WHERE parameter = 'utils_graphanalytics_automatic_trigger');
			v_updatemapzone = (SELECT (value::json->>'parameters')::json->>'updateMapZone' FROM config_param_system WHERE parameter = 'utils_graphanalytics_automatic_trigger');
			v_mapzone_array = (SELECT (value::json->>'mapzone') FROM config_param_system WHERE parameter = 'utils_graphanalytics_automatic_trigger');
			v_mapzones = replace((SELECT (value::json->>'mapzone') FROM config_param_system WHERE parameter = 'utils_graphanalytics_automatic_trigger'), '"','');

			-- FOR v_mapzone
			FOR v_mapzone IN SELECT json_array_elements_text(v_mapzone_array)
			LOOP
				-- getting current mapzone
				EXECUTE ' SELECT '||lower(v_mapzone)||'_id FROM node WHERE node_id = '||quote_literal(v_id) INTO v_value;

				-- looking for mapzones number (including 0 on both sides of valve)
				EXECUTE 'SELECT count(*) FROM (SELECT DISTINCT '||lower(v_mapzone)||'_id FROM node WHERE node_id IN 
				(SELECT node_1 as node_id FROM arc WHERE node_2 = '||v_id||'::text AND state = 1 UNION SELECT node_2 FROM arc WHERE node_1 = '||v_id||'::text AND state = 1)) a '
				INTO v_count;


				IF v_closedstatus IS TRUE OR (v_closedstatus IS FALSE AND v_count = 2) THEN

					-- getting mapzone id (indistinct side of valve)
					EXECUTE 'SELECT array_agg('||lower(v_mapzone)||'_id) FROM (SELECT DISTINCT ('||lower(v_mapzone)||'_id) FROM arc WHERE arc_id IN 
					(SELECT arc_id FROM arc WHERE node_2 = '||v_id||'::text AND state = 1 UNION SELECT arc_id FROM arc WHERE node_1 = '||v_id||'::text) 
					AND '||lower(v_mapzone)||'_id NOT IN (''0'', ''-1'') AND state = 1)b'
					INTO v_mapzone_id;

					-- looking for mapzones number (excluding 0 on both sides of valve)
					EXECUTE 'SELECT count(*) FROM (SELECT DISTINCT '||lower(v_mapzone)||'_id FROM node WHERE node_id IN 
					(SELECT node_1 as node_id FROM arc WHERE node_2 = '||v_id||'::text AND state = 1 UNION SELECT node_2 FROM arc WHERE node_1 = '||v_id||'::text AND state = 1) AND '||lower(v_mapzone)||'_id NOT IN (''0'', ''-1'')) a '
					INTO v_count_2;

					-- execute code
					IF v_mapzone_id IS NOT NULL THEN

						v_mapzone_id = REPLACE(REPLACE (v_mapzone_id,'{','[') ,'}',']');


						v_querytext = '{"data":{"parameters":{"graphClass":"'||v_mapzone||'", "exploitation":"'||v_exploitation||'", "floodOnlyMapzone":"'||v_mapzone_id||'", "checkData":false, "commitChanges":"true", 
						"updateMapZone":'||v_updatemapzone||', "geomParamUpdate":'||v_geomparamupdate||',"debug":false, "usePlanPsector":'||v_useplanpsector||', "forceOpen":[], "forceClosed":[]}}}';
					ELSE
						v_querytext = '{"data":{"parameters":{"graphClass":"'||v_mapzone||'", "exploitation":"'||v_exploitation||'", "checkData":false, "commitChanges":"true", 
						"updateMapZone":'||v_updatemapzone||', "geomParamUpdate":'||v_geomparamupdate||',"debug":false, "usePlanPsector":'||v_useplanpsector||', "forceOpen":[], "forceClosed":[]}}}';
					END IF;

					PERFORM gw_fct_graphanalytics_mapzones(v_querytext::json);

					IF v_closedstatus IS FALSE THEN

						IF v_count= 1 THEN
							INSERT INTO temp_audit_check_data_duplicate (fid, criticity, error_message)
							VALUES (v_fid, 0, concat(v_mapzone, ' Any ',v_mapzone,' have been updated. Both sides of valve have the same ',v_mapzone));

						ELSIF v_count =  2 THEN

							IF v_count_2 = 2 THEN
								INSERT INTO temp_audit_check_data_duplicate (fid, criticity, error_message)
								VALUES (v_fid, 2, concat (' There is a CONFLICT against two ', v_mapzone, 'S. Check your valve status!'));

							ELSIF  v_count_2 = 1 THEN
								INSERT INTO temp_audit_check_data_duplicate (fid, criticity, error_message)
								VALUES (v_fid, 1, concat (' Disconnected features have been atached to current ',v_mapzone));

							END IF;
						ELSE
							-- return message
							INSERT INTO temp_audit_check_data_duplicate (fid, criticity, error_message)
							VALUES (v_fid, 0, concat(v_mapzone, ' Any ',v_mapzone,' have been updated. Both sides of valve has not ',v_mapzone));
						END IF;
					END IF;
				ELSE
					INSERT INTO temp_audit_check_data_duplicate (fid, criticity, error_message)
					VALUES (v_fid, 0, concat (v_mapzone, '''S: Any mapzone have been updated.\n'));
				END IF;
			END LOOP;

			-- check for message
			IF v_closedstatus IS TRUE THEN
				v_message = '{"status": "Accepted", "level": 1, "text": "Valve status have been succesfully closed, automatic trigger for mapzones is enabled and therefore some MAPZONES MAY HAVE CHANGED"}';

			ELSIF (SELECT count(*) FROM temp_audit_check_data_duplicate WHERE criticity > 0) > 0 THEN

				-- detailed log need to be created
				v_message = concat('{"status": "Accepted", "level": 1, "text": "Valve status have been succesfully updated, automatic trigger for mapzones is enabled and some MAPZONES HAVE CHANGED: ',
						replace(replace(replace(replace((SELECT (array_agg(error_message))::text FROM temp_audit_check_data_duplicate WHERE criticity > 0),'{',''),'}',''),'"',''),',',''), '"}');

			ELSE
				v_message = '{"status": "Accepted", "level": 0, "text": "Valve status have been succesfully updated, automatic trigger for mapzones is enabled, but any mapzone have been changed"}';

			END IF;
		ELSE
			-- return message
			v_message = '{"status": "Accepted", "level": 0, "text": "Valve status have been succesfully updated. Nothing to do because automatic trigger is not enabled to recalculate DYNAMIC MAPZONES"}';
		END IF;
	ELSE
		v_message = '{"status": "Accepted", "level": 0, "text": "Nothing to do because it is not a valid valve. Only those valves with cat_feature_node.graph_delimiter = MINSECTOR are valid"}';
	END IF;

	-- Return
	RETURN (v_message::json);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
