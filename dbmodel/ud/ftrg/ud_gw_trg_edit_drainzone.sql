/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3178

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_drainzone()  RETURNS trigger AS
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
			
		INSERT INTO drainzone (drainzone_id, name, expl_id, macrodma_id, descript, undelete, the_geom, minc, maxc, effc, pattern_id, link, graphconfig, stylesheet, 
    active, avg_press)
		VALUES (NEW.drainzone_id, NEW.name, NEW.expl_id, NEW.macrodma_id, NEW.descript, NEW.undelete, NEW.the_geom, NEW.minc, NEW.maxc, NEW.effc, NEW.pattern_id, 
		NEW.link, NEW.graphconfig, NEW.stylesheet, NEW.active, NEW.avg_press);

		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN
   	
		UPDATE dma 
		SET drainzone_id=NEW.drainzone_id, name=NEW.name, expl_id=NEW.expl_id, macrodma_id=NEW.macrodma_id, descript=NEW.descript, undelete=NEW.undelete, the_geom=NEW.the_geom, 
		minc=NEW.minc, maxc=NEW.maxc, effc=NEW.effc, pattern_id=NEW.pattern_id, link=NEW.link, graphconfig=NEW.graphconfig, stylesheet=NEW.stylesheet,
		active=NEW.active, avg_press=NEW.avg_press
		WHERE drainzone_id=OLD.drainzone_id;
		
		RETURN NEW;
		
	ELSIF TG_OP = 'DELETE' THEN  
	 
		DELETE FROM drainzone WHERE drainzone_id = OLD.drainzone_id;		
		RETURN NULL;
	END IF;
END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


