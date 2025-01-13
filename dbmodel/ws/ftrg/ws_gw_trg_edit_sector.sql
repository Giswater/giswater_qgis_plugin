/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 1124

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_sector()
  RETURNS trigger AS
$BODY$
DECLARE

view_name TEXT;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Arg will be or 'edit' or 'ui'
	view_name = TG_ARGV[0];

	-- We recive name as a parameter of macrosector so we select id from NEW.macrosector of corresponding table
	IF TG_OP = 'INSERT' THEN

		INSERT INTO sector (sector_id, name, descript, macrosector_id, sector_type, undelete, graphconfig, stylesheet, parent_id, pattern_id, avg_press)
		VALUES (NEW.sector_id, NEW.name, NEW.descript, (SELECT macrosector_id FROM macrosector WHERE name = NEW.macrosector), NEW.sector_type, NEW.undelete,
		NEW.graphconfig::json, NEW.stylesheet::json, NEW.parent_id, NEW.pattern_id, NEW.avg_press);

		IF view_name = 'ui' THEN
			UPDATE sector SET active = NEW.active WHERE sector_id = NEW.sector_id;

		ELSIF view_name = 'edit' THEN
			UPDATE sector SET the_geom = NEW.the_geom WHERE sector_id = NEW.sector_id;

		END IF;

		INSERT INTO selector_sector VALUES (NEW.sector_id, current_user);

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE sector
		SET sector_id=NEW.sector_id, name=NEW.name, descript=NEW.descript, sector_type = NEW.sector_type, macrosector_id=(SELECT macrosector_id FROM macrosector WHERE name = NEW.macrosector),
		undelete=NEW.undelete, graphconfig=NEW.graphconfig::json, stylesheet = NEW.stylesheet::json, parent_id = NEW.parent_id, pattern_id = NEW.pattern_id,
		lastupdate=now(), lastupdate_user = current_user, avg_press = NEW.avg_press
		WHERE sector_id=OLD.sector_id;

		IF view_name = 'ui' THEN
			UPDATE sector SET active = NEW.active WHERE sector_id = OLD.sector_id;

		ELSIF view_name = 'edit' THEN
			UPDATE sector SET the_geom = NEW.the_geom WHERE sector_id = OLD.sector_id;

		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM sector WHERE sector_id = OLD.sector_id;

		RETURN NEW;

	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
