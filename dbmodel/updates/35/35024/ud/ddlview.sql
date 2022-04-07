/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/02
CREATE OR REPLACE VIEW v_edit_inp_coverage AS 
SELECT subc_id,
landus_id,
percent,
c.hydrology_id
FROM selector_sector, config_param_user,inp_coverage c
JOIN inp_subcatchment s USING (subc_id)
WHERE s.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
AND c.hydrology_id = config_param_user.value::integer AND config_param_user.cur_user::text = "current_user"()::text AND
config_param_user.parameter::text = 'inp_options_hydrology_scenario'::text;
