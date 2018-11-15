/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_review_audit_gully()
  RETURNS trigger AS
$BODY$

BEGIN

EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

      IF TG_OP = 'INSERT' THEN
		IF NEW.field_checked=TRUE THEN
				
			INSERT INTO review_audit_gully (gully_id, the_geom, top_elev, ymax, matcat_id, gratecat_id, units, groove, arccat_id, arc_id, siphon, featurecat_id, feature_id,annotation, verified, field_checked,"operation","user",date_field, office_checked) 
			VALUES(NEW.gully_id, NEW.the_geom, NEW.top_elev, NEW.ymax, NEW.matcat_id, NEW.gratecat_id, NEW.units, NEW.groove, NEW.arccat_id,NEW.arc_id,NEW.siphon, NEW.featurecat_id, NEW.feature_id,NEW.annotation, 'REVISED', 
			NEW.field_checked,'UPDATE',user,CURRENT_TIMESTAMP, NEW.office_checked);

			UPDATE review_gully SET verified='REVISED' where gully_id=NEW.gully_id;
		END IF;
		
	RETURN NEW;
	
      ELSIF TG_OP = 'UPDATE' THEN
		IF EXISTS (SELECT gully_id FROM review_audit_gully WHERE gully_id=NEW.gully_id) THEN					
			UPDATE review_audit_gully SET gully_id=NEW.gully_id, the_geom=NEW.the_geom, top_elev=NEW.top_elev, ymax=NEW.ymax, matcat_id=NEW.matcat_id,
			gratecat_id=NEW.gratecat_id, units=NEW.units, groove=NEW.groove, arccat_id=NEW.arccat_id, arc_id=NEW.arc_id, siphon=NEW.siphon, featurecat_id=NEW.featurecat_id, feature_id=NEW.feature_id, 
			annotation=NEW.annotation, verified='REVISED', field_checked=NEW.field_checked,"operation"='UPDATE',"user"=user,date_field=CURRENT_TIMESTAMP, office_checked=NEW.office_checked
			WHERE gully_id=NEW.gully_id;
							
				IF NEW.the_geom::text<>OLD.the_geom::text THEN
					UPDATE review_audit_gully SET moved_geom='TRUE' 
					WHERE gully_id=NEW.gully_id;
				END IF;	
				
				RETURN NEW;
				
				UPDATE review_gully SET verified='REVISED' where gully_id=NEW.gully_id;
					
		ELSE
				IF NEW.the_geom=OLD.the_geom THEN
					INSERT INTO review_audit_gully(gully_id, the_geom, top_elev, ymax, matcat_id, gratecat_id, units, groove, arccat_id, arc_id, siphon, featurecat_id, feature_id, annotation, verified, field_checked,"operation", "user", 
					date_field, office_checked,moved_geom) 
					VALUES (NEW.gully_id, NEW.the_geom, NEW.top_elev, NEW.ymax, NEW.matcat_id, NEW.gratecat_id, NEW.units, NEW.groove, NEW.arccat_id, NEW.arc_id, NEW.siphon, NEW.featurecat_id, NEW.feature_id,
					NEW.annotation, 'REVISED', NEW.field_checked,'INSERT', user, CURRENT_TIMESTAMP, NEW.office_checked,'FALSE');
					
					UPDATE review_gully SET verified='REVISED' WHERE gully_id=NEW.gully_id;
					
				ELSE
					INSERT INTO review_audit_gully(gully_id, the_geom, top_elev, ymax, matcat_id, gratecat_id, units, groove,arccat_id, arc_id, siphon, featurecat_id, feature_id, annotation, verified, field_checked,"operation", "user",
					date_field, office_checked,moved_geom) 
					VALUES (NEW.gully_id, NEW.the_geom, NEW.top_elev, NEW.ymax, NEW.matcat_id, NEW.gratecat_id, NEW.units, NEW.groove, NEW.arccat_id, NEW.arc_id, NEW.siphon, NEW.featurecat_id, NEW.feature_id,
					NEW.annotation, 'REVISED', NEW.field_checked,'INSERT', user, CURRENT_TIMESTAMP, NEW.office_checked,'TRUE');
					
					UPDATE review_gully SET verified='REVISED' WHERE gully_id=NEW.gully_id;
					
				END IF;
				
				RETURN NEW;	
		END IF;
     END IF;

     RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  
 DROP TRIGGER IF EXISTS gw_trg_review_audit_gully ON "SCHEMA_NAME".review_gully;
CREATE TRIGGER gw_trg_review_audit_gully AFTER INSERT OR UPDATE ON "SCHEMA_NAME".review_gully FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_review_audit_gully();