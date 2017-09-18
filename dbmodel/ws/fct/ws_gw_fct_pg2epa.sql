/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa(character varying );
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa(result_id_var character varying)  RETURNS integer AS $BODY$
DECLARE
    
      

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa process.';
		
	-- PROCESSES
	-- 1) RESULT MANAGEMENT INSERT
		-- INSERT INTO inp_selector_result (result_id_var, cur_user)
		-- INSERT INTO rpt_input_node & rpt_input_arc TABLES. SELECT FROM arc, node, JOIN man_type_function WHERE is_operative IS NULL or is_operative IS TRUE
	
	-- 2) VALVE OPTIONS 
		-- Copy on inp_valve.status and inp_shorpipe.status se values from inp_options.valve_type & inp_options.valve_type_mincut_result
		-- table destination: inp_temp_valve (result_id, valve_id, status)
		-- If mincut valve options is choosed, demand of all internal nodes of the mincut polygon must be CERO!!!!
		
	-- 3) RTC OPTIONS (IF IS TRUE) 
		-- Use values from rtc_options 
		-- Enhance the scenario when hydrometer value is null (when it's used inp_junction.demand value)
		-- table destination: inp_temp_demand (result_id, node_id, value, pattern)

	--4) CALL pg2epa_nodarc
	
	--5) Call pg2epa_pump_additional

RETURN 1;
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;