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
v_link_id integer;
v_rec record;
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_table:= TG_ARGV[0];

	-- force the activation of psector
	INSERT INTO selector_psector (psector_id, cur_user) VALUES (NEW.psector_id, current_user) ON CONFLICT (psector_id, cur_user) DO NOTHING;

	IF TG_OP = 'INSERT' THEN
		
		IF v_table = 'plan_psector_x_connec' then
		
			EXECUTE 'SELECT state, arc_id FROM connec where connec_id = '''||new.connec_id||''''
			INTO v_rec;

        		v_link_id = (select link_id from link where feature_id = new.connec_id and feature_type = 'CONNEC' AND exit_id = v_rec.arc_id LIMIT 1);

			-- setting null value for arc
        		IF NEW.arc_id IS NULL THEN NEW.arc_id = v_rec.arc_id; END IF;

			--inserting on tables
			IF v_rec.state =  1 THEN
				INSERT INTO plan_psector_x_connec (connec_id, psector_id, state, link_id, arc_id) values (NEW.connec_id,  NEW.psector_id, 0, v_link_id, v_rec.arc_id) 
				on conflict do nothing;
				INSERT INTO plan_psector_x_connec (connec_id, psector_id, state, link_id, arc_id) values (NEW.connec_id,  NEW.psector_id, 1, NULL, NEW.arc_id) 
				on conflict do nothing;
				
			ELSIF v_rec.state = 2 THEN
				INSERT INTO plan_psector_x_connec (connec_id, psector_id, state) values (NEW.connec_id,  NEW.psector_id, 1)
				on conflict do nothing;
			END IF;
		
		ELSIF v_table = 'plan_psector_x_gully' THEN

			EXECUTE 'SELECT state, arc_id FROM gully where gully_id = '''||new.gully_id||''''
			INTO v_rec;
			
			v_link_id = (select link_id from link where feature_id = new.connec_id and feature_type = 'CONNEC' AND exit_id = v_rec.arc_id LIMIT 1);

			-- todo gullies

			


		END IF;

		RETURN NEW;
	
	ELSIF TG_OP = 'UPDATE' THEN

		IF v_table = 'plan_psector_x_connec' then

			EXECUTE 'SELECT state, arc_id FROM connec where connec_id = '''||new.connec_id||''''
			INTO v_rec;
        
			v_link_id = (select link_id from link where feature_id = new.connec_id and feature_type = 'CONNEC' AND exit_id = v_rec.arc_id LIMIT 1);			

			UPDATE plan_psector_x_connec SET doable = NEW.doable, descript = NEW.descript, arc_id = NEW.arc_id
			WHERE id = NEW.id;

			IF NEW.state  = 0 AND OLD.state = 1 AND v_rec.state = 2 THEN
				RAISE EXCEPTION 'IT DOES NOT MAKE SENSE DOWNGRADE THE STATE OF PLANNED CONNEC.  TO UNLINK IT FROM PSECTOR PLEASE REMOVE ROW OR DELETE CONNEC';
				
			ELSIF NEW.state  = 0 AND OLD.state = 1 THEN
				DELETE FROM link WHERE link_id = OLD.link_id;
				DELETE FROM plan_psector_x_connec WHERE id = NEW.id;
				
			ELSIF NEW.state  = 1 AND OLD.state = 0 THEN	-- link id null in order to force new link
				INSERT INTO plan_psector_x_connec (psector_id, connec_id, state, arc_id, link_id) VALUES (NEW.psector_id, NEW.connec_id, 1, NEW.arc_id, null);
			END IF;
						
		ELSIF v_table = 'plan_psector_x_gully' THEN

			EXECUTE 'SELECT state, arc_id FROM gully where gully_id = '''||new.gully_id||''''
			INTO v_rec;
        
			v_link_id = (select link_id from link where feature_id = NEW.gully_id and feature_type = 'GULLY' AND exit_id = v_rec.arc_id LIMIT 1);			
		
			UPDATE plan_psector_x_gully SET doable = NEW.doable, descript = NEW.descript, arc_id = NEW.arc_id
			WHERE id = NEW.id;	

			-- todo gullies


			
		
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