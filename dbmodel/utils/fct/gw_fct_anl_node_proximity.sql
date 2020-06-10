/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2914

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_anl_node_proximity(p_table json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_node_duplicated($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"v_edit_man_junction", "id":["1004","1005"]},
"data":{"selectionMode":"previousSelection",
  "parameters":{"nodeProximity":300, "saveOnDatabase":true}}}$$)

-- fid: 132

*/

DECLARE
    
v_id json;
v_selectionmode text;
v_nodeproximity	float;
v_saveondatabase boolean;
v_worklayer text;
v_result json;
v_result_info json;
v_result_point json;
v_array text;
v_qmlpointpath text;
v_error_context text;
 
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- getting input data   
    v_id :=  ((p_data ->>'feature')::json->>'id')::json;
    v_array :=  replace(replace(replace (v_id::text, ']', ')'),'"', ''''), '[', '(');
    v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
    v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_saveondatabase :=  (((p_data ->>'data')::json->>'parameters')::json->>'saveOnDatabase')::boolean;
    v_nodeproximity := ((p_data ->>'data')::json->>'parameters')::json->>'nodeProximity';

    -- Reset values
    DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=132;
		
    --select default geometry style
    SELECT regexp_replace(row(value)::text, '["()"]', '', 'g')  INTO v_qmlpointpath FROM config_param_user WHERE parameter='qgis_qml_pointlayer_path' AND cur_user=current_user;
		
  -- Computing process
  IF v_array != '()' THEN
    EXECUTE 'INSERT INTO anl_node (node_id, nodecat_id, state, node_id_aux, nodecat_id_aux, state_aux, expl_id, fid, the_geom)
        SELECT * FROM (
        SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.state as state1, t2.node_id, t2.nodecat_id, t2.state as state2, t1.expl_id, 6, t1.the_geom
        FROM '||v_worklayer||' AS t1 JOIN '||v_worklayer||' AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom,('||v_nodetolerance||')) 
        WHERE t1.node_id != t2.node_id AND t1.node_id IN '||v_array||' ORDER BY t1.node_id ) a where a.state1 > 0 AND a.state2 > 0';
  ELSE
    EXECUTE 'INSERT INTO anl_node (node_id, nodecat_id, state, node_id_aux, nodecat_id_aux, state_aux, expl_id, fid, the_geom)
        SELECT * FROM (
        SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.state as state1, t2.node_id, t2.nodecat_id, t2.state as state2, t1.expl_id, 6, t1.the_geom
        FROM '||v_worklayer||' AS t1 JOIN '||v_worklayer||' AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom,('||v_nodetolerance||')) 
        WHERE t1.node_id != t2.node_id ORDER BY t1.node_id ) a where a.state1 > 0 AND a.state2 > 0';
  END IF;

  
  	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=132 order by id) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

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
    FROM  anl_node WHERE cur_user="current_user"() AND fid=132) row) features;

  v_result := COALESCE(v_result, '{}'); 
  v_result_point = concat ('{"geometryType":"Point", "qmlPath":"',v_qmlpointpath,'", "features":',v_result, '}'); 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=132;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fid=132 AND cur_user=current_user;
		INSERT INTO selector_audit (fid,cur_user) VALUES (132, current_user);
	END IF;

 
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 

	--  Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||
			'}}'||
	    '}')::json;

  EXCEPTION WHEN OTHERS THEN
   GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
   RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
