/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_table SET alias = 'Inp Raingage' WHERE id = 've_raingage';

INSERT INTO dwfzone (dwfzone_id, code, "name", dwfzone_type, expl_id, sector_id, muni_id, descript, link, graphconfig, stylesheet, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by, drainzone_id, addparam) VALUES(-1, '-1', 'Conflict', NULL, '{0}', NULL, NULL, 'Dwfzone used on graphanalytics algorithm when two ore more zones has conflict in terms of some interconnection.', NULL, '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (dwfzone_id) DO NOTHING;
INSERT INTO sector (sector_id, code, "name", descript, sector_type, expl_id, muni_id, macrosector_id, parent_id, graphconfig, stylesheet, link, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by, addparam) VALUES(-1, '-1', 'Conflict', 'Sector used on graphanalytics algorithm when two ore more zones has conflict in terms of some interconnection.', NULL, '{0}', NULL, 0, NULL, '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (sector_id) DO NOTHING;
INSERT INTO omzone (omzone_id, code, "name", descript, omzone_type, expl_id, macroomzone_id, minc, maxc, effc, link, graphconfig, stylesheet, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by, sector_id, muni_id, addparam) VALUES(-1, '-1', 'Conflict', 'Omzone used on graphanalytics algorithm when two ore more zones has conflict in terms of some interconnection.', NULL, '{0}', 0, NULL, NULL, NULL, NULL, '{"use":[{"nodeParent":""}], "ignore":[], "forceClosed":[]}'::json, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (omzone_id) DO NOTHING;
UPDATE dma SET descript='Undefined',"name"='Undefined',code='0' WHERE dma_id=0;
INSERT INTO dma (dma_id, code, "name", descript, dma_type, muni_id, expl_id, sector_id, avg_press, pattern_id, effc, graphconfig, stylesheet, lock_level, link, addparam, active, the_geom, created_at, created_by, updated_at, updated_by) VALUES(-1, '-1', 'Conflict', 'Dma used on graphanalytics algorithm when two ore more zones has conflict in terms of some interconnection.', NULL, NULL, '{0}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (dma_id) DO NOTHING;
