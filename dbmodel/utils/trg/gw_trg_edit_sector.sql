/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 1124

-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_arc();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_sector()
  RETURNS trigger AS
$BODY$
DECLARE 

	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	
    IF TG_OP = 'INSERT' THEN
				
		--Exploitation ID
            IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
                --PERFORM audit_function(1012,1124);
				RETURN NULL;				
            END IF;
            expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
                --PERFORM audit_function(1014,1124);
				RETURN NULL; 
            END IF;
			
        -- FEATURE INSERT
			INSERT INTO sector (sector_id, descript, the_geom, undelete, expl_id)
			VALUES (NEW.sector_id, NEW.descript, NEW.the_geom, NEW.undelete, expl_id_int);
		
		
		RETURN NEW;
		

    ELSIF TG_OP = 'UPDATE' THEN
   -- FEATURE UPDATE		
			UPDATE sector 
			SET sector_id=NEW.sector_id, descript=NEW.descript, the_geom=NEW.the_geom, undelete=NEW.undelete, expl_id=NEW.expl_id
			WHERE sector_id=NEW.sector_id;
				
        RETURN NEW;


     ELSIF TG_OP = 'DELETE' THEN  
	-- FEATURE DELETE 
		DELETE FROM sector WHERE sector_id = OLD.sector_id;
		
				
		
		RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
  


DROP TRIGGER IF EXISTS gw_trg_edit_sector ON "SCHEMA_NAME".v_edit_sector;
CREATE TRIGGER gw_trg_edit_sector INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_sector FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_sector('sector');







