/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2130

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_state_control(
    feature_type_aux character varying,
    feature_id_aux character varying,
    state_aux integer,
    tg_op_aux character varying)
  RETURNS integer AS
$BODY$

DECLARE 
	project_type_aux text;
	querystring text;
	old_state_aux integer;
	psector_vdefault_var integer;
	num_feature integer;
	downgrade_force_aux boolean;
	rec_feature record;
	state_type_aux integer;
	

BEGIN 

    SET search_path=SCHEMA_NAME, public;
	
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	downgrade_force_aux:= (SELECT "value" FROM config_param_user WHERE "parameter"='edit_arc_downgrade_force' AND cur_user=current_user)::boolean;
	

     -- control for downgrade features to state(0)
    IF tg_op_aux = 'UPDATE' THEN
		IF feature_type_aux='NODE' and state_aux=0 THEN
			SELECT state INTO old_state_aux FROM node WHERE node_id=feature_id_aux;
			IF state_aux!=old_state_aux AND (downgrade_force_aux IS NOT TRUE) THEN

				-- arcs control
				SELECT count(arc.arc_id) INTO num_feature FROM node, arc WHERE (node_1=feature_id_aux OR node_2=feature_id_aux) AND arc.state > 0;
				IF num_feature > 0 THEN 
					PERFORM audit_function(1072,2130,feature_id_aux);
				END IF;

				--link feature control
				SELECT count(link_id) INTO num_feature FROM link WHERE exit_type='NODE' AND exit_id=feature_id_aux AND link.state > 0;
				IF num_feature > 0 THEN 
					PERFORM audit_function(1072,2130,feature_id_aux);
				END IF;
				
			ELSIF state_aux!=old_state_aux AND (downgrade_force_aux IS TRUE) THEN
			
				-- arcs control
				SELECT count(arc.arc_id) INTO num_feature FROM node, arc WHERE (node_1=feature_id_aux OR node_2=feature_id_aux) AND arc.state > 0;
				IF num_feature > 0 THEN 
					EXECUTE 'SELECT state_type FROM node WHERE node_id=$1'
						INTO state_type_aux
						USING feature_id_aux;						
					INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) VALUES (28,'NODE', feature_id_aux, concat(old_state_aux,',',state_type_aux));
				
				END IF;

				--link feature control
				SELECT count(link_id) INTO num_feature FROM link WHERE exit_type='NODE' AND exit_id=feature_id_aux AND link.state > 0;
				IF num_feature > 0 THEN 
					EXECUTE 'SELECT state_type FROM node WHERE node_id=$1'
						INTO state_type_aux
						USING feature_id_aux;						
					INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) VALUES (28,'NODE', feature_id_aux, concat(old_state_aux,',',state_type_aux));

				END IF;
				
				
			END IF;

		ELSIF feature_type_aux='ARC' and state_aux=0 THEN
			SELECT state INTO old_state_aux FROM arc WHERE arc_id=feature_id_aux;
			
			IF state_aux!=old_state_aux AND (downgrade_force_aux IS TRUE) THEN

				--connec's control
				FOR rec_feature IN SELECT * FROM connec WHERE arc_id=feature_id_aux AND connec.state>0
				LOOP
					UPDATE connec set arc_id=NULL WHERE connec_id=rec_feature.connec_id;
				END LOOP;

				--node's control (only WS)
				IF project_type_aux='WS' THEN
					FOR rec_feature IN SELECT * FROM node WHERE arc_id=feature_id_aux AND node.state>0
					LOOP
						UPDATE node set arc_id=NULL WHERE node_id=rec_feature.node_id;
					END LOOP;

				--gully's control (only UD)
				ELSIF project_type_aux='UD' THEN
					FOR rec_feature IN SELECT * FROM gully WHERE arc_id=feature_id_aux AND gully.state>0
					LOOP
						UPDATE gully set arc_id=NULL WHERE gully_id=rec_feature.gully_id;
					END LOOP;
				END IF;
			END IF;


			IF state_aux!=old_state_aux THEN

				--connec's control
				SELECT count(arc_id) INTO num_feature FROM connec WHERE arc_id=feature_id_aux AND connec.state>0;
				IF num_feature > 0 THEN 
					PERFORM audit_function(1074,2130,feature_id_aux);
				END IF;

				--node's control (only WS)
				IF project_type_aux='WS' THEN
					SELECT count(arc_id) INTO num_feature FROM node WHERE arc_id=feature_id_aux AND node.state>0;
					IF num_feature > 0 THEN
						PERFORM audit_function(1074,2130,feature_id_aux);
					END IF;
				
				--gully's control (only UD)
				ELSIF project_type_aux='UD' THEN
					SELECT count(arc_id) INTO num_feature FROM gully WHERE arc_id=feature_id_aux AND gully.state>0;
					IF num_feature > 0 THEN
						PERFORM audit_function(1074,2130,feature_id_aux);
					END IF;	
				END IF;
				
			END IF;	


		ELSIF feature_type_aux='CONNEC' and state_aux=0 THEN
			SELECT state INTO old_state_aux FROM connec WHERE connec_id=feature_id_aux;
			
			IF state_aux!=old_state_aux AND (downgrade_force_aux IS NOT TRUE) THEN

				--link feature control
				SELECT count(link_id) INTO num_feature FROM link WHERE exit_type='CONNEC' AND exit_id=feature_id_aux AND link.state > 0;
				IF num_feature > 0 THEN 
					PERFORM audit_function(1072,2130,feature_id_aux);
				END IF;
				
			ELSIF state_aux!=old_state_aux AND (downgrade_force_aux IS TRUE) THEN
			
				--link feature control
				SELECT count(link_id) INTO num_feature FROM link WHERE exit_type='CONNEC' AND exit_id=feature_id_aux AND link.state > 0;
				IF num_feature > 0 THEN 
					EXECUTE 'SELECT state_type FROM connec WHERE connec_id=$1'
						INTO state_type_aux
						USING feature_id_aux;						
					INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) VALUES (28,'CONNEC', feature_id_aux, concat(old_state_aux,',',state_type_aux));
				END IF;
				
			END IF;	


		ELSIF feature_type_aux='GULLY' and state_aux=0 THEN
			SELECT state INTO old_state_aux FROM gully WHERE gully_id=feature_id_aux;

			IF state_aux!=old_state_aux AND (downgrade_force_aux IS NOT TRUE) THEN

				--link feature control
				SELECT count(link_id) INTO num_feature FROM link WHERE exit_type='GULLY' AND exit_id=feature_id_aux AND link.state > 0;
				IF num_feature > 0 THEN 
					PERFORM audit_function(1072,2130,feature_id_aux);
				END IF;
				
			ELSIF state_aux!=old_state_aux AND (downgrade_force_aux IS TRUE) THEN
			
				--link feature control
				SELECT count(link_id) INTO num_feature FROM link WHERE exit_type='GULLY' AND exit_id=feature_id_aux AND link.state > 0;
				IF num_feature > 0 THEN 
					EXECUTE 'SELECT state_type FROM gully WHERE gully_id=$1'
						INTO state_type_aux
						USING feature_id_aux;
					INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) VALUES (28,'GULLY', feature_id_aux, concat(old_state_aux,',',state_type_aux));
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
