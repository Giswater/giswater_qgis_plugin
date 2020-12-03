/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_connec()
  RETURNS trigger AS
$BODY$

BEGIN
EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'UPDATE' THEN
	
		UPDATE review_audit_connec
		SET office_checked=NEW.office_checked
		WHERE connec_id = OLD.connec_id;
		
		UPDATE review_connec
		SET office_checked=NEW.office_checked
		WHERE connec_id = OLD.connec_id;
		
		
		DELETE FROM review_connec WHERE office_checked IS TRUE AND connec_id = OLD.connec_id;
		
			
		UPDATE connec SET top_elev=review_audit_connec.top_elev, ymax=review_audit_connec.ymax, connec_type=review_audit_connec.connec_type, connecat_id=review_audit_connec.connecat_id, annotation=review_audit_connec.annotation
		FROM review_audit_connec
		WHERE connec.connec_id=review_audit_connec.connec_id AND office_checked is TRUE;
		
	END IF;	
	RETURN NULL;
		

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



DROP TRIGGER IF EXISTS gw_trg_edit_review_connec ON "SCHEMA_NAME".v_edit_review_connec;
CREATE TRIGGER gw_trg_edit_review_connec INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_connec FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_connec(review_audit_connec);

DROP TRIGGER IF EXISTS gw_trg_edit_review_connec ON "SCHEMA_NAME".v_edit_review_connec;
CREATE TRIGGER gw_trg_edit_review_connec INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_connec FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_connec(review_connec);