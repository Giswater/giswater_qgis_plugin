/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25
ALTER TABLE cat_presszone RENAME TO presszone;

ALTER TABLE sector ADD COLUMN stylesheet json;
ALTER TABLE dma ADD COLUMN stylesheet json;
ALTER TABLE presszone ADD COLUMN head numeric(12,2);
ALTER TABLE presszone ADD COLUMN stylesheet json;
ALTER TABLE dqa ADD COLUMN stylesheet json;

ALTER TABLE presszone ALTER COLUMN id RENAME TO presszone_id;
ALTER TABLE presszone ALTER COLUMN descrpit RENAME TO name;