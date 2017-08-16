/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_connec() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    v_sql varchar;
    connec_id_seq int8;
	expl_id_int integer;
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

        -- connec ID
        IF (NEW.connec_id IS NULL) THEN
            PERFORM setval('urn_id_seq', gw_fct_urn(),true);
            NEW.connec_id:= (SELECT nextval('urn_id_seq'));
        END IF;

        -- connec Catalog ID
        IF (NEW.connecat_id IS NULL) THEN
            PERFORM audit_function(150,350); 
            RETURN NULL;                   
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                PERFORM audit_function(115,350); 
                RETURN NULL;                     
            END IF;
            NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                PERFORM audit_function(120,350); 
                RETURN NULL;                     
            END IF;
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                PERFORM audit_function(125,350); 
                RETURN NULL;                         
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                PERFORM audit_function(130,350); 
                RETURN NULL;                     
            END IF;
        END IF;
		
		-- Workcat_id
        IF (NEW.workcat_id IS NULL) THEN
            NEW.workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
            IF (NEW.workcat_id IS NULL) THEN
                NEW.workcat_id := (SELECT id FROM cat_work limit 1);
            END IF;
        END IF;
		
-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT "value" FROM config_vdefault WHERE "parameter"='verified_vdefault' AND "user"="current_user"());
            IF (NEW.verified IS NULL) THEN
                NEW.verified := (SELECT id FROM value_verified limit 1);
            END IF;
        END IF;

		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_vdefault WHERE "parameter"='state_vdefault' AND "user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := (SELECT id FROM value_state limit 1);
            END IF;
        END IF;
		
	--Exploitation ID
            IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
                --PERFORM audit_function(125,340);
				RETURN NULL;				
            END IF;
            expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
                --PERFORM audit_function(130,340);
				RETURN NULL; 
            END IF;
  
		-- Builtdate
			IF (NEW.builtdate IS NULL) THEN
				NEW.builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;  
        
        -- FEATURE INSERT
INSERT INTO connec (connec_id, code, elevation, "depth",connecat_id, sector_id, customer_code, connec_arccat_id, connec_length, demand, "state", annotation, observ, "comment",dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, 
			location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, streetaxis_id, postnumber, descript, rotation, link,verified, the_geom, undelete, label_x,label_y,label_rotation,
		  expl_id, publish, inventory, num_value) 
		  VALUES (NEW.connec_id, NEW.code, NEW.elevation, NEW.depth, NEW.connecat_id, NEW.sector_id, NEW.customer_code, NEW.connec_arccat_id, NEW.connec_length, NEW.demand, NEW.state, NEW.annotation, 
		  NEW.observ, NEW.comment,NEW.dma_id, NEW.presszonecat_id, NEW.soilcat_id, NEW.function_type, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.workcat_id_end,
		  NEW.buildercat_id, NEW.builtdate, NEW.enddate, NEW.ownercat_id, NEW.address_01, NEW.address_02, NEW.address_03, NEW.streetname, NEW.postnumber, 
		  NEW.descript, NEW.rotation, NEW.link, NEW.verified, NEW.the_geom,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation, 
		  expl_id_int, NEW.publish, NEW.inventory, NEW.num_value );
        --PERFORM audit_function(1,350);     
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN

       -- UPDATE dma/sector
        IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)THEN   
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);          
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);         
        END IF;
		
			
		
UPDATE connec 
			SET connec_id=NEW.connec_id, code=NEW.code, elevation=NEW.elevation, "depth"=NEW.depth, connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, customer_code=NEW.customer_code,
			connec_arccat_id=NEW.connec_arccat_id, connec_length=NEW.connec_length, demand=NEW.demand, "state"=NEW.state, annotation=NEW.annotation, observ=NEW.observ, "comment"=NEW.comment, dma_id=NEW.dma_id, 
			presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.soilcat_id, function_type=NEW.function_type, category_type=NEW.category_type, fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, 
			workcat_id_end=NEW.workcat_id_end, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate enddate=NEW.enddate, ownercat_id=NEW.ownercat_id, address_01=NEW.address_01, address_02=NEW.address_02, 
			address_03=NEW.address_03, streetaxis_id=NEW.streetaxis_id, postnumber=NEW.postnumber, descript=NEW.descript,  rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, 
			the_geom=NEW.the_geom, undelete=NEW.undelete, label_x=NEW.label_x,label_y=NEW.label_y, label_rotation=NEW.label_rotation,
			 publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, num_value=NEW.num_value
			WHERE connec_id=OLD.connec_id;
      
       -- PERFORM audit_function(2,350);     
        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN

        DELETE FROM connec WHERE connec_id = OLD.connec_id;

        --PERFORM audit_function(3,350);     
        RETURN NULL;
   
    END IF;

END;
$$;


DROP TRIGGER IF EXISTS gw_trg_edit_connec ON "SCHEMA_NAME".v_edit_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec();

      