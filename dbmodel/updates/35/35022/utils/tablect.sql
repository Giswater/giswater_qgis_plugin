/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/02/18
DROP RULE IF EXISTS sector_undefined ON sector;
CREATE RULE sector_undefined AS ON UPDATE TO sector
WHERE NEW.sector_id = 0 OR OLD.sector_id = 0 DO INSTEAD NOTHING;

DROP RULE IF EXISTS sector_del_undefined ON sector;
CREATE RULE sector_del_undefined AS ON DELETE TO sector
WHERE OLD.sector_id = 0 DO INSTEAD NOTHING;

DROP RULE IF EXISTS sector_conflict ON sector;
CREATE RULE sector_conflict AS ON UPDATE TO sector
WHERE NEW.sector_id = -1 OR OLD.sector_id = -1 DO INSTEAD NOTHING;

DROP RULE IF EXISTS sector_del_conflict ON sector;
CREATE RULE sector_del_conflict AS ON DELETE TO sector
WHERE OLD.sector_id = -1 DO INSTEAD NOTHING;

DROP RULE IF EXISTS dma_undefined ON dma;
CREATE RULE dma_undefined AS ON UPDATE TO dma
WHERE NEW.dma_id = 0 OR OLD.dma_id = 0 DO INSTEAD NOTHING;

DROP RULE IF EXISTS dma_del_undefined ON dma;
CREATE RULE dma_del_undefined AS ON DELETE TO dma
WHERE OLD.dma_id = 0 DO INSTEAD NOTHING;

DROP RULE IF EXISTS dma_conflict ON dma;
CREATE RULE dma_conflict AS ON UPDATE TO dma
WHERE NEW.dma_id = -1 OR OLD.dma_id = -1 DO INSTEAD NOTHING;

DROP RULE IF EXISTS dma_del_conflict ON dma;
CREATE RULE dma_del_conflict AS ON DELETE TO dma
WHERE OLD.dma_id = -1 DO INSTEAD NOTHING;

DROP RULE IF EXISTS exploitation_undefined ON exploitation;
CREATE RULE exploitation_undefined AS ON UPDATE TO exploitation
WHERE NEW.expl_id = 0 OR OLD.expl_id = 0 DO INSTEAD NOTHING;

DROP RULE IF EXISTS exploitation_del_undefined ON exploitation;
CREATE RULE exploitation_del_undefined AS ON DELETE TO exploitation
WHERE OLD.expl_id = 0 DO INSTEAD NOTHING;
