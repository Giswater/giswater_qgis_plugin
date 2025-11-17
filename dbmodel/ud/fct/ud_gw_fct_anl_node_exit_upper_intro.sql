/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2206

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_node_exit_upper_intro(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_exit_upper_intro(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE

SELECT gw_fct_anl_node_exit_upper_intro($${
"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
"feature":{"tableName":"ve_node", "featureType":"NODE", "id":[]},
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{}}}$$);
-- fid: 111

*/


DECLARE
rec_node record;
rec_arc record;

v_sys_elev1 numeric(12,3);
v_sys_elev2 numeric(12,3);
v_version text;
v_selectionmode text;
v_result json;
v_result_info json;
v_result_point json;
v_id json;
v_worklayer text;
v_array text;
v_sql text;
v_querytext text;
v_querytextres record;
v_i integer;
v_count integer;
v_error_context text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=111;
    DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=111;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2206", "fid":"111 "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3990", "function":"2206", "fid":"111", "criticity":"4", "prefix_id":"1001", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3974", "function":"2206", "fid":"111", "criticity":"4", "is_process":true}}$$)';
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (111, null, 4, '');


    	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	-- Computing process
	IF v_selectionmode = 'previousSelection' THEN
		v_sql:= 'SELECT * FROM '||v_worklayer||' where node_id in (select node_1 from ve_arc) 
		and node_id in (select node_2 from ve_arc) and node_id IN ('||v_array||') AND (verified IS NULL OR verified != 1)';
	ELSE
		v_sql:= ('SELECT * FROM '||v_worklayer||' where node_id in (select node_1 from ve_arc) 
		and node_id in (select node_2 from ve_arc) AND (verified IS NULL OR verified != 1)');
	END IF;


	FOR rec_node IN EXECUTE v_sql
		LOOP
			-- raise notice
			--raise notice '% - %', v_i, v_count;
			v_i=v_i+1;

			-- setting variables
			v_sys_elev1=0;
			v_sys_elev2=0;

			-- as node1
			v_querytext = 'SELECT * FROM ve_arc where node_1::integer='||rec_node.node_id;
			EXECUTE v_querytext INTO v_querytextres;
			IF v_querytextres.arc_id IS NOT NULL THEN
				FOR rec_arc IN EXECUTE v_querytext
				LOOP
					v_sys_elev1=greatest(v_sys_elev1,rec_arc.sys_elev1);
				END LOOP;
			ELSE
				v_sys_elev1=NULL;
			END IF;

			-- as node2
			v_querytext = 'SELECT * FROM ve_arc where node_2::integer='||rec_node.node_id;
			EXECUTE v_querytext INTO v_querytextres;
			IF v_querytextres.arc_id IS NOT NULL THEN
				FOR rec_arc IN EXECUTE v_querytext
				LOOP
					v_sys_elev2=greatest(v_sys_elev2,rec_arc.sys_elev2);
				END LOOP;
			ELSE
				v_sys_elev2=NULL;
			END IF;

			IF v_sys_elev1 > v_sys_elev2 AND v_sys_elev1 IS NOT NULL AND v_sys_elev2 IS NOT NULL THEN
				INSERT INTO anl_node (node_id, nodecat_id, expl_id, fid, the_geom, arc_distance, state) VALUES
				(rec_node.node_id,rec_node.nodecat_id, rec_node.expl_id, 111, rec_node.the_geom,v_sys_elev1 - v_sys_elev2,rec_node.state );
				raise notice 'Node found % :[% / %] maxelevin % maxelevout %',rec_node.node_id, v_i, v_count, v_sys_elev2 , v_sys_elev1 ;
			END IF;

		END LOOP;

	-- set selector
	DELETE FROM selector_audit WHERE fid=111 AND cur_user=current_user;
	INSERT INTO selector_audit (fid,cur_user) VALUES (111, current_user);

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
  	FROM  anl_node WHERE cur_user="current_user"() AND fid=111) row) features;

	v_result := COALESCE(v_result, '{}');
	v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}');

	SELECT count(*) INTO v_count FROM anl_node WHERE cur_user="current_user"() AND fid=111;

	IF v_count = 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3986", "function":"2206", "fid":"111", "fcount":"'||v_count||'", "is_process":true}}$$)';

	ELSE
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3988", "function":"2206", "parameters":{"v_count":"'||v_count||'"}, "fid":"111", "fcount":"'||v_count||'", "is_process":true}}$$)';

		INSERT INTO audit_check_data(fid,  error_message, fcount)
		SELECT 111,  concat ('Node_id: ',string_agg(node_id, ', '), '.' ), v_count
		FROM anl_node WHERE cur_user="current_user"() AND fid=111;

	END IF;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=111 order by  id asc) row;
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
	    '}')::json, 2206, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;