/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3364

CREATE OR REPLACE FUNCTION ws40000.gw_fct_setcheckdatabase (p_data json)
  RETURNS json AS
$BODY$

/*
SELECT ws40000.gw_fct_setcheckdatabase($${"data":{"parameters":{"ignoreVerifiedExceptions":false}}}$$);

fid  =604
*/

DECLARE

v_project_type text;
v_rectable record;
v_version text;
v_epsg integer;
v_return json;
v_schemaname text;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result json;
v_result_info json;
v_error_context text;
v_projectrole text;
v_infotype text;
v_insert_fields json;
v_uservalues json;
v_ignoregraphanalytics boolean;
v_ignoreepa boolean;
v_ignoreplan boolean;
v_ignore_verified_exceptions boolean = true;
v_fid integer = 604;

BEGIN

	-- search path
	SET search_path = "ws40000", public;
	v_schemaname = 'ws40000';

	SELECT project_type, giswater, epsg INTO v_project_type, v_version, v_epsg FROM sys_version order by id desc limit 1;

	-- Get input parameters
	v_ignore_verified_exceptions := ((p_data ->> 'data')::json->>'parameters')::json->> 'ignoreVerifiedExceptions';

	-- get system parameters
	SELECT value::json->>'ignoreGraphanalytics' INTO v_ignoregraphanalytics FROM config_param_system WHERE parameter = 'admin_checkproject';
	SELECT value::json->>'ignorePlan' INTO v_ignoreplan FROM config_param_system WHERE parameter = 'admin_checkproject';
	SELECT value::json->>'ignoreEpa' INTO v_ignoreepa FROM config_param_system WHERE parameter = 'admin_checkproject';
	IF v_ignoregraphanalytics IS NULL THEN v_ignoregraphanalytics = FALSE; END IF;
	IF v_ignoreepa IS NULL THEN v_ignoreepa = FALSE; END IF;
	IF v_ignoreplan IS NULL THEN v_ignoreplan = FALSE; END IF;

	-- create temp tables
	EXECUTE 'SELECT gw_fct_create_checktables($${"data":{"parameters":{"fid":'||v_fid||',"ignoreVerifiedExceptions":'||v_ignore_verified_exceptions||'"}}}$$::json)';

	-- trigger check functions
	--IF 'role_om' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN
		EXECUTE 'SELECT gw_fct_om_check_data($${"data":{"parameters":{"fid":'||v_fid||'}}}$$)';
/*
		IF v_ignoregraphanalytics IS FALSE THEN 
			IF v_project_type = 'WS' THEN
				EXECUTE 'SELECT gw_fct_graphanalytics_check_data($${"data":{"parameters":{"fid":'||v_fid||'}}}$$)';
			END IF;
		END IF;
	END IF;
	
	IF 'role_epa' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN
		IF v_ignoreepa IS FALSE THEN
			EXECUTE 'SELECT gw_fct_pg2epa_check_data($${"data":{"parameters":{"fid":'||v_fid||'}}}$$)';
		END IF;
	END IF;
	IF 'role_master' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN		IF v_ignoreplan IS FALSE THEN
			EXECUTE 'SELECT gw_fct_plan_check_data($${"data":{"parameters":{"fid":'||v_fid||'}}}$$)';
		END IF;
	END IF;	
	IF 'role_admin' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN
		EXECUTE 'SELECT gw_fct_admin_check_data($${"data":{"parameters":{"fid":'||v_fid||'}}}$$)';
	END IF; 

	EXECUTE 'SELECT gw_fct_user_check_data($${"data":{"parameters":{"fid":'||v_fid||'}}}$$)';
	*/	

	-- materialize tables
	PERFORM gw_fct_create_logreturn($${"data":{"parameters":{"type":"fillExcepTables"}}}$$::json);

	-- create json return to send client
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"info"}}}$$::json)' INTO v_result_info;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"point"}}}$$::json)' INTO v_result_point;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"line"}}}$$::json)' INTO v_result_line;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"polygon"}}}$$::json)' INTO v_result_polygon;

	--return definition for v_audit_check_result
	v_return= ('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"
		,"body":{"form":{}'||
			',"data":{ "epsg":'||v_epsg||
			    ',"info":'||v_result_info||','||
					'"point":'||v_result_point||','||
					'"line":'||v_result_line||','||
					'"polygon":'||v_result_polygon||'}}}')::json;

	--  Return
	RETURN v_return;

	--  Exception handling
	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	--RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', 
	--SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 