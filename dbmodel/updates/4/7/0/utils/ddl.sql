/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 07/01/2026
ALTER TABLE anl_polygon ALTER COLUMN the_geom TYPE geometry(MULTIPOLYGON, SRID_VALUE) USING the_geom;
