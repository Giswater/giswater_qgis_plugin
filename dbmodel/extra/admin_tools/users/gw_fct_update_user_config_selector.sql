/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path='SCHEMA_NAME';

INSERT INTO config_param_user (parameter, value, cur_user) 
SELECT parameter, value, 'user_name' FROM config_param_user WHERE cur_user='postgres';

INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, 'user_name' FROM selector_expl WHERE cur_user='postgres';
INSERT INTO selector_psector (psector_id, cur_user) SELECT psector_id, 'user_name' FROM selector_psector WHERE cur_user='postgres';
INSERT INTO selector_state (state_id, cur_user) SELECT state_id, 'user_name' FROM selector_state WHERE cur_user='postgres';
INSERT INTO inp_selector_sector (sector_id, cur_user) SELECT sector_id, 'user_name' FROM inp_selector_sector WHERE cur_user='postgres';


--UD
INSERT INTO inp_selector_hydrology (hydrology_id, cur_user) SELECT hydrology_id, 'user_name' FROM inp_selector_hydrology WHERE cur_user='postgres';


--WS
