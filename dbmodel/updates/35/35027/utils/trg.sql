/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/08/04

DROP TRIGGER IF EXISTS gw_trg_manage_raster_dem_insert ON ext_raster_dem;
CREATE TRIGGER gw_trg_manage_raster_dem_insert BEFORE
INSERT ON ext_raster_dem FOR EACH ROW EXECUTE FUNCTION gw_trg_manage_raster_dem();