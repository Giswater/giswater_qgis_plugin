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
		
			
		UPDATE arc SET y1=review_audit_arc.y1, y2=review_audit_arc.y2,arccat_id=review_audit_arc.arccat_id FROM review_audit_arc 
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