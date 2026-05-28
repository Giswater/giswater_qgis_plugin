/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW IF EXISTS v_om_mincut_hydrometer;
DROP VIEW IF EXISTS v_om_mincut_current_hydrometer;
DROP VIEW IF EXISTS v_ui_mincut_hydrometer;

ALTER TABLE IF EXISTS om_mincut_hydrometer DROP CONSTRAINT IF EXISTS om_mincut_hydrometer_hydrometer_id_fkey;

ALTER TABLE om_mincut_hydrometer ADD CONSTRAINT om_mincut_hydrometer_hydrometer_id_fkey
FOREIGN KEY (hydrometer_id) REFERENCES ext_hydrometer(hydrometer_id) ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE OR REPLACE VIEW v_hydrometer AS
SELECT * FROM ext_hydrometer;

CREATE OR REPLACE VIEW v_hydrometer_period AS
SELECT * FROM ext_hydrometer_period;

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

CREATE OR REPLACE VIEW v_cat_period_type AS
SELECT * FROM ext_cat_period_type;

CREATE OR REPLACE VIEW v_cat_period AS
SELECT * FROM ext_cat_period;

CREATE OR REPLACE VIEW vf_hydrometer AS
WITH sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
), node_data AS (
    SELECT
        v_hydrometer.hydrometer_id,
        node.node_id,
        node.expl_id,
        node.muni_id
    FROM v_hydrometer
        JOIN man_netwjoin ON man_netwjoin.customer_code::text = v_hydrometer.feature_customer_code::text
        JOIN node ON node.node_id = man_netwjoin.node_id
), connec_data AS (
    SELECT
        v_hydrometer.hydrometer_id,
        connec.connec_id,
        connec.expl_id,
        connec.muni_id
    FROM v_hydrometer
        JOIN connec ON connec.customer_code::text = v_hydrometer.feature_customer_code::text
), feature_data AS (
    SELECT
        connec_data.hydrometer_id,
        connec_data.connec_id AS feature_id,
        'CONNEC'::text AS feature_type,
        connec_data.expl_id,
        connec_data.muni_id
    FROM connec_data
    UNION
    SELECT
        node_data.hydrometer_id,
        node_data.node_id AS feature_id,
        'NODE'::text AS feature_type,
        node_data.expl_id,
        node_data.muni_id
    FROM node_data
)
SELECT
    v_hydrometer.hydrometer_id,
    v_hydrometer.hydro_customer_code,
    d.feature_id,
    d.feature_type,
    COALESCE(
        v_hydrometer.feature_customer_code,
        'XXXX'::character varying(30)
    ) AS feature_customer_code,
    v_hydrometer.contract_id,
    v_hydrometer.identif,
    v_cat_hydrometer_state.name AS state,
    v_cat_hydrometer_state.is_operative,
    d.expl_id,
    exploitation.name AS expl_name,
    v_hydrometer.priority_id,
    v_hydrometer.catalog_id,
    v_hydrometer.category_id,
    v_hydrometer.crmzone_id,
    v_hydrometer.crmzone_order,
    v_hydrometer.wmeter_builtdate,
    v_hydrometer.wmeter_instaldate,
    v_hydrometer.plot_code,
    v_hydrometer.muni_id,
    v_municipality.name AS muni_name,
    v_hydrometer.start_date,
    v_hydrometer.update_date,
    v_hydrometer.shutdown_date,
    v_hydrometer.end_date,
    v_hydrometer.address1_1,
    v_hydrometer.address1_2,
    v_hydrometer.address1_3,
    v_hydrometer.address2_1,
    v_hydrometer.address2_2,
    v_hydrometer.address2_3,
    v_hydrometer.assessed_volume,
    v_hydrometer.is_waterbal,
    concat(
        COALESCE(
            (SELECT config_param_system.value
            FROM config_param_system
            WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)
            , ''
        ),
        v_hydrometer.link
    ) AS hydrometer_link
FROM feature_data d
    JOIN v_hydrometer ON v_hydrometer.hydrometer_id = d.hydrometer_id
    JOIN v_cat_hydrometer_state ON v_cat_hydrometer_state.id = v_hydrometer.state_id
    LEFT JOIN v_municipality ON v_municipality.muni_id = d.muni_id
    LEFT JOIN exploitation ON exploitation.expl_id = d.expl_id
    WHERE EXISTS (
        SELECT 1
        FROM sel_expl
        WHERE sel_expl.expl_id = d.expl_id
    );

