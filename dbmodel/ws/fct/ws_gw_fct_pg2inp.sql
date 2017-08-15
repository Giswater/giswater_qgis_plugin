/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2inp(character varying );
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2inp('result_id_var' character varying)  RETURNS integer AS $BODY$
DECLARE
    
      

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2inp process.';
		
	-- PROCESSES
	-- 1) RESULT MANAGEMENT INSERT
		-- INSERT INTO inp_selector_result (result_id_var, cur_user)
		-- INSERT INTO rpt_input_node & rpt_input_arc TABLES
	
	-- 2) VALVE OPTIONS 
		-- Copy on inp_valve.status and inp_shorpipe.status se values from inp_options.valve_type & inp_options.valve_type_mincut_result
		-- table destination: inp_temp_valve (result_id, valve_id, status)
		
	-- 3) RTC OPTIONS (IF IS TRUE) 
		-- Use values from rtc_options 
		-- Enhance the scenario when hydrometer value is null (when it's used inp_junction.demand value)
		-- table destination: inp_temp_demand (result_id, node_id, value, pattern)
	
		
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;