/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE ext_cat_period ADD CONSTRAINT ext_cat_period_period_type_fkey FOREIGN KEY (period_type)
REFERENCES ext_cat_period_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;