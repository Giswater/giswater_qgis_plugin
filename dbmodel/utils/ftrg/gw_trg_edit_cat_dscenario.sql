/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 3116

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_cat_dscenario() RETURNS trigger AS $BODY$
DECLARE 
    
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'INSERT' THEN
		INSERT INTO cat_dscenario (dscenario_id, name, descript, dscenario_type, parent_id, expl_id, active) 
		VALUES (NEW.dscenario_id, NEW.name, NEW.descript, NEW.dscenario_type, NEW.parent_id, NEW.expl_id, NEW.active);
		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE cat_dscenario SET dscenario_id = NEW.dscenario_id, name = NEW.name, descript = NEW.descript, dscenario_type=NEW.dscenario_type, parent_id = NEW.parent_id,
		expl_id = NEW.expl_id, active = NEW.active
		WHERE dscenario_id = OLD.dscenario_id;
		RETURN NEW;
		
	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM cat_dscenario WHERE dscenario_id = OLD.dscenario_id;
		RETURN NULL;
	END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;