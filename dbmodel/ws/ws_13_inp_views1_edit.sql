/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- View structure for v_edit_inp
-- ----------------------------

CREATE VIEW "SCHEMA_NAME"."v_edit_inp_junction" AS 
SELECT 
node.node_id, node.elevation, node."depth", node.nodecat_id, node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.rotation, node.link, node.verified, node.the_geom,
inp_junction.demand, inp_junction.pattern_id
FROM (SCHEMA_NAME.node
JOIN SCHEMA_NAME.inp_junction ON (((inp_junction.node_id)::text = (node.node_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_edit_inp_reservoir" AS 
SELECT 
node.node_id, node.elevation, node."depth", node.nodecat_id, node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.rotation, node.link, node.verified, node.the_geom,
inp_reservoir.head, inp_reservoir.pattern_id
FROM (SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_reservoir ON (((inp_reservoir.node_id)::text = (node.node_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_edit_inp_tank" AS 
SELECT 
node.node_id, node.elevation, node."depth", node.nodecat_id, node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.rotation, node.link, node.verified, node.the_geom,
inp_tank.initlevel, inp_tank.minlevel, inp_tank.maxlevel, inp_tank.diameter, inp_tank.minvol, inp_tank.curve_id
FROM (SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_tank ON (((inp_tank.node_id)::text = (node.node_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_edit_inp_pump" AS 
SELECT 
node.node_id, node.elevation, node."depth", node.nodecat_id, node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.rotation, node.link, node.verified, node.the_geom,
inp_pump.power, inp_pump.curve_id, inp_pump.speed, inp_pump.pattern, inp_pump.status
FROM (SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_pump ON (((node.node_id)::text = (inp_pump.node_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_edit_inp_valve" AS 
SELECT 
node.node_id, node.elevation, node."depth", node.nodecat_id, node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.rotation, node.link, node.verified, node.the_geom,
inp_valve.valv_type, inp_valve.pressure, inp_valve.flow, inp_valve.coef_loss, inp_valve.curve_id, inp_valve.minorloss, inp_valve.status
FROM (SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_valve ON (((node.node_id)::text = (inp_valve.node_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_edit_inp_shortpipe" AS 
SELECT 
node.node_id,  node.elevation, node."depth", node.nodecat_id, node.sector_id, node."state", node.annotation, node.observ, node.comment, node.dma_id, node.rotation, node.link, node.verified, node.the_geom,
inp_shortpipe.minorloss, inp_shortpipe.to_arc, inp_shortpipe.status
FROM (SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_shortpipe ON (((inp_shortpipe.node_id)::text = (node.node_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_edit_inp_pipe" AS 
SELECT 
arc.arc_id, arc.arccat_id, arc.sector_id, arc."state", arc.annotation, arc.observ, arc.comment, arc.dma_id, arc.custom_length, arc.rotation, arc.link, arc.verified, arc.the_geom,
inp_pipe.minorloss, inp_pipe.status
FROM (SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_pipe ON (((inp_pipe.arc_id)::text = (arc.arc_id)::text)));
