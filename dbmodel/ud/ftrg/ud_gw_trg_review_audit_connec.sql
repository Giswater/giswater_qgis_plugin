/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION NUMBER: 2476


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_audit_connec()
  RETURNS trigger AS
$BODY$

DECLARE
	review_status integer;
	
BEGIN
EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'UPDATE' THEN
	
		SELECT review_status_id INTO review_status FROM review_audit_connec WHERE connec_id=NEW.connec_id;
		
		IF NEW.is_validated = 0 THEN

			DELETE FROM review_connec WHERE connec_id = NEW.connec_id;
			UPDATE review_audit_connec SET is_validated=NEW.is_validated WHERE connec_id=NEW.connec_id;

		ELSIF NEW.is_validated = 1 THEN

			IF NEW.new_connecat_id IS NULL THEN
				RAISE EXCEPTION 'It is impossible to validate the connec % without assigning value of connecat_id', NEW.connec_id;
			END IF;
			
			UPDATE review_audit_connec SET new_connecat_id=NEW.new_connecat_id, is_validated=NEW.is_validated WHERE connec_id=NEW.connec_id;
			
			IF review_status=1 AND NEW.connec_id NOT IN (SELECT connec_id FROM connec) THEN 

				INSERT INTO v_edit_connec (connec_id, y1, y2, connec_type, connecat_id, annotation, observ, expl_id, the_geom)
				VALUES (NEW.connec_id, NEW.new_y1, NEW.new_y2, NEW.new_connec_type, NEW.new_connecat_id, NEW.annotation, NEW.observ, NEW.expl_id, NEW.the_geom); 
				
		
			ELSIF review_status=2 THEN
				UPDATE v_edit_connec SET the_geom=NEW.the_geom, y1=NEW.new_y1, y2=NEW.new_y2, connecat_id=NEW.new_connecat_id, connec_type=NEW.new_connec_type, annotation=NEW.annotation, 
				observ=NEW.observ WHERE connec_id=NEW.connec_id;
					
			ELSIF review_status=3 THEN

				UPDATE v_edit_connec SET y1=NEW.new_y1, y2=NEW.new_y2, connecat_id=NEW.new_connecat_id, connec_type=NEW.new_connec_type, annotation=NEW.annotation, 
				observ=NEW.observ
				WHERE connec_id=NEW.connec_id;
	
			END IF;	
			
			
			DELETE FROM review_connec WHERE connec_id = NEW.connec_id;

		ELSIF NEW.is_validated = 2 THEN
			
			UPDATE review_connec SET field_checked=FALSE, is_validated=2 WHERE connec_id=NEW.connec_id;
			UPDATE review_audit_connec SET is_validated=NEW.is_validated WHERE connec_id=NEW.connec_id;
		END IF;
		
	END IF;	

RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;