/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 20/05/2026 cibs hydrometer schema refactor
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
