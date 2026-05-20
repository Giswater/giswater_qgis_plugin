/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 18/05/2026
CREATE OR REPLACE VIEW ve_exploitation
AS SELECT e.expl_id,
    e.code,
    e.name,
    e.macroexpl_id,
    e.owner_vdefault,
    e.descript,
    e.lock_level,
    e.active,
    e.the_geom,
    e.created_at,
    e.created_by,
    e.updated_at,
    e.updated_by
FROM exploitation e
WHERE EXISTS (
    SELECT 1
    FROM selector_expl se
    WHERE se.expl_id = e.expl_id AND se.cur_user = CURRENT_USER
) AND e.active IS TRUE;