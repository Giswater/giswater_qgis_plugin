/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3270, 'You can''t create or update a document with an empty name. Please provide a valid name.', NULL, 2, true, 'utils', 'core');

UPDATE config_form_fields SET dv_querytext = 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL' WHERE columnname  = 'muni_id' AND widgettype = 'combo';

DO $$
DECLARE
    v_utils boolean;
BEGIN
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	 IF v_utils IS true THEN
        INSERT INTO utils.municipality VALUES (0, 'Undefined', NULL, NULL, true) ON CONFLICT DO NOTHING;
     ELSE
        INSERT INTO ext_municipality VALUES (0, 'Undefined', NULL, NULL, true) ON CONFLICT DO NOTHING;
	 END IF;
END; $$;

INSERT INTO selector_municipality SELECT DISTINCT 0, cur_user FROM selector_expl ON CONFLICT (muni_id, cur_user) DO NOTHING;
