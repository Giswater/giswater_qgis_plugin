/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1112

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_dma()  RETURNS trigger AS
$BODY$

DECLARE 


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	IF TG_OP = 'INSERT' THEN
		
		-- expl_id		
		IF ((SELECT COUNT(*) FROM exploitation WHERE active IS TRUE) = 0) THEN
			RETURN NULL;				
		END IF;
		IF NEW.the_geom IS NOT NULL THEN
			IF NEW.expl_id IS NULL THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE active IS TRUE AND ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
			END IF;
		END IF;

		-- active
		IF NEW.active IS NULL THEN
			NEW.active = TRUE;
		END IF;
			
		INSERT INTO dma (dma_id, name, descript, macrodma_id, the_geom, undelete, expl_id, pattern_id, link, minc, maxc, effc, active)
		VALUES (NEW.dma_id, NEW.name, NEW.descript, NEW.macrodma_id, NEW.the_geom, NEW.undelete, NEW.expl_id, NEW.pattern_id, NEW.link, NEW.minc, 
		NEW.maxc, NEW.effc, NEW.active);

		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN
   	
		UPDATE dma 
		SET dma_id=NEW.dma_id, name=NEW.name, descript=NEW.descript, the_geom=NEW.the_geom, undelete=NEW.undelete, expl_id=NEW.expl_id, pattern_id=NEW.pattern_id, link=NEW.link,
        minc=NEW.minc, maxc=NEW.maxc, effc=NEW.effc, active=NEW.active, lastupdate=now(), lastupdate_user = current_user, macrodma_id = NEW.macrodma_id
		WHERE dma_id=OLD.dma_id;
		
		RETURN NEW;
		
	ELSIF TG_OP = 'DELETE' THEN  
	 
		DELETE FROM dma WHERE dma_id = OLD.dma_id;		
		RETURN NULL;
	END IF;
END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


