/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE VIEW "SCHEMA_NAME".v_ui_hydrometer_x_connec AS
SELECT
ext_rtc_hydrometer.hydrometer_id,
rtc_hydrometer_x_connec.connec_id,
ext_rtc_hydrometer.cat_hydrometer_id,
ext_rtc_hydrometer.text
FROM "SCHEMA_NAME".ext_rtc_hydrometer
JOIN "SCHEMA_NAME".rtc_hydrometer_x_connec ON "SCHEMA_NAME".rtc_hydrometer_x_connec.hydrometer_id="SCHEMA_NAME".ext_rtc_hydrometer.hydrometer_id;



CREATE VIEW "SCHEMA_NAME".v_rtc_hydrometer AS
SELECT
ext_rtc_hydrometer.hydrometer_id,
connec.dma_id,
ext_rtc_hydrometer_x_data.sum as m3_period,
((ext_rtc_hydrometer_x_data.sum*1000)/(ext_cat_period.period_seconds)) AS lps
FROM "SCHEMA_NAME".ext_rtc_hydrometer
JOIN "SCHEMA_NAME".ext_rtc_hydrometer_x_data ON "SCHEMA_NAME".ext_rtc_hydrometer_x_data.hydrometer_id = "SCHEMA_NAME".ext_rtc_hydrometer.hydrometer_id
JOIN "SCHEMA_NAME".ext_cat_period ON "SCHEMA_NAME".ext_rtc_hydrometer_x_data.cat_period_id = "SCHEMA_NAME".ext_cat_period.id
JOIN "SCHEMA_NAME".rtc_hydrometer_x_connec ON "SCHEMA_NAME".rtc_hydrometer_x_connec.hydrometer_id="SCHEMA_NAME".ext_rtc_hydrometer.hydrometer_id
JOIN "SCHEMA_NAME".connec ON "SCHEMA_NAME".connec.connec_id = "SCHEMA_NAME".rtc_hydrometer_x_connec.connec_id
JOIN "SCHEMA_NAME".rtc_selector_period ON  "SCHEMA_NAME".rtc_selector_period.id = "SCHEMA_NAME".ext_cat_period.id;



CREATE VIEW "SCHEMA_NAME".v_rtc_hydrometer_dma AS
SELECT
v_rtc_hydrometer.dma_id,
sum (v_rtc_hydrometer.m3_period) as m3_period,
sum (v_rtc_hydrometer.lps) as lps
FROM v_rtc_hydrometer
GROUP BY 
dma_id;


/*
CREATE VIEW v_rtc_scada_dma
rtc_scada_x_dma.dma_id,
sum (rtc_scada_x_data.sum*rtc_scada_x_dma.sign) as total
FROM rtc_scada
JOIN rtc_scada_x_data
JOIN rtc_scada_x_dma
JOIN rtc_selector_period
GROUP BY 
dma_id


CREATE VIEW v_rtc_parameter_dma
v_rtc_hydrometer_dma.dma_id
(v_rtc_hydrometer_dma.total/v_rtc_scada_dma.total):numeric (4,3) as losses
FROM v_rtc_hydrometer_dma
JOIN v_rtc_scada_dma



CREATE VIEW v_rtc_scada_sector
rtc_scada_x_sector.sector_id
sum (min x sign) as min
sum (avg x sign) as avg
sum (max x sign) as max
(sum (min x avg x sign) / sum (avg)) as min_coef
(sum (max x avg x sign) / sum (avg)) as max_coef
FROM rtc_scada_x_data
JOIN rtc_scada_x_sector
JOIN rtc_selector_period
GROUP BY 
sector_id



CREATE VIEW v_hydrometer_x_arc
hydrometer_id
connec_id
link_id
vnode_id
arc_id
node1
node2

FROM hydrometer
JOIN hydrometer_x_connec
JOIN link
JOIN vnode
JOIN arc



CREATE VIEW v_hydrometer_x_node
v_rtc_hydrometer.hydrometer_id
v_rtc_hydrometer.value*v_rtc_dma_parameters.losses*0.5 as demand
node1 as node_id
FROM v_rtc_hydrometer
JOIN v_rtc_dma_parameters
UNION
v_rtc_hydrometer.hydrometer_id
v_rtc_hydrometer.value*v_rtc_dma_parameters.losses*0.5 as demand
node2 as node_id
FROM v_rtc_hydrometer
JOIN v_rtc_dma_parameters



CREATE VIEW v_inp_demand
v_hydrometer_x_node.node_id
CASE WHEN  
sum (v_hydrometer_x_node.demand*v_rtc_scada_sector.min_coef) as demand
sum (v_hydrometer_x_node.demand) as demand
sum (v_hydrometer_x_node.demand*v_rtc_scada_sector.max_coef) as demand
FROM v_hydrometer_x_node
JOIN v_rtc_scada_sector
JOIN rtc_selector_coeficient
GROUP 
v_hydrometer_x_node.node_id

*/