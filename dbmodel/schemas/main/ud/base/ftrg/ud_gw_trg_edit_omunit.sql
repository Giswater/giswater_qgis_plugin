/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 1124

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_omunit()
  RETURNS trigger AS
$BODY$
DECLARE
	v_view_name TEXT;
	v_omunit_id INTEGER;
	v_count INTEGER;
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Arg will be or 'edit' or 'ui'
	v_view_name = TG_ARGV[0];

	IF TG_OP = 'INSERT' THEN

		IF NEW.omunit_id != (SELECT last_value FROM urn_id_seq) OR NEW.omunit_id IS NULL THEN
			NEW.omunit_id:= (SELECT nextval('urn_id_seq'));
		END IF;

		INSERT INTO omunit (omunit_id, node_1, node_2, macroomunit_id, order_number, the_geom, expl_id, muni_id, sector_id)
		VALUES (NEW.omunit_id, NEW.node_1, NEW.node_2, NEW.macroomunit_id, NEW.order_number, NEW.the_geom, NEW.expl_id, NEW.muni_id, NEW.sector_id);

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE omunit SET node_1=NEW.node_1, node_2=NEW.node_2, macroomunit_id=NEW.macroomunit_id, order_number=NEW.order_number, the_geom=NEW.the_geom, 
		expl_id=NEW.expl_id, muni_id=NEW.muni_id, sector_id=NEW.sector_id WHERE omunit_id=OLD.omunit_id;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		-- Check if there are operative elements in the mapzone before allowing delete
		SELECT SUM(counts) INTO v_count FROM (
			SELECT count(*) as counts
				FROM node n
				JOIN value_state_type vst ON vst.id = n.state_type
				WHERE n.omunit_id = OLD.omunit_id
					AND n.state = 1
					AND vst.is_operative
			UNION ALL
			SELECT count(*) as counts
				FROM arc a
				JOIN value_state_type vst ON vst.id = a.state_type
				WHERE a.omunit_id = OLD.omunit_id
					AND a.state = 1
					AND vst.is_operative
			UNION ALL
			SELECT count(*) as counts
				FROM connec c
				JOIN value_state_type vst ON vst.id = c.state_type
				WHERE c.omunit_id = OLD.omunit_id
					AND c.state = 1
					AND vst.is_operative
			UNION ALL
			SELECT count(*) as counts
				FROM gully g
				JOIN value_state_type vst ON vst.id = g.state_type
				WHERE g.omunit_id = OLD.omunit_id
					AND g.state = 1
					AND vst.is_operative
			UNION ALL
			SELECT count(*) as counts
				FROM link l
				JOIN value_state_type vst ON vst.id = l.state_type
				WHERE l.omunit_id = OLD.omunit_id
					AND l.state = 1
					AND vst.is_operative
		) combined;
		IF COALESCE(v_count, 0) > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4468", "function":"1112","parameters":{"mapzone_name":"Sector", "mapzone_id":'||OLD.sector_id||'}}}$$);';
		END IF;

		UPDATE node SET omunit_id = 0 WHERE omunit_id = OLD.omunit_id;
		UPDATE arc SET omunit_id = 0 WHERE omunit_id = OLD.omunit_id;
		UPDATE connec SET omunit_id = 0 WHERE omunit_id = OLD.omunit_id;
		UPDATE gully SET omunit_id = 0 WHERE omunit_id = OLD.omunit_id;
		UPDATE link SET omunit_id = 0 WHERE omunit_id = OLD.omunit_id;

		DELETE FROM omunit WHERE omunit_id = OLD.omunit_id;

		RETURN NULL;

	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
