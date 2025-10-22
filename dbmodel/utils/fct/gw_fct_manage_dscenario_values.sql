/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3042

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_manage_dscenario_values(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_manage_dscenario_values($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"parameters":{"target":"1", "copyFrom":"2", "action":"DELETE-COPY"}}}$$)
SELECT SCHEMA_NAME.gw_fct_manage_dscenario_values($${"client":{"device":4, "lang":"EN", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"source":"1", "action":"DELETE-COPY", "copyFrom":"2"}}}$$);
SELECT SCHEMA_NAME.gw_fct_manage_dscenario_values($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"parameters":{"target":2, "copyFrom":1, "action":"KEEP-COPY"}}}$$)
SELECT SCHEMA_NAME.gw_fct_manage_dscenario_values($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"parameters":{"target":2, "copyFrom":1, "action":"DELETE-ONLY}}}$$)


-- fid: 403

*/


DECLARE

object_rec record;

v_version text;
v_result json;
v_result_info json;
v_copyfrom integer;
v_target integer;
v_error_context text;
v_count integer;
v_count2 integer;
v_projecttype text;
v_fid integer = 403;
v_source_name text;
v_target_name text;
v_action text;
v_querytext text;
v_result_id text = null;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_copyfrom :=  ((p_data ->>'data')::json->>'parameters')::json->>'copyFrom';
	v_target :=  ((p_data ->>'data')::json->>'parameters')::json->>'target';
	v_action :=  ((p_data ->>'data')::json->>'parameters')::json->>'action';

	-- getting scenario name
	v_source_name := (SELECT name FROM cat_dscenario WHERE dscenario_id = v_copyfrom);
	v_target_name := (SELECT name FROM cat_dscenario WHERE dscenario_id = v_target);

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3042", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3726", "function":"3042", "parameters":{"v_target_name":"'||quote_nullable(v_target_name)||'"}, "fid":"403", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3728", "function":"3042", "parameters":{"v_action":"'||quote_nullable(v_action)||'"}, "fid":"403", "criticity":"4", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3730", "function":"3042", "parameters":{"v_source_name":"'||quote_nullable(v_source_name)||'"}, "fid":"403", "criticity":"4", "is_process":true}}$$)';


	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3042", "fid":"'||v_fid||'", "criticity":"3", "is_process":true, "is_header":"true", "label_id":"3003", "separator_id":"2008"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3042", "fid":"'||v_fid||'", "criticity":"2", "is_process":true, "is_header":"true", "label_id":"3002", "separator_id":"2009"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3042", "fid":"'||v_fid||'", "criticity":"1", "is_process":true, "is_header":"true", "label_id":"1001", "separator_id":"2009"}}$$)';

	IF v_copyfrom = v_target AND v_action NOT IN ('INSERT-ONLY','DELETE-ONLY') THEN

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3756", "function":"3042", "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"3", "is_process":true}}$$)';

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3724", "function":"3042", "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"3", "prefix_id":"1003", "is_process":true}}$$)';

	ELSE

		-- check dscenario type
		IF v_action NOT IN ('INSERT-ONLY','DELETE-ONLY') THEN
			IF (SELECT dscenario_type FROM cat_dscenario WHERE dscenario_id = v_copyfrom) != (SELECT dscenario_type FROM cat_dscenario WHERE dscenario_id = v_target) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3732", "function":"3042", "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"2", "prefix_id":"1002", "is_process":true}}$$)';

			ELSE
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3734", "function":"3042", "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"1", "prefix_id":"1001", "is_process":true}}$$)';

			END IF;
		END IF;

		-- Computing process
		IF v_projecttype = 'UD' THEN

			FOR object_rec IN SELECT elem AS table, '' AS pk, '' AS column FROM  json_array_elements_text(
                (SELECT json_agg(suffix)::json
                FROM (
                    SELECT DISTINCT substring(table_name FROM 'inp_dscenario_(.*)$') AS suffix
                    FROM information_schema.tables
                    WHERE table_schema = 'SCHEMA_NAME' AND table_name  LIKE 'inp_dscenario_%'
                ) s
              )
          ) AS j(elem)
			LOOP

				SELECT string_agg(value, ',') AS column_list INTO object_rec.pk FROM
					(SELECT json_array_elements_text(json_agg(a.attname)::json) AS pk FROM pg_index i
					JOIN pg_class t ON t.oid = i.indrelid
					JOIN pg_namespace n ON n.oid = t.relnamespace
					JOIN pg_attribute a ON a.attrelid = t.oid AND a.attnum = ANY(i.indkey)
				WHERE i.indisprimary AND t.relname = 'inp_dscenario_'||object_rec.table AND n.nspname = 'SCHEMA_NAME' AND a.attname <> 'dscenario_id') as t(value);

				SELECT string_agg(value, ',') AS column_list INTO object_rec.column FROM
				json_array_elements_text(
					(SELECT json_agg(column_name)::json FROM information_schema.columns
					WHERE table_schema = 'SCHEMA_NAME' AND table_name = 'inp_dscenario_'||object_rec.table AND column_name <> 'dscenario_id')) AS t(value);

				IF v_action = 'DELETE-COPY' THEN
					EXECUTE 'DELETE FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_target;

					-- get message
					GET DIAGNOSTICS v_count = row_count;
					IF v_count > 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3736", "function":"3042", "parameters":{"v_count":"'||v_count||'", "object_rec":"'||object_rec.table||'"}, "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"2", "prefix_id":"1002", "is_process":true}}$$)';

					END IF;
				END IF;

				IF v_action = 'KEEP-COPY' OR  v_action = 'DELETE-COPY' THEN

					-- get message
					EXECUTE 'SELECT count(*) FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_target INTO v_count;
					IF v_count > 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3738", "function":"3042", "parameters":{"v_count":"'||v_count||'", "object_rec":"'||object_rec.table||'"}, "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"2", "prefix_id":"1001", "is_process":true}}$$)';


					END IF;

					IF object_rec.table = 'controls' THEN
						v_querytext = 'INSERT INTO inp_dscenario_'||object_rec.table||' SELECT '||v_target||','||object_rec.column||' 
						FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_copyfrom||
						' ON CONFLICT ('||object_rec.pk||') DO NOTHING';
					EXECUTE v_querytext;
					ELSE
						v_querytext = 'INSERT INTO inp_dscenario_'||object_rec.table||' SELECT '||v_target||','||object_rec.column||' 
						FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_copyfrom||
						' ON CONFLICT (dscenario_id, '||object_rec.pk||') DO NOTHING';
						EXECUTE v_querytext;
					END IF;

					-- get message
					GET DIAGNOSTICS v_count2 = row_count;
					IF v_count > 0 AND v_count2 = 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3740", "function":"3042", "parameters":{"object_rec":"'||object_rec.table||'"}, "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"2", "prefix_id":"1001", "is_process":true}}$$)';

					ELSIF v_count2 > 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3742", "function":"3042", "parameters":{"v_count2":"'||v_count2||'", "object_rec":"'||object_rec.table||'"}, "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"2", "prefix_id":"1001", "is_process":true}}$$)';

					END IF;
				END IF;
			END LOOP;

		ELSIF v_projecttype = 'WS' THEN

			FOR object_rec IN SELECT elem AS table, '' AS pk, '' AS column FROM  json_array_elements_text(
                (SELECT json_agg(suffix)::json
                FROM (
                    SELECT DISTINCT substring(table_name FROM 'inp_dscenario_(.*)$') AS suffix
                    FROM information_schema.tables
                    WHERE table_schema = 'SCHEMA_NAME' AND table_name  LIKE 'inp_dscenario_%'
                ) s
              )
          ) AS j(elem)
			LOOP

				SELECT string_agg(value, ',') AS column_list INTO object_rec.pk FROM
					(SELECT json_array_elements_text(json_agg(a.attname)::json) AS pk FROM pg_index i
					JOIN pg_class t ON t.oid = i.indrelid
					JOIN pg_namespace n ON n.oid = t.relnamespace
					JOIN pg_attribute a ON a.attrelid = t.oid AND a.attnum = ANY(i.indkey)
				WHERE i.indisprimary AND t.relname = 'inp_dscenario_'||object_rec.table AND n.nspname = 'SCHEMA_NAME' AND a.attname <> 'dscenario_id') as t(value);

				SELECT string_agg(value, ',') AS column_list INTO object_rec.column FROM
				json_array_elements_text(
					(SELECT json_agg(column_name)::json FROM information_schema.columns
					WHERE table_schema = 'SCHEMA_NAME' AND table_name = 'inp_dscenario_'||object_rec.table AND column_name <> 'dscenario_id')) AS t(value);

				IF v_action = 'DELETE-COPY' THEN

					EXECUTE 'DELETE FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_target;

					-- get message
					GET DIAGNOSTICS v_count = row_count;
					IF v_count > 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3744", "function":"3042", "parameters":{"v_count":"'||v_count||'", "object_rec":"'||object_rec.table||'"}, "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"2", "prefix_id":"1001", "is_process":true}}$$)';

					END IF;
				END IF;

				IF v_action = 'KEEP-COPY' OR  v_action = 'DELETE-COPY' THEN

					-- get message
					EXECUTE 'SELECT count(*) FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_target INTO v_count;
					IF v_count > 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3746", "function":"3042", "parameters":{"v_count":"'||v_count||'", "object_rec":"'||object_rec.table||'"}, "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"2", "prefix_id":"1001", "is_process":true}}$$)';

					END IF;

					IF object_rec.table = 'demand' THEN -- it is not possible to parametrize due table structure (dscenario_id is not first column)
						INSERT INTO inp_dscenario_demand (dscenario_id, feature_id, feature_type, demand, pattern_id, demand_type, source)
						SELECT v_target, feature_id, feature_type, demand, pattern_id, demand_type, source
						FROM inp_dscenario_demand WHERE dscenario_id = v_copyfrom;
					ELSIF object_rec.table IN ('controls', 'pump_additional', 'rules') THEN
						v_querytext = 'INSERT INTO inp_dscenario_'||object_rec.table||' SELECT '||v_target||','||object_rec.column||' 
						FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_copyfrom||
						' ON CONFLICT ('||object_rec.pk||') DO NOTHING';
					ELSE
						v_querytext = 'INSERT INTO inp_dscenario_'||object_rec.table||' SELECT '||v_target||','||object_rec.column||' 
						FROM inp_dscenario_'||object_rec.table||' WHERE dscenario_id = '||v_copyfrom||
						' ON CONFLICT (dscenario_id, '||object_rec.pk||') DO NOTHING';
						EXECUTE v_querytext;
					END IF;

					-- get message
					GET DIAGNOSTICS v_count2 = row_count;
					IF v_count > 0 AND v_count2 = 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3748", "function":"3042", "parameters":{"object_rec":"'||object_rec.table||'"}, "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"2", "prefix_id":"1001", "is_process":true}}$$)';

					ELSIF v_count2 > 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3750", "function":"3042", "parameters":{"object_rec.table":"'||object_rec.table||'"}, "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"2", "prefix_id":"1001", "is_process":true}}$$)';
					END IF;
				END IF;
			END LOOP;
		END IF;

		IF v_action = 'DELETE-ONLY' THEN

			EXECUTE 'DELETE FROM cat_dscenario WHERE dscenario_id = '||v_target;

			-- get message
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3752", "function":"3042", "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"2", "prefix_id":"1001", "is_process":true}}$$)';

		END IF;

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3700", "function":"3042", "fid":"403", "result_id":"'||quote_nullable(v_result_id)||'", "criticity":"2", "is_process":true}}$$)';


		-- set selector
		IF v_action != 'DELETE-ONLY' THEN
			INSERT INTO selector_inp_dscenario (dscenario_id,cur_user) VALUES (v_target, current_user) ON CONFLICT (dscenario_id,cur_user) DO NOTHING ;
		END IF;
	END IF;

	-- insert spacers
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, concat(''));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, concat(''));

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3042, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;