/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_hydrometer AS
SELECT * FROM ext_hydrometer;

CREATE OR REPLACE VIEW v_hydrometer_data AS
SELECT * FROM ext_hydrometer_data;

CREATE OR REPLACE VIEW vf_hydrometer AS
WITH sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT
    v_hydrometer.hydrometer_id,
    v_hydrometer.code AS hydrometer_customer_code,
    connec.connec_id AS feature_id,
    'CONNEC'::text AS feature_type,
    COALESCE(
        v_hydrometer.customer_code,
        'XXXX'::character varying
    ) AS customer_code,
    cat_hydrometer_state.name AS state,
    v_municipality.name AS muni_name,
    connec.expl_id,
    exploitation.name AS expl_name,
    v_hydrometer.plot_code,
    v_hydrometer.priority_id,
    v_hydrometer.catalog_id,
    v_hydrometer.category_id,
    v_hydrometer.hydro_number,
    v_hydrometer.hydro_man_date,
    v_hydrometer.crm_number,
    v_hydrometer.customer_name,
    v_hydrometer.address1,
    v_hydrometer.address2,
    v_hydrometer.address3,
    v_hydrometer.address2_1,
    v_hydrometer.address2_2,
    v_hydrometer.address2_3,
    v_hydrometer.m3_volume,
    v_hydrometer.start_date,
    v_hydrometer.end_date,
    v_hydrometer.update_date,
    concat(
        COALESCE(
            (SELECT config_param_system.value
            FROM config_param_system
            WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)
            , ''
        ),
        v_hydrometer.link
    ) AS hydrometer_link,
    cat_hydrometer_state.is_operative,
    v_hydrometer.shutdown_date
FROM v_hydrometer
    JOIN ext_cat_hydrometer_state ON cat_hydrometer_state.id = v_hydrometer.state_id
    JOIN connec ON connec.customer_code::text = v_hydrometer.customer_code::text
    LEFT JOIN v_municipality ON v_municipality.muni_id = connec.muni_id
    LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
WHERE EXISTS (
    SELECT 1
    FROM sel_expl
    WHERE sel_expl.expl_id = connec.expl_id
);

CREATE OR REPLACE VIEW ve_hydrometer_data AS
SELECT v_hydrometer_data.id,
    connec.connec_id AS feature_id,
    v_hydrometer_data.hydrometer_id,
    v_hydrometer.code,
    v_hydrometer.catalog_id,
    v_hydrometer_data.cat_period_id,
    ext_cat_period.code AS cat_period_code,
    v_hydrometer_data.value_date,
    v_hydrometer_data.sum,
    v_hydrometer_data.custom_sum,
    'CONNEC'::text AS feature_type
FROM v_hydrometer_data
    JOIN v_hydrometer ON v_hydrometer_data.hydrometer_id::bigint = v_hydrometer.hydrometer_id::bigint
    LEFT JOIN ext_cat_hydrometer ON cat_hydrometer.id::bigint = v_hydrometer.catalog_id::bigint
    JOIN connec ON connec.customer_code::text = v_hydrometer.customer_code::text
    JOIN ext_cat_period ON v_hydrometer_data.cat_period_id::text = ext_cat_period.id::text
ORDER BY v_hydrometer_data.hydrometer_id, v_hydrometer_data.cat_period_id DESC;

CREATE OR REPLACE VIEW v_cat_hydrometer AS
SELECT * FROM ext_cat_hydrometer;

CREATE OR REPLACE VIEW v_cat_hydrometer_state AS
SELECT * FROM ext_cat_hydrometer_state;

CREATE OR REPLACE VIEW v_cat_hydrometer_priority AS
SELECT * FROM ext_cat_hydrometer_priority;

CREATE OR REPLACE VIEW v_cat_hydrometer_type AS
SELECT * FROM ext_cat_hydrometer_type;

CREATE OR REPLACE VIEW v_cat_hydrometer_category AS
SELECT * FROM ext_cat_hydrometer_category;

UPDATE config_form_fields
SET dv_querytext='SELECT name as id, name as idval FROM v_cat_hydrometer_state WHERE id IS NOT NULL'
WHERE formname='connec' AND formtype='form_feature' AND columnname='cmb_hydrometer_state' AND tabname='tab_hydrometer';
UPDATE config_form_fields SET linkedobject = REPLACE(linkedobject, 'v_ui_hydrometer', 'vf_hydrometer') WHERE linkedobject ILIKE '%v_ui_hydrometer%';
UPDATE config_form_list SET query_text = REPLACE(query_text, 'v_ui_hydroval', 've_hydrometer_data') WHERE query_text ILIKE '%v_ui_hydroval%';

ALTER TABLE ext_hydrometer_data DROP CONSTRAINT IF EXISTS ext_rtc_hydrometer_x_data_hydrometer_id_fkey;
ALTER TABLE ext_hydrometer_data ADD CONSTRAINT ext_hydrometer_data_hydrometer_id_fkey
FOREIGN KEY (hydrometer_id) REFERENCES ext_hydrometer(hydrometer_id) ON UPDATE CASCADE ON DELETE CASCADE;
