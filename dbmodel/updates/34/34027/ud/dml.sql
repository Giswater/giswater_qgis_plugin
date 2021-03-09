/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/01/22
INSERT INTO macroexploitation VALUES ('0', 'Undefined', 'Undefined') ON CONFLICT (macroexpl_id) DO NOTHING;
INSERT INTO exploitation VALUES (0, 'Undefined', 0, NULL, NULL, NULL, null, TRUE) ON CONFLICT (expl_id) DO NOTHING;
INSERT INTO macrodma VALUES (0, 'Undefined', 0, NULL, NULL) ON CONFLICT (macrodma_id) DO NOTHING;
INSERT INTO dma VALUES (0, 'Undefined', 0, NULL, NULL, NULL) ON CONFLICT (dma_id) DO NOTHING;
INSERT INTO macrosector VALUES (0, 'Undefined','Undefined', NULL) ON CONFLICT (macrosector_id) DO NOTHING;
INSERT INTO sector VALUES (0, 'Undefined', 0, 'Undefined', NULL) ON CONFLICT (sector_id) DO NOTHING;
