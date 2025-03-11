/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/11/20
ALTER TABLE IF EXISTS inp_valve RENAME diameter TO custom_dint;

-- 2020/03/12
ALTER TABLE config_mincut_checkvalve ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_mincut_inlet ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_mincut_valve ALTER COLUMN active SET DEFAULT TRUE;

