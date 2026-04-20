/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 20/04/2026
-- update cat_feature_gully column double_geom default value
ALTER TABLE cat_feature_gully ALTER COLUMN double_geom SET DEFAULT '{"activated":false,"value":1}'::JSON;