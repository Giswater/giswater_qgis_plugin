/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/25
UPDATE config_toolbox SET inputparams ='[{"widgetname":"action", "label":"Set topocontrol mode:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["TRUE","FALSE"],"comboNames":["MIGRATION","WORK"], "selectedId":"FALSE"}]'
where id = 3130;

INSERT INTO sys_param_user(id, formname, descript, sys_role, isenabled, project_type, isautoupdate, datatype, widgettype, ismandatory, dv_isnullvalue, source)
VALUES ('edit_disable_topocontrol', 'hidden', 'If true topocontrol and feature proximity is disabled to allow data migration',
'role_admin', true, 'utils', false, 'boolean', 'check', false, true,'core');

--2022/01/27
DELETE FROM sys_fprocess where fid in (333, 334, 335, 179);

--2022/01/31
ALTER TABLE plan_price DROP CONSTRAINT plan_price_unit_check;


