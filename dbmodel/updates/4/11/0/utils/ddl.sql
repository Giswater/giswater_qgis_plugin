/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 18/05/2026
DROP VIEW IF EXISTS ve_exploitation;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON exploitation;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_sector ON exploitation;

ALTER TABLE exploitation DROP COLUMN sector_id;
ALTER TABLE exploitation DROP COLUMN muni_id;
