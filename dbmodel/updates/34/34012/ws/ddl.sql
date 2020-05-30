/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25
-- config_mincut_inlet
ALTER TABLE config_mincut_inlet RENAME config TO parameters;
ALTER TABLE config_mincut_inlet ADD COLUMN active boolean;
ALTER TABLE config_mincut_valve ADD COLUMN active boolean;
ALTER TABLE config_mincut_checkvalve ADD COLUMN active boolean;

-- tstep on selector
ALTER TABLE selector_rpt_compare_tstep RENAME time TO timestep;
ALTER TABLE selector_rpt_main_tstep RENAME time TO timestep;