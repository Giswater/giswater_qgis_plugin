/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3250

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_minsector()  RETURNS trigger AS
$BODY$

DECLARE 
v_newpattern json;
v_status boolean;
v_value text;

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

			
		INSERT INTO minsector (code, dma_id, dqa_id, presszone_id, expl_id, num_border, num_connec, num_hydro, length, descript, addparam, the_geom)
		VALUES ( NEW.code, NEW.dma_id, NEW.dqa_id, NEW.presszone_id, NEW.expl_id, NEW.num_border, NEW.num_connec, NEW.num_hydro, NEW.length, NEW.descript, 
			NEW.addparam, NEW.the_geom);

		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN
   	
		UPDATE minsector 
		SET minsector_id =NEW.minsector_id, code = NEW.code, dma_id = NEW.dma_id, dqa_id = NEW.dqa_id, presszone_id= NEW.presszone_id, expl_id=NEW.expl_id, 
		num_border=NEW.num_border, num_connec=NEW.num_connec, num_hydro=NEW.num_hydro, length=NEW.length, descript=NEW.descript, addparam=NEW.addparam, the_geom=NEW.the_geom
		WHERE minsector_id=OLD.minsector_id;
		
		RETURN NEW;
		
	ELSIF TG_OP = 'DELETE' THEN  
	 
		DELETE FROM minsector WHERE minsector_id = OLD.minsector_id;		
		RETURN NULL;
     
	END IF;

END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


