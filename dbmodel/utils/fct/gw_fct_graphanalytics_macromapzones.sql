/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3482

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_macromapzones(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_macromapzones(p_data json)
RETURNS json AS
$BODY$

DECLARE

	-- system variables
	v_version TEXT;
	v_srid INTEGER;
	v_project_type TEXT;

	v_fid integer = 3482;

	-- dialog variables
	v_class text;
	v_expl_id text;
	v_expl_id_array text[];
	v_updatemapzgeom integer = 0;
	v_geomparamupdate float;
	v_commitchanges boolean;

	v_visible_layer text;

	v_level integer;
	v_status text;
	v_message text;

	v_result_info json;
	v_result_polygon json;
	v_response JSON;

	-- dynamic mapping
	v_macro_table text;
	v_child_table text;
	v_macro_id_field text;
	v_data json;
	v_query_geom TEXT;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
	SELECT giswater, epsg, UPPER(project_type) INTO v_version, v_srid, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
	v_class = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'graphClass');
	v_expl_id = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_updatemapzgeom = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_geomparamupdate = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');
	v_commitchanges = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'commitChanges')::BOOLEAN;

	-- Dynamic mapping for macro/child tables and fields
	IF v_class NOT IN ('MACROSECTOR', 'MACROOMZONE','MACRODMA','MACRODQA') THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3090", "function":"3482","parameters":null, "is_process":true}}$$)';
		RETURN NULL;
	END IF;

	v_macro_table := lower(v_class);
	v_child_table := replace(v_macro_table, 'macro', '');
	v_macro_id_field := v_macro_table || '_id';
	v_visible_layer := 'v_edit_' || v_macro_table;

	-- Parse expl_id array
	IF v_expl_id = '-901' THEN
		SELECT array_agg(DISTINCT expl_id::text) INTO v_expl_id_array FROM selector_expl;
	ELSIF v_expl_id = '-902' THEN
		SELECT array_agg(DISTINCT expl_id::text) INTO v_expl_id_array FROM exploitation WHERE active;
	ELSE
		v_expl_id_array := string_to_array(v_expl_id, ',');
	END IF;

	-- Delete temporary tables
	-- =======================
	v_data := '{"data":{"action":"DROP", "fct_name":"'|| v_class ||'"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

	-- Create temporary tables
	-- =======================
	v_data := '{"data":{"action":"CREATE", "fct_name":"'|| v_class ||'"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Log
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('MACROMAPZONES DYNAMIC SECTORITZATION - ', upper(v_class)));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, '------------------------------------------------------------------');
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Macromapzone constructor method: ', upper(v_updatemapzgeom::text)));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Update feature mapzone attributes: ', upper(v_commitchanges::text)));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, 'ERRORS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, '-----------');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, 'WARNINGS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, '--------------');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, 'INFO');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, '-------');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 0, 'DETAILS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 0, '----------');

	-- prepare query
	v_query_geom = '
	SELECT '||v_macro_id_field||', st_union(the_geom) as the_geom FROM '|| v_child_table ||' 
	WHERE '||v_macro_id_field||' IS NOT NULL AND '||quote_literal(v_expl_id_array)||'::integer[] && ARRAY[expl_id]
	GROUP BY '||v_macro_id_field||'';

	IF v_commitchanges THEN -- update macromapzone table
		
		EXECUTE '
		UPDATE '|| v_macro_table ||' t SET the_geom = a.the_geom FROM ('||v_query_geom||')a 
		WHERE t.'||v_macro_id_field||' = a.'||v_macro_id_field||'
		';
	ELSE -- temporal layer
	
		EXECUTE '
		SELECT COALESCE(jsonb_agg(features.feature), ''[]''::jsonb)
		FROM (
			SELECT jsonb_build_object(
				''type'',       ''Feature'',
				''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
				''properties'', to_jsonb(row) - ''the_geom''
			) AS feature
			FROM ('||v_query_geom||') AS row
		) AS features
		' INTO v_result_polygon;
		
	END IF;



	-- return
	v_status := coalesce(v_status, 'Accepted');
	v_level := COALESCE(v_level, 0);
	v_message := COALESCE(v_message, '{}');
	v_version := COALESCE(v_version, '{}');
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_polygon := COALESCE(v_result_polygon, '{}');

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
				"info":'||v_result_info||',
				"polygon":'||v_result_polygon||'
			}
		}
	}')::json, 3482, null, ('{"visible": ["'||v_visible_layer||'"]}')::json, null)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
