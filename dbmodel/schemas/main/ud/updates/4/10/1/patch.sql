/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE omunit ALTER COLUMN the_geom TYPE public.geometry(multipolygon, SRID_VALUE) USING the_geom::public.geometry(multipolygon, SRID_VALUE);
ALTER TABLE macroomunit ALTER COLUMN the_geom TYPE public.geometry(multipolygon, SRID_VALUE) USING the_geom::public.geometry(multipolygon, SRID_VALUE);

UPDATE config_toolbox
SET active=true
WHERE id=3492;
