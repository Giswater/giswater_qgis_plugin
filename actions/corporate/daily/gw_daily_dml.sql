/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



UPDATE config_param_system SET value='TRUE' WHERE parameter='sys_daily_updates';


INSERT INTO utils.config_param_system VALUES 
(1, 'daily_update_mails', '{"mails": [{"mail":"info@bgeo.es"},{"mail":"info@giswater.org"}]}', 'json', 'daily_update_mails', 'Daily update mails');
