/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1112

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_dma()  RETURNS trigger AS
$BODY$

DECLARE
v_newpattern json;
v_status boolean;
v_value text;
view_name TEXT;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Arg will be or 'edit' or 'ui'
	view_name = TG_ARGV[0];

	IF TG_OP = 'INSERT' THEN

		v_newpattern = (SELECT value::json->>'forcePatternOnNewDma' FROM config_param_system WHERE parameter = 'epa_patterns');
		v_status = v_newpattern->>'status';
		v_value = v_newpattern->>'value';

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

		-- pattern_id
		IF v_status THEN

			IF  v_value = 'dma_id' OR v_value IS NULL THEN
				NEW.pattern_id = NEW.dma_id;
			ELSE
				NEW.pattern_id = v_value;
			END IF;

			INSERT INTO inp_pattern values (NEW.pattern_id)
			ON CONFLICT (pattern_id) DO NOTHING;
		END IF;

		INSERT INTO dma (dma_id, name, descript,  macrodma_id, undelete, expl_id, pattern_id, link, effc, graphconfig, stylesheet, avg_press, dma_type)
		VALUES (NEW.dma_id, NEW.name, NEW.descript, NEW.macrodma_id, NEW.undelete, NEW.expl_id, NEW.pattern_id, NEW.link,
		NEW.effc, NEW.graphconfig::json, NEW.stylesheet::json, NEW.avg_press, NEW.dma_type);

		IF view_name = 'ui' THEN
			UPDATE dma SET active = NEW.active WHERE dma_id = NEW.dma_id;

		ELSIF view_name = 'edit' THEN
			UPDATE dma SET the_geom = NEW.the_geom WHERE dma_id = NEW.dma_id;

		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE dma
		SET dma_id=NEW.dma_id, name=NEW.name, descript=NEW.descript, undelete=NEW.undelete, expl_id=NEW.expl_id,
		pattern_id=NEW.pattern_id, link=NEW.link, effc=NEW.effc, graphconfig=NEW.graphconfig::json, dma_type=NEW.dma_type,
		stylesheet = NEW.stylesheet::json, avg_press=NEW.avg_press, macrodma_id = (SELECT macrodma_id FROM macrodma WHERE name = NEW.macrodma_name), lastupdate=now(), lastupdate_user = current_user
		WHERE dma_id=OLD.dma_id;

		IF view_name = 'ui' THEN
			UPDATE dma SET active = NEW.active WHERE dma_id = OLD.dma_id;

		ELSIF view_name = 'edit' THEN
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