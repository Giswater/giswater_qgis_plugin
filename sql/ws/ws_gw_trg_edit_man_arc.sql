/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



  
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_man_arc() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    arc_table varchar;
    man_table varchar;
    v_sql varchar;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    man_table:= TG_ARGV[0];

    IF TG_OP = 'INSERT' THEN
    
        -- Arc ID
        IF (NEW.arc_id IS NULL) THEN
            NEW.arc_id := (SELECT nextval('arc_id_seq'));
        END IF;
        
        -- Arc catalog ID
        IF (NEW.arccat_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM cat_arc) = 0) THEN
                RAISE EXCEPTION 'There are no arcs catalog defined in the model, define at least one.';
            END IF;
            NEW.arccat_id := (SELECT id FROM cat_arc LIMIT 1);
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
            END IF;
            NEW.sector_id := (SELECT sector_id FROM sector WHERE (NEW.the_geom @ sector.the_geom) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RAISE EXCEPTION 'Please take a look on your map and use the approach of the sectors!!!';
            END IF;
        END IF;

        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RAISE EXCEPTION 'There are no dma defined in the model, define at least one.';
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE (NEW.the_geom @ dma.the_geom) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RAISE EXCEPTION 'Please take a look on your map and use the approach of the dma!!!';
            END IF;
        END IF;


        -- FEATURE INSERT
        INSERT INTO arc VALUES (NEW.arc_id, null, null, NEW.arccat_id, 'PIPE'::text, NEW.sector_id, NEW."state", NEW.annotation, NEW."observ", NEW."comment", 
                                NEW.custom_length,NEW.dma_id, NEW.soilcat_id, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, 
                                NEW.buildercat_id, NEW.builtdate, NEW.ownercat_id, null, null, null, null, null, 
                                NEW.rotation, NEW.link, NEW.verified, NEW.the_geom);
        
        -- MANAGEMENT INSERT
        IF arc_table = 'man_pipe' THEN   
            INSERT INTO man_pipe VALUES (NEW.arc_id, NEW.add_info);
        END IF;              

        -- EPA INSERT
        IF arc_table = 'man_pipe' THEN   
            INSERT INTO inp_pipe VALUES (NEW.arc_id, null, null);   
        END IF;        
        RETURN NEW;
    
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE arc 
        SET arc_id=NEW.arc_id, arccat_id=NEW.arccat_id, sector_id=NEW.sector_id, "state"=NEW."state", annotation= NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", custom_length=NEW.custom_length, 
            dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, category_type=NEW.category_type, fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate, 
            rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom 
        WHERE node_id=OLD.node_id;

        IF man_table = 'man_pipe' THEN   
            UPDATE man_pipe SET arc_id=NEW.arc_id, add_info=NEW.add_info WHERE arc_id=OLD.arc_id;
        END IF;         
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM arc WHERE arc_id=OLD.arc_id;
        EXECUTE 'DELETE FROM '||man_table||' WHERE arc_id = '||quote_literal(OLD.arc_id);        
        RETURN NULL;

    END IF;
    
END;
$$;
  
  

CREATE TRIGGER gw_trg_edit_man_node_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_pipe 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('man_pipe');
   
   