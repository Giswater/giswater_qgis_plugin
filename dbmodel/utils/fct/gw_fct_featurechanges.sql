/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3374

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_featurechanges(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE
-- Individual feature types
SELECT SCHEMA_NAME.gw_fct_featurechanges('{"client":{"device":5, "epsg":SRID_VALUE}, "feature":{"feature_type": "NODE"}, "data": {"action":"INSERT", "lastFeeding":"2024-11-11"}}');
SELECT SCHEMA_NAME.gw_fct_featurechanges('{"client":{"device":5, "epsg":SRID_VALUE}, "feature":{"feature_type": "ARC"}, "data": {"action":"INSERT", "lastFeeding":"2024-11-11"}}');
SELECT SCHEMA_NAME.gw_fct_featurechanges('{"client":{"device":5, "epsg":SRID_VALUE}, "feature":{"feature_type": "CONNEC"}, "data": {"action":"INSERT", "lastFeeding":"2024-11-11"}}');
SELECT SCHEMA_NAME.gw_fct_featurechanges('{"client":{"device":5, "epsg":SRID_VALUE}, "feature":{"feature_type": "GULLY"}, "data": {"action":"INSERT", "lastFeeding":"2024-11-11"}}');
-- All features combined
SELECT SCHEMA_NAME.gw_fct_featurechanges('{"client":{"device":5, "epsg":SRID_VALUE}, "feature":{"feature_type": "FEATURE"}, "data": {"action":"INSERT", "lastFeeding":"2024-11-11"}}');
-- Elements
SELECT SCHEMA_NAME.gw_fct_featurechanges('{"client":{"device":5, "epsg":SRID_VALUE}, "feature":{"feature_type": "ELEMENT"}, "data": {"action":"INSERT", "lastFeeding":"2024-11-11"}}');
-- Update examples
SELECT SCHEMA_NAME.gw_fct_featurechanges('{"client":{"device":5, "epsg":SRID_VALUE}, "feature":{"feature_type": "NODE"}, "data": {"action":"UPDATE", "lastFeeding":"2024-11-11"}}');
SELECT SCHEMA_NAME.gw_fct_featurechanges('{"client":{"device":5, "epsg":SRID_VALUE}, "feature":{"feature_type": "FEATURE"}, "data": {"action":"UPDATE", "lastFeeding":"2024-11-11"}}');
SELECT SCHEMA_NAME.gw_fct_featurechanges('{"client":{"device":5, "epsg":SRID_VALUE}, "feature":{"feature_type": "ELEMENT"}, "data": {"action":"UPDATE", "lastFeeding":"2024-11-11"}}');
**/

DECLARE

v_version text;
v_project_type text;
v_featuretype text;
v_action text;
v_lastfeeding date;
v_fields json;
v_fields_array jsonb;
v_query text;
v_feature_list text[];
v_feat text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting parameters
	v_featuretype = (p_data->>'feature')::json->>'feature_type';
	v_action = (p_data->>'data')::json->>'action';
	v_lastfeeding = (p_data->>'data')::json->>'lastFeeding';

	-- Determine which features to process
	IF v_featuretype = 'FEATURE' THEN
		IF v_project_type = 'UD' THEN
			v_feature_list := ARRAY['node', 'arc', 'connec', 'gully'];
		ELSE
			v_feature_list := ARRAY['node', 'arc', 'connec'];
		END IF;
	ELSIF v_featuretype IN ('NODE', 'ARC', 'CONNEC') THEN
		v_feature_list := ARRAY[lower(v_featuretype)];
	ELSIF v_featuretype = 'GULLY' THEN
		IF v_project_type = 'UD' THEN
			v_feature_list := ARRAY['gully'];
		ELSE
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"message":"4140", "function":"3374","parameters":{"feature_type":"GULLY not available in '||v_project_type||' project"}}}$$);';
		END IF;
	ELSIF v_featuretype = 'ELEMENT' THEN
		-- Handle ELEMENT separately
		v_fields_array := '[]'::jsonb;

		IF v_action = 'INSERT' THEN
			-- Elements from nodes
			v_query := 'SELECT json_agg(row_to_json(a)) FROM (%s) a';
			EXECUTE format(v_query, 'SELECT element_id as "elementId", elementcat_id as "featureClass", ' ||
				'node_id as "nodeId", serial_number as "serialNumber", brand_id as brand, ' ||
				'model_id as model, descript as descript, comment as "aresepId" ' ||
				'FROM v_element_x_node WHERE updated_at >= '''||v_lastfeeding||'''')
			INTO v_fields;
			IF v_fields IS NOT NULL THEN
				v_fields_array := v_fields_array || v_fields::jsonb;
			END IF;

			-- Elements from connecs
			EXECUTE format(v_query, 'SELECT element_id as "elementId", elementcat_id as "featureClass", ' ||
				'connec_id as "connecId", serial_number as "serialNumber", brand_id as brand, ' ||
				'model_id as model, descript as descript, comment as "aresepId" ' ||
				'FROM v_element_x_connec WHERE updated_at >= '''||v_lastfeeding||'''')
			INTO v_fields;
			IF v_fields IS NOT NULL THEN
				v_fields_array := v_fields_array || v_fields::jsonb;
			END IF;

		ELSIF v_action = 'UPDATE' THEN
			-- Elements from nodes
			v_query := 'SELECT json_agg(row_to_json(a)) FROM (%s) a';
			EXECUTE format(v_query, 'SELECT element_id as "elementId", elementcat_id as "featureClass", ' ||
				'node_id as "nodeId", serial_number as "serialNumber", brand_id as brand, ' ||
				'model_id as model, descript as descript, comment as "aresepId" ' ||
				'FROM v_element_x_node WHERE updated_at >= '''||v_lastfeeding||''' AND element_id IN ' ||
				'(SELECT (newdata->>''node_id'')::int FROM audit.log WHERE EXISTS ' ||
				'(SELECT 1 FROM unnest(array[''macrosector_id'', ''state'', ''nodecat_id'', ''asset_id'']) AS key ' ||
				'WHERE olddata->key IS NOT NULL AND newdata->key IS NOT NULL ' ||
				'AND table_name ILIKE ''%_node%'' AND schema = ''SCHEMA_NAME''))')
			INTO v_fields;
			IF v_fields IS NOT NULL THEN
				v_fields_array := v_fields_array || v_fields::jsonb;
			END IF;

			-- Elements from connecs
			EXECUTE format(v_query, 'SELECT element_id as "elementId", elementcat_id as "featureClass", ' ||
				'connec_id as "connecId", serial_number as "serialNumber", brand_id as brand, ' ||
				'model_id as model, descript as descript, comment as "aresepId" ' ||
				'FROM v_element_x_connec WHERE updated_at >= '''||v_lastfeeding||''' AND element_id IN ' ||
				'(SELECT (newdata->>''connec_id'')::int FROM audit.log WHERE EXISTS ' ||
				'(SELECT 1 FROM unnest(array[''macrosector_id'', ''state'', ''conneccat_id'', ''asset_id'']) AS key ' ||
				'WHERE olddata->key IS NOT NULL AND newdata->key IS NOT NULL ' ||
				'AND table_name ILIKE ''%_connec%'' AND schema = ''SCHEMA_NAME''))')
			INTO v_fields;
			IF v_fields IS NOT NULL THEN
				v_fields_array := v_fields_array || v_fields::jsonb;
			END IF;
		END IF;
	ELSE
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"message":"4140", "function":"3374","parameters":{"feature_type":"'||v_featuretype::text||'"}}}$$);';
	END IF;

	-- Process features if not ELEMENT
	IF v_featuretype != 'ELEMENT' AND v_feature_list IS NOT NULL THEN
		v_fields_array := '[]'::jsonb;
		FOREACH v_feat IN ARRAY v_feature_list
		LOOP
			-- Build query based on action
			IF v_action = 'INSERT' THEN
				v_query := concat(
					'SELECT ', v_feat, '_id as "', v_feat, 'Id", ',
					v_feat, 'cat_id as "featureClass", ',
					'macrosector_id as "macroSector", ',
					'comment as "aresepId", ',
					'asset_id as "assetId", ',
					'state, ',
					'uuid, ',
					'expl_id as "exploitation"'
				);

				-- Add feature-specific fields
				IF v_feat = 'connec' THEN
					v_query := concat(v_query, ', customer_code as "customerCode"');
				END IF;

				v_query := concat(
					v_query,
					', created_at as "createdAt", ',
					'updated_at as "updatedAt"',
					' FROM ve_', v_feat,
					' WHERE created_at >= ''', v_lastfeeding, ''''
				);
			ELSIF v_action = 'UPDATE' THEN
				v_query := concat(
					'SELECT ', v_feat, '_id as "', v_feat, 'Id", ',
					v_feat, 'cat_id as "featureClass", ',
					'macrosector_id as "macroSector", ',
					'comment as "aresepId", ',
					'asset_id as "assetId", ',
					'state, ',
					'uuid, ',
					'expl_id as "exploitation"'
				);

				-- Add feature-specific fields
				IF v_feat = 'connec' THEN
					v_query := concat(v_query, ', customer_code as "customerCode"');
				END IF;

				v_query := concat(v_query, ', created_at as "createdAt", updated_at as "updatedAt"',
					' FROM ve_', v_feat, ' WHERE updated_at >= ''', v_lastfeeding, ''' AND ', v_feat, '_id IN ',
					'(SELECT (newdata->>''', v_feat, '_id'')::int FROM audit.log WHERE EXISTS ',
					'(SELECT 1 FROM unnest(array[''macrosector_id'', ''state'', ''', v_feat, 'cat_id'', ''asset_id'']) AS key ',
					'WHERE olddata->key IS NOT NULL AND newdata->key IS NOT NULL AND table_name ILIKE ''%_', v_feat, '%'' AND schema = ''SCHEMA_NAME''))'
				);
			END IF;

			-- Execute query for this feature type and append results
			EXECUTE format('SELECT json_agg(row_to_json(a)) FROM (%s) a', v_query)
			INTO v_fields;

			-- Append to results array (skip if no results)
			IF v_fields IS NOT NULL THEN
				v_fields_array := v_fields_array || v_fields::jsonb;
			END IF;
		END LOOP;
	END IF;

	v_fields := v_fields_array::json;

	-- Control nulls
	v_fields := COALESCE(v_fields, '[]');

	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Process done sucessfully"}, "version":"'||v_version||'"'||
			 ',"body":{"form":{}'||
			 ',"feature":{}'||
			 ',"data":{"features":'||v_fields||'}}'||'}')::json;

END;
$function$
;
