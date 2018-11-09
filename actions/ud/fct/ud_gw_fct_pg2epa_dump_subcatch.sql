/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2228


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2epa_dump_subcatch() RETURNS SETOF character varying LANGUAGE plpgsql AS $$
DECLARE
    subcatchment_polygon public.geometry;
    row_id varchar(16);
    index_point integer;
    point_aux public.geometry;

BEGIN


	--  Search path
    SET search_path = "SCHEMA_NAME", public;

	--  Reset values
	DELETE FROM temp_table WHERE user_name=cur_user AND fprocesscat_id=17;

    -- Dump node coordinates for every polygon
    FOR row_id IN SELECT subc_id FROM v_edit_subcatchment
    LOOP

        -- Get the geom and remain fields
        SELECT INTO subcatchment_polygon the_geom FROM subcatchment WHERE subc_id = row_id;

        -- Loop for nodes
        index_point := 1;
        FOR point_aux IN SELECT (ST_dumppoints(subcatchment_polygon)).geom
        LOOP
            -- Insert result into outfile table
            INSERT INTO temp_table (fprocesscat_id, text) VALUES ( 17, format('%s       %s       %s       ', row_id, to_char(ST_X(point_aux),'99999999.999'), to_char(ST_Y(point_aux),'99999999.999')) );
        END LOOP;

    END LOOP;

    -- Return the temporal table
    RETURN QUERY SELECT text FROM temp_table WHERE user_name=cur_user AND fprocesscat_id=17 ORDER BY index;

END
$$;

