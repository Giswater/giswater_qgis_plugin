/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4634, 'The following mapzones have no nodeParent: %feature_list%', 'Check for nulls in graphconfigs', 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4636, 'There are no mapzones with no nodeParent', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT DO NOTHING;
