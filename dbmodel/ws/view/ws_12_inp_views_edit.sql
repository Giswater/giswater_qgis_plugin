/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- View structure for v_edit_inp
-- ----------------------------

DROP VIEW IF EXISTS "v_edit_inp_junction" CASCADE;
CREATE VIEW "v_edit_inp_junction" AS 
SELECT 
node.node_id, 
node.elevation, 
node."depth", 
node.nodecat_id,
node.sector_id, 
v_node.macrosector_id,
node."state", 
node.annotation, 
node.the_geom,
inp_junction.demand, 
inp_junction.pattern_id
FROM inp_selector_sector, node
	JOIN v_node ON v_node.node_id=node.node_id
	JOIN inp_junction ON ((inp_junction.node_id) = (node.node_id))
	WHERE (node.sector_id=inp_selector_sector.sector_id AND inp_selector_sector.cur_user="current_user"());


DROP VIEW IF EXISTS "v_edit_inp_reservoir" CASCADE;
CREATE VIEW "v_edit_inp_reservoir" AS 
SELECT 
node.node_id, 
node.elevation, 
node."depth", node.nodecat_id, 
node.sector_id, 
v_node.macrosector_id,
node."state", 
node.annotation,
node.the_geom,
inp_reservoir.pattern_id
FROM inp_selector_sector, node
	JOIN v_node ON v_node.node_id=node.node_id
	JOIN inp_reservoir ON ((inp_reservoir.node_id) = (node.node_id))
	WHERE ((node.sector_id)=(inp_selector_sector.sector_id)	AND inp_selector_sector.cur_user="current_user"());


DROP VIEW IF EXISTS "v_edit_inp_tank" CASCADE;
CREATE VIEW "v_edit_inp_tank" AS 
SELECT 
node.node_id, 
node.elevation, 
node."depth", 
node.nodecat_id, 
node.sector_id,
v_node.macrosector_id,
node."state", 
node.annotation,
node.the_geom,
inp_tank.initlevel, 
inp_tank.minlevel, 
inp_tank.maxlevel, 
inp_tank.diameter,
inp_tank.minvol, 
inp_tank.curve_id
FROM inp_selector_sector, node
	JOIN v_node ON v_node.node_id=node.node_id
	JOIN inp_tank ON ((inp_tank.node_id) = (node.node_id))
	WHERE ((node.sector_id)=(inp_selector_sector.sector_id)	AND inp_selector_sector.cur_user="current_user"());


DROP VIEW IF EXISTS "v_edit_inp_pump" CASCADE;
CREATE VIEW "v_edit_inp_pump" AS 
SELECT 
node.node_id, 
node.elevation, 
node."depth", 
node.nodecat_id, 
node.sector_id, 
v_node.macrosector_id,
node."state", 
node.annotation,
node.the_geom,
inp_pump.power, 
inp_pump.curve_id, 
inp_pump.speed, 
inp_pump.pattern, 
inp_pump.to_arc, 
inp_pump.status
FROM inp_selector_sector, node 
	JOIN v_node ON v_node.node_id=node.node_id
	JOIN inp_pump ON ((node.node_id) = (inp_pump.node_id))
	WHERE ((node.sector_id)=(inp_selector_sector.sector_id)	AND inp_selector_sector.cur_user="current_user"());


DROP VIEW IF EXISTS "v_edit_inp_valve" CASCADE;
CREATE VIEW "v_edit_inp_valve" AS 
SELECT 
node.node_id, 
node.elevation, 
node."depth", 
node.nodecat_id, 
node.sector_id, 
v_node.macrosector_id,
node."state", 
node.annotation,
node.the_geom,
inp_valve.valv_type, 
inp_valve.pressure, 
inp_valve.flow, 
inp_valve.coef_loss, 
inp_valve.curve_id, 
inp_valve.minorloss, 
inp_valve.to_arc,
inp_valve.status
FROM inp_selector_sector, node 
	JOIN v_node ON v_node.node_id=node.node_id
	JOIN inp_valve ON ((node.node_id) = (inp_valve.node_id))
	WHERE ((node.sector_id)=(inp_selector_sector.sector_id)	AND inp_selector_sector.cur_user="current_user"());


DROP VIEW IF EXISTS "v_edit_inp_shortpipe" CASCADE;
CREATE VIEW "v_edit_inp_shortpipe" AS 
SELECT 
node.node_id, 
node.elevation, 
node."depth", 
node.nodecat_id, 
node.sector_id, 
v_node.macrosector_id,
node."state", 
node.annotation,
node.the_geom,
inp_shortpipe.minorloss, 
inp_shortpipe.to_arc, 
inp_shortpipe.status
FROM inp_selector_sector, node
	JOIN v_node ON v_node.node_id=node.node_id
	JOIN inp_shortpipe ON ((inp_shortpipe.node_id) = (node.node_id))
	WHERE ((node.sector_id)=(inp_selector_sector.sector_id)	AND inp_selector_sector.cur_user="current_user"());


DROP VIEW IF EXISTS "v_edit_inp_pipe" CASCADE;
CREATE VIEW "v_edit_inp_pipe" AS 
SELECT 
arc.arc_id, 
arc.arccat_id, 
arc.sector_id, 
v_arc.macrosector_id,
arc."state", 
arc.annotation, 
arc.custom_length, 
arc.the_geom,
inp_pipe.minorloss, 
inp_pipe.status, 
inp_pipe.custom_roughness, 
inp_pipe.custom_dint
FROM inp_selector_sector, arc
	JOIN v_arc ON v_arc.arc_id=arc.arc_id
	JOIN inp_pipe ON ((inp_pipe.arc_id) = (arc.arc_id))
	WHERE ((arc.sector_id)=(inp_selector_sector.sector_id)	AND inp_selector_sector.cur_user="current_user"());


	
DROP VIEW IF EXISTS "v_edit_inp_demand" CASCADE;
CREATE VIEW "v_edit_inp_demand" AS 
SELECT 
inp_demand.id,
node.node_id,
inp_demand.demand,
inp_demand.pattern_id,
deman_type,
inp_demand.dscenario_id
FROM inp_selector_sector, inp_selector_dscenario, node
	JOIN v_node ON v_node.node_id=node.node_id
	JOIN inp_demand ON ((inp_demand.node_id) = (node.node_id))
	WHERE ((node.sector_id)=(inp_selector_sector.sector_id)	AND inp_selector_sector.cur_user="current_user"())
	AND ((inp_demand.dscenario_id)=(inp_selector_dscenario.dscenario_id)	AND inp_selector_dscenario.cur_user="current_user"());
