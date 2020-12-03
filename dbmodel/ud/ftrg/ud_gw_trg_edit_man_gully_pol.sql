/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/

--FUNCTION CODE: 2416


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_gully_pol();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_gully_pol() RETURNS trigger AS
$BODY$

DECLARE 
    v_man_table varchar;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_man_table:= TG_ARGV[0];
		
	
	-- INSERT
	IF TG_OP = 'INSERT' THEN
	
		-- Pol ID	
		IF (NEW.pol_id IS NULL) THEN
			PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
			NEW.pol_id:= (SELECT nextval('urn_id_seq'));
		END IF;
		
		-- Gully ID	
		IF (NEW.gully_id IS NULL) THEN
			NEW.gully_id:= (SELECT gully_id FROM v_edit_gully WHERE ST_DWithin(NEW.the_geom, v_edit_gully.the_geom,0.001) LIMIT 1);
			IF (NEW.gully_id IS NULL) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      		 	"data":{"message":"2048", "function":"2416","debug_msg":null}}$$);'; 
			END IF;
		END IF;
			
		-- Insert into polygon table
		INSERT INTO polygon (pol_id, sys_type, the_geom) VALUES (NEW.pol_id, 'GULLY', NEW.the_geom);
		
		-- Update man table
		UPDATE gully SET pol_id=NEW.pol_id WHERE gully_id=NEW.gully_id;
		
		RETURN NEW;
		
    
	-- UPDATE
    ELSIF TG_OP = 'UPDATE' THEN
	
		UPDATE polygon SET pol_id=NEW.pol_id, the_geom=NEW.the_geom WHERE pol_id=OLD.pol_id;
		
		IF (NEW.gully_id != OLD.gully_id) THEN
			IF (SELECT gully_id FROM gully WHERE gully_id=NEW.gully_id) IS NULL THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      		 	"data":{"message":"2050", "function":"2416","debug_msg":null}}$$);';
			END IF;
			UPDATE gully SET pol_id=NULL WHERE gully_id=OLD.gully_id;
			UPDATE gully SET pol_id=NEW.pol_id WHERE gully_id=NEW.gully_id;
		
		END IF;
		
		RETURN NEW;
    
	-- DELETE
    ELSIF TG_OP = 'DELETE' THEN
	
		UPDATE gully SET pol_id=NULL WHERE gully_id=OLD.gully_id;
		DELETE FROM polygon WHERE pol_id=OLD.pol_id;
				
		RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;