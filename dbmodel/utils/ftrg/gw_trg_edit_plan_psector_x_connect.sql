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
v_connec_state integer;
v_link_id integer;
v_arc_id integer;
v_rec record;
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_table:= TG_ARGV[0];

	IF TG_OP = 'INSERT' THEN
		
		IF v_table = 'plan_psector_x_connec' then
		
			EXECUTE 'SELECT state, arc_id FROM connec where connec_id = '''||new.connec_id||''''
        	INTO v_rec;
        
        	v_connec_state = v_rec.state;
       		v_arc_id = v_rec.arc_id;
       		v_link_id = (select link_id from link where feature_id = new.connec_id and feature_Type = 'CONNEC');
       	
			--raise exception 'EXCEPTION -> %',v_rec;
			/*INSERT INTO plan_psector_x_connec (connec_id,  psector_id, state, doable, descript, arc_id) 
			VALUES (NEW.connec_id,  NEW.psector_id, v_connec_state, NEW.doable, NEW.descript, v_arc_id) on conflict do nothing;*/ 
			INSERT INTO plan_psector_x_connec (connec_id,  psector_id, state, doable, descript) 
			VALUES (NEW.connec_id,  NEW.psector_id, v_connec_state, NEW.doable, NEW.descript) on conflict do nothing; 
				
			if v_connec_state =  1 then
				insert into plan_psector_x_connec (connec_id, psector_id, state, link_id) values (NEW.connec_id,  NEW.psector_id, 0, v_link_id) on conflict do nothing;
				--insert into plan_psector_x_connec (connec_id, psector_id, state, link_id, arc_id) values (NEW.connec_id,  NEW.psector_id, 0, v_link_id, v_arc_id) on conflict do nothing;
				-- COMENTAR ?? insert into plan_psector_x_connec (connec_id, psector_id, state) values (NEW.connec_id,  NEW.psector_id, 1) on conflict do nothing;
			elsif v_connec_state = 2 then
				insert into plan_psector_x_connec (connec_id, psector_id, state) values (NEW.connec_id,  NEW.psector_id, 1) on conflict do nothing;
			end if;
		
		ELSIF v_table = 'plan_psector_x_gully' THEN

			INSERT INTO plan_psector_x_gully (gully_id,  psector_id, state, doable, descript) 
			VALUES (NEW.gully_id,  NEW.psector_id, NEW.state, NEW.doable, NEW.descript); 

		END IF;

		RETURN NEW;
	
	ELSIF TG_OP = 'UPDATE' THEN

		IF v_table = 'plan_psector_x_connec' then

			EXECUTE 'SELECT state, arc_id FROM connec where connec_id = '''||new.connec_id||''''
        	INTO v_rec;
        
        	v_connec_state = v_rec.state;
       		v_arc_id = v_rec.arc_id;
			v_link_id = (select link_id from link where feature_id = new.connec_id and feature_Type = 'CONNEC');
			
			UPDATE plan_psector_x_connec SET doable = NEW.doable, descript = NEW.descript, arc_id = NEW.arc_id
			WHERE id = NEW.id;

			IF NEW.state  = 0 AND OLD.state = 1 AND v_connec_state = 2 THEN
				RAISE EXCEPTION 'IT DOES NOT MAKE SENSE DOWNGRADE THE STATE OF PLANNED CONNEC.  TO UNLINK IT FROM PSECTOR PLEASE REMOVE ROW OR DELETE CONNEC';
			ELSIF NEW.state  = 0 AND OLD.state = 1 THEN
				DELETE FROM plan_psector_x_connec WHERE id = NEW.id;
			ELSIF NEW.state  = 1 AND OLD.state = 0 THEN
				INSERT INTO plan_psector_x_connec (psector_id, connec_id, state) VALUES (NEW.psector_id, NEW.connec_id, 1);
			END IF;
						
		ELSIF v_table = 'plan_psector_x_gully' THEN
		
			UPDATE plan_psector_x_gully SET doable = NEW.doable, descript = NEW.descript, arc_id = NEW.arc_id
			WHERE id = NEW.id;	
			
			IF NEW.state  = 0 AND OLD.state = 1 and v_connec_state = 2 THEN
				RAISE EXCEPTION 'IT DOES NOT MAKE SENSE DOWNGRADE THE STATE OF PLANNED GULLY.  TO UNLINK IT FROM PSECTOR PLEASE REMOVE ROW OR DELETE GULLY';
			ELSIF NEW.state  = 0 AND OLD.state = 1 THEN
				DELETE FROM plan_psector_x_gully WHERE id = NEW.id;
			ELSIF NEW.state  = 1 AND OLD.state = 0 THEN
				INSERT INTO plan_psector_x_gully (psector_id, gully_id, state) VALUES (NEW.psector_id, NEW.gully_id, 1);
			END IF;
		
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
$function$
;
