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

SELECT gw_fct_graphanalytics_treatment_type($${"client":{"device":4, "lang":"es_ES", "version":"4.7.0",
"infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, 
"parameters":{"processName":"TREATMENT_TYPE", "exploitation":"-902", "usePlanPsector":"false",
"commitChanges":"false"}, "aux_params":null}}$$);

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
	v_expl_id_array INTEGER[];
    v_parameters json;
	v_usepsector boolean;
	v_commitchanges boolean;

	--

	v_level integer;
	v_status text;
	v_message text;

	v_query_text text;
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
	v_process_name := p_data->'data'->'parameters'->>'processName'::text;
	v_expl_id := p_data->'data'->'parameters'->>'exploitation'::text;
	v_usepsector = (p_data->'data'->'parameters'->>'usePlanPsector')::BOOLEAN;
	v_commitchanges = (p_data->'data'->'parameters'->>'commitChanges')::BOOLEAN;
	-- for extra parameters
	v_parameters = p_data->'data'->'parameters';

	-- it's not allowed to commit changes when psectors are used
 	IF v_usepsector THEN
		v_commitchanges := FALSE;
	END IF;

    -- Get exploitation ID array
    v_expl_id_array := gw_fct_get_expl_id_array(v_expl_id);

    -- if v_expl_id_array is null, return error
    IF v_expl_id_array IS NULL THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		       	"data":{"message":"4478", "function":"3522","parameters":null}}$$);';
    END IF;

	-- Delete temporary tables
	-- =======================
	v_data := '{"data":{"action":"DROP", "fct_name":"treatment_type"}}';
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
	/*
	-- =======================
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3522", "fid":"'||v_fid||'", "is_header":"true", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"data":{"message":"4460", "function":"3522", "criticity":"3", "tempTable":"temp_", "parameters":{"v_psectors":"'||v_usepsector||'"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"data":{"message":"4462", "function":"3522", "criticity":"3", "tempTable":"temp_", "parameters":{"v_commit_changes":"'||v_commitchanges||'"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"separator_id": "2000", "function":"3522", "criticity":"3", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3522", "fid":"'||v_fid||'", "criticity":"3", "is_header":"true", "label_id":"3003", "separator_id":"2008", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3522", "fid":"'||v_fid||'", "criticity":"2", "is_header":"true", "label_id":"3002", "separator_id":"2009", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3522", "fid":"'||v_fid||'", "criticity":"1", "is_header":"true", "label_id":"3001", "separator_id":"2009", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3522", "fid":"'||v_fid||'", "criticity":"0", "is_header":"true", "label_id":"3012", "separator_id":"2010", "tempTable":"temp_"}}$$)';
*/
	-- Initialize process
	-- =======================
	v_query_text := $q$
        SELECT arc_id AS id, node_1 AS source, node_2 AS target, 1 AS cost
        FROM v_temp_arc
    $q$;

	EXECUTE format($sql$
        WITH connectedcomponents AS (
            SELECT *
            FROM pgr_connectedcomponents($q$%s$q$)
        ),
        components AS (
            SELECT c.component
            FROM connectedcomponents c
            WHERE cardinality($1) = 0
            OR EXISTS (
                SELECT 1
                FROM v_temp_arc v
                WHERE v.expl_id = ANY($1)
                AND v.node_1 = c.node
            )
            GROUP BY c.component
        )
        INSERT INTO temp_pgr_node (pgr_node_id)
        SELECT c.node
        FROM connectedcomponents c
        WHERE EXISTS (
            SELECT 1
            FROM components cc
            WHERE cc.component = c.component
        )
    $sql$, v_query_text)
    USING v_expl_id_array;

	INSERT INTO temp_pgr_arc (pgr_arc_id, pgr_node_1, pgr_node_2)
	SELECT a.arc_id, a.node_1, a.node_2
	FROM v_temp_arc a
	JOIN temp_pgr_node n1 ON n1.pgr_node_id = a.node_1
	JOIN temp_pgr_node n2 ON n2.pgr_node_id = a.node_2;

	INSERT INTO temp_pgr_connec (pgr_connec_id, pgr_arc_id)
	SELECT c.connec_id, c.arc_id
	FROM v_temp_connec c
	JOIN temp_pgr_arc a ON a.pgr_arc_id = c.arc_id;

	INSERT INTO temp_pgr_gully (pgr_gully_id, pgr_arc_id)
	SELECT g.gully_id, g.arc_id
	FROM v_temp_gully g
	JOIN temp_pgr_arc a ON a.pgr_arc_id = g.arc_id;

	-- UPDATE treatment_type
	UPDATE temp_pgr_node t
	SET mapzone_id = n.treatment_type
	FROM node n
	WHERE t.pgr_node_id = n.node_id
	AND n.treatment_type <> 0;

	UPDATE temp_pgr_arc t
	SET mapzone_id = a.treatment_type
	FROM arc a
	WHERE t.pgr_arc_id = a.arc_id
	AND a.treatment_type <> 0;

	UPDATE temp_pgr_connec t
	SET mapzone_id = c.treatment_type
	FROM connec c
	WHERE t.pgr_connec_id = c.connec_id
	AND c.treatment_type <> 0;

	UPDATE temp_pgr_gully t
	SET mapzone_id = g.treatment_type
	FROM gully g
	WHERE t.pgr_gully_id = g.gully_id
	AND g.treatment_type <> 0;

	-- UPDATE como graph_delimiter HAS_TREATMENT
	UPDATE temp_pgr_node t
	SET graph_delimiter = 'HAS_TREATMENT'
	FROM node n
	WHERE t.pgr_node_id = n.node_id
	AND n.has_treatment = TRUE;

	-- UPDATE mapzone_id = 3 (NOT TREATED) if treatment_type is not informed 
	-- nodes 
	UPDATE temp_pgr_node
	SET mapzone_id = 3
	WHERE mapzone_id = 0
	AND graph_delimiter <> 'HAS_TREATMENT';
  
	-- arcs
	UPDATE temp_pgr_arc a
	SET mapzone_id = n.mapzone_id
	FROM temp_pgr_node n
	WHERE n.pgr_node_id = a.pgr_node_1
	AND a.mapzone_id = 0;

	v_count := 1;

	WHILE v_count > 0 LOOP

		WITH feature AS (
			SELECT
				a.pgr_arc_id,
				n.mapzone_id AS mapzone_id
			FROM temp_pgr_arc a 
			JOIN  temp_pgr_node n ON n.pgr_node_id = a.pgr_node_1
			UNION ALL
			SELECT
				c.pgr_arc_id,
				max(c.mapzone_id) AS mapzone_id
			FROM temp_pgr_connec c
			GROUP BY c.pgr_arc_id
			UNION ALL
			SELECT
				g.pgr_arc_id,
				max(g.mapzone_id) AS mapzone_id
			FROM temp_pgr_gully g
			GROUP BY g.pgr_arc_id
		),
		arc_mapzone AS (
			SELECT
				pgr_arc_id,
				max(mapzone_id) AS mapzone_id
			FROM feature
			GROUP BY pgr_arc_id
		)
		UPDATE temp_pgr_arc t
		SET mapzone_id = a.mapzone_id
		FROM arc_mapzone a
		WHERE a.pgr_arc_id = t.pgr_arc_id
		AND a.mapzone_id <> t.mapzone_id;

		-- nodes with graph_delimiter ='HAS_TREATMENT' will NOT be updated
		WITH node_mapzone AS (
			SELECT
				pgr_node_2 AS pgr_node_id,
				max(mapzone_id) AS mapzone_id
			FROM temp_pgr_arc
			GROUP BY pgr_node_2
		)
		UPDATE temp_pgr_node t
		SET mapzone_id = n.mapzone_id
		FROM node_mapzone n
		WHERE n.pgr_node_id = t.pgr_node_id
		AND n.mapzone_id <> t.mapzone_id
		AND t.graph_delimiter <> 'HAS_TREATMENT';

		GET DIAGNOSTICS v_count = ROW_COUNT;

  	END LOOP;

	IF v_commitchanges IS TRUE THEN
		RAISE NOTICE 'Updating treatment_type on real tables';

		UPDATE node n
		SET treatment_type = t.mapzone_id 
		FROM temp_pgr_node t 
		WHERE t.pgr_node_id = n.node_id 
		AND t.mapzone_id IS DISTINCT FROM n.treatment_type;

		UPDATE arc a
		SET treatment_type = t.mapzone_id 
		FROM temp_pgr_arc t 
		WHERE t.pgr_arc_id = a.arc_id 
		AND t.mapzone_id IS DISTINCT FROM a.treatment_type;

		UPDATE connec c
		SET treatment_type = t.mapzone_id
		FROM temp_pgr_connec t
		WHERE t.pgr_connec_id = c.connec_id
		AND t.mapzone_id IS DISTINCT FROM c.treatment_type;

		UPDATE gully g
		SET treatment_type = t.mapzone_id
		FROM temp_pgr_gully t
		WHERE t.pgr_gully_id = g.gully_id
		AND t.mapzone_id IS DISTINCT FROM g.treatment_type;

		UPDATE gully g
		SET treatment_type = 3
		FROM temp_pgr_arc t 
		JOIN v_temp_gully v ON t.pgr_arc_id = v.arc_id
		WHERE g.gully_id = v.gully_id
		AND COALESCE(g.treatment_type, 0) = 0; 

		-- the treatment_type for links is the treatment_type of the connec/gully
		UPDATE link l
		SET treatment_type = t.mapzone_id
		FROM temp_pgr_gully t
		WHERE t.pgr_gully_id = l.feature_id
		AND t.mapzone_id IS DISTINCT FROM l.treatment_type;

		UPDATE link l
		SET treatment_type = t.mapzone_id
		FROM temp_pgr_connec t
		WHERE t.pgr_connec_id = l.feature_id
		AND t.mapzone_id IS DISTINCT FROM l.treatment_type;

		v_status = 'Accepted';
		v_level = 3;
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4210", "function":"3522", "is_process":true}}$$)::JSON->>''text''' INTO v_message;

	ELSE
		RAISE NOTICE 'Showing temporal layers with treatment_type and geometry';

		v_result_line := jsonb_build_object(
			'type', 'FeatureCollection',
			'layerName', 'Treatment Type Lines',
			'features', COALESCE((
				SELECT jsonb_agg(features.feature)
				FROM (
					SELECT jsonb_build_object(
						'type',       'Feature',
						'geometry',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
						'properties', to_jsonb(row) - 'the_geom'
					) AS feature
					FROM (
						SELECT t.pgr_arc_id AS feature_id, 'ARC' AS feature_type, t.mapzone_id AS treatment_type, ot.idval AS treatment_type_name, a.treatment_type AS old_treatment_type, oto.idval AS old_treatment_type_name, ST_Transform(a.the_geom, 4326) AS the_geom
						FROM temp_pgr_arc t
						JOIN arc a ON a.arc_id = t.pgr_arc_id
						JOIN om_typevalue ot ON ot.id::int4 = t.mapzone_id
						JOIN om_typevalue oto ON oto.id::int4 = a.treatment_type
						WHERE ot.typevalue = 'treatment_type'
						AND oto.typevalue = 'treatment_type'
					) row
				) features
			), '[]'::jsonb)
		)::text;

		v_result_point := jsonb_build_object(
			'type', 'FeatureCollection',
			'layerName', 'Treatment Type Points',
			'features', COALESCE((
				SELECT jsonb_agg(features.feature)
				FROM (
					SELECT jsonb_build_object(
						'type',       'Feature',
						'geometry',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
						'properties', to_jsonb(row) - 'the_geom'
					) AS feature
					FROM (
						SELECT t.pgr_node_id AS feature_id, 'NODE' AS feature_type, COALESCE(n.has_treatment, FALSE) AS has_treatment, t.mapzone_id AS treatment_type, ot.idval AS treatment_type_name, n.treatment_type AS old_treatment_type, oto.idval AS old_treatment_type_name, ST_Transform(n.the_geom, 4326) AS the_geom
						FROM temp_pgr_node t
						JOIN node n ON n.node_id = t.pgr_node_id
						JOIN om_typevalue ot ON ot.id::int4 = t.mapzone_id
						JOIN om_typevalue oto ON oto.id::int4 = n.treatment_type
						WHERE ot.typevalue = 'treatment_type'
						AND oto.typevalue = 'treatment_type'
						UNION
						SELECT t.pgr_connec_id AS feature_id, 'CONNEC' AS feature_type, COALESCE(c.has_treatment, FALSE) AS has_treatment, t.mapzone_id AS treatment_type, ot.idval AS treatment_type_name, c.treatment_type AS old_treatment_type, oto.idval AS old_treatment_type_name, ST_Transform(c.the_geom, 4326) AS the_geom
						FROM temp_pgr_connec t
						JOIN connec c ON c.connec_id = t.pgr_connec_id
						JOIN om_typevalue ot ON ot.id::int4 = t.mapzone_id
						JOIN om_typevalue oto ON oto.id::int4 = c.treatment_type
						WHERE ot.typevalue = 'treatment_type'
						AND oto.typevalue = 'treatment_type'
						UNION
						SELECT t.pgr_gully_id AS feature_id, 'GULLY' AS feature_type, COALESCE(g.has_treatment, FALSE) AS has_treatment, t.mapzone_id AS treatment_type, ot.idval AS treatment_type_name, g.treatment_type AS old_treatment_type, oto.idval AS old_treatment_type_name, ST_Transform(g.the_geom, 4326) AS the_geom
						FROM temp_pgr_gully t
						JOIN gully g ON g.gully_id = t.pgr_gully_id
						JOIN om_typevalue ot ON ot.id::int4 = t.mapzone_id
						JOIN om_typevalue oto ON oto.id::int4 = g.treatment_type
						WHERE ot.typevalue = 'treatment_type'
						AND oto.typevalue = 'treatment_type'
					) row
				) features
			), '[]'::jsonb)
		)::text;

		v_result_polygon = '{}';

		v_status = 'Accepted';
		v_level = 3;
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4210", "function":"3522", "is_process":true}}$$)::JSON->>''text''' INTO v_message;

	END IF;

		-- treatment_type equal to zero
	v_count = 0;

	SELECT count(*) INTO v_count 
	FROM temp_pgr_arc 
	WHERE mapzone_id = 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4342", "function":"3522", "criticity":"2", "prefix_id":"1002", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"arc"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	SELECT count(*) INTO v_count 
	FROM temp_pgr_node 
	WHERE mapzone_id = 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4342", "function":"3522", "criticity":"2", "prefix_id":"1002", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"node"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	SELECT count(*) INTO v_count 
	FROM temp_pgr_connec
	WHERE mapzone_id = 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4342", "function":"3522", "criticity":"2", "prefix_id":"1002", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"connec"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	SELECT count(*) INTO v_count 
	FROM temp_pgr_gully
	WHERE mapzone_id = 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4342", "function":"3522", "criticity":"2", "prefix_id":"1002", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"gully"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	-- treatment_type different to zero
	SELECT count(*) INTO v_count 
	FROM temp_pgr_arc 
	WHERE mapzone_id > 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4344", "function":"3522", "criticity":"1", "prefix_id":"1001", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"arc"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	SELECT count(*) INTO v_count 
	FROM temp_pgr_node 
	WHERE mapzone_id > 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4344", "function":"3522", "criticity":"1", "prefix_id":"1001", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"node"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	SELECT count(*) INTO v_count 
	FROM temp_pgr_connec
	WHERE mapzone_id > 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4344", "function":"3522", "criticity":"1", "prefix_id":"1001", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"connec"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	SELECT count(*) INTO v_count 
	FROM temp_pgr_gully
	WHERE mapzone_id > 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4344", "function":"3522", "criticity":"1", "prefix_id":"1001", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"gully"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
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
	v_result_info := concat ('{"values":',v_result, '}');

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
	}')::json, 3522, null, null, null)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
