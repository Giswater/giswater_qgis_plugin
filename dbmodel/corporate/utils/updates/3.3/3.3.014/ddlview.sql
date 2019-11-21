/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE VIEW SCHEMA_NAME.ext_raster_dem AS
SELECT
  raster_dem.id,
  code,
  alias,
  raster_type, 
  descript,
  source,
  provider,
  year,
  rast
FROM utils.raster_dem
JOIN utils.cat_raster ON cat_raster.id=rastercat_id;
