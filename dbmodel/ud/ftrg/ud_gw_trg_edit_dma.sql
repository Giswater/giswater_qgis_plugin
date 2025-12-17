/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 1112

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_dma()  RETURNS trigger AS
$BODY$

DECLARE
	v_view_name TEXT;
	v_dma_id INTEGER;
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	v_view_name = TG_ARGV[0];

	IF TG_OP = 'INSERT' THEN

		-- expl_id
		IF ((SELECT COUNT(*) FROM exploitation WHERE active IS TRUE) = 0) THEN
			RETURN NULL;
		END IF;

		SELECT max(dma_id::integer)+1 INTO v_dma_id FROM dma WHERE dma_id::text ~ '^[0-9]+$';
		IF NEW.code IS NULL THEN
			NEW.code := v_dma_id::text;
		END IF;

		-- active
		IF NEW.active IS NULL THEN
			NEW.active = TRUE;
		END IF;

		IF v_view_name = 'EDIT'THEN
			IF NEW.the_geom IS NOT NULL THEN
				IF NEW.expl_id IS NULL THEN
					NEW.expl_id := (SELECT expl_id FROM exploitation WHERE active IS TRUE AND ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				END IF;
			END IF;
		END IF;

		INSERT INTO dma (dma_id, code, name, descript, active, dma_type, expl_id, sector_id, muni_id, avg_press, pattern_id, effc, graphconfig, stylesheet, link, lock_level, addparam, created_at, created_by, updated_at, updated_by)
		VALUES (v_dma_id, NEW.code, NEW.name, NEW.descript, NEW.active, NEW.dma_type, NEW.expl_id, NEW.sector_id, NEW.muni_id, NEW.avg_press, NEW.pattern_id,
		NEW.effc, NEW.graphconfig::json, NEW.stylesheet::json, NEW.link, NEW.lock_level, NEW.addparam::json, now(), current_user, now(), current_user);

		IF v_view_name = 'EDIT' THEN
			UPDATE dma SET the_geom = NEW.the_geom WHERE dma_id = NEW.dma_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE dma
		SET dma_id=NEW.dma_id, code=NEW.code, name=NEW.name, descript=NEW.descript, active=NEW.active, dma_type=NEW.dma_type, expl_id=NEW.expl_id,
		muni_id=NEW.muni_id, sector_id=NEW.sector_id, avg_press=NEW.avg_press, pattern_id=NEW.pattern_id, effc=NEW.effc, graphconfig=NEW.graphconfig::json, 
		stylesheet=NEW.stylesheet::json, link=NEW.link, lock_level=NEW.lock_level, addparam=NEW.addparam::json, updated_at=now(), updated_by = current_user
		WHERE dma_id=OLD.dma_id;

		IF v_view_name = 'EDIT' THEN
			UPDATE dma SET the_geom = NEW.the_geom WHERE dma_id = OLD.dma_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM dma WHERE dma_id = OLD.dma_id;
		RETURN NULL;
	END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


