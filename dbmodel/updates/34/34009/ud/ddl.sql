/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/09
ALTER TABLE rpt_selector_timestep_compare RENAME to selector_rpt_compare_tstep;
ALTER TABLE rpt_selector_timestep RENAME to selector_rpt_main_tstep;
ALTER TABLE inp_selector_hydrology RENAME to selector_inp_hydrology;


-- remove id from selectors
ALTER TABLE selector_inp_hydrology DROP CONSTRAINT IF EXISTS inp_selector_hydrology_hydrology_id_cur_user;
ALTER TABLE selector_inp_hydrology DROP CONSTRAINT IF EXISTS inp_selector_hydrology_pkey;
ALTER TABLE selector_inp_hydrology ADD CONSTRAINT selector_hydrology_pkey PRIMARY KEY(hydrology_id, cur_user);
ALTER TABLE selector_inp_hydrology DROP COLUMN id;

ALTER TABLE selector_rpt_compare DROP CONSTRAINT IF EXISTS rpt_selector_compare_result_id_cur_user_unique;
ALTER TABLE selector_rpt_compare DROP CONSTRAINT IF EXISTS rpt_selector_compare_pkey;
ALTER TABLE selector_rpt_compare ADD CONSTRAINT selector_rpt_compare_pkey PRIMARY KEY(result_id, cur_user);
ALTER TABLE selector_rpt_compare DROP COLUMN id;

ALTER TABLE selector_rpt_compare_tstep DROP CONSTRAINT IF EXISTS rpt_selector_timestep_compare_pkey;
ALTER TABLE selector_rpt_compare_tstep ADD CONSTRAINT selector_rpt_compare_tstep_pkey PRIMARY KEY(resultdate, resulttime, cur_user);
ALTER TABLE selector_rpt_compare_tstep DROP COLUMN id;

ALTER TABLE selector_rpt_main DROP CONSTRAINT IF EXISTS rpt_selector_result_id_cur_user_unique;
ALTER TABLE selector_rpt_main DROP CONSTRAINT IF EXISTS rpt_selector_result_pkey;
ALTER TABLE selector_rpt_main ADD CONSTRAINT selector_rpt_main_pkey PRIMARY KEY(result_id, cur_user);
ALTER TABLE selector_rpt_main DROP COLUMN id;

ALTER TABLE selector_rpt_main_tstep DROP CONSTRAINT IF EXISTS rpt_selector_timestep_pkey;
ALTER TABLE selector_rpt_main_tstep ADD CONSTRAINT selector_rpt_main_tstep_pkey PRIMARY KEY(resultdate, resulttime, cur_user);
ALTER TABLE selector_rpt_main_tstep DROP COLUMN id;
