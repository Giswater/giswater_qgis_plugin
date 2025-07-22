/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

update sys_table set sys_role = 'role_basic' where id = 'cat_users';

DELETE FROM config_param_system WHERE parameter = 'basic_selector_options';
