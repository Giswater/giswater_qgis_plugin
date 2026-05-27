/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS ve_rtc_hydro_data_x_connec;
DROP VIEW IF EXISTS v_ui_hydroval_x_connec;
DROP VIEW IF EXISTS v_ui_hydroval;
DROP VIEW IF EXISTS v_ui_hydrometer;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_connec;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_node;
DROP VIEW IF EXISTS v_rtc_hydrometer;
DROP VIEW IF EXISTS vf_hydrometer;
DROP VIEW IF EXISTS ve_hydrometer_data;
DROP VIEW IF EXISTS v_hydrometer_data;
DROP VIEW IF EXISTS v_hydrometer;
DROP VIEW IF EXISTS v_cat_hydrometer_state;
DROP VIEW IF EXISTS v_cat_hydrometer_category;
DROP VIEW IF EXISTS v_cat_hydrometer_priority;
DROP VIEW IF EXISTS v_cat_hydrometer_type;
DROP VIEW IF EXISTS v_cat_hydrometer_category_x_pattern;

INSERT INTO config_param_system VALUES ('admin_cibs_schema', 'FALSE', 'Variable to check if cibs schema exists', 'cibs schema:', NULL, NULL, true, 11, 'utils', NULL, NULL, 'boolean', 'check', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_system');

ALTER TABLE IF EXISTS ext_rtc_hydrometer_x_data DROP CONSTRAINT IF EXISTS ext_rtc_hydrometer_x_data_hydrometer_id_fkey;
ALTER TABLE IF EXISTS om_mincut_hydrometer DROP CONSTRAINT IF EXISTS om_mincut_hydrometer_hydrometer_id_fkey;

ALTER TABLE IF EXISTS ext_rtc_hydrometer RENAME TO ext_hydrometer;
ALTER TABLE IF EXISTS ext_rtc_hydrometer_x_data RENAME TO ext_hydrometer_data;
ALTER TABLE IF EXISTS ext_hydrometer_category RENAME TO ext_cat_hydrometer_category;
ALTER TABLE IF EXISTS ext_rtc_hydrometer_state RENAME TO ext_cat_hydrometer_state;

ALTER SEQUENCE IF EXISTS ext_rtc_hydrometer_hydrometer_id_seq RENAME TO ext_hydrometer_hydrometer_id_seq;
ALTER SEQUENCE IF EXISTS ext_rtc_hydrometer_x_data_seq RENAME TO ext_hydrometer_data_id_seq;

DELETE FROM sys_table WHERE id IN
('v_rtc_hydrometer', 'v_rtc_hydrometer_x_connec', 'v_rtc_hydrometer_x_node', 'v_ui_hydroval', 'v_ui_hydroval_x_connec', 'v_ui_hydrometer', 've_rtc_hydro_data_x_connec',
'ext_rtc_hydrometer', 'ext_rtc_hydrometer_x_data', 'ext_rtc_hydrometer_state', 'ext_hydrometer_category');

INSERT INTO sys_table (id, descript, sys_role, source)
VALUES
    ('ext_hydrometer', 'Hydrometer table.', 'role_basic', 'core'),
    ('ext_hydrometer_data', 'Hydrometer data table.', 'role_basic', 'core'),
    ('ext_cat_hydrometer_state', 'Hydrometer state catalog table.', 'role_basic', 'core'),
    ('ext_cat_hydrometer_category', 'Hydrometer category catalog table.', 'role_basic', 'core'),
    ('ext_cat_hydrometer_priority', 'Hydrometer priority catalog table.', 'role_basic', 'core'),
    ('ext_cat_hydrometer_type', 'Hydrometer type catalog table.', 'role_basic', 'core'),
    ('ext_cat_hydrometer_category_x_pattern', 'Hydrometer category x pattern catalog table.', 'role_basic', 'core'),
    ('vf_hydrometer', 'Hydrometers filtered by exploitation selector.', 'role_basic', 'core'),
    ('ve_hydrometer_data', 'Editable hydrometer period data without connec join.', 'role_basic', 'core'),
    ('v_hydrometer', 'Hydrometer base view.', 'role_basic', 'core'),
    ('v_hydrometer_data', 'Hydrometer period data base view.', 'role_basic', 'core'),
    ('v_cat_hydrometer', 'Hydrometer catalog base view.', 'role_basic', 'core'),
    ('v_cat_hydrometer_state', 'Hydrometer state base view.', 'role_basic', 'core'),
    ('v_cat_hydrometer_category', 'Hydrometer category base view.', 'role_basic', 'core'),
    ('v_cat_hydrometer_priority', 'Hydrometer priority base view.', 'role_basic', 'core'),
    ('v_cat_hydrometer_type', 'Hydrometer type base view.', 'role_basic', 'core'),
    ('v_cat_hydrometer_category_x_pattern', 'Hydrometer category x pattern base view.', 'role_basic', 'core')
ON CONFLICT (id) DO UPDATE SET descript = EXCLUDED.descript;

ALTER TABLE ext_hydrometer ADD CONSTRAINT ext_hydrometer_ext_cat_hydrometer_state_fk FOREIGN KEY (state_id) REFERENCES ext_cat_hydrometer_state(id);
ALTER TABLE ext_hydrometer ADD CONSTRAINT ext_hydrometer_ext_cat_hydrometer_priority_fk FOREIGN KEY (priority_id) REFERENCES ext_cat_hydrometer_priority(id);
