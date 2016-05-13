/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/




CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_arc() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    inp_table varchar;
    man_table varchar;
    v_sql varchar;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    IF TG_OP = 'INSERT' THEN
    
        -- Arc ID
        IF (NEW.arc_id IS NULL) THEN
            NEW.arc_id:= (SELECT nextval('arc_id_seq'));
        END IF;

         -- Arc type & EPA type
        IF (NEW.arc_type IS NULL) THEN
                RAISE EXCEPTION 'Please, define arc_type.';
        ELSE   
		NEW.epa_type:= (SELECT epa_default FROM arc_type WHERE arc_type.id=NEW.arc_type)::text;        
        END IF;        


        -- Arc catalog ID
        IF (NEW.arccat_id IS NULL) THEN
                RAISE EXCEPTION 'Please, define arc_catalog.';
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
        INSERT INTO arc VALUES (NEW.arc_id, null, null, NEW.y1, NEW.y2, NEW.arc_type, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW."state", NEW.annotation, NEW."observ", NEW."comment", NEW.direction, NEW.custom_length,
                                NEW.dma_id, NEW.soilcat_id, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, 
                                NEW.ownercat_id, NEW.adress_01, NEW.adress_02, NEW.adress_03, NEW.descript, NEW.est_y1, NEW.est_y2, NEW.rotation, NEW.link, NEW.verified, NEW.the_geom);
        -- EPA INSERT
        IF (NEW.epa_type = 'CONDUIT') THEN 
            inp_table:= 'inp_conduit';
        ELSIF (NEW.epa_type = 'PUMP') THEN 
            inp_table:= 'inp_pump';
		ELSIF (NEW.epa_type = 'ORIFICE') THEN 
			inp_table:= 'inp_orifice';
		ELSIF (NEW.epa_type = 'WEIR') THEN 
            inp_table:= 'inp_weir';
		ELSIF (NEW.epa_type = 'OUTLET') THEN 
            inp_table:= 'inp_outlet';
        END IF;
        v_sql:= 'INSERT INTO '||inp_table||' (arc_id) VALUES ('||quote_literal(NEW.arc_id)||')';
        EXECUTE v_sql;
        
        -- MAN INSERT      
        man_table := (SELECT arc_type.man_table FROM arc_type WHERE arc_type.id=NEW.arc_type);
        v_sql:= 'INSERT INTO '||man_table||' (arc_id) VALUES ('||quote_literal(NEW.arc_id)||')';    
        EXECUTE v_sql;
        
        RETURN NEW;
    
    ELSIF TG_OP = 'UPDATE' THEN
    
        IF (NEW.epa_type <> OLD.epa_type) THEN    
         
            IF (OLD.epa_type = 'CONDUIT') THEN 
            inp_table:= 'inp_conduit';
			ELSIF (OLD.epa_type = 'PUMP') THEN 
            inp_table:= 'inp_pump';
			ELSIF (OLD.epa_type = 'ORIFICE') THEN 
			inp_table:= 'inp_orifice';
			ELSIF (OLD.epa_type = 'WEIR') THEN 
            inp_table:= 'inp_weir';
			ELSIF (OLD.epa_type = 'OUTLET') THEN 
            inp_table:= 'inp_outlet';
			END IF;
            v_sql:= 'DELETE FROM '||inp_table||' WHERE arc_id = '||quote_literal(OLD.arc_id);
            EXECUTE v_sql;

			IF (NEW.epa_type = 'CONDUIT') THEN 
            inp_table:= 'inp_conduit';
			ELSIF (NEW.epa_type = 'PUMP') THEN 
			inp_table:= 'inp_pump';
			ELSIF (NEW.epa_type = 'ORIFICE') THEN 
			inp_table:= 'inp_orifice';
			ELSIF (NEW.epa_type = 'WEIR') THEN 
            inp_table:= 'inp_weir';
			ELSIF (NEW.epa_type = 'OUTLET') THEN 
            inp_table:= 'inp_outlet';
			END IF;
            v_sql:= 'INSERT INTO '||inp_table||' (arc_id) VALUES ('||quote_literal(NEW.arc_id)||')';
            EXECUTE v_sql;

        END IF;
    
        UPDATE arc 
        SET arc_id=NEW.arc_id, y1=NEW.y1, y2=NEW.y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."state", annotation= NEW.annotation, "observ"=NEW."observ", 
            "comment"=NEW."comment", direction=NEW.direction, custom_length=NEW.custom_length, dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, category_type=NEW.category_type, fluid_type=NEW.fluid_type, 
            location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate,
            ownercat_id=NEW.ownercat_id, adress_01=NEW.adress_01, adress_02=NEW.adress_02, adress_03=NEW.adress_03, descript=NEW.descript,
            rotation=NEW.rotation, link=NEW.link, est_y1=NEW.est_y1, est_y2=NEW.est_y2, verified=NEW.verified, the_geom=NEW.the_geom 
        WHERE arc_id=OLD.arc_id;
        RETURN NEW;

     ELSIF TG_OP = 'DELETE' THEN
     
        DELETE FROM arc WHERE arc_id = OLD.arc_id;
        RETURN NULL;
     
     END IF;

END;
$$;




CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc();

      