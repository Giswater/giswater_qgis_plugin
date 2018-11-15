/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_review_audit_connec()
  RETURNS trigger AS
$BODY$

BEGIN

EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

      IF TG_OP = 'INSERT' THEN
		IF NEW.field_checked=TRUE THEN
		
			INSERT INTO review_audit_connec (connec_id, the_geom, top_elev, ymax, connec_type, connecat_id, annotation, verified, field_checked,"operation","user",date_field, office_checked) 
			VALUES(NEW.connec_id, NEW.the_geom, NEW.top_elev, NEW.ymax, NEW.connec_type, NEW.connecat_id, NEW.annotation, 'REVISED', NEW.field_checked,'UPDATE',user,CURRENT_TIMESTAMP, NEW.office_checked);

			UPDATE review_connec SET verified='REVISED' where connec_id=NEW.connec_id;
		END IF;
		
	RETURN NEW;
	
      ELSIF TG_OP = 'UPDATE' THEN
		IF EXISTS (SELECT connec_id FROM review_audit_connec WHERE connec_id=NEW.connec_id) THEN					
			UPDATE review_audit_connec SET connec_id=NEW.connec_id, the_geom=NEW.the_geom, top_elev=NEW.top_elev, ymax=NEW.ymax, connec_type=NEW.connec_type,
			connecat_id=NEW.connecat_id, annotation=NEW.annotation, verified='REVISED', field_checked=NEW.field_checked,"operation"='UPDATE',"user"=user,date_field=CURRENT_TIMESTAMP, office_checked=NEW.office_checked
			WHERE connec_id=OLD.connec_id;
							
				IF NEW.the_geom::text<>OLD.the_geom::text THEN
					UPDATE review_audit_connec SET moved_geom='TRUE' 
					WHERE connec_id=OLD.connec_id;
				END IF;	
				
				RETURN NEW;
				
				UPDATE review_connec SET verified='REVISED' where connec_id=OLD.connec_id;
					
		ELSE
				IF NEW.the_geom=OLD.the_geom THEN
					INSERT INTO review_audit_connec(connec_id, the_geom, top_elev, ymax, connec_type, connecat_id, annotation, verified, field_checked,"operation", "user", date_field, office_checked,moved_geom) 
					VALUES (NEW.connec_id, NEW.the_geom, NEW.top_elev, NEW.ymax, NEW.connec_type, NEW.connecat_id, NEW.annotation, 'REVISED', NEW.field_checked,'INSERT', user, CURRENT_TIMESTAMP, NEW.office_checked,'FALSE');
					
					UPDATE review_connec SET verified='REVISED' where connec_id=OLD.connec_id;
					
				ELSE
					INSERT INTO review_audit_connec(connec_id, the_geom, top_elev, ymax, connec_type, connecat_id, annotation, verified, field_checked,"operation", "user", date_field, office_checked,moved_geom) 
					VALUES (NEW.connec_id, NEW.the_geom, NEW.top_elev, NEW.ymax, NEW.connec_type, NEW.connecat_id, NEW.annotation, 'REVISED', NEW.field_checked,'INSERT', user, CURRENT_TIMESTAMP, NEW.office_checked,'TRUE');
					
					UPDATE review_connec SET verified='REVISED' where connec_id=OLD.connec_id;
					
				END IF;
				
				RETURN NEW;	
		END IF;
     END IF;

     RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



DROP TRIGGER IF EXISTS gw_trg_review_audit_connec ON "SCHEMA_NAME".review_connec;
CREATE TRIGGER gw_trg_review_audit_connec AFTER INSERT OR UPDATE ON "SCHEMA_NAME".review_connec FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_review_audit_connec();