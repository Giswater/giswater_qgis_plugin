/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2324



DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_audit_check_data(character varying );
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_audit_check_data (result_id_var character varying)  RETURNS integer AS $BODY$
DECLARE

rec_options 	record;
valve_rec	record;
      

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	SELECT * INTO rec_options FROM inp_options;

	RAISE NOTICE 'Starting pg2epa check data consistency.....';
	
	-- UTILS
	-- Check disconected nodes ---> force to ignore 
	-- Reset sequences of rpt_* tables
	
		
	--UD check and set value default
	--inp_outfall (outfall_type)
	--inp_conduit table (q0, barrels)
	--inp_junction table (y0)
	--raingage (scf)


	-- UD check
	-- Check inp_outfall table: if outfall_type then. (2 etaoa)
	-- Check inp_conduit table valors per davant d'altres. i.e  no pot ser un kexit amb un kentry null
	-- Check inp_junction table valors per davant d'altres. i.e  no pot ser un apond amb valor darrera de un ysur null
	-- Check subcatchment table: only null values on snow_id and not used infiltration method. Controlar els valors que tenen clau foranea.. (snow_id.....)
	-- Combined check raingage & timeseries table: if rgage_type=timser_id then check form_type, intvl 
	-- Check timeseries (order)
	-- Check advanced inp tables: storage, flow regulators, divider, lid...
	

	--WS check and set value default
	-- nothing
	
	--WS check
	-- Check conected nodes but with closed valves -->force to put values of demand on '0'
	-- Check inp_tank (initlevel, minlevel, maxlevel, diameter, minvol)
	-- Check inp_valve table: if valv_type='' THEN........
	-- Check inp_pump table 

	
RETURN 1;
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
