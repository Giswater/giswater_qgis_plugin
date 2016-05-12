/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


------------------------------------------------
-- SUBCATCHMENT EXPORT
------------------------------------------------

-- Function: "SCHEMA_NAME".gw_dump_subcatchments()

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_dump_subcatchments() RETURNS SETOF character varying LANGUAGE plpgsql AS $$
DECLARE
	subcatchment_polygon public.geometry;
	row_id varchar(16);
	index_point integer;
	point_aux public.geometry;

BEGIN

--	Create the temporal table
	DROP TABLE IF EXISTS temp_subcatchments CASCADE;
	CREATE TEMP TABLE temp_subcatchments("Text" character varying,
		index serial NOT NULL,
		CONSTRAINT outfile_pkey PRIMARY KEY (index));

--	Dump node coordinates for every polygon
	FOR row_id IN SELECT subc_id FROM subcatchment
	LOOP

--		Get the geom and remain fields
		SELECT INTO subcatchment_polygon the_geom FROM subcatchment WHERE subc_id = row_id;

--		Loop for river 2d nodes
		index_point := 1;
		FOR point_aux IN SELECT (ST_dumppoints(subcatchment_polygon)).geom
		LOOP
--			Insert result into outfile table
			INSERT INTO temp_subcatchments VALUES ( format('%s       %s       %s       ', row_id, to_char(ST_X(point_aux),'99999999.999'), to_char(ST_Y(point_aux),'99999999.999')) );
		END LOOP;

	END LOOP;

--	Return the temporal table
	RETURN QUERY SELECT "Text" FROM temp_subcatchments ORDER BY index;

END
$$;

