/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: 2208
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_node_flowregulator(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_flowregulator(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_node_flowregulator($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"ve_man_manhole", "id":["138","139"]},
"data":{"selectionMode":"previousSelection",  "parameters":{}
	}}$$)

-- fid: 122

*/


DECLARE

v_version text;
v_result json;
v_result_info json;
v_result_point json;
v_id json;
v_selectionmode text;
v_worklayer text;
v_array text;
v_error_context text;
v_count integer;

BEGIN
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=112;
    DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=112;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2208", "fid":"112", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3980", "function":"2208", "fid":"112", "criticity":"4", "prefix_id":"1001", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3974", "function":"2208", "fid":"112", "criticity":"4", "is_process":true}}$$)';
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (112, null, 4, '');

    -- getting input data
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	-- Computing process
	IF v_selectionmode = 'previousSelection' THEN
		EXECUTE 'INSERT INTO anl_node (node_id, expl_id, fid, num_arcs, the_geom,nodecat_id, state)
				SELECT node_1 as node_id, n.expl_id, 112, count(node_1) as num_arcs, n.the_geom,nodecat_id, n.state
				FROM arc JOIN '||v_worklayer||' n ON node_id=node_1 AND node_id IN ('||v_array||')
				WHERE arc.state=1 and n.state=1 AND (n.verified != 1 OR n.verified IS NULL) 
				GROUP BY node_1, n.expl_id, n.the_geom, n.nodecat_id, n.state
				HAVING count(node_1)> 1 
				ORDER BY 2 desc;';
	ELSE
		EXECUTE 'INSERT INTO anl_node (node_id, expl_id, fid, num_arcs, the_geom,nodecat_id,state)
				SELECT node_1 as node_id, n.expl_id, 112, count(node_1) as num_arcs, n.the_geom, nodecat_id, n.state
				FROM arc JOIN '||v_worklayer||' n ON node_id=node_1
				WHERE arc.state=1 and n.state=1 AND (n.verified != 1 OR n.verified IS NULL) 
				GROUP BY node_1, n.expl_id, n.the_geom, n.nodecat_id, n.state
				HAVING count(node_1)> 1 
				ORDER BY 2 desc;';
	END IF;

	-- set selector
	DELETE FROM selector_audit WHERE fid=112 AND cur_user=current_user;
	INSERT INTO selector_audit (fid,cur_user) VALUES (112, current_user);

	-- get results
	--points
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript,fid, the_geom
  	FROM  anl_node WHERE cur_user="current_user"() AND fid=112) row) features;

	v_result := COALESCE(v_result, '{}');
	v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}');

	SELECT count(*) INTO v_count FROM anl_node WHERE cur_user="current_user"() AND fid=112;

	IF v_count = 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3982", "function":"2208", "fid":"112", "fcount":"'||v_count||'", "is_process":true}}$$)';

	ELSE
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3984", "function":"2208", "parameters":{"v_count":"'||v_count||'"}, "fid":"112", "fcount":"'||v_count||'", "is_process":true}}$$)';

		INSERT INTO audit_check_data(fid,  error_message, fcount)
		SELECT 112,  concat ('Node_id: ',string_agg(node_id, ', '), '.' ), v_count
		FROM anl_node WHERE cur_user="current_user"() AND fid=112;

	END IF;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=112 order by  id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||
			'}}'||
	    '}')::json, 2208, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;