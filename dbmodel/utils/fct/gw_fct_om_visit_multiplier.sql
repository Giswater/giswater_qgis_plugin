/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX



DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_om_visit_multiplier(integer, text);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_om_visit_multiplier(visit_id_aux integer, feature_type_aux text) RETURNS void AS
$BODY$

DECLARE 
rec_visit record;
rec_feature record;
rec_event record;
rec_photo record;
id_last bigint;
id_event_last bigint;
project_type_aux text;
rec_doc record;


BEGIN 


    SET search_path = "SCHEMA_NAME", public;

    SELECT * INTO rec_visit FROM om_visit WHERE id=visit_id_aux;
    SELECT wsoftware INTO project_type_aux FROM version;
    
    IF feature_type_aux='NODE' THEN

	-- looking for all features relateds to visit
	FOR rec_feature IN SELECT * FROM om_visit_x_node WHERE visit_id=visit_id_aux
	LOOP 
		-- inserting new visit on visit table
		INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, descript, is_done)
		VALUES (rec_visit.visitcat_id, rec_visit.ext_code, rec_visit.startdate, rec_visit.enddate, rec_visit.user_name, rec_visit.descript, rec_visit.is_done) RETURNING id INTO id_last;
	
		-- looking for documents
		FOR rec_doc IN SELECT * FROM doc_x_visit WHERE visit_id=visit_id_aux
		LOOP
			INSERT INTO doc_x_visit (visit_id, doc_id) VALUES (id_last, rec_doc.doc_id);
		END LOOP;
		
		-- updating values of feature on visit_x_feature table
		UPDATE om_visit_x_node SET visit_id=id_last WHERE visit_id=visit_id_aux AND node_id=rec_feature.node_id;

		--looking for events relateds to visit
		FOR rec_event IN SELECT * FROM om_visit_event WHERE visit_id=visit_id_aux
		LOOP
			INSERT INTO om_visit_event (ext_code, visit_id, position_id, position_value, parameter_id, value, value1, value2, geom1, geom2, geom3, tstamp, text, index_val, is_last) 
			VALUES (rec_event.ext_code, id_last, rec_event.position_id, rec_event.position_value, rec_event.parameter_id, rec_event.value, rec_event.value1, 
			rec_event.value2, rec_event.geom1, rec_event.geom2, rec_event.geom3, rec_event.tstamp, rec_event.text, rec_event.index_val, rec_event.is_last) RETURNING id INTO id_event_last;

			-- looking for photo relateds to event
			FOR rec_photo IN SELECT * FROM om_visit_event_photo WHERE event_id=rec_event.id
			LOOP
				INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) 
				VALUES (id_last, id_event_last, rec_photo.tstamp, rec_photo.value, rec_photo.text, rec_photo.compass);
			END LOOP;
		END LOOP;
	END LOOP;

    ELSIF feature_type_aux='ARC' THEN

	-- looking for all features relateds to visit
	FOR rec_feature IN SELECT * FROM om_visit_x_arc WHERE visit_id=visit_id_aux
	LOOP 
		-- inserting new visit on visit table
		INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, descript, is_done)
		VALUES (rec_visit.visitcat_id, rec_visit.ext_code, rec_visit.startdate, rec_visit.enddate, rec_visit.user_name, rec_visit.descript, rec_visit.is_done) RETURNING id INTO id_last;
		
		-- looking for documents
		FOR rec_doc IN SELECT * FROM doc_x_visit WHERE visit_id=visit_id_aux
		LOOP
			INSERT INTO doc_x_visit (visit_id, doc_id) VALUES (id_last, rec_doc.doc_id);
		END LOOP;
		
		-- updating values of feature on visit_x_feature table
		UPDATE om_visit_x_arc SET visit_id=id_last WHERE visit_id=visit_id_aux AND arc_id=rec_feature.arc_id;

		--looking for events relateds to visit
		FOR rec_event IN SELECT * FROM om_visit_event WHERE visit_id=visit_id_aux
		LOOP
			INSERT INTO om_visit_event (ext_code, visit_id, position_id, position_value, parameter_id, value, value1, value2, geom1, geom2, geom3, tstamp, text, index_val, is_last) 
			VALUES (rec_event.ext_code, id_last, rec_event.position_id, rec_event.position_value, rec_event.parameter_id, rec_event.value, rec_event.value1, 
			rec_event.value2, rec_event.geom1, rec_event.geom2, rec_event.geom3, rec_event.tstamp, rec_event.text, rec_event.index_val, rec_event.is_last) RETURNING id INTO id_event_last;

			-- looking for photo relateds to event
			FOR rec_photo IN SELECT * FROM om_visit_event_photo WHERE event_id=rec_event.id
			LOOP
				INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) 
				VALUES (id_last, id_event_last, rec_photo.tstamp, rec_photo.value, rec_photo.text, rec_photo.compass);
			END LOOP;
		END LOOP;
	END LOOP;

    ELSIF feature_type_aux='CONNEC' THEN

	-- looking for all features relateds to visit
	FOR rec_feature IN SELECT * FROM om_visit_x_connec WHERE visit_id=visit_id_aux
	LOOP 
		-- inserting new visit on visit table
		INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, descript, is_done)
		VALUES (rec_visit.visitcat_id, rec_visit.ext_code, rec_visit.startdate, rec_visit.enddate, rec_visit.user_name, rec_visit.descript, rec_visit.is_done) RETURNING id INTO id_last;

		-- looking for documents
		FOR rec_doc IN SELECT * FROM doc_x_visit WHERE visit_id=visit_id_aux
		LOOP
			INSERT INTO doc_x_visit (visit_id, doc_id) VALUES (id_last, rec_doc.doc_id);
		END LOOP;
		
		-- updating values of feature on visit_x_feature table
		UPDATE om_visit_x_connec SET visit_id=id_last WHERE visit_id=visit_id_aux AND connec_id=rec_feature.connec_id;

		--looking for events relateds to visit
		FOR rec_event IN SELECT * FROM om_visit_event WHERE visit_id=visit_id_aux
		LOOP
			INSERT INTO om_visit_event (ext_code, visit_id, position_id, position_value, parameter_id, value, value1, value2, geom1, geom2, geom3, tstamp, text, index_val, is_last) 
			VALUES (rec_event.ext_code, id_last, rec_event.position_id, rec_event.position_value, rec_event.parameter_id, rec_event.value, rec_event.value1, 
			rec_event.value2, rec_event.geom1, rec_event.geom2, rec_event.geom3, rec_event.tstamp, rec_event.text, rec_event.index_val, rec_event.is_last) RETURNING id INTO id_event_last;

			-- looking for photo relateds to event
			FOR rec_photo IN SELECT * FROM om_visit_event_photo WHERE event_id=rec_event.id
			LOOP
				INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) 
				VALUES (id_last, id_event_last, rec_photo.tstamp, rec_photo.value, rec_photo.text, rec_photo.compass);
			END LOOP;
		END LOOP;
	END LOOP;

   END IF;	

   IF project_type_aux='UD' THEN
   
	IF feature_type_aux='GULLY' THEN

		-- looking for all features relateds to visit
		FOR rec_feature IN SELECT * FROM om_visit_x_gully WHERE visit_id=visit_id_aux
		LOOP 
			-- inserting new visit on visit table
			INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, descript, is_done)
			VALUES (rec_visit.visitcat_id, rec_visit.ext_code, rec_visit.startdate, rec_visit.enddate, rec_visit.user_name, rec_visit.descript, rec_visit.is_done) RETURNING id INTO id_last;
			
			-- looking for documents
			FOR rec_doc IN SELECT * FROM doc_x_visit WHERE visit_id=visit_id_aux
			LOOP
				INSERT INTO doc_x_visit (visit_id, doc_id) VALUES (id_last, rec_doc.doc_id);
			END LOOP;
			
			-- updating values of feature on visit_x_feature table
			UPDATE om_visit_x_gully SET visit_id=id_last WHERE visit_id=visit_id_aux AND gully_id=rec_feature.gully_id;

			--looking for events relateds to visit
			FOR rec_event IN SELECT * FROM om_visit_event WHERE visit_id=visit_id_aux
			LOOP
				INSERT INTO om_visit_event (ext_code, visit_id, position_id, position_value, parameter_id, value, value1, value2, geom1, geom2, geom3, tstamp, text, index_val, is_last) 
				VALUES (rec_event.ext_code, id_last, rec_event.position_id, rec_event.position_value, rec_event.parameter_id, rec_event.value, rec_event.value1, 
				rec_event.value2, rec_event.geom1, rec_event.geom2, rec_event.geom3, rec_event.tstamp, rec_event.text, rec_event.index_val, rec_event.is_last) RETURNING id INTO id_event_last;
	
				-- looking for photo relateds to event
				FOR rec_photo IN SELECT * FROM om_visit_event_photo WHERE event_id=rec_event.id
				LOOP
					INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) 
					VALUES (id_last, id_event_last, rec_photo.tstamp, rec_photo.value, rec_photo.text, rec_photo.compass);
				END LOOP;
			END LOOP;
		END LOOP;
	END IF;	
	
    END IF;


    

   -- delete original visit (and due foreign keys on database deleted also al events and pictures and documents associated with)
   DELETE FROM om_visit WHERE id=visit_id_aux;
   
	
RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
