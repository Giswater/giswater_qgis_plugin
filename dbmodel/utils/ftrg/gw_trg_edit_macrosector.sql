/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 1246

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_macrosector()
  RETURNS trigger AS
$BODY$

DECLARE

	v_view_name TEXT; -- EDIT | UI

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

	IF TG_OP = 'INSERT' THEN

		IF v_view_name = 'UI' THEN
			IF NEW.active IS NULL THEN
				NEW.active = TRUE;
			END IF;
		END IF;

		INSERT INTO macrosector (macrosector_id, name, descript, lock_level) VALUES (NEW.macrosector_id, NEW.name, NEW.descript, NEW.lock_level);

		IF v_view_name = 'UI' THEN
			UPDATE macrosector SET active = NEW.active WHERE macrosector_id = NEW.macrosector_id;
		ELSIF v_view_name = 'EDIT' THEN
			UPDATE macrosector SET the_geom = NEW.the_geom WHERE macrosector_id = NEW.macrosector_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE macrosector
		SET macrosector_id=NEW.macrosector_id, name=NEW.name, descript=NEW.descript, lock_level=NEW.lock_level
		WHERE macrosector_id=NEW.macrosector_id;


		IF v_view_name = 'UI' THEN
			UPDATE macrosector SET active = NEW.active WHERE macrosector_id = OLD.macrosector_id;
		ELSIF v_view_name = 'EDIT' THEN
			UPDATE macrosector SET the_geom = NEW.the_geom WHERE macrosector_id = OLD.macrosector_id;
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		UPDATE sector SET macrosector_id=NULL WHERE macrosector_id = OLD.macrosector_id;
		DELETE FROM macrosector WHERE macrosector_id = OLD.macrosector_id;
		RETURN NULL;

	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
