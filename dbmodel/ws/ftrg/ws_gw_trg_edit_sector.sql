/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 1124

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_sector()
  RETURNS trigger AS
$BODY$

DECLARE

	v_view_name TEXT; -- EDIT | UI
	v_mapzone_id INTEGER;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Get parameters
	v_view_name = UPPER(TG_ARGV[0]);

	-- Validate parameters
	IF v_view_name IS NULL THEN
		RAISE EXCEPTION 'Param ''v_view_name'' is requiered';
    END IF;

	IF v_view_name NOT IN ('EDIT', 'UI') THEN
		RAISE EXCEPTION 'Param ''v_view_name'' is wrong, need to be: ''EDIT'' or ''UI''.';
	END IF;

	-- Other validations
	IF NOT (SELECT array_agg(expl_id ORDER BY expl_id) @> NEW.expl_id FROM exploitation) THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3276", "function":"1124","parameters":null, "is_process":true}}$$);';
	END IF;

	IF NOT (SELECT array_agg(muni_id ORDER BY muni_id) @> NEW.muni_id FROM ext_municipality) THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3278", "function":"1124","parameters":null, "is_process":true}}$$);';
	END IF;

	IF TG_OP = 'INSERT' THEN
		IF ((SELECT COUNT(*) FROM exploitation WHERE active IS TRUE) = 0) THEN
			RETURN NULL;
		END IF;

		IF v_view_name = 'EDIT' THEN
			IF NEW.the_geom IS NOT NULL THEN
				IF NEW.expl_id IS NULL THEN
					NEW.expl_id := (SELECT array_agg(expl_id) FROM exploitation WHERE active IS TRUE AND ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				END IF;
			END IF;

			v_mapzone_id = NEW.macrosector_id;
		ELSIF v_view_name = 'UI' THEN
			IF NEW.active IS NULL THEN
				NEW.active = TRUE;
			END IF;

			SELECT macrosector_id INTO v_mapzone_id FROM macrosector WHERE name = NEW.macrosector;
		END IF;

		INSERT INTO sector (sector_id, name, descript, macrosector_id, sector_type, graphconfig, stylesheet, parent_id, pattern_id, avg_press, link, muni_id, expl_id, lock_level)
		VALUES (NEW.sector_id, NEW.name, NEW.descript, v_mapzone_id, NEW.sector_type,
		NEW.graphconfig::json, NEW.stylesheet::json, NEW.parent_id, NEW.pattern_id, NEW.avg_press, NEW.link, NEW.muni_id, NEW.expl_id, NEW.lock_level);

		IF v_view_name = 'UI' THEN
			UPDATE sector SET active = NEW.active WHERE sector_id = NEW.sector_id;
		ELSIF v_view_name = 'EDIT' THEN
			UPDATE sector SET the_geom = NEW.the_geom WHERE sector_id = NEW.sector_id;
		END IF;

		INSERT INTO selector_sector VALUES (NEW.sector_id, current_user);

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		IF v_view_name = 'EDIT' THEN
			v_mapzone_id = NEW.macrosector_id;
		ELSIF v_view_name = 'UI' THEN
			SELECT macrosector_id INTO v_mapzone_id FROM macrosector WHERE name = NEW.macrosector;
		END IF;

		UPDATE sector
		SET sector_id=NEW.sector_id, name=NEW.name, descript=NEW.descript, macrosector_id=v_mapzone_id, sector_type=NEW.sector_type,
		graphconfig=NEW.graphconfig::json, stylesheet = NEW.stylesheet::json, parent_id = NEW.parent_id, pattern_id = NEW.pattern_id,
		updated_at=now(), updated_by = current_user, avg_press = NEW.avg_press, link = NEW.link, muni_id = NEW.muni_id, expl_id = NEW.expl_id, lock_level=NEW.lock_level
		WHERE sector_id=OLD.sector_id;

		IF v_view_name = 'UI' THEN
			UPDATE sector SET active = NEW.active WHERE sector_id = OLD.sector_id;
		ELSIF v_view_name = 'EDIT' THEN
			UPDATE sector SET the_geom = NEW.the_geom WHERE sector_id = OLD.sector_id;
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
