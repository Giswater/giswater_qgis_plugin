/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_municipality AS
SELECT * FROM ext_municipality;

CREATE OR REPLACE VIEW ve_municipality
AS SELECT DISTINCT s.muni_id,
    m.name,
    m.active,
    m.the_geom
   FROM v_municipality m,
    selector_municipality s
  WHERE m.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;
  
  
CREATE OR REPLACE VIEW v_streetaxis AS
SELECT * FROM ext_streetaxis;

CREATE OR REPLACE VIEW ve_streetaxis
AS SELECT v_streetaxis.id,
    v_streetaxis.code,
    v_streetaxis.type,
    v_streetaxis.name,
    v_streetaxis.text,
    v_streetaxis.the_geom,
    v_streetaxis.muni_id,
        CASE
            WHEN v_streetaxis.type IS NULL THEN v_streetaxis.name::text
            WHEN v_streetaxis.text IS NULL THEN ((v_streetaxis.name::text || ', '::text) || v_streetaxis.type::text) || '.'::text
            WHEN v_streetaxis.type IS NULL AND v_streetaxis.text IS NULL THEN v_streetaxis.name::text
            ELSE (((v_streetaxis.name::text || ', '::text) || v_streetaxis.type::text) || '. '::text) || v_streetaxis.text
        END AS descript,
    v_streetaxis.source
   FROM selector_municipality,
    v_streetaxis
  WHERE v_streetaxis.muni_id = selector_municipality.muni_id AND selector_municipality.cur_user = "current_user"()::text;
  
  
CREATE OR REPLACE VIEW v_address AS
SELECT * FROM ext_address;

CREATE OR REPLACE VIEW ve_address
AS SELECT v_address.id,
    v_address.muni_id,
    v_address.postcode,
    v_address.streetaxis_id,
    v_address.postnumber,
    v_address.plot_id,
    v_streetaxis.name,
    v_address.the_geom,
    v_address.postcomplement,
    v_address.code,
    v_address.source
   FROM selector_municipality s,
    v_address
     LEFT JOIN v_streetaxis ON v_streetaxis.id::text = v_address.streetaxis_id::text
  WHERE v_address.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;
  
  
CREATE OR REPLACE VIEW v_plot AS
SELECT * FROM ext_plot;

CREATE OR REPLACE VIEW ve_plot
AS SELECT v_plot.id,
    v_plot.code,
    v_plot.muni_id,
    v_plot.postcode,
    v_plot.streetaxis_id,
    v_plot.postnumber,
    v_plot.complement,
    v_plot.placement,
    v_plot.square,
    v_plot.observ,
    v_plot.text,
    v_plot.the_geom
   FROM selector_municipality s,
    v_plot
  WHERE v_plot.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;
  
  
CREATE OR REPLACE VIEW v_raster_dem AS
SELECT * FROM ext_raster_dem;

CREATE OR REPLACE VIEW ve_raster_dem
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
   FROM ve_municipality a,
    v_raster_dem r
     JOIN ext_cat_raster c ON c.id = r.rastercat_id
  WHERE st_dwithin(r.envelope, a.the_geom, 0::double precision);
  
CREATE OR REPLACE VIEW v_district AS
SELECT * FROM ext_district;

CREATE OR REPLACE VIEW v_region AS
SELECT * FROM ext_region;

CREATE OR REPLACE VIEW v_province AS
SELECT * FROM ext_province;