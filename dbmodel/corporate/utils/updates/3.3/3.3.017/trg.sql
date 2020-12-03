/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "utils", public, pg_catalog;


DROP TRIGGER IF EXISTS gw_trg_manage_raster_dem ON utils.raster_dem;
CREATE TRIGGER gw_trg_manage_raster_dem
AFTER INSERT OR DELETE ON utils.raster_dem
FOR EACH ROW
EXECUTE PROCEDURE utils.gw_trg_manage_raster_dem();

