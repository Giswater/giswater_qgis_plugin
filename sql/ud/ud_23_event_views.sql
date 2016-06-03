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
event_x_junction.value_struc,
event_x_junction.value_sediment,
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
event_x_junction.value_struc,
event_x_junction.value_sediment,
event_x_junction.observ,
node.the_geom;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_storage AS
SELECT
event_x_storage.id,
event_x_storage.event_id,
event_x_storage.node_id,
event_x_storage.value_struc,
event_x_storage.value_sediment,
event_x_storage.observ,
max(event_x_storage.date) AS date,
node.the_geom
FROM SCHEMA_NAME.event_x_storage
JOIN SCHEMA_NAME.event ON event.id::text = event_x_storage.event_id::text
JOIN SCHEMA_NAME.node ON node.node_id::text = event_x_storage.node_id::text
GROUP BY
event_x_storage.id,
event_x_storage.event_id,
event_x_storage.node_id,
event_x_storage.value_struc,
event_x_storage.value_sediment,
event_x_storage.observ,
node.the_geom;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_outfall AS
SELECT
event_x_outfall.id,
event_x_outfall.event_id,
event_x_outfall.node_id,
event_x_outfall.value_struc,
event_x_outfall.value_sediment,
event_x_outfall.observ,
max(event_x_outfall.date) AS date,
node.the_geom
FROM SCHEMA_NAME.event_x_outfall
JOIN SCHEMA_NAME.event ON event.id::text = event_x_outfall.event_id::text
JOIN SCHEMA_NAME.node ON node.node_id::text = event_x_outfall.node_id::text
GROUP BY
event_x_outfall.id,
event_x_outfall.event_id,
event_x_outfall.node_id,
event_x_outfall.value_struc,
event_x_outfall.value_sediment,
event_x_outfall.observ,
node.the_geom;




-- ----------------------------
-- Views to arc
-- ----------------------------

CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_conduit AS
SELECT 
event_x_conduit.id,
event_x_conduit.event_id,
event_x_conduit.arc_id,
event_x_conduit.value_struc,
event_x_conduit.value_sediment,
event_x_conduit.observ,
max(event_x_conduit.date) AS date,
arc.the_geom
FROM SCHEMA_NAME.event_x_conduit
JOIN SCHEMA_NAME.event ON event.id::text = event_x_conduit.event_id::text
JOIN SCHEMA_NAME.arc ON arc.arc_id::text = event_x_conduit.arc_id::text
GROUP BY
event_x_conduit.id,
event_x_conduit.event_id,
event_x_conduit.arc_id,
event_x_conduit.value_struc,
event_x_conduit.value_sediment,
event_x_conduit.observ,
arc.the_geom;



-- ----------------------------
-- Views to connec
-- ----------------------------

CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_connec AS
SELECT 
event_x_connec.id,
event_x_connec.event_id,
event_x_connec.connec_id,
event_x_connec.value_struc,
event_x_connec.value_sediment,
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
event_x_connec.value_struc,
event_x_connec.value_sediment,
event_x_connec.observ,
connec.the_geom;


-- ----------------------------
-- Views to connec
-- ----------------------------

CREATE OR REPLACE VIEW SCHEMA_NAME.v_event_x_gully AS
SELECT 
event_x_gully.id,
event_x_gully.event_id,
event_x_gully.gully_id,
event_x_gully.value_struc,
event_x_gully.value_sediment,
event_x_gully.observ,
max(event_x_gully.date) AS date,
gully.the_geom
FROM SCHEMA_NAME.event_x_gully
JOIN SCHEMA_NAME.event ON event.id::text = event_x_gully.event_id::text
JOIN SCHEMA_NAME.gully ON gully.gully_id::text = event_x_gully.gully_id::text
GROUP BY
event_x_gully.id,
event_x_gully.event_id,
event_x_gully.gully_id,
event_x_gully.value_struc,
event_x_gully.value_sediment,
event_x_gully.observ,
gully.the_geom;

