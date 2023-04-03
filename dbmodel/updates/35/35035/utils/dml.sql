/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source") 
VALUES('edit_workcat_id_plan', 'config', 'Default value of workcat id plan', 'role_edit', NULL, 'Workcat id plan:', 'SELECT cat_work.id AS id,cat_work.id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE ', NULL, true, 25, 'utils', false, NULL, 'workcat_id_plan', NULL, false, 'string', 'combo', false, NULL, NULL, 'lyt_inventory', true, NULL, NULL, NULL, NULL, 'core');