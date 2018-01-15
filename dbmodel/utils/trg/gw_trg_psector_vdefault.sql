/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX
   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_psector_vdefault() RETURNS trigger LANGUAGE plpgsql AS $$

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	-- Scale_vdefault
		IF (NEW.scale IS NULL) THEN
			NEW.scale := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_scale_vdefault' AND "cur_user"="current_user"())::numeric (8,2);
		END IF;
		
	-- Rotation_vdefault
		IF (NEW.rotation IS NULL) THEN
			NEW.rotation := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_rotation_vdefault' AND "cur_user"="current_user"())::numeric (8,4);
		END IF;
		
	-- Gexpenses_vdefault
		IF (NEW.gexpenses IS NULL) THEN
			NEW.gexpenses := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_gexpenses_vdefault' AND "cur_user"="current_user"())::numeric(4,2);
		END IF;
		
	-- Vat_vdefault
		IF (NEW.vat IS NULL) THEN
			NEW.vat := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_vat_vdefault' AND "cur_user"="current_user"())::numeric(4,2);
		END IF;
		
	-- Other_vdefault
		IF (NEW.other IS NULL) THEN
			NEW.other := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_other_vdefault' AND "cur_user"="current_user"())::numeric(4,2);
		END IF;
	
	-- Type_vdefault
		IF (NEW.psector_type IS NULL) THEN
			NEW.psector_type := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_type_vdefault' AND "cur_user"="current_user"())::integer;
		END IF;
RETURN NEW;
			
END;
$$;


DROP TRIGGER IF EXISTS gw_trg_psector_vdefault ON "SCHEMA_NAME".plan_psector;
CREATE TRIGGER gw_trg_psector_vdefault BEFORE INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".plan_psector
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_psector_vdefault();
