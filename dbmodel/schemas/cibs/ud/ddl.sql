/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

ALTER TABLE IF EXISTS ext_cat_hydrometer RENAME TO ext_cat_hydrometer_old;
ALTER TABLE IF EXISTS ext_cat_hydrometer_priority RENAME TO ext_cat_hydrometer_priority_old;
ALTER TABLE IF EXISTS ext_cat_hydrometer_type RENAME TO ext_cat_hydrometer_type_old;
ALTER TABLE IF EXISTS ext_cat_hydrometer_category RENAME TO ext_cat_hydrometer_category_old;
ALTER TABLE IF EXISTS ext_cat_hydrometer_state RENAME TO ext_cat_hydrometer_state_old;
ALTER TABLE IF EXISTS ext_hydrometer RENAME TO ext_hydrometer_old;
ALTER TABLE IF EXISTS ext_hydrometer_data RENAME TO ext_hydrometer_data_old;
ALTER TABLE IF EXISTS ext_cat_hydrometer_category_x_pattern RENAME TO ext_cat_hydrometer_category_x_pattern_old;
