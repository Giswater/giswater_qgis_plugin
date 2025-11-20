/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3102

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_manage_dwf_values(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_manage_dwf_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", "target":"2", "sector":"1", "action":"INSERT-ONLY"}}}$$);
SELECT SCHEMA_NAME.gw_fct_manage_dwf_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", "target":"2", "sector":"1", "action":"KEEP-COPY"}}}$$);
SELECT SCHEMA_NAME.gw_fct_manage_dwf_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", "target":"2", "sector":"1", "action":"DELETE-COPY"}}}$$);
SELECT SCHEMA_NAME.gw_fct_manage_dwf_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", "target":"2", "sector":"1", "action":"DELETE-ONLY"}}}$$);


-- fid: 399

*/


DECLARE

object_rec record;
v_version text;
v_result json;
v_result_info json;
v_result_point json;
v_copyfrom integer;
v_target integer;
v_error_context text;
v_count integer;
v_count2 integer;
v_projecttype text;
v_fid integer = 399;
v_source_name text;
v_target_name text;
v_action text;
v_querytext text;
v_sector integer;
v_sector_name text;
v_sector_list text[];
v_result_id text = null;
rec text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_copyfrom :=  ((p_data ->>'data')::json->>'parameters')::json->>'copyFrom';
	v_target :=  ((p_data ->>'data')::json->>'parameters')::json->>'target';
	v_sector :=  ((p_data ->>'data')::json->>'parameters')::json->>'sector';
	v_action :=  ((p_data ->>'data')::json->>'parameters')::json->>'action';

	-- getting scenario name
	v_source_name := (SELECT idval FROM cat_dwf WHERE id = v_copyfrom);
	v_target_name := (SELECT idval FROM cat_dwf WHERE id = v_target);
	v_sector_name := (SELECT name FROM sector WHERE sector_id = v_sector);

	IF v_sector = -999 THEN
		SELECT array_agg(sector_id) INTO v_sector_list FROM  sector JOIN selector_sector USING (sector_id) WHERE cur_user = current_user;
	ELSIF v_sector = -998 THEN
		SELECT array_agg(sector_id) INTO v_sector_list from sector;
	ELSE
		SELECT array_agg(sector_id) INTO v_sector_list FROM  sector WHERE sector_id = v_sector;
	END IF;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3102", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3726", "function":"3102", "parameters":{"v_target_name":"'||v_target_name||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3728", "function":"3102", "parameters":{"v_action":"'||v_action||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4028", "function":"3102", "parameters":{"v_sector_name":"'||quote_nullable(v_sector_name)||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3730", "function":"3102", "parameters":{"v_source_name":"'||v_source_name||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3134", "fid":"'||v_fid||'", "criticity":"3", "is_process":true, "is_header":"true", "label_id":"3003", "separator_id":"2008"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3134", "fid":"'||v_fid||'", "criticity":"2", "is_process":true, "is_header":"true", "label_id":"3002", "separator_id":"2009"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3134", "fid":"'||v_fid||'", "criticity":"1", "is_process":true, "is_header":"true", "label_id":"3001", "separator_id":"2009"}}$$)';

	IF v_copyfrom = v_target AND v_action NOT IN ('INSERT-ONLY','DELETE-ONLY') THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3754", "function":"3102", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"3", "is_process":true}}$$)';

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3724", "function":"3102", "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"3", "prefix_id":"1003", "is_process":true}}$$)';

	else

		FOREACH rec IN ARRAY(v_sector_list) LOOP

			v_sector = rec;
			v_sector_name := (SELECT name FROM sector WHERE sector_id = v_sector);

			FOR object_rec IN SELECT json_array_elements_text('["dwf"]'::json) as table,
						json_array_elements_text('["node_id"]'::json) as pk,
						json_array_elements_text('["node_id, value, pat1, pat2, pat3, pat4"]'::json) as column

			LOOP
				IF v_action = 'DELETE-COPY' THEN

					EXECUTE 'DELETE FROM inp_'||object_rec.table||' WHERE dwfscenario_id = '||v_target;

					-- get message
					GET DIAGNOSTICS v_count = row_count;
					IF v_count > 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3744", "function":"3102", "parameters":{"v_count":"'||v_count||'", "object_rec":"'||object_rec.table||'"}, "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"2", "prefix_id":"1002", "is_process":true}}$$)';
					END IF;
				END IF;

				IF v_action = 'KEEP-COPY' OR  v_action = 'DELETE-COPY' THEN

					-- get message
					EXECUTE 'SELECT count(*) FROM inp_'||object_rec.table||' WHERE dwfscenario_id = '||v_target INTO v_count;
					IF v_count > 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4030", "function":"3102", "parameters":{"v_count":"'||v_count||'", "object_rec":"'||object_rec.table||'"}, "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';

					END IF;

					v_querytext = 'INSERT INTO inp_'||object_rec.table||' SELECT '||object_rec.column||', '||v_target||' FROM inp_'||object_rec.table||' t JOIN node USING (node_id)
					WHERE dwfscenario_id = '||v_copyfrom||' AND sector_id = '||v_sector||
					' ON CONFLICT (dwfscenario_id, '||object_rec.pk||') DO NOTHING';
					RAISE NOTICE 'v_querytext %', v_querytext;
					EXECUTE v_querytext;

					-- get message
					GET DIAGNOSTICS v_count2 = row_count;
					IF v_count > 0 AND v_count2 = 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4032", "function":"3102", "parameters":{"object_rec":"'||object_rec.table||'"}, "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';

					ELSIF v_count2 > 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4034", "function":"3102", "parameters":{"object_rec":"'||object_rec.table||'", "v_count2":"'||v_count2||'"}, "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';
					END IF;

				ELSIF v_action = 'DELETE-ONLY' THEN

					EXECUTE 'DELETE FROM inp_'||object_rec.table||' WHERE dwfscenario_id = '||v_target;

					-- get message
					GET DIAGNOSTICS v_count = row_count;
					IF v_count > 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4036", "function":"3102", "parameters":{"object_rec":"'||object_rec.table||'", "v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';
					END IF;

				ELSIF v_action = 'INSERT-ONLY' THEN

					INSERT INTO inp_dwf (node_id, dwfscenario_id) SELECT node_id, v_target FROM ve_inp_junction
					ON CONFLICT (node_id, dwfscenario_id) DO NOTHING;

					-- get message
					GET DIAGNOSTICS v_count = row_count;
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4038", "function":"3102", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';

				END IF;
			END LOOP;
		end loop;
		-- set selector
		UPDATE config_param_user SET value = v_target WHERE parameter = 'inp_options_dwfscenario_current' AND cur_user = current_user;

	END IF;

	-- insert spacers
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, concat(''));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, concat(''));

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3102, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;