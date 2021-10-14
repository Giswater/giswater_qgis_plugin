/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1112

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_dma()  RETURNS trigger AS
$BODY$

DECLARE 
expl_id_int integer;
v_newpattern json;
v_status boolean;
v_value text;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	IF TG_OP = 'INSERT' THEN
	
		v_newpattern = (SELECT value::json->>'forcePatternOnNewDma' FROM config_param_system WHERE parameter = 'epa_patterns');
		v_status = v_newpattern->>'status';
		v_value = v_newpattern->>'value';
		
		--Exploitation ID
		IF ((SELECT COUNT(*) FROM exploitation WHERE active IS TRUE) = 0) THEN
			RETURN NULL;				
		END IF;

		expl_id_int := (SELECT expl_id FROM exploitation WHERE active IS TRUE AND ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
		
		IF v_status THEN
		
			IF  v_value = 'dma_id' OR v_value IS NULL THEN
				NEW.pattern_id = NEW.dma_id;
			ELSE
				NEW.pattern_id = v_value;
			END IF;

			INSERT INTO inp_pattern values (NEW.pattern_id)
			ON CONFLICT (pattern_id) DO NOTHING;
		END IF;
			
		INSERT INTO dma (dma_id, name, descript,  the_geom, undelete, expl_id, pattern_id, link, minc, maxc, effc, grafconfig, stylesheet, active)
		VALUES (NEW.dma_id, NEW.name, NEW.descript, NEW.the_geom, NEW.undelete, expl_id_int, NEW.pattern_id, NEW.link, NEW.minc, 
		NEW.maxc, NEW.effc, NEW.grafconfig::json, NEW.stylesheet::json, NEW.active);

		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN
   	
		UPDATE dma 
		SET dma_id=NEW.dma_id, name=NEW.name, descript=NEW.descript, the_geom=NEW.the_geom, undelete=NEW.undelete, expl_id=NEW.expl_id, 
		pattern_id=NEW.pattern_id, link=NEW.link, minc=NEW.minc, maxc=NEW.maxc, effc=NEW.effc, grafconfig=NEW.grafconfig::json, 
		stylesheet = NEW.stylesheet::json, active=NEW.active
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


