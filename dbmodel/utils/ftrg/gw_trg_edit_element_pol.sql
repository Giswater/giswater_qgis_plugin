/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/

--FUNCTION CODE: 2996


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_element_pol() RETURNS trigger AS
$BODY$


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
			
	
	-- INSERT
	IF TG_OP = 'INSERT' THEN
	
		-- Pol ID	
		IF (NEW.pol_id IS NULL) THEN
			PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
			NEW.pol_id:= (SELECT nextval('urn_id_seq'));
		END IF;
		
		-- element id	
		IF (NEW.element_id IS NULL) THEN
			NEW.element_id := (SELECT element_id FROM v_edit_element WHERE ST_DWithin(NEW.the_geom, v_edit_element.the_geom,0.001) LIMIT 1);
			IF (NEW.element_id IS NULL) THEN
				RETURN audit_function(2094,2460);
			END IF;
		END IF;
					
		-- Insert into polygon table
		INSERT INTO polygon (pol_id, sys_type, the_geom) VALUES (NEW.pol_id, 'ELEMENT', NEW.the_geom);
		
		-- Update man table
		UPDATE element SET pol_id=NEW.pol_id WHERE element_id=NEW.element_id;
		
		RETURN NEW;
		
    
	-- UPDATE
	ELSIF TG_OP = 'UPDATE' THEN
	
		UPDATE polygon SET pol_id=NEW.pol_id, the_geom=NEW.the_geom WHERE pol_id=OLD.pol_id;
		
		IF (NEW.element_id != OLD.element_id) THEN
			IF (SELECT element_id FROM v_edit_element WHERE element_id=NEW.element_id) iS NULL THEN
				RETURN audit_function(2098,2460);
			END IF;
			UPDATE v_edit_element SET pol_id=NULL WHERE element_id=OLD.element_id;
			UPDATE v_edit_element SET pol_id=NEW.pol_id WHERE element_id=NEW.element_id;
		
		END IF;
		
		RETURN NEW;
    
	-- DELETE
	ELSIF TG_OP = 'DELETE' THEN
	
		UPDATE v_edit_element SET pol_id=NULL WHERE element_id=OLD.element_id;
		DELETE FROM polygon WHERE pol_id=OLD.pol_id;
				
		RETURN NULL;
		 
	END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;