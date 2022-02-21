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

DROP RULE IF EXISTS macroexploitation_undefined ON macroexploitation;
CREATE RULE macroexploitation_undefined AS ON UPDATE TO macroexploitation
WHERE NEW.macroexpl_id = 0 OR OLD.macroexpl_id = 0 DO INSTEAD NOTHING;

DROP RULE IF EXISTS macroexploitation_del_undefined ON macroexploitation;
CREATE RULE macroexploitation_del_undefined AS ON DELETE TO macroexploitation
WHERE OLD.macroexpl_id = 0 DO INSTEAD NOTHING;

DROP RULE IF EXISTS macrosector_undefined ON macrosector;
CREATE RULE macrosector_undefined AS ON UPDATE TO macrosector
WHERE NEW.macrosector_id = 0 OR OLD.macrosector_id = 0 DO INSTEAD NOTHING;

DROP RULE IF EXISTS macrosector_del_undefined ON macrosector;
CREATE RULE macrosector_del_undefined AS ON DELETE TO macrosector
WHERE OLD.macrosector_id = 0 DO INSTEAD NOTHING;

DROP RULE IF EXISTS macrodma_undefined ON macrodma;
CREATE RULE macrodma_undefined AS ON UPDATE TO macrodma
WHERE NEW.macrodma_id = 0 OR OLD.macrodma_id = 0 DO INSTEAD NOTHING;

DROP RULE IF EXISTS macrodma_del_undefined ON macrodma;
CREATE RULE macrodma_del_undefined AS ON DELETE TO macrodma
WHERE OLD.macrodma_id = 0 DO INSTEAD NOTHING;
