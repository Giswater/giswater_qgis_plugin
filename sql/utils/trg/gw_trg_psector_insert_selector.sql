/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2450
   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_psector_selector() RETURNS trigger LANGUAGE plpgsql AS $$

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	

	INSERT INTO selector_psector (psector_id, cur_user) VALUES (NEW.psector_id, current_user);
	
	
RETURN NEW;
			
END;
$$;


DROP TRIGGER IF EXISTS gw_trg_psector_selector ON "SCHEMA_NAME".plan_psector;
CREATE TRIGGER gw_trg_psector_selector AFTER INSERT ON "SCHEMA_NAME".plan_psector
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_psector_selector();
