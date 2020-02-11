/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: xxxx

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_presszone()  RETURNS trigger AS
$BODY$

DECLARE 
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
    IF TG_OP = 'INSERT' THEN
		
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
			
			
		INSERT INTO cat_presszone (id, descript, expl_id, the_geom, grafconfig)
		VALUES (NEW.id, NEW.descript, expl_id_int, NEW.the_geom, NEW.grafconfig::json);

		RETURN NEW;
		
    ELSIF TG_OP = 'UPDATE' THEN
   	
		UPDATE cat_presszone 
		SET id=NEW.id, descript=NEW.descript, expl_id=NEW.expl_id, the_geom=NEW.the_geom, grafconfig=NEW.grafconfig::json
		WHERE id=NEW.id;
		
		RETURN NEW;
		
    ELSIF TG_OP = 'DELETE' THEN  
	 
		DELETE FROM cat_presszone WHERE id = OLD.id;		
		RETURN NULL;
     
	END IF;

END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


