/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 1112

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_dma()
  RETURNS trigger AS
$BODY$

DECLARE

	v_view_name TEXT; -- EDIT | UI
	v_mapzone_id INTEGER;

	v_newpattern JSON;
	v_status BOOLEAN;
	v_value TEXT;

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
		"data":{"message":"3276", "function":"1112","parameters":null, "is_process":true}}$$);';
	END IF;

	IF NOT (SELECT array_agg(muni_id ORDER BY muni_id) @> NEW.muni_id FROM ext_municipality) THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3278", "function":"1112","parameters":null, "is_process":true}}$$);';
	END IF;

	IF NOT (SELECT array_agg(sector_id ORDER BY sector_id) @> NEW.sector_id FROM sector) THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3280", "function":"1112","parameters":null, "is_process":true}}$$);';
	END IF;

	IF TG_OP = 'INSERT' THEN
		v_newpattern = (SELECT value::json->>'forcePatternOnNewDma' FROM config_param_system WHERE parameter = 'epa_patterns');
		v_status = v_newpattern->>'status';
		v_value = v_newpattern->>'value';

		IF ((SELECT COUNT(*) FROM exploitation WHERE active IS TRUE) = 0) THEN
			RETURN NULL;
		END IF;

		IF v_view_name = 'EDIT' THEN
			IF NEW.the_geom IS NOT NULL THEN
				IF NEW.expl_id IS NULL THEN
					NEW.expl_id := (SELECT array_agg(expl_id) FROM exploitation WHERE active IS TRUE AND ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				END IF;
			END IF;

			-- set macrodma_id = 0 if null
			IF NEW.macrodma_id IS NULL THEN NEW.macrodma_id = 0; END IF;
			v_mapzone_id = NEW.macrodma_id;
		ELSIF v_view_name = 'UI' THEN
			IF NEW.active IS NULL THEN
				NEW.active = TRUE;
			END IF;

			SELECT macrodma_id INTO v_mapzone_id FROM macrodma WHERE name = NEW.macrodma;
		END IF;

		-- pattern_id
		IF v_status THEN

			IF v_value = 'dma_id' OR v_value IS NULL THEN
				NEW.pattern_id = NEW.dma_id;
			ELSE
				NEW.pattern_id = v_value;
			END IF;

			INSERT INTO inp_pattern values (NEW.pattern_id)
			ON CONFLICT (pattern_id) DO NOTHING;
		END IF;

		INSERT INTO dma (dma_id, name, descript, macrodma_id, expl_id, pattern_id, link, effc, graphconfig, stylesheet, avg_press, dma_type, minc, maxc, muni_id, sector_id, lock_level)
		VALUES (NEW.dma_id, NEW.name, NEW.descript, v_mapzone_id, NEW.expl_id, NEW.pattern_id, NEW.link,
		NEW.effc, NEW.graphconfig::json, NEW.stylesheet::json, NEW.avg_press, NEW.dma_type, NEW.minc, NEW.maxc, NEW.muni_id, NEW.sector_id, NEW.lock_level);

		IF v_view_name = 'UI' THEN
			UPDATE dma SET active = NEW.active WHERE dma_id = NEW.dma_id;
		ELSIF v_view_name = 'EDIT' THEN
			UPDATE dma SET the_geom = NEW.the_geom WHERE dma_id = NEW.dma_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		IF v_view_name = 'EDIT' THEN
			v_mapzone_id = NEW.macrodma_id;
		ELSIF v_view_name = 'UI' THEN
			SELECT macrodma_id INTO v_mapzone_id FROM macrodma WHERE name = NEW.macrodma;
		END IF;

		UPDATE dma
		SET dma_id=NEW.dma_id, name=NEW.name, descript=NEW.descript, macrodma_id=v_mapzone_id, expl_id=NEW.expl_id,
		pattern_id=NEW.pattern_id, link=NEW.link, effc=NEW.effc, graphconfig=NEW.graphconfig::json, dma_type=NEW.dma_type,
		stylesheet = NEW.stylesheet::json, avg_press=NEW.avg_press, updated_at=now(), updated_by = current_user,
		minc = NEW.minc, maxc = NEW.maxc, muni_id = NEW.muni_id, sector_id = NEW.sector_id, lock_level=NEW.lock_level
		WHERE dma_id=OLD.dma_id;

		IF v_view_name = 'UI' THEN
			UPDATE dma SET active = NEW.active WHERE dma_id = OLD.dma_id;
		ELSIF v_view_name = 'EDIT' THEN
			UPDATE dma SET the_geom = NEW.the_geom WHERE dma_id = OLD.dma_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM dma WHERE dma_id = OLD.dma_id;
		RETURN NULL;

	END IF;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;