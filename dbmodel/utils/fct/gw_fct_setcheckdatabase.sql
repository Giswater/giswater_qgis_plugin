/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
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
v_rectable record;
v_version text;
v_epsg integer;
v_return json;
v_schemaname text;
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
v_verified_exceptions boolean = true;
v_fid integer = 604;

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
	v_plancheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'tab_data_master_check';
	v_admincheck :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'tab_data_admin_check';

	-- get system parameters in case input parameter is null
	IF v_verified_exceptions IS NULL THEN SELECT value::json->>'verifiedExceptions' INTO v_verified_exceptions 
	   FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_omcheck IS NULL THEN SELECT value::json->>'omCheck' INTO v_omcheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_graphcheck IS NULL THEN SELECT value::json->>'graphCheck' INTO v_graphcheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_epacheck IS NULL THEN SELECT value::json->>'epaCheck' INTO v_epacheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_plancheck IS NULL THEN SELECT value::json->>'planCheck' INTO v_plancheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;
	IF v_admincheck IS NULL THEN SELECT value::json->>'adminCheck' INTO v_admincheck FROM config_param_system WHERE parameter = 'admin_checkproject'; END IF;

	-- create temp tables
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"LOG"}}}$$)';
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"ANL"}}}$$)';
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"OMCHECK"}}}$$)';
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"MAPZONES", "subGroup":"ALL"}}}$$)';

	-- create log tables
	EXECUTE 'SELECT gw_fct_create_logtables($${"data":{"parameters":{"fid":604}}}$$::json)';

	-- starting check process
	IF 'role_om' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) AND v_omcheck THEN
		EXECUTE 'SELECT gw_fct_om_check_data($${"data":{"parameters":{"fid":'||v_fid||', "isEmbebed":true}}}$$)';
	END IF;

	IF 'role_epa' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) AND v_epacheck THEN
		EXECUTE 'SELECT gw_fct_pg2epa_check_data($${"data":{"parameters":{"fid":'||v_fid||', "isEmbebed":true}}}$$)';
	END IF;

	IF 'role_master' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) AND v_plancheck THEN
		EXECUTE 'SELECT gw_fct_plan_check_data($${"data":{"parameters":{"fid":'||v_fid||', "isEmbebed":true}}}$$)';
	END IF;
	
	IF 'role_admin' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) AND v_admincheck THEN
		EXECUTE 'SELECT gw_fct_admin_check_data($${"data":{"parameters":{"fid":'||v_fid||', "isEmbebed":true}}}$$)';
	END IF; 

	--EXECUTE 'SELECT gw_fct_user_check_data($${"data":{"parameters":{"fid":'||v_fid||', "isEmbebed":true}}}$$)';
	
	-- create return
	EXECUTE 'SELECT gw_fct_create_return($${"data":{"parameters":{"functionId":3364, "isEmbebed":false}}}$$::json)' INTO v_return;
	
	-- drop temp tables
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"LOG"}}}$$)';
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"ANL"}}}$$)';
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"OMCHECK"}}}$$)';
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"EPAMAIN"}}}$$)';
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"MAPZONES", "subGroup":"ALL"}}}$$)';

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
 