/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2212

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_node_topological_consistency(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_topological_consistency(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_node_topological_consistency($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"ve_man_manhole", "id":["138","139"]},
"data":{"selectionMode":"previousSelection", "parameters":{"saveOnDatabase":true}
}}$$)

-- fid: 108
*/

DECLARE

rec_node record;
rec record;

v_version text;
v_saveondatabase boolean;
v_result json;
v_result_info json;
v_result_point json;
v_id json;
v_selectionmode text;
v_worklayer text;
v_array text;
v_error_context text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=108;

    -- getting input data
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_saveondatabase :=  (((p_data ->>'data')::json->>'parameters')::json->>'saveOnDatabase')::boolean;

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	-- Computing process
	IF v_selectionmode = 'previousSelection' THEN
		EXECUTE 'INSERT INTO anl_node (node_id, nodecat_id, expl_id, num_arcs, fid, the_geom, state)
				SELECT node_id, nodecat_id, '||v_worklayer||'.expl_id, COUNT(*), 108, '||v_worklayer||'.the_geom , '||v_worklayer||'.state
				FROM '||v_worklayer||' 
				INNER JOIN ve_arc ON ve_arc.node_1 = '||v_worklayer||'.node_id OR ve_arc.node_2 = '||v_worklayer||'.node_id 
				WHERE '||v_worklayer||'.node_type != ''OUTFALL'' AND  node_id IN ('||v_array||')
				GROUP BY '||v_worklayer||'.node_id,'||v_worklayer||'.nodecat_id, '||v_worklayer||'.expl_id, '||v_worklayer||'.the_geom,
				'||v_worklayer||'.state 
				HAVING COUNT(*) = 1;';
	ELSE
		EXECUTE 'INSERT INTO anl_node (node_id, nodecat_id, expl_id, num_arcs, fid, the_geom, state)
				SELECT node_id, nodecat_id, '||v_worklayer||'.expl_id, COUNT(*), 108, '||v_worklayer||'.the_geom,'||v_worklayer||'.state 
				FROM '||v_worklayer||'
				INNER JOIN ve_arc ON ve_arc.node_1 = '||v_worklayer||'.node_id OR ve_arc.node_2 = '||v_worklayer||'.node_id 
				WHERE '||v_worklayer||'.node_type != ''OUTFALL'' 
				GROUP BY '||v_worklayer||'.node_id,'||v_worklayer||'.nodecat_id, '||v_worklayer||'.expl_id, '||v_worklayer||'.the_geom,
				'||v_worklayer||'.state
				HAVING COUNT(*) = 1;';
	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=108 order by id) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	--points
	v_result = null;
  	SELECT jsonb_build_object(
	    'type', 'FeatureCollection',
	    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
	) INTO v_result
 	FROM (
    SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
    ) AS feature
    FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript,fid, ST_Transform(the_geom, 4326) as the_geom
    FROM  anl_node WHERE cur_user="current_user"() AND fid=108) row) features;

  	v_result_point := COALESCE(v_result, '{}');

	IF v_saveondatabase IS FALSE THEN
		-- delete previous results
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=108;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fid=108 AND cur_user=current_user;
		INSERT INTO selector_audit (fid,cur_user) VALUES (108, current_user);
	END IF;

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||
			'}}'||
	    '}')::json, 2212, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
