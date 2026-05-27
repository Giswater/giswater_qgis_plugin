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

CREATE OR REPLACE VIEW vf_hydrometer AS
WITH sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT
    vh.hydrometer_id,
    vh.code AS hydrometer_customer_code,
    connec.connec_id AS feature_id,
    'CONNEC'::text AS feature_type,
    COALESCE(
        vh.customer_code,
        'XXXX'::character varying
    ) AS customer_code,
    vchs.name AS state,
    v_municipality.name AS muni_name,
    connec.expl_id,
    exploitation.name AS expl_name,
    vh.plot_code,
    vh.priority_id,
    vh.catalog_id,
    vh.category_id,
    vh.hydro_number,
    vh.hydro_man_date,
    vh.crm_number,
    vh.customer_name,
    vh.address1,
    vh.address2,
    vh.address3,
    vh.address2_1,
    vh.address2_2,
    vh.address2_3,
    vh.m3_volume,
    vh.start_date,
    vh.end_date,
    vh.update_date,
    concat(
        COALESCE(
            (SELECT config_param_system.value
            FROM config_param_system
            WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)
            , ''
        ),
        vh.link
    ) AS hydrometer_link,
    vchs.is_operative,
    vh.shutdown_date
FROM v_hydrometer vh
    JOIN v_cat_hydrometer_state vchs ON vchs.id = vh.state_id
    JOIN connec ON connec.customer_code::text = vh.customer_code::text
    LEFT JOIN v_municipality ON v_municipality.muni_id = connec.muni_id
    LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
WHERE EXISTS (
    SELECT 1
    FROM sel_expl
    WHERE sel_expl.expl_id = connec.expl_id
);

CREATE OR REPLACE VIEW ve_hydrometer_data AS
SELECT vhd.id,
    connec.connec_id AS feature_id,
    vhd.hydrometer_id,
    vh.code,
    vh.catalog_id,
    vhd.cat_period_id,
    cp.code AS cat_period_code,
    vhd.value_date,
    vhd.sum,
    vhd.custom_sum,
    'CONNEC'::text AS feature_type
FROM v_hydrometer_data vhd
    JOIN v_hydrometer vh ON vhd.hydrometer_id::bigint = vh.hydrometer_id::bigint
    LEFT JOIN v_cat_hydrometer vch ON vch.id::bigint = vh.catalog_id::bigint
    JOIN connec ON connec.customer_code::text = vh.customer_code::text
    JOIN ext_cat_period cp ON vhd.cat_period_id::text = cp.id::text
ORDER BY vhd.hydrometer_id, vhd.cat_period_id DESC;

UPDATE config_form_fields
SET dv_querytext='SELECT name as id, name as idval FROM v_cat_hydrometer_state WHERE id IS NOT NULL'
WHERE formname='connec' AND formtype='form_feature' AND columnname='cmb_hydrometer_state' AND tabname='tab_hydrometer';
UPDATE config_form_fields SET linkedobject = REPLACE(linkedobject, 'v_ui_hydrometer', 'vf_hydrometer') WHERE linkedobject ILIKE '%v_ui_hydrometer%';
UPDATE config_form_list SET query_text = REPLACE(query_text, 'v_ui_hydroval', 've_hydrometer_data') WHERE query_text ILIKE '%v_ui_hydroval%';

ALTER TABLE ext_hydrometer_data DROP CONSTRAINT IF EXISTS ext_rtc_hydrometer_x_data_hydrometer_id_fkey;
ALTER TABLE ext_hydrometer_data ADD CONSTRAINT ext_hydrometer_data_hydrometer_id_fkey
FOREIGN KEY (hydrometer_id) REFERENCES ext_hydrometer(hydrometer_id) ON UPDATE CASCADE ON DELETE CASCADE;


-- rename scada tables
ALTER TABLE IF EXISTS ext_rtc_scada RENAME TO ext_scada;

DELETE FROM sys_table WHERE id IN ('ext_rtc_scada');
INSERT INTO sys_table (id, descript, sys_role, source)
VALUES ('ext_scada', 'Scada table.', 'role_basic', 'core');
