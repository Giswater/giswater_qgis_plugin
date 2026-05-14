/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "utils", public, pg_catalog;

create trigger gw_trg_manage_raster_dem_delete after delete on utils.raster_dem 
for each row execute function utils.gw_trg_manage_raster_dem();

create trigger gw_trg_manage_raster_dem_insert before insert on utils.raster_dem
for each row execute function utils.gw_trg_manage_raster_dem();