/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO utils.config_param_system(parameter, value, descript)
VALUES ('ws_current_schema', 'SCHEMA_NAME', 'Indicate the name for the WS schema');

UPDATE config_param_system SET value='TRUE' WHERE parameter='admin_utils_schema';

insert into utils.province select * from ext_province_old;
insert into utils.region select * from ext_region_old;
insert into utils.region_x_province select * from ext_region_x_province_old;
insert into utils.municipality select * from ext_municipality_old;
insert into utils.district select * from ext_district_old;
insert into utils.cat_raster select * from ext_cat_raster_old;
insert into utils.raster_dem select * from ext_raster_dem_old;
insert into utils.type_street select * from ext_type_street_old;
insert into utils.streetaxis select * from ext_streetaxis_old;
insert into utils.plot select * from ext_plot_old;
insert into utils.address select * from ext_address_old;