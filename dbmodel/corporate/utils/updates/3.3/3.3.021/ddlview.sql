/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- 2019/12/21
CREATE OR REPLACE VIEW ws_test.ext_raster_dem AS 
 SELECT raster_dem.id,
   raster_dem.rast,
   raster_dem.rastercat_id,
   raster_dem.envelope
   FROM utils.raster_dem, ws_test.exploitation a, ws_test.selector_expl b
   WHERE st_dwithin (envelope, the_geom, 0)
   AND a.expl_id=b.expl_id AND cur_user=current_user;
