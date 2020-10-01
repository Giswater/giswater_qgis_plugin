/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2610

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_setfields(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setfields(p_data json)
  RETURNS json AS
$BODY$

/* example

-- FEATURE
SELECT SCHEMA_NAME.gw_fct_setfields($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},
"feature":{"featureType":"node", "tableName":"v_edit_man_junction", "id":"1251521"},
"data":{"fields":{"macrosector_id": "1", "sector_id": "2", 
"undelete": "False", "inventory": "False", "epa_type": "PUMP", "state": "1", "arc_id": "113854", "publish": "False", "verified": "TO REVIEW",
"expl_id": "1", "builtdate": "2018/11/29", "muni_id": "2", "workcat_id": "22", "buildercat_id": "builder1", "enddate": "2018/11/29", 
"soilcat_id": "soil1", "ownercat_id": "owner1", "workcat_id_end": "22"}}}$$)

-- VISIT
SELECT SCHEMA_NAME.gw_fct_setfields('
 {"client":{"device":4, "infoType":1, "lang":"ES"},
 "feature":{"featureType":"arc", "tableName":"ve_visit_multievent_x_arc", "id":1135}, 
 "data":{"fields":{"class_id":6, "arc_id":"2001", "visitcat_id":1, "ext_code":"testcode", "sediments_arc":1000, "desperfectes_arc":1, "neteja_arc":3},
 "deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}')

-- MAPZONES
SELECT SCHEMA_NAME.gw_fct_setfields($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},
"feature":{"featureType":"node", "tableName":"ve_node_shutoff_valve", "id":"1110"},"data":{"fields":{"closed":"TRUE"}}}$$)
*/

DECLARE

v_device integer;
v_infotype integer;
v_tablename text;
v_id  character varying;
v_fields json;
v_columntype character varying;
v_querytext varchar;
v_idname varchar;
column_type_id character varying;
v_version json;
v_text text[];
text text;
i integer=1;
n integer=1;
v_field text;
v_value text;
v_return text;
v_schemaname text;
v_featuretype text;
v_jsonfield json;
v_fieldsreload text;
v_columnfromid json;

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
v_projecttype text;
v_oppositenode text;


BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

        -- get project type
        v_projecttype = (SELECT project_type FROM sys_version LIMIT 1);

	-- fix diferent ways to say null on client
	p_data = REPLACE (p_data::text, '"NULL"', 'null');
	p_data = REPLACE (p_data::text, '"null"', 'null');
	p_data = REPLACE (p_data::text, '""', 'null');
	p_data = REPLACE (p_data::text, '''''', 'null');
      
	-- Get input parameters:
	v_device := (p_data ->> 'client')::json->> 'device';
	v_infotype := (p_data ->> 'client')::json->> 'infoType';
	v_featuretype := (p_data ->> 'feature')::json->> 'featureType';
	v_tablename := (p_data ->> 'feature')::json->> 'tableName';
	v_id := (p_data ->> 'feature')::json->> 'id';
	v_fields := ((p_data ->> 'data')::json->> 'fields')::json;
	v_fieldsreload := (p_data ->> 'data')::json->> 'reload';
	
	select array_agg(row_to_json(a)) into v_text from json_each(v_fields)a;

	--  Get id column, for tables is the key column
	EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
        INTO v_idname
        USING v_tablename;
        
	-- For views it suposse pk is the first column
	IF v_idname ISNULL THEN
		EXECUTE '
		SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
		AND t.relname = $1 
		AND s.nspname = $2
		ORDER BY a.attnum LIMIT 1'
		INTO v_idname
		USING v_tablename, v_schemaname;
	END IF;
 
	--   Get id column type
	EXECUTE 'SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) FROM pg_attribute a
	    JOIN pg_class t on a.attrelid = t.oid
	    JOIN pg_namespace s on t.relnamespace = s.oid
	    WHERE a.attnum > 0 
	    AND NOT a.attisdropped
	    AND a.attname = $3
	    AND t.relname = $2 
	    AND s.nspname = $1
	    ORDER BY a.attnum'
            USING v_schemaname, v_tablename, v_idname
            INTO column_type_id;

	IF v_text is not NULL THEN
		-- query text, step1
		v_querytext := 'UPDATE ' || quote_ident(v_tablename) ||' SET ';
	
		-- query text, step2
		FOREACH text IN ARRAY v_text 
		LOOP
			SELECT v_text [i] into v_jsonfield;
			v_field:= (SELECT (v_jsonfield ->> 'key')) ;
			v_value := (SELECT (v_jsonfield ->> 'value')) ;

			-- getting closed status if exists to work with grafanalytics functions in case of valves
			IF v_field = 'closed' THEN
				v_closedstatus = v_value;
			END IF;
			
			-- Get column type
			EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(v_tablename) || ' AND column_name = $2'
				USING v_schemaname, v_field
				INTO v_columntype;

			-- control column_type
			IF v_columntype IS NULL THEN
				v_columntype='text';
			END IF;
				
			-- control geometry fields
			IF v_field ='the_geom' OR v_field ='geom' THEN 
				v_columntype='geometry';
			END IF;
			--IF v_value !='null' OR v_value !='NULL' THEN 
		
				IF v_field='state' THEN
					PERFORM gw_fct_state_control(v_featuretype, v_id, v_value::integer, 'UPDATE');
				END IF;
				
				IF v_field in ('geom', 'the_geom') THEN			
					v_value := (SELECT ST_SetSRID((v_value)::geometry, SRID_VALUE));				
				END IF;
				
				--building the query text
				IF n=1 THEN
					v_querytext := concat (v_querytext, quote_ident(v_field) , ' = CAST(' , quote_nullable(v_value) , ' AS ' , v_columntype , ')');
				ELSIF i>1 THEN
					v_querytext := concat (v_querytext, ' , ',  quote_ident(v_field) , ' = CAST(' , quote_nullable(v_value) , ' AS ' , v_columntype , ')');
				END IF;
				n=n+1;			
			--END IF;
			i=i+1;

		END LOOP;

		-- query text, final step
		v_querytext := v_querytext || ' WHERE ' || quote_ident(v_idname) || ' = CAST(' || quote_literal(v_id) || ' AS ' || column_type_id || ')';	

		raise notice 'v_querytext %', v_querytext;

		-- execute query text
		EXECUTE v_querytext;
		IF v_fieldsreload IS NOT NULL THEN
			EXECUTE 'SELECT gw_fct_getcolumnsfromid($${
				"client":{"device":4, "infoType":1, "lang":"ES"},
				"form":{},
				"feature":{"tableName":"'|| v_tablename ||'", "id":"'|| v_id ||'", "fieldsReload":"'|| v_fieldsreload ||'", "parentField":"'||json_object_keys(v_fields)||'"},
				"data":{}}$$)' INTO v_columnfromid;

			raise notice 'v_columnfromid %', v_columnfromid;
		END IF;
	END IF;

	v_message = '{"level": 3, "text": "Feature have been succesfully updated."}';

	-- trigger automatic mapzones
	IF v_projecttype = 'WS' AND TG_OP = 'UPDATE' THEN
	
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
						IF v_nodeheader IS NOT NULL THEN
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
	END IF;

	-- Control NULL's
	v_version := COALESCE(v_version, '[]');
	v_columnfromid := COALESCE(v_columnfromid, '{}');   

	-- Return
	RETURN ('{"status":"Accepted", "message":'||v_message||', "version":' || v_version ||
	      ',"body":{"data":{"fields":' || v_columnfromid || '}'||
	      '}'||'}')::json; 

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN ('{"status":"Failed","message":{"level":2, "text":' || to_json(SQLERRM) || '}, "apiVersion":'|| v_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;