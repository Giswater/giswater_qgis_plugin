/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

DELETE FROM sys_table WHERE id = 'ext_cat_hydrometer';
DELETE FROM sys_table WHERE id = 'ext_cat_hydrometer_priority';
DELETE FROM sys_table WHERE id = 'ext_cat_hydrometer_type';
DELETE FROM sys_table WHERE id = 'ext_cat_hydrometer_category';
DELETE FROM sys_table WHERE id = 'ext_cat_hydrometer_state';
DELETE FROM sys_table WHERE id = 'ext_hydrometer';
DELETE FROM sys_table WHERE id = 'ext_hydrometer_data';
DELETE FROM sys_table WHERE id = 'ext_cat_hydrometer_category_x_pattern';
