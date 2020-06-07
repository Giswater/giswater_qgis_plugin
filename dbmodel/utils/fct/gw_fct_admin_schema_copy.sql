/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2722

CREATE OR REPLACE FUNCTION gw_fct_admin_schema_copy(p_data json)
  RETURNS void AS
$BODY$

/*EXAMPLE

DISABLE CONSTRAINTS:
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$);

EXECUTE:
SELECT SCHEMA_NAME.gw_fct_admin_schema_copy($${"client":{"lang":"CA"}, "data":{"fromSchema":"bgeo_treball", "toSchema":"ud"}}$$)
WARNING: need to decide before what to do with configs: config_api_* AND config_param_system

ENABLE CONSTRAINTS:
SELECT SCHEMA_NAME.gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"ADD"}}$$)

*/

DECLARE

v_fromschema text;
v_toschema text;
v_schemaname text;
v_tablerecord record;
v_query_text text;
v_result integer;
v_idname text;

BEGIN
	
	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	v_fromschema := (p_data ->> 'data')::json->> 'fromSchema';
	v_toschema := (p_data ->> 'data')::json->> 'toSchema';

	-- delete previous data
	DELETE FROM config_param_user;

	-- copy data using primary key
	FOR v_tablerecord IN SELECT * FROM sys_table WHERE id NOT IN ('config_param_system')
	AND id IN (SELECT table_name FROM information_schema.tables WHERE table_schema=v_fromschema AND table_type='BASE TABLE') 
	AND id IN (SELECT table_name FROM information_schema.tables WHERE table_schema=v_toschema AND table_type='BASE TABLE') AND id NOT IN('price_value_unit', 'temp_table')
	LOOP

		-- get primary key
		EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
			INTO v_idname
			USING v_tablerecord.id;

		RAISE NOTICE ' COPYING DATA FROM/TO TABLE: % , %', v_tablerecord.id, v_idname;

		-- execute copy from table to table
		EXECUTE 'INSERT INTO '||v_toschema||'.'||v_tablerecord.id||' SELECT * FROM '||v_fromschema||'.'||v_tablerecord.id||' 
			WHERE '||v_idname||' NOT IN (SELECT '||v_idname||' FROM '||v_toschema||'.'||v_tablerecord.id||')';
		
	END LOOP;

	-- copy data using others
	EXECUTE 'INSERT INTO '||v_toschema||'.config_param_system SELECT * FROM '||v_fromschema||'.config_param_syste WHERE parameter NOT IN (SELECT parameter FROM '||v_toschema||'.config_param_system)';

	RETURN;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
