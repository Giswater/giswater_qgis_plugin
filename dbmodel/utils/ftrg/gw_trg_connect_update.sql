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
connecRecord3 record;
v_projectype text;
v_move_polgeom boolean = true;
v_featuretype text;
gullyRecord1 record;
gullyRecord2 record;
gullyRecord3 record;
v_link record;
xvar float;
yvar float;

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_featuretype:= TG_ARGV[0];

	v_move_polgeom = (SELECT value FROM config_param_user WHERE parameter='edit_gully_autoupdate_polgeom' AND cur_user=current_user);

	v_projectype = (SELECT project_type FROM sys_version LIMIT 1);
	
	
	IF v_featuretype='connec' THEN
	
		-- updating links geom
		IF st_equals (NEW.the_geom, OLD.the_geom) IS FALSE THEN

			--Select links with start on the updated connec
			querystring := 'SELECT * FROM link WHERE (link.feature_id = ' || quote_literal(NEW.connec_id) || ' AND feature_type=''CONNEC'')';
			FOR linkrec IN EXECUTE querystring
			LOOP
				EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, 0, $2) WHERE link_id = ' || quote_literal(linkrec."link_id") USING linkrec.the_geom, NEW.the_geom; 
			END LOOP;

			--Select links with end on the updated connec
			querystring := 'SELECT * FROM link WHERE (link.exit_id = ' || quote_literal(NEW.connec_id) || ' AND exit_type=''CONNEC'')';
			FOR linkrec IN EXECUTE querystring
			LOOP
				EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE link_id = ' || quote_literal(linkrec."link_id") USING linkrec.the_geom, NEW.the_geom; 
			END LOOP;		
		END IF;
		
		-- update the rest of the feature parameters
		FOR v_link IN SELECT * FROM link WHERE (exit_type='CONNEC' AND exit_id=OLD.connec_id)
		LOOP

			IF v_link.feature_type='CONNEC' THEN

				-- update connec, mandatory to use v_edit_connec because it's identified and managed when arc_id comes from plan psector tables
				UPDATE v_edit_connec SET arc_id=NEW.arc_id, expl_id=NEW.expl_id, dma_id= NEW.dma_id, sector_id=NEW.sector_id WHERE connec_id=v_link.feature_id;
							
			
			ELSIF v_link.feature_type='GULLY' THEN
 		
				-- update gully, mandatory to use v_edit_gully because it's identified and managed when arc_id comes from plan psector tables
				UPDATE v_edit_gully SET arc_id=NEW.arc_id, expl_id=NEW.expl_id, dma_id= NEW.dma_id, sector_id=NEW.sector_id WHERE gully_id=v_link.feature_id;
				
			END IF;
			
		END LOOP;

		IF v_projectype = 'WS' AND NEW.arc_id IS NOT NULL THEN
			-- update fields that inherit values from arc
			UPDATE v_edit_connec SET presszone_id=a.presszone_id, dqa_id=a.dqa_id, minsector_id=a.minsector_id, fluid_type = a.fluid_type
			FROM arc a WHERE a.arc_id = NEW.arc_id;
		END IF;

		IF v_projectype = 'UD' AND NEW.arc_id IS NOT NULL THEN
			-- update fields that inherit values from arc
			UPDATE v_edit_connec SET fluid_type = a.fluid_type FROM arc a WHERE a.arc_id = NEW.arc_id;
			UPDATE v_edit_gully SET fluid_type = a.fluid_type FROM arc a WHERE a.arc_id = NEW.arc_id;
		END IF;

	ELSIF v_featuretype='gully' THEN
	
		-- Updating polygon geometry in case of exists it
		IF v_move_polgeom IS TRUE THEN
			IF (OLD.pol_id IS NOT NULL) THEN   
				xvar= (st_x(NEW.the_geom)-st_x(OLD.the_geom));
				yvar= (st_y(NEW.the_geom)-st_y(OLD.the_geom));		
				UPDATE polygon SET the_geom=ST_translate(the_geom, xvar, yvar) WHERE pol_id=OLD.pol_id;
			END IF;  
		END IF;
		
		-- updating links geom
		IF st_equals (NEW.the_geom, OLD.the_geom) IS FALSE THEN
	
			--Select links with start on the updated gully
			querystring := 'SELECT * FROM link WHERE (link.feature_id = ' || quote_literal(NEW.gully_id) || ' AND feature_type=''GULLY'')';
			FOR linkrec IN EXECUTE querystring
			LOOP
				EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, 0, $2) WHERE link_id = ' || quote_literal(linkrec."link_id") USING linkrec.the_geom, NEW.the_geom; 
			END LOOP;

			--Select links with end on the updated gully
			querystring := 'SELECT * FROM link WHERE (link.exit_id = ' || quote_literal(NEW.gully_id) || ' AND exit_type=''GULLY'')';
			FOR linkrec IN EXECUTE querystring
			LOOP
				EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE link_id = ' || quote_literal(linkrec."link_id") USING linkrec.the_geom, NEW.the_geom; 
			END LOOP;
		END IF;
		
		-- update the rest of feature parameters
		FOR v_link IN SELECT * FROM link WHERE (exit_type='GULLY' AND exit_id=OLD.gully_id)
		LOOP
			IF v_link.feature_type='CONNEC' THEN
			
				UPDATE v_edit_connec SET arc_id=NEW.arc_id, expl_id=NEW.expl_id, dma_id= NEW.dma_id, sector_id=NEW.sector_id WHERE connec_id=v_link.feature_id;
			
			ELSIF v_link.feature_type='GULLY' THEN
		
				UPDATE v_edit_gully SET arc_id=NEW.arc_id, expl_id=NEW.expl_id, dma_id= NEW.dma_id, sector_id=NEW.sector_id WHERE gully_id=v_link.feature_id;
			END IF;

		END LOOP;
		
	END IF;
		
    RETURN NEW;
    
END; 
$$;
