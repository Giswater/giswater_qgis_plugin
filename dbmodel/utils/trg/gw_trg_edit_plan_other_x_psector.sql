/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX
   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_plan_psector_x_other() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
   
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
		
		-- measurement_vdefault
			IF (NEW.measurement IS NULL) THEN
				NEW.measurement := (SELECT "value" FROM config_param_user WHERE "parameter"='psector_measurement_vdefault' AND "cur_user"="current_user"())::float;
				IF (NEW.measurement IS NULL) THEN NEW.measurement=1;
				END IF;
			END IF;
			
        INSERT INTO plan_psector_x_other (price_id, measurement, psector_id, descript)
		VALUES  (NEW.price_id, NEW.measurement, NEW.psector_id, NEW.descript);
		
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
		UPDATE plan_psector_x_other
		SET measurement=NEW.measurement, descript=NEW.descript
		WHERE id=OLD.id;		
                
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM plan_psector_x_other WHERE id = OLD.id;
        RETURN NULL;
   
    END IF;

END;
$$;


DROP TRIGGER IF EXISTS gw_trg_edit_plan_psector_x_other ON "SCHEMA_NAME".v_edit_plan_psector_x_other;
CREATE TRIGGER gw_trg_edit_plan_psector_x_other INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_plan_psector_x_other
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_plan_psector_x_other();

      