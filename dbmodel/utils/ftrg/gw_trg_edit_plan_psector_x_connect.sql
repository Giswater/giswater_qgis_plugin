/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_plan_psector_x_connect()
  RETURNS trigger AS
$BODY$

DECLARE 
v_table text;

BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_table:= TG_ARGV[0];

	IF TG_OP = 'INSERT' THEN

		IF v_table = 'plan_psector_x_connec' THEN
			INSERT INTO plan_psector_x_connec (connec_id,  psector_id, state, doable, descript) 
			VALUES (NEW.connec_id,  NEW.psector_id, NEW.state, NEW.doable, NEW.descript); 

		ELSIF v_table = 'plan_psector_x_gully' THEN

			INSERT INTO plan_psector_x_gully (gully_id,  psector_id, state, doable, descript) 
			VALUES (NEW.gully_id,  NEW.psector_id, NEW.state, NEW.doable, NEW.descript); 
		END IF;

		RETURN NEW;
	
	ELSIF TG_OP = 'UPDATE' THEN

		IF v_table = 'plan_psector_x_connec' THEN

			UPDATE plan_psector_x_connec SET doable = NEW.doable, descript = NEW.descript
			WHERE id = NEW.id;
						
		ELSIF v_table = 'plan_psector_x_gully' THEN
		
			UPDATE plan_psector_x_gully SET doable = NEW.doable, descript = NEW.descript
			WHERE id = NEW.id;	
		
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
