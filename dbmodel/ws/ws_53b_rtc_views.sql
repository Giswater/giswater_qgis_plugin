/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;


DROP VIEW IF EXISTS v_rtc_hydrometer CASCADE;
CREATE OR REPLACE VIEW v_rtc_hydrometer AS
SELECT
ext_rtc_hydrometer.hydrometer_id,
rtc_hydrometer_x_connec.connec_id,
connec.code as urban_propierties_code,
cat_hydrometer_id,
client_name,
adress,
adress_number,
adress_adjunct,
hydrometer_code,
instalation_date,
flow,
easel,
cover,
diameter,
kink_date,
technical_average,
hydrometer_number,
hydrometer_flag,
digits_hydrometer,
kit_flag_ulmc,
brand,
class,
ulmc,
voltman_flow,
multi_jet_flow,
easel_diameter_pol,
easel_diameter_mm,
ext_cat_hydrometer.hydrometer_type, 
ext_cat_hydrometer.text2, 
ext_cat_hydrometer.text3
FROM ext_rtc_hydrometer
LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.cat_hydrometer_id::text
JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::text = ext_rtc_hydrometer.hydrometer_id
JOIN  connec ON rtc_hydrometer_x_connec.connec_id=connec.connec_id;



DROP VIEW IF EXISTS v_rtc_hydrometer_period CASCADE;
CREATE OR REPLACE VIEW v_rtc_hydrometer_period AS
SELECT
ext_rtc_hydrometer.hydrometer_id,
ext_cat_period.id as period_id,
connec.dma_id,
ext_rtc_hydrometer_x_data.sum as m3_total_period,
((ext_rtc_hydrometer_x_data.sum*1000)/(ext_cat_period.period_seconds)) AS lps_avg
FROM ext_rtc_hydrometer
JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id = ext_rtc_hydrometer.hydrometer_id
JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id = ext_cat_period.id
JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id=ext_rtc_hydrometer.hydrometer_id
JOIN connec ON connec.connec_id = rtc_hydrometer_x_connec.connec_id
JOIN rtc_options ON  rtc_options.period_id = ext_cat_period.id;


DROP VIEW IF EXISTS v_rtc_dma_hydrometer_period CASCADE;
CREATE OR REPLACE VIEW v_rtc_dma_hydrometer_period AS 
 SELECT v_rtc_hydrometer_period.dma_id, 
    ext_cat_period.id AS period_id, 
    sum(v_rtc_hydrometer_period.m3_total_period) AS m3_total_period, 
    ext_cat_period.period_seconds
   FROM v_rtc_hydrometer_period
   JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::text = v_rtc_hydrometer_period.hydrometer_id::text
   JOIN rtc_options ON rtc_options.period_id::text = ext_rtc_hydrometer_x_data.cat_period_id::text
   JOIN ext_cat_period ON rtc_options.period_id::text = ext_cat_period.id::text
  GROUP BY v_rtc_hydrometer_period.dma_id, ext_cat_period.id, ext_cat_period.period_seconds;


DROP VIEW IF EXISTS v_rtc_dma_parameter_period CASCADE;
CREATE OR REPLACE VIEW v_rtc_dma_parameter_period AS 
 SELECT v_rtc_dma_hydrometer_period.dma_id, 
    v_rtc_dma_hydrometer_period.period_id, 
    v_rtc_dma_hydrometer_period.m3_total_period AS m3_total_hydrometer,
    ext_rtc_scada_dma_period.m3_total_period AS m3_total_scada, 
    (1::double precision - v_rtc_dma_hydrometer_period.m3_total_period / ext_rtc_scada_dma_period.m3_total_period)::numeric(5,4) AS losses, 
    ext_rtc_scada_dma_period.m3_min AS m3_min_scada, 
    ext_rtc_scada_dma_period.m3_max AS m3_max_scada, 
    ext_rtc_scada_dma_period.m3_avg AS m3_avg_scada, 
    ext_rtc_scada_dma_period.m3_min / ext_rtc_scada_dma_period.m3_avg AS cmin, 
    ext_rtc_scada_dma_period.m3_max / ext_rtc_scada_dma_period.m3_avg AS cmax
   FROM v_rtc_dma_hydrometer_period
  JOIN ext_rtc_scada_dma_period ON ext_rtc_scada_dma_period.cat_period_id::text = v_rtc_dma_hydrometer_period.period_id::text;


