/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_param_system
("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('edit_connect_autoupdate_dma', 'TRUE', 'If true, after connect to network, gully or connec will have the same dma as its pjoint. If false, this value won''t propagate', 'Connect autoupdate dma', NULL, NULL, true, 14, 'utils', NULL, NULL, 'boolean', 'check', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_admin_other')
ON CONFLICT (parameter) DO NOTHING;
INSERT INTO config_param_system
("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('edit_connect_autoupdate_fluid', 'TRUE', 'If true, after inserting a link, gully or connec will have the same fluid as arc they are connected to. If false, this value won''t propagate', 'Connect autoupdate fluid', NULL, NULL, true, 15, 'utils', NULL, NULL, 'boolean', 'check', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_admin_other')
ON CONFLICT (parameter) DO NOTHING;
