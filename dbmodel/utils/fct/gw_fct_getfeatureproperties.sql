/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3518

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getfeatureproperties(jsonb);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfeatureproperties(p_data jsonb)
RETURNS jsonb AS
$BODY$

/* Example usage:

SELECT gw_fct_getfeatureproperties(json_build_object('data', json_build_object('parameters', json_build_object('featureId', 1, 'featureType', 'ARC'))));

*/

DECLARE

	-- system variables
	v_version text;
	v_srid integer;
	v_project_type text;
	v_fid integer;

	-- dialog variables
	v_feature_id integer;
	v_feature_type text; -- ARC, NODE, CONNEC, LINK, GULLY

	-- query variables
	v_count integer;
	v_query_text text;
	v_query_text_aux text;
	v_data json;

	-- extra variables
	v_feature_table text;
	v_feature_id_field text;
	v_feature_type_field text;
	v_feature_cat_feature_table text;
	v_feature_cat_table text;
	v_feature_cat_field text;
	v_feature_class text; -- PIPE, JUNCTION, ...
	v_psector_table text;

	-- result variables
	v_result text;

	-- response variables
	v_status text;
	v_level integer;
	v_message text;

	v_is_arc_divide_candidate boolean;
	v_is_arc_fusion_candidate boolean;
	v_feature_state integer;
	v_feature_expl_id integer;
	v_feature_psector_id integer;

	v_error_context text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
	SELECT giswater, epsg, UPPER(project_type) INTO v_version, v_srid, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
	v_feature_id := p_data->'data'->'parameters'->>'featureId';
	v_feature_type := p_data->'data'->'parameters'->>'featureType';

	-- CHECKS
	IF v_feature_type NOT IN (SELECT id FROM sys_feature_type) THEN
		RAISE EXCEPTION 'Invalid feature type';
	END IF;

	IF v_feature_id IS NULL THEN
		RAISE EXCEPTION 'Feature ID cannot be null';
	END IF;

	v_feature_type := lower(v_feature_type);
	v_feature_table := v_feature_type;
	v_feature_id_field := v_feature_type || '_id';
	v_feature_type_field := v_feature_type || '_type';
	v_feature_cat_feature_table := 'cat_feature_' || v_feature_type;
	v_feature_cat_table := 'cat_' || v_feature_type;
	v_feature_cat_field := v_feature_type || 'cat_id';
	v_psector_table := 'plan_psector_x_' || v_feature_type;

	EXECUTE format('
			SELECT c.%I AS feature_type
			FROM %I t
			JOIN %I c ON c.id = t.%I	
			WHERE t.%I = $1
		', v_feature_type_field , v_feature_table, v_feature_cat_table, v_feature_cat_field , v_feature_id_field
	) INTO v_feature_class USING v_feature_id;

	IF v_feature_type = 'node' THEN
		v_query_text := format('SELECT isarcdivide FROM %I WHERE id = $1', v_feature_cat_feature_table);
		EXECUTE v_query_text INTO v_is_arc_divide_candidate USING v_feature_class;

		v_query_text := format('SELECT COUNT(*) FROM ve_arc WHERE node_1 = $1 OR node_2 = $1 AND state > 0');
		EXECUTE v_query_text INTO v_count USING v_feature_id;
		IF v_count = 2 THEN
			v_is_arc_fusion_candidate := TRUE;
		END IF;
	END IF;

	v_query_text := format('SELECT expl_id FROM %I WHERE %I = $1', v_feature_table, v_feature_id_field);
	EXECUTE v_query_text INTO v_feature_expl_id USING v_feature_id;

	v_query_text := format('SELECT state FROM %I WHERE %I = $1', v_feature_table, v_feature_id_field);
	EXECUTE v_query_text INTO v_feature_state USING v_feature_id;

	v_status := 'Accepted';

	-- Control NULL values
	v_status := COALESCE(v_status, 'Failed');
	v_level := COALESCE(v_level, 0);
	v_message := COALESCE(v_message, '');
	v_version := COALESCE(v_version, '');
	v_is_arc_divide_candidate := COALESCE(v_is_arc_divide_candidate, false);
	v_is_arc_fusion_candidate := COALESCE(v_is_arc_fusion_candidate, false);
	v_feature_state := COALESCE(v_feature_state, -1);
	v_feature_expl_id := COALESCE(v_feature_expl_id, -1);
	v_feature_psector_id := COALESCE(v_feature_psector_id, -1);

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
				"isArcDivideCandidate": '||v_is_arc_divide_candidate||', 
				"isArcFusionCandidate": '||v_is_arc_fusion_candidate||', 
				"featureState": "'||v_feature_state||'", 
				"featureExplId":"'||v_feature_expl_id||'",
				"featurePsectorId":"'||v_feature_psector_id||'"
			}
		}
	}')::json, 3518, null, null, null)::json;

	EXCEPTION WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
		RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

