/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/08/03
UPDATE config_form_fields SET widgettype = 'typeahead',
dv_querytext = 'SELECT id, id as idval FROM cat_grate WHERE id IS NOT NULL' FROM cat_feature WHERE 
system_id = 'NETGULLY' AND formname = child_layer and columnname = 'gratecat_id';

INSERT INTO sys_param_user(id, formname, descript, sys_role, label, isenabled, layoutorder, project_type, isparent, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, isdeprecated, vdefault)
VALUES ('edit_element_doublegeom', 'config', 'If value, overwrites trigger element value to create double geometry in case elementcat_id is defined with this attribute',
'role_edit', 'Doublegeometry value for element:', TRUE, 12, 'utils', FALSE, FALSE, 'boolean', 'check', FALSE, 'lyt_inventory',
TRUE, FALSE, 2) ON CONFLICT (id) DO NOTHING;

-- re-creation of child
SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "multi_create":"True" }}$$);



