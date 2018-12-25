/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

DROP RULE IF EXISTS undelete_exploitation ON exploitation;
CREATE OR REPLACE RULE undelete_dma AS ON DELETE TO exploitation WHERE old.undelete = true DO INSTEAD NOTHING;


DROP RULE IF EXISTS undelete_dma ON dma;
CREATE OR REPLACE RULE undelete_dma AS ON DELETE TO dma WHERE old.undelete = true DO INSTEAD NOTHING;


DROP RULE IF EXISTS undelete_sector ON sector;
CREATE OR REPLACE RULE undelete_sector AS ON DELETE TO sector WHERE old.undelete = true DO INSTEAD NOTHING;

DROP RULE IF EXISTS undelete_macrosector ON macrosector;
CREATE OR REPLACE RULE undelete_macrosector AS ON DELETE TO macrosector WHERE old.undelete = true DO INSTEAD NOTHING;

