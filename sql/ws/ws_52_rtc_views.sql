/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Views to node
-- ----------------------------
/*
CREATE OR REPLACE VIEW SCHEMA_NAME.v_rtc_x_node AS 
SELECT
rtc_scada_node.node_id,
rtc_scada_node.scada_id,
cat_scada.data_type,
cat_scada.units,
rtc_scada_x_value.value,
rtc_scada_x_value.status,
max(rtc_scada_x_value.date) AS date,
node.the_geom
FROM SCHEMA_NAME.node
JOIN SCHEMA_NAME.rtc_scada_node ON node.node_id = rtc_scada_node.node_id::text
JOIN SCHEMA_NAME.cat_scada ON rtc_scada_node.scadacat_id = cat_scada.id::text
JOIN SCHEMA_NAME.rtc_scada_x_value ON rtc_scada_x_value.scada_id = rtc_scada_node.node_id::text
GROUP BY
rtc_scada_node.node_id,
rtc_scada_node.scada_id,
cat_scada.data_type,
cat_scada.units,
rtc_scada_x_value.value,
rtc_scada_x_value.status,
node.the_geom;


-- ----------------------------
-- View structure to INP
-- ----------------------------

CREATE VIEW v_rtc_hydrometer
hydrometer_id,
connec.dma_id,
rtc_hydrometer_x_data.sum
(rtc_hydrometer_x_data.sum/cat_period.period_seconds) AS value
FROM rtc_hydrometer
JOIN rtc_hydrometer_x_data
JOIN cat_period
JOIN rtc_hydrometer_x_connec
JOIN connec
JOIN rtc_selector_period


CREATE VIEW v_rtc_hydrometer_dma
v_rtc_hydrometer.dma_id
sum (rtc_hydrometer_x_data.sum) as total
FROM v_rtc_hydrometer
GROUP BY 
dma_id


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