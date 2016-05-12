/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



   
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_arc() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    arc_table varchar;
    man_table varchar;
    epa_type varchar;
    v_sql varchar;
    old_arctype varchar;
    new_arctype varchar;   

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    arc_table:= TG_ARGV[0];
    epa_type:= TG_ARGV[1];
    
    IF TG_OP = 'INSERT' THEN
    RAISE EXCEPTION 'Insert features is forbidden. To insert new features use the GIS FEATURES layers agrupation of TOC';
	RETURN NEW;
 /*
--	To disable the insert option
    RAISE EXCEPTION 'Insert features is forbidden. To insert new features use the GIS FEATURES layers agrupation of TOC';
	  RETURN NULL;

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

        INSERT INTO arc VALUES (NEW.arc_id, null, null, NEW.y1, NEW.y2, NEW.arc_type, NEW.arccat_id, epa_type::text, NEW.sector_id, NEW."state", NEW.annotation, NEW."observ", 
            NEW."comment", NEW.custom_length, null, null, null, null, null, null, null, null, null, null, null, 
            null, null,NEW.rotation, NEW.link,  NEW.est_y1, NEW.est_y2, NEW.verified, NEW.the_geom);

        IF (epa_type = 'CONDUIT') THEN 
            INSERT INTO  inp_conduit VALUES(NEW.arc_id,NEW.barrels,NEW.culvert,NEW.kentry,NEW.kexit,NEW.kavg,NEW.flap,NEW.q0,NEW.qmax, NEW.seepage);
        ELSIF (epa_type = 'PUMP') THEN 
        	INSERT INTO  inp_pump VALUES(NEW.arc_id,NEW.curve_id,NEW.status,NEW.startup,NEW.shutoff);
		ELSIF (epa_type = 'ORIFICE') THEN 
			INSERT INTO  inp_orifice VALUES(NEW.arc_id,NEW.ori_type,NEW.offset,NEW.cd,NEW.orate,NEW.flap,NEW.shape,NEW.geom1,NEW.geom2,NEW.geom3,NEW.geom4);
		ELSIF (epa_type = 'WEIR') THEN 
			INSERT INTO  inp_weir VALUES(NEW.arc_id,NEW.weir_type,NEW."offset",NEW.cd,NEW.ec,NEW.cd2,NEW.flap,NEW.geom1,NEW.geom2,NEW.geom3,NEW.geom4, NEW.surcharge);
		ELSIF (epa_type = 'OUTLET') THEN 
        	INSERT INTO  inp_outlet VALUES(NEW.arc_id,NEW.outlet_type,NEW."offset",NEW.curve_id,NEW.cd1,NEW.cd2,NEW.flap);
        END IF;

        -- MAN INSERT      
        man_table := (SELECT arc_type.man_table FROM arc_type WHERE arc_type.id=NEW.arc_type);
        v_sql:= 'INSERT INTO '||man_table||' (arc_id) VALUES ('||quote_literal(NEW.arc_id)||')';    
        EXECUTE v_sql;


        RETURN NEW;
    
*/
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE arc 
        SET arc_id=NEW.arc_id, y1=NEW.y1, y2=NEW.y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, sector_id=NEW.sector_id, "state"=NEW."state", annotation= NEW.annotation, 
            "observ"=NEW."observ", "comment"=NEW."comment", custom_length=NEW.custom_length, rotation=NEW.rotation, link=NEW.link, 
             est_y1=NEW.est_y1, est_y2=NEW.est_y2, verified=NEW.verified, the_geom=NEW.the_geom 
        WHERE arc_id = OLD.arc_id;

        IF (epa_type = 'CONDUIT') THEN 
            UPDATE inp_conduit SET arc_id=NEW.arc_id,barrels=NEW.barrels,culvert=NEW.culvert,kentry=NEW.kentry,kexit=NEW.kexit,kavg=NEW.kavg,flap=NEW.flap,q0=NEW.q0,qmax=NEW.qmax, seepage=NEW.seepage WHERE arc_id=OLD.arc_id;
        ELSIF (epa_type = 'PUMP') THEN 
        	UPDATE inp_pump SET arc_id=NEW.arc_id,curve_id=NEW.curve_id,status=NEW.status,startup=NEW.startup,shutoff=NEW.shutoff WHERE arc_id=OLD.arc_id;
		ELSIF (epa_type = 'ORIFICE') THEN 
			UPDATE inp_orifice SET arc_id=NEW.arc_id,ori_type=NEW.ori_type,"offset"=NEW."offset",cd=NEW.cd,orate=NEW.orate,flap=NEW.flap,shape=NEW.shape,geom1=NEW.geom1,geom2=NEW.geom2,geom3=NEW.geom3,geom4=NEW.geom4 WHERE arc_id=OLD.arc_id;
		ELSIF (epa_type = 'WEIR') THEN 
			UPDATE inp_weir SET arc_id=NEW.arc_id,weir_type=NEW.weir_type,"offset"=NEW."offset",cd=NEW.cd,ec=NEW.ec,cd2=NEW.cd2,flap=NEW.flap,geom1=NEW.geom1,geom2=NEW.geom2,geom3=NEW.geom3,geom4=NEW.geom4,surcharge=NEW.surcharge WHERE arc_id=OLD.arc_id;
		ELSIF (epa_type = 'OUTLET') THEN 
        	UPDATE inp_outlet SET arc_id=NEW.arc_id, outlet_type=NEW.outlet_type, "offset"=NEW."offset", curve_id=NEW.curve_id, cd1=NEW.cd1,cd2=NEW.cd2,flap=NEW.flap WHERE arc_id=OLD.arc_id;
		END IF;
        RETURN NEW;




    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM arc WHERE arc_id = OLD.arc_id;
        EXECUTE 'DELETE FROM '||arc_table||' WHERE arc_id = '|| quote_literal(OLD.arc_id);
        RETURN NULL;
    
    END IF;
    
END;
$$;



CREATE TRIGGER gw_trg_edit_inp_arc_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_conduit
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_conduit', 'CONDUIT');   

CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_pump
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_pump', 'PUMP');   

CREATE TRIGGER gw_trg_edit_inp_arc_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_orifice
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_orifice', 'ORIFICE');   

CREATE TRIGGER gw_trg_edit_inp_arc_outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_outlet
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_outlet', 'OUTLET');   

CREATE TRIGGER gw_trg_edit_inp_arc_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_weir
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_weir', 'WEIR');   
 


   