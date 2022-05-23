/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3146

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_hydrology()  RETURNS trigger AS
$BODY$

DECLARE 


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	IF TG_OP = 'INSERT' THEN

		INSERT INTO cat_hydrology(hydrology_id, name, infiltration, text, active, expl_id, log)
    VALUES (NEW.hydrology_id, NEW.name, NEW.infiltration, NEW.text, NEW.active, NEW.expl_id, NEW.log);

    UPDATE config_param_user SET value=NEW.id WHERE parameter='inp_options_hydrology_scenario' AND cur_user=current_user;

		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN
   	
		UPDATE cat_hydrology 
		SET hydrology_id=NEW.hydrology_id, name=NEW.name, infiltration=NEW.infiltration, text=NEW.text, active=NEW.active, expl_id=NEW.expl_id, log=NEW.log
		WHERE hydrology_id=OLD.hydrology_id;
		
		RETURN NEW;
		
	ELSIF TG_OP = 'DELETE' THEN  
	 
		DELETE FROM cat_hydrology WHERE hydrology_id = OLD.hydrology_id;		
	
		RETURN NULL;
	END IF;
END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


