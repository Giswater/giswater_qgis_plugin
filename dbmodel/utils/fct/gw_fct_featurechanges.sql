/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3374

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_featurechanges(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_featurechanges('{"client":{"device":6, "epsg":SRID_VALUE}, "feature":{"feature_type": "FEATURE"}, "data": {"action":"INSERT", "lastFeeding":"2024-11-11"}}');
SELECT SCHEMA_NAME.gw_fct_featurechanges('{"client":{"device":6, "epsg":SRID_VALUE}, "feature":{"feature_type": "ELEMENT"}, "data": {"action":"INSERT", "lastFeeding":"2024-11-11"}}');
SELECT SCHEMA_NAME.gw_fct_featurechanges('{"client":{"device":6, "epsg":SRID_VALUE}, "feature":{"feature_type": "FEATURE"}, "data": {"action":"UPDATE", "lastFeeding":"2024-11-11"}}');
SELECT SCHEMA_NAME.gw_fct_featurechanges('{"client":{"device":6, "epsg":SRID_VALUE}, "feature":{"feature_type": "ELEMENT"}, "data": {"action":"UPDATE", "lastFeeding":"2024-11-11"}}');
**/

DECLARE

v_version text;
v_featuretype text;
v_feature text;
v_action text;
v_lastfeeding date;
v_fields json;
v_fields_array json[];
v_tablename text;
v_select_node text;
v_select_connec text;
v_select_element_node text;
v_select_element_connec text;
v_id_list_node int[];
v_id_list_connec int[];

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	SELECT giswater INTO v_version FROM sys_version order by id desc limit 1;

	-- getting parameters
	v_featuretype = (p_data->>'feature')::json->>'feature_type';
	v_action = (p_data->>'data')::json->>'action';
	v_lastfeeding = (p_data->>'data')::json->>'lastFeeding';

	CASE v_action
		WHEN 'INSERT' THEN
			-- Dynamic query construction based on the feature type
			CASE v_featuretype
			    WHEN 'FEATURE' THEN

					-- NODE
					v_feature = 'node';
			        v_select_node = 'SELECT '||v_feature||'_id as "'||lower(v_feature)||'Id", '||
			                          lower(v_feature)||'cat_id as "featureClass", macrosector_id as "macroSector", asset_id as "assetId", state FROM vu_'||v_feature|| ' WHERE lastupdate >= '''||v_lastfeeding||'''';

					-- CONNEC
					v_feature = 'connec';
					v_select_connec = 'SELECT '||v_feature||'_id as "'||lower(v_feature)||'Id", '||
			                          lower(v_feature)||'cat_id as "featureClass", macrosector_id as "macroSector", asset_id as "assetId", state FROM vu_'||v_feature|| ' WHERE lastupdate >= '''||v_lastfeeding||'''';

					-- Combine the query parts and execute it
					EXECUTE format('SELECT array_agg(row_to_json(a)) FROM (%s UNION ALL %s) a',
					               v_select_node, v_select_connec)
					INTO v_fields_array;

			    WHEN 'ELEMENT' THEN
					-- NODE
					v_feature = 'node';
			        v_select_element_node = 'SELECT element_id as "elementId", '||
			                          'elementcat_id as featureClass, node_id as "nodeId", serial_number as "serialNumber", '||
			                          'brand_id as brand, model_id as model, descript as descript FROM vu_element_x_'||v_feature|| ' WHERE lastupdate >= '''||v_lastfeeding||'''';

					-- CONNEC
					v_feature = 'connec';
			        v_select_element_connec = 'SELECT element_id as "elementId", '||
			                          'elementcat_id as featureClass, connec_id as "connecId", serial_number as "serialNumber", '||
			                          'brand_id as brand, model_id as model, descript as descript FROM vu_element_x_'||v_feature|| ' WHERE lastupdate >= '''||v_lastfeeding||'''';

					-- Combine the query parts and execute it
					EXECUTE format('SELECT array_agg(row_to_json(a)) FROM (%s UNION ALL %s) a',
					               v_select_element_node, v_select_element_connec)
					INTO v_fields_array;

			    ELSE
			        RAISE EXCEPTION 'The specified feature type is not supported: %', v_featuretype;
			END CASE;
		WHEN 'UPDATE' THEN
			CASE v_featuretype
				WHEN 'FEATURE' THEN
					-- NODE
					v_feature = 'node';
					v_select_node = 'SELECT '||v_feature||'_id as "'||lower(v_feature)||'Id", '||
				    				lower(v_feature)||'cat_id as "featureClass", macrosector_id as "macroSector", asset_id as "assetId", state FROM vu_'||v_feature|| ' WHERE lastupdate >= '''||v_lastfeeding||''' and '||v_feature||'_id IN (SELECT newdata->>''node_id'' as id FROM audit.log WHERE exists (SELECT 1 FROM unnest(array[''macrosector_id'', ''state'', ''nodecat_id'', ''asset_id'']) AS key WHERE olddata->key IS NOT NULL AND newdata->key IS NOT NULL and table_name ilike ''%_element_x_%'' AND schema = ''SCHEMA_NAME''))';
					-- CONNEC
					v_feature = 'connec';
					v_select_connec = 'SELECT '||v_feature||'_id as "'||lower(v_feature)||'Id", '||
		                   lower(v_feature)||'cat_id as "featureClass", macrosector_id as "macroSector", asset_id as "assetId", state FROM vu_'||v_feature|| ' WHERE lastupdate >= '''||v_lastfeeding||''' and '||v_feature||'_id IN (SELECT newdata->>''connec_id'' as id FROM audit.log WHERE exists (SELECT 1 FROM unnest(array[''macrosector_id'', ''state'', ''nodecat_id'', ''asset_id'']) AS key WHERE olddata->key IS NOT NULL AND newdata->key IS NOT NULL and table_name ilike ''%_element_x_%'' AND schema = ''SCHEMA_NAME''))';

					-- Combine the query parts and execute it
					EXECUTE format('SELECT array_agg(row_to_json(a)) FROM (%s UNION ALL %s) a',
					               v_select_node, v_select_connec)
					INTO v_fields_array;
				WHEN 'ELEMENT' THEN
					-- NODE
					v_feature = 'node';
			        v_select_element_node = 'SELECT element_id as "elementId", '||
			                          'elementcat_id as featureClass, node_id as "nodeId", serial_number as "serialNumber", '||
			                          'brand_id as brand, model_id as model, descript as descript FROM vu_element_x_'||v_feature|| ' WHERE lastupdate >= '''||v_lastfeeding||'''and element_id IN (SELECT newdata->>''node_id'' as id FROM audit.log WHERE exists (SELECT 1 FROM unnest(array[''macrosector_id'', ''state'', ''nodecat_id'', ''asset_id'']) AS key WHERE olddata->key IS NOT NULL AND newdata->key IS NOT NULL and table_name ilike ''%_'||v_feature||'%'' AND schema = ''SCHEMA_NAME''))';

					-- CONNEC
					v_feature = 'connec';
			        v_select_element_connec = 'SELECT element_id as "elementId", '||
			                          'elementcat_id as featureClass, connec_id as "connecId", serial_number as "serialNumber", '||
			                          'brand_id as brand, model_id as model, descript as descript FROM vu_element_x_'||v_feature|| ' WHERE lastupdate >= '''||v_lastfeeding||'''and element_id IN (SELECT newdata->>''connec_id'' as id FROM audit.log WHERE exists (SELECT 1 FROM unnest(array[''macrosector_id'', ''state'', ''nodecat_id'', ''asset_id'']) AS key WHERE olddata->key IS NOT NULL AND newdata->key IS NOT NULL and table_name ilike ''%_'||v_feature||'%'' AND schema = ''SCHEMA_NAME''))';

					-- Combine the query parts and execute it
					EXECUTE format('SELECT array_agg(row_to_json(a)) FROM (%s UNION ALL %s) a',
					               v_select_element_node, v_select_element_connec)
					INTO v_fields_array;

			    ELSE
			        RAISE EXCEPTION 'The specified feature type is not supported: %', v_featuretype;
			END CASE;
	END CASE;

	v_fields := array_to_json(v_fields_array);

	-- Control nulls
	v_fields := COALESCE(v_fields, '{}');

	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Process done sucessfully"}, "version":"'||v_version||'"'||
			 ',"body":{"form":{}'||
			 ',"feature":'||v_fields||''||
			 ',"data":{}}'||'}')::json;

END;
$function$
;
