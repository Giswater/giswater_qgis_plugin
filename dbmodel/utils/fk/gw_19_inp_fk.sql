/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP
ALTER TABLE rpt_selector_result DROP CONSTRAINT IF EXISTS rpt_selector_result_id_cur_user_unique;
ALTER TABLE rpt_selector_result DROP CONSTRAINT IF EXISTS "rpt_selector_result_id_fkey";

ALTER TABLE rpt_selector_compare DROP CONSTRAINT IF EXISTS  rpt_selector_compare_result_id_cur_user_unique;
ALTER TABLE rpt_selector_compare DROP CONSTRAINT IF EXISTS "rpt_selector_compare_id_fkey";

ALTER TABLE inp_selector_sector DROP CONSTRAINT IF EXISTS  inp_selector_sector_sector_id_cur_user_unique;
ALTER TABLE inp_selector_sector DROP CONSTRAINT IF EXISTS "inp_selector_sector_id_fkey";

ALTER TABLE inp_selector_result DROP CONSTRAINT IF EXISTS  inp_selector_result_result_id_cur_user_unique;
ALTER TABLE inp_selector_result DROP CONSTRAINT IF EXISTS "inp_selector_result_id_fkey";



--ADD
ALTER TABLE rpt_selector_result ADD CONSTRAINT rpt_selector_result_id_cur_user_unique UNIQUE(result_id, cur_user);
ALTER TABLE rpt_selector_result ADD CONSTRAINT "rpt_selector_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE rpt_selector_compare ADD CONSTRAINT rpt_selector_compare_result_id_cur_user_unique UNIQUE(result_id, cur_user);
ALTER TABLE rpt_selector_compare ADD CONSTRAINT "rpt_selector_compare_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_selector_sector ADD CONSTRAINT inp_selector_sector_sector_id_cur_user_unique UNIQUE(sector_id, cur_user);
ALTER TABLE inp_selector_sector ADD CONSTRAINT "inp_selector_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_selector_result ADD CONSTRAINT inp_selector_result_result_id_cur_user_unique UNIQUE(result_id, cur_user);
ALTER TABLE inp_selector_result ADD CONSTRAINT "inp_selector_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON UPDATE CASCADE ON DELETE CASCADE;

