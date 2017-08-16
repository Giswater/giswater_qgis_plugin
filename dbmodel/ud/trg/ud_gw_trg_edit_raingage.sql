/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


   
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_raingage()
  RETURNS trigger AS
$BODY$
DECLARE 
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
    -- Control insertions ID
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
		INSERT INTO raingage (rg_id, form_type, intvl, scf, rgage_type, timser_id, fname, sta, units, the_geom, expl_id) 
		VALUES (NEW.rg_id, NEW.form_type, NEW.intvl, NEW.scf, NEW.rgage_type, NEW.timser_id, NEW.fname, NEW.sta, NEW.units, NEW.the_geom, expl_id_int);
		
		
		PERFORM audit_function (1,780);
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN

       
       -- UPDATE values
		
			UPDATE raingage 
			SET rg_id=NEW.rg_id, form_type=NEW.form_type, intvl=NEW.intvl, scf=NEW.scf, rgage_type=NEW.rgage_type, timser_id=NEW.timser_id, fname=NEW.fname, sta=NEW.sta, units=NEW.units, the_geom=NEW.the_geom, expl_id=NEW.expl_id
			WHERE rg_id = OLD.rg_id;


                
		PERFORM audit_function (2,780);
        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM raingage WHERE rg_id = OLD.rg_id;

		PERFORM audit_function (3,780);
        RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_edit_raingage ON "SCHEMA_NAME".v_edit_raingage;
CREATE TRIGGER gw_trg_edit_raingage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_raingage
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_raingage(raingage);
