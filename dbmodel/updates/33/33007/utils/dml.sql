/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/10/2019
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_rtc_hydrometer_x_connec';

-- harmonize context for pivot tables (in case those have been changed to 'view from external schema' nothing will change here
UPDATE audit_cat_table SET context='table to external'  WHERE context IN ('external table','ext','Streeter');

UPDATE config_param_user SET parameter = 'qgis_composers_path' WHERE parameter = 'composers_path';

INSERT INTO audit_cat_param_user VALUES 
('qgis_composers_path', 'dynamic_param', 'Value of the composers path for user', 'role_basic', NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, 'utils', false, NULL, NULL, NULL, 
false, 'string', 'combo', true, NULL, 'C:/Users/Usuari/AppData/Roaming/QGIS/QGIS3/profiles/default/python/plugins/giswater/templates/qgiscomposer/en', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;

INSERT INTO audit_cat_param_user VALUES 
('qgis_toolbar_hidebuttons', 'hidden_param', 'Buttons to be disabled for user', 'role_basic', NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, 'utils', false, NULL, NULL, NULL, 
false, 'string', 'combo', true, NULL, '{"action_index":[199,74,75,76]}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false)
ON conflict (id) DO NOTHING;

UPDATE audit_cat_param_user SET formname='dynamic_param' WHERE id='epaverion';
UPDATE audit_cat_param_user SET formname='config' WHERE id='edit_connect_force_downgrade_linkvnode';