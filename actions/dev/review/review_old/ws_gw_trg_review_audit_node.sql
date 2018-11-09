/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_review_audit_node() RETURNS trigger AS
$BODY$

BEGIN
EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'INSERT' THEN
	
			IF NEW.field_checked=TRUE THEN
				INSERT INTO review_audit_node (node_id, the_geom, elevation, "depth", nodecat_id, annotation, observ, verified, field_checked,"operation", "user", date_field, office_checked) 
				VALUES(NEW.node_id, NEW.the_geom, NEW.elevation, NEW."depth", NEW.nodecat_id, NEW.annotation, NEW.observ, 'REVISED', NEW.field_checked, 'INSERT', user, CURRENT_TIMESTAMP, 
				NEW.office_checked);
				
				UPDATE review_node SET verified='REVISED' where node_id=NEW.node_id;
				
			END IF;	
			
			RETURN NEW;
			
	ELSIF TG_OP = 'UPDATE' THEN
	
		IF EXISTS (SELECT node_id FROM review_audit_node WHERE node_id=NEW.node_id) THEN
			
					UPDATE review_audit_node SET node_id=NEW.node_id, the_geom=NEW.the_geom, elevation=NEW.elevation, "depth"=NEW."depth", nodecat_id=NEW.nodecat_id, annotation=NEW.annotation, observ=NEW.observ, verified='REVISED', field_checked=NEW.field_checked, "operation"='UPDATE',"user"=user, date_field=CURRENT_TIMESTAMP, office_checked=NEW.office_checked
					WHERE node_id=OLD.node_id;
					
				IF NEW.the_geom::text<>OLD.the_geom::text THEN
					UPDATE review_audit_node SET moved_geom='TRUE'
					WHERE node_id=OLD.node_id;
				END IF;	
				RETURN NEW;
				
				UPDATE review_node SET verified='REVISED' where node_id=OLD.node_id;
			
		ELSE
			IF NEW.the_geom=OLD.the_geom THEN
				INSERT INTO review_audit_node (node_id, the_geom, elevation, "depth", nodecat_id, annotation, observ, verified, field_checked,"operation", "user", date_field, office_checked,moved_geom) 
				VALUES (NEW.node_id, NEW.the_geom, NEW.elevation, NEW."depth", NEW.nodecat_id, NEW.annotation, NEW.observ, 'REVISED', NEW.field_checked, 'INSERT', user, CURRENT_TIMESTAMP, 
				NEW.office_checked,'FALSE');						
				
				UPDATE review_node SET verified='REVISED' where node_id=OLD.node_id;
				
		ELSE 
				INSERT INTO review_audit_node (node_id, the_geom, elevation, "depth", nodecat_id, annotation, observ, verified, field_checked,"operation", "user", date_field, office_checked,moved_geom) 
				VALUES (NEW.node_id, NEW.the_geom, NEW.elevation, NEW."depth", NEW.nodecat_id, NEW.annotation, NEW.observ, 'REVISED', NEW.field_checked, 'INSERT', user, CURRENT_TIMESTAMP, 
				NEW.office_checked,'TRUE');
				
				UPDATE review_node SET verified='REVISED' where node_id=OLD.node_id;
			
			END IF;
			
			
			RETURN NEW;	
			
		END IF;
							

END IF;
RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

DROP TRIGGER IF EXISTS gw_trg_review_audit_node ON "SCHEMA_NAME".review_node;
CREATE TRIGGER gw_trg_review_audit_node AFTER INSERT OR UPDATE ON "SCHEMA_NAME".review_node FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_review_audit_node();
			
