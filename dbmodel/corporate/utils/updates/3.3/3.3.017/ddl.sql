/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "utils", public, pg_catalog;


--21/11/2019
CREATE TABLE district
(
  district_id integer NOT NULL,
  name text,
  muni_id integer NOT NULL,
  observ text,
  active boolean,
  the_geom geometry(MultiPolygon,SRID_VALUE),
  CONSTRAINT district_pkey PRIMARY KEY (district_id)
);


ALTER TABLE utils.raster_dem ADD COLUMN envelope geometry (POLYGON,25831);
