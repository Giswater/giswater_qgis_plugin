/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (124,'Go2epa-temporal nodarcs','ws', 'epa') ON CONFLICT (id) DO NOTHING;

UPDATE audit_cat_function set function_name = 'gw_fct_pg2epa_demand' where function_name = 'gw_fct_pg2epa_rtc';

INSERT INTO audit_cat_function VALUES (2846, 'gw_fct_pg2epa_vdefault', 'ws', 'Default values for epanet', NULL, NULL, NULL, 'Default values for epanet', 'role_epa', false) 
ON CONFLICT (id) DO NOTHING;