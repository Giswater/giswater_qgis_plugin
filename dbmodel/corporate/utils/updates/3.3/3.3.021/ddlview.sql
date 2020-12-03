/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- 2019/12/21
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
    JOIN utils.cat_raster ON cat_raster.id=rastercat_id
  WHERE st_dwithin(raster_dem.envelope, a.the_geom, 0::double precision);
