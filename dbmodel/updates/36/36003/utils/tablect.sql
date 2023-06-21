/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP RULE IF EXISTS undelete_dma ON exploitation;
DROP RULE IF EXISTS undelete_exploitation ON exploitation;
CREATE RULE undelete_exploitation AS
ON DELETE TO exploitation
WHERE (old.undelete = true) DO INSTEAD NOTHING;


DROP RULE IF EXISTS undelete_dma ON macrodma;
DROP RULE IF EXISTS undelete_macrodma ON macrodma;
CREATE RULE undelete_macrodma AS
ON DELETE TO macrodma
WHERE (old.undelete = true) DO INSTEAD NOTHING;
