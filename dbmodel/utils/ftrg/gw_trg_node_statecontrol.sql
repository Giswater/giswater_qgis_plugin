/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2948

SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_node_statecontrol()
  RETURNS trigger AS
$BODY$
DECLARE 
v_state_control_disable boolean;
  
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	v_state_control_disable:= (SELECT "value" FROM config_param_user WHERE "parameter"='edit_disable_statetopocontrol' AND cur_user=current_user)::boolean;

	IF v_state_control_disable IS FALSE THEN

		-- this trigger must act separate from toponcontrol_node simply it not works. It must work before the downgrade, because if not after downgrade it's not possible...
		-- State control (permissions to work with state=2 and possibility to downgrade feature to state=0)
		PERFORM gw_fct_state_control('NODE', NEW.node_id, NEW.state, TG_OP);
	END IF;
	
	RETURN NEW;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;