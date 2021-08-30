/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/08/30
ALTER TABLE selector_inp_result ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_plan_psector ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_plan_result ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_rpt_compare ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_rpt_compare_tstep ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_rpt_main ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_rpt_main_tstep ALTER COLUMN cur_user SET DEFAULT "current_user"();
ALTER TABLE selector_sector ALTER COLUMN cur_user SET DEFAULT "current_user"();
