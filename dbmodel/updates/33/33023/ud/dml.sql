/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/01/10
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, csvversion) 
VALUES (80, 'rpt_control_actions_taken', 'Control Actions', '{"from":"5.0.022", "to":null,"language":"english"}';