/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 1124

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_sector()
  RETURNS trigger AS
$BODY$
DECLARE
view_name TEXT;
v_mapzone_id INTEGER;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Arg will be or 'edit' or 'ui'
	view_name = TG_ARGV[0];

	IF TG_OP = 'INSERT' THEN

		IF view_name = 'EDIT' THEN
			-- set macrosector_id = 0 if null
			IF NEW.macrosector_id IS NULL THEN NEW.macrosector_id = 0; END IF;
			v_mapzone_id = NEW.macrosector_id;
		ELSIF view_name = 'UI' THEN
			IF NEW.active IS NULL THEN
				NEW.active = TRUE;
			END IF;

			SELECT macrosector_id INTO v_mapzone_id FROM macrosector WHERE name = NEW.macrosector;
		END IF;

		INSERT INTO sector (sector_id, name, descript, macrosector_id, expl_id, muni_id, parent_id, stylesheet, sector_type, graphconfig, link, lock_level)
		VALUES (NEW.sector_id, NEW.name, NEW.descript, v_mapzone_id, NEW.expl_id, NEW.muni_id, NEW.parent_id,
		NEW.stylesheet, NEW.sector_type, NEW.graphconfig::json, NEW.link, NEW.lock_level);

		IF view_name = 'UI' THEN
			UPDATE sector SET active = NEW.active WHERE sector_id = NEW.sector_id;
		ELSIF view_name = 'EDIT' THEN
			UPDATE sector SET the_geom = NEW.the_geom WHERE sector_id = NEW.sector_id;
		END IF;

		INSERT INTO selector_sector VALUES (NEW.sector_id, current_user);

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		IF view_name = 'EDIT' THEN
			v_mapzone_id = NEW.macrosector_id;
		ELSIF view_name = 'UI' THEN

			IF NEW.active IS FALSE AND OLD.active IS TRUE THEN
				PERFORM gw_fct_check_linked_mapzones(json_build_object('parameters', json_build_object('mapzoneName', 'sector', 'mapzoneId', OLD.sector_id)));
			END IF;

			SELECT macrosector_id INTO v_mapzone_id FROM macrosector WHERE name = NEW.macrosector;
		END IF;

		UPDATE sector
		SET sector_id=NEW.sector_id, name=NEW.name, descript=NEW.descript, macrosector_id=v_mapzone_id, expl_id=NEW.expl_id,
		muni_id=NEW.muni_id, updated_at=now(), updated_by = current_user, stylesheet=NEW.stylesheet, sector_type=NEW.sector_type,
		graphconfig=NEW.graphconfig::json, link=NEW.link, lock_level=NEW.lock_level
		WHERE sector_id=OLD.sector_id;

		IF view_name = 'UI' THEN
			UPDATE sector SET active = NEW.active WHERE sector_id = NEW.sector_id;

		ELSIF view_name = 'EDIT' THEN
			UPDATE sector SET the_geom = NEW.the_geom WHERE sector_id = NEW.sector_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM sector WHERE sector_id = OLD.sector_id;

		RETURN NULL;

	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
