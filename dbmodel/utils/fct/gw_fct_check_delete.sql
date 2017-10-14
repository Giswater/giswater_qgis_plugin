
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_check_delete(feature_id_aux text, feature_type_aux text)
  RETURNS void AS
$BODY$
DECLARE
    rec_node record;
    rec record;
    id_text_aux text;
    id_int_aux integer;
    project_type_aux text;


BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Get data from config table
    SELECT * INTO rec FROM config; 

    SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	
	
    -- Computing process

    IF feature_type_aux='NODE' THEN

	SELECT arc_id INTO id_text_aux FROM arc WHERE node_1=feature_id_aux OR node_2=feature_id_aux LIMIT 1;
		IF id_text_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more arcs (%) atached to deleted feature (%). Please review it before delete', id_text_aux, feature_id_aux;
		END IF;

	SELECT element_id INTO id_text_aux FROM element_x_node WHERE node_id=feature_id_aux LIMIT 1;
		IF id_text_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more element(%) atached to deleted feature (%). Please review it before delete', id_text_aux, feature_id_aux;
		END IF;
		
	SELECT doc_id INTO id_text_aux FROM doc_x_node WHERE node_id=feature_id_aux LIMIT 1;
		IF id_text_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more document (%) atached to deleted feature (%). Please review it before delete', id_text_aux, feature_id_aux;
		END IF;

	SELECT visit_id INTO id_int_aux FROM om_visit_x_node WHERE node_id=feature_id_aux LIMIT 1;
		IF id_int_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more visit (%) atached to deleted feature (%). Please review it before delete', id_int_aux, feature_id_aux;
		END IF;

	SELECT link_id INTO id_int_aux FROM link WHERE exit_type='NODE' AND exit_id=feature_id_aux LIMIT 1 ;
		IF id_int_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more link (%) atached to deleted feature (%). Please review it before delete', id_int_aux, feature_id_aux;
		END IF;	
		

    ELSIF feature_type_aux='ARC' THEN

	SELECT element_id INTO id_text_aux FROM element_x_arc WHERE arc_id=feature_id_aux LIMIT 1;
		IF id_text_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more element (%) atached to deleted feature (%). Please review it before delete', id_text_aux, feature_id_aux;
		END IF;
		
	SELECT doc_id INTO id_text_aux FROM doc_x_arc WHERE arc_id=feature_id_aux LIMIT 1;
		IF id_text_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more document (%) atached to deleted feature (%). Please review it before delete', id_text_aux, feature_id_aux;
		END IF;

	SELECT visit_id INTO id_int_aux FROM om_visit_x_arc WHERE arc_id=feature_id_aux LIMIT 1;
		IF id_int_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more visit (%) atached to deleted feature (%). Please review it before delete', id_int_aux, feature_id_aux;
		END IF;

	SELECT arc_id INTO id_int_aux FROM connec WHERE arc_id=feature_id_aux LIMIT 1 ;
		IF id_int_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more conec (%) atached to deleted feature (%). Please review it before delete', id_int_aux, feature_id_aux;
		END IF;	
		
	IF project_type_aux='UD' THEN
		SELECT arc_id INTO id_int_aux FROM gully WHERE arc_id=feature_id_aux LIMIT 1 ;
			IF id_int_aux IS NOT NULL THEN
				RAISE EXCEPTION ' There are at least one or more gully (%) atached to deleted feature (%). Please review it before delete', id_int_aux, feature_id_aux;
			END IF;	
	END IF;


    ELSIF feature_type_aux='CONNEC' THEN

	SELECT element_id INTO id_text_aux FROM element_x_connec WHERE connec_id=feature_id_aux LIMIT 1;
		IF id_text_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more element (%) atached to deleted feature (%). Please review it before delete', id_text_aux, feature_id_aux;
		END IF;
		
	SELECT doc_id INTO id_text_aux FROM doc_x_connec WHERE connec_id=feature_id_aux LIMIT 1;
		IF id_text_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more document (%) atached to deleted feature (%). Please review it before delete', id_text_aux, feature_id_aux;
		END IF;

	SELECT visit_id INTO id_int_aux FROM om_visit_x_connec WHERE connec_id=feature_id_aux LIMIT 1;
		IF id_int_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more visit (%) atached to deleted feature (%). Please review it before delete', id_int_aux, feature_id_aux;
		END IF;

	SELECT link_id INTO id_int_aux FROM link WHERE exit_type='CONNEC' AND exit_id=feature_id_aux LIMIT 1 ;
		IF id_int_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more link (%) atached to deleted feature (%). Please review it before delete', id_int_aux, feature_id_aux;
		END IF;	


    ELSIF feature_type_aux='GULLY' THEN

	SELECT element_id INTO id_text_aux FROM element_x_gully WHERE gully_id=feature_id_aux LIMIT 1;
		IF id_text_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more element (%) atached to deleted feature (%). Please review it before delete', id_text_aux, feature_id_aux;
		END IF;
		
	SELECT doc_id INTO id_text_aux FROM doc_x_gully WHERE gully_id=feature_id_aux LIMIT 1;
		IF id_text_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more document (%) atached to deleted feature (%). Please review it before delete', id_text_aux, feature_id_aux;
		END IF;

	SELECT visit_id INTO id_int_aux FROM om_visit_x_gully WHERE gully_id=feature_id_aux LIMIT 1;
		IF id_int_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more visit (%) atached to deleted feature (%). Please review it before delete', id_int_aux, feature_id_aux;
		END IF;

	SELECT link_id INTO id_int_aux FROM link WHERE exit_type='GULLY' AND exit_id=feature_id_aux LIMIT 1 ;
		IF id_int_aux IS NOT NULL THEN
			RAISE EXCEPTION ' There are at least one or more link (%) atached to deleted feature (%). Please review it before delete', id_int_aux, feature_id_aux;
		END IF;	
     END IF;


RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_check_delete(text, text)
  OWNER TO postgres;

