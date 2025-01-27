/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1246


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_arc();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_macrosector()
  RETURNS trigger AS
$BODY$
DECLARE 
	expl_id_int integer;

  view_name TEXT;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    view_name = TG_ARGV[0];

	
    IF TG_OP = 'INSERT' THEN
	
			/*
	        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
       			"data":{"message":"1008", "function":"1246","parameters":null}}$$);';
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN   
                EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
       			"data":{"message":"1010", "function":"1246","parameters":null}}$$);';      
            END IF;            
        END IF;
		*/
			IF view_name = 'ui'THEN
        IF NEW.active IS NULL THEN
          NEW.active = TRUE;
        END IF;
		  END IF;



        -- FEATURE INSERT
				INSERT INTO macrosector (macrosector_id, name, descript, undelete) VALUES (NEW.macrosector_id, NEW.name, NEW.descript, NEW.undelete);

        IF view_name = 'ui' THEN
			    UPDATE macrosector SET active = NEW.active WHERE macrosector_id = NEW.macrosector_id;

		    ELSIF view_name = 'edit' THEN
			    UPDATE macrosector SET the_geom = NEW.the_geom WHERE macrosector_id = NEW.macrosector_id;

		    END IF;

		RETURN NEW;
		
    ELSIF TG_OP = 'UPDATE' THEN
   	-- FEATURE UPDATE
			UPDATE macrosector 
			SET macrosector_id=NEW.macrosector_id, name=NEW.name, descript=NEW.descript, undelete=NEW.undelete
			WHERE macrosector_id=NEW.macrosector_id;


      IF view_name = 'ui' THEN
			  UPDATE macrosector SET active = NEW.active WHERE macrosector_id = OLD.macrosector_id;

		  ELSIF view_name = 'edit' THEN
			  UPDATE macrosector SET the_geom = NEW.the_geom WHERE macrosector_id = OLD.macrosector_id;

		  END IF;
		
        RETURN NEW;

		
		
     ELSIF TG_OP = 'DELETE' THEN  
	 -- FEATURE DELETE
		DELETE FROM macrosector WHERE macrosector_id = OLD.macrosector_id;		

		RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



