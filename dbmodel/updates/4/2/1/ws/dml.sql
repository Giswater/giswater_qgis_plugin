/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_feature_class SET epa_default = 'UNDEFINED' WHERE type IN ('ELEMENT','CONNEC');

UPDATE sys_function SET function_name = 'gw_fct_pg2epa_flwreg2arc', descript = 'This functions transform flwreg elements to arcs.' WHERE id = 2318;

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES('epa_toolbar', 'utils', 'v_ui_rpt_cat_result', 'dma_id', (SELECT MAX(columnindex) FROM config_form_tableview WHERE location_type = 'epa_toolbar' AND project_type = 'utils' AND objectname = 'v_ui_rpt_cat_result'), true, NULL, 'dma_id', NULL, NULL);
