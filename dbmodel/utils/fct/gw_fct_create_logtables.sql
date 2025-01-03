/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3362

CREATE OR REPLACE FUNCTION ws40000.gw_fct_create_logtables (p_data json)
  RETURNS json AS
$BODY$

/*
SELECT gw_fct_create_logtables('{"client":{}, "form":{}, "feature":{}, "data":{"parameters":{"fid":604}}}');

*/

DECLARE
v_fid integer;
v_fprocessname text;
v_filter text;
v_project_type text;

BEGIN

	-- search path
	SET search_path = "ws40000", public;

	-- get input parameters
	v_fid := (((p_data ->>'data')::json->>'parameters')::json->>'fid');

	-- get system parameters	
	v_fprocessname = (SELECT UPPER(fprocess_name) FROM sys_fprocess where fid = v_fid);
	v_project_type = (SELECT project_type FROM sys_version order by id desc limit 1);
	
	-- create log tables
	DROP TABLE IF EXISTS t_audit_check_data; CREATE TEMP TABLE t_audit_check_data (LIKE ws40000.audit_check_data INCLUDING ALL);
	DROP TABLE IF EXISTS t_audit_check_project;	CREATE TEMP TABLE t_audit_check_project (LIKE ws40000.audit_check_project INCLUDING ALL);
	DROP TABLE IF EXISTS t_anl_node;CREATE TEMP TABLE  t_anl_node (LIKE ws40000.anl_node INCLUDING ALL);
	DROP TABLE IF EXISTS t_anl_arc; CREATE TEMP TABLE t_anl_arc (LIKE ws40000.anl_arc INCLUDING ALL);
	DROP TABLE IF EXISTS t_anl_connec;CREATE TEMP TABLE t_anl_connec (LIKE ws40000.anl_connec INCLUDING ALL);
	DROP TABLE IF EXISTS t_anl_polygon; CREATE TEMP TABLE t_anl_polygon (LIKE ws40000.anl_polygon INCLUDING ALL);	
		
	IF v_project_type  = 'UD' THEN
		DROP TABLE IF EXISTS t_anl_gully;CREATE TEMP TABLE t_anl_gully (LIKE ws40000.anl_gully INCLUDING ALL);	
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

	--  Return
	RETURN '{"status":"ok"}';

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;