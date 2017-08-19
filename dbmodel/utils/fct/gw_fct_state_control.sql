/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_state_control(
    feature_type_aux character varying,
    feature_id_aux character varying,
    state_aux integer,
    tg_op_aux character varying)
  RETURNS integer AS
$BODY$
DECLARE 
	querystring text;
	old_state_aux integer;
	psector_vdefault_var integer;
BEGIN 

    SET search_path=SCHEMA_NAME, public;


	IF feature_type_aux='node' THEN
		SELECT state INTO old_state_aux FROM v_edit_node WHERE node_id=quote_literal(feature_id_aux);
	ELSIF feature_type_aux='arc' THEN
		SELECT state INTO old_state_aux FROM v_edit_arc WHERE arc_id=quote_literal(feature_id_aux);
	END IF;

    IF tg_op_aux = 'INSERT' THEN
	IF state_aux=2 THEN
		SELECT value INTO psector_vdefault_var FROM config_param_user WHERE parameter='psector_vdefault' AND cur_user="current_user"();
		IF psector_vdefault_var IS NULL THEN	
			RAISE EXCEPTION 'You are not allowed to manage with values of arc state=2. Please review your profile parameters';
		END IF;
	END IF;

    ELSIF tg_op_aux = 'UPDATE' THEN
	IF state_aux=2 AND state_aux!=old_state_aux THEN
		SELECT value INTO psector_vdefault_var FROM config_param_user WHERE parameter='psector_vdefault' AND cur_user="current_user"();
		IF psector_vdefault_var IS NULL THEN	
			RAISE EXCEPTION 'You are not allowed to manage with values of arc state=2. Please review your profile parameters';
		END IF;
	END IF;
	
	IF state_aux=1 AND old_state_aux=2 THEN
		SELECT value INTO psector_vdefault_var FROM config_param_user WHERE parameter='psector_vdefault' AND cur_user="current_user"();
		IF psector_vdefault_var IS NULL THEN	
			RAISE EXCEPTION 'You are not allowed to manage with values of arc state=2. Please review your profile parameters';
		END IF;
	END IF;
    END IF;

RETURN 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
