/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2324



DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_check(character varying );
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check (result_id_var character varying)  RETURNS integer AS $BODY$
DECLARE

rec_options 	record;
valve_rec	record;
      

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	SELECT * INTO rec_options FROM inp_options;

	RAISE NOTICE 'Starting pg2epa check data consistency.....';
	
	-- PUT IN ORDER TO EXPORT
	-- Check disconected nodes ---> force to ignore
	-- Check conected nodes but with closed valves -->force to put values of demand on '0'
	
	-- PUT IN ORDER TO IMPORT
	-- Reset sequences of rpt_* tables

	
RETURN 1;
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
