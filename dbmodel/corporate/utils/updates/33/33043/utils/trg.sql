/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- 2020/04/15
DROP TRIGGER IF EXISTS gw_trg_manage_raster_dem ON SCHEMA_NAME.raster_dem;
DROP TRIGGER IF EXISTS gw_trg_manage_raster_dem_insert ON SCHEMA_NAME.raster_dem;
CREATE TRIGGER gw_trg_manage_raster_dem_insert BEFORE INSERT ON SCHEMA_NAME.raster_dem
FOR EACH ROW EXECUTE PROCEDURE gw_trg_manage_raster_dem();

DROP TRIGGER IF EXISTS gw_trg_manage_raster_dem_delete ON SCHEMA_NAME.raster_dem;
CREATE TRIGGER gw_trg_manage_raster_dem_delete AFTER DELETE ON SCHEMA_NAME.raster_dem
FOR EACH ROW EXECUTE PROCEDURE gw_trg_manage_raster_dem();