/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") VALUES(3256, 'It is not possible to upgrade the arc to state planified because it has operative gullies associated', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") VALUES(3254, 'It is not possible to upgrade the arc to state planified because it has operative connecs associated', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") VALUES(3252, 'It is not possible to upgrade the arc to state planified because node has operative arcs associated', NULL, 2, true, 'utils', 'core');

