/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Views to node
-- ----------------------------

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
JOIN SCHEMA_NAME.cat_scada ON rtc_scada_node.scdcat_id = cat_scada.id::text
JOIN SCHEMA_NAME.rtc_scada_x_value ON rtc_scada_x_value.scada_id = rtc_scada_node.node_id::text
GROUP BY
rtc_scada_node.node_id,
rtc_scada_node.scada_id,
cat_scada.data_type,
cat_scada.units,
rtc_scada_x_value.value,
rtc_scada_x_value.status,
node.the_geom;

