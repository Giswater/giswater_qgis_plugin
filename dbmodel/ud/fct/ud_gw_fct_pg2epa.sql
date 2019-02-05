/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2222


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2epa(result_id_var character varying, p_use_networkgeom boolean, p_dumpsubcatchment boolean)  
RETURNS integer AS 
$BODY$

-- only_check_bool NOT USED VARIABLE

DECLARE
	check_count_aux integer; 

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa process.';
	
	
	IF p_use_networkgeom IS FALSE THEN

		-- Fill inprpt tables
		PERFORM gw_fct_pg2epa_fill_data(result_id_var);
	
		-- Fill inprpt tables
		PERFORM gw_fct_pg2epa_fill_data(result_id_var);

		-- Make virtual arcs (EPA) transparents for hydraulic model
		PERFORM gw_fct_pg2epa_join_virtual(result_id_var);
		
		-- Call nod2arc function
		PERFORM gw_fct_pg2epa_nod2arc_geom(result_id_var);
		
		-- Calling for gw_fct_pg2epa_flowreg_additional function
		PERFORM gw_fct_pg2epa_nod2arc_data(result_id_var);
	
	END IF;
	
	-- Check data quality
	SELECT gw_fct_pg2epa_check_data(result_id_var) INTO check_count_aux;
	
	IF p_dumpsubcatchment THEN
		-- Dump subcatchments
		PERFORM gw_fct_pg2epa_dump_subcatch (result_id_var);
	END IF;
	

	
RETURN check_count_aux;

	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;