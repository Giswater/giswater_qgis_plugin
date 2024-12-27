/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3362

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_create_checktables (p_data json)
  RETURNS json AS
$BODY$

/*
SELECT gw_fct_create_checktables('{"client":{}, "form":{}, "feature":{}, "data":{"ignoreVerifiedExceptions":true,"selectionMode":"userDomain", "checkPsectors":"userDomain"}}');

*/

DECLARE
v_fid integer;
v_schemaname text;
v_project_type text;
v_version text;
v_epsg integer;
v_error_context text;
v_return json= '{}';
v_selection_mode text;
v_ignore_verified_exceptions boolean = true;
v_checkpsectors text;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';
	
	-- Get input parameters
	v_ignore_verified_exceptions := ((p_data ->>'data')::json->>'parameters')::json->>'ignoreVerifiedExceptions';
	v_selection_mode := ((p_data ->>'data')::json->>'parameters')::json->>'selectionMode'::text;
	v_checkpsectors := ((p_data ->>'data')::json->>'parameters')::json->>'checkPsectors'::text;
	v_fid := (((p_data ->>'data')::json->>'parameters')::json->>'fid');
	
	-- create log tables
	CREATE TEMP TABLE IF NOT EXISTS t_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);
	CREATE TEMP TABLE IF NOT EXISTS t_audit_check_project (LIKE SCHEMA_NAME.audit_check_project INCLUDING ALL);
	CREATE TEMP TABLE IF NOT EXISTS t_anl_node (LIKE SCHEMA_NAME.anl_node INCLUDING ALL);
	CREATE TEMP TABLE IF NOT EXISTS t_anl_arc (LIKE SCHEMA_NAME.anl_arc INCLUDING ALL);
	CREATE TEMP TABLE IF NOT EXISTS t_anl_connec (LIKE SCHEMA_NAME.anl_connec INCLUDING ALL);
	CREATE TEMP TABLE IF NOT EXISTS t_anl_polygon (LIKE SCHEMA_NAME.anl_polygon INCLUDING ALL);
		
	IF v_project_type  = 'UD' THEN
		CREATE TEMP TABLE IF NOT EXISTS t_anl_gully (LIKE SCHEMA_NAME.anl_gully INCLUDING ALL);	
	END IF;	
		
	-- fill log table
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, 'CHECK PROJECT');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, '------------------------------');

	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 3, 'CRITICAL ERRORS');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 3, '----------------------');

	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 2, 'WARNINGS');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 2, '--------------');

	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 1, 'INFO');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 1, '-------');

	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, '');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, '-----------------------------------------------------------');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, 'To check CRITICAL ERRORS or WARNINGS, execute a query FROM anl_table WHERE fid=error number AND current_user.');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, 'For example:');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, '');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, 'SELECT * FROM MySchema.anl_arc WHERE fid = Myfid AND cur_user=current_user;');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, '');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, 'Only the errors with anl_table next to the number can be checked this way.');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, 'Using Giswater Toolbox it''s also posible to check these errors.');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, '-----------------------------------------------------------');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, '');

	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, NULL);
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 3, NULL);
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 2, NULL);
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 1, NULL);

	--  Return
	IF v_selection_mode = 'ingore' THEN
		RETURN v_return;
	END IF;

	-- continue with selection mode	

	
	-- saving user exploitation

	-- setting user options
	IF v_selection_mode = 'userDomain' THEN

		IF v_user_x_exploitation THEN
			INSERT INTO selector_x_expl (expl_id, cur_user) SELECT expl_id, username FROM config_user_x_exploitation
			ON CONFLICT (expl_id, cur_user) DO NOTHING;

		ELSE
			INSERT INTO selector_x_expl (expl_id, cur_user) SELECT expl_id, current_user FROM exploitation
			ON CONFLICT (expl_id, cur_user) DO NOTHING;
		END IF;

	END IF;
		
	-- create query tables
	CREATE TEMP TABLE IF NOT EXISTS t_arc AS SELECT * FROM v_edit_arc;
	CREATE TEMP TABLE IF NOT EXISTS t_node AS SELECT * FROM v_edit_node;
	CREATE TEMP TABLE IF NOT EXISTS t_dma AS SELECT * FROM v_edit_dma;
	CREATE TEMP TABLE IF NOT EXISTS t_connec AS SELECT * FROM v_edit_connec;
	CREATE TEMP TABLE IF NOT EXISTS t_element AS SELECT * FROM v_edit_element;
	CREATE TEMP TABLE IF NOT EXISTS t_link AS SELECT * FROM v_edit_link;



	-- restoring user selectors
	
	--  Return
	RETURN v_return;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;