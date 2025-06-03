/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
-- The code of this inundation function have been provided by Claudia Dragoste (Aigues de Manresa, S.A.)

--FUNCTION CODE: 3390

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_fluid_type(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_fluid_type(p_data json)
RETURNS json AS
$BODY$
/* FLUID TYPES
* 0: NOT INFORMED
* 1: RAINWATER
* 2: DILUTED
* 3: FECAL
* 4: UNITARY


* EXAMPLE:

-- QUERY SAMPLE
SELECT gw_fct_graphanalytics_fluid_type('
	{
		"data":{
			"parameters":{
				"graphClass":"DRAINZONE",
				"exploitation":"1,2,0",
				"updateMapZone":2,
				"geomParamUpdate":15,
				"commitChanges":true,
				"usePlanPsector":false,
				"forceOpen":"1,2,3",
				"forceClosed":"2,3,4"
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
	v_fid integer = 637;


	v_islastupdate BOOLEAN;

	-- dialog variables
	v_process_name text;
	v_expl_id text;
	v_expl_id_array text;
    v_parameters json;
	v_usepsector boolean;
	v_commitchanges boolean;

	--

	v_level integer;
	v_status text;
	v_message text;

	v_querytext text;
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
	v_process_name = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'processName')::text;
	v_expl_id = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation')::text;
	v_usepsector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePlanPsector')::boolean;
	v_commitchanges = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'commitChanges')::boolean;
	-- for extra parameters
	v_parameters = (SELECT ((p_data::json->>'data')::json->>'parameters'))::json;

	-- it's not allowed to commit changes when psectors are used
 	IF v_usepsector IS TRUE THEN
		v_commitchanges = FALSE;
	END IF;


	-- MANAGE EXPL ARR
    -- For user selected exploitations
    IF v_expl_id = '-901' THEN
        SELECT string_to_array(string_agg(DISTINCT expl_id::text, ','), ',') INTO v_expl_id_array
		FROM selector_expl;
    -- For all exploitations
    ELSIF v_expl_id = '-902' THEN
        SELECT string_to_array(string_agg(DISTINCT expl_id::text, ','), ',') INTO v_expl_id_array
        FROM exploitation
		WHERE active;
    -- For a specific exploitation/s
    ELSE
		v_expl_id_array = string_to_array(v_expl_id, ',');
    END IF;

	-- Delete temporary tables
	-- =======================
	v_data := '{"data":{"action":"DROP", "fct_name":"'|| v_process_name ||'"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

	IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Create temporary tables
	-- =======================
	v_data := '{"data":{"action":"CREATE", "fct_name":"'|| v_process_name ||'", "use_psector":"'|| v_usepsector ||'", "expl_id_array":"'|| v_expl_id_array ||'"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Start Building Log Message
	-- =======================
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('FLUID TYPE CALCULATION'));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('------------------------------------------------------------------'));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Use psectors: ', upper(v_usepsector::text)));


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

	-- Initialize process
	-- =======================
	v_data := '{"data":{"expl_id_array":"' || v_expl_id_array || '", "mapzone_name":"'|| v_process_name ||'"}}';
    SELECT gw_fct_graphanalytics_initnetwork(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;



	WITH feature_type AS (
		SELECT
			a.arc_id,
			CASE WHEN a.initoverflowpath = FALSE THEN n.fluid_type
			WHEN n.fluid_type >= 2 THEN 2
			ELSE n.fluid_type -- rainwater or Not Informed
			END AS fluid_type
		FROM temp_pgr_node n
		JOIN v_temp_arc a ON a.node_1 = n.node_id
		UNION ALL
		SELECT
			c.arc_id, c.fluid_type
		FROM v_temp_connec c
		WHERE EXISTS (
			SELECT 1
			FROM temp_pgr_arc a
			WHERE a.arc_id = c.arc_id
		)
		UNION ALL
		SELECT
			g.arc_id, g.fluid_type
		FROM v_temp_gully g
		WHERE EXISTS (
			SELECT 1
			FROM temp_pgr_arc a
			WHERE a.arc_id = g.arc_id
		)
	), arc_type AS (
		SELECT
			arc_id,
			max(fluid_type) AS fluid_type,
			count(DISTINCT fluid_type) FILTER (WHERE fluid_type >0) AS nr
		FROM feature_type
		GROUP BY arc_id
	), arc_modif AS (
		SELECT
			arc_id,
			CASE
			WHEN nr <= 1 THEN fluid_type -- 0 when fluid_type is not informed
			WHEN fluid_type IN (3,4) THEN 4
			ELSE fluid_type
			END AS fluid_type
		FROM arc_type
	)
	UPDATE temp_pgr_arc t
	SET fluid_type = a.fluid_type
	FROM arc_modif a
	WHERE a.arc_id = t.arc_id
	AND a.fluid_type <> t.fluid_type;

	WITH node_type AS (
		SELECT
			node_2 AS node_id,
			max(fluid_type) AS fluid_type,
			count(DISTINCT fluid_type) FILTER (WHERE fluid_type > 0) AS nr
		FROM temp_pgr_arc
		GROUP BY node_2
	), node_modif AS (
		SELECT
			node_id,
			CASE
			WHEN nr <= 1 THEN fluid_type -- 0 when fluid_type is not informed
			WHEN fluid_type IN (3,4) THEN 4
			ELSE fluid_type
			END AS fluid_type
		FROM node_type
	)
	UPDATE temp_pgr_node t
	SET fluid_type = n.fluid_type
	FROM node_modif n
	WHERE n.node_id = t.node_id
	AND n.fluid_type <> t.fluid_type;

	IF v_commitchanges IS TRUE THEN
		RAISE NOTICE 'Updating fluid type';
	ELSE
		RAISE NOTICE 'Fluid type not updated';
	END IF;


	-- Control NULL values
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');
	v_result_line := COALESCE(v_result_line, '{}');
	v_result_polygon := COALESCE(v_result_polygon, '{}');
	v_level := COALESCE(v_level, 0);
	v_message := COALESCE(v_message, '');
	v_version := COALESCE(v_version, '');

	-- Return JSON
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
				"processName": "'||v_process_name||'", 
				"info":'||v_result_info||',
				"point":'||v_result_point||',
				"line":'||v_result_line||',
				"polygon":'||v_result_polygon||'
			}
		}
	}')::json, 2710, null, null, null)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

