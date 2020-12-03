/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/15/09
INSERT INTO sys_param_user(id, formname, descript, sys_role, label, isenabled, layoutorder, project_type, isparent, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, isdeprecated, vdefault)
VALUES ('edit_element_doublegeom', 'config', 'If value, overwrites trigger element value to create double geometry in case elementcat_id is defined with this attribute',
'role_edit', 'Doublegeometry value for element:', TRUE, 11, 'utils', FALSE, FALSE, 'boolean', 'check', FALSE, 'lyt_inventory',
TRUE, FALSE, 2) ON CONFLICT (id) DO NOTHING;
