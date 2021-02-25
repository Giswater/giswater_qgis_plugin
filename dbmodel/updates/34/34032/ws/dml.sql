/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/02/22
UPDATE config_param_user SET value = 'NO' WHERE parameter  ='inp_report_f_factor';
UPDATE sys_param_user SET vdefault = 'NO' WHERE id  ='inp_report_f_factor';
UPDATE config_form_tableview SET status = TRUE WHERE tablename  ='v_ui_rpt_cat_result' AND columnname = 'id';