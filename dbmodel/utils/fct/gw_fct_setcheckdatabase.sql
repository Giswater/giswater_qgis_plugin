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
SELECT ws40000.gw_fct_setcheckdatabase($${"data":{"parameters":{"omCheck":true, "graphCheck":false, "epaCheck":false, "planCheck":false, "adminCheck":false, "ignoreVerifiedExceptions":false}}}$$);

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
v_omcheck boolean = true;
v_graphcheck boolean = true;
v_epacheck boolean = true;
v_plancheck boolean = true;
v_admincheck boolean = true;
v_ignore_verified_exceptions boolean = true;
v_fid integer = 604;

BEGIN

	-- search path
	SET search_path = "ws40000", public;
	v_schemaname = 'ws40000';

	SELECT project_type, giswater, epsg INTO v_project_type, v_version, v_epsg FROM sys_version order by id desc limit 1;

	-- Get input parameters
	v_ignore_verified_exceptions := ((p_data ->> 'data')::json->>'parameters')::json->> 'ignoreVerifiedExceptions';
	v_omcheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'omCheck';
	v_graphcheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'omCheck';
	v_epacheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'epaCheck';
	v_plancheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'planCheck';
	v_admincheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'adminCheck';

	-- get system parameters in case input parameter is null
	IF v_ignore_verified_exceptions IS NULL THEN SELECT value::json->>'ignoreVerifiedExceptions' INTO v_ignore_verified_exceptions 
	   FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_omcheck IS NULL THEN SELECT value::json->>'omCheck' INTO v_omcheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_graphcheck IS NULL THEN SELECT value::json->>'graphCheck' INTO v_graphcheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_epacheck IS NULL THEN SELECT value::json->>'epaCheck' INTO v_epacheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_plancheck IS NULL THEN SELECT value::json->>'planCheck' INTO v_plancheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_admincheck IS NULL THEN SELECT value::json->>'adminCheck' INTO v_admincheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;

	-- create log tables
	EXECUTE 'SELECT gw_fct_create_logtables($${"data":{"parameters":{"fid":604}}}$$::json)';

	-- create query tables
	EXECUTE 'SELECT gw_fct_create_querytables($${"data":{"parameters":{"fid":604, 
				"omCheck":'||v_omcheck||', "graphCheck":'||v_graphcheck||', "epaCheck":'||v_epacheck||', "planCheck":'||
				v_plancheck||', "adminCheck":'||v_omcheck||', "ignoreVerifiedExceptions":'||v_ignore_verified_exceptions||'}}}$$::json)';

	-- starting check process
	IF 'role_om' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) AND v_omcheck THEN
		EXECUTE 'SELECT gw_fct_om_check_data($${"data":{"parameters":{"fid":'||v_fid||'}}}$$)';
	END IF;

	IF 'role_epa' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) AND v_epacheck THEN
		EXECUTE 'SELECT gw_fct_pg2epa_check_data($${"data":{"parameters":{"fid":'||v_fid||'}}}$$)';
	END IF;
	IF 'role_master' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) AND v_plancheck THEN		EXECUTE 'SELECT gw_fct_plan_check_data($${"data":{"parameters":{"fid":'||v_fid||'}}}$$)';
	END IF;	
	IF 'role_admin' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) AND v_admincheck THEN
		EXECUTE 'SELECT gw_fct_admin_check_data($${"data":{"parameters":{"fid":'||v_fid||'}}}$$)';
	END IF; 

	EXECUTE 'SELECT gw_fct_user_check_data($${"data":{"parameters":{"fid":'||v_fid||'}}}$$)';

	-- materialize tables
	PERFORM gw_fct_create_logreturn($${"data":{"parameters":{"type":"fillExcepTables"}}}$$::json);

	-- create json return to send client
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"info"}}}$$::json)' INTO v_result_info;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"point"}}}$$::json)' INTO v_result_point;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"line"}}}$$::json)' INTO v_result_line;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"polygon"}}}$$::json)' INTO v_result_polygon;

	--return definition
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
 