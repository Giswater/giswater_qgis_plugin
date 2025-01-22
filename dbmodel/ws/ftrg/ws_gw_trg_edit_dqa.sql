/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2924

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_dqa()  RETURNS trigger AS
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

		IF view_name = 'edit'THEN
			IF NEW.the_geom IS NOT NULL THEN
				IF NEW.expl_id IS NULL THEN
					NEW.expl_id := (SELECT expl_id FROM exploitation WHERE active IS TRUE AND ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				END IF;
			END IF;
		END IF;
		-- active
		IF view_name = 'ui'THEN
			IF NEW.active IS NULL THEN
				NEW.active = TRUE;
			END IF;
		END IF;

		INSERT INTO dqa (dqa_id, name, expl_id, macrodqa_id, descript, undelete, pattern_id, dqa_type, link, graphconfig, stylesheet)
		VALUES (NEW.dqa_id, NEW.name, NEW.expl_id, NEW.macrodqa_id, NEW.descript, NEW.undelete, NEW.pattern_id, NEW.dqa_type,
		NEW.link, NEW.graphconfig::json, NEW.stylesheet::json);

		IF view_name = 'ui' THEN
			UPDATE dqa SET active = NEW.active WHERE dqa_id = NEW.dqa_id;

		ELSIF view_name = 'edit' THEN
			UPDATE dqa SET the_geom = NEW.the_geom WHERE dqa_id = NEW.dqa_id;

		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE dqa
		SET dqa_id=NEW.dqa_id, name=NEW.name, expl_id=NEW.expl_id, macrodqa_id=(SELECT macrodqa_id FROM macrodqa WHERE name = NEW.macrodqa_id), descript=NEW.descript, undelete=NEW.undelete,
		pattern_id=NEW.pattern_id, dqa_type=NEW.dqa_type, link=NEW.link, graphconfig=NEW.graphconfig::json,
		stylesheet = NEW.stylesheet::json, lastupdate=now(), lastupdate_user = current_user
		WHERE dqa_id=OLD.dqa_id;

		IF view_name = 'ui' THEN
			UPDATE dqa SET active = NEW.active WHERE dqa_id = OLD.dqa_id;

		ELSIF view_name = 'edit' THEN
			UPDATE dqa SET the_geom = NEW.the_geom WHERE dqa_id = OLD.dqa_id;

		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM dqa WHERE dqa_id = OLD.dqa_id;
		RETURN NULL;
	END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


