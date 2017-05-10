/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


		CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_review_audit_arc() RETURNS trigger AS
		$BODY$
		
		DECLARE

		r "SCHEMA_NAME".review_arc%rowtype;
		
		BEGIN
			EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
				SELECT * into r FROM review_arc;
				
				FOR  r IN SELECT field_checked FROM review_arc WHERE NEW.field_checked is TRUE LOOP
				
					IF EXISTS (SELECT arc_id FROM review_audit_arc WHERE arc_id=NEW.arc_id) THEN
						
							UPDATE review_audit_arc SET arc_id=NEW.arc_id, the_geom=NEW.the_geom, y1=NEW.y1, y2=NEW.y2, arc_type=NEW.arc_type,
							arccat_id=NEW.arccat_id, annotation=NEW.annotation, verified=NEW.verified, field_checked=NEW.field_checked,"operation"='UPDATE',"user"=user,date_field=CURRENT_TIMESTAMP, office_checked=NEW.office_checked
							WHERE arc_id=OLD.arc_id;
							
							
							IF NEW.the_geom::text<>OLD.the_geom::text THEN
								UPDATE review_audit_arc SET moved_geom='TRUE' 
								WHERE arc_id=OLD.arc_id;
							END IF;	
							
						RETURN NEW;
						
					ELSE
					
						IF NEW.the_geom=OLD.the_geom THEN
						INSERT INTO review_audit_arc(arc_id, the_geom, y1, y2, arc_type, arccat_id, annotation, verified, field_checked,"operation", "user", date_field, office_checked,moved_geom) 
						VALUES (NEW.arc_id, NEW.the_geom, NEW.y1, NEW.y2, NEW.arc_type, NEW.arccat_id, NEW.annotation, NEW.verified, NEW.field_checked,'INSERT', user, CURRENT_TIMESTAMP, NEW.office_checked,'FALSE');
						ELSE
						INSERT INTO review_audit_arc(arc_id, the_geom, y1, y2, arc_type, arccat_id, annotation, verified, field_checked,"operation", "user", date_field, office_checked,moved_geom) 
						VALUES (NEW.arc_id, NEW.the_geom, NEW.y1, NEW.y2, NEW.arc_type, NEW.arccat_id, NEW.annotation, NEW.verified, NEW.field_checked,'INSERT', user, CURRENT_TIMESTAMP, NEW.office_checked,'TRUE');
						RETURN NEW;	
						END IF;
					END IF;
					
				END LOOP;
				
			RETURN NEW;
		END;
		$BODY$
		  LANGUAGE plpgsql VOLATILE
		  COST 100;
		  
		DROP TRIGGER IF EXISTS gw_trg_review_audit_arc ON "SCHEMA_NAME".review_arc;
		CREATE TRIGGER gw_trg_review_audit_arc AFTER UPDATE ON "SCHEMA_NAME".review_arc FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_review_audit_arc();
		
