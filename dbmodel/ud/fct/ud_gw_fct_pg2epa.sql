/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa(character varying, boolean);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa (result_id_var character varying, export_subcatch boolean)  RETURNS integer AS $BODY$
DECLARE
    
      

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2inp process.';
		
	-- PROCESSES
	-- 1) RESULT MANAGEMENT INSERT
		-- INSERT INTO inp_selector_result (result_id_var, cur_user)
		-- INSERT INTO rpt_input_node & rpt_input_arc TABLES
	
	-- 2) EXPORT SUBCATCHMENT
	

	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;