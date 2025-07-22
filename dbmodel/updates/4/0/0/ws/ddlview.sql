/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


-- delete all views to avoid conflicts, then recreate them
DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

        CREATE OR REPLACE VIEW ext_municipality AS SELECT * FROM utils.municipality;

    ELSE
    
        CREATE OR REPLACE VIEW v_ext_municipality
        AS SELECT DISTINCT s.muni_id,
            m.name,
            m.expl_id,
            m.sector_id,
            m.active,
            m.the_geom
            FROM ext_municipality m, selector_municipality s
            WHERE m.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;

    END IF;
END; $$;