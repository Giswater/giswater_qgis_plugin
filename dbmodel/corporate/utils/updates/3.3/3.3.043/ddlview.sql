/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


DROP VIEW IF EXISTS ext_raster_dem;
CREATE OR REPLACE VIEW ext_raster_dem AS 
SELECT raster_dem.id,
	code,
	alias,
  raster_type, 
  cat_raster.descript,
  source,
  provider,
  year,
    raster_dem.rast,
    a.expl_id,
    raster_dem.rastercat_id,
    raster_dem.envelope
   FROM 
    exploitation a, utils.raster_dem
    JOIN utils.cat_raster ON cat_raster.id=rastercat_id;
    

DROP VIEW IF EXISTS v_ext_raster_dem;
CREATE OR REPLACE VIEW v_ext_raster_dem AS 
SELECT r.id,
r.code,
r.alias,
r.raster_type, 
r.descript,
r.source,
r.provider,
r.year,
r.rast,
r.rastercat_id,
r.envelope
FROM 
v_edit_exploitation a, ext_raster_dem r
WHERE st_dwithin(r.envelope, a.the_geom, 0::double precision);




