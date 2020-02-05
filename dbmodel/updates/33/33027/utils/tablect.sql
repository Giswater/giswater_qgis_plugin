/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/02/04
ALTER TABLE node ADD CONSTRAINT node_unique_code UNIQUE(code);
ALTER TABLE arc ADD CONSTRAINT arc_unique_code UNIQUE(code);
ALTER TABLE connec ADD CONSTRAINT connec_unique_code UNIQUE(code);
ALTER TABLE element ADD CONSTRAINT element_unique_code UNIQUE(code);
