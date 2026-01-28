/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3176


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_graphanalytics_upstream_section_control(p_data json)
RETURNS json AS

$BODY$

/*
example:
SELECT SCHEMA_NAME.gw_graphanalytics_upstream_section_control($${
"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"},
"feature":{"id":["20607"]},
"data":{}}$$);

--fid: 477;

*/

DECLARE

v_result_json json;
v_result json;
v_result_info text;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_error_context text;
v_version text;
v_status text;
v_level integer;
v_message text;
v_audit_result text;
v_cur_user text;
v_prev_cur_user text;
v_count_connec integer;
v_count_gully integer;
v_count_node integer;
v_length_arc numeric;
v_device integer;

v_node text;
v_xcoord double precision;
v_ycoord double precision;
v_epsg integer;
v_client_epsg integer;
v_point public.geometry;

v_fid integer =477;
v_count integer;
v_node_list text[];
rec_node_id text;
v_layer text;
v_node_id text;
v_exists boolean;
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	v_cur_user := (p_data ->> 'client')::json->> 'cur_user';
	v_device := (p_data ->> 'client')::json->> 'device';
	v_xcoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'xcoord';
	v_ycoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'ycoord';
	v_epsg := (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);
	v_client_epsg := (p_data ->> 'client')::json->> 'epsg';
	v_node_id =json_extract_path_text(p_data,'data','parameters','node');
	v_layer = json_extract_path_text(p_data,'feature','tableName');

	IF v_client_epsg IS NULL THEN v_client_epsg = v_epsg; END IF;

	v_prev_cur_user = current_user;
	IF v_cur_user IS NOT NULL THEN
		EXECUTE 'SET ROLE "'||v_cur_user||'"';
	END IF;

	-- Reset values
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fid = v_fid;
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid =v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid =v_fid;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3176", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	SELECT gw_fct_json_object_set_key (p_data,'fid'::text, v_fid) INTO p_data;

	IF v_node_id IS NULL AND v_layer in ('ve_storage', 've_inp_outfall') THEN
			EXECUTE 'SELECT array_agg(node_id) FROM '||v_layer||''
			INTO v_node_list;

		FOREACH rec_node_id in ARRAY(v_node_list) LOOP
			p_data = jsonb_set(p_data::jsonb,'{data,parameters,node}'::text[], rec_node_id::jsonb);
			EXECUTE 'SELECT gw_fct_graphanalytics_upstream($$'||p_data||'$$);'
			INTO v_result_json;
		END LOOP;

	ELSIF v_node_id IS NOT NULL THEN
		EXECUTE 'select exists(select 1 from '||v_layer||' where node_id='||quote_literal(v_node_id)||')' into v_exists;
		IF v_exists THEN
			EXECUTE 'SELECT gw_fct_graphanalytics_upstream($$'||p_data||'$$);'
			INTO v_result_json;
		END IF;

	END IF;

	IF v_node_id IS NULL AND v_layer !='ve_inp_outfall' THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3990", "function":"3176", "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3992", "function":"3176", "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
	ELSIF v_exists IS FALSE THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3994", "function":"3176", "parameters":{"v_node_id":"'||v_node_id||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3996", "function":"3176", "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';
	ELSE

		SELECT count(*) INTO v_count FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid;

		IF v_count = 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3998", "function":"3176", "fid":"'||v_fid||'", "fcount":"'||v_count||'", "is_process":true}}$$)';
		ELSE
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4000", "function":"3176", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "is_process":true}}$$)';


			INSERT INTO audit_check_data(fid,  error_message, fcount)
			SELECT v_fid,  concat ('Arc_id: ',string_agg(arc_id, ', '), '.' ), v_count
			FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid;
		END IF;
	END IF;


		IF v_audit_result is null THEN
			v_status = 'Accepted';
			v_level = 3;
			v_message = 'Analysis done successfully';
		ELSE

			SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status;
			SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
			SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

		END IF;


		-- info
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
		FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;

		v_result := COALESCE(v_result, '{}');
		v_result_info := COALESCE(v_result, '{}');
		v_result_info = concat ('{"values":',v_result_info, '}');

		v_result_line := jsonb_build_object(
			'type', 'FeatureCollection',
			'features', COALESCE((
				SELECT jsonb_agg(features.feature)
				FROM (
					SELECT jsonb_build_object(
						'type',       'Feature',
						'geometry',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
						'properties', to_jsonb(row) - 'the_geom'
					) AS feature
					FROM (SELECT distinct arc_id, arccat_id, expl_id, fid, ST_Transform(the_geom, 4326) as the_geom, descript as geom1
					FROM anl_arc WHERE fid=v_fid and cur_user="current_user"()) row
				) features
			), '[]'::jsonb)
		)::text;

		v_result_point = '{}';

		v_result_polygon = '{}';

		EXECUTE 'SET ROLE "'||v_prev_cur_user||'"';

		--  Return
		RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
				   ',"body":{"form":{}'||
				   ',"data":{ "info":'||v_result_info||','||
					  '"point":'||v_result_point||','||
					  '"line":'||v_result_line||','||
					  '"polygon":'||v_result_polygon||'}'||
					 '}'
			  '}')::json, 3176, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
