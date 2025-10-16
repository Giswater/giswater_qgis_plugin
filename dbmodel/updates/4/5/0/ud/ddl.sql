/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2025/10/15
-- Add archived boolean column to plan_psector_x_gully (UD-specific)
ALTER TABLE plan_psector_x_gully ADD COLUMN IF NOT EXISTS archived boolean DEFAULT false;

-- Drop old archived_psector_gully table (no longer needed with boolean flag approach)
ALTER TABLE IF EXISTS archived_psector_gully RENAME TO _archived_psector_gully_;
