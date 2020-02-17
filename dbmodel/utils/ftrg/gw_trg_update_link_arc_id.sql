/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 2688

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_update_link_arc_id()
  RETURNS trigger AS
$BODY$
DECLARE 
v_featuretype text;
v_link record;
v_projecttype text;
v_geom public.geometry;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_featuretype:= TG_ARGV[0];

		-- get project type
	SELECT wsoftware INTO v_projecttype FROM version LIMIT 1;

	IF v_featuretype='connec' THEN

		-- feature as startpoint
		v_geom =  (SELECT the_geom FROM connec WHERE connec_id = OLD.connec_id);
		UPDATE link SET the_geom = ST_SetPoint(the_geom, 0, v_geom) WHERE feature_id = OLD.connec_id AND feature_type = 'CONNEC';

		-- feature as endpoint
		FOR v_link IN SELECT * FROM link WHERE (exit_type='CONNEC' AND exit_id=OLD.connec_id)
		LOOP

			IF v_link.feature_type='CONNEC' THEN

				-- update connec, mandatory to use v_edit_connec because it's identified and managed when arc_id comes from plan psector tables
				UPDATE v_edit_connec SET arc_id=NEW.arc_id, expl_id=NEW.expl_id, dma_id= NEW.dma_id, sector_id=NEW.sector_id WHERE connec_id=v_link.feature_id;
							
				IF v_projecttype = 'WS' THEN

					-- update presszone
					UPDATE v_edit_connec SET presszonecat_id=NEW.presszonecat_id, dqa_id=NEW.dqa_id, minsector_id=NEW.minsector_id WHERE connec_id=v_link.feature_id;
	
				END IF;

			
			ELSIF v_link.feature_type='GULLY' THEN
 		
				-- update gully, mandatory to use v_edit_gully because it's identified and managed when arc_id comes from plan psector tables
				UPDATE v_edit_gully SET arc_id=NEW.arc_id, expl_id=NEW.expl_id, dma_id= NEW.dma_id, sector_id=NEW.sector_id WHERE gully_id=v_link.feature_id;
				
			END IF;

			-- update link geometry in case of exit geometry has changed
			v_geom =  (SELECT the_geom FROM connec WHERE connec_id = OLD.connec_id);
			UPDATE link SET the_geom = ST_SetPoint(the_geom, ST_NumPoints(the_geom) - 1, v_geom) WHERE exit_id = OLD.connec_id;
			
		END LOOP;
		
	
	ELSIF v_featuretype='gully' THEN

		-- feature as startpoint
		v_geom =  (SELECT the_geom FROM gully WHERE gully_id = OLD.gully_id);
		UPDATE link SET the_geom = ST_SetPoint(the_geom, 0, v_geom) WHERE feature_id = OLD.gully_id AND feature_type = 'GULLY';

		-- feature as endpoint
		FOR v_link IN SELECT * FROM link WHERE (exit_type='GULLY' AND exit_id=OLD.gully_id)
		LOOP
			IF v_link.feature_type='CONNEC' THEN
			
				UPDATE v_edit_connec SET arc_id=NEW.arc_id, expl_id=NEW.expl_id, dma_id= NEW.dma_id, sector_id=NEW.sector_id WHERE connec_id=v_link.feature_id;
			
			ELSIF v_link.feature_type='GULLY' THEN
		
				UPDATE v_edit_gully SET arc_id=NEW.arc_id, expl_id=NEW.expl_id, dma_id= NEW.dma_id, sector_id=NEW.sector_id WHERE gully_id=v_link.feature_id;
			END IF;

			-- update link geometry in case of exit geometry has changed
			v_geom =  (SELECT the_geom FROM gully WHERE gully_id = OLD.gully_id);
			UPDATE link SET the_geom = ST_SetPoint(the_geom, ST_NumPoints(the_geom) - 1, v_geom) WHERE exit_id = OLD.gully_id;

		END LOOP;
		
	END IF;
	
	RETURN NEW;   
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;




