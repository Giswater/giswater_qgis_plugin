/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


   
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_subcatchment()
  RETURNS trigger AS
$BODY$
DECLARE 
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
    
        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,380);  
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,380);          
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
		
		        -- FEATURE INSERT
		INSERT INTO subcatchment (subc_id, node_id, rg_id, area, imperv, width, slope, clength, snow_id, nimp, nperv, simp, sperv, zero, routeto, rted, maxrate, minrate, decay, drytime, maxinfil, suction, conduct, initdef, curveno, conduct_2, 
		drytime_2, sector_id, hydrology_id, the_geom, expl_id) 
		VALUES (NEW.subc_id, NEW.node_id, NEW.rg_id, NEW.area, NEW.imperv, NEW.width, NEW.slope, NEW.clength, NEW.snow_id, NEW.nimp, NEW.nperv, NEW.simp, NEW.sperv, NEW.zero, NEW.routeto, NEW.rted, NEW.maxrate, 
		NEW.minrate, NEW.decay, NEW.drytime, NEW.maxinfil, NEW.suction, NEW.conduct, NEW.initdef, NEW.curveno, NEW.conduct_2, NEW.drytime_2, NEW.sector_id, NEW.hydrology_id, NEW.the_geom, expl_id_int);
		
		
		PERFORM audit_function (1,780);
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN

       
       -- UPDATE values
		
			UPDATE subcatchment 
			SET subc_id=NEW.subc_id, node_id=NEW.node_id, rg_id=NEW.rg_id, area=NEW.area, imperv=NEW.imperv, width=NEW.width, slope=NEW.slope, clength=NEW.clength, snow_id=NEW.snow_id, nimp=NEW.nimp, nperv=NEW.nperv, 
			simp=NEW.simp, sperv=NEW.sperv, zero=NEW.zero, routeto=NEW.routeto, rted=NEW.rted, maxrate=NEW.maxrate, minrate=NEW.minrate, decay=NEW.decay, drytime=NEW.drytime, maxinfil=NEW.maxinfil, suction=NEW.suction, 
			conduct=NEW.conduct, initdef=NEW.initdef, curveno=NEW.curveno, conduct_2=NEW.conduct_2, drytime_2=NEW.drytime_2, sector_id=NEW.sector_id, hydrology_id=NEW.hydrology_id, the_geom=NEW.the_geom, expl_id=NEW.expl_id
			WHERE subc_id = OLD.subc_id;


                
		PERFORM audit_function (2,780);
        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM subcatchment WHERE subc_id = OLD.subc_id;

		PERFORM audit_function (3,780);
        RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_edit_subcatchment ON "SCHEMA_NAME".v_edit_subcatchment;
CREATE TRIGGER gw_trg_edit_subcatchment INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_subcatchment
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_subcatchment(subcatchment);
