/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 20/05/2026 cibs hydrometer schema refactor
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
