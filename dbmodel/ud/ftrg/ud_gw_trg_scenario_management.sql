/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3040

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_scenario_management()  RETURNS trigger AS
$BODY$

DECLARE 
v_hydrology_status boolean;
v_hydrology_value integer;
v_dwf_status boolean;
v_dwf_value integer;
v_scenario_table text;

BEGIN

	-- set serach_path
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- getting system variables
	v_scenario_table:= TG_ARGV[0];
	
	-- getting user variables
	v_hydrology_status := (SELECT (value::json->>'automaticInsert')::json->>'status' FROM config_param_user WHERE cur_user = current_user AND parameter = 'inp_scenario_hydrology');
	v_hydrology_value := (SELECT (value::json->>'automaticInsert')::json->>'sourceScenario' FROM config_param_user WHERE cur_user = current_user AND parameter = 'inp_scenario_hydrology');
	v_dwf_status := (SELECT (value::json->>'automaticInsert')::json->>'status' FROM config_param_user WHERE cur_user = current_user AND parameter = 'inp_scenario_dwf');
	v_dwf_value := (SELECT (value::json->>'automaticInsert')::json->>'sourceScenario' FROM config_param_user WHERE cur_user = current_user AND parameter = 'inp_scenario_dwf');


	IF TG_OP = 'INSERT' THEN
	
		IF v_scenario_table = 'cat_hydrology' THEN 

			-- fill automatic new values on cat_dwf_scenario
			IF v_hydrology_status THEN 
				INSERT INTO inp_subcatchment (subc_id, outlet_id, rg_id, area, clength, width, slope, sector_id, hydrology_id, the_geom)
				SELECT concat('H',NEW.hydrology_id,'-',substring(subc_id,0,13)), outlet_id, rg_id, area, clength, width, slope, sector_id, NEW.hydrology_id, the_geom 
				FROM inp_subcatchment WHERE hydrology_id = v_hydrology_value;
			END IF;

			-- setting this scenario as vdefault scenario
			DELETE FROM selector_inp_hydrology WHERE cur_user = current_user;
			INSERT INTO selector_inp_hydrology VALUES (NEW.hydrology_id, current_user);
			
		END IF;
		
		IF v_scenario_table = 'cat_dwf_scenario' THEN 	

			-- fill automatic new values on cat_dwf_scenario
			IF v_dwf_status THEN 
				INSERT INTO inp_dwf (node_id, value, pat1, pat2, pat3, pat4, dwfscenario_id)
				SELECT node_id, value, pat1, pat2, pat3, pat4, NEW.id FROM inp_dwf WHERE dwfscenario_id = v_dwf_value;
			END IF;

			-- setting this scenario as vdefault scenario
			UPDATE config_param_user SET value =  NEW.id WHERE parameter = 'inp_options_dwfscenario' and cur_user = current_user;
			
		END IF;

		RETURN NEW;
		
	END IF;

END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;