/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2232


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_rpt2pg(character varying);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_rpt2pg (result_id_var character varying)  
RETURNS json AS $BODY$

DECLARE
	rec_var record;  
	v_return json;   

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting epa2pg process.';
	
	/*
	-- Reset sequences of rpt_* tables
	FOR rec_var IN SELECT id FROM audit_cat_table WHERE context='Hydraulic result data' AND sys_sequence IS NOT NULL
	LOOP
		EXECUTE 'SELECT max(id) INTO setvalue_int FROM '||rec_var.id||';';
		EXECUTE 'SELECT setval(SCHEMA_NAME.'||rec_var.sys_sequence||', '||setvalue_int||', true);';
	END LOOP;
	*/
	
	-- set result on result selector
	-- NOTE: In spite of there are two selectors tables (rpt_selector_result, rpt_selector_compare) only it's setted one
	DELETE FROM rpt_selector_result WHERE cur_user=current_user;
	INSERT INTO rpt_selector_result (result_id, cur_user) VALUES (result_id_var, current_user);

	SELECT gw_fct_rpt2pg_log (result_id_var) INTO v_return;	

RETURN v_return;

	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;