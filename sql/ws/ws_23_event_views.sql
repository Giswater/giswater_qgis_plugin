/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Views to node
-- ----------------------------

CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_junction AS 
SELECT
event_x_junction.id,
event_x_junction.event_id,
event_x_junction.node_id,
event_x_junction.value,
event_x_junction.observ,
max(event_x_junction.date) AS date,
node.the_geom
FROM SCHEMA_NAME.event_x_junction
JOIN SCHEMA_NAME.event ON event.id::text = event_x_junction.event_id::text
JOIN SCHEMA_NAME.node ON node.node_id::text = event_x_junction.node_id::text
GROUP BY
event_x_junction.id,
event_x_junction.event_id,
event_x_junction.node_id,
event_x_junction.value,
event_x_junction.observ,
node.the_geom;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_tank AS
SELECT
event_x_tank.id,
event_x_tank.event_id,
event_x_tank.node_id,
event_x_tank.value,
event_x_tank.observ,
max(event_x_tank.date) AS date,
node.the_geom
FROM SCHEMA_NAME.event_x_tank
JOIN SCHEMA_NAME.event ON event.id::text = event_x_tank.event_id::text
JOIN SCHEMA_NAME.node ON node.node_id::text = event_x_tank.node_id::text
GROUP BY
event_x_tank.id,
event_x_tank.event_id,
event_x_tank.node_id,
event_x_tank.value,
event_x_tank.observ,
node.the_geom;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_hydrant AS
SELECT
event_x_hydrant.id,
event_x_hydrant.event_id,
event_x_hydrant.node_id,
event_x_hydrant.value,
event_x_hydrant.observ,
max(event_x_hydrant.date) AS date,
node.the_geom
FROM SCHEMA_NAME.event_x_hydrant
JOIN SCHEMA_NAME.event ON event.id::text = event_x_hydrant.event_id::text
JOIN SCHEMA_NAME.node ON node.node_id::text = event_x_hydrant.node_id::text
GROUP BY
event_x_hydrant.id,
event_x_hydrant.event_id,
event_x_hydrant.node_id,
event_x_hydrant.value,
event_x_hydrant.observ,
node.the_geom;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_valve AS
SELECT
event_x_valve.id,
event_x_valve.event_id,
event_x_valve.node_id,
event_x_valve.value,
event_x_valve.observ,
max(event_x_valve.date) AS date,
node.the_geom
FROM SCHEMA_NAME.event_x_valve
JOIN SCHEMA_NAME.event ON event.id::text = event_x_valve.event_id::text
JOIN SCHEMA_NAME.node ON node.node_id::text = event_x_valve.node_id::text
GROUP BY
event_x_valve.id,
event_x_valve.event_id,
event_x_valve.node_id,
event_x_valve.value,
event_x_valve.observ,
node.the_geom;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_pump AS
SELECT 
event_x_pump.id,
event_x_pump.event_id,
event_x_pump.node_id,
event_x_pump.value,
event_x_pump.observ,
max(event_x_pump.date) AS date,
node.the_geom
FROM SCHEMA_NAME.event_x_pump
JOIN SCHEMA_NAME.event ON event.id::text = event_x_pump.event_id::text
JOIN SCHEMA_NAME.node ON node.node_id::text = event_x_pump.node_id::text
GROUP BY
event_x_pump.id,
event_x_pump.event_id,
event_x_pump.node_id,
event_x_pump.value,
event_x_pump.observ,
node.the_geom;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_filter AS
SELECT 
event_x_filter.id,
event_x_filter.event_id,
event_x_filter.node_id,
event_x_filter.value,
event_x_filter.observ,
max(event_x_filter.date) AS date,
node.the_geom
FROM SCHEMA_NAME.event_x_filter
JOIN SCHEMA_NAME.event ON event.id::text = event_x_filter.event_id::text
JOIN SCHEMA_NAME.node ON node.node_id::text = event_x_filter.node_id::text
GROUP BY
event_x_filter.id,
event_x_filter.event_id,
event_x_filter.node_id,
event_x_filter.value,
event_x_filter.observ,
node.the_geom;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_meter AS
SELECT 
event_x_meter.id,
event_x_meter.event_id,
event_x_meter.node_id,
event_x_meter.value,
event_x_meter.observ,
max(event_x_meter.date) AS date,
node.the_geom
FROM SCHEMA_NAME.event_x_meter
JOIN SCHEMA_NAME.event ON event.id::text = event_x_meter.event_id::text
JOIN SCHEMA_NAME.node ON node.node_id::text = event_x_meter.node_id::text
GROUP BY
event_x_meter.id,
event_x_meter.event_id,
event_x_meter.node_id,
event_x_meter.value,
event_x_meter.observ,
node.the_geom;



-- ----------------------------
-- Views to arc
-- ----------------------------

CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_pipe AS
SELECT 
event_x_pipe.id,
event_x_pipe.event_id,
event_x_pipe.arc_id,
event_x_pipe.value,
event_x_pipe.observ,
max(event_x_pipe.date) AS date,
arc.the_geom
FROM SCHEMA_NAME.event_x_pipe
JOIN SCHEMA_NAME.event ON event.id::text = event_x_pipe.event_id::text
JOIN SCHEMA_NAME.arc ON arc.arc_id::text = event_x_pipe.arc_id::text
GROUP BY
event_x_pipe.id,
event_x_pipe.event_id,
event_x_pipe.arc_id,
event_x_pipe.value,
event_x_pipe.observ,
arc.the_geom;



-- ----------------------------
-- Views to connec
-- ----------------------------

CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_connec AS
SELECT 
event_x_connec.id,
event_x_connec.event_id,
event_x_connec.connec_id,
event_x_connec.value,
event_x_connec.observ,
max(event_x_connec.date) AS date,
connec.the_geom
FROM SCHEMA_NAME.event_x_connec
JOIN SCHEMA_NAME.event ON event.id::text = event_x_connec.event_id::text
JOIN SCHEMA_NAME.connec ON connec.connec_id::text = event_x_connec.connec_id::text
GROUP BY
event_x_connec.id,
event_x_connec.event_id,
event_x_connec.connec_id,
event_x_connec.value,
event_x_connec.observ,
connec.the_geom;

