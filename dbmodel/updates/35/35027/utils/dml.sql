/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/07/26

UPDATE sys_function SET project_type='utils' WHERE id=1346;

--2022/07/28

INSERT INTO config_param_system
("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('edit_custom_link', '{"google_maps":false}', 'Allow users to enable custom configurations to fill features ''link'' field', 'Custom link field', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'json', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

UPDATE config_param_system c
SET value=gw_fct_json_object_set_key(c.value::json,'fid',a.value) 
FROM (
SELECT value::boolean from config_param_system WHERE "parameter"='edit_feature_usefid_on_linkid'
)a
WHERE parameter = 'edit_custom_link';

DELETE FROM config_param_system WHERE "parameter"='edit_feature_usefid_on_linkid';

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (465, 'Check number of rows in a plan_price table', 'utils',null, 'core', true, 'Check plan-config',null) ON CONFLICT (fid) DO NOTHING;