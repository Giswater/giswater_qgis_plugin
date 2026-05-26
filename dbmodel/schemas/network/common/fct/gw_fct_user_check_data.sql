/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2998

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_user_check_data(p_data json)
RETURNS json AS

/*
EXAMPLE

SELECT SCHEMA_NAME.gw_fct_user_check_data($${"client":
{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{"checkType":"Project","isAudit":true, "selectionMode":"userSelectors"}}}$$)::text

--Project - audit_check_project - only errors
--User - errors and info
--isAudit - errors and info for statistics (data copied to audit_fid_log)

-- fid: 251

*/

$BODY$

DECLARE
v_schemaname text;
v_count integer;
v_countquery text;
v_project_type text;
v_version text;
v_criticity integer;
v_error_val integer;
v_warning_val integer;
v_groupby text;
json_result json[];
rec_result text;
v_log_project text;
rec record;
v_target text;
v_infotext text;
rec_selector json;
v_selector_value json;
v_selector_name text;
v_selection_mode text;
v_cur_expl json;

v_result_id text;
v_result text;
v_result_info json;
v_error_context text;
v_isaudit boolean;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	v_schemaname = 'SCHEMA_NAME';

	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	v_log_project = json_extract_path_text(p_data,'data','parameters','checkType');
	v_isaudit = json_extract_path_text(p_data,'data','parameters','isAudit')::boolean;
	v_selection_mode = json_extract_path_text(p_data,'data','parameters','selectionMode')::text;

	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":251, "project_type":"'||v_project_type||'", "action":"CREATE", "group":"USERCHECK"}}}$$)';

	--if in schema audit doesnt exist or doesnt have table audit_fid_log - switch off audit option
	IF v_isaudit IS TRUE and
	(SELECT EXISTS (SELECT FROM information_schema.tables WHERE  table_schema = 'audit' AND table_name = 'audit_fid_log')) is false THEN
		v_isaudit=FALSE;
	END IF;

	--if project check is executed look only for possible errors, if it's users check - look for info and errors
	IF v_log_project = 'Project' THEN
		v_target= '''ERROR'',''DATA''';
	ELSE
		v_target = '''ERROR'',''INFO''';
	END IF;

	-- init variables
	v_count=0;

	-- delete old values on result table
	DELETE FROM t_audit_check_data WHERE fid=251 AND cur_user=current_user;

	-- save state & expl selector
	IF v_selection_mode !='userSelectors' THEN
		DELETE FROM temp_table WHERE fid=251 AND cur_user=current_user;
		INSERT INTO temp_table (fid, addparam)
		SELECT 251, json_agg(s.selector_conf)  FROM (
		select jsonb_build_object('selector_expl', array_agg(expl_id))  as selector_conf
		FROM selector_expl where cur_user=current_user
		UNION
		select jsonb_build_object('selector_state', array_agg(state_id)) as selector_conf
		FROM selector_state where cur_user=current_user)s;


		INSERT INTO selector_state (state_id) SELECT id FROM value_state ON conflict(state_id, cur_user) DO NOTHING;
		INSERT INTO selector_expl (expl_id) SELECT expl_id FROM exploitation ON conflict(expl_id, cur_user) DO NOTHING;

		EXECUTE 'SELECT array_to_json(array_agg(a.expl_id::text))
		FROM (SELECT expl_id FROM exploitation WHERE expl_id > 0) a'
		INTO v_cur_expl;

	ELSE
		EXECUTE 'SELECT array_to_json(array_agg(a.expl_id::text))
		FROM (SELECT expl_id FROM selector_expl WHERE cur_user=current_user) a'
		INTO v_cur_expl;
	END IF;

	FOR rec IN EXECUTE 'SELECT * FROM config_fprocess WHERE fid::text ILIKE ''9%'' AND target IN ('||v_target||') AND active IS TRUE ORDER BY orderby' LOOP

		SELECT (rec.addparam::json ->> 'criticityLimits')::json->> 'warning' INTO v_warning_val;
		SELECT (rec.addparam::json ->> 'criticityLimits')::json->> 'error' INTO v_error_val;
		SELECT (rec.addparam::json ->> 'groupBy') INTO v_groupby;

		IF v_groupby IS NULL THEN
			EXECUTE rec.querytext
			INTO v_countquery;

		ELSE
			EXECUTE 'SELECT array_agg(features.feature) FROM (
			SELECT jsonb_build_object(
			''fcount'',   a.count,
			''groupBy'', a.'||v_groupby||') AS feature
			FROM ('||rec.querytext||')a) features;'
			INTO json_result;
		END IF;

		v_count = round(v_countquery::float);

		IF rec.target = 'ERROR' THEN
			IF v_count::integer < v_warning_val THEN
				v_criticity = 1;
				v_infotext = 'INFO: ';
			ELSIF  v_count::integer >= v_warning_val AND  v_count::integer < v_error_val THEN
				v_criticity = 2;
				v_infotext = concat('WARNING-',rec.fid,':');
			ELSE
				v_criticity = 3;
				v_infotext = concat('ERROR-',rec.fid,':');
			END IF;
		ELSIF rec.target = 'DATA' THEN
			v_criticity = 0;
			v_infotext = concat('DATA-',rec.fid,':');
		ELSE
			v_criticity = 0;
			v_infotext  = 'INFO: ';
		END IF;

		IF v_groupby IS NULL THEN
			IF v_isaudit IS TRUE THEN
				INSERT INTO audit.audit_fid_log (fid, type, fprocess_name, fcount, criticity, source)
				SELECT rec.fid, s.fprocess_type, s.fprocess_name, v_count::integer, v_criticity, jsonb_build_object('schema','SCHEMA_NAME', 'expl_id',v_cur_expl)
				FROM sys_fprocess s
				WHERE s.isaudit IS TRUE AND rec.fid=s.fid;
			END IF;
			INSERT INTO t_audit_check_data(fid, result_id, criticity, error_message,  fcount)
			SELECT 251,rec.fid, v_criticity, concat(v_infotext,sys_fprocess.fprocess_name, ': ',v_count), v_count::integer
			FROM sys_fprocess WHERE sys_fprocess.fid = rec.fid;

		ELSIF json_result IS NOT NULL AND v_groupby IS NOT NULL THEN
			FOREACH rec_result IN ARRAY(json_result) LOOP

				IF v_isaudit IS TRUE  THEN
					INSERT INTO audit_fid_log (fid, type, fprocess_name, fcount, criticity, groupby, source)
					SELECT rec.fid, s.fprocess_type, s.fprocess_name,  (rec_result::json ->> 'fcount')::integer, v_criticity, (rec_result::json ->>'groupBy'), jsonb_build_object('schema','SCHEMA_NAME', 'expl_id',v_cur_expl)
					FROM sys_fprocess s
					WHERE s.isaudit IS TRUE AND rec.fid=s.fid;
				END IF;

				INSERT INTO t_audit_check_data(fid, result_id, criticity, error_message, fcount)
				SELECT 251,rec.fid, v_criticity, concat(v_infotext,sys_fprocess.fprocess_name,' - ',(rec_result::json ->>'groupBy'),': ',(rec_result::json ->> 'fcount')), (rec_result::json ->> 'fcount')::integer
				FROM sys_fprocess WHERE sys_fprocess.fid = rec.fid;
			END LOOP;
		END IF;
	END LOOP;

	--restore selectors
	IF v_selection_mode !='userSelectors' THEN
		FOR rec_selector IN (select json_array_elements(addparam) from temp_table where fid=251) LOOP

			v_selector_name = json_object_keys(rec_selector);

			--remove values for selector
			EXECUTE 'DELETE FROM '||v_selector_name||' WHERE cur_user = current_user;';

			v_selector_value = json_extract_path_text(rec_selector,v_selector_name);
		--insert previous values for selector
			EXECUTE 'INSERT INTO '||v_selector_name||'
			SELECT value::integer, current_user FROM json_array_elements_text('''||v_selector_value||''')';
		END LOOP;
	END IF;

	--copy errors results from project check
	IF v_log_project = 'Project' AND v_isaudit IS TRUE THEN
		INSERT INTO audit.audit_fid_log (fid, type, fprocess_name, fcount, criticity, source)
		SELECT result_id::integer, f.fprocess_type, f.fprocess_name, fcount, criticity, jsonb_build_object('schema','SCHEMA_NAME', 'expl_id',v_cur_expl)
		FROM t_audit_check_data a
		JOIN sys_fprocess f ON f.fid=result_id::integer
		WHERE a.fid=604 AND cur_user = current_user
		AND ((criticity IN (2,3) AND (error_message ILIKE 'ERROR-%' OR error_message ILIKE 'WARNING-%'))
		OR (criticity IN (0) AND (error_message ILIKE 'DATA%')))
		AND f.isaudit IS TRUE;

		INSERT INTO audit.anl_arc (arc_id, arccat_id, state, arc_id_aux, expl_id, fid, cur_user,
		the_geom, the_geom_p, descript, result_id, node_1, node_2, sys_type,
		code, source)
		SELECT arc_id, arccat_id, state, arc_id_aux, expl_id, fid, cur_user,
		the_geom, the_geom_p, descript, result_id, node_1, node_2, sys_type,
		code, jsonb_build_object('schema','SCHEMA_NAME', 'expl_id',expl_id)
		FROM t_anl_arc WHERE fid::text IN (SELECT DISTINCT result_id FROM t_audit_check_data WHERE fid=101 AND cur_user = current_user
		AND criticity IN (2,3) AND (error_message ILIKE 'ERROR-%' OR error_message ILIKE 'WARNING-%')) AND cur_user=current_user;

		INSERT INTO audit.anl_node (node_id, nodecat_id, state, num_arcs, node_id_aux, nodecat_id_aux,
		state_aux, expl_id, fid, cur_user, the_geom, arc_distance, arc_id,
		descript, result_id, sys_type, code, source)
		SELECT node_id, nodecat_id, state, num_arcs, node_id_aux, nodecat_id_aux,
		state_aux, expl_id, fid, cur_user, the_geom, arc_distance, arc_id,
		descript, result_id, sys_type, code, jsonb_build_object('schema','SCHEMA_NAME', 'expl_id',expl_id)
		FROM t_anl_node WHERE fid::text IN (SELECT DISTINCT result_id FROM t_audit_check_data WHERE fid=101 AND cur_user = current_user
		AND criticity IN (2,3) AND (error_message ILIKE 'ERROR-%' OR error_message ILIKE 'WARNING-%')) AND cur_user=current_user;

	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM t_audit_check_data WHERE cur_user="current_user"() AND fid=251 order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
			 ',"body":{"form":{}'||
			 ',"data":{ "info":'||v_result_info||'}}'||
		'}')::json, 2998, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
