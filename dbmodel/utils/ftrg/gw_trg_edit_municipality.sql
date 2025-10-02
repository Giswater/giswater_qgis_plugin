/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3328

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_municipality() 
RETURNS TRIGGER
 LANGUAGE plpgsql
AS $function$


DECLARE
v_newpattern json;
v_status boolean;
v_value text;

BEGIN
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	IF TG_OP = 'INSERT' THEN

	
		-- active
		IF NEW.active IS NULL THEN
			NEW.active = TRUE;
		END IF;
	
		INSERT INTO ext_municipality(muni_id, "name", expl_id, the_geom, active)
		VALUES(NEW.muni_id, NEW.name, NEW.expl_id, NEW.the_geom, NEW.active);
		
		INSERT INTO selector_municipality(muni_id, cur_user)
		VALUES(NEW.muni_id, current_user);

		RETURN NEW;

		
	ELSIF TG_OP = 'UPDATE' THEN
	    
		UPDATE ext_municipality
		SET name= NEW.name, expl_id = NEW.expl_id, the_geom = NEW.the_geom, active = NEW.active WHERE muni_id=OLD.muni_id;

	RETURN NEW;
				
	ELSIF TG_OP = 'DELETE' THEN  

		DELETE FROM ext_municipality WHERE muni_id = OLD.muni_id;
		RETURN NULL;

	END IF;


END;
$function$
;
