/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3186

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_epa_setjunctionsoutlet(p_data json) RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_epa_setjunctionsoutlet($${"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},"feature":{"tableName":"ve_node", "featureType":"NODE", "id":[]},
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
"parameters":{"minDistance":"20.0"}}}$$)::text

SELECT * FROM temp_node

fid: 484

*/

DECLARE

v_id json;
v_selectionmode text;
v_mindistance float;
v_worklayer text;
v_result json;
v_result_info json;
v_result_point json;
v_array text;
v_version text;
v_error_context text;
v_count integer;
rec_node record;
v_fid integer = 484;
i integer = 0;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_mindistance := ((p_data ->>'data')::json->>'parameters')::json->>'minDistance';

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	raise notice '0 - Reset';
	TRUNCATE temp_node;
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4,"infoType":1,"lang":"ES"},"feature":{}, 
						"data":{"function":"3186","fid":"'||v_fid||'","criticity":"4","is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4,"infoType":1,"lang":"ES"},"feature":{}, 
						"data":{"message":"4306","function":"3186","parameters":{"v_mindistance":"'||v_mindistance||'"}, "fid":"'||v_fid||'","criticity":"4","is_process":true}}$$)';


	raise notice '1- Insert';
	INSERT INTO temp_node (node_id, nodecat_id, expl_id, the_geom, sector_id, state)
	SELECT node_id, nodecat_id, expl_id,  the_geom, sector_id, state FROM ve_node where epa_type = 'JUNCTION';

	select count(*) into v_count from temp_node;
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4,"infoType":1,"lang":"ES"},"feature":{}, 
						"data":{"message":"4308","function":"3186","parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'","criticity":"4","is_process":true}}$$)';

	raise notice '2- Clean';
	for rec_node in EXECUTE 'select n1, array_agg(n2) n2 FROM (select n1.node_id n1, n2.node_id n2 FROM temp_node n1, temp_node n2 
			WHERE st_dwithin(n1.the_geom, n2.the_geom, '||v_mindistance||') and n1.node_id != n2.node_id order by 1)a group by n1'
	loop
		update temp_node set state_type = 1 where node_id = rec_node.n1;
		delete from temp_node where node_id in (select unnest(rec_node.n2)) and state_type is null;
	end loop;

	select count(*) into v_count from temp_node;
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4,"infoType":1,"lang":"ES"},"feature":{}, 
						"data":{"message":"4310","function":"3186","parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'","criticity":"4","is_process":true}}$$)';


	INSERT INTO anl_node (node_id, nodecat_id, expl_id, the_geom, sector_id, state, fid, cur_user)
	SELECT node_id, nodecat_id, expl_id,  the_geom, sector_id, state, 484, current_user FROM temp_node;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;
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
			'geometry',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
			'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, fid, ST_Transform(the_geom, 4326) as the_geom
		FROM  anl_node WHERE cur_user="current_user"() AND fid=v_fid) row) features;
	v_result := COALESCE(v_result, '{}');
	v_result_point = v_result::text;

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||
			'}}'||
	    '}')::json, 3186, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
