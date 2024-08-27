/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE sys_style ADD CONSTRAINT sys_style_pkey PRIMARY KEY (layername, styleconfig_id);
ALTER TABLE sys_style ALTER COLUMN styleconfig_id SET NOT NULL;

ALTER TABLE drainzone ADD CONSTRAINT drainzone_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
ALTER TABLE dma ADD CONSTRAINT dma_muni_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id);

ALTER TABLE raingage ADD CONSTRAINT raingage_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);