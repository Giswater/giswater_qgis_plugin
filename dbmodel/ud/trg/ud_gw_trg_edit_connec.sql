/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1204

   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_connec() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    v_sql varchar;
    connec_id_seq int8;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
        
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

        -- connec ID
        IF (NEW.connec_id IS NULL) THEN
            --PERFORM setval('urn_id_seq', gw_fct_urn(),true);
            NEW.connec_id:= (SELECT nextval('urn_id_seq'));
        END IF;

        -- connec Catalog ID
        IF (NEW.connecat_id IS NULL) THEN
              --  RETURN audit_function(1022,1204); 
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(1008,1204); 
            END IF;
            NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(1010,1204); 
            END IF;
        END IF;
        
		-- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(1012,1204);  
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(1014,1204);  
            END IF;            
        END IF;
		
	   	-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT "value" FROM config_param_user WHERE "parameter"='verified_vdefault' AND "cur_user"="current_user"());
            IF (NEW.verified IS NULL) THEN
                NEW.verified := (SELECT id FROM value_verified limit 1);
            END IF;
        END IF;

		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := (SELECT id FROM value_state limit 1);
            END IF;
        END IF;
		
		-- Workcat_id
        IF (NEW.workcat_id IS NULL) THEN
            NEW.workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
            IF (NEW.workcat_id IS NULL) THEN
                NEW.workcat_id := (SELECT id FROM cat_work limit 1);
            END IF;
        END IF;
		
		--Inventory
		IF (NEW.inventory IS NULL) THEN
			NEW.inventory :='TRUE';
		END IF; 
		
		--Builtdate
		IF (NEW.builtdate IS NULL) THEN
			NEW.builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;  
        
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,1204);
				END IF;		
			END IF;
		END IF;

		-- Municipality 
		IF (NEW.muni_id IS NULL) THEN
			NEW.muni_id := (SELECT "value" FROM config_param_user WHERE "parameter"='municipality_vdefault' AND "cur_user"="current_user"());
			IF (NEW.muni_id IS NULL) THEN
				NEW.muni_id := (SELECT muni_id FROM ext_municipality WHERE ST_DWithin(NEW.the_geom, ext_municipality.the_geom,0.001) LIMIT 1);
					PERFORM audit_function(2024,1212);
				END IF;
			END IF;


        -- FEATURE INSERT
		INSERT INTO connec (connec_id, code, customer_code, top_elev, y1, y2,connecat_id, connec_type, sector_id, demand, "state", state_type, connec_depth, connec_length, arc_id, annotation, "observ",
								"comment",  dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, 
								postnumber, streetaxis2_id, postnumber2, descript, rotation, link, verified, the_geom,  undelete, featurecat_id, feature_id,  label_x, label_y, label_rotation, accessibility,diagonal, expl_id, publish, 
								inventory, uncertain, num_value, private_connecat_id)
		VALUES (NEW.connec_id, NEW.code, NEW.customer_code, NEW.top_elev, NEW.y1, NEW.y2, NEW.connecat_id, NEW.connec_type, NEW.sector_id, NEW.demand,NEW."state", NEW.state_type, NEW.connec_depth, 
								NEW.connec_length, NEW.arc_id, NEW.annotation, NEW."observ", NEW."comment", NEW.dma_id, NEW.soilcat_id, NEW.function_type, NEW.category_type, NEW.fluid_type, NEW.location_type, 
								NEW.workcat_id, NEW.workcat_id_end, NEW.buildercat_id, NEW.builtdate, NEW.enddate, NEW.ownercat_id, NEW.muni_id, NEW.postcode, NEW.streetaxis_id, NEW.postnumber, NEW.streetaxis2_id, NEW.postnumber2, NEW.descript, NEW.rotation, NEW.link, 
								NEW.verified, NEW.the_geom, NEW.undelete,NEW.featurecat_id,NEW.feature_id, NEW.label_x, NEW.label_y, NEW.label_rotation,
								NEW.accessibility, NEW.diagonal, NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, NEW.num_value, NEW.private_connecat_id);

        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN

       -- UPDATE geom/dma/sector/expl_id
        IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)THEN   
		UPDATE connec SET the_geom=NEW.the_geom;
		NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);          
		NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);         
		NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);         			
        END IF;

        -- Looking for state control
        IF (NEW.state != OLD.state) THEN   
		PERFORM gw_fct_state_control('CONNEC', NEW.connec_id, NEW.state, TG_OP);	
 	END IF;


        UPDATE connec 
        SET  code=NEW.code, top_elev=NEW.top_elev, y1=NEW.y1, y2=NEW.y2, connecat_id=NEW.connecat_id, connec_type=NEW.connec_type, sector_id=NEW.sector_id, demand=NEW.demand,
			"state"=NEW."state", state_type=NEW.state_type, connec_depth=NEW.connec_depth, connec_length=NEW.connec_length, arc_id=NEW.arc_id, annotation=NEW.annotation, "observ"=NEW."observ", 
			"comment"=NEW."comment", dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, function_type=NEW.function_type, category_type=NEW.category_type, 
            fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate, enddate=NEW.enddate,
            ownercat_id=NEW.ownercat_id, postcode=NEW.postcode, streetaxis2_id=NEW.streetaxis2_id, postnumber2=NEW.postnumber2, muni_id=NEW.muni_id, streetaxis_id=NEW.streetaxis_id, postnumber=NEW.postnumber, descript=NEW.descript,
            rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, undelete=NEW.undelete, featurecat_id=NEW.featurecat_id,feature_id=NEW.feature_id, 
			label_x=NEW.label_x, label_y=NEW.label_y, label_rotation=NEW.label_rotation, accessibility=NEW.accessibility, diagonal=NEW.diagonal, publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, 
			expl_id=NEW.expl_id,num_value=NEW.num_value, private_connecat_id=NEW.private_connecat_id
        WHERE connec_id = OLD.connec_id;
                
        RETURN NEW;


    ELSIF TG_OP = 'DELETE' THEN
	
		PERFORM gw_fct_check_delete(OLD.connec_id, 'CONNEC');
	
        DELETE FROM connec WHERE connec_id = OLD.connec_id;

        RETURN NULL;
   
    END IF;

END;
$$;


DROP TRIGGER IF EXISTS gw_trg_edit_connec ON "SCHEMA_NAME".v_edit_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec();
      