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

DROP RULE IF EXISTS undelete_gully ON gully;
CREATE OR REPLACE RULE undelete_gully AS ON DELETE TO gully WHERE old.undelete = true DO INSTEAD NOTHING;

DROP RULE IF EXISTS undelete_sector ON sector;
CREATE OR REPLACE RULE undelete_sector AS ON DELETE TO sector WHERE old.undelete = true DO INSTEAD NOTHING;

DROP RULE IF EXISTS undelete_cathment ON catchment;
CREATE OR REPLACE RULE undelete_cathment AS ON DELETE TO catchment WHERE old.undelete = true DO INSTEAD NOTHING;

DROP RULE IF EXISTS undelete_polygon ON polygon;
CREATE OR REPLACE RULE undelete_polygon AS ON DELETE TO polygon WHERE old.undelete = true DO INSTEAD NOTHING;

DROP RULE IF EXISTS undelete_dma ON dma;
CREATE OR REPLACE RULE undelete_dma AS ON DELETE TO dma WHERE old.undelete = true DO INSTEAD NOTHING;

DROP RULE IF EXISTS undelete_point ON point;
CREATE OR REPLACE RULE undelete_point AS ON DELETE TO point WHERE old.undelete = true DO INSTEAD NOTHING;