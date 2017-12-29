/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2130

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_state_control(feature_type_aux character varying,feature_id_aux character varying,state_aux integer,tg_op_aux character varying)  
RETURNS integer AS
$BODY$

DECLARE 
	project_type_aux text;
	querystring text;
	old_state_aux integer;
	psector_vdefault_var integer;
	num_feature integer;

BEGIN 

    SET search_path=SCHEMA_NAME, public;
	
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	

     -- control for downgrade features to state(0)
    IF tg_op_aux = 'UPDATE' THEN
		IF feature_type_aux='NODE' and state_aux=0 THEN
			SELECT state INTO old_state_aux FROM node WHERE node_id=feature_id_aux;
			IF state_aux!=old_state_aux THEN

				-- control arcs
				SELECT count(arc.arc_id) INTO num_feature FROM node, arc WHERE (node_1=feature_id_aux OR node_2=feature_id_aux) AND arc.state > 0;
				IF num_feature > 0 THEN 
					PERFORM audit_function(1072,2130,feature_id_aux);
				END IF;

				--control links
				SELECT count(link_id) INTO num_feature FROM link WHERE exit_type='NODE' AND exit_id=feature_id_aux AND link.state > 0;
				IF num_feature > 0 THEN 
					PERFORM audit_function(1072,2130,feature_id_aux);
				END IF;
				
			END IF;

		ELSIF feature_type_aux='ARC' and state_aux=0 THEN
			SELECT state INTO old_state_aux FROM arc WHERE arc_id=feature_id_aux;
			IF state_aux!=old_state_aux THEN

				--control connecs
				SELECT count(arc_id) INTO num_feature FROM connec WHERE arc_id=feature_id_aux AND connec.state>0;
				IF num_feature > 0 THEN 
					PERFORM audit_function(1074,2130,feature_id_aux);
				END IF;

				--control gullys
				IF project_type_aux='UD' THEN
					SELECT count(arc_id) INTO num_feature FROM gully WHERE arc_id=feature_id_aux AND gully.state>0;
					IF num_feature > 0 THEN
						PERFORM audit_function(1074,2130,feature_id_aux);
					END IF;	
				END IF;
				
			END IF;	


		ELSIF feature_type_aux='CONNEC' and state_aux=0 THEN
			SELECT state INTO old_state_aux FROM arc WHERE arc_id=feature_id_aux;
			IF state_aux!=old_state_aux THEN

				--control links
				SELECT count(link_id) INTO num_feature FROM link WHERE exit_type='CONNEC' AND exit_id=feature_id_aux AND link.state > 0;
				IF num_feature > 0 THEN 
					PERFORM audit_function(1076,2130,feature_id_aux);
				END IF;
				
			END IF;	


		ELSIF feature_type_aux='GULLY' and state_aux=0 THEN
			SELECT state INTO old_state_aux FROM arc WHERE arc_id=feature_id_aux;
			IF state_aux!=old_state_aux THEN

				--control links
				SELECT count(link_id) INTO num_feature FROM link WHERE exit_type='GULLY' AND exit_id=feature_id_aux AND link.state > 0;
				IF num_feature > 0 THEN 
					PERFORM audit_function(1078,2130,feature_id_aux);
				END IF;
				
			END IF;	
		
		END IF;
	  
    END IF;




   -- control of insert/update nodes with state(2)
	IF feature_type_aux='NODE' THEN
		SELECT state INTO old_state_aux FROM node WHERE node_id=feature_id_aux;
	ELSIF feature_type_aux='ARC' THEN
		SELECT state INTO old_state_aux FROM arc WHERE arc_id=feature_id_aux;
	END IF;
	
	IF tg_op_aux = 'INSERT' THEN
		IF state_aux=2 THEN
			SELECT value INTO psector_vdefault_var FROM config_param_user WHERE parameter='psector_vdefault' AND cur_user="current_user"();
			IF psector_vdefault_var IS NULL THEN	
				PERFORM audit_function(1080,2130);
			END IF;
		END IF;
	
	ELSIF tg_op_aux = 'UPDATE' THEN
		IF state_aux=2 AND old_state_aux<2 THEN
			SELECT value INTO psector_vdefault_var FROM config_param_user WHERE parameter='psector_vdefault' AND cur_user="current_user"();
			IF psector_vdefault_var IS NULL THEN	
				PERFORM audit_function(1080,2130);
			END IF;
		ELSIF state_aux<2 AND old_state_aux=2 THEN
			SELECT value INTO psector_vdefault_var FROM config_param_user WHERE parameter='psector_vdefault' AND cur_user="current_user"();
			IF psector_vdefault_var IS NULL THEN	
				PERFORM audit_function(1080,2130);
		END IF;
	END IF;	
END IF;

RETURN 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
