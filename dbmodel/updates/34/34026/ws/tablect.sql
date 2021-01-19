/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/01/15
ALTER TABLE rtc_scada_node DROP CONSTRAINT IF EXISTS rtc_scada_node_scada_id_fkey;

ALTER TABLE rtc_scada_x_dma DROP CONSTRAINT IF EXISTS rtc_scada_x_dma_scada_id_fkey;

ALTER TABLE rtc_scada_x_sector DROP CONSTRAINT IF EXISTS rtc_scada_x_sector_scada_id_fkey;