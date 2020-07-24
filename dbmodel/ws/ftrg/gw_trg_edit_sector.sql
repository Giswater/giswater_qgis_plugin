/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 1124

-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_sector();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_sector()
  RETURNS trigger AS
$BODY$
DECLARE 


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	
	IF TG_OP = 'INSERT' THEN

	IF NEW.sector_id IS NULL THEN
		NEW.sector_id=(SELECT nextval('SCHEMA_NAME.sector_sector_id_seq'::regclass));
	END IF;
					
			INSERT INTO sector (sector_id, name, descript, macrosector_id, the_geom, undelete, grafconfig, stylesheet)
			VALUES (NEW.sector_id, NEW.name, NEW.descript, NEW.macrosector_id, NEW.the_geom, NEW.undelete, 
			NEW.grafconfig::json, NEW.stylesheet::json);
	
			INSERT INTO selector_sector (sector_id, cur_user) VALUES (NEW.sector_id, current_user);
				
		RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

			UPDATE sector 
			SET sector_id=NEW.sector_id, name=NEW.name, descript=NEW.descript, macrosector_id=NEW.macrosector_id, the_geom=NEW.the_geom, 
			undelete=NEW.undelete, grafconfig=NEW.grafconfig::json, stylesheet = NEW.stylesheet::json
			WHERE sector_id=NEW.sector_id;
				
        RETURN NEW;

     ELSIF TG_OP = 'DELETE' THEN  

		DELETE FROM sector WHERE sector_id = OLD.sector_id;
			
		RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;






