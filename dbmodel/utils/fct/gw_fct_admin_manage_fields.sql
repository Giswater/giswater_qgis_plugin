/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2700

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_manage_fields();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_fields(p_data json) RETURNS void AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"addvalue", "dataType":"varchar(16)", "isUtils":"True"}}$$)
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"addvalue", "dataType":"varchar(16)", "isUtils":"True"}}$$)
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"arc", "column":"addvalue", "newName":"_addvalue_"}}$$)
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"arc", "column":"addvalue"}}$$)

*/

DECLARE 

v_schemaname varchar = 'SCHEMA_NAME';
v_project_type text;
v_schemautils boolean;
v_action text;
v_table text;
v_column text;
v_datatype text;
v_isutils boolean;
v_newname text;
v_querytext text;
v_currentcolumn text;
v_tableversion text = 'sys_version';
v_columntype text = 'project_type';

BEGIN 

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	
	-- get info from version table
	IF (SELECT tablename FROM pg_tables WHERE schemaname = v_schemaname AND tablename = 'version') IS NOT NULL THEN v_tableversion = 'version'; v_columntype = 'wsoftware'; END IF;
 	EXECUTE 'SELECT '||quote_ident(v_columntype)||' FROM '||quote_ident(v_tableversion)||' LIMIT 1' INTO v_project_type;
	
	v_action = (p_data->>'data')::json->>'action';
	v_table = (p_data->>'data')::json->>'table';
	v_column = (p_data->>'data')::json->>'column';
	v_datatype = (p_data->>'data')::json->>'dataType';
	v_isutils = (p_data->>'data')::json->>'isUtils';
	v_newname = (p_data->>'data')::json->>'newName';

	-- manage utils schema
	IF v_isutils THEN
		v_schemautils = (SELECT value::boolean FROM config_param_system WHERE parameter='sys_utils_schema' OR parameter='admin_utils_schema');
		IF v_schemautils THEN 		
			SET search_path = 'utils', public;
			v_schemaname := 'utils';
			v_table := substring(v_table,5,999);
			
		END IF;
	END IF;

	-- check if column not exists
	IF v_action='ADD' AND (SELECT column_name FROM information_schema.columns WHERE table_schema=v_schemaname and table_name = v_table AND column_name = v_column) IS NULL THEN

		v_querytext = 'ALTER TABLE '||quote_ident(v_schemaname) ||'.'|| quote_ident(v_table) ||' ADD COLUMN '||quote_ident(v_column)||' '||v_datatype;
		EXECUTE v_querytext;
		
	ELSIF v_action='RENAME' AND (SELECT column_name FROM information_schema.columns WHERE table_schema=v_schemaname and table_name = v_table AND column_name = v_column) IS NOT NULL  
				AND (SELECT column_name FROM information_schema.columns WHERE table_schema=v_schemaname and table_name = v_table AND column_name = v_newname) IS NULL THEN

		v_querytext = 'ALTER TABLE '|| quote_ident(v_table) ||' RENAME COLUMN '||quote_ident(v_column)||' TO '||quote_ident(v_newname);
		EXECUTE v_querytext;

	ELSIF v_action='DROP' AND (SELECT column_name FROM information_schema.columns WHERE table_schema=v_schemaname and table_name = v_table AND column_name = v_column) IS NOT NULL THEN

		v_querytext = 'ALTER TABLE '|| quote_ident(v_table) ||' DROP COLUMN '||quote_ident(v_column);
		EXECUTE v_querytext;

	ELSE 
		RAISE NOTICE 'Process not executed. Check data';
	END IF;

	-- recover search_path in case utils = true in order to reset value fixed before
	SET search_path = "SCHEMA_NAME", public;

	RETURN ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;