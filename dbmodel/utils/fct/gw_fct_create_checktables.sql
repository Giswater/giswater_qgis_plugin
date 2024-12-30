/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3362

CREATE OR REPLACE FUNCTION ws40000.gw_fct_create_checktables (p_data json)
  RETURNS json AS
$BODY$

/*
SELECT gw_fct_create_checktables('{"client":{}, "form":{}, "feature":{}, "data":{"parameters":{"ignoreVerifiedExceptions":true}}}');

*/

DECLARE
v_fid integer;
v_schemaname text;
v_project_type text;
v_version text;
v_epsg integer;
v_error_context text;
v_return json= '{}';
v_ignore_verified_exceptions boolean = true;
v_fprocessname text;
v_verified_filter text;

BEGIN

	-- search path
	SET search_path = "ws40000", public;
	v_schemaname = 'ws40000';

	-- Get input parameters
	v_ignore_verified_exceptions := ((p_data ->>'data')::json->>'parameters')::json->>'ignoreVerifiedExceptions';
	v_fid := (((p_data ->>'data')::json->>'parameters')::json->>'fid');

	v_fprocessname = (SELECT UPPER(fprocess_name) FROM sys_fprocess where fid = v_fid);
	
	-- create log tables
	DROP TABLE IF EXISTS t_audit_check_data;
	CREATE TEMP TABLE t_audit_check_data (LIKE ws40000.audit_check_data INCLUDING ALL);
	
	DROP TABLE IF EXISTS t_audit_check_project;
	CREATE TEMP TABLE t_audit_check_project (LIKE ws40000.audit_check_project INCLUDING ALL);
	
	DROP TABLE IF EXISTS t_anl_node;
	CREATE TEMP TABLE  t_anl_node (LIKE ws40000.anl_node INCLUDING ALL);
	
	DROP TABLE IF EXISTS t_anl_arc;
	CREATE TEMP TABLE t_anl_arc (LIKE ws40000.anl_arc INCLUDING ALL);
	
	DROP TABLE IF EXISTS t_anl_connec;
	CREATE TEMP TABLE t_anl_connec (LIKE ws40000.anl_connec INCLUDING ALL);	

	DROP TABLE IF EXISTS t_anl_polygon;
	CREATE TEMP TABLE t_anl_polygon (LIKE ws40000.anl_polygon INCLUDING ALL);	
		
	IF v_project_type  = 'UD' THEN
		DROP TABLE IF EXISTS t_anl_gully;
		CREATE TEMP TABLE t_anl_gully (LIKE ws40000.anl_gully INCLUDING ALL);	
	END IF;	

	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 2, NULL);
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, NULL);
		
	-- fill log table
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, v_fprocessname);
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '------------------------------');

	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 3, 'CRITICAL ERRORS');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 3, '----------------------');

	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 2, 'WARNINGS');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 2, '--------------');

	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, 'INFO');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, '-------');

	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '-----------------------------------------------------------');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, 'To check CRITICAL ERRORS or WARNINGS, execute a query FROM anl_table WHERE fid=error number AND current_user.');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, 'For example:');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, 'SELECT * FROM MySchema.anl_arc WHERE fid = Myfid AND cur_user=current_user;');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, 'Only the errors with anl_table next to the number can be checked this way.');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, 'Using Giswater Toolbox it''s also posible to check these errors.');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '-----------------------------------------------------------');
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '');

	
	-- setting verified options
	IF v_ignore_verified_exceptions THEN
		v_verified_filter = ' ';
	ELSE
		v_verified_filter = ' WHERE verified is null or verified::INTEGER IN (0,1)';
	END IF;

	-- create query tables
	DROP TABLE IF EXISTS t_arc;
	EXECUTE 'CREATE TEMP TABLE t_arc AS SELECT * FROM v_edit_arc'||v_verified_filter;

	DROP TABLE IF EXISTS t_node;
	EXECUTE 'CREATE TEMP TABLE  t_node AS SELECT * FROM v_edit_node'||v_verified_filter;

	DROP TABLE IF EXISTS t_connec;
	EXECUTE 'CREATE TEMP TABLE t_connec AS SELECT * FROM v_edit_connec'||v_verified_filter;

	DROP TABLE IF EXISTS t_element;
	EXECUTE 'CREATE TEMP TABLE t_element AS SELECT * FROM v_edit_element'||v_verified_filter;

	DROP TABLE IF EXISTS t_link;
	EXECUTE 'CREATE TEMP TABLE t_link AS SELECT * FROM v_edit_link';

	DROP TABLE IF EXISTS t_dma;
	CREATE TEMP TABLE t_dma AS SELECT * FROM v_edit_dma;

	IF v_project_type  = 'UD' THEN
		DROP TABLE IF EXISTS t_gully;
		EXECUTE 'CREATE TEMP TABLE t_gully AS SELECT * FROM v_edit_gully'||v_verified_filter;

	END IF;	
	
	--  Return
	RETURN v_return;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;