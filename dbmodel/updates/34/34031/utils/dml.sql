/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/02/11
INSERT INTO config_param_system VALUES ('edit_connect_autoupdate_dma', 'TRUE', 'If true, after connect to network, gully or connec will have the same dma as its pjoint. If false, this value won''t propagate', 'Connect autoupdate dma', NULL, NULL, FALSE, NULL, 'utils', NULL, NULL, 'boolean')
ON CONFLICT (parameter) DO NOTHING;


INSERT INTO sys_param_user(id, formname, descript, sys_role, label, isenabled, layoutorder, project_type, isparent, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, isdeprecated, vdefault)
VALUES ('plan_psector_force_delete', 'hidden', 'Force delete when feature is deleted from one psector and no more it appears on other psector',
'role_plan', 'Force delete planned feature', FALSE, NULL, 'utils', FALSE, FALSE, 'boolean', 'check', TRUE, NULL, NULL, FALSE, 
'true') ON CONFLICT (id) DO NOTHING;


