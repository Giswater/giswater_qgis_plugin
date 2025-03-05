/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2924

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_dqa()
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
		"data":{"message":"3276", "function":"2924","parameters":null, "is_process":true}}$$);';
	END IF;

	IF NOT (SELECT array_agg(muni_id ORDER BY muni_id) @> NEW.muni_id FROM ext_municipality) THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3278", "function":"2924","parameters":null, "is_process":true}}$$);';
	END IF;

	IF NOT (SELECT array_agg(sector_id ORDER BY sector_id) @> NEW.sector_id FROM sector) THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3280", "function":"2924","parameters":null, "is_process":true}}$$);';
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

			v_mapzone_id = NEW.macrodqa_id;
		ELSIF v_view_name = 'UI' THEN
			IF NEW.active IS NULL THEN
				NEW.active = TRUE;
			END IF;

			SELECT macrodqa_id INTO v_mapzone_id FROM macrodqa WHERE name = NEW.macrodqa;
		END IF;

		INSERT INTO dqa (dqa_id, name, expl_id, macrodqa_id, descript, pattern_id, dqa_type, link, graphconfig, stylesheet, muni_id, sector_id, lock_level)
		VALUES (NEW.dqa_id, NEW.name, NEW.expl_id, v_mapzone_id, NEW.descript, NEW.pattern_id, NEW.dqa_type,
		NEW.link, NEW.graphconfig::json, NEW.stylesheet::json, NEW.muni_id, NEW.sector_id, NEW.lock_level);

		IF v_view_name = 'UI' THEN
			UPDATE dqa SET active = NEW.active WHERE dqa_id = NEW.dqa_id;
		ELSIF v_view_name = 'EDIT' THEN
			UPDATE dqa SET the_geom = NEW.the_geom WHERE dqa_id = NEW.dqa_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		IF v_view_name = 'EDIT' THEN
			v_mapzone_id = NEW.macrodqa_id;
		ELSIF v_view_name = 'UI' THEN
			SELECT macrodqa_id INTO v_mapzone_id FROM macrodqa WHERE name = NEW.macrodqa;
		END IF;

		UPDATE dqa
		SET dqa_id=NEW.dqa_id, name=NEW.name, expl_id=NEW.expl_id, macrodqa_id=v_mapzone_id, descript=NEW.descript,
		pattern_id=NEW.pattern_id, dqa_type=NEW.dqa_type, link=NEW.link, graphconfig=NEW.graphconfig::json,
		stylesheet = NEW.stylesheet::json, lastupdate=now(), lastupdate_user = current_user, muni_id = NEW.muni_id, sector_id = NEW.sector_id, lock_level=NEW.lock_level
		WHERE dqa_id=OLD.dqa_id;

		IF v_view_name = 'UI' THEN
			UPDATE dqa SET active = NEW.active WHERE dqa_id = OLD.dqa_id;
		ELSIF v_view_name = 'EDIT' THEN
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


