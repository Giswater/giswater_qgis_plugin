/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--mandatory update on ddl to save value of editability, typeahead, reg_exp columns
UPDATE audit_cat_param_user SET isparent=True, editability='{"trueWhenParentIn":[11]}' WHERE id ='inp_options_pattern';-- (audit_cat_param_user)
UPDATE audit_cat_param_user SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols,'comboEnableWhenParent', editability->>'trueWhenParentIn') where editability is not null; --editability (enableWhenParent)
UPDATE audit_cat_param_user SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols,'regexpControl', reg_exp) where reg_exp is not null; --reg_exp

-- drop fields
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"audit_cat_param_user", "column":"editability"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"audit_cat_param_user", "column":"typeahead"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"audit_cat_param_user", "column":"reg_exp"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"audit_cat_param_user", "column":"qgis_message"}}$$);



--2020/02/24
INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox,isparametric)
VALUES (2808, 'gw_trg_edit_config_addfields', 'utils','trigger function', 'Trigger to manage the editability of ve_config_addfields', 
'role_admin', FALSE, FALSE, FALSE) ON CONFLICT (id) DO NOTHING;
