/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/16
CREATE OR REPLACE RULE insert_plan_arc_x_pavement AS ON INSERT TO arc DO INSERT INTO plan_arc_x_pavement (arc_id, pavcat_id, percent)
VALUES (new.arc_id, ((( SELECT config_param_user.value FROM config_param_user
WHERE config_param_user.parameter::text = 'edit_pavement_vdefault'::text AND config_param_user.cur_user::name = "current_user"() LIMIT 1))), '1'::numeric);
