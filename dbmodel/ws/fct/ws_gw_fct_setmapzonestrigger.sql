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
v_version text;
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
v_mapzone_id integer;
v_nodeheader text;
v_message json;
v_geomparamupdate integer;
v_useplanpsector boolean;
v_updatemapzone float;
v_oppositenode text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	
	-- get project type
    SELECT project_type, giswater INTO v_projecttype, v_version FROM sys_version LIMIT 1;
	
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
			-- looking for mapzones
				EXECUTE 'SELECT count(*) FROM (SELECT DISTINCT '||lower(v_mapzone)||'_id FROM node WHERE node_id IN 
				(SELECT node_1 as node_id FROM arc WHERE node_2 = '||v_id||'::text UNION SELECT node_2 FROM arc WHERE node_1 = '||v_id||'::text)) a '
				INTO v_count;
					
				IF v_closedstatus IS TRUE OR (v_closedstatus IS FALSE AND v_count = 2) THEN

					-- count mapzones
					EXECUTE 'SELECT count(*) FROM (SELECT DISTINCT '||lower(v_mapzone)||'_id FROM node WHERE node_id IN 
					(SELECT node_1 as node_id FROM arc WHERE node_2 = '||v_id||'::text UNION SELECT node_2 FROM arc WHERE node_1 = '||v_id||'::text)) a WHERE '||lower(v_mapzone)||'_id::integer > 0 '
					INTO v_count;

					-- getting mapzone id
					EXECUTE 'SELECT ('||lower(v_mapzone)||'_id) FROM node WHERE node_id IN (SELECT node_1 as node_id FROM arc WHERE node_2 = '||v_id||'::text UNION SELECT node_2 FROM arc WHERE node_1 = '||v_id||'::text) 
					AND '||lower(v_mapzone)||'_id::integer > 0 LIMIT 1' 
					INTO v_mapzone_id;

					-- getting nodeheader id
					IF v_mapzone_id IS NOT NULL THEN
						EXECUTE 'SELECT (json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'' FROM '||lower(v_mapzone)||' WHERE '||lower(v_mapzone)||'_id = '||quote_literal(v_mapzone_id)
						INTO v_nodeheader;
					END IF;

					-- execute grafanalytics function from nodeheader				
					IF v_mapzone_id::integer > 0 THEN
						v_querytext = '{"data":{"parameters":{"grafClass":"'||v_mapzone||'", "exploitation":['||v_expl||'], "floodFromNode":"'||v_nodeheader||'", "checkData":false, "updateFeature":true, 
						"updateMapZone":'||v_updatemapzone||', "geomParamUpdate":'||v_geomparamupdate||',"debug":false, "usePlanPsector":'||v_useplanpsector||', "forceOpen":[], "forceClosed":[]}}}';
						ELSE
						v_querytext = '{"data":{"parameters":{"grafClass":"'||v_mapzone||'", "exploitation":['||v_expl||'], "checkData":false, "updateFeature":true, 
						"updateMapZone":'||v_updatemapzone||', "geomParamUpdate":'||v_geomparamupdate||',"debug":false, "usePlanPsector":'||v_useplanpsector||', "forceOpen":[], "forceClosed":[]}}}';
					END IF;
										
					PERFORM gw_fct_grafanalytics_mapzones(v_querytext::json);

					-- return message 
					IF v_closedstatus IS TRUE THEN
						v_message = '{"level": 0, "text": "DYNAMIC MAPZONES: Valve have been succesfully closed. Maybe this operation have been affected on mapzones. Take a look on map for check it"}';
					ELSIF v_closedstatus IS FALSE THEN
						IF v_count= 1 THEN
							v_message = '{"level": 0, "text": "DYNAMIC MAPZONES: Valve have been succesfully opened. If there were disconnected elements, it have been reconnected to mapzone"}';
						ELSIF v_count =  2 THEN
							v_message = '{"level": 1, "text": "DYNAMIC MAPZONES: Valve have been succesfully opened. Be carefull because there is a conflict againts two mapzones"}';
						END IF;
					END IF;

					IF v_closedstatus IS TRUE THEN
					-- looking for dry side using catching opposite node
						EXECUTE 'SELECT node_2 FROM arc WHERE node_1 = '''||v_id||''' AND '||lower(v_mapzone)||'_id::integer = 0 UNION SELECT node_1 
					    FROM arc WHERE node_2 ='''||v_id||''' AND '||lower(v_mapzone)||'_id::integer = 0 LIMIT 1'
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
					ELSIF v_closedstatus IS FALSE THEN
						IF v_count= 1 THEN
							v_message = '{"level": 0, "text": "DYNAMIC MAPZONES: Valve have been succesfully opened. If there were disconnected elements, it have been reconnected to mapzone"}';
						ELSIF v_count =  2 THEN
							v_message = '{"level": 1, "text": "DYNAMIC MAPZONES: Valve have been succesfully opened. Be carefull because there is a conflict againts two mapzones"}';
						END IF;
					END IF;
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


	-- Control NULL's
	v_version := COALESCE(v_version, '[]');

		-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":'||v_message||', "version":"' || v_version ||'","body":{"data":{}}}')::json, 3006);



	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN ('{"status":"Failed","message":{"level":2, "text":' || to_json(SQLERRM) || '}, "apiVersion":'|| v_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
