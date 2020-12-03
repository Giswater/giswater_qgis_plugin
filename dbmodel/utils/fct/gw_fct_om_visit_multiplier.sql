/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2802

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_om_visit_multiplier(integer, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_om_visit_multiplier(p_data json) 
RETURNS json AS
$BODY$

/*

SELECT SCHEMA_NAME.gw_fct_om_visit_multiplier($${
"client":{"device":4, "infoType":1, "lang":"ES"}, "feature":{"id":11458}}$$)

*/

DECLARE 

v_visit record;
v_feature record;
v_event record;
v_photo record;
v_idlast bigint;
v_eventlast bigint;
v_project_type text;
v_doc record;
v_return json = '{"status":"Accepted"}';
v_visitid integer;
v_querytext text;
v_count integer;

BEGIN 

	SET search_path = "SCHEMA_NAME", public;

	-- get system variables
	SELECT * INTO v_visit FROM om_visit WHERE id=v_visitid;
	SELECT project_type INTO v_project_type FROM sys_version;

	-- Reset sequences
	PERFORM setval('SCHEMA_NAME.om_visit_id_seq', (SELECT max(id) FROM om_visit) , true);
	PERFORM setval('SCHEMA_NAME.doc_x_visit_id_seq', (SELECT max(id) FROM doc_x_visit) , true);
	PERFORM setval('SCHEMA_NAME.om_visit_x_arc_id_seq', (SELECT max(id) FROM om_visit_x_arc) , true);
	PERFORM setval('SCHEMA_NAME.om_visit_x_node_id_seq', (SELECT max(id) FROM om_visit_x_node) , true);
	PERFORM setval('SCHEMA_NAME.om_visit_x_connec_id_seq', (SELECT max(id) FROM om_visit_x_connec) , true);
	PERFORM setval('SCHEMA_NAME.om_visit_event_id_seq', (SELECT max(id) FROM om_visit_event) , true);
	PERFORM setval('SCHEMA_NAME.om_visit_event_photo_id_seq', (SELECT max(id) FROM om_visit_event_photo) , true);
	
	IF v_project_type = 'UD' THEN
		PERFORM setval('SCHEMA_NAME.om_visit_x_gully_id_seq', (SELECT max(id) FROM om_visit_x_gully) , true);
	END IF;

	-- get input data
	v_visitid :=  ((p_data ->>'feature')::json->>'id')::integer;

	-- get if visit is multiplier
	v_querytext =  'SELECT * FROM om_visit_x_node WHERE visit_id = '||(v_visitid)||' UNION 
			SELECT * FROM om_visit_x_arc WHERE visit_id = '||(v_visitid)||' UNION 
			SELECT * FROM om_visit_x_connec WHERE visit_id = '||(v_visitid);
			
	IF v_project_type = 'UD' THEN
		v_querytext = concat(v_querytext, ' UNION SELECT * FROM om_visit_x_gully WHERE visit_id = '||(v_visitid));
	END IF;

	EXECUTE 'SELECT count(*) FROM ('||v_querytext||')a' INTO v_count;

	IF v_count > 1 THEN

		-- getting values from visit
		SELECT * INTO v_visit FROM om_visit WHERE id=v_visitid;

		-- looking for all node features relateds to visit
		FOR v_feature IN SELECT * FROM om_visit_x_node WHERE visit_id=v_visitid
		LOOP 
			-- inserting new visit on visit table
			INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, descript, is_done)
			VALUES (v_visit.visitcat_id, v_visit.ext_code, v_visit.startdate, v_visit.enddate, v_visit.user_name, v_visit.descript, v_visit.is_done) RETURNING id INTO v_idlast;
		
			-- looking for documents
			FOR v_doc IN SELECT * FROM doc_x_visit WHERE visit_id=v_visitid
			LOOP
				INSERT INTO doc_x_visit (visit_id, doc_id) VALUES (v_idlast, v_doc.doc_id);
			END LOOP;

			-- new elements on visit_x_node
			INSERT INTO om_visit_x_node (visit_id, node_id, is_last)
			VALUES (v_idlast, v_feature.node_id, v_feature.is_last);
			
			--looking for events relateds to visit
			FOR v_event IN SELECT * FROM om_visit_event WHERE visit_id=v_visitid
			LOOP
				INSERT INTO om_visit_event (event_code, visit_id, position_id, position_value, parameter_id, value, value1, value2, geom1, geom2, geom3, tstamp, text, index_val, is_last) 
				VALUES (v_event.event_code, v_idlast, v_event.position_id, v_event.position_value, v_event.parameter_id, v_event.value, v_event.value1, 
				v_event.value2, v_event.geom1, v_event.geom2, v_event.geom3, v_event.tstamp, v_event.text, v_event.index_val, v_event.is_last) RETURNING id INTO v_eventlast;

				-- looking for photo relateds to event
				FOR v_photo IN SELECT * FROM om_visit_event_photo WHERE event_id=v_event.id
				LOOP
					INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) 
					VALUES (v_idlast, v_eventlast, v_photo.tstamp, v_photo.value, v_photo.text, v_photo.compass);
				END LOOP;
			END LOOP;		
		END LOOP;

		-- looking for all arc features relateds to visit
		FOR v_feature IN SELECT * FROM om_visit_x_arc WHERE visit_id=v_visitid
		LOOP 
			-- inserting new visit on visit table
			INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, descript, is_done)
			VALUES (v_visit.visitcat_id, v_visit.ext_code, v_visit.startdate, v_visit.enddate, v_visit.user_name, v_visit.descript, v_visit.is_done) RETURNING id INTO v_idlast;
			
			-- looking for documents
			FOR v_doc IN SELECT * FROM doc_x_visit WHERE visit_id=v_visitid
			LOOP
				INSERT INTO doc_x_visit (visit_id, doc_id) VALUES (v_idlast, v_doc.doc_id);
			END LOOP;

			-- new elements on visit_x_arc
			INSERT INTO om_visit_x_arc (visit_id, arc_id, is_last)
			VALUES (v_idlast, v_feature.arc_id, v_feature.is_last);
			
			--looking for events relateds to visit
			FOR v_event IN SELECT * FROM om_visit_event WHERE visit_id=v_visitid
			LOOP
				INSERT INTO om_visit_event (event_code, visit_id, position_id, position_value, parameter_id, value, value1, value2, geom1, geom2, geom3, tstamp, text, index_val, is_last) 
				VALUES (v_event.event_code, v_idlast, v_event.position_id, v_event.position_value, v_event.parameter_id, v_event.value, v_event.value1, 
				v_event.value2, v_event.geom1, v_event.geom2, v_event.geom3, v_event.tstamp, v_event.text, v_event.index_val, v_event.is_last) ON CONFLICT DO NOTHING RETURNING id INTO v_eventlast;

				-- looking for photo relateds to event
				FOR v_photo IN SELECT * FROM om_visit_event_photo WHERE event_id=v_event.id
				LOOP
					INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) 
					VALUES (v_idlast, v_eventlast, v_photo.tstamp, v_photo.value, v_photo.text, v_photo.compass);
				END LOOP;
			END LOOP;
		END LOOP;

		-- looking for all connec features relateds to visit
		FOR v_feature IN SELECT * FROM om_visit_x_connec WHERE visit_id=v_visitid
		LOOP 
			-- inserting new visit on visit table
			INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, descript, is_done)
			VALUES (v_visit.visitcat_id, v_visit.ext_code, v_visit.startdate, v_visit.enddate, v_visit.user_name, v_visit.descript, v_visit.is_done) RETURNING id INTO v_idlast;

			-- looking for documents
			FOR v_doc IN SELECT * FROM doc_x_visit WHERE visit_id=v_visitid
			LOOP
				INSERT INTO doc_x_visit (visit_id, doc_id) VALUES (v_idlast, v_doc.doc_id);
			END LOOP;

			-- new elements on visit_x_connec
			INSERT INTO om_visit_x_connec (visit_id, connec_id, is_last)
			VALUES (v_idlast, v_feature.connec_id, v_feature.is_last);
		
			--looking for events relateds to visit
			FOR v_event IN SELECT * FROM om_visit_event WHERE visit_id=v_visitid
			LOOP
				INSERT INTO om_visit_event (event_code, visit_id, position_id, position_value, parameter_id, value, value1, value2, geom1, geom2, geom3, tstamp, text, index_val, is_last) 
				VALUES (v_event.event_code, v_idlast, v_event.position_id, v_event.position_value, v_event.parameter_id, v_event.value, v_event.value1, 
				v_event.value2, v_event.geom1, v_event.geom2, v_event.geom3, v_event.tstamp, v_event.text, v_event.index_val, v_event.is_last) ON CONFLICT DO NOTHING RETURNING id INTO v_eventlast;

				-- looking for photo relateds to event
				FOR v_photo IN SELECT * FROM om_visit_event_photo WHERE event_id=v_event.id
				LOOP
					INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) 
					VALUES (v_idlast, v_eventlast, v_photo.tstamp, v_photo.value, v_photo.text, v_photo.compass);
				END LOOP;
			END LOOP;
		END LOOP;

		IF v_project_type='UD' THEN
	   
			-- looking for all gully features relateds to visit
			FOR v_feature IN SELECT * FROM om_visit_x_gully WHERE visit_id=v_visitid
			LOOP 
				-- inserting new visit on visit table
				INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, descript, is_done)
				VALUES (v_visit.visitcat_id, v_visit.ext_code, v_visit.startdate, v_visit.enddate, v_visit.user_name, v_visit.descript, v_visit.is_done) RETURNING id INTO v_idlast;
				
				-- looking for documents
				FOR v_doc IN SELECT * FROM doc_x_visit WHERE visit_id=v_visitid
				LOOP
					INSERT INTO doc_x_visit (visit_id, doc_id) VALUES (v_idlast, v_doc.doc_id);
				END LOOP;

				-- new elements on visit_x_gully
				INSERT INTO om_visit_x_gully (visit_id, gully_id, is_last)
				VALUES (v_idlast, v_feature.gully_id, v_feature.is_last);

				--looking for events relateds to visit
				FOR v_event IN SELECT * FROM om_visit_event WHERE visit_id=v_visitid
				LOOP
					INSERT INTO om_visit_event (event_code, visit_id, position_id, position_value, parameter_id, value, value1, value2, geom1, geom2, geom3, tstamp, text, index_val, is_last) 
					VALUES (v_event.event_code, v_idlast, v_event.position_id, v_event.position_value, v_event.parameter_id, v_event.value, v_event.value1, 
					v_event.value2, v_event.geom1, v_event.geom2, v_event.geom3, v_event.tstamp, v_event.text, v_event.index_val, v_event.is_last) ON CONFLICT DO NOTHING RETURNING id INTO v_eventlast;
		
					-- looking for photo relateds to event
					FOR v_photo IN SELECT * FROM om_visit_event_photo WHERE event_id=v_event.id
					LOOP
						INSERT INTO om_visit_event_photo (visit_id, event_id, tstamp, value, text, compass) 
						VALUES (v_idlast, v_eventlast, v_photo.tstamp, v_photo.value, v_photo.text, v_photo.compass);
					END LOOP;
				END LOOP;
			END LOOP;	
		END IF;
	  
		-- delete original visit (and due foreign keys on database deleted also al events and pictures and documents associated with)
		DELETE FROM om_visit WHERE id=v_visitid;  

	END IF;
	
	RETURN v_return;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;