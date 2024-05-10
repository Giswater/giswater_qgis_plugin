/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_arc()
  RETURNS trigger AS
$BODY$

BEGIN
EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'UPDATE' THEN
	
		UPDATE review_audit_arc
		SET office_checked=NEW.office_checked
		WHERE arc_id = OLD.arc_id;
		
		UPDATE review_arc
		SET office_checked=NEW.office_checked
		WHERE arc_id = OLD.arc_id;
		
		
		DELETE FROM review_arc WHERE office_checked IS TRUE AND arc_id = OLD.arc_id;
		
			
		UPDATE arc SET y1=review_audit_arc.y1, y2=review_audit_arc.y2,arccat_id=review_audit_arc.arccat_id, arc_type=review_audit_arc.arc_type, annotation=review_audit_arc.annotation FROM review_audit_arc 
		WHERE arc.arc_id=review_audit_arc.arc_id AND office_checked is TRUE;


		
	END IF;	
	RETURN NULL;
		

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



DROP TRIGGER IF EXISTS gw_trg_edit_review_arc ON "SCHEMA_NAME".v_edit_review_arc;
CREATE TRIGGER gw_trg_edit_review_arc INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_arc FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_arc(review_audit_arc);

DROP TRIGGER IF EXISTS gw_trg_edit_review_arc ON "SCHEMA_NAME".v_edit_review_arc;
CREATE TRIGGER gw_trg_edit_review_arc INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_arc FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_arc(review_arc);