/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

   
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_arc() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    arc_table varchar;
    man_table varchar;
    v_sql varchar;    

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    arc_table:= TG_ARGV[0];
    
    IF TG_OP = 'INSERT' THEN
    RAISE EXCEPTION '[%]:Insert features is forbidden. To insert new features use the GIS FEATURES layers agrupation of TOC', TG_NAME;
    RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        -- UPDATE position 
        IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)THEN   
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE (NEW.the_geom @ sector.the_geom) LIMIT 1);           
            NEW.dma_id := (SELECT dma_id FROM dma WHERE (NEW.the_geom @ dma.the_geom) LIMIT 1);         
        END IF;


        UPDATE arc 
        SET arc_id=NEW.arc_id, arccat_id=NEW.arccat_id, sector_id=NEW.sector_id, "state"=NEW."state", annotation= NEW.annotation, 
            "observ"=NEW."observ", "comment"=NEW."comment", dma=NEW.dma_id, custom_length=NEW.custom_length, rotation=NEW.rotation, link=NEW.link, 
             verified=NEW.verified, the_geom=NEW.the_geom 
        WHERE arc_id = OLD.arc_id;

        IF arc_table = 'inp_pipe' THEN   
            UPDATE inp_pipe SET arc_id=NEW.arc_id, minorloss=NEW.minorloss, status=NEW.status WHERE arc_id=OLD.arc_id;
        END IF;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM arc WHERE arc_id = OLD.arc_id;
        EXECUTE 'DELETE FROM '||arc_table||' WHERE arc_id = '|| quote_literal(OLD.arc_id);
        RETURN NULL;
    
    END IF;
    
END;
$$;



CREATE TRIGGER gw_trg_edit_inp_node_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_pipe 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_pipe');   

   