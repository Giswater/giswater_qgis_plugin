/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION ud_t4.gw_trg_edit_plan_psector_x_connect()
  RETURNS trigger AS
$BODY$

DECLARE 
v_table text;

BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_table:= TG_ARGV[0];

	IF TG_OP = 'INSERT' THEN

		IF v_table = 'plan_psector_x_connec' THEN
			INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript) 
			VALUES (NEW.connec_id, NEW.arc_id, NEW.psector_id, NEW.state, NEW.doable, NEW.descript); 

			IF NEW.state = 0 THEN -- double insert
				INSERT INTO plan_psector_x_connec (connec_id, arc_id, psector_id, state, doable, descript) 
				VALUES (NEW.connec_id, NEW.arc_id, NEW.psector_id, 1, NEW.doable, NEW.descript); 
			END IF;
			
		ELSIF v_table = 'plan_psector_x_gully' THEN

			-- repetir per gullies quan hagin validat
			
		END IF;

		RETURN NEW;
	
	ELSIF TG_OP = 'UPDATE' THEN

		IF v_table = 'plan_psector_x_connec' THEN

			IF (SELECT state FROM connec WHERE connec_id = NEW.connec_id) = 1 THEN

				IF NEW.state = 0 AND OLD.state = 1 THEN
					DELETE plan_psector_x_connec FROM plan_psector_x_connec 
					WHERE psector_id = NEW.psector_id AND connec_id = NEW.connec_id AND state = 1;

				ELSIF NEW.state = 1 AND OLD.state = 0 THEN
					INSERT INTO plan_psector_x_connec (connec_id, psector_id, state) 
					VALUES (NEW.connec_id, NEW.psector_id, 1); 
				END IF;
			END IF;

			UPDATE plan_psector_x_connec SET arc_id = NEW.arc_id, doable = NEW.doable, descript = NEW.descript
			WHERE psector_id = NEW.psector_id AND connec_id = NEW.connec_id AND state = NEW.state;	
			
		ELSIF v_table = 'plan_psector_x_gully' THEN
		
			IF  (SELECT state FROM gully WHERE gully_id = NEW.gully) = 1 THEN

			-- repetir per gully quan hagim validat

			END IF;

			UPDATE plan_psector_x_gully SET arc_id = NEW.arc_id, doable = NEW.doable, descript = NEW.descript
			WHERE psector_id = NEW.psector_id AND gully_id = NEW.gully_id AND state = NEW.state;	
		
		END IF;
		
		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		IF v_table = 'plan_psector_x_connec' THEN
			DELETE FROM plan_psector_x_connec WHERE id = OLD.id;
					
		ELSIF v_table = 'plan_psector_x_gully' THEN
			DELETE FROM plan_psector_x_gully WHERE id = OLD.id;
			
		END IF;
		
		RETURN OLD;

	END IF;
	
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
