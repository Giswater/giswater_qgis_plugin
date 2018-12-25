/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION NUMBER: 2480


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_review_audit_gully()
  RETURNS trigger AS
$BODY$

DECLARE
	review_status integer;
	
BEGIN
EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'UPDATE' THEN
	
		SELECT review_status_id INTO review_status FROM review_audit_gully WHERE gully_id=NEW.gully_id;
		
		IF NEW.is_validated = 0 THEN

			DELETE FROM review_gully WHERE gully_id = NEW.gully_id;
			UPDATE review_audit_gully SET is_validated=NEW.is_validated WHERE gully_id=NEW.gully_id;

		ELSIF NEW.is_validated = 1 THEN

			UPDATE review_audit_gully SET is_validated=NEW.is_validated WHERE gully_id=NEW.gully_id;
	
			IF review_status=1 AND NEW.gully_id NOT IN (SELECT gully_id FROM gully) THEN 

				INSERT INTO v_edit_gully (gully_id, top_elev, ymax, sandbox, gratecat_id, gully_type, units, groove, siphon,  connec_arccat_id, featurecat_id, feature_id, annotation, observ, expl_id, the_geom)
				VALUES (NEW.gully_id, NEW.new_top_elev, NEW.new_ymax, NEW.new_sandbox, NEW.new_gratecat_id, NEW.new_gully_type,  NEW.new_units, NEW.new_groove, NEW.new_siphon, NEW.new_connec_arccat_id, 
				NEW.new_featurecat_id, NEW.new_feature_id, NEW.annotation, NEW.observ, NEW.expl_id, NEW.the_geom); 
				
		
			ELSIF review_status=2 THEN
				UPDATE v_edit_gully SET the_geom=NEW.the_geom, top_elev=NEW.new_top_elev, ymax=NEW.new_ymax, sandbox=NEW.new_sandbox, gratecat_id=NEW.new_gratecat_id,gully_type=NEW.new_gully_type, units=NEW.new_units, groove=NEW.new_groove, 
				siphon=NEW.new_siphon, connec_arccat_id=NEW.new_connec_arccat_id, featurecat_id=NEW.new_featurecat_id, feature_id=NEW.new_feature_id, annotation=NEW.annotation, observ=NEW.observ WHERE gully_id=NEW.gully_id;
					
			ELSIF review_status=3 THEN

				UPDATE v_edit_gully SET top_elev=NEW.new_top_elev, ymax=NEW.new_ymax, sandbox=NEW.new_sandbox, gratecat_id=NEW.new_gratecat_id,gully_type=NEW.new_gully_type, units=NEW.new_units, groove=NEW.new_groove, 
				siphon=NEW.new_siphon, connec_arccat_id=NEW.new_connec_arccat_id, featurecat_id=NEW.new_featurecat_id, feature_id=NEW.new_feature_id, annotation=NEW.annotation, observ=NEW.observ
				WHERE gully_id=NEW.gully_id;
	
			END IF;	
			
			
			DELETE FROM review_gully WHERE gully_id = NEW.gully_id;
			
		ELSIF NEW.is_validated = 2 THEN
			
			UPDATE review_gully SET field_checked=FALSE, is_validated=2 WHERE gully_id=NEW.gully_id;
			UPDATE review_audit_gully SET is_validated=NEW.is_validated WHERE gully_id=NEW.gully_id;
			
		END IF;
		
	END IF;	

RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;