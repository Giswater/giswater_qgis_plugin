/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

update arc set muni_id = 0 where muni_id is null;
update node set muni_id = 0 where muni_id is null;
update connec set muni_id = 0 where muni_id is null;
update link set muni_id = 0 where muni_id is null;

ALTER TABLE arc alter column muni_id set NOT NULL;
ALTER TABLE node alter column muni_id set NOT NULL;
ALTER TABLE connec alter column muni_id set NOT NULL;
ALTER TABLE link alter column muni_id set NOT NULL;

ALTER TABLE arc alter column muni_id set default 0;
ALTER TABLE node alter column muni_id set default 0;
ALTER TABLE connec alter column muni_id set default 0;
ALTER TABLE link alter column muni_id set default 0;

DROP RULE IF EXISTS dma_undefined ON dma;
DROP RULE IF EXISTS dma_conflict ON dma;
update dma set macrodma_id = 0 where macrodma_id is null;
ALTER TABLE dma alter column macrodma_id set default 0;
CREATE RULE dma_conflict AS ON UPDATE TO dma WHERE ((new.dma_id = -1) OR (old.dma_id = -1)) DO INSTEAD NOTHING;
CREATE RULE dma_undefined AS ON UPDATE TO dma WHERE ((new.dma_id = 0) OR (old.dma_id = 0)) DO INSTEAD NOTHING;;

update sector set macrosector_id = 0 where macrosector_id is null;
ALTER TABLE sector alter column macrosector_id set NOT NULL;
ALTER TABLE sector alter column macrosector_id set default 0;

update exploitation set macroexpl_id = 0 where macroexpl_id is null;
ALTER TABLE exploitation alter column macroexpl_id set NOT NULL;
ALTER TABLE exploitation alter column macroexpl_id set default 0;
