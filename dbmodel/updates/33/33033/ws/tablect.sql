/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/13
ALTER TABLE ext_rtc_hydrometer_x_data DROP CONSTRAINT IF EXISTS cat_period_id_fk;

ALTER TABLE ext_rtc_hydrometer_x_data ADD CONSTRAINT cat_period_id_fk FOREIGN KEY (cat_period_id)
REFERENCES ext_cat_period (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
