/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_message SET log_level = 2 WHERE id = 4432;

-- 29/10/2025
UPDATE config_form_fields
SET dv_querytext='SELECT r.result_id AS id, r.result_id AS idval FROM rpt_cat_result r JOIN v_ui_rpt_cat_result vr ON vr.result_id = r.result_id WHERE r.status = 2'
WHERE formname='generic' AND formtype='epa_selector' AND columnname='result_name_compare' AND tabname='tab_result';

UPDATE config_form_fields
SET dv_querytext='SELECT r.result_id AS id, r.result_id AS idval FROM rpt_cat_result r JOIN v_ui_rpt_cat_result vr ON vr.result_id = r.result_id WHERE r.status = 2'
WHERE formname='generic' AND formtype='epa_selector' AND columnname='result_name_show' AND tabname='tab_result';

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) 
VALUES(3518, 'gw_fct_getfeatureproperties', 'utils', 'function', 'json', 'json', 'Function to get the properties of a feature.', NULL, NULL, 'core', NULL);
