/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
-- The code of this inundation function have been provided by Claudia Dragoste (Aigues de Manresa, S.A.)

--FUNCTION CODE: 3522
--FID: 642

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_treatment_type(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_treatment_type(p_data json)
RETURNS json AS
$BODY$
/* TREATMENT TYPES

* EXAMPLE:

-- QUERY SAMPLE

SELECT gw_fct_graphanalytics_treatment_type($${
	"data":{
		"parameters":{
			"processName":"TREATMENT_TYPE",
			"exploitation":"1", -- Specific exploitation
			"usePlanPsector":"false", -- Not using psectors
			"commitChanges":"false" -- Not committing changes (This means showing temporal layers as the result)
		}
	}
}$$);

SELECT gw_fct_graphanalytics_treatment_type($${
	"data":{
		"parameters":{
			"processName":"TREATMENT_TYPE",
			"exploitation":"-901", -- Using selected exploitations
			"usePlanPsector":"true",
			"commitChanges":"false"
		}
	}
}$$);


SELECT gw_fct_graphanalytics_treatment_type($${
	"data":{
		"parameters":{
			"processName":"TREATMENT_TYPE",
			"exploitation":"-901",
			"usePlanPsector":"true",
			"commitChanges":"true" -- THIS CASE IS INCOMPATIBLE, AND IN THE CODE IT IS SET TO FALSE
		}
	}
}$$);

SELECT gw_fct_graphanalytics_treatment_type($${
	"data":{
		"parameters":{
			"processName":"TREATMENT_TYPE",
			"exploitation":"-902", -- Using all exploitations
			"usePlanPsector":"false",
			"commitChanges":"true" -- Committing changes (This means updating the real tables)
		}
	}
}$$);



*/

DECLARE


	-- system variables
	v_version TEXT;
	v_srid INTEGER;
	v_project_type TEXT;
	v_fid integer = 642;


	v_islastupdate BOOLEAN;

	-- dialog variables
	v_process_name text;
	v_expl_id text;
	v_expl_id_array text[];
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

	v_count integer;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
	SELECT giswater, epsg, UPPER(project_type) INTO v_version, v_srid, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
	v_process_name = p_data->'data'->'parameters'->>'processName'::text;
	v_expl_id = p_data->'data'->'parameters'->>'exploitation'::text;
	v_usepsector = p_data->'data'->'parameters'->>'usePlanPsector'::boolean;
	v_commitchanges = p_data->'data'->'parameters'->>'commitChanges'::boolean;
	-- for extra parameters
	v_parameters = p_data->'data'->'parameters';

	-- it's not allowed to commit changes when psectors are used
 	IF v_usepsector THEN
		v_commitchanges := FALSE;
	END IF;


    -- Get exploitation ID array
    v_expl_id_array = gw_fct_get_expl_id_array(v_expl_id);

	-- Delete temporary tables
	-- =======================
	v_data := '{"data":{"action":"DROP", "fct_name":"'|| v_process_name ||'"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

	IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Create temporary tables
	-- =======================
	v_data := '{"data":{"action":"CREATE", "fct_name":"'|| v_process_name ||'", "use_psector":"'|| v_usepsector ||'"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Start Building Log Message
	-- =======================
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3424", "fid":"'||v_fid||'", "is_header":"true", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"data":{"message":"4460", "function":"3424", "criticity":"3", "tempTable":"temp_", "parameters":{"v_psectors":"'||v_usepsector||'"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"data":{"message":"4462", "function":"3424", "criticity":"3", "tempTable":"temp_", "parameters":{"v_commit_changes":"'||v_commitchanges||'"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"separator_id": "2000", "function":"3424", "criticity":"3", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3424", "fid":"'||v_fid||'", "criticity":"3", "is_header":"true", "label_id":"3003", "separator_id":"2008", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3424", "fid":"'||v_fid||'", "criticity":"2", "is_header":"true", "label_id":"3002", "separator_id":"2009", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3424", "fid":"'||v_fid||'", "criticity":"1", "is_header":"true", "label_id":"3001", "separator_id":"2009", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3424", "fid":"'||v_fid||'", "criticity":"0", "is_header":"true", "label_id":"3012", "separator_id":"2010", "tempTable":"temp_"}}$$)';

	-- Initialize process
	-- =======================
	v_data := '{"data":{"expl_id_array":"' || array_to_string(v_expl_id_array, ',') || '", "mapzone_name":"'|| v_process_name ||'"}}';
    SELECT gw_fct_graphanalytics_initnetwork(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;



	-- WITH feature_type AS (
	-- 	SELECT
	-- 		a.arc_id,
	-- 		CASE WHEN a.initoverflowpath = FALSE THEN n.mapzone_id
	-- 		WHEN n.mapzone_id >= 2 THEN 2
	-- 		ELSE n.mapzone_id -- rainwater or Not Informed
	-- 		END AS fluid_type
	-- 	FROM temp_pgr_node n
	-- 	JOIN v_temp_arc a ON a.node_1 = n.node_id
	-- 	UNION ALL
	-- 	SELECT
	-- 		c.arc_id, c.fluid_type
	-- 	FROM v_temp_connec c
	-- 	WHERE EXISTS (
	-- 		SELECT 1
	-- 		FROM temp_pgr_arc a
	-- 		WHERE a.arc_id = c.arc_id
	-- 	)
	-- 	UNION ALL
	-- 	SELECT
	-- 		g.arc_id, g.fluid_type
	-- 	FROM v_temp_gully g
	-- 	WHERE EXISTS (
	-- 		SELECT 1
	-- 		FROM temp_pgr_arc a
	-- 		WHERE a.arc_id = g.arc_id
	-- 	)
	-- ), arc_type AS (
	-- 	SELECT
	-- 		arc_id,
	-- 		max(fluid_type) AS fluid_type,
	-- 		count(DISTINCT fluid_type) FILTER (WHERE fluid_type >0) AS nr
	-- 	FROM feature_type
	-- 	GROUP BY arc_id
	-- ), arc_modif AS (
	-- 	SELECT
	-- 		arc_id,
	-- 		CASE
	-- 		WHEN nr <= 1 THEN fluid_type -- 0 when fluid_type is not informed
	-- 		WHEN fluid_type IN (3,4) THEN 4
	-- 		ELSE fluid_type
	-- 		END AS fluid_type
	-- 	FROM arc_type
	-- )
	-- UPDATE temp_pgr_arc t
	-- SET mapzone_id = a.fluid_type
	-- FROM arc_modif a
	-- WHERE a.arc_id = t.arc_id
	-- AND a.fluid_type <> t.mapzone_id;

	-- WITH node_type AS (
	-- 	SELECT
	-- 		node_2 AS node_id,
	-- 		max(mapzone_id) AS fluid_type,
	-- 		count(DISTINCT mapzone_id) FILTER (WHERE mapzone_id > 0) AS nr
	-- 	FROM temp_pgr_arc
	-- 	GROUP BY node_2
	-- ), node_modif AS (
	-- 	SELECT
	-- 		node_id,
	-- 		CASE
	-- 		WHEN nr <= 1 THEN fluid_type -- 0 when fluid_type is not informed
	-- 		WHEN fluid_type IN (3,4) THEN 4
	-- 		ELSE fluid_type
	-- 		END AS fluid_type
	-- 	FROM node_type
	-- )
	-- UPDATE temp_pgr_node t
	-- SET mapzone_id = n.fluid_type
	-- FROM node_modif n
	-- WHERE n.node_id = t.node_id
	-- AND n.fluid_type <> t.mapzone_id;

	IF v_commitchanges IS TRUE THEN
		RAISE NOTICE 'Updating treatment type on real tables';

		-- v_querytext = 'UPDATE node SET treatment_type = t.mapzone_id FROM temp_pgr_node t WHERE t.node_id = node.node_id AND t.mapzone_id <> node.treatment_type;';
		-- EXECUTE v_querytext;

		-- v_querytext = 'UPDATE arc SET treatment_type = t.mapzone_id FROM temp_pgr_arc t WHERE t.arc_id = arc.arc_id AND t.mapzone_id <> arc.treatment_type;';
		-- EXECUTE v_querytext;
	ELSE
		RAISE NOTICE 'Showing temporal layers with treatment type and geometry';

		-- SELECT jsonb_agg(features.feature) INTO v_result
		-- FROM (
		-- SELECT jsonb_build_object(
		-- 	'type',       'Feature',
		-- 	'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		-- 	'properties', to_jsonb(row) - 'the_geom',
		-- 	'crs',concat('EPSG:',ST_SRID(the_geom))
		-- ) AS feature
		-- FROM (
		-- 	SELECT v.arc_id AS feature_id, 'ARC' AS feature_type, v.fluid_type, ot.idval as fluid_type_name, v.the_geom
		-- 	FROM v_temp_arc v
		-- 	JOIN temp_pgr_arc t ON t.arc_id = v.arc_id
		-- 	JOIN om_typevalue ot ON ot.id::int4 = v.fluid_type
		-- 	WHERE ot.typevalue = 'fluid_type'
		-- 	UNION
		-- 	SELECT v.link_id AS feature_id, 'LINK' AS feature_type, v.fluid_type, ot.idval as fluid_type_name, v.the_geom
		-- 	FROM v_temp_link_connec v
		-- 	JOIN temp_pgr_arc t ON t.arc_id = v.arc_id
		-- 	JOIN om_typevalue ot ON ot.id::int4 = v.fluid_type
		-- 	WHERE ot.typevalue = 'fluid_type'
		-- 	UNION
		-- 	SELECT v.link_id AS feature_id, 'LINK' AS feature_type, v.fluid_type, ot.idval as fluid_type_name, v.the_geom
		-- 	FROM v_temp_link_gully v
		-- 	JOIN temp_pgr_arc t ON t.arc_id = v.arc_id
		-- 	JOIN om_typevalue ot ON ot.id::int4 = v.fluid_type
		-- 	WHERE ot.typevalue = 'fluid_type'
		-- ) row) features;

		-- v_result := COALESCE(v_result, '{}');
		-- v_result_line = concat ('{"geometryType":"LineString", "layerName": "Lines", "features":',v_result, '}');

		-- SELECT jsonb_agg(features.feature) INTO v_result
		-- FROM (
		-- SELECT jsonb_build_object(
		-- 	'type',       'Feature',
		-- 	'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		-- 	'properties', to_jsonb(row) - 'the_geom',
		-- 	'crs',concat('EPSG:',ST_SRID(the_geom))
		-- ) AS feature
		-- FROM (
		-- 	SELECT v.node_id AS feature_id, 'NODE' AS feature_type, v.fluid_type, ot.idval as fluid_type_name, v.the_geom
		-- 	FROM v_temp_node v
		-- 	JOIN temp_pgr_node t ON t.node_id = v.node_id
		-- 	JOIN om_typevalue ot ON ot.id::int4 = v.fluid_type
		-- 	WHERE ot.typevalue = 'fluid_type'
		-- 	UNION
		-- 	SELECT v.connec_id AS feature_id, 'CONNECT' AS feature_type, v.fluid_type, ot.idval as fluid_type_name, v.the_geom
		-- 	FROM v_temp_connec v
		-- 	JOIN temp_pgr_arc t ON t.arc_id = v.arc_id
		-- 	JOIN om_typevalue ot ON ot.id::int4 = v.fluid_type
		-- 	WHERE ot.typevalue = 'fluid_type'
		-- 	UNION
		-- 	SELECT v.gully_id AS feature_id, 'GULLY' AS feature_type, v.fluid_type, ot.idval as fluid_type_name, v.the_geom
		-- 	FROM v_temp_gully v
		-- 	JOIN temp_pgr_arc t ON t.arc_id = v.arc_id
		-- 	JOIN om_typevalue ot ON ot.id::int4 = v.fluid_type
		-- 	WHERE ot.typevalue = 'fluid_type'
		-- ) row) features;

		v_result := COALESCE(v_result, '{}');
		v_result_point = concat ('{"geometryType":"Point", "layerName": "Points", "features":',v_result, '}');

		v_result_polygon = '{"geometryType":"", "features":[]}';

		v_status = 'Accepted';
		v_level = 3;
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4210", "function":"3424", "is_process":true}}$$)::JSON->>''text''' INTO v_message;

	END IF;


	-- Treatment type equal to zero
	v_count = 0;
	SELECT count(DISTINCT arc_id) INTO v_count FROM v_temp_arc WHERE treatment_type = 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4342", "function":"3424", "criticity":"2", "prefix_id":"1002", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"arc"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;
	SELECT count(DISTINCT node_id) INTO v_count FROM v_temp_node WHERE treatment_type = 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4342", "function":"3424", "criticity":"2", "prefix_id":"1002", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"node"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;
	SELECT count(DISTINCT connec_id) INTO v_count FROM v_temp_connec WHERE treatment_type = 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4342", "function":"3424", "criticity":"2", "prefix_id":"1002", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"connec"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;
	SELECT count(DISTINCT gully_id) INTO v_count FROM v_temp_gully WHERE treatment_type = 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4342", "function":"3424", "criticity":"2", "prefix_id":"1002", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"gully"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	-- Treatment type different to zero
	SELECT count(DISTINCT arc_id) INTO v_count FROM v_temp_arc WHERE treatment_type > 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4344", "function":"3424", "criticity":"1", "prefix_id":"1001", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"arc"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;
	SELECT count(DISTINCT node_id) INTO v_count FROM v_temp_node WHERE treatment_type > 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4344", "function":"3424", "criticity":"1", "prefix_id":"1001", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"node"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;
	SELECT count(DISTINCT connec_id) INTO v_count FROM v_temp_connec WHERE treatment_type > 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4344", "function":"3424", "criticity":"1", "prefix_id":"1001", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"connec"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;
	SELECT count(DISTINCT gully_id) INTO v_count FROM v_temp_gully WHERE treatment_type > 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4344", "function":"3424", "criticity":"1", "prefix_id":"1001", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"gully"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	-- insert spacer for warning and info
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  3, '');
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  2, '');
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  1, '');
	INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  0, '');



	-- Get Info for the audit
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message AS message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid IN (v_fid) ORDER BY criticity DESC, id ASC) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info := concat ('{"geometryType":"", "values":',v_result, '}');

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
	}')::json, 3520, null, null, null)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

