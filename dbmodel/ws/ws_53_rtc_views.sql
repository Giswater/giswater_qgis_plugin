/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE VIEW SCHEMA_NAME.v_ui_scada_x_node AS 
SELECT
ext_rtc_scada_x_value.id,
rtc_scada_node.scada_id,
rtc_scada_node.node_id,
ext_rtc_scada_x_value.value,
ext_rtc_scada_x_value.status,
ext_rtc_scada_x_value.timestamp
FROM "SCHEMA_NAME".rtc_scada_node
JOIN "SCHEMA_NAME".ext_rtc_scada_x_value ON ext_rtc_scada_x_value.scada_id::text = rtc_scada_node.scada_id::text;



CREATE OR REPLACE VIEW "SCHEMA_NAME".v_ui_hydrometer_x_connec AS
SELECT
ext_rtc_hydrometer.hydrometer_id,
rtc_hydrometer_x_connec.connec_id,
ext_rtc_hydrometer.cat_hydrometer_id,
ext_rtc_hydrometer.text
FROM "SCHEMA_NAME".ext_rtc_hydrometer
JOIN "SCHEMA_NAME".rtc_hydrometer_x_connec ON "SCHEMA_NAME".rtc_hydrometer_x_connec.hydrometer_id="SCHEMA_NAME".ext_rtc_hydrometer.hydrometer_id;



CREATE OR REPLACE VIEW "SCHEMA_NAME".v_rtc_hydrometer_period AS
SELECT
ext_rtc_hydrometer.hydrometer_id,
ext_cat_period.id as period_id,
connec.dma_id,
ext_rtc_hydrometer_x_data.sum as m3_total_period,
((ext_rtc_hydrometer_x_data.sum*1000)/(ext_cat_period.period_seconds)) AS lps_avg
FROM "SCHEMA_NAME".ext_rtc_hydrometer
JOIN "SCHEMA_NAME".ext_rtc_hydrometer_x_data ON "SCHEMA_NAME".ext_rtc_hydrometer_x_data.hydrometer_id = "SCHEMA_NAME".ext_rtc_hydrometer.hydrometer_id
JOIN "SCHEMA_NAME".ext_cat_period ON "SCHEMA_NAME".ext_rtc_hydrometer_x_data.cat_period_id = "SCHEMA_NAME".ext_cat_period.id
JOIN "SCHEMA_NAME".rtc_hydrometer_x_connec ON "SCHEMA_NAME".rtc_hydrometer_x_connec.hydrometer_id="SCHEMA_NAME".ext_rtc_hydrometer.hydrometer_id
JOIN "SCHEMA_NAME".connec ON "SCHEMA_NAME".connec.connec_id = "SCHEMA_NAME".rtc_hydrometer_x_connec.connec_id
JOIN "SCHEMA_NAME".rtc_options ON  "SCHEMA_NAME".rtc_options.period_id = "SCHEMA_NAME".ext_cat_period.id;



CREATE OR REPLACE VIEW SCHEMA_NAME.v_rtc_dma_hydrometer_period AS 
 SELECT v_rtc_hydrometer_period.dma_id, 
    ext_cat_period.id AS period_id, 
    sum(v_rtc_hydrometer_period.m3_total_period) AS m3_total_period, 
    ext_cat_period.period_seconds
   FROM SCHEMA_NAME.v_rtc_hydrometer_period
   JOIN SCHEMA_NAME.ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::text = v_rtc_hydrometer_period.hydrometer_id::text
   JOIN SCHEMA_NAME.rtc_options ON rtc_options.period_id::text = ext_rtc_hydrometer_x_data.cat_period_id::text
   JOIN SCHEMA_NAME.ext_cat_period ON rtc_options.period_id::text = ext_cat_period.id::text
  GROUP BY v_rtc_hydrometer_period.dma_id, ext_cat_period.id, ext_cat_period.period_seconds;



CREATE OR REPLACE VIEW "SCHEMA_NAME".v_rtc_dma_parameter_period AS 
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
   FROM "SCHEMA_NAME".v_rtc_dma_hydrometer_period
  JOIN "SCHEMA_NAME".ext_rtc_scada_dma_period ON ext_rtc_scada_dma_period.cat_period_id::text = v_rtc_dma_hydrometer_period.period_id::text;



CREATE OR REPLACE VIEW "SCHEMA_NAME".v_rtc_hydrometer_x_arc AS 
SELECT
rtc_hydrometer_x_connec.hydrometer_id,
rtc_hydrometer_x_connec.connec_id,
arc.arc_id,
arc.node_1,
arc.node_2
FROM "SCHEMA_NAME".rtc_hydrometer_x_connec
JOIN "SCHEMA_NAME".v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
JOIN "SCHEMA_NAME".arc ON arc.arc_id::text = v_edit_connec.arc_id;


CREATE OR REPLACE VIEW "SCHEMA_NAME".v_rtc_hydrometer_x_node_period AS
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
FROM "SCHEMA_NAME".v_rtc_hydrometer_x_arc
JOIN "SCHEMA_NAME".v_rtc_hydrometer_period ON v_rtc_hydrometer_period.hydrometer_id::text=v_rtc_hydrometer_x_arc.hydrometer_id
JOIN "SCHEMA_NAME".v_rtc_dma_parameter_period ON v_rtc_hydrometer_period.period_id::text=v_rtc_dma_parameter_period.period_id::text
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
FROM "SCHEMA_NAME".v_rtc_hydrometer_x_arc
JOIN "SCHEMA_NAME".v_rtc_hydrometer_period ON v_rtc_hydrometer_period.hydrometer_id::text=v_rtc_hydrometer_x_arc.hydrometer_id
JOIN "SCHEMA_NAME".v_rtc_dma_parameter_period ON v_rtc_hydrometer_period.period_id::text=v_rtc_dma_parameter_period.period_id::text;



CREATE OR REPLACE VIEW "SCHEMA_NAME"."v_inp_demand" as
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
FROM "SCHEMA_NAME".inp_junction
JOIN "SCHEMA_NAME".node ON (((node.node_id)::text = (node.node_id)::text)) 
JOIN "SCHEMA_NAME".v_rtc_hydrometer_x_node_period ON v_rtc_hydrometer_x_node_period.node_id=node.node_id
JOIN "SCHEMA_NAME".rtc_options ON rtc_options.period_id=v_rtc_hydrometer_x_node_period.period_id
JOIN "SCHEMA_NAME".inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))
JOIN "SCHEMA_NAME".inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text))
WHERE rtc_options.rtc_status='ON'
GROUP BY
v_rtc_hydrometer_x_node_period.node_id,
pattern_id,
v_rtc_hydrometer_x_node_period.period_id,
rtc_options.coefficient;
