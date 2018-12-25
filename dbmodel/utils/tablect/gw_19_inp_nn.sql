/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP
ALTER TABLE rpt_selector_result ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE rpt_selector_result ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE rpt_selector_compare ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE rpt_selector_compare ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE inp_selector_sector ALTER COLUMN sector_id DROP NOT NULL;
ALTER TABLE inp_selector_sector ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE inp_selector_result ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE inp_selector_result ALTER COLUMN cur_user DROP NOT NULL;

--SET
ALTER TABLE rpt_selector_result ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE rpt_selector_result ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE rpt_selector_compare ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE rpt_selector_compare ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE inp_selector_sector ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE inp_selector_sector ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE inp_selector_result ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE inp_selector_result ALTER COLUMN cur_user SET NOT NULL;



