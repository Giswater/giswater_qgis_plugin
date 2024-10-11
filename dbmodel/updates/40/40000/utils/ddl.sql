/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE cat_feature DROP CONSTRAINT IF EXISTS cat_feature_system_fkey;
ALTER TABLE cat_feature RENAME COLUMN system_id TO sys_feature_cat;
ALTER TABLE cat_feature ADD CONSTRAINT cat_feature_sys_feature_cat_fkey FOREIGN KEY (sys_feature_cat, feature_type) REFERENCES sys_feature_cat(id, type) ON UPDATE CASCADE ON DELETE CASCADE;
