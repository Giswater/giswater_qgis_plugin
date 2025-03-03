/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: TODO


CREATE OR REPLACE FUNCTION gw_trg_edit_supplyzone()
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
		"data":{"message":"3276", "function":"3378","parameters":null, "is_process":true}}$$);';
	END IF;

	IF NOT (SELECT array_agg(muni_id ORDER BY muni_id) @> NEW.muni_id FROM ext_municipality) THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3278", "function":"3378","parameters":null, "is_process":true}}$$);';
	END IF;

	IF TG_OP = 'INSERT' THEN

		IF v_view_name = 'EDIT' THEN
			v_mapzone_id = NEW.macrosector_id;
		ELSIF v_view_name = 'UI' THEN
			SELECT macrosector_id INTO v_mapzone_id FROM macrosector WHERE name = NEW.macrosector;
		END IF;

		INSERT INTO supplyzone (supplyzone_id, name, descript, macrosector_id, supplyzone_type, graphconfig, stylesheet, parent_id, pattern_id, avg_press, link, muni_id, expl_id)
		VALUES (NEW.supplyzone_id, NEW.name, NEW.descript, v_mapzone_id, NEW.supplyzone_type,
		NEW.graphconfig::json, NEW.stylesheet::json, NEW.parent_id, NEW.pattern_id, NEW.avg_press, NEW.link, NEW.muni_id, NEW.expl_id);

		IF v_view_name = 'UI' THEN
			UPDATE supplyzone SET active = NEW.active WHERE supplyzone_id = NEW.supplyzone_id;
		ELSIF v_view_name = 'EDIT' THEN
			UPDATE supplyzone SET the_geom = NEW.the_geom WHERE supplyzone_id = NEW.supplyzone_id;
		END IF;

		INSERT INTO selector_supplyzone VALUES (NEW.supplyzone_id, current_user);

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		IF v_view_name = 'EDIT' THEN
			v_mapzone_id = NEW.macrosector_id;
		ELSIF v_view_name = 'UI' THEN
			SELECT macrosector_id INTO v_mapzone_id FROM macrosector WHERE name = NEW.macrosector;
		END IF;

		UPDATE supplyzone
		SET supplyzone_id=NEW.supplyzone_id, name=NEW.name, descript=NEW.descript, supplyzone_type = NEW.supplyzone_type, macrosector_id=v_mapzone_id,
		graphconfig=NEW.graphconfig::json, stylesheet = NEW.stylesheet::json, parent_id = NEW.parent_id, pattern_id = NEW.pattern_id,
		lastupdate=now(), lastupdate_user = current_user, avg_press = NEW.avg_press, link = NEW.link, muni_id = NEW.muni_id, expl_id = NEW.expl_id
		WHERE supplyzone_id=OLD.supplyzone_id;

		IF v_view_name = 'UI' THEN
			UPDATE supplyzone SET active = NEW.active WHERE supplyzone_id = OLD.supplyzone_id;
		ELSIF v_view_name = 'EDIT' THEN
			UPDATE supplyzone SET the_geom = NEW.the_geom WHERE supplyzone_id = OLD.supplyzone_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM supplyzone WHERE supplyzone_id = OLD.supplyzone_id;
		RETURN NULL;

	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


