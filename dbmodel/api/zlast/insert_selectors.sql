
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET SEARCH_PATH='SCHEMA_NAME';

--qgisserver
INSERT INTO selector_state (state_id, cur_user)
SELECT id, 'qgisserver' from value_state;



INSERT INTO selector_expl (expl_id, cur_user)
SELECT expl_id, 'qgisserver' from exploitation

