/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2548

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_om_visit()
  RETURNS trigger AS
$BODY$
DECLARE 
  

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- automatic creation of workcat
    IF (SELECT (value::json->>'AutoNewWorkcat') FROM config_param_system WHERE parameter='om_visit_parameters') THEN
	
		IF TG_OP='INSERT' THEN
			INSERT INTO cat_work (id) VALUES (NEW.id);
			RETURN NEW;	
			
		ELSIF TG_OP='DELETE' THEN
			DELETE FROM cat_work WHERE id=OLD.id;
			RETURN OLD;
			
		END IF;
		
    END IF;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
