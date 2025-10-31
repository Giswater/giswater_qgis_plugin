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

INSERT INTO config_typevalue (typevalue,id,idval,addparam)
VALUES ('sys_table_context','33','["MASTERPLAN", "REPOSITION VALUE"]','{"orderBy":33}'::json);

UPDATE sys_table SET context = '33' WHERE id = 'v_plan_arc' OR id = 'v_plan_node';
UPDATE sys_table SET alias = 'Arc reposition value' WHERE id = 'v_plan_arc';
UPDATE sys_table SET alias = 'Node reposition value' WHERE id = 'v_plan_node';

UPDATE sys_param_user SET feature_field_id = 'pavcat_id' WHERE id = 'edit_pavementcat_vdefault';

UPDATE config_form_fields
SET dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null AND ''LINK''=ANY(feature_type)) ) AND active IS TRUE'
WHERE formname='ve_link' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
