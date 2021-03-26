/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/01/30
ALTER TABLE inp_flwreg_orifice ALTER COLUMN "offset" drop NOT NULL;

ALTER TABLE node DROP CONSTRAINT IF EXISTS node_epa_type_fkey ;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_epa_type_fkey ;