/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 29/05/2024
ALTER TABLE cat_manager RENAME COLUMN username TO rolename;
ALTER TABLE config_user_x_expl DROP CONSTRAINT config_user_x_expl_username_fkey;
ALTER TABLE config_user_x_sector DROP CONSTRAINT config_user_x_sector_username_fkey;

ALTER TABLE config_user_x_sector DROP CONSTRAINT config_user_x_sector_manager_id_fkey;
ALTER TABLE config_user_x_sector ADD CONSTRAINT config_user_x_sector_manager_id_fkey 
FOREIGN KEY (manager_id) REFERENCES cat_manager(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE config_user_x_expl DROP CONSTRAINT config_user_x_expl_manager_id_fkey;
ALTER TABLE config_user_x_expl ADD CONSTRAINT config_user_x_expl_manager_id_fkey 
FOREIGN KEY (manager_id) REFERENCES cat_manager(id) ON DELETE CASCADE ON UPDATE CASCADE;
