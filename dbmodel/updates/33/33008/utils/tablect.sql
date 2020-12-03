/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 23/10/2019


ALTER TABLE raster_dem ADD CONSTRAINT raster_dem_rastercat_id_fkey FOREIGN KEY (rastercat_id)
      REFERENCES cat_raster (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
