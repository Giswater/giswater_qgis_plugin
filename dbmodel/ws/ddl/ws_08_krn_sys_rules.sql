	/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

DROP RULE IF EXISTS undelete_node ON node;
CREATE OR REPLACE RULE undelete_node AS ON DELETE TO node WHERE old.undelete = true DO INSTEAD NOTHING;

DROP RULE IF EXISTS undelete_arc ON arc;
CREATE OR REPLACE RULE undelete_arc AS ON DELETE TO arc WHERE old.undelete = true DO INSTEAD NOTHING;

DROP RULE IF EXISTS undelete_connec ON connec;
CREATE OR REPLACE RULE undelete_connec AS ON DELETE TO connec WHERE old.undelete = true DO INSTEAD NOTHING;
