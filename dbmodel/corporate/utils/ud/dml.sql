/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO utils.config_param_system(parameter, value, descript)
VALUES ('ud_current_schema', 'SCHEMA_NAME', 'Indicate the name for the UD schema');

UPDATE config_param_system SET value='TRUE' WHERE parameter='admin_utils_schema';