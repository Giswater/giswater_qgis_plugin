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
	v_expl_id_array text[];
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
    v_expl_id_array := string_to_array(gw_fct_get_expl_id_array(v_expl_id), ',')::integer[];

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
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3424", "fid":"'||v_fid||'", "is_header":"true", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"data":{"message":"4460", "function":"3424", "criticity":"3", "tempTable":"temp_", "parameters":{"v_psectors":"'||v_usepsector||'"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"data":{"message":"4462", "function":"3424", "criticity":"3", "tempTable":"temp_", "parameters":{"v_commit_changes":"'||v_commitchanges||'"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"separator_id": "2000", "function":"3424", "criticity":"3", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3424", "fid":"'||v_fid||'", "criticity":"3", "is_header":"true", "label_id":"3003", "separator_id":"2008", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3424", "fid":"'||v_fid||'", "criticity":"2", "is_header":"true", "label_id":"3002", "separator_id":"2009", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3424", "fid":"'||v_fid||'", "criticity":"1", "is_header":"true", "label_id":"3001", "separator_id":"2009", "tempTable":"temp_"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3424", "fid":"'||v_fid||'", "criticity":"0", "is_header":"true", "label_id":"3012", "separator_id":"2010", "tempTable":"temp_"}}$$)';
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
            WHERE $1 IS NULL
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

	UPDATE temp_pgr_node n
	SET  mapzone_id = t.treatment_type, old_mapzone_id = t.treatment_type 
	FROM v_temp_node t
	WHERE n.pgr_node_id = t.node_id;

	INSERT INTO temp_pgr_arc (pgr_arc_id,pgr_node_1, pgr_node_2, mapzone_id, old_mapzone_id, cost, reverse_cost)
	SELECT a.arc_id, a.node_1, a.node_2,  a.treatment_type, a.treatment_type, 1, -1
	FROM v_temp_arc a
	WHERE EXISTS (SELECT 1 FROM temp_pgr_node n WHERE n.pgr_node_id = a.node_1)
    AND EXISTS (SELECT 1 FROM temp_pgr_node n WHERE n.pgr_node_id = a.node_2);

	v_count := 1;

	WHILE v_count > 0 LOOP

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
		AND t.mapzone_id IS DISTINCT FROM arc.treatment_type;

		UPDATE link l
		SET treatment_type = t.treatment_type
		FROM v_temp_connec t
		WHERE l.feature_id = t.connec_id;

		UPDATE link l
		SET treatment_type = t.treatment_type
		FROM v_temp_gully t
		WHERE l.feature_id = t.gully_id;

	ELSE
		RAISE NOTICE 'Showing temporal layers with treatment_type and geometry';

		v_result_line := jsonb_build_object(
			'type', 'FeatureCollection',
			'layerName', 'Lines',
			'features', COALESCE((
				SELECT jsonb_agg(features.feature)
				FROM (
					SELECT jsonb_build_object(
						'type',       'Feature',
						'geometry',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
						'properties', to_jsonb(row) - 'the_geom'
					) AS feature
					FROM (
						SELECT t.pgr_arc_id AS feature_id, 'ARC' AS feature_type, t.mapzone_id as treatment_type, ot.idval as treatment_type_name, t.old_mapzone_id as old_treatment_type, oto.idval as old_treatment_type_name, ST_Transform(v.the_geom, 4326) as the_geom
						FROM temp_pgr_arc t 
						JOIN v_temp_arc v ON  v.arc_id = t.pgr_arc_id
						JOIN om_typevalue ot ON ot.id::int4 = t.mapzone_id
						JOIN om_typevalue oto ON oto.id::int4 = t.old_mapzone_id
						WHERE ot.typevalue = 'treatment_type' 
						AND oto.typevalue = 'treatment_type'
						UNION
						SELECT vl.link_id AS feature_id, 'LINK' AS feature_type, vc.treatment_type as treatment_type, ot.idval as treatment_type_name, vl.treatment_type as old_treatment_type, oto.idval as old_treatment_type_name, ST_Transform(vl.the_geom, 4326) as the_geom
						FROM temp_pgr_arc t 
						JOIN v_temp_connec vc ON vc.arc_id = t.pgr_arc_id
						JOIN v_temp_link_connec vl ON vl.feature_id = vc.connec_id
						JOIN om_typevalue ot ON ot.id::int4 = vc.treatment_type
						JOIN om_typevalue oto ON oto.id::int4 = vl.treatment_type
						WHERE ot.typevalue = 'treatment_type'
						AND oto.typevalue = 'treatment_type'
						UNION
						SELECT vl.link_id AS feature_id, 'LINK' AS feature_type, vg.treatment_type as treatment_type, ot.idval as treatment_type_name, vl.treatment_type as old_treatment_type, oto.idval as old_treatment_type_name, ST_Transform(vl.the_geom, 4326) as the_geom
						FROM temp_pgr_arc t 
						JOIN v_temp_gully vg ON vg.arc_id = t.pgr_arc_id
						JOIN v_temp_link_gully vl ON vl.feature_id = vg.gully_id
						JOIN om_typevalue ot ON ot.id::int4 = vg.treatment_type
						JOIN om_typevalue oto ON oto.id::int4 = vl.treatment_type
						WHERE ot.typevalue = 'treatment_type'
						AND oto.typevalue = 'treatment_type'
					) row
				) features
			), '[]'::jsonb)
		)::text;

		v_result_point := jsonb_build_object(
			'type', 'FeatureCollection',
			'layerName', 'Points',
			'features', COALESCE((
				SELECT jsonb_agg(features.feature)
				FROM (
					SELECT jsonb_build_object(
						'type',       'Feature',
						'geometry',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
						'properties', to_jsonb(row) - 'the_geom'
					) AS feature
					FROM (
						SELECT t.pgr_node_id AS feature_id, 'NODE' AS feature_type, t.mapzone_id as treatment_type, ot.idval as treatment_type_name, t.old_mapzone_id as old_treatment_type, oto.idval as old_treatment_type_name, ST_Transform(v.the_geom, 4326) as the_geom
						FROM temp_pgr_node t 
						JOIN v_temp_node v ON v.node_id = t.pgr_node_id
						JOIN om_typevalue ot ON ot.id::int4 = t.mapzone_id
						JOIN om_typevalue oto ON oto.id::int4 = t.old_mapzone_id
						WHERE ot.typevalue = 'treatment_type' 
						AND oto.typevalue = 'treatment_type'
						UNION
						SELECT vc.connec_id AS feature_id, 'CONNECT' AS feature_type, vc.treatment_type, ot.idval as treatment_type_name, vc.treatment_type AS old_treatment_type, ot.idval as old_treatment_type_name, ST_Transform(vc.the_geom, 4326) as the_geom
						FROM temp_pgr_arc t 
						JOIN v_temp_connec vc ON vc.arc_id = t.pgr_arc_id 
						JOIN om_typevalue ot ON ot.id::int4 = vc.treatment_type
						WHERE ot.typevalue = 'treatment_type'
						UNION
						SELECT vg.gully_id AS feature_id, 'GULLY' AS feature_type, vg.treatment_type, ot.idval as treatment_type_name, vg.treatment_type AS old_treatment_type, ot.idval as old_treatment_type_name, ST_Transform(vg.the_geom, 4326) as the_geom
						FROM temp_pgr_arc t  
						JOIN v_temp_gully vg ON vg.arc_id = t.pgr_arc_id
						JOIN om_typevalue ot ON ot.id::int4 = vg.treatment_type
						WHERE ot.typevalue = 'treatment_type'
					) row
				) features
			), '[]'::jsonb)
		)::text;

		v_result_polygon = '{}';

		v_status = 'Accepted';
		v_level = 3;
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4210", "function":"3424", "is_process":true}}$$)::JSON->>''text''' INTO v_message;

	END IF;

		-- treatment_type equal to zero
	v_count = 0;

	SELECT count(*) INTO v_count 
	FROM temp_pgr_arc 
	WHERE mapzone_id = 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4342", "function":"3424", "criticity":"2", "prefix_id":"1002", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"arc"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	SELECT count(*) INTO v_count 
	FROM temp_pgr_node 
	WHERE mapzone_id = 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4342", "function":"3424", "criticity":"2", "prefix_id":"1002", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"node"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	SELECT count(*) INTO v_count 
	FROM temp_pgr_arc a 
	JOIN v_temp_connec v ON v.arc_id = a.pgr_arc_id  
	WHERE COALESCE (v.treatment_type, 0) = 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4342", "function":"3424", "criticity":"2", "prefix_id":"1002", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"connec"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	SELECT count(DISTINCT gully_id) INTO v_count 
	FROM temp_pgr_arc a 
	JOIN v_temp_gully v ON v.arc_id = a.pgr_arc_id  
	WHERE COALESCE (v.treatment_type, 0) = 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4342", "function":"3424", "criticity":"2", "prefix_id":"1002", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"gully"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	-- treatment_type different to zero
	SELECT count(*) INTO v_count 
	FROM temp_pgr_arc 
	WHERE mapzone_id > 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4344", "function":"3424", "criticity":"1", "prefix_id":"1001", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"arc"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	SELECT count(*) INTO v_count 
	FROM temp_pgr_node 
	WHERE mapzone_id > 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4344", "function":"3424", "criticity":"1", "prefix_id":"1001", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"node"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	SELECT count(*) INTO v_count 
	FROM temp_pgr_arc a 
	JOIN v_temp_connec v ON v.arc_id = a.pgr_arc_id  
	WHERE v.treatment_type > 0;
	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4344", "function":"3424", "criticity":"1", "prefix_id":"1001", "parameters":{"v_count":"'||v_count||'", "v_feature_type":"connec"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "tempTable":"temp_"}}$$)';
	END IF;

	SELECT count(*) INTO v_count 
	FROM temp_pgr_arc a 
	JOIN v_temp_gully v ON v.arc_id = a.pgr_arc_id  
	WHERE v.treatment_type > 0;
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
	}')::json, 2710, null, null, null)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
