/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2954


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_macrodqa()
  RETURNS trigger AS
$BODY$
DECLARE 

   
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	
	
    IF TG_OP = 'INSERT' THEN
        				
		--Exploitation ID
      IF ((SELECT COUNT(*) FROM exploitation WHERE active IS TRUE) = 0) THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"1110", "function":"1312","parameters":null}}$$);';
				RETURN NULL;				
      END IF;
      
      IF v_view_name = 'EDIT' THEN
        IF NEW.the_geom IS NOT NULL THEN
				  IF NEW.expl_id IS NULL THEN
            expl_id_int := (SELECT expl_id FROM exploitation WHERE active IS TRUE AND ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
				      expl_id_int := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_exploitation_vdefault' AND "cur_user"="current_user"());
            END IF;
				  END IF;
			  END IF;

		  ELSIF v_view_name = 'UI' THEN
			  IF NEW.active IS NULL THEN
				  NEW.active = TRUE;
			  END IF;
		  END IF;
        
        -- FEATURE INSERT
			
			INSERT INTO macrodqa (macrodqa_id, name, descript, the_geom, expl_id, lock_level)
			VALUES (NEW.macrodqa_id, NEW.name, NEW.descript, NEW.the_geom, expl_id_int, NEW.lock_level);

      IF v_view_name = 'UI' THEN
			  UPDATE macrodqa SET active = NEW.active WHERE macrodqa_id = NEW.macrodqa_id;
		  ELSIF v_view_name = 'EDIT' THEN
			  UPDATE macrodqa SET the_geom = NEW.the_geom WHERE macrodqa_id = NEW.macrodqa_id;
		  END IF;
				
		  RETURN NEW;
		
          
    ELSIF TG_OP = 'UPDATE' THEN

						
			UPDATE macrodqa 
			SET macrodqa_id=NEW.macrodqa_id, name=NEW.name, descript=NEW.descript, the_geom=NEW.the_geom,expl_id=NEW.expl_id, lock_level=NEW.lock_level
			WHERE macrodqa_id=NEW.macrodqa_id;

      IF v_view_name = 'UI' THEN
			  UPDATE macrodqa SET active = NEW.active WHERE macrodqa_id = OLD.macrodqa_id;
		  ELSIF v_view_name = 'EDIT' THEN
			  UPDATE macrodqa SET the_geom = NEW.the_geom WHERE macrodqa_id = OLD.macrodqa_id;
		  END IF;
			
	
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        		"data":{"message":"2", "function":"1312","parameters":null}}$$);';
        RETURN NEW;

		 ELSIF TG_OP = 'DELETE' THEN  		
			
				DELETE FROM macrodqa WHERE macrodqa_id=OLD.macrodqa_id;
		
		
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"3", "function":"1312","parameters":null}}$$);'; 
        RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

