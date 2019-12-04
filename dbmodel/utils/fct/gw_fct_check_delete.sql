/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2120


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_check_delete(feature_id_aux text, feature_type_aux text)
  RETURNS void AS
$BODY$
DECLARE
    rec_node record;
    v_num_feature integer;
    v_project_type text;
	v_error text;



BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    SELECT wsoftware INTO v_project_type FROM version LIMIT 1;
	
	
    -- Computing process

    IF feature_type_aux='NODE' THEN
	
	
		IF v_project_type='WS' THEN 
				select count(*) INTO v_num_feature from node join node a on node.parent_id=a.node_id where node.parent_id=feature_id_aux;
				IF v_num_feature > 0 THEN
					v_error = concat(v_num_feature,',',feature_id_aux);
					PERFORM audit_function(2108,2120,v_error);
				END IF;
		END IF;
		
		SELECT count(arc_id) INTO v_num_feature FROM arc WHERE node_1=feature_id_aux OR node_2=feature_id_aux ;
			IF v_num_feature > 0 THEN
				v_error = concat(v_num_feature,',',feature_id_aux);
				PERFORM audit_function(1056,2120,v_error);
			END IF;

		SELECT count(element_id) INTO v_num_feature FROM element_x_node WHERE node_id=feature_id_aux ;
			IF v_num_feature > 0 THEN
				v_error = concat(v_num_feature,',',feature_id_aux);
				PERFORM audit_function(1058,2120,v_error);
			END IF;
			
		SELECT count(doc_id) INTO v_num_feature FROM doc_x_node WHERE node_id=feature_id_aux ;
			IF v_num_feature > 0 THEN
				v_error = concat(v_num_feature,',',feature_id_aux);
				PERFORM audit_function(1060,2120,v_error);
			END IF;
	
		SELECT count(visit_id) INTO v_num_feature FROM om_visit_x_node WHERE node_id=feature_id_aux ;
			IF v_num_feature > 0 THEN
				v_error = concat(v_num_feature,',',feature_id_aux);
				PERFORM audit_function(1062,2120,v_error);
			END IF;
	
		SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='NODE' AND exit_id=feature_id_aux;
			IF v_num_feature > 0 THEN
				v_error = concat(v_num_feature,',',feature_id_aux);
				PERFORM audit_function(1064,2120,v_error);
			END IF;	
			
	
	ELSIF feature_type_aux='ARC' THEN

		SELECT count(element_id) INTO v_num_feature FROM element_x_arc WHERE arc_id=feature_id_aux ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',feature_id_aux);
			PERFORM audit_function(1058,2120,v_error);
		END IF;
		
		SELECT count(doc_id) INTO v_num_feature FROM doc_x_arc WHERE arc_id=feature_id_aux ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',feature_id_aux);
			PERFORM audit_function(1060,2120,v_error);
		END IF;

		SELECT count(visit_id) INTO v_num_feature FROM om_visit_x_arc WHERE arc_id=feature_id_aux ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',feature_id_aux);
			PERFORM audit_function(1062,2120,v_error);
		END IF;

		SELECT count(arc_id) INTO v_num_feature FROM connec WHERE arc_id=feature_id_aux;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',feature_id_aux);
			PERFORM audit_function(1066,2120,v_error);
		END IF;	
	
	
		IF v_project_type='UD' THEN
			SELECT count(arc_id) INTO v_num_feature FROM gully WHERE arc_id=feature_id_aux;
				IF v_num_feature > 0 THEN
					v_error = concat(v_num_feature,',',feature_id_aux);
					PERFORM audit_function(1068,2120,v_error);
				END IF;	
		ELSIF v_project_type='WS' THEN 
				SELECT count(arc_id) INTO v_num_feature FROM node WHERE arc_id=feature_id_aux;
				IF v_num_feature > 0 THEN
					v_error = concat(v_num_feature,',',feature_id_aux);
					PERFORM audit_function(2108,2120,v_error);
				END IF;
		END IF;


    ELSIF feature_type_aux='CONNEC' THEN

		SELECT count(element_id) INTO v_num_feature FROM element_x_connec WHERE connec_id=feature_id_aux ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',feature_id_aux);
			PERFORM audit_function(1058,2120,v_error);
		END IF;
		
		SELECT count(doc_id) INTO v_num_feature FROM doc_x_connec WHERE connec_id=feature_id_aux ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',feature_id_aux);
			PERFORM audit_function(1060,2120,v_error);
		END IF;

		SELECT count(visit_id) INTO v_num_feature FROM om_visit_x_connec WHERE connec_id=feature_id_aux ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',feature_id_aux);
			PERFORM audit_function(1062,2120,v_error);
		END IF;

		SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='CONNEC' AND exit_id=feature_id_aux;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',feature_id_aux);
			PERFORM audit_function(1064,2120,v_error);
		END IF;	


		ELSIF feature_type_aux='GULLY' THEN

		SELECT count(element_id) INTO v_num_feature FROM element_x_gully WHERE gully_id=feature_id_aux ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',feature_id_aux);
			PERFORM audit_function(1058,2120,v_error);
		END IF;
		
		SELECT count(doc_id) INTO v_num_feature FROM doc_x_gully WHERE gully_id=feature_id_aux ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',feature_id_aux);
			PERFORM audit_function(1060,2120,v_error);
		END IF;
	
		SELECT count(visit_id) INTO v_num_feature FROM om_visit_x_gully WHERE gully_id=feature_id_aux ;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',feature_id_aux);
			PERFORM audit_function(1062,2120,v_error);
		END IF;

		SELECT count(link_id) INTO v_num_feature FROM link WHERE exit_type='GULLY' AND exit_id=feature_id_aux;
		IF v_num_feature > 0 THEN
			v_error = concat(v_num_feature,',',feature_id_aux);
			PERFORM audit_function(1064,2120,v_error);
		END IF;	
		
    END IF;

RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

