/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 20110/02/05

INSERT INTO audit_cat_param_user VALUES ('dim_tooltip', 'config', 'If true, tooltip appears when you are selecting depth from another node with dimensioning tool', 'role_edit', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('cad_tools_base_layer_vdefault', 'config', 'Selected layer will be the only one which allow snapping with CAD tools', 'role_edit', NULL, NULL, NULL, NULL);



--2019/02/08
DELETE FROM audit_cat_param_user WHERE id='virtual_line_vdefault';
DELETE FROM audit_cat_param_user WHERE id='virtual_point_vdefault';
DELETE FROM audit_cat_param_user WHERE id='virtual_polygon_vdefault';
DELETE FROM audit_cat_param_user WHERE id='qgis_template_folder_path';


DELETE FROM config_param_user WHERE parameter='virtual_line_vdefault';
DELETE FROM config_param_user WHERE parameter='virtual_point_vdefault';
DELETE FROM config_param_user WHERE parameter='virtual_polygon_vdefault';
DELETE FROM config_param_user WHERE parameter='qgis_template_folder_path';


-- 2019/02/12
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('om_mincut_valvestat_using_valveunaccess', 'FALSE', 'Boolean', 'Mincut', 'Variable to enable/disable the possibility to use valve unaccess button to open valves with closed status (WS)');
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('om_mincut_debug', 'FALSE', 'Boolean', 'Mincut', 'Variable to enable/disable the debug messages of mincut (WS)');
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('epa_units_factor', 
'{"CFS":0, "GPM":0, "MGD":0, "CMS":1, "LPS":1000, "MLD":86.4}', 'json', 'Epa', 'Conversion factors of CRM flows in function of EPA units choosed by user');

