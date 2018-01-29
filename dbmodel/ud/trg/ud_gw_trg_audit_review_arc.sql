/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION NUMBER: XXXX


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_audit_review_arc()
  RETURNS trigger AS
$BODY$

BEGIN
EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'UPDATE' AND 
	
		IF NEW.is_validated IS TRUE THEN

			IF NEW.new_arccat_id IS NULL THEN
				RAISE EXCEPTION 'Is not possible to validated the arc % without assign values on arccat_id column', NEW.arc_id;
			END IF;
			
			UPDATE audit_review_arc SET is_validated=TRUE WHERE arc_id=NEW.arc_id;
			
			IF NEW.review_status_id=1 THEN
				INSERT into v_edit_arc 
			
			ELSIF nEW.review_status_id=2 THEN
				UPDATE v_edit_arc SET the_geom=NEW.the_geom WHERE arc_id=NEW.arc_id;
					
			ELSIF nEW.review_status_id=2 or nEW.review_status_id=3 THEN

				UPDATE v_edit_arc SET y1=NEW.new_y1, y2=NEW.new_y2, arccat_id=NEW.new_arccat_id, arc_type=NEW.new_arc_type, annotation=NEW.annotation, observ=NEW.observ;
				WHERE arc_id=NEW.arc_id;
	
			END IF;	
			
			
			DELETE FROM review_arc WHERE arc_id = NEW.arc_id;
		
		END IF;
		
	END IF;	

RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  
/*
DROP TRIGGER IF EXISTS gw_trg_edit_audit_review_arc ON "SCHEMA_NAME".v_edit_audit_review_arc;
CREATE TRIGGER gw_trg_edit_audit_review_arc INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_audit_review_arc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_audit_review_arc();
*/