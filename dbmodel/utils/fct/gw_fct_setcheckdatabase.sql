/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3364

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setcheckdatabase (p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_setcheckdatabase($${"data":{"parameters":{"omCheck":true, "graphCheck":false, "epaCheck":false, "planCheck":false, "adminCheck":false, "verifiedExceptions":false}}}$$);

fid  =604
*/

DECLARE

v_project_type text;
v_version text;
v_epsg integer;
v_return json;
v_schemaname text;
v_error_context text;

v_verified_exceptions boolean = true;
v_omcheck boolean = true;
v_graphcheck boolean = true;
v_epacheck boolean = true;
v_plancheck boolean = true;
v_admincheck boolean = true;

v_fid integer = 604;

v_querytext TEXT;
v_rec record;
v_result_info JSON;
v_result_point JSON;
v_result_line JSON;
v_result_polygon JSON;
v_rec_mapzone record;
v_rec_check record;
v_mapzones TEXT;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	SELECT project_type, giswater, epsg INTO v_project_type, v_version, v_epsg FROM sys_version order by id desc limit 1;

	-- Get input parameters
	v_verified_exceptions := ((p_data ->> 'data')::json->>'parameters')::json->> 'tab_data_verified_exceptions';
	v_omcheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'tab_data_om_check';
	v_graphcheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'tab_data_graph_check';
	v_epacheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'tab_data_epa_check';
	v_plancheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'tab_data_plan_check';
	v_admincheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'tab_data_admin_check';

	-- get system parameters in case input parameter is null
/*
	IF v_verified_exceptions IS NULL THEN SELECT value::json->>'verifiedExceptions' INTO v_verified_exceptions
	   FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_omcheck IS NULL THEN SELECT value::json->>'omCheck' INTO v_omcheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_graphcheck IS NULL THEN SELECT value::json->>'graphCheck' INTO v_graphcheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_epacheck IS NULL THEN SELECT value::json->>'epaCheck' INTO v_epacheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_plancheck IS NULL THEN SELECT value::json->>'planCheck' INTO v_plancheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_admincheck IS NULL THEN SELECT value::json->>'adminCheck' INTO v_admincheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;

*/
	-- create temp tables
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"EPA"}}}$$)';
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"LOG"}}}$$)';
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"ANL"}}}$$)';
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"OMCHECK"}}}$$)';
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"MAPZONES", "subGroup":"ALL"}}}$$)';

	-- create log tables
	EXECUTE 'SELECT gw_fct_create_logtables($${"data":{"parameters":{"fid":604}}}$$::json)';


	CREATE TEMP TABLE t_temp_values AS
	SELECT 'v_omcheck', 'om_check' AS check_data, v_omcheck AS val UNION
	SELECT 'v_graphcheck', 'graph_check' AS check_data, v_graphcheck AS val UNION
	SELECT 'v_epacheck', 'pg2epa_check' as check_data, v_epacheck AS val UNION
	SELECT 'v_plancheck', 'plan_check' as check_data, v_plancheck AS val UNION
	SELECT 'v_admincheck', 'admin_check' AS check_data, v_admincheck AS val;


	-- build query for generic cases
	FOR v_rec_check IN SELECT check_data FROM t_temp_values WHERE val IS TRUE
	LOOP

		v_querytext = '
			SELECT * FROM sys_fprocess 
			WHERE project_type IN (LOWER('||quote_literal(v_project_type)||'), ''utils'') 
			AND query_text NOT ILIKE ''%v_graphClass%''
			AND (addparam IS NULL 
			AND query_text IS NOT NULL 
			AND function_name ILIKE ''%'||v_rec_check.check_data||'%'')
			AND active
			ORDER BY fid ASC';

		FOR v_rec IN EXECUTE v_querytext
		LOOP

			EXECUTE 'SELECT gw_fct_check_fprocess($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
		    "form":{},"feature":{},"data":{"parameters":{"functionFid": '||v_fid||', "checkFid":"'||v_rec.fid||'"}}}$$)';

		END LOOP;

	END LOOP;

	-- build query for (mapzones)
	IF v_graphcheck THEN

		v_querytext = '
		SELECT * FROM sys_fprocess 
		WHERE project_type IN (LOWER('||quote_literal(v_project_type)||'), ''utils'') 
		AND (addparam IS NULL 
		AND query_text ILIKE ''%v_graphClass%'')
		AND active
		ORDER BY fid ASC
		';

		IF lower(v_project_type) = 'ws' THEN
			v_mapzones = 'SELECT unnest(ARRAY[''sector'', ''dma'', ''dqa'', ''presszone'']) AS mec';

		ELSIF lower(v_project_type) = 'ud' THEN
			v_mapzones = 'SELECT unnest(ARRAY[''sector'', ''drainzone'']) AS mec';

		END IF;


		FOR v_rec IN EXECUTE v_querytext
		LOOP

			FOR v_rec_mapzone IN EXECUTE v_mapzones
			LOOP

				EXECUTE 'SELECT gw_fct_check_fprocess($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
		    	"form":{},"feature":{},"data":{"parameters":{"functionFid": '||v_fid||', "checkFid":"'||v_rec.fid||'", "graphClass":"'||v_rec_mapzone.mec||'"}}}$$)';

			END LOOP;

		END LOOP;

	END IF;

	EXECUTE 'SELECT gw_fct_user_check_data($${"data":{"parameters":{"fid":'||v_fid||', "isEmbebed":true, "isAudit":true, "checkType": "Project"}}}$$)';

	-- create json return to send client
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"info"}}}$$::json)' INTO v_result_info;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"point"}}}$$::json)' INTO v_result_point;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"line"}}}$$::json)' INTO v_result_line;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"polygon"}}}$$::json)' INTO v_result_polygon;

	-- drop temp tables
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"ANL"}}}$$)';

	-- Drop possible duplicated values (if temp table exists)
	IF to_regclass('pg_temp.t_audit_check_data') IS NOT NULL THEN
  	
		DELETE FROM t_audit_check_data WHERE id IN (
			WITH mec AS (
				SELECT id, ROW_NUMBER() OVER(PARTITION BY error_message ORDER BY error_message) AS rowid
				FROM t_audit_check_data WHERE cur_user = current_user
			) SELECT id FROM mec WHERE rowid = 2
		);

	END IF;

	DROP TABLE IF EXISTS t_temp_values;

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||
		       '}'||
	    '}}')::json, 2670, null, null, null);

	--  Exception handling
	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	--RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE',
	--SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
