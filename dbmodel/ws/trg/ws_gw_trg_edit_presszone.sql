/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_presszone()
  RETURNS trigger AS
$BODY$
DECLARE 

	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	        
	
	
    IF TG_OP = 'INSERT' THEN
        			
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

				INSERT INTO presszone (id, the_geom, presszonecat_id, sector, text, undelete,expl_id)
				VALUES (NEW.id, NEW.the_geom, NEW.presszonecat_id, NEW.sector, NEW.text, NEW.undelete, expl_id_int);
		
		RETURN NEW;
		
          
    ELSIF TG_OP = 'UPDATE' THEN

							
			UPDATE presszone 
			SET id=NEW.id, the_geom=NEW.the_geom, presszonecat_id=NEW.presszonecat_id, sector=NEW.sector, text=NEW.text, undelete=NEW.undelete, expl_id=NEW.expl_id
			WHERE id=NEW.id;
			
			

		
        PERFORM audit_function(2,340); 
        RETURN NEW;

		 ELSIF TG_OP = 'DELETE' THEN  
			
				DELETE FROM presszone WHERE id=OLD.id;

		
        PERFORM audit_function(3,340); 
        RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  







DROP TRIGGER IF EXISTS gw_trg_edit_presszone ON "SCHEMA_NAME".v_edit_presszone;
CREATE TRIGGER gw_trg_edit_presszone INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_presszone FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_presszone('presszone');

