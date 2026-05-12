/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 24/02/2026
UPDATE sys_param_user
SET ismandatory=true
WHERE id='edit_statetype_1_vdefault' OR id='edit_statetype_2_vdefault';
