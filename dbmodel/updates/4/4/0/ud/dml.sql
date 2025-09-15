/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_table SET alias = 'Inp Raingage' WHERE id = 've_raingage';

INSERT INTO dwfzone (dwfzone_id, code, "name", dwfzone_type, expl_id, sector_id, muni_id, descript, link, graphconfig, stylesheet, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by, drainzone_id, addparam) VALUES(-1, '-1', 'Conflict', NULL, '{NULL}', NULL, NULL, 'Dwfzone used on graphanalytics algorithm when two ore more zones has conflict in terms of some interconnection.', NULL, '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
