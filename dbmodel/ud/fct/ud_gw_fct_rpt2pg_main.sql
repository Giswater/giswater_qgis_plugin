/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2726

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_rpt2pg_main(character varying );
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_rpt2pg(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_rpt2pg_main(p_data json)  
RETURNS json AS $BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_rpt2pg_main($${"data":{"resultId":"test1"}}$$) 
*/

DECLARE
rec_table record;

v_result text;
v_val integer;

  
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get parameters
	v_result  = (p_data ->>'data')::json->>'resultId';

	RAISE NOTICE 'Starting epa2pg process.';

	-- call import epa function
	PERFORM gw_fct_rpt2pg_import_rpt(p_data);
	
	-- Reset sequences of rpt_* tables
	FOR rec_table IN SELECT * FROM sys_table WHERE context='Hydraulic result data' AND sys_sequence IS NOT NULL
	LOOP
		-- EXECUTE 'SELECT max(id) FROM '||quote_ident(rec_table.id) INTO v_val;
		-- EXECUTE 'SELECT setval(SCHEMA_NAME.'||rec_table.sys_sequence||', '||v_val||', true);';
	END LOOP;
		
	-- set result on result selector: In spite of there are two selectors tables () only it's setted one
	DELETE FROM selector_rpt_main WHERE cur_user=current_user;
	INSERT INTO selector_rpt_main (result_id, cur_user) VALUES (v_result, current_user);

	-- create log
	RETURN gw_fct_rpt2pg_log (v_result);
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;