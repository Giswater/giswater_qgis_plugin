/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

ALTER TABLE if exists ext_address RENAME TO ext_address_old;
ALTER TABLE if exists ext_cat_raster RENAME TO ext_cat_raster_old;
ALTER TABLE if exists ext_district RENAME TO ext_district_old;
ALTER TABLE if exists ext_region_x_province RENAME TO ext_region_x_province_old;
ALTER TABLE if exists ext_municipality RENAME TO ext_municipality_old;
ALTER TABLE if exists ext_plot RENAME TO ext_plot_old;
ALTER TABLE if exists ext_province RENAME TO ext_province_old;
ALTER TABLE if exists ext_raster_dem RENAME TO ext_raster_dem_old;
ALTER TABLE if exists ext_region RENAME TO ext_region_old;
ALTER TABLE if exists ext_streetaxis RENAME TO ext_streetaxis_old;
ALTER TABLE if exists ext_type_street RENAME TO ext_type_street_old;