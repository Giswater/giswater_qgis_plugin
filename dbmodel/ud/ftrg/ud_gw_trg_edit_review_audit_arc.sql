/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION NUMBER: 2472


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_audit_arc()
  RETURNS trigger AS
$BODY$

/* INFORMATION ABOUT VALUES ON THIS TRIGGER REVIEW TABLE FUNCTIONALITY
The only updatable value on this view is is_validated and have 3 diferent possible values:
-- is_validated=0 means that I belive new values but I don't want to apply it to the real table
-- is_validated=1 means that I belive new values and I want to apply it to the real table
-- is_validated=2 mean that I don't belive new values and I update field_checked to FALSE again

If is_validated=1, depending on review_status the trigger do diferent actions:
-- review_status=1 new element
-- review_status=2 modified geom (and maybe fields)
-- review_status=3 modified fields but geom is the same

*/

DECLARE
	v_review_status integer;
	
BEGIN
EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'UPDATE' THEN
	
		SELECT review_status_id INTO v_review_status FROM review_audit_arc WHERE arc_id=NEW.arc_id;
		
		IF NEW.is_validated = 0 THEN

			DELETE FROM review_arc WHERE arc_id = NEW.arc_id;
			UPDATE review_audit_arc SET is_validated=NEW.is_validated WHERE arc_id=NEW.arc_id;

		ELSIF NEW.is_validated = 1 THEN

			IF NEW.new_arccat_id IS NULL THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3056", "function":"2472","debug_msg":"'||NEW.arc_id||'"}}$$);';
			END IF;
			
			UPDATE review_audit_arc SET new_arccat_id=NEW.new_arccat_id, is_validated=NEW.is_validated WHERE arc_id=NEW.arc_id;
			
			IF v_review_status =1 AND NEW.arc_id NOT IN (SELECT arc_id FROM arc) THEN 

				INSERT INTO v_edit_arc (arc_id, y1, y2, arc_type, arccat_id, annotation, observ, expl_id, the_geom, matcat_id)
				VALUES (NEW.arc_id, NEW.new_y1, NEW.new_y2, NEW.new_arc_type, NEW.new_arccat_id, NEW.new_annotation, NEW.new_observ, NEW.expl_id, NEW.the_geom, NEW.new_matcat_id); 
				
		
			ELSIF v_review_status =2 THEN
				UPDATE v_edit_arc SET the_geom=NEW.the_geom, y1=NEW.new_y1, y2=NEW.new_y2, arccat_id=NEW.new_arccat_id, annotation=NEW.new_annotation,
				observ=NEW.new_observ, arc_type=NEW.new_arc_type, matcat_id=NEW.new_matcat_id
				WHERE arc_id=NEW.arc_id;
					
			ELSIF  v_review_status =3 THEN

				UPDATE v_edit_arc SET y1=NEW.new_y1, y2=NEW.new_y2, arccat_id=NEW.new_arccat_id, annotation=NEW.new_annotation,
				observ=NEW.new_observ, arc_type=NEW.new_arc_type, matcat_id=NEW.new_matcat_id
				WHERE arc_id=NEW.arc_id;
	
			END IF;	
			
			
			DELETE FROM review_arc WHERE arc_id = NEW.arc_id;

		ELSIF NEW.is_validated = 2 THEN
			
			UPDATE review_arc SET field_checked=FALSE, is_validated=2 WHERE arc_id=NEW.arc_id;
			UPDATE review_audit_arc SET is_validated=NEW.is_validated WHERE arc_id=NEW.arc_id;
		
		END IF;
		
	END IF;	

RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;