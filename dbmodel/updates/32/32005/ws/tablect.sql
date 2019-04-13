/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 3.1.112
ALTER TABLE anl_mincut_cat_state DROP CONSTRAINT IF EXISTS anl_mincut_cat_state_check CASCADE;
ALTER TABLE anl_mincut_cat_state ADD CONSTRAINT anl_mincut_cat_state_check CHECK (id = ANY (ARRAY[0, 1, 2, 3]));
