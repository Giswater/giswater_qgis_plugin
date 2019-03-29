/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



-- 2019/03/29
ALTER TABLE dma RENAME COLUMN pattern_id to _pattern_id_;
ALTER TABLE dma ADD COLUMN pattern_id character varying(16);
ALTER TABLE rpt_inp_node ADD COLUMN pattern_id character varying(16);
