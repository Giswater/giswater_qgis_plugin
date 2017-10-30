/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP

ALTER TABLE rtc_scada_x_dma ALTER COLUMN scada_id DROP NOT NULL;

ALTER TABLE rtc_scada_x_sector ALTER COLUMN scada_id DROP NOT NULL;


--CREATE
ALTER TABLE rtc_scada_x_dma ALTER COLUMN scada_id SET NOT NULL;

ALTER TABLE rtc_scada_x_sector ALTER COLUMN scada_id SET NOT NULL;