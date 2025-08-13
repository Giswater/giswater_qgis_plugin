/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE rpt_cat_result DROP CONSTRAINT IF EXISTS rpt_cat_result_network_dma_corporate;
ALTER TABLE rpt_cat_result ADD CONSTRAINT rpt_cat_result_network_dma_corporate CHECK (NOT (iscorporate = TRUE AND network_type = '5'));
