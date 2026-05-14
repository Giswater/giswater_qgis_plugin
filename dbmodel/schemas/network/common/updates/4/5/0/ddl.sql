/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2025/10/15
-- Add archived boolean column to plan_psector_x_* tables (common to WS and UD)
ALTER TABLE plan_psector_x_arc ADD COLUMN IF NOT EXISTS archived boolean DEFAULT false;
ALTER TABLE plan_psector_x_node ADD COLUMN IF NOT EXISTS archived boolean DEFAULT false;
ALTER TABLE plan_psector_x_connec ADD COLUMN IF NOT EXISTS archived boolean DEFAULT false;

-- Rename old archived_psector_* tables (no longer needed with boolean flag approach)
ALTER TABLE IF EXISTS archived_psector_arc RENAME TO _archived_psector_arc_;
ALTER TABLE IF EXISTS archived_psector_node RENAME TO _archived_psector_node_;
ALTER TABLE IF EXISTS archived_psector_connec RENAME TO _archived_psector_connec_;
ALTER TABLE IF EXISTS archived_psector_link RENAME TO _archived_psector_link_;

-- 20/10/2025
ALTER TABLE audit_check_data ALTER COLUMN tstamp SET DEFAULT CLOCK_TIMESTAMP();
