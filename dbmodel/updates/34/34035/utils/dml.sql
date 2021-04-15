/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/04/15
UPDATE config_form_tabs SET orderby = 1 WHERE formname = 'search' AND tabname = 'tab_network' AND orderby IS NULL;
UPDATE config_form_tabs SET orderby = 2 WHERE formname = 'search' AND tabname = 'tab_add_network' AND orderby IS NULL;
UPDATE config_form_tabs SET orderby = 3 WHERE formname = 'search' AND tabname = 'tab_address' AND orderby IS NULL;
UPDATE config_form_tabs SET orderby = 4 WHERE formname = 'search' AND tabname = 'tab_hydro' AND orderby IS NULL;
UPDATE config_form_tabs SET orderby = 5 WHERE formname = 'search' AND tabname = 'tab_workcat' AND orderby IS NULL;
INSERT INTO config_form_tabs(formname, tabname, label, tooltip, sys_role, tabfunction, tabactions, device, orderby)
VALUES ('search', 'tab_visit', 'Visit', 'Visit', 'role_basic', NULL, NULL, 4, 6) 
ON CONFLICT (formname, tabname, device) DO UPDATE set orderby= 6 where config_form_tabs.orderby is null;
UPDATE config_form_tabs SET orderby = 7  WHERE formname = 'search' AND tabname = 'tab_psector' AND orderby IS NULL;