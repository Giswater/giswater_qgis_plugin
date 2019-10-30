/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE vnode DROP CONSTRAINT IF EXISTS vnode_verified_fkey;
ALTER TABLE vnode DROP CONSTRAINT IF EXISTS vnode_dma_fkey;
ALTER TABLE vnode  ADD CONSTRAINT vnode_dma_fkey FOREIGN KEY (dma_id)
REFERENCES dma (dma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE vnode DROP CONSTRAINT vnode_state_fkey;
ALTER TABLE vnode ADD CONSTRAINT vnode_state_fkey FOREIGN KEY (state)
REFERENCES value_state (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE vnode DROP CONSTRAINT vnode_sector_id_fkey;
ALTER TABLE vnode ADD CONSTRAINT vnode_sector_id_fkey FOREIGN KEY (sector_id)
REFERENCES sector (sector_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE vnode DROP CONSTRAINT vnode_exploitation_id_fkey;
ALTER TABLE vnode ADD CONSTRAINT vnode_exploitation_id_fkey FOREIGN KEY (expl_id)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
