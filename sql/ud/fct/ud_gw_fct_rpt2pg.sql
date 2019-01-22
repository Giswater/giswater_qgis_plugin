/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2232


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_rpt2pg(character varying, boolean);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_rpt2pg (result_id_var character varying)  RETURNS integer AS $BODY$
DECLARE

rec_var record;   
      

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
	

RETURN 1;

	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;