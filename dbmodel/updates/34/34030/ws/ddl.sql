/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/01/30
ALTER TABLE temp_arc ALTER COLUMN the_geom TYPE geometry(LineString, SRID_VALUE);
ALTER TABLE temp_node ALTER COLUMN the_geom TYPE geometry(Point, SRID_VALUE);