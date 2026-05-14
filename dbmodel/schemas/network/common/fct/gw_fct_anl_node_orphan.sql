/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2110

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_node_orphan(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_orphan(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_node_orphan($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{}, "feature":{"tableName":"ve_node", "featureType":"NODE", "id":[]},
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
"parameters":{"isArcDivide":"true"}}}$$)::text

-- fid: 107

*/

DECLARE

rec_node record;

v_closest_arc_id integer;
v_closest_arc_distance numeric;
v_version text;
v_result json;
v_id json;
v_result_info json;
v_result_point json;
v_array text;
v_selectionmode text;
v_worklayer text;
v_projectype text;
v_partialquery text;
v_isarcdivide text;
v_error_context text;
v_count1 integer;
v_count2 integer;
v_partialquery2 text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projectype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_isarcdivide := (((p_data ->>'data')::json->>'parameters')::json->>'isArcDivide')::text;

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid in (442,443);
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid in (442,443);

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2110", "fid":"442", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	-- built partial query
	IF v_projectype = 'WS' THEN
		v_partialquery = 'JOIN cat_node nc ON nodecat_id=id JOIN cat_feature_node nt ON nt.id=nc.node_type';
	ELSIF v_projectype = 'UD' THEN
		v_partialquery = 'JOIN cat_feature_node ON id = a.node_type';
	END IF;

	-- Computing process
    IF v_selectionmode = 'previousSelection' then
		IF v_array IS NOT NULL THEN
			FOR rec_node IN EXECUTE 'SELECT  * FROM '||v_worklayer||' a '||v_partialquery||'  WHERE a.state>0 AND node_id IN ('||v_array||') 
			AND isarcdivide= ''true'' AND 
			(SELECT COUNT(*) FROM arc WHERE node_1 = a.node_id OR node_2 = a.node_id and arc.state>0) = 0'
			LOOP
				--find the closest arc and the distance between arc and node
				SELECT ST_Distance(arc.the_geom, rec_node.the_geom) as d, arc.arc_id INTO v_closest_arc_distance, v_closest_arc_id
				FROM arc WHERE arc.state = 1 ORDER BY arc.the_geom <-> rec_node.the_geom  LIMIT 1;

				INSERT INTO anl_node (node_id, state, expl_id, fid, the_geom, nodecat_id,arc_id,arc_distance)
				VALUES (rec_node.node_id, rec_node.state, rec_node.expl_id, 442, rec_node.the_geom, rec_node.nodecat_id,v_closest_arc_id,v_closest_arc_distance);
			END LOOP;

			FOR rec_node IN EXECUTE 'SELECT  * FROM '||v_worklayer||' a '||v_partialquery||'  WHERE a.state>0 AND node_id IN ('||v_array||') 
			AND isarcdivide= ''false'' AND arc_id IS NULL'
			LOOP
				--find the closest arc and the distance between arc and node
				SELECT ST_Distance(arc.the_geom, rec_node.the_geom) as d, arc.arc_id INTO v_closest_arc_distance, v_closest_arc_id
				FROM arc WHERE arc.state = 1 ORDER BY arc.the_geom <-> rec_node.the_geom  LIMIT 1;

				INSERT INTO anl_node (node_id, state, expl_id, fid, the_geom, nodecat_id,arc_id,arc_distance)
				VALUES (rec_node.node_id, rec_node.state, rec_node.expl_id, 442, rec_node.the_geom, rec_node.nodecat_id,v_closest_arc_id,v_closest_arc_distance);
			END LOOP;
		END IF;
	ELSE
		FOR rec_node IN EXECUTE 'SELECT * FROM '||v_worklayer||' a '||v_partialquery||' WHERE a.state > 0 AND isarcdivide = ''true'' AND 
		(SELECT COUNT(*) FROM arc WHERE node_1 = a.node_id OR node_2 = a.node_id and arc.state > 0) = 0'
		LOOP
			--find the closest arc and the distance between arc and node
			SELECT ST_Distance(arc.the_geom, rec_node.the_geom) as d, arc.arc_id INTO v_closest_arc_distance, v_closest_arc_id
			FROM arc WHERE arc.state = 1 ORDER BY arc.the_geom <-> rec_node.the_geom LIMIT 1;

			INSERT INTO anl_node (node_id, state, expl_id, fid, the_geom, nodecat_id,arc_id,arc_distance,descript)
			VALUES (rec_node.node_id, rec_node.state, rec_node.expl_id, 442, rec_node.the_geom, rec_node.nodecat_id,
			v_closest_arc_id,v_closest_arc_distance, 'Orphan nodes with isarcdivide = TRUE');
		END LOOP;

		IF v_projectype = 'WS' THEN
			v_partialquery2 = 'AND node.arc_id IS NULL';
		ELSE
			v_partialquery2 = '';
		END IF;

		FOR rec_node IN EXECUTE 'SELECT * FROM '||v_worklayer||' a '||v_partialquery||' JOIN node ON node.node_id = a.node_id WHERE a.state > 0 AND isarcdivide = ''false'' '||v_partialquery2||' '
		LOOP
			--find the closest arc and the distance between arc and node
			SELECT ST_Distance(arc.the_geom, rec_node.the_geom) as d, arc.arc_id INTO v_closest_arc_distance, v_closest_arc_id
			FROM arc WHERE arc.state = 1 ORDER BY arc.the_geom <-> rec_node.the_geom LIMIT 1;

			INSERT INTO anl_node (node_id, state, expl_id, fid, the_geom, nodecat_id,arc_id,arc_distance,descript)
			VALUES (rec_node.node_id, rec_node.state, rec_node.expl_id, 443, rec_node.the_geom, rec_node.nodecat_id,
			v_closest_arc_id,v_closest_arc_distance, 'Orphan nodes with isarcdivide=FALSE');
		END LOOP;
	END IF;

	-- set selector
	DELETE FROM selector_audit WHERE fid in (442,443) AND cur_user=current_user;
	INSERT INTO selector_audit (fid,cur_user) VALUES (442, current_user);
	INSERT INTO selector_audit (fid,cur_user) VALUES (443, current_user);

	-- get results
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
  	FROM  anl_node WHERE cur_user="current_user"() AND fid in (442,443)) row) features;

	v_result_point := COALESCE(v_result, '{}');

	SELECT count(*) INTO v_count1 FROM anl_node WHERE cur_user="current_user"() AND fid=442;
	SELECT count(*) INTO v_count2 FROM anl_node WHERE cur_user="current_user"() AND fid=443;

	IF v_count1 = 0 and v_count2=0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3602", "function":"2110", "fid":"442", "fcount":"0", "is_process":true}}$$)';
	ELSE
		IF v_count1 > 0 and v_count2 > 0 THEN
		 	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2110", "fid":"442", "criticity":"4", "is_process":true, "is_header":"true", "label_id":"3006", "separator_id":"2025"}}$$)';

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3604", "function":"2110", "parameters":{"v_count1":"'||v_count1||'"}, "fcount":"'||v_count1||'", "fid":"442", "is_process":true}}$$)';

			INSERT INTO audit_check_data(fid,  error_message, fcount)
			SELECT 442,  concat ('Node_id: ',array_agg(node_id), '.' ), v_count1
			FROM anl_node WHERE cur_user="current_user"() AND fid=442;

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2110", "fid":"442", "criticity":"4", "is_process":true, "separator_id":"2025"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2110", "fid":"442", "criticity":"4", "is_process":true, "is_header":"true", "label_id":"3008", "separator_id":"2025"}}$$)';


			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3606", "function":"2110", "parameters":{"v_count2":"'||v_count2||'"}, "fcount":"'||v_count2||'", "fid":"443", "is_process":true}}$$)';

			INSERT INTO audit_check_data(fid,  error_message, fcount)
			SELECT 443,  concat ('Node_id: ',array_agg(node_id), '.' ), v_count2
			FROM anl_node WHERE cur_user="current_user"() AND fid=443;

		ELSIF v_count1 > 0 and v_count2 = 0 THEN

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2110", "fid":"442", "criticity":"4", "is_process":true, "is_header":"true", "label_id":"3006", "separator_id":"2025"}}$$)';

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3604", "function":"2110", "parameters":{"v_count1":"'||v_count1||'"}, "fcount":"'||v_count1||'", "fid":"442", "is_process":true}}$$)';

			INSERT INTO audit_check_data(fid,  error_message, fcount)
			SELECT 442,  concat ('Node_id: ',array_agg(node_id), '.' ), v_count1
			FROM anl_node WHERE cur_user="current_user"() AND fid=442;

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2110", "fid":"442", "criticity":"4", "is_process":true, "separator_id":"2025"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2110", "fid":"442", "criticity":"4", "is_process":true, "is_header":"true", "label_id":"3008", "separator_id":"2025"}}$$)';


			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3608", "function":"2110", "fcount":"'||v_count2||'", "fid":"443", "is_process":true}}$$)';

		ELSIF v_count1 = 0 and v_count2 > 0 THEN

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2110", "fid":"442", "criticity":"4", "is_process":true, "is_header":"true", "label_id":"3006", "separator_id":"2025"}}$$)';

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3610", "function":"2110", "fcount":"'||v_count1||'", "fid":"442", "is_process":true}}$$)';

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2110", "fid":"442", "criticity":"4", "is_process":true, "separator_id":"2025"}}$$)';
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2110", "fid":"442", "criticity":"4", "is_process":true, "is_header":"true", "label_id":"3008", "separator_id":"2025"}}$$)';

			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3606", "function":"2110", "parameters":{"v_count2":"'||v_count2||'"}, "fcount":"'||v_count2||'", "fid":"443", "is_process":true}}$$)';

			INSERT INTO audit_check_data(fid,  error_message, fcount)
			SELECT 443,  concat ('Node_id: ',array_agg(node_id), '.' ), v_count2
			FROM anl_node WHERE cur_user="current_user"() AND fid=443;

		END IF;
	END IF;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid in (442,443) order by  id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||
			'}}'||
	    '}')::json, 2110, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
