/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


			CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_review_audit_node() RETURNS trigger AS
			$BODY$
			
			DECLARE

			r "SCHEMA_NAME".review_node%rowtype;
			move_geom record;
			
			BEGIN
				EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
					SELECT * into r FROM review_node;
					SELECT * INTO move_geom FROM node;

					
					FOR  r IN SELECT field_checked FROM review_node WHERE NEW.field_checked is TRUE LOOP
					
						IF EXISTS (SELECT node_id FROM review_audit_node WHERE node_id=NEW.node_id) THEN
							
									UPDATE review_audit_node SET node_id=NEW.node_id, the_geom=NEW.the_geom, top_elev=NEW.top_elev, ymax=NEW.ymax, node_type=NEW.node_type,
									cat_matcat=NEW.cat_matcat, dimensions=NEW.dimensions, annotation=NEW.annotation, observ=NEW.observ, verified=NEW.verified, field_checked=NEW.field_checked, "operation"='UPDATE',"user"=user, date_field=CURRENT_TIMESTAMP, office_checked=NEW.office_checked,moved_geom='TRUE'
									WHERE node_id=OLD.node_id;
									
								IF NEW.the_geom::text<>OLD.the_geom::text THEN
									UPDATE review_audit_node SET moved_geom='TRUE'
									WHERE node_id=OLD.node_id;
								END IF;	
							RETURN NEW;
							
						ELSE
							IF NEW.the_geom=OLD.the_geom THEN
								INSERT INTO review_audit_node (node_id, the_geom, top_elev, ymax, node_type, cat_matcat, dimensions, annotation, observ, verified, field_checked,"operation", "user", date_field, office_checked,moved_geom) 
								VALUES (NEW.node_id, NEW.the_geom, NEW.top_elev, NEW.ymax, NEW.node_type, NEW.cat_matcat, NEW.dimensions, NEW.annotation, NEW.observ, NEW.verified, NEW.field_checked, 'INSERT', user, CURRENT_TIMESTAMP, 
								NEW.office_checked,'FALSE');						
						ELSE 
								INSERT INTO review_audit_node (node_id, the_geom, top_elev, ymax, node_type, cat_matcat, dimensions, annotation, observ, verified, field_checked,"operation", "user", date_field, office_checked,moved_geom) 
								VALUES (NEW.node_id, NEW.the_geom, NEW.top_elev, NEW.ymax, NEW.node_type, NEW.cat_matcat, NEW.dimensions, NEW.annotation, NEW.observ, NEW.verified, NEW.field_checked, 'INSERT', user, CURRENT_TIMESTAMP, 
								NEW.office_checked,'TRUE');
							END IF;
							
							
							RETURN NEW;	
							
						END IF;
						
					END LOOP;
					
				RETURN NEW;
			END;
			$BODY$
			  LANGUAGE plpgsql VOLATILE
			  COST 100;
			  
			DROP TRIGGER IF EXISTS gw_trg_review_audit_node ON "SCHEMA_NAME".review_node;
			CREATE TRIGGER gw_trg_review_audit_node AFTER UPDATE ON "SCHEMA_NAME".review_node FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_review_audit_node();
			
