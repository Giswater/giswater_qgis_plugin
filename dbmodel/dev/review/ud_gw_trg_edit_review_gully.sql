/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_gully()
  RETURNS trigger AS
$BODY$

BEGIN
EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'UPDATE' THEN
	
		UPDATE review_audit_gully
		SET office_checked=NEW.office_checked
		WHERE gully_id = OLD.gully_id;
		
		UPDATE review_gully
		SET office_checked=NEW.office_checked
		WHERE gully_id = OLD.gully_id;
		
		
		DELETE FROM review_gully WHERE office_checked IS TRUE AND gully_id = OLD.gully_id;
		

		UPDATE gully SET top_elev=review_audit_gully.top_elev, ymax=review_audit_gully.ymax, matcat_id=review_audit_gully.matcat_id, gratecat_id=review_audit_gully.gratecat_id, units=review_audit_gully.units, groove=review_audit_gully.groove, 
		arccat_id=review_audit_gully.arccat_id, arc_id=review_audit_gully.arc_id, siphon=review_audit_gully.siphon, featurecat_id=review_audit_gully.featurecat_id, feature_id=review_audit_gully.feature_id, annotation=review_audit_gully.annotation
		FROM review_audit_gully
		WHERE gully.gully_id=review_audit_gully.gully_id AND office_checked is TRUE;


		
	END IF;	
	RETURN NULL;
		

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



DROP TRIGGER IF EXISTS gw_trg_edit_review_gully ON "SCHEMA_NAME".v_edit_review_gully;
CREATE TRIGGER gw_trg_edit_review_gully INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_gully FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_gully(review_audit_gully);

DROP TRIGGER IF EXISTS gw_trg_edit_review_gully ON "SCHEMA_NAME".v_edit_review_gully;
CREATE TRIGGER gw_trg_edit_review_gully INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_gully FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_gully(review_gully);