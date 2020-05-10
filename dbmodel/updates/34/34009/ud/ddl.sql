/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/09
ALTER TABLE rpt_selector_timestep_compare RENAME to selector_rpt_compare_tstep ;
ALTER TABLE rpt_selector_timestep RENAME to selector_rpt_main_tstep ;
ALTER TABLE inp_selector_hydrology RENAME to selector_inp_hydrology ;
