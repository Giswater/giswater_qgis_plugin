/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_state_control(feature_type_aux character varying,feature_id_aux character varying,state_aux integer,tg_op_aux character varying)  
RETURNS integer AS
$BODY$

DECLARE 
	querystring text;
	old_state_aux integer;
	psector_vdefault_var integer;
	num_arcs integer;
	num_connecs integer;
BEGIN 

    SET search_path=SCHEMA_NAME, public;


     -- control for downgrade features to state(0)
     IF tg_op_aux = 'UPDATE' THEN
	IF feature_type_aux='node' and state_aux=0 THEN
		SELECT state INTO old_state_aux FROM node WHERE node_id=feature_id_aux;
		IF state_aux!=old_state_aux THEN
			SELECT count(arc_id) INTO num_arcs FROM node, arc WHERE (node_1=feature_id_aux OR node_2=feature_id_aux) AND arc.state!=0;
			IF num_arcs > 0 THEN 
				RAISE EXCEPTION 'Before downgrade the node to state 0, please disconnect the associated arcs, node_id= %',feature_id_aux;
			END IF;
		END IF;

	ELSIF feature_type_aux='arc' and state_aux=0 THEN
		SELECT state INTO old_state_aux FROM arc WHERE arc_id=feature_id_aux;
		IF state_aux!=old_state_aux THEN
			SELECT count(connec_id) INTO num_connecs FROM v_edit_connec, v_edit_arc WHERE v_edit_connec.arc_id=feature_id_aux AND v_edit_connec.state!=0;
			IF num_arcs > 0 THEN 
				RAISE EXCEPTION 'Before downgrade the arc to state 0, please disconnect the associated connecs, arc_id= %',feature_id_aux;
			END IF;
		END IF;
	END IF;   
      END IF;

   -- control of insert/update nodes with state(2)
      IF feature_type_aux='node' THEN
	SELECT state INTO old_state_aux FROM node WHERE node_id=feature_id_aux;
      ELSIF feature_type_aux='arc' THEN
	SELECT state INTO old_state_aux FROM arc WHERE arc_id=feature_id_aux;
      END IF;

      IF tg_op_aux = 'INSERT' THEN
	IF state_aux=2 THEN
		SELECT value INTO psector_vdefault_var FROM config_param_user WHERE parameter='psector_vdefault' AND cur_user="current_user"();
		IF psector_vdefault_var IS NULL THEN	
			RAISE EXCEPTION 'You are not allowed to manage with state=2 values. Please review your profile parameters';
		END IF;
	END IF;

      ELSIF tg_op_aux = 'UPDATE' THEN
	IF state_aux=2 AND state_aux!=old_state_aux THEN
		SELECT value INTO psector_vdefault_var FROM config_param_user WHERE parameter='psector_vdefault' AND cur_user="current_user"();
		IF psector_vdefault_var IS NULL THEN	
			RAISE EXCEPTION 'You are not allowed to manage with state=2 values. Please review your profile parameters';
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
