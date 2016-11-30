/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_connec() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    v_sql varchar;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
        
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

        -- connec ID
        IF (NEW.connec_id IS NULL) THEN
            NEW.connec_id:= (SELECT nextval('connec_seq'));
        END IF;

        -- connec Catalog ID
        IF (NEW.connecat_id IS NULL) THEN
                RETURN audit_function(150,860); 
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,860); 
            END IF;
            NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,860); 
            END IF;
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(125,860); 
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(130,860); 
            END IF;
        END IF;
        
        -- FEATURE INSERT
        INSERT INTO connec VALUES (NEW.connec_id, NEW.top_elev, NEW."ymax", NEW.connecat_id, NEW.sector_id, NEW.code, NEW.n_hydrometer,NEW.demand,NEW."state", NEW.annotation, NEW."observ", NEW."comment", NEW.rotation,
                                NEW.dma_id, NEW.soilcat_id, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, 
                                NEW.ownercat_id, NEW.adress_01, NEW.adress_02, NEW.adress_03, NEW.streetaxis_id, NEW.postnumber, NEW.descript, NEW.link, NEW.verified, NEW.the_geom, NEW.workcat_id_end,NEW.y1,NEW.y2,NEW.undelete,NEW.featurecat_id,NEW.feature_id,NEW.private_connecat_id );
              
        PERFORM audit_function (1,860);
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN

        -- UPDATE dma/sector
        IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)THEN   
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);          
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);         
        END IF;

        UPDATE connec 
        SET connec_id=NEW.connec_id, top_elev=NEW.top_elev, ymax=NEW."ymax", connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, code=NEW.code, n_hydrometer=NEW.n_hydrometer,demand=NEW.demand, "state"=NEW."state", 
            annotation=NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, category_type=NEW.category_type, 
            fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate,
            ownercat_id=NEW.ownercat_id, adress_01=NEW.adress_01, adress_02=NEW.adress_02, adress_03=NEW.adress_03, streetaxis_id=NEW.streetaxis_id, postnumber=NEW.postnumber, descript=NEW.descript,
            rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom,workcat_id_end=NEW.workcat_id_end,y1=NEW.y1,y2=NEW.y2,undelete=NEW.undelete,featurecat_id=NEW.featurecat_id,feature_id=NEW.feature_id, private_connecat_id=NEW.private_connecat_id
        WHERE connec_id = OLD.connec_id;
                
        PERFORM audit_function (2,860);
        RETURN NEW;


    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM connec WHERE connec_id = OLD.connec_id;

        PERFORM audit_function (3,860);
        RETURN NULL;
   
    END IF;

END;
$$;


DROP TRIGGER IF EXISTS gw_trg_edit_man_connec ON "SCHEMA_NAME".v_edit_man_connec;
CREATE TRIGGER gw_trg_edit_man_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec();
      