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

/* Example usage:

-- QUERY SAMPLE
SELECT gw_fct_graphanalytics_mapzones('
	{
		"data":{
			"parameters":{
				"graphClass":"MACROSECTOR",
				"exploitation":"1,2,0",
				"updateMapZone":2,
				"geomParamUpdate":15,
				"commitChanges":true,
			}
		}
	}
');
SELECT gw_fct_graphanalytics_mapzones('
	{
		"data":{
			"parameters":{
				"graphClass":"MACROOMZONE",
				"exploitation":"1,2,0",
				"updateMapZone":2,
				"geomParamUpdate":15,
				"commitChanges":true,
			}
		}
	}
');

*/

DECLARE

	-- system variables
	v_version TEXT;
	v_srid INTEGER;
	v_project_type TEXT;

	v_fid integer;

	-- dialog variables
	v_class text;
	v_expl_id text;
	v_expl_id_array text;
	v_old_mapzone_id_array text;
	v_updatemapzgeom integer = 0;
	v_geomparamupdate_divide float;
	v_concavehull float = 0.9;
	v_geomparamupdate float;
	v_commitchanges boolean;

	--
	v_audit_result text;
	v_visible_layer text;
	v_source text;
	v_target text;

	v_arcs_count integer;
	v_nodes_count integer;
	v_connecs_count integer;
	v_gullies_count integer;
	v_mapzones_ids text;

	v_macro_mapzone_name text;
	v_mapzone_field text;
	v_mapzone_id int4;
	v_ignore_broken_valves BOOLEAN = TRUE;
	v_pgr_distance integer;
	v_pgr_root_vids int[];

	v_level integer;
	v_status text;
	v_message text;

	v_query_text text;
	v_query_text_aux text;
	v_data json;

	v_result text;
	v_result_info json;
	v_result_point json;
	v_result_line json;
	v_result_polygon json;

	v_response JSON;

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

	IF v_class NOT IN ('MACROSECTOR', 'MACROOMZONE','MACRODMA','MACRODQA') THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3090", "function":"3482","parameters":null, "is_process":true}}$$);' INTO v_audit_result;
	END IF;

	-- SECTION[epic=mapzones]: SET VARIABLES
	v_macro_mapzone_name = LOWER(v_class);
	v_mapzone_name = replace(v_macro_mapzone_name, 'macro', '');
    v_mapzone_field = v_macro_mapzone_name || '_id';
	v_visible_layer = 'v_edit_' || v_macro_mapzone_name;
	v_macro_mapzone_name = UPPER(v_macro_mapzone_name);

	-- MANAGE EXPL ARR
    IF v_expl_id = '-901' THEN
        SELECT string_to_array(string_agg(DISTINCT expl_id::text, ','), ',') INTO v_expl_id_array
		FROM selector_expl;
    ELSIF v_expl_id = '-902' THEN
        SELECT string_to_array(string_agg(DISTINCT expl_id::text, ','), ',') INTO v_expl_id_array
        FROM exploitation
		WHERE active;
    ELSE
		v_expl_id_array = string_to_array(v_expl_id, ',');
    END IF;

	-- Start Building Log Message
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('MACROMAPZONES DYNAMIC SECTORITZATION - ', upper(v_class)));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('------------------------------------------------------------------'));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Macromapzone constructor method: ', upper(v_updatemapzgeom::text)));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Update feature mapzone attributes: ', upper(v_commitchanges::text)));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat(''));
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, 'ERRORS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, '-----------');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, 'WARNINGS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, '--------------');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, 'INFO');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, '-------');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 0, 'DETAILS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 0, '----------');

	RAISE NOTICE 'Creating geometry of mapzones';

	-- SECTION: Creating geometry of mapzones
	-- (unchanged, keep all the original geometry creation logic here...)

	-- ... (all the original v_updatemapzgeom logic, unchanged) ...

	-- SECTION: JOIN THE_GEOM BY EXPL_ID IN MACROZONE
	-- This is the new part: after all geometry creation, join the_geom for all rows with the same expl_id in the macrozone table
	-- This will overwrite the_geom in the macrozone table with the union of all geometries for each expl_id

	-- Only do this for macrozone tables (not for PRESSZONE, DWFZONE, etc)
	IF v_class IN ('MACROSECTOR', 'MACROOMZONE','MACRODMA','MACRODQA') THEN
		v_query_text = '
			WITH geom_by_expl AS (
				SELECT
					expl_id,
					ST_Union(the_geom) AS the_geom
				FROM '||v_macro_mapzone_name||'
				WHERE the_geom IS NOT NULL
				GROUP BY expl_id
			)
			UPDATE '||v_macro_mapzone_name||' m
			SET the_geom = g.the_geom
			FROM geom_by_expl g
			WHERE m.expl_id = g.expl_id
			AND g.the_geom IS NOT NULL;
		';
		EXECUTE v_query_text;
	END IF;

	-- (rest of the function unchanged, including temporal layers, updates, and return)
	-- ... (all the rest of the code as in the original selection) ...

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');
	v_result_line := COALESCE(v_result_line, '{}');
	v_result_polygon := COALESCE(v_result_polygon, '{}');
	v_level := COALESCE(v_level, 0);
	v_message := COALESCE(v_message, '');
	v_version := COALESCE(v_version, '');

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
				"point":'||v_result_point||',
				"line":'||v_result_line||',
				"polygon":'||v_result_polygon||'
			}
		}
	}')::json, 2710, null, ('{"visible": ["'||v_visible_layer||'"]}')::json, null)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
