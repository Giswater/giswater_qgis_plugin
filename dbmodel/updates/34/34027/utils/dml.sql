/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/01/20
INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3172, 'Value inserted into field featurecat_id is not defined in a table cat_feature', 'Please check it before continue', 2, TRUE, 'utils') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_param_system(parameter, value, descript, label, dv_querytext, dv_filterbyfield, 
isenabled, layoutorder, project_type, dv_isparent, isautoupdate, datatype, widgettype, ismandatory, iseditable, layoutname)
VALUES ('edit_feature_auto_builtdate', TRUE, 'If true builtdate is set to the current date', 'Current date as builtdate', null, null, 
TRUE, 6, 'utils', FALSE, FALSE, 'boolean', 'check', FALSE, TRUE, 'lyt_system') ON CONFLICT (parameter) DO NOTHING;
            
UPDATE config_param_system SET layoutorder=8 where parameter='admin_currency';

UPDATE config_form_fields SET dv_parent_id = null, dv_querytext_filterc = null where formtype =  'form_catalog' and columnname = 'matcat_id';

UPDATE cat_feature SET parent_layer = 'v_edit_node' WHERE id  IN ('CLORINATHOR', 'CLORADOR', 'RECLORADOR') AND parent_layer IS NULL;

