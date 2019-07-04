/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 2688



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_update_link_arc_id() RETURNS trigger AS $BODY$
DECLARE 

	v_exittype text;
	v_link record;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_exittype:= TG_ARGV[0];

	
	IF v_exittype='connec' THEN
	FOR v_link IN SELECT * FROM link WHERE (exit_type='CONNEC' AND exit_id=OLD.connec_id)
		LOOP

			IF v_link.feature_type='CONNEC' THEN

				-- update connec, mandatory to use v_edit_connec because it's identified and managed when arc_id comes from plan psector tables
				UPDATE v_edit_connec SET arc_id=NEW.arc_id, dma_id= NEW.dma_id, sector_id=NEW.sector_id, expl_id=NEW.expl_id WHERE connec_id=v_link.feature_id;
								
				IF v_projecttype = 'WS' THEN

					-- update presszone
					UPDATE v_edit_connec SET presszonecat_id=NEW.presszonecat_id, dqa_id=NEW.dqa_id, minsector_id=NEW.minsector_id WHERE connec_id=v_link.feature_id;
	
				END IF;

			
			ELSIF v_link.feature_type='GULLY' THEN
 		
				-- update gully, mandatory to use v_edit_gully because it's identified and managed when arc_id comes from plan psector tables
				UPDATE v_edit_gully SET arc_id=NEW.arc_id, dma_id= NEW.dma_id, sector_id=NEW.sector_id, expl_id=NEW.expl_id WHERE gully_id=v_link.feature_id;
				
			END IF;
		END LOOP;
	
	ELSIF v_exittype='gully' THEN
	FOR v_link IN SELECT * FROM link WHERE (exit_type='GULLY' AND exit_id=OLD.gully_id)
		LOOP
			IF v_link.feature_type='CONNEC' THEN
			
				UPDATE v_edit_connec SET arc_id=NEW.arc_id, dma_id= NEW.dma_id, sector_id=NEW.sector_id, expl_id=NEW.expl_id WHERE connec_id=v_link.feature_id;
			
			ELSIF v_link.feature_type='GULLY' THEN
		
				UPDATE v_edit_gully SET arc_id=NEW.arc_id, dma_id= NEW.dma_id, sector_id=NEW.sector_id, expl_id=NEW.expl_id WHERE gully_id=v_link.feature_id;
			END IF;
		END LOOP;
		
	END IF;
	
	RETURN NEW;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


