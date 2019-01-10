/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--DROP CONSTRAINT

ALTER TABLE rpt_selector_compare DROP CONSTRAINT IF EXISTS rpt_selector_compare_result_id_cur_user_unique ;

ALTER TABLE rpt_selector_hourly_compare DROP CONSTRAINT IF EXISTS time_compare_cur_user_unique;

DROP INDEX IF EXISTS shortcut_unique;

--ADD CONSTRAINT


ALTER TABLE rpt_selector_compare ADD CONSTRAINT rpt_selector_compare_result_id_cur_user_unique UNIQUE(result_id, cur_user);

ALTER TABLE rpt_selector_hourly_compare ADD CONSTRAINT time_compare_cur_user_unique UNIQUE("time", cur_user);

CREATE UNIQUE INDEX shortcut_unique ON cat_feature USING btree (shortcut_key COLLATE pg_catalog."default");
