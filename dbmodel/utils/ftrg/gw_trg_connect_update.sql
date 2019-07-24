/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2732


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_connect_update() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 

linkrec Record; 
querystring text;
connecRecord1 record; 
connecRecord2 record;
v_projectype text;
v_move_polgeom boolean = true;
v_featuretype text;

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_featuretype:= TG_ARGV[0];
	

	v_projectype = (SELECT wsoftware FROM version LIMIT 1);
	
	
	IF v_featuretype='connec' THEN
	
		-- updating links geom
		IF st_equals (NEW.the_geom, OLD.the_geom) IS FALSE THEN

			--  Select conneclinks with start-end on the updated connec
			querystring := 'SELECT * FROM link WHERE (link.feature_id = ' || quote_literal(NEW.connec_id) || ' 
			AND feature_type=''CONNEC'') OR (link.exit_id = ' || quote_literal(NEW.connec_id)|| ' AND feature_type=''CONNEC'');'; 
			FOR linkrec IN EXECUTE querystring
			LOOP
				-- Initial and final connec of the LINK
				SELECT * INTO connecRecord1 FROM v_edit_connec WHERE v_edit_connec.connec_id = linkrec.feature_id AND linkrec.feature_type='CONNEC';
				SELECT * INTO connecRecord2 FROM v_edit_connec WHERE v_edit_connec.connec_id = linkrec.exit_id AND linkrec.exit_type='CONNEC'; 
				
				-- Update link from connec
				IF (connecRecord1.connec_id) IS NOT NULL THEN
					EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, 0, $2) WHERE link_id = ' || quote_literal(linkrec."link_id") USING linkrec.the_geom, NEW.the_geom; 
				ELSIF (connecRecord2.connec_id) IS NOT NULL THEN
					EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE link_id = ' || quote_literal(linkrec."link_id") USING linkrec.the_geom, NEW.the_geom; 
				END IF;
			
				-- Update link from gully
				IF v_projectype ='UD' THEN
					SELECT * INTO connecRecord3 FROM v_edit_gully WHERE v_edit_gully.gully_id = linkrec.exit_id AND linkrec.exit_type='CONNEC'; 
					
					IF (connecRecord3.gully_id IS NOT NULL) THEN
						EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE link_id = ' || quote_literal(linkrec."link_id") USING linkrec.the_geom, NEW.the_geom; 
					END IF;
				END IF;
					
			END LOOP;
			
		END IF;
		
		-- update the rest of the feature parameters
		FOR v_link IN SELECT * FROM link WHERE (exit_type='CONNEC' AND exit_id=OLD.connec_id)
		LOOP
			IF v_link.feature_type='CONNEC' THEN
			
				UPDATE connec SET arc_id=NEW.arc_id, pjoint_type = NEW.pjoint_type , pjoint_id = NEW.pjoint_id
				WHERE connec_id=v_link.feature_id;
			
			ELSIF v_link.feature_type='GULLY' THEN
 		
				UPDATE gully SET arc_id=NEW.arc_id, pjoint_type = NEW.pjoint_type , pjoint_id = NEW.pjoint_id
				WHERE gully_id=v_link.feature_id;
				
			END IF;
		END LOOP;
	
	ELSIF v_featuretype='gully' THEN
	
		-- Updating polygon geometry in case of exists it
		IF v_move_polgeom IS TRUE
			IF (OLD.pol_id IS NOT NULL) THEN   
				xvar= (st_x(NEW.the_geom)-st_x(OLD.the_geom));
				yvar= (st_y(NEW.the_geom)-st_y(OLD.the_geom));		
				UPDATE polygon SET the_geom=ST_translate(the_geom, xvar, yvar) WHERE pol_id=OLD.pol_id;
			END IF;  
		END IF;
		
		-- updating links geom
		IF st_equals (NEW.the_geom, OLD.the_geom) IS FALSE THEN
	
			--Select links with start-end on the updated node
			querystring := 'SELECT * FROM link WHERE (link.feature_id = ' || quote_literal(NEW.gully_id) || ' 
			AND feature_type=''GULLY'') OR (link.exit_id = ' || quote_literal(NEW.gully_id)|| ' AND feature_type=''GULLY'');'; 
			FOR linkrec IN EXECUTE querystring
			LOOP
				-- Initial and final gully of the LINK
				SELECT * INTO gullyRecord1 FROM v_edit_gully WHERE v_edit_gully.gully_id = linkrec.feature_id;
				SELECT * INTO gullyRecord2 FROM v_edit_gully WHERE v_edit_gully.gully_id = linkrec.exit_id;
				SELECT * INTO gullyRecord3 FROM v_edit_connec WHERE v_edit_connec.connec_id = linkrec.exit_id;

				-- Update link
				IF (gullyRecord1.gully_id) IS NOT NULL THEN
					EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, 0, $2) WHERE link_id = ' || quote_literal(linkrec."link_id") USING linkrec.the_geom, NEW.the_geom; 
				ELSIF (gullyRecord2.gully_id IS NOT NULL) OR (gullyRecord3.connec_id IS NOT NULL)
					EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE link_id = ' || quote_literal(linkrec."link_id") USING linkrec.the_geom, NEW.the_geom; 
				END IF;
			END LOOP;
		END IF;
		
		-- update the rest of feature parameters
		FOR v_link IN SELECT * FROM link WHERE (exit_type='GULLY' AND exit_id=OLD.gully_id)
		LOOP
			IF v_link.feature_type='CONNEC' THEN
			
				UPDATE v_edit_connec SET arc_id=NEW.arc_id, pjoint_type = NEW.pjoint_type , pjoint_id = NEW.pjoint_id
				WHERE connec_id=v_link.feature_id;
			
			ELSIF v_link.feature_type='GULLY' THEN
		
				UPDATE v_edit_gully SET arc_id=NEW.arc_id, pjoint_type = NEW.pjoint_type , pjoint_id = NEW.pjoint_id
				WHERE gully_id=v_link.feature_id;
			END IF;
		END LOOP;
		
	END IF;
		
    RETURN NEW;
    
END; 
$$;
