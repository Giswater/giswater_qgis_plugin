/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2314


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa(character varying, boolean );
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa(result_id_var character varying, only_check_bool boolean)  RETURNS integer AS $BODY$
DECLARE

-- only_check_bool NOT USED VARIABLE

rec_options 	record;
valve_rec		record;
check_count_aux integer;
      
BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	SELECT * INTO rec_options FROM inp_options;

	RAISE NOTICE 'Starting pg2epa process.';
	
	-- Fill inprpt tables
	PERFORM gw_fct_pg2epa_fill_data(result_id_var);

	-- Update demand values filtering by dscenario
	PERFORM gw_fct_pg2epa_dscenario(result_id_var);
	
	-- Calling for gw_fct_pg2epa_nod2arc function
	PERFORM gw_fct_pg2epa_nod2arc(result_id_var);

	-- Calling for gw_fct_pg2epa_pump_additional function;
	PERFORM gw_fct_pg2epa_pump_additional(result_id_var);

	-- Check data quality
	SELECT gw_fct_pg2epa_check_data(result_id_var) INTO check_count_aux;

	-- Real values of demand if rtc is enabled;
	IF rec_options.rtc_enabled IS TRUE THEN
		PERFORM gw_fct_pg2epa_rtc(result_id_var);
	END IF;

	-- Calling for modify the valve status
	PERFORM gw_fct_pg2epa_valve_status(result_id_var);
		
	

RETURN check_count_aux;
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;