/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2926

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_presszone()  RETURNS trigger AS
$BODY$

DECLARE 
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
    IF TG_OP = 'INSERT' THEN
		
        IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
             -- PERFORM gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        	 -- "data":{"message":"1012", "function":"1112","debug_msg":null, "variables":null}}$$); 
			RETURN NULL;				
            END IF;
            expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
                 -- PERFORM gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        	 -- "data":{"message":"1014", "function":"1112","debug_msg":null, "variables":null}}$$); 
				RETURN NULL; 
            END IF;
			
		INSERT INTO presszone (presszone_id, name, expl_id, the_geom, grafconfig, head, stylesheet)
		VALUES (NEW.presszone_id, NEW.name, expl_id_int, NEW.the_geom, NEW.grafconfig::json, NEW.head, NEW.stylesheet::json);

		RETURN NEW;
		
    ELSIF TG_OP = 'UPDATE' THEN
   	
		UPDATE presszone
		SET presszone_id=NEW.presszone_id, name=NEW.name, expl_id=NEW.expl_id, the_geom=NEW.the_geom, grafconfig=NEW.grafconfig::json,
		head = NEW.head, stylesheet=NEW.stylesheet::json
		WHERE id=NEW.id;
		
		RETURN NEW;
		
    ELSIF TG_OP = 'DELETE' THEN  
	 
		DELETE FROM presszone WHERE presszone_id = OLD.presszone_id;
		RETURN NULL;
     
	END IF;

END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


