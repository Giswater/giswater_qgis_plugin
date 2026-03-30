/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/03/2026
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) 
VALUES('inp_typevalue_dscenario', 'PATTERN', 'PATTERN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO config_function (id, function_name, "style", layermanager, actions) VALUES(3536, 'gw_fct_getmincutminsector', '{
  "style": {
    "Valves": {
      "style": "categorized",
      "field": "closed",
      "width": 2,
      "transparency": 0.5
    },
    "Arcs": {
      "style": "categorized",
      "field": "minsector_id",
      "width": 2,
      "transparency": 0.5
    },
    "Connecs": {
      "style": "categorized",
      "field": "minsector_id",
      "width": 2,
      "transparency": 0.5
    }
  }
}'::json, NULL, NULL);

-- 24/03/2026
UPDATE sys_function SET function_alias = 'MACROMAPZONES DYNAMIC SECTORITZATION' WHERE id = 3482;


INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_municipality', 'View of town cities and villages', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_streetaxis', 'View of streetaxis', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_address', 'View of entrance numbers', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_plot', 'View of urban properties', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_raster_dem', 'View to store raster DEM', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_district', 'View of districts', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_region', 'View of regions', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_province', 'View of provinces', 'role_edit', 'core');

-- 26/03/2026
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) 
VALUES('inp_typevalue_dscenario', 'CALIBRATION', 'CALIBRATION', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;


UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM cat_element WHERE active IS true'
WHERE formname = 've_element' AND columnname = 'elementcat_id';

UPDATE config_form_tabs SET tooltip='State' WHERE formname='selector_basic' AND tabname='tab_network_state';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4610, 'Mincut has overlapping conflicts', NULL, 1, true, 'ws', 'core', 'UI') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4612, 'Mincut to cancel not found', NULL, 1, true, 'ws', 'core', 'UI') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4614, 'Mincut to delete not found', NULL, 1, true, 'ws', 'core', 'UI') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4616, 'Mincut deleted', NULL, 0, true, 'ws', 'core', 'UI') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4618, 'Node not operative not found', NULL, 2, true, 'ws', 'core', 'UI') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4620, 'You MUST execute the minsector analysis before executing the mincut analysis with 6.1 version.', NULL, 3, true, 'ws', 'core', 'UI') ON CONFLICT DO NOTHING;

UPDATE config_form_fields SET dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE ((featurecat_id is null OR ''ELEMENT''=ANY(feature_type))) AND active IS TRUE' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE ((featurecat_id is null OR ''ARC''=ANY(feature_type)) ) AND active IS TRUE' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE ((featurecat_id is null OR ''CONNEC''=ANY(feature_type)) ) AND active IS TRUE' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE ((featurecat_id is null OR ''NODE''=ANY(feature_type)) ) AND active IS TRUE' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';

UPDATE config_form_fields SET dv_querytext='SELECT category_type as id, category_type as idval FROM man_type_category WHERE ((featurecat_id is null OR ''ARC''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type as id, category_type as idval FROM man_type_category WHERE ((featurecat_id is null OR ''CONNEC''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type as id, category_type as idval FROM man_type_category WHERE ((featurecat_id is null OR ''ELEMENT''=ANY(feature_type))) AND active IS TRUE' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type as id, category_type as idval FROM man_type_category WHERE ((featurecat_id is null OR ''NODE''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';

UPDATE config_form_fields SET dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null OR ''ARC''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null OR ''CONNEC''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null OR ''ELEMENT''=ANY(feature_type))) AND active IS TRUE' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null OR ''NODE''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';

-- 30/03/2026
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4622, 'You MUST select “current_psector” to perform this action', NULL, 2, true, 'utils', 'core', 'UI') ON CONFLICT DO NOTHING;

INSERT INTO sys_message
(id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4624, 'There are values not allowed in the field ''%alias%'' (%column%) of the table ''%table%''', NULL, 0, true, 'utils', 'core', 'AUDIT');
