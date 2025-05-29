/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3420

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_omzone()  RETURNS trigger AS
$BODY$

DECLARE
view_name TEXT;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	view_name = TG_ARGV[0];

	IF TG_OP = 'INSERT' THEN

		-- expl_id
		IF ((SELECT COUNT(*) FROM exploitation WHERE active IS TRUE) = 0) THEN
			RETURN NULL;
		END IF;

		INSERT INTO omzone (omzone_id, code, name, descript, omzone_type, muni_id, expl_id, macroomzone_id, link, lock_level)
		VALUES (NEW.omzone_id, NEW.code, NEW.name, NEW.descript, NEW.omzone_type, NEW.muni_id, NEW.expl_id, NEW.macroomzone_id, NEW.link, NEW.lock_level);

		IF view_name = 'UI' THEN
			IF NEW.active IS NULL THEN
				NEW.active = TRUE;
			END IF;

			UPDATE omzone SET active = NEW.active WHERE omzone_id = NEW.omzone_id;

		ELSIF view_name = 'EDIT' THEN
			IF NEW.the_geom IS NOT NULL THEN
				IF NEW.expl_id IS NULL THEN
					NEW.expl_id := (SELECT expl_id FROM exploitation WHERE active IS TRUE AND ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				END IF;
			END IF;

			UPDATE omzone SET the_geom = NEW.the_geom WHERE omzone_id = NEW.omzone_id;

		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE omzone
		SET code=NEW.code, name=NEW.name, descript=NEW.descript, omzone_type=NEW.omzone_type, muni_id=NEW.muni_id, expl_id=NEW.expl_id,
		macroomzone_id=NEW.macroomzone_id, link=NEW.link, lock_level=NEW.lock_level
		WHERE omzone_id=OLD.omzone_id;

		IF view_name = 'UI' THEN
			UPDATE omzone SET active = NEW.active WHERE omzone_id = OLD.omzone_id;

		ELSIF view_name = 'EDIT' THEN
			UPDATE omzone SET the_geom = NEW.the_geom WHERE omzone_id = OLD.omzone_id;

		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM omzone WHERE omzone_id = OLD.omzone_id;
		RETURN NULL;
	END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


