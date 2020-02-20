/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_update_workcat_geom ON gully;
DROP TRIGGER IF EXISTS gw_trg_update_workcat_geom ON connec;
DROP TRIGGER IF EXISTS gw_trg_update_workcat_geom ON node;
DROP TRIGGER IF EXISTS gw_trg_update_workcat_geom ON arc;

DROP FUNCTION IF EXISTS gw_fct_update_workcat_geom (text);
