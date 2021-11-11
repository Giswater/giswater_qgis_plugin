/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3060


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_curve() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
v_table text;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
   
   v_table = TG_ARGV[0];

	-- Control insertions ID
	IF TG_OP = 'INSERT' THEN
		
		IF v_table = 'inp_curve' THEN
			INSERT INTO inp_curve (id, curve_type, descript, sector_id) 
			VALUES (NEW.id, NEW.curve_type, NEW.descript, NEW.sector_id);
		
		ELSIF v_table = 'inp_curve_value' THEN

			IF NEW.id IS NULL THEN
				PERFORM setval('inp_curve_value_id_seq', (SELECT max(id) FROM inp_curve_value), true);
				NEW.id := (SELECT nextval('inp_curve_value_id_seq'));
			END IF;
			INSERT INTO inp_curve_value (id, curve_id,x_value,y_value) 
			VALUES (NEW.id, NEW.curve_id,NEW.x_value,NEW.y_value);
			
		END IF;
		
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		IF v_table = 'inp_curve' THEN
			UPDATE inp_curve SET id=NEW.id, curve_type=NEW.curve_type, descript=NEW.descript, sector_id=NEW.sector_id
			WHERE id=OLD.id;

		ELSIF v_table = 'inp_curve_value' THEN
			UPDATE inp_curve_value SET curve_id = curve_id, x_value=NEW.x_value,y_value=NEW.y_value
			WHERE id=OLD.id;
		END IF;

		RETURN NEW;
        
	ELSIF TG_OP = 'DELETE' THEN
		IF v_table = 'inp_curve' THEN
			DELETE FROM inp_curve WHERE id=OLD.id;

		ELSIF v_table = 'inp_curve_value' THEN
			DELETE FROM inp_curve_value WHERE curve_id=OLD.curve_id;
		END IF;
		
		RETURN OLD;
   
	END IF;
       
END;
$$;
  