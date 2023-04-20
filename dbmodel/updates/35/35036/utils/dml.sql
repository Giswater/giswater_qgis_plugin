/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM config_form_tableview where tablename in('v_edit_plan_psector_x_connec', 'v_edit_plan_psector_x_gully') and columnindex in(7,8);
UPDATE config_form_tableview SET visible = true where columnindex = 7 and tablename in('v_edit_plan_psector_x_connec', 'v_edit_plan_psector_x_gully');
UPDATE config_form_tableview SET visible = false, columnindex = 8 where columnname = 'active' and tablename in('v_edit_plan_psector_x_connec', 'v_edit_plan_psector_x_gully');
UPDATE config_form_tableview SET visible = false, columnindex = 9 where columnname = 'insert_tstamp' and tablename in('v_edit_plan_psector_x_connec', 'v_edit_plan_psector_x_gully');
UPDATE config_form_tableview SET visible = false, columnindex = 10 where columnname = 'insert_user' and tablename in('v_edit_plan_psector_x_connec', 'v_edit_plan_psector_x_gully');
