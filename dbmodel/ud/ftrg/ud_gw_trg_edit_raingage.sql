/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1222
   
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_raingage()
  RETURNS trigger AS
$BODY$
DECLARE 
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
     		     
	-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,1216,NEW.rg_id);
				END IF;		
			END IF;
		END IF;	

		
		        -- FEATURE INSERT
		INSERT INTO raingage (rg_id, form_type, intvl, scf, rgage_type, timser_id, fname, sta, units, the_geom, expl_id) 
		VALUES (NEW.rg_id, NEW.form_type, NEW.intvl, NEW.scf, NEW.rgage_type, NEW.timser_id, NEW.fname, NEW.sta, NEW.units, NEW.the_geom, NEW.expl_id);
		
		
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN

       
       -- UPDATE values
		
			UPDATE raingage 
			SET rg_id=NEW.rg_id, form_type=NEW.form_type, intvl=NEW.intvl, scf=NEW.scf, rgage_type=NEW.rgage_type, timser_id=NEW.timser_id, fname=NEW.fname, sta=NEW.sta, units=NEW.units, the_geom=NEW.the_geom, expl_id=NEW.expl_id
			WHERE rg_id = OLD.rg_id;


                
        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM raingage WHERE rg_id = OLD.rg_id;

        RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;