/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3178

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_drainzone()  RETURNS trigger AS
$BODY$

DECLARE
	v_view_name TEXT;
	v_drainzone_id INTEGER;
	v_count INTEGER;
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Arg will be or 'edit' or 'ui'
	v_view_name = TG_ARGV[0];

	IF TG_OP = 'INSERT' THEN

		-- expl_id
		IF ((SELECT COUNT(*) FROM exploitation WHERE active IS TRUE) = 0) THEN
			RETURN NULL;
		END IF;

		-- active
		IF NEW.active IS NULL THEN
			NEW.active = TRUE;
		END IF;

		IF v_view_name = 'EDIT'THEN
			IF NEW.the_geom IS NOT NULL THEN
				IF NEW.expl_id IS NULL THEN
					NEW.expl_id := (SELECT expl_id FROM exploitation WHERE active IS TRUE AND ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				END IF;
			END IF;
		END IF;

		SELECT max(drainzone_id::integer)+1 INTO v_drainzone_id FROM drainzone WHERE drainzone_id::text ~ '^[0-9]+$';
		IF NEW.code IS NULL THEN
			NEW.code := v_drainzone_id::text;
		END IF;

		INSERT INTO drainzone (drainzone_id, code, name, active, drainzone_type, expl_id, sector_id, muni_id, descript, graphconfig, stylesheet, link, lock_level, addparam, created_at, created_by, updated_at, updated_by)
		VALUES (v_drainzone_id, NEW.code, NEW.name, NEW.active, NEW.drainzone_type, NEW.expl_id, NEW.sector_id, NEW.muni_id, NEW.descript,
		NEW.graphconfig::json, NEW.stylesheet::json, NEW.link, NEW.lock_level, NEW.addparam::json, now(), current_user, now(), current_user);

		IF v_view_name = 'EDIT' THEN
			UPDATE drainzone SET the_geom = NEW.the_geom WHERE drainzone_id = NEW.drainzone_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE drainzone
		SET drainzone_id=NEW.drainzone_id, code=NEW.code, name=NEW.name, descript=NEW.descript, active=NEW.active, drainzone_type=NEW.drainzone_type, expl_id=NEW.expl_id,
		sector_id=NEW.sector_id, muni_id=NEW.muni_id, graphconfig=NEW.graphconfig::json, stylesheet=NEW.stylesheet::json,
		link=NEW.link, lock_level=NEW.lock_level, addparam=NEW.addparam::json, updated_at=now(), updated_by = current_user
		WHERE drainzone_id=OLD.drainzone_id;

		IF v_view_name = 'EDIT' THEN
			UPDATE drainzone SET the_geom = NEW.the_geom WHERE drainzone_id = OLD.drainzone_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		-- Check if there are operative elements in the mapzone before allowing delete
		SELECT SUM(counts) INTO v_count FROM (
			SELECT count(*) as counts
				FROM node n
				JOIN value_state_type vst ON vst.id = n.state_type
				WHERE n.drainzone_id = OLD.drainzone_id
					AND n.state = 1
					AND vst.is_operative
			UNION ALL
			SELECT count(*) as counts
				FROM arc a
				JOIN value_state_type vst ON vst.id = a.state_type
				WHERE a.drainzone_id = OLD.drainzone_id
					AND a.state = 1
					AND vst.is_operative
			UNION ALL
			SELECT count(*) as counts
				FROM connec c
				JOIN value_state_type vst ON vst.id = c.state_type
				WHERE c.drainzone_id = OLD.drainzone_id
					AND c.state = 1
					AND vst.is_operative
			UNION ALL
			SELECT count(*) as counts
				FROM gully g
				JOIN value_state_type vst ON vst.id = g.state_type
				WHERE g.drainzone_id = OLD.drainzone_id
					AND g.state = 1
					AND vst.is_operative
			UNION ALL
			SELECT count(*) as counts
				FROM link l
				JOIN value_state_type vst ON vst.id = l.state_type
				WHERE l.drainzone_id = OLD.drainzone_id
					AND l.state = 1
					AND vst.is_operative
		) combined;
		IF COALESCE(v_count, 0) > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4468", "function":"1112","parameters":{"mapzone_name":"Drainzone", "mapzone_id":'||OLD.drainzone_id||'}}}$$);';
		END IF;

		UPDATE node SET drainzone_id = 0 WHERE drainzone_id = OLD.drainzone_id;
		UPDATE arc SET drainzone_id = 0 WHERE drainzone_id = OLD.drainzone_id;
		UPDATE connec SET drainzone_id = 0 WHERE drainzone_id = OLD.drainzone_id;
		UPDATE gully SET drainzone_id = 0 WHERE drainzone_id = OLD.drainzone_id;
		UPDATE link SET drainzone_id = 0 WHERE drainzone_id = OLD.drainzone_id;

		DELETE FROM drainzone WHERE drainzone_id = OLD.drainzone_id;
		RETURN NULL;
	END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


