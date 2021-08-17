/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3006

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setmapzonestrigger(p_data json)
  RETURNS json AS
$BODY$

/* example

	
-- MAPZONES
SELECT SCHEMA_NAME.gw_fct_setmapzonestrigger($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},
"feature":{"featureType":"node", "tableName":"ve_node_shutoff_valve", "id":"1110"},"data":{"fields":{"closed":"TRUE"}}}$$)
*/

DECLARE
v_projecttype text;
v_featuretype text;
v_tablename text;
v_id text;
v_querytext text;

-- variables only used on the automatic trigger mapzone
v_closedstatus boolean;
v_automaticmapzonetrigger boolean;
v_type text;
v_expl integer;
v_mapzone text;
v_count integer;
v_count_2 integer;
v_mapzone_id integer;
v_mapzone_id_2 integer;
v_nodeheader text;
v_message json;
v_geomparamupdate integer;
v_useplanpsector boolean;
v_updatemapzone float;
v_oppositenode text;
v_value integer;
v_geometry text;

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

	SELECT type INTO v_type FROM cat_feature JOIN cat_feature_node USING (id) WHERE child_layer = v_tablename AND graf_delimiter !='NONE';

	IF v_type = 'VALVE' AND v_closedstatus IS NOT NULL THEN

		-- getting exploitation
		v_expl = (SELECT expl_id FROM node WHERE node_id = v_id::text);
		
		-- getting system variable
		v_automaticmapzonetrigger = (SELECT value::json->>'status' FROM config_param_system WHERE parameter = 'utils_grafanalytics_automatic_trigger');		
		
		IF v_automaticmapzonetrigger THEN

			-- getting variables for trigger automatic mapzones
			v_geomparamupdate = (SELECT (value::json->>'parameters')::json->>'geomParamUpdate' FROM config_param_system WHERE parameter = 'utils_grafanalytics_automatic_trigger'); 
			v_useplanpsector = (SELECT (value::json->>'parameters')::json->>'usePlanPsector' FROM config_param_system WHERE parameter = 'utils_grafanalytics_automatic_trigger'); 
			v_updatemapzone = (SELECT (value::json->>'parameters')::json->>'updateMapZone' FROM config_param_system WHERE parameter = 'utils_grafanalytics_automatic_trigger'); 
			
			-- FOR v_mapzone
			FOR v_mapzone IN 
			SELECT upper(mapzone) FROM (SELECT 'sector' AS mapzone, value::json->>'SECTOR' as status FROM config_param_system WHERE parameter='utils_grafanalytics_status'
			UNION
			SELECT 'presszone', value::json->>'PRESSZONE' FROM config_param_system WHERE parameter='utils_grafanalytics_status'
			UNION
			SELECT 'dma', value::json->>'DMA' FROM config_param_system WHERE parameter='utils_grafanalytics_status'
			UNION
			SELECT 'dqa', value::json->>'DQA' FROM config_param_system WHERE parameter='utils_grafanalytics_status') a
			WHERE status::boolean is true
			LOOP

				-- getting current mapzone
				EXECUTE ' SELECT '||lower(v_mapzone)||'_id FROM node WHERE node_id = '||quote_literal(v_id) INTO v_value;
					
				-- looking for mapzones number (including 0 on both sides of valve)
				EXECUTE 'SELECT count(*) FROM (SELECT DISTINCT '||lower(v_mapzone)||'_id FROM node WHERE node_id IN 
				(SELECT node_1 as node_id FROM arc WHERE node_2 = '||v_id||'::text AND state = 1 UNION SELECT node_2 FROM arc WHERE node_1 = '||v_id||'::text AND state = 1)) a '
				INTO v_count;
				
				IF v_closedstatus IS TRUE OR (v_closedstatus IS FALSE AND v_count = 2) THEN

					-- getting mapzone id (indistinct side of valve) --> always with value
					EXECUTE 'SELECT ('||lower(v_mapzone)||'_id) FROM arc WHERE arc_id IN (SELECT arc_id FROM arc WHERE node_2 = '||v_id||'::text AND state = 1 UNION SELECT arc_id FROM arc WHERE node_1 = '||v_id||'::text) 
					AND '||lower(v_mapzone)||'_id::integer > 0 AND state = 1 LIMIT 1' 
					INTO v_mapzone_id;

					-- getting id of opposite mapzone (if exists)
					v_querytext = 'SELECT '||lower(v_mapzone)||'_id FROM node WHERE node_id IN 
					(SELECT node_1 as node_id FROM arc WHERE node_2 = '||v_id||'::text AND state = 1 UNION SELECT node_2 FROM arc WHERE node_1 = '||v_id||'::text AND state = 1)
					AND '||lower(v_mapzone)||'_id::text != '||quote_literal(v_mapzone_id);
					EXECUTE v_querytext INTO v_mapzone_id_2;

					-- looking for mapzones number (excluding 0 on both sides of valve)
					EXECUTE 'SELECT count(*) FROM (SELECT DISTINCT '||lower(v_mapzone)||'_id FROM node WHERE node_id IN 
					(SELECT node_1 as node_id FROM arc WHERE node_2 = '||v_id||'::text AND state = 1 UNION SELECT node_2 FROM arc WHERE node_1 = '||v_id||'::text AND state = 1) AND '||lower(v_mapzone)||'_id::integer > 0) a '
					INTO v_count_2;

					-- getting nodeheader id
					IF v_mapzone_id IS NOT NULL THEN
						EXECUTE 'SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' FROM '||lower(v_mapzone)||' WHERE '||lower(v_mapzone)||'_id = '||quote_literal(v_mapzone_id)
						INTO v_nodeheader;
					END IF;

					-- execute grafanalytics function from nodeheader				
					v_querytext = '{"data":{"parameters":{"grafClass":"'||v_mapzone||'", "floodFromNode":"'||v_nodeheader||'", "checkData":false, "updateFeature":"true", 
					"updateMapZone":'||v_updatemapzone||', "geomParamUpdate":'||v_geomparamupdate||',"debug":false, "usePlanPsector":'||v_useplanpsector||', "forceOpen":[], "forceClosed":[]}}}';

					RAISE NOTICE 'v_querytext %', v_querytext;
				
					PERFORM gw_fct_grafanalytics_mapzones(v_querytext::json);

					-- harmonize the geom of both mapzones which has conflict
					IF v_count_2 = 2 AND v_closedstatus IS FALSE THEN

						EXECUTE 'SELECT the_geom FROM (SELECT '||lower(v_mapzone)||'_id, the_geom, st_area(the_geom) a FROM '||lower(v_mapzone)||
						') q WHERE a > 0 AND '||lower(v_mapzone)||'_id::integer IN ('||v_mapzone_id||','||v_mapzone_id_2||')
						ORDER BY a DESC LIMIT 1'
						INTO v_geometry;
																	
						EXECUTE 'UPDATE '||lower(v_mapzone)||' SET the_geom = '||quote_literal(v_geometry)||'::geometry WHERE '||lower(v_mapzone)||'_id::integer  IN ('||v_mapzone_id||','||v_mapzone_id_2||')'; 
					END IF;

					-- return message 
					IF v_closedstatus IS TRUE THEN
						v_message = '{"level": 0, "text": "DYNAMIC MAPZONES: Valve have been succesfully closed. Maybe this operation have been affected on mapzones. Take a look on map for check it"}';

					ELSIF v_closedstatus IS FALSE THEN

						IF v_count= 1 THEN
							v_message = '{"level": 0, "text": "DYNAMIC MAPZONES: Valve have been succesfully opened. Nothing happens because both sides of valve has same mapzone"}';

						ELSIF v_count =  2 THEN
							IF v_count_2 = 2 THEN			
								v_message = concat('{"level": 1, "text": "DYNAMIC MAPZONES: Valve have been succesfully opened. THERE IS CONFLICT againts ',v_mapzone,' ( ',
								v_mapzone_id,' , ',v_mapzone_id_2,' )"}');											
							ELSIF  v_count_2 = 1 THEN
								v_message = '{"level": 0, "text": "DYNAMIC MAPZONES: Valve have been succesfully opened. Disconnected network have been atached to current mapzone"}';
							END IF;
						END IF;
					END IF;

					IF v_closedstatus IS TRUE THEN
					
						-- looking for dry side using catching opposite node
						EXECUTE 'SELECT node_2 FROM arc WHERE node_1 = '''||v_id||''' AND '||lower(v_mapzone)||'_id::integer = 0 AND arc.state = 1 UNION SELECT node_1 
						FROM arc WHERE node_2 ='''||v_id||''' AND '||lower(v_mapzone)||'_id::integer = 0 AND arc.state = 1 LIMIT 1'
						INTO v_oppositenode;

						IF v_oppositenode IS NOT NULL THEN
						
							-- execute grafanalytics_mapzones using dry side in order to check some header
							v_querytext = '{"data":{"parameters":{"grafClass":"'||v_mapzone||'", "exploitation":['||v_expl||'], "floodFromNode":"'||v_oppositenode||'", "checkData":false, "updateFeature":true, 
							"updateMapZone":'||v_updatemapzone||', "geomParamUpdate":'||v_geomparamupdate||',"debug":false, "usePlanPsector":'||v_useplanpsector||', "forceOpen":[], "forceClosed":[]}}}';

							PERFORM gw_fct_grafanalytics_mapzones(v_querytext::json);
										
							v_message = '{"level": 0, "text": "DYNAMIC MAPZONES: Valve have been succesfully closed. This operation have been affected mapzones scenario. Take a look on map for check it"}';
						ELSE
								
							v_message = '{"level": 0, "text": "DYNAMIC MAPZONES: Valve have been succesfully closed. Maybe this operation have been affected mapzones scenario. Take a look on map for check it"}';	
						END IF;	
										
					END IF;
					
				ELSIF v_closedstatus IS FALSE AND v_count = 1 AND v_value = 0 THEN
					v_message = '{"level": 1, "text": "DYNAMIC MAPZONES: Valve have been succesfully opened, but as both sides have undefined dma, nothing have been updated"}';
				ELSE
					-- return message 
					v_message = '{"level": 0, "text": "DYNAMIC MAPZONES: Valve have been succesfully opened and no mapzones have been updated"}';
				END IF;
				
			END LOOP;
		ELSE 
			-- return message 
			v_message = '{"level": 0, "text": "Feature succesfully updated. Valve status have been succesfully updated but automatic trigger is not enabled to recalculate DYNAMIC MAPZONES"}';			
		END IF;
	END IF;

	-- Return
	RETURN (v_message::json);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
