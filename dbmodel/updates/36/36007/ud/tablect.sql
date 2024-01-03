/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 3/1/2024
ALTER TABLE arc ALTER COLUMN dma_id DROP NOT NULL;
ALTER TABLE node ALTER COLUMN dma_id DROP NOT NULL;
ALTER TABLE connec ALTER COLUMN dma_id DROP NOT NULL;
ALTER TABLE gully ALTER COLUMN dma_id DROP NOT NULL;
ALTER TABLE link ALTER COLUMN dma_id DROP NOT NULL;
