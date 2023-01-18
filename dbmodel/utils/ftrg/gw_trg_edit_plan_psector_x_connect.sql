/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3174

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_plan_psector_x_connect()
  RETURNS trigger AS
$BODY$

DECLARE 
v_table text;
v_link_id integer;
v_exit_type text;
v_rec record;

BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_table:= TG_ARGV[0];

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
			
			v_link_id = (select link_id from link where feature_id = new.gully_id and feature_type = 'GULLY' AND exit_id = v_rec.arc_id LIMIT 1);

			-- setting null value for arc
        	IF NEW.arc_id IS NULL THEN NEW.arc_id = v_rec.arc_id; END IF;

			--inserting on tables
			IF v_rec.state =  1 THEN
				INSERT INTO plan_psector_x_gully (gully_id, psector_id, state, link_id, arc_id) values (NEW.gully_id,  NEW.psector_id, 0, v_link_id, v_rec.arc_id) 
				on conflict do nothing;
				INSERT INTO plan_psector_x_gully (gully_id, psector_id, state, link_id, arc_id) values (NEW.gully_id,  NEW.psector_id, 1, NULL, NEW.arc_id) 
				on conflict do nothing;
				
			ELSIF v_rec.state = 2 THEN
				INSERT INTO plan_psector_x_gully (gully_id, psector_id, state) values (NEW.gully_id,  NEW.psector_id, 1)
				on conflict do nothing;
			END IF;

		END IF;

		RETURN NEW;
	
	ELSIF TG_OP = 'UPDATE' THEN

		IF NEW.arc_id IS NULL AND OLD.arc_id IS NOT NULL THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3208", "function":"3174","debug_msg":""}}$$);';
		END IF;

		IF v_table = 'plan_psector_x_connec' then

			EXECUTE 'SELECT state, arc_id FROM v_edit_connec where connec_id = '''||new.connec_id||''''
			INTO v_rec;
        
			select link_id, exit_type INTO v_link_id, v_exit_type from v_edit_link where feature_id = new.connec_id and feature_type = 'CONNEC' AND feature_id = new.connec_id LIMIT 1;			

			UPDATE plan_psector_x_connec SET doable = NEW.doable, descript = NEW.descript, arc_id = NEW.arc_id
			WHERE id = NEW.id;

			IF NEW.state  = 0 AND OLD.state = 1 AND v_rec.state = 2 THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3210", "function":"3174","debug_msg":""}}$$);';

			ELSIF coalesce(NEW.arc_id,'') !=  coalesce(OLD.arc_id,'') AND v_exit_type IN ('NODE', 'CONNEC', 'GULLY') THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3212", "function":"3174","debug_msg":""}}$$);';

			ELSIF NEW.state  = 0 AND OLD.state = 1 THEN
				DELETE FROM link WHERE link_id = OLD.link_id;
				DELETE FROM plan_psector_x_connec WHERE id = NEW.id;
				
			ELSIF NEW.state  = 1 AND OLD.state = 0 THEN	-- link id null in order to force new link
				INSERT INTO plan_psector_x_connec (psector_id, connec_id, state, arc_id, link_id) VALUES (NEW.psector_id, NEW.connec_id, 1, NEW.arc_id, null);
			END IF;
						
		ELSIF v_table = 'plan_psector_x_gully' THEN

			EXECUTE 'SELECT state, arc_id FROM v_edit_gully where gully_id = '''||new.gully_id||''''
			INTO v_rec;
        
			select link_id, exit_type INTO v_link_id, v_exit_type from v_edit_link where feature_id = new.gully_id and feature_type = 'GULLY' AND feature_id = new.gully_id LIMIT 1;	

			UPDATE plan_psector_x_gully SET doable = NEW.doable, descript = NEW.descript, arc_id = NEW.arc_id
			WHERE id = NEW.id;	

			IF NEW.state  = 0 AND OLD.state = 1 AND v_rec.state = 2 THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3214", "function":"3174","debug_msg":""}}$$);';

			ELSIF coalesce(NEW.arc_id,'') !=  coalesce(OLD.arc_id,'') AND v_exit_type IN ('NODE', 'CONNEC', 'GULLY') THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3216", "function":"3174","debug_msg":""}}$$);';

			ELSIF NEW.state  = 0 AND OLD.state = 1 THEN
				DELETE FROM link WHERE link_id = OLD.link_id;
				DELETE FROM plan_psector_x_gully WHERE id = NEW.id;
				
			ELSIF NEW.state  = 1 AND OLD.state = 0 THEN	-- link id null in order to force new link
				INSERT INTO plan_psector_x_gully (psector_id, gully_id, state, arc_id, link_id) VALUES (NEW.psector_id, NEW.gully_id, 1, NEW.arc_id, null);
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;