CREATE OR REPLACE VIEW ve_hydrometer_period AS
SELECT
    v_hydrometer_period.id,
    COALESCE(connec.connec_id, man_netwjoin.node_id) AS feature_id,
    v_hydrometer_period.hydrometer_id,
    v_hydrometer.hydro_customer_code,
    v_hydrometer.catalog_id,
    v_hydrometer_period.cat_period_id,
    v_cat_period.code AS cat_period_code,
    v_hydrometer_period.value_date,
    v_hydrometer_period.billed_volume,
    CASE
        WHEN connec.connec_id IS NOT NULL THEN 'CONNEC'::text
        WHEN man_netwjoin.node_id IS NOT NULL THEN 'NODE'::text
    END AS feature_type
FROM v_hydrometer_period
    JOIN v_hydrometer ON v_hydrometer_period.hydrometer_id::bigint = v_hydrometer.hydrometer_id::bigint
    LEFT JOIN v_cat_hydrometer ON v_cat_hydrometer.id::bigint = v_hydrometer.catalog_id::bigint
    LEFT JOIN connec ON connec.customer_code::text = v_hydrometer.feature_customer_code::text
    LEFT JOIN man_netwjoin ON man_netwjoin.customer_code::text = v_hydrometer.feature_customer_code::text
    JOIN v_cat_period ON v_hydrometer_period.cat_period_id::text = v_cat_period.id::text
    WHERE connec.connec_id IS NOT NULL OR man_netwjoin.node_id IS NOT NULL
ORDER BY v_hydrometer_period.hydrometer_id, v_hydrometer_period.cat_period_id DESC;


CREATE OR REPLACE VIEW v_om_mincut_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    v_hydrometer.hydro_customer_code,
    connec.connec_id,
    connec.code AS connec_code
   FROM selector_mincut_result,
    om_mincut_hydrometer
     JOIN v_hydrometer ON om_mincut_hydrometer.hydrometer_id = v_hydrometer.hydrometer_id
     JOIN connec ON connec.customer_code::text = v_hydrometer.feature_customer_code::text
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_hydrometer.result_id::text AND selector_mincut_result.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_om_mincut_current_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    v_hydrometer.hydro_customer_code,
    connec.connec_id,
    connec.code AS connec_code
   FROM om_mincut_hydrometer
     JOIN v_hydrometer ON om_mincut_hydrometer.hydrometer_id = v_hydrometer.hydrometer_id
     JOIN connec ON connec.customer_code::text = v_hydrometer.feature_customer_code::text
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
  WHERE om_mincut.mincut_state = 1;

CREATE OR REPLACE VIEW v_ui_mincut_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.hydrometer_id,
    connec.connec_id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut.mincut_state,
    om_mincut.mincut_class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_appropiate,
        CASE
            WHEN om_mincut.mincut_state = 0 THEN om_mincut.forecast_start::timestamp with time zone
            WHEN om_mincut.mincut_state = 1 THEN now()
            WHEN om_mincut.mincut_state = 2 THEN om_mincut.exec_start::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS start_date,
        CASE
            WHEN om_mincut.mincut_state = 0 THEN om_mincut.forecast_end::timestamp with time zone
            WHEN om_mincut.mincut_state = 1 THEN now()
            WHEN om_mincut.mincut_state = 2 THEN om_mincut.exec_end::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS end_date,
    om_mincut.shutoff_required
   FROM om_mincut_hydrometer
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
     JOIN v_hydrometer ON v_hydrometer.hydrometer_id::text = om_mincut_hydrometer.hydrometer_id::text
     JOIN connec ON connec.customer_code::text = v_hydrometer.feature_customer_code::text;

UPDATE config_form_fields SET linkedobject = REPLACE(linkedobject, 'v_ui_hydrometer', 'vf_hydrometer') WHERE linkedobject ILIKE '%v_ui_hydrometer%';
UPDATE config_form_list SET query_text = REPLACE(query_text, 'v_ui_hydroval', 've_hydrometer_period') WHERE query_text ILIKE '%v_ui_hydroval%';


UPDATE config_form_fields SET formname = 'ext_cat_hydrometer_category' WHERE formname = 'ext_hydrometer_category';
UPDATE config_form_fields SET formname = 'ext_cat_hydrometer_state' WHERE formname = 'ext_rtc_hydrometer_state';
UPDATE config_form_fields SET formname = 'ext_hydrometer' WHERE formname = 'ext_rtc_hydrometer';
UPDATE config_form_fields SET formname = 'ext_hydrometer_period' WHERE formname = 'ext_rtc_hydrometer_data';

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;
