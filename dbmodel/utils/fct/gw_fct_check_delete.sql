
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_check_delete(feature_id_aux text, feature_type_aux text)
  RETURNS void AS
$BODY$
DECLARE
    rec_node record;
    rec record;
    num_feature integer;
    project_type_aux text;


BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Get data from config table
    SELECT * INTO rec FROM config; 

    SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	
	
    -- Computing process

    IF feature_type_aux='NODE' THEN

	SELECT count(arc_id) INTO num_feature FROM arc WHERE node_1=feature_id_aux OR node_2=feature_id_aux ;
		IF num_feature > 0 THEN
			RAISE EXCEPTION ' There are at least one or more arcs (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;

	SELECT count(element_id) INTO num_feature FROM element_x_node WHERE node_id=feature_id_aux ;
		IF num_feature > 0 THEN
			RAISE EXCEPTION ' There are at least one or more element(%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;
		
	SELECT count(doc_id) INTO num_feature FROM doc_x_node WHERE node_id=feature_id_aux ;
		IF num_feature > 0 THEN
			RAISE EXCEPTION ' There are at least one or more document (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;

	SELECT count(visit_id) INTO num_feature FROM om_visit_x_node WHERE node_id=feature_id_aux ;
		IF num_feature IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more visit (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;

	SELECT count(link_id) INTO num_feature FROM link WHERE exit_type='NODE' AND exit_id=feature_id_aux LIMIT 1 ;
		IF num_feature IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more link (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;	
		

    ELSIF feature_type_aux='ARC' THEN

	SELECT count(element_id) INTO num_feature FROM element_x_arc WHERE arc_id=feature_id_aux ;
		IF num_feature > 0 THEN
			RAISE EXCEPTION ' There are at least one or more element (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;
		
	SELECT count(doc_id) INTO num_feature FROM doc_x_arc WHERE arc_id=feature_id_aux ;
		IF num_feature > 0 THEN
			RAISE EXCEPTION ' There are at least one or more document (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;

	SELECT count(visit_id) INTO num_feature FROM om_visit_x_arc WHERE arc_id=feature_id_aux ;
		IF num_feature IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more visit (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;

	SELECT count(arc_id) INTO num_feature FROM connec WHERE arc_id=feature_id_aux LIMIT 1 ;
		IF num_feature IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more conec (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;	
		
	IF project_type_aux='UD' THEN
		SELECT count(arc_id) INTO num_feature FROM gully WHERE arc_id=feature_id_aux LIMIT 1 ;
			IF num_feature IS NOT NULL THEN
				RAISE EXCEPTION ' There are at least one or more gully (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
			END IF;	
	END IF;


    ELSIF feature_type_aux='CONNEC' THEN

	SELECT count(element_id) INTO num_feature FROM element_x_connec WHERE connec_id=feature_id_aux ;
		IF num_feature > 0 THEN
			RAISE EXCEPTION ' There are at least one or more element (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;
		
	SELECT count(doc_id) INTO num_feature FROM doc_x_connec WHERE connec_id=feature_id_aux ;
		IF num_feature > 0 THEN
			RAISE EXCEPTION ' There are at least one or more document (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;

	SELECT count(visit_id) INTO num_feature FROM om_visit_x_connec WHERE connec_id=feature_id_aux ;
		IF num_feature IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more visit (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;

	SELECT count(link_id) INTO num_feature FROM link WHERE exit_type='CONNEC' AND exit_id=feature_id_aux LIMIT 1 ;
		IF num_feature IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more link (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;	


    ELSIF feature_type_aux='GULLY' THEN

	SELECT count(element_id) INTO num_feature FROM element_x_gully WHERE gully_id=feature_id_aux ;
		IF num_feature > 0 THEN
			RAISE EXCEPTION ' There are at least one or more element (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;
		
	SELECT count(doc_id) INTO num_feature FROM doc_x_gully WHERE gully_id=feature_id_aux ;
		IF num_feature > 0 THEN
			RAISE EXCEPTION ' There are at least one or more document (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;

	SELECT count(visit_id) INTO num_feature FROM om_visit_x_gully WHERE gully_id=feature_id_aux ;
		IF num_feature IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more visit (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;

	SELECT count(link_id) INTO num_feature FROM link WHERE exit_type='GULLY' AND exit_id=feature_id_aux LIMIT 1 ;
		IF num_feature IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more link (%) atached to deleted feature (%). Please review it before delete', num_feature, feature_id_aux;
		END IF;	
     END IF;


RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_check_delete(text, text)
  OWNER TO postgres;