DROP VIEW IF EXISTS v_rtc_hydrometer_x_arc CASCADE;
CREATE OR REPLACE VIEW v_rtc_hydrometer_x_arc AS 
SELECT
rtc_hydrometer_x_connec.hydrometer_id,
rtc_hydrometer_x_connec.connec_id,
arc.arc_id,
arc.node_1,
arc.node_2
FROM rtc_hydrometer_x_connec
JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
JOIN arc ON arc.arc_id::text = v_edit_connec.arc_id;


DROP VIEW IF EXISTS v_rtc_hydrometer_x_node_period CASCADE;
CREATE OR REPLACE VIEW v_rtc_hydrometer_x_node_period AS
SELECT
v_rtc_hydrometer_x_arc.node_1 as node_id,
v_rtc_dma_parameter_period.dma_id,
v_rtc_dma_parameter_period.period_id,
v_rtc_hydrometer_period.lps_avg*0.5 as lps_avg_real,
v_rtc_dma_parameter_period.losses,
v_rtc_hydrometer_period.lps_avg*0.5*(1/(1-v_rtc_dma_parameter_period.losses)) as lps_avg,
v_rtc_dma_parameter_period.cmin,
v_rtc_hydrometer_period.lps_avg*0.5*v_rtc_dma_parameter_period.cmin as lps_min,
v_rtc_dma_parameter_period.cmax,
v_rtc_hydrometer_period.lps_avg*0.5*v_rtc_dma_parameter_period.cmax as lps_max
FROM v_rtc_hydrometer_x_arc
JOIN v_rtc_hydrometer_period ON v_rtc_hydrometer_period.hydrometer_id::text=v_rtc_hydrometer_x_arc.hydrometer_id
JOIN v_rtc_dma_parameter_period ON v_rtc_hydrometer_period.period_id::text=v_rtc_dma_parameter_period.period_id::text
UNION
SELECT
v_rtc_hydrometer_x_arc.node_2 as node_id,
v_rtc_dma_parameter_period.dma_id,
v_rtc_dma_parameter_period.period_id,
v_rtc_hydrometer_period.lps_avg*0.5 as lps_avg_real,
v_rtc_dma_parameter_period.losses,
v_rtc_hydrometer_period.lps_avg*0.5*(1/(1-v_rtc_dma_parameter_period.losses)) as lps_avg,
v_rtc_dma_parameter_period.cmin,
v_rtc_hydrometer_period.lps_avg*0.5*v_rtc_dma_parameter_period.cmin as lps_min,
v_rtc_dma_parameter_period.cmax,
v_rtc_hydrometer_period.lps_avg*0.5*v_rtc_dma_parameter_period.cmax as lps_max
FROM v_rtc_hydrometer_x_arc
JOIN v_rtc_hydrometer_period ON v_rtc_hydrometer_period.hydrometer_id::text=v_rtc_hydrometer_x_arc.hydrometer_id
JOIN v_rtc_dma_parameter_period ON v_rtc_hydrometer_period.period_id::text=v_rtc_dma_parameter_period.period_id::text;


DROP VIEW IF EXISTS "v_inp_demand" CASCADE;
CREATE OR REPLACE VIEW "v_inp_demand" as
SELECT
v_rtc_hydrometer_x_node_period.node_id,
(CASE 
WHEN (rtc_options.coefficient='MIN') THEN (sum(v_rtc_hydrometer_x_node_period.lps_min)) 
WHEN (rtc_options.coefficient='AVG') THEN (sum(v_rtc_hydrometer_x_node_period.lps_avg))
ELSE (sum(v_rtc_hydrometer_x_node_period.lps_max)) END) as demand,
(CASE 
WHEN (rtc_options.coefficient='MIN') THEN null
WHEN (rtc_options.coefficient='AVG') THEN inp_junction.pattern_id
ELSE null END) as pattern_id
FROM inp_junction
JOIN node ON (((node.node_id)::text = (node.node_id)::text)) 
JOIN v_rtc_hydrometer_x_node_period ON v_rtc_hydrometer_x_node_period.node_id=node.node_id
JOIN rtc_options ON rtc_options.period_id=v_rtc_hydrometer_x_node_period.period_id
JOIN inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))
JOIN inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text))
WHERE rtc_options.rtc_status='ON'
GROUP BY
v_rtc_hydrometer_x_node_period.node_id,
pattern_id,
v_rtc_hydrometer_x_node_period.period_id,
rtc_options.coefficient;

