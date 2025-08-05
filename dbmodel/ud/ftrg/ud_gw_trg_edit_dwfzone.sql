/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3178

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_dwfzone()  RETURNS trigger AS
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

		INSERT INTO dwfzone (dwfzone_id, code, name, expl_id, sector_id, muni_id, descript, link, graphconfig, stylesheet, dwfzone_type, lock_level, drainzone_id)
		VALUES (NEW.dwfzone_id, NEW.dwfzone_id, NEW.name, NEW.expl_id, NEW.sector_id, NEW.muni_id, NEW.descript,
		NEW.link, NEW.graphconfig::json, NEW.stylesheet::json, NEW.dwfzone_type, NEW.lock_level, NEW.drainzone_id);

		IF view_name = 'UI' THEN
			UPDATE dwfzone SET active = NEW.active WHERE dwfzone_id = NEW.dwfzone_id;

		ELSIF view_name = 'EDIT' THEN
			UPDATE dwfzone SET the_geom = NEW.the_geom WHERE dwfzone_id = NEW.dwfzone_id;

		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		IF NEW.active IS FALSE AND OLD.active IS TRUE THEN
			PERFORM gw_fct_check_linked_mapzones(json_build_object('parameters', json_build_object('mapzoneName', 'dwfzone', 'mapzoneId', OLD.dwfzone_id)));
		END IF;

		UPDATE dwfzone
		SET dwfzone_id=NEW.dwfzone_id, name=NEW.name, expl_id=NEW.expl_id,
		sector_id=NEW.sector_id, muni_id=NEW.muni_id, descript=NEW.descript,
		link=NEW.link, graphconfig=NEW.graphconfig::json, stylesheet=NEW.stylesheet::json, updated_at=now(),
		updated_by = current_user, dwfzone_type=NEW.dwfzone_type, lock_level=NEW.lock_level, drainzone_id=NEW.drainzone_id
		WHERE dwfzone_id=OLD.dwfzone_id;

		IF view_name = 'UI' THEN
			UPDATE dwfzone SET active = NEW.active WHERE dwfzone_id = OLD.dwfzone_id;

		ELSIF view_name = 'EDIT' THEN
			UPDATE dwfzone SET the_geom = NEW.the_geom WHERE dwfzone_id = OLD.dwfzone_id;

		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM dwfzone WHERE dwfzone_id = OLD.dwfzone_id;
		RETURN NULL;
	END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
