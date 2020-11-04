/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2130

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_state_control(feature_type_aux character varying,feature_id_aux character varying,
state_aux integer, tg_op_aux character varying)
RETURNS integer AS
$BODY$

-- fid: 128

DECLARE 

v_project_type text;
v_old_state integer;
v_psector_vdefault integer;
v_num_feature integer;
v_downgrade_force boolean;
v_state_type integer;
v_psector_list text;

rec_feature record;

BEGIN 

    SET search_path=SCHEMA_NAME, public;

	SELECT project_type INTO v_project_type FROM sys_version LIMIT 1;
	v_downgrade_force:= (SELECT "value" FROM config_param_user WHERE "parameter"='edit_arc_downgrade_force' AND cur_user=current_user)::boolean;
	
    -- control for downgrade features to state(0)
    IF tg_op_aux = 'UPDATE' THEN
		IF feature_type_aux='NODE' and state_aux=0 THEN
			SELECT state INTO v_old_state FROM node WHERE node_id=feature_id_aux;
			IF state_aux!=v_old_state AND (v_downgrade_force IS NOT TRUE) THEN

				-- psector control
				SELECT count(plan_psector_x_node.node_id) INTO v_num_feature FROM plan_psector_x_node
				JOIN  plan_psector USING (psector_id) WHERE active IS TRUE and node_id=feature_id_aux;

				IF v_num_feature > 0 THEN 
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3160", "function":"2130","debug_msg":"'||feature_id_aux||'"}}$$);';
				END IF;

				-- arcs control
				SELECT count(arc.arc_id) INTO v_num_feature FROM arc WHERE (node_1=feature_id_aux OR node_2=feature_id_aux) AND arc.state = 1;
				IF v_num_feature > 0 THEN 
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"1072", "function":"2130","debug_msg":"'||feature_id_aux||'"}}$$);';
				END IF;

				SELECT count(arc.arc_id) INTO v_num_feature FROM arc WHERE (node_1=feature_id_aux OR node_2=feature_id_aux) AND arc.state = 2;
				IF v_num_feature > 0 THEN 
					SELECT string_agg(name::text, ', ') INTO v_psector_list FROM plan_psector_x_arc 
					JOIN plan_psector USING (psector_id) where arc_id IN 
					(SELECT arc.arc_id FROM arc WHERE (node_1='1070' OR node_2='1070') AND arc.state = 2); 
					
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3140", "function":"2130","debug_msg":"'||v_psector_list||'"}}$$);';
					
				END IF;

				--link feature control
				SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='NODE' AND exit_id=feature_id_aux AND link.state > 0;
				IF v_num_feature > 0 THEN 
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"1072", "function":"2130","debug_msg":"'||feature_id_aux||'"}}$$);';
				END IF;
				
			ELSIF state_aux!=v_old_state AND (v_downgrade_force IS TRUE) THEN
			
				-- arcs control
				SELECT count(arc.arc_id) INTO v_num_feature FROM node, arc WHERE (node_1=feature_id_aux OR node_2=feature_id_aux) AND arc.state > 0;
				IF v_num_feature > 0 THEN 
					EXECUTE 'SELECT state_type FROM node WHERE node_id=$1'
						INTO v_state_type
						USING feature_id_aux;						
					INSERT INTO audit_log_data (fid, feature_type, feature_id, log_message) VALUES (128,'NODE', feature_id_aux, concat(v_old_state,',',v_state_type));
				
				END IF;

				--link feature control
				SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='NODE' AND exit_id=feature_id_aux AND link.state > 0;
				IF v_num_feature > 0 THEN 
					EXECUTE 'SELECT state_type FROM node WHERE node_id=$1'
						INTO v_state_type
						USING feature_id_aux;						
					INSERT INTO audit_log_data (fid, feature_type, feature_id, log_message) VALUES (128,'NODE', feature_id_aux, concat(v_old_state,',',v_state_type));
				END IF;
			END IF;

		ELSIF feature_type_aux='ARC' and state_aux=0 THEN
			SELECT state INTO v_old_state FROM arc WHERE arc_id=feature_id_aux;
			
			IF state_aux!=v_old_state AND (v_downgrade_force IS TRUE) THEN

				--connec's control
				FOR rec_feature IN SELECT * FROM connec WHERE arc_id=feature_id_aux AND connec.state>0
				LOOP
					UPDATE connec set arc_id=NULL WHERE connec_id=rec_feature.connec_id;
				END LOOP;

				--node's control (only WS)
				IF v_project_type='WS' THEN
					FOR rec_feature IN SELECT * FROM node WHERE arc_id=feature_id_aux AND node.state>0
					LOOP
						UPDATE node set arc_id=NULL WHERE node_id=rec_feature.node_id;
					END LOOP;

				--gully's control (only UD)
				ELSIF v_project_type='UD' THEN
					FOR rec_feature IN SELECT * FROM gully WHERE arc_id=feature_id_aux AND gully.state>0
					LOOP
						UPDATE gully set arc_id=NULL WHERE gully_id=rec_feature.gully_id;
					END LOOP;
				END IF;
			END IF;

			IF state_aux!=v_old_state THEN

				--connec's control
				SELECT count(arc_id) INTO v_num_feature FROM connec WHERE arc_id=feature_id_aux AND connec.state>0;
				IF v_num_feature > 0 THEN 
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"1074", "function":"2130","debug_msg":"'||feature_id_aux||'"}}$$);';
				END IF;

				--node's control (only WS)
				IF v_project_type='WS' THEN
					SELECT count(arc_id) INTO v_num_feature FROM node WHERE arc_id=feature_id_aux AND node.state>0;
					IF v_num_feature > 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"1074", "function":"2130","debug_msg":"'||feature_id_aux||'"}}$$);';
					END IF;
				
				--gully's control (only UD)
				ELSIF v_project_type='UD' THEN
					SELECT count(arc_id) INTO v_num_feature FROM gully WHERE arc_id=feature_id_aux AND gully.state>0;
					IF v_num_feature > 0 THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"1074", "function":"2130","debug_msg":"'||feature_id_aux||'"}}$$);';
					END IF;	
				END IF;
			END IF;	

		ELSIF feature_type_aux='CONNEC' and state_aux=0 THEN
			SELECT state INTO v_old_state FROM connec WHERE connec_id=feature_id_aux;
			
			IF state_aux!=v_old_state AND (v_downgrade_force IS NOT TRUE) THEN

				--link feature control
				SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='CONNEC' AND exit_id=feature_id_aux AND link.state > 0;
				IF v_num_feature > 0 THEN 
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"1072", "function":"2130","debug_msg":"'||feature_id_aux||'"}}$$);';
				END IF;
				
			ELSIF state_aux!=v_old_state AND (v_downgrade_force IS TRUE) THEN
			
				--link feature control
				SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='CONNEC' AND exit_id=feature_id_aux AND link.state > 0;
				IF v_num_feature > 0 THEN 
					EXECUTE 'SELECT state_type FROM connec WHERE connec_id=$1'
						INTO v_state_type
						USING feature_id_aux;						
					INSERT INTO audit_log_data (fid, feature_type, feature_id, log_message) VALUES (128,'CONNEC', feature_id_aux, concat(v_old_state,',',v_state_type));
				END IF;
			END IF;	

		ELSIF feature_type_aux='GULLY' and state_aux=0 THEN
			SELECT state INTO v_old_state FROM gully WHERE gully_id=feature_id_aux;

			IF state_aux!=v_old_state AND (v_downgrade_force IS NOT TRUE) THEN

				--link feature control
				SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='GULLY' AND exit_id=feature_id_aux AND link.state > 0;
				IF v_num_feature > 0 THEN 
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"1072", "function":"2130","debug_msg":"'||feature_id_aux||'"}}$$);';
				END IF;
				
			ELSIF state_aux!=v_old_state AND (v_downgrade_force IS TRUE) THEN
			
				--link feature control
				SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='GULLY' AND exit_id=feature_id_aux AND link.state > 0;
				IF v_num_feature > 0 THEN 
					EXECUTE 'SELECT state_type FROM gully WHERE gully_id=$1'
						INTO v_state_type
						USING feature_id_aux;
					INSERT INTO audit_log_data (fid, feature_type, feature_id, log_message) VALUES (128,'GULLY', feature_id_aux, concat(v_old_state,',',v_state_type));
				END IF;
			END IF;	
		END IF;
    END IF;

	-- control of insert/update nodes with state(2)
	IF feature_type_aux='NODE' THEN
		SELECT state INTO v_old_state FROM node WHERE node_id=feature_id_aux;
	ELSIF feature_type_aux='ARC' THEN
		SELECT state INTO v_old_state FROM arc WHERE arc_id=feature_id_aux;
	END IF;
	
	IF tg_op_aux = 'INSERT' THEN
		IF state_aux=2 THEN
		
			IF ('role_master' NOT IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member'))) AND
			   (current_user NOT IN (SELECT json_array_elements_text(value::json) FROM config_param_system WHERE parameter = 'admin_superusers')) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1080", "function":"2130","debug_msg":null}}$$);';
			END IF;

			-- check at least one psector defined
			IF (SELECT psector_id FROM plan_psector LIMIT 1) IS NULL THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1081", "function":"2130","debug_msg":null}}$$);';
			END IF;

			-- check user's variable
			SELECT value INTO v_psector_vdefault FROM config_param_user WHERE parameter='plan_psector_vdefault' AND cur_user="current_user"();
			IF v_psector_vdefault IS NULL THEN	
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1083", "function":"2130","debug_msg":null}}$$);';
			END IF;
		END IF;
	
	ELSIF tg_op_aux = 'UPDATE' THEN
		IF state_aux=2 AND v_old_state<2 THEN
		
			-- check user's role
			IF ('role_master' NOT IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member'))) AND
			   (current_user NOT IN (SELECT json_array_elements_text(value::json) FROM config_param_system WHERE parameter = 'admin_superusers')) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1080", "function":"2130","debug_msg":null}}$$);';
			END IF;

			-- check user's variable
			SELECT value INTO v_psector_vdefault FROM config_param_user WHERE parameter='plan_psector_vdefault' AND cur_user="current_user"();
			IF v_psector_vdefault IS NULL THEN	
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1083", "function":"2130","debug_msg":null}}$$);';
			END IF;

			-- TODO: check for nodes in order to disconnect arcs
			-- TODO: check for arcs in order to disconnect links and vnodes

			
		ELSIF state_aux<2 AND v_old_state=2 THEN

			-- check user's role
			IF ('role_master' NOT IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member'))) AND
			   (current_user NOT IN (SELECT json_array_elements_text(value::json) FROM config_param_system WHERE parameter = 'admin_superusers')) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1080", "function":"2130","debug_msg":null}}$$);';
			END IF;
		END IF;	
	END IF;

	RETURN 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
