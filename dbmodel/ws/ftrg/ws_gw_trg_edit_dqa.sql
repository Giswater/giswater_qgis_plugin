/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2924

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_dqa()  RETURNS trigger AS
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
			
		INSERT INTO dqa (dqa_id, name, expl_id, macrodqa_id, descript, undelete, the_geom, pattern_id, dqa_type, link, grafconfig, stylesheet,active)
		VALUES (NEW.dqa_id, NEW.name, NEW.expl_id, NEW.macrodqa_id, NEW.descript, NEW.undelete, NEW.the_geom, NEW.pattern_id, NEW.dqa_type,
		NEW.link, NEW.grafconfig::json, NEW.stylesheet::json, NEW.active);

		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN
   	
		UPDATE dqa 
		SET dqa_id=NEW.dqa_id, name=NEW.name, expl_id=NEW.expl_id, macrodqa_id=NEW.macrodqa_id, descript=NEW.descript, undelete=NEW.undelete, 
		the_geom=NEW.the_geom, pattern_id=NEW.pattern_id, dqa_type=NEW.dqa_type, link=NEW.link, grafconfig=NEW.grafconfig::json, 
		stylesheet = NEW.stylesheet::json, active=NEW.active
		WHERE dqa_id=OLD.dqa_id;
		
		RETURN NEW;
		
	ELSIF TG_OP = 'DELETE' THEN  
	 
		DELETE FROM dqa WHERE dqa_id = OLD.dqa_id;		
		RETURN NULL;
	END IF;
END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


