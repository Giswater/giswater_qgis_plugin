/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2926

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_presszone()  RETURNS trigger AS
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
		IF NEW.the_geom IS NOT NULL THEN
			IF NEW.expl_id IS NULL THEN
				NEW.expl_id := (SELECT ARRAY[expl_id] FROM exploitation WHERE active IS TRUE AND ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
			END IF;
		END IF;

		-- active
		IF view_name = 'ui'THEN
			IF NEW.active IS NULL THEN
				NEW.active = TRUE;
			END IF;
		END IF;

		INSERT INTO presszone (presszone_id, name, expl_id, graphconfig, head, stylesheet, descript, avg_press, presszone_type)
		VALUES (NEW.presszone_id, NEW.name, NEW.expl_id, NEW.graphconfig::json, NEW.head, NEW.stylesheet::json, NEW.descript,
		NEW.avg_press, NEW.presszone_type);

		IF view_name = 'ui' THEN
			UPDATE presszone SET active = NEW.active WHERE presszone_id = NEW.presszone_id;

		ELSIF view_name = 'edit' THEN
			UPDATE presszone SET the_geom = NEW.the_geom WHERE presszone_id = NEW.presszone_id;

		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE presszone
		SET presszone_id=NEW.presszone_id, name=NEW.name, expl_id=NEW.expl_id, graphconfig=NEW.graphconfig::json,
		head = NEW.head, stylesheet=NEW.stylesheet::json, descript=NEW.descript, lastupdate=now(), lastupdate_user = current_user,
		avg_press = NEW.avg_press, presszone_type = NEW.presszone_type
		WHERE presszone_id=OLD.presszone_id;

		IF view_name = 'ui' THEN
			UPDATE presszone SET active = NEW.active WHERE presszone_id = OLD.presszone_id;

		ELSIF view_name = 'edit' THEN
			UPDATE presszone SET the_geom = NEW.the_geom WHERE presszone_id = OLD.presszone_id;

		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM presszone WHERE presszone_id = OLD.presszone_id;
		RETURN NULL;

	END IF;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


