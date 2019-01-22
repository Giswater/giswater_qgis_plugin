/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 1124

-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_arc();

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
				
			
        -- FEATURE INSERT
			INSERT INTO sector (sector_id, name, descript, macrosector_id, the_geom, undelete)
			VALUES (NEW.sector_id, NEW.name, NEW.descript, NEW.macrosector_id, NEW.the_geom, NEW.undelete);
	
			INSERT INTO inp_selector_sector (sector_id, cur_user) VALUES (NEW.sector_id, current_user);
		

		
		RETURN NEW;
		

    ELSIF TG_OP = 'UPDATE' THEN
   -- FEATURE UPDATE		
			UPDATE sector 
			SET sector_id=NEW.sector_id, name=NEW.name, descript=NEW.descript, macrosector_id=NEW.macrosector_id, the_geom=NEW.the_geom, undelete=NEW.undelete
			WHERE sector_id=NEW.sector_id;
				
        RETURN NEW;


     ELSIF TG_OP = 'DELETE' THEN  
	-- FEATURE DELETE 
		DELETE FROM sector WHERE sector_id = OLD.sector_id;
		
				
		
		RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;






