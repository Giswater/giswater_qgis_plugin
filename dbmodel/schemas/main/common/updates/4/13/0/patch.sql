/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog; 

-- Add column is_twin
ALTER TABLE rpt_cat_result ADD COLUMN IF NOT EXISTS is_twin boolean DEFAULT false;

ALTER TABLE rpt_cat_result ADD COLUMN IF NOT EXISTS parent_id varchar(16);
