/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3178

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_drainzone()  RETURNS trigger AS
$BODY$

DECLARE
view_name TEXT;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Arg will be or 'edit' or 'ui'
	view_name = TG_ARGV[0];

	IF TG_OP = 'INSERT' THEN

		-- expl_id
		IF ((SELECT COUNT(*) FROM exploitation WHERE active IS TRUE) = 0) THEN
			RETURN NULL;
		END IF;

		IF view_name = 'EDIT'THEN
			IF NEW.the_geom IS NOT NULL THEN
				IF NEW.expl_id IS NULL THEN
					NEW.expl_id := (SELECT expl_id FROM exploitation WHERE active IS TRUE AND ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				END IF;
			END IF;
		END IF;

		-- active
		IF view_name = 'UI'THEN
			IF NEW.active IS NULL THEN
				NEW.active = TRUE;
			END IF;
		END IF;

		INSERT INTO drainzone (drainzone_id, "name", expl_id, sector_id, muni_id, descript, link, graphconfig, stylesheet, drainzone_type, lock_level)
		VALUES (NEW.drainzone_id, NEW.name, NEW.expl_id, NEW.sector_id, NEW.muni_id, NEW.descript,
		NEW.link, NEW.graphconfig::json, NEW.stylesheet::json, NEW.drainzone_type, NEW.lock_level);

		IF view_name = 'UI' THEN
			UPDATE drainzone SET active = NEW.active WHERE drainzone_id = NEW.drainzone_id;

		ELSIF view_name = 'EDIT' THEN
			UPDATE drainzone SET the_geom = NEW.the_geom WHERE drainzone_id = NEW.drainzone_id;

		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE drainzone
		SET drainzone_id=NEW.drainzone_id, name=NEW.name, expl_id=NEW.expl_id,
		sector_id=NEW.sector_id, muni_id=NEW.muni_id, descript=NEW.descript,
		link=NEW.link, graphconfig=NEW.graphconfig::json, stylesheet=NEW.stylesheet::json, updated_at=now(),
		updated_by = current_user, drainzone_type=NEW.drainzone_type, lock_level=NEW.lock_level
		WHERE drainzone_id=OLD.drainzone_id;

		IF view_name = 'UI' THEN
			UPDATE drainzone SET active = NEW.active WHERE drainzone_id = OLD.drainzone_id;

		ELSIF view_name = 'EDIT' THEN
			UPDATE drainzone SET the_geom = NEW.the_geom WHERE drainzone_id = OLD.drainzone_id;

		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM drainzone WHERE drainzone_id = OLD.drainzone_id;
		RETURN NULL;
	END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


