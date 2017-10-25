/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa(character varying, boolean);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa (result_id_var character varying)  RETURNS integer AS $BODY$
DECLARE
    
      

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa process.';
		
	-- Fill inprpt tables
	PERFORM gw_fct_pg2epa_fill_inp2rpt(result_id_var);

	-- Calling for gw_fct_pg2epa_flowreg_additional function
	PERFORM gw_fct_pg2epa_flowreg_additional(result_id_var);
	
	-- Make virtual arcs transparent for hydraulic model
	PERFORM gw_fct_pg2epa_virtual (result_id_var);


RETURN 1;

	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;