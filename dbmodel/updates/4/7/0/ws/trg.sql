/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 07/01/2026
DROP INDEX IF EXISTS node_expl_visibility_idx;
DROP INDEX IF EXISTS arc_expl_visibility_idx;
DROP INDEX IF EXISTS connec_expl_visibility_idx;
DROP INDEX IF EXISTS link_expl_visibility_idx;
DROP INDEX IF EXISTS element_expl_visibility_idx;

-- Recreate indexes with gin index
CREATE INDEX node_expl_visibility_gin ON node USING gin(expl_visibility) WHERE expl_visibility IS NOT NULL;
CREATE INDEX arc_expl_visibility_gin ON arc USING gin(expl_visibility) WHERE expl_visibility IS NOT NULL;
CREATE INDEX connec_expl_visibility_gin ON connec USING gin(expl_visibility) WHERE expl_visibility IS NOT NULL;
CREATE INDEX link_expl_visibility_gin ON link USING gin(expl_visibility) WHERE expl_visibility IS NOT NULL;
CREATE INDEX element_expl_visibility_gin ON element USING gin(expl_visibility) WHERE expl_visibility IS NOT NULL;
