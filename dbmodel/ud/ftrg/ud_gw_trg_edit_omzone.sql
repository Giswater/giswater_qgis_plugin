/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1112

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

		INSERT INTO omzone (omzone_id, name, descript, macrodma_id, expl_id, link, stylesheet, omzone_type, graphconfig, lock_level)
		VALUES (NEW.omzone_id, NEW.name, NEW.descript, NEW.macrodma_id, NEW.expl_id, NEW.link, NEW.stylesheet,
		NEW.omzone_type, NEW.graphconfig::json, NEW.lock_level);

		IF view_name = 'UI' THEN
			UPDATE omzone SET active = NEW.active WHERE omzone_id = NEW.omzone_id;

		ELSIF view_name = 'EDIT' THEN
			UPDATE omzone SET the_geom = NEW.the_geom WHERE omzone_id = NEW.omzone_id;

		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE omzone
		SET omzone_id=NEW.omzone_id, name=NEW.name, descript=NEW.descript, expl_id=NEW.expl_id,
		link=NEW.link, lastupdate=now(), lastupdate_user = current_user, macrodma_id = NEW.macrodma_id, stylesheet=NEW.stylesheet,
		omzone_type=NEW.omzone_type, graphconfig=NEW.graphconfig::json, lock_level=NEW.lock_level
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


