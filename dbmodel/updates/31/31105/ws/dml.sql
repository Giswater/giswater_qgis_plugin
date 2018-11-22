/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2018/11/11
INSERT INTO audit_cat_param_user VALUES ('om_mincut_analysis_dminsector', 'om', 'Use mincut to analyze minsector in spite of standard mincut workflow', 'role_edit');
INSERT INTO audit_cat_param_user VALUES ('om_mincut_analysis_pipehazard', 'om', 'Use mincut to analyze pipehazard in spite of standard mincut workflow', 'role_plan');
INSERT INTO audit_cat_param_user VALUES ('om_mincut_analysis_dinletsector', 'om', 'Use mincut to analyze dynamic inlet sector in spite of standard mincut workflow', 'role_om');
INSERT INTO audit_cat_table VALUES ('anl_mincut_inlet_x_arc', 'om' 'Table to arcs as a inlets', role_admin, 0, NULL, NULL, 0, NULL, NULL, NULL);


--2018/11/12
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('om_mincut_valvestat_using_valveunaccess', 'FALSE', 'Boolean', 'Mincut', 'Variable to enable/disable the possibility to use valve unaccess button to open valves with closed status');
UPDATE audit_cat_table SET sys_role_id='role_om' WHERE id='man_valve'

--2018/11/20
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('om_mincut_debug', 'FALSE', 'Boolean', 'Mincut', 'Variable to enable/disable the debug messages of mincut');
UPDATE audit_cat_table SET sys_role_id='role_om' WHERE id='man_valve'
