/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 07/04/2020

INSERT INTO config_api_form_tabs (id, formname, tabname, label,  tooltip, sys_role) 
VALUES (710, 'exploitation', 'tabExploitation', 'Exploitation', 'Exploitation Selector', 'role_basic');

SELECT setval('config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, context,  descript, label, project_type, datatype, isdeprecated) 
VALUES ('api_selector_exploitation', '{"table":"exploitation", "selector":"selector_expl", "table_id":"expl_id",  "selector_id":"expl_id",  "label":"expl_id, '' - '', name, '' '', CASE WHEN descript IS NULL THEN '' ELSE concat('' - '', descript) END, ''"}', 'system', 'Select which label to display for selectors', 'Selector labels:', 'utils', 'json', FALSE);