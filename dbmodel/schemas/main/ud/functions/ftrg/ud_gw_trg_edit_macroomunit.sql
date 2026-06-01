/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 1124

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_macroomunit()
  RETURNS trigger AS
$BODY$
DECLARE
	v_view_name TEXT;
	v_macroomunit_id INTEGER;
	v_count INTEGER;
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Arg will be or 'edit' or 'ui'
	v_view_name = TG_ARGV[0];

	IF TG_OP = 'INSERT' THEN

		IF NEW.macroomunit_id != (SELECT last_value FROM urn_id_seq) OR NEW.macroomunit_id IS NULL THEN
			NEW.macroomunit_id:= (SELECT nextval('urn_id_seq'));
		END IF;

		INSERT INTO macroomunit (macroomunit_id, node_1, node_2, catchment_node, order_number, the_geom, expl_id, muni_id, sector_id)
		VALUES (NEW.macroomunit_id, NEW.node_1, NEW.node_2, NEW.catchment_node, NEW.order_number, NEW.the_geom, NEW.expl_id, NEW.muni_id, NEW.sector_id);

		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE macroomunit SET node_1=NEW.node_1, node_2=NEW.node_2, catchment_node=NEW.catchment_node, order_number=NEW.order_number, the_geom=NEW.the_geom, 
		expl_id=NEW.expl_id, muni_id=NEW.muni_id, sector_id=NEW.sector_id WHERE macroomunit_id=OLD.macroomunit_id;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM macroomunit WHERE macroomunit_id = OLD.macroomunit_id;

		RETURN NULL;

	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
