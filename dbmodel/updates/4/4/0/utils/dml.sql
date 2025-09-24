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
UPDATE config_form_fields SET layoutorder = 1 WHERE formname ilike 've_%' AND formtype = 'form_feature' AND tabname = 'tab_data' AND columnname = 'sector_id' AND layoutname = 'lyt_bot_1';
UPDATE config_form_fields SET layoutorder = 2 WHERE formname ilike 've_%' AND formtype = 'form_feature' AND tabname = 'tab_data' AND columnname = 'omzone_id' AND layoutname = 'lyt_bot_1';

UPDATE config_typevalue
	SET idval='Set To Arc'
	WHERE typevalue='formactions_typevalue' AND id='actionSetToArc';

-- 16/09/2025
UPDATE sys_message SET error_message = 'There are no arcs with outlayers values' WHERE id = 3570;
UPDATE sys_message SET error_message = 'There are %v_count% arcs with outlayers values' WHERE id = 3572;

-- 19/09/2025
UPDATE config_form_fields SET widgettype = 'text', iseditable = true WHERE formname = 've_sector' AND columnname = 'sector_id';

INSERT INTO sys_message (id, error_message, log_level, show_user, project_type, "source", message_type) 
VALUES(4358, 'It is not allowed to deactivate your current psector. Click on the Play button to exit psector mode and then, deactivate the psector.', 0, true, 'utils', 'core', 'UI');


UPDATE sys_fprocess SET query_text = '
SELECT * FROM (WITH 
	rgh as (SELECT min(roughness), max(roughness) FROM cat_mat_roughness),
	hdl as (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter=''inp_options_headloss'')
	SELECT 
		case when value = ''D-W'' and (min < 0.0025 or max > 0.15) then 1 
				when value = ''H-W'' and (min < 110 or max > 150) then 1
				when value = ''C-M'' and (min < 0.011 or max > 0.017) then 1
				else 0 END roughness
		from rgh, hdl) a WHERE roughness = 1' WHERE fid = 377;

UPDATE sys_fprocess SET query_text = '
SELECT a.arc_id FROM ve_arc a 
LEFT JOIN cat_arc b ON a.arccat_id = b.id
LEFT JOIN cat_mat_roughness c USING (matcat_id)
WHERE b.matcat_id IS NOT NULL AND c.roughness IS NULL' WHERE fid = 433;

-- 24/09/2025
UPDATE sys_fprocess 
SET except_msg='pumps with curve defined by 3 points found. Check if this 3-points has thresholds defined (133%) acording SWMM user''s manual'
WHERE fid=172;

-- 24/09/2025
UPDATE sys_param_user SET dv_isnullvalue=true WHERE id='inp_options_selecteddma';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) 
VALUES(4360, 'There is no dma selected. Please select one in the options', NULL, 0, true, 'utils', 'core', 'UI') ON CONFLICT (id) DO NOTHING;
