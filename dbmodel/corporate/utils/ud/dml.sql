/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO utils.config_param_system(parameter, value, descript)
VALUES ('ud_current_schema', 'SCHEMA_NAME', 'Indicate the name for the UD schema');

UPDATE config_param_system SET value='TRUE' WHERE parameter='admin_utils_schema';

delete from sys_table where id ='ext_address';
delete from sys_table where id ='ext_municipality';
delete from sys_table where id ='ext_streetaxis';
delete from sys_table where id ='ext_plot';
delete from sys_table where id ='ext_cat_raster';
delete from sys_table where id ='ext_raster_dem';
delete from sys_table where id ='ext_district';
delete from sys_table where id ='ext_region';
delete from sys_table where id ='ext_region_x_province';
delete from sys_table where id ='ext_province';
delete from sys_table where id ='ext_type_street';