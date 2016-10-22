/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE OR REPLACE RULE undelete_node AS ON DELETE TO node WHERE old.undelete = true DO INSTEAD NOTHING;
CREATE OR REPLACE RULE undelete_arc AS ON DELETE TO arc WHERE old.undelete = true DO INSTEAD NOTHING;
CREATE OR REPLACE RULE undelete_connec AS ON DELETE TO connec WHERE old.undelete = true DO INSTEAD NOTHING;
CREATE OR REPLACE RULE undelete_sector AS ON DELETE TO sector WHERE old.undelete = true DO INSTEAD NOTHING;
CREATE OR REPLACE RULE undelete_dma AS ON DELETE TO dma WHERE old.undelete = true DO INSTEAD NOTHING;
CREATE OR REPLACE RULE undelete_presszone AS ON DELETE TO presszone WHERE old.undelete = true DO INSTEAD NOTHING;
CREATE OR REPLACE RULE undelete_point AS ON DELETE TO point WHERE old.undelete = true DO INSTEAD NOTHING;