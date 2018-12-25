/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1112


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_arc();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_dma()
  RETURNS trigger AS
$BODY$
DECLARE 
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	
    IF TG_OP = 'INSERT' THEN
	
			/*
	        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(1008,1320);  
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(1010,1320);          
            END IF;            
        END IF;
		*/
		--Exploitation ID
            IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
                --PERFORM audit_function(1012,1112);
				RETURN NULL;				
            END IF;
            expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
                --PERFORM audit_function(1014,1112);
				RETURN NULL; 
            END IF;
			
		-- Municipality 
		/*
			IF (NEW.muni_id IS NULL) THEN
				NEW.muni_id := (SELECT "value" FROM config_param_user WHERE "parameter"='municipality_vdefault' AND "cur_user"="current_user"());
				IF (NEW.muni_id IS NULL) THEN
					NEW.muni_id := (SELECT muni_id FROM ext_municipality WHERE ST_DWithin(NEW.the_geom, ext_municipality.the_geom,0.001) LIMIT 1);
						PERFORM audit_function(2024,1212);
				END IF;
			END IF;
			*/
			
        -- FEATURE INSERT
				INSERT INTO dma (dma_id, name, descript,  the_geom, undelete,  expl_id)
				VALUES (NEW.dma_id, NEW.name, NEW.descript, NEW.the_geom, NEW.undelete, expl_id_int);

		RETURN NEW;
		
    ELSIF TG_OP = 'UPDATE' THEN
   	-- FEATURE UPDATE
			UPDATE dma 
			SET dma_id=NEW.dma_id, name=NEW.name, descript=NEW.descript, the_geom=NEW.the_geom, undelete=NEW.undelete, expl_id=NEW.expl_id
			WHERE dma_id=NEW.dma_id;
		
        RETURN NEW;

		
		
     ELSIF TG_OP = 'DELETE' THEN  
	 -- FEATURE DELETE
		DELETE FROM dma WHERE dma_id = OLD.dma_id;		

		RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


