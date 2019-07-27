/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2456

--DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_dscenario(character varying );
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_dscenario (result_id_var character varying)  RETURNS integer AS $BODY$

DECLARE
    v_demandpriority integer; 

BEGIN
	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa for filling demand scenario';

	v_demandpriority = (SELECT value FROM config_param_user WHERE parameter='inp_options_oveedemands' AND cur_user=current_user);
	
	-- 
	IF v_demandpriority = 1 THEN -- Dscenario overwrites base demand
		UPDATE rpt_inp_node SET demand=a.demand FROM vi_demands a WHERE a.node_id=rpt_inp_node.node_id AND result_id=result_id_var;

	ELSIF v_demandpriority = 2 THEN -- Ignore Dscenario when base demand exists
		UPDATE rpt_inp_node SET demand=a.demand FROM vi_demands a WHERE a.node_id=rpt_inp_node.node_id AND result_id=result_id_var AND rpt_inp_node.demand =0;

	ELSIF v_demandpriority = 3 THEN -- Dscenario and base demand are joined
		UPDATE rpt_inp_node SET demand=demand + a.demand FROM vi_demands a WHERE a.node_id=rpt_inp_node.node_id AND result_id=result_id_var;
	
	END IF;

RETURN 1;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;