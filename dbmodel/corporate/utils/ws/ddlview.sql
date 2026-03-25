/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE OR REPLACE VIEW v_municipality AS
SELECT * FROM utils.municipality;

CREATE OR REPLACE VIEW v_streetaxis AS
SELECT * FROM utils.streetaxis;

CREATE OR REPLACE VIEW v_address AS
SELECT * FROM utils.address;

CREATE OR REPLACE VIEW v_plot AS
SELECT * FROM utils.plot;

CREATE OR REPLACE VIEW v_raster_dem AS
SELECT * FROM utils.raster_dem;

CREATE OR REPLACE VIEW v_ext_raster_dem
AS SELECT DISTINCT ON (r.id) r.id,
    c.code,
    c.alias,
    c.raster_type,
    c.descript,
    c.source,
    c.provider,
    c.year,
    r.rast,
    r.rastercat_id,
    r.envelope
   FROM v_ext_municipality a,
    v_raster_dem r
     JOIN utils.cat_raster c ON c.id = r.rastercat_id
  WHERE st_dwithin(r.envelope, a.the_geom, 0::double precision);

CREATE OR REPLACE VIEW v_district AS
SELECT * FROM utils.district;

CREATE OR REPLACE VIEW v_region AS
SELECT * FROM utils.region;

CREATE OR REPLACE VIEW v_province AS
SELECT * FROM utils.province;