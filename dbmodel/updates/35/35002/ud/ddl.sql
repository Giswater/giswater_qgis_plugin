/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/12/14
ALTER TABLE cat_dwf_scenario ADD COLUMN active boolean;
ALTER TABLE cat_dwf_scenario ALTER COLUMN active SET DEFAULT TRUE;

ALTER TABLE cat_hydrology ADD COLUMN active boolean;
ALTER TABLE cat_hydrology ALTER COLUMN active SET DEFAULT TRUE;

ALTER TABLE cat_mat_grate ADD COLUMN active boolean;
ALTER TABLE cat_mat_grate ALTER COLUMN active SET DEFAULT TRUE;

ALTER TABLE cat_mat_gully ADD COLUMN active boolean;
ALTER TABLE cat_mat_gully ALTER COLUMN active SET DEFAULT TRUE;