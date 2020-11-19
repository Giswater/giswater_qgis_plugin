/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/05/24
ALTER TABLE exploitation_x_user DROP CONSTRAINT IF EXISTS exploitation_x_user_pkey;
ALTER TABLE exploitation_x_user ADD CONSTRAINT exploitation_x_user_pkey PRIMARY KEY(expl_id, username);
ALTER TABLE exploitation_x_user DROP CONSTRAINT IF EXISTS exploitation_x_user_expl_username_unique;
ALTER TABLE exploitation_x_user DROP COLUMN id;
ALTER TABLE exploitation_x_user RENAME to config_user_x_expl;

ALTER TABLE sys_message DROP COLUMN message_type;

ALTER TABLE audit_arc_traceability RENAME COLUMN "user" to cur_user;
