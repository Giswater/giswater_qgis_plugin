/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_macrodma()
  RETURNS trigger AS
$BODY$
DECLARE 

   
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	
	
    IF TG_OP = 'INSERT' THEN
        	
		--macrodma id
			IF (NEW.macrodma_id IS NULL) THEN
				PERFORM setval('urn_id_seq',PERFORM gw_fct_urn(),true);
				NEW.macrodma_id:= (SELECT nextval('urn_id_seq'));
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
			
				INSERT INTO macrodma (macrodma_id, descript, the_geom, undelete, expl_id)
				VALUES (NEW.macrodma_id, NEW.descript, NEW.the_geom, NEW.undelete, expl_id_int);
				
		RETURN NEW;
		
          
    ELSIF TG_OP = 'UPDATE' THEN

						
			UPDATE macrodma 
			SET macrodma_id=NEW.macrodma_id, descript=NEW.descript, the_geom=NEW.the_geom, undelete=NEW.undelete,expl_id=NEW.expl_id
			WHERE macrodma_id=NEW.macrodma_id;
			
	
        PERFORM audit_function(2,340); 
        RETURN NEW;

		 ELSIF TG_OP = 'DELETE' THEN  		
			
				DELETE FROM macrodma WHERE macrodma_id=OLD.macrodma_id;
		
		
        PERFORM audit_function(3,340); 
        RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  



DROP TRIGGER IF EXISTS gw_trg_edit_macrodma ON "SCHEMA_NAME".v_edit_macrodma;
CREATE TRIGGER gw_trg_edit_macrodma INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_macrodma FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_macrodma('macrodma');

