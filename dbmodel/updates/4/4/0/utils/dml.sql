/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_toolbox SET
alias = 'Arcs shorter/bigger than specific length',
inputparams = '[{"label": "Arc length shorter than:", "datatype": "string", "layoutname": "grl_option_parameters", "widgetname": "shorterThan", "widgettype": "text", "layoutorder": 1}, 
{"label": "Arc length bigger than:", "datatype": "string", "layoutname": "grl_option_parameters", "widgetname": "biggerThan", "widgettype": "text", "layoutorder": 2}]'
WHERE id = 3052;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) 
VALUES(4356, 'Cannot delete system mapzone with id: %id%', NULL, 2, true, 'utils', 'core', 'UI') ON CONFLICT (id) DO NOTHING;

-- 15/09/2025
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) 
VALUES(3514, 'gw_fct_cm_admin_manage_fields', 'utils', 'function', 'json', 'json', 'Funtion to auto-update cm views and tables to match their parent definitions.', 'role_admin', NULL, 'core', NULL);
UPDATE config_form_fields SET layoutorder = 1 WHERE formname ilike 've_arc%' AND formtype = 'form_feature' AND tabname = 'tab_data' AND columnname = 'sector_id' AND layoutname = 'lyt_bot_1';
UPDATE config_form_fields SET layoutorder = 2 WHERE formname ilike 've_arc%' AND formtype = 'form_feature' AND tabname = 'tab_data' AND columnname = 'omzone_id' AND layoutname = 'lyt_bot_1';

UPDATE config_typevalue
	SET idval='Set To Arc'
	WHERE typevalue='formactions_typevalue' AND id='actionSetToArc';