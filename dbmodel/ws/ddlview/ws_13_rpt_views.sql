/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- View structure for v_rpt_result
-- ----------------------------

DROP VIEW IF EXISTS "v_rpt_arc" CASCADE; 
CREATE VIEW "v_rpt_arc" AS 
SELECT 
arc.arc_id, 
rpt_selector_result.result_id, 
arc.arc_type,
arc.arccat_id,
max(rpt_arc.flow) AS max_flow, 
min(rpt_arc.flow) AS min_flow, 
max(rpt_arc.vel) AS max_vel, 
min(rpt_arc.vel) AS min_vel, 
max(rpt_arc.headloss) AS max_headloss, 
min(rpt_arc.headloss) AS min_headloss, 
max(rpt_arc.headloss::double precision / (st_length2d(arc.the_geom) * 10::double precision+0.1))::numeric(12,2) AS max_uheadloss,
min(rpt_arc.headloss::double precision / (st_length2d(arc.the_geom) * 10::double precision+0.1))::numeric(12,2) AS min_uheadloss,
max(rpt_arc.setting) AS max_setting, 
min(rpt_arc.setting) AS min_setting, 
max(rpt_arc.reaction) AS max_reaction, 
min(rpt_arc.reaction) AS min_reaction, 
max(rpt_arc.ffactor) AS max_ffactor, 
min(rpt_arc.ffactor) AS min_ffactor, arc.the_geom 
FROM rpt_selector_result,rpt_inp_arc arc
JOIN rpt_arc ON ((rpt_arc.arc_id) = (arc.arc_id))
WHERE ((rpt_arc.result_id) = (rpt_selector_result.result_id))
AND rpt_selector_result.cur_user="current_user"()
GROUP BY arc.arc_id, arc_type, arccat_id, rpt_selector_result.result_id, arc.the_geom 
ORDER BY arc.arc_id;


DROP VIEW IF EXISTS "v_rpt_energy_usage" CASCADE;
CREATE VIEW "v_rpt_energy_usage" AS 
SELECT 
rpt_energy_usage.id, 
rpt_energy_usage.result_id, 
rpt_energy_usage.nodarc_id, 
rpt_energy_usage.usage_fact, 
rpt_energy_usage.avg_effic, 
rpt_energy_usage.kwhr_mgal, 
rpt_energy_usage.avg_kw, 
rpt_energy_usage.peak_kw, 
rpt_energy_usage.cost_day 
FROM rpt_energy_usage,rpt_selector_result 
WHERE ((rpt_selector_result.result_id) = (rpt_energy_usage.result_id))
AND rpt_selector_result.cur_user="current_user"()
GROUP BY rpt_energy_usage.id,  rpt_selector_result.result_id;


DROP VIEW IF EXISTS "v_rpt_hydraulic_status" CASCADE;
CREATE VIEW "v_rpt_hydraulic_status" AS 
SELECT 
rpt_hydraulic_status.id, 
rpt_hydraulic_status.result_id, 
rpt_hydraulic_status."time", 
rpt_hydraulic_status.text 
FROM rpt_hydraulic_status,rpt_selector_result  
WHERE ((rpt_selector_result.result_id) = (rpt_hydraulic_status.result_id))
AND rpt_selector_result.cur_user="current_user"()
GROUP BY rpt_hydraulic_status.id, rpt_selector_result.result_id;


DROP VIEW IF EXISTS "v_rpt_node" CASCADE;
CREATE VIEW "v_rpt_node" AS 
SELECT 
node.node_id, 
rpt_selector_result.result_id,
node.node_type,
node.nodecat_id,
max(rpt_node.elevation) AS elevation, 
max(rpt_node.demand) AS max_demand, 
min(rpt_node.demand) AS min_demand, 
max(rpt_node.head) AS max_head, 
min(rpt_node.head) AS min_head, 
max(rpt_node.press) AS max_pressure, 
min(rpt_node.press) AS min_pressure, 
max(rpt_node.quality) AS max_quality, 
min(rpt_node.quality) AS min_quality, 
node.the_geom 
FROM rpt_selector_result, rpt_inp_node node
JOIN rpt_node ON ((rpt_node.node_id) = (node.node_id))
WHERE ((rpt_node.result_id) = (rpt_selector_result.result_id))
AND rpt_selector_result.cur_user="current_user"()
GROUP BY node.node_id, node_type, nodecat_id, rpt_selector_result.result_id, node.the_geom ORDER BY node.node_id;


DROP VIEW IF EXISTS "v_rpt_arc_all" CASCADE;
CREATE VIEW "v_rpt_arc_all" AS
SELECT
rpt_arc.id,
arc.arc_id,
rpt_selector_result.result_id,
arc.arc_type,
arc.arccat_id,
rpt_arc.flow, 
rpt_arc.vel, 
rpt_arc.headloss,
rpt_arc.setting,
rpt_arc.ffactor, 
(now()::date+rpt_arc.time::interval) as time,  
arc.the_geom
FROM rpt_selector_result, rpt_inp_arc arc
JOIN rpt_arc ON rpt_arc.arc_id = arc.arc_id
WHERE ((rpt_arc.result_id) = (rpt_selector_result.result_id))
AND rpt_selector_result.cur_user="current_user"()
ORDER BY 9,2;


DROP VIEW IF EXISTS "v_rpt_node_all"CASCADE;
CREATE VIEW "v_rpt_node_all" AS 
SELECT 
rpt_node.id,
node.node_id, 
node.node_type,
node.nodecat_id,
rpt_selector_result.result_id,
rpt_node.elevation, 
rpt_node.demand, 
rpt_node.head, 
rpt_node.press, 
rpt_node.quality, 
(now()::date+rpt_node.time::interval) as time, 
node.the_geom 
FROM rpt_selector_result, rpt_inp_node node
JOIN rpt_node ON ((rpt_node.node_id) = (node.node_id))
WHERE ((rpt_node.result_id) = (rpt_selector_result.result_id))
AND rpt_selector_result.cur_user="current_user"()
ORDER BY 9,2;



CREATE OR REPLACE VIEW v_rpt_arc_hourly AS
SELECT rpt_arc.id,
arc.arc_id,
rpt_selector_result.result_id,
rpt_arc.flow,
rpt_arc.vel,
rpt_arc.headloss,
rpt_arc.setting,
rpt_arc.ffactor,
rpt_arc.time,
arc.the_geom
FROM rpt_selector_result, rpt_selector_hourly, rpt_inp_arc arc
JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
WHERE rpt_arc.result_id::text = rpt_selector_result.result_id::text
AND rpt_arc.time=rpt_selector_hourly.time
AND rpt_selector_result.cur_user = "current_user"()::text
AND rpt_selector_hourly.cur_user = "current_user"()::text
ORDER BY time, arc.arc_id;

 


CREATE OR REPLACE VIEW v_rpt_node_hourly AS
SELECT rpt_node.id,
node.node_id,
rpt_selector_result.result_id,
rpt_node.elevation,
rpt_node.demand,
rpt_node.head,
rpt_node.press,
rpt_node.quality,
rpt_node.time,
node.the_geom
FROM rpt_selector_result, rpt_selector_hourly, rpt_inp_node node
JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
WHERE rpt_node.result_id::text = rpt_selector_result.result_id::text
AND rpt_node.time=rpt_selector_hourly.time
AND rpt_selector_result.cur_user = "current_user"()::text
AND rpt_selector_hourly.cur_user = "current_user"()::text
ORDER BY rpt_node.time, node.node_id;




-- ----------------------------
-- View structure for v_rpt_compare
-- ----------------------------

DROP VIEW IF EXISTS "v_rpt_comp_arc" CASCADE; 
CREATE VIEW "v_rpt_comp_arc" AS 
SELECT 
arc.arc_id, 
rpt_selector_compare.result_id, 


max(rpt_arc.flow) AS max_flow, 
min(rpt_arc.flow) AS min_flow, 
max(rpt_arc.vel) AS max_vel, 
min(rpt_arc.vel) AS min_vel, 
max(rpt_arc.headloss) AS max_headloss, min(rpt_arc.headloss) AS min_headloss, 
max(rpt_arc.headloss::double precision / (st_length2d(arc.the_geom) * 10::double precision+0.1))::numeric(12,2) AS max_uheadloss,
min(rpt_arc.headloss::double precision / (st_length2d(arc.the_geom) * 10::double precision+0.1))::numeric(12,2) AS min_uheadloss,
max(rpt_arc.setting) AS max_setting, 
min(rpt_arc.setting) AS min_setting, 
max(rpt_arc.reaction) AS max_reaction,
 min(rpt_arc.reaction) AS min_reaction, 
max(rpt_arc.ffactor) AS max_ffactor, 
min(rpt_arc.ffactor) AS min_ffactor, arc.the_geom 
FROM rpt_selector_compare, rpt_inp_arc arc
JOIN rpt_arc ON ((rpt_arc.arc_id) = (arc.arc_id))
WHERE ((rpt_arc.result_id) = (rpt_selector_compare.result_id))
AND rpt_selector_compare.cur_user="current_user"()
GROUP BY arc.arc_id,  arc_type, arccat_id, rpt_selector_compare.result_id, arc.the_geom 
ORDER BY arc.arc_id;


DROP VIEW IF EXISTS "v_rpt_comp_energy_usage" CASCADE;
CREATE VIEW "v_rpt_comp_energy_usage" AS 
SELECT 
rpt_energy_usage.id, 
rpt_energy_usage.result_id, 
rpt_energy_usage.nodarc_id, 
rpt_energy_usage.usage_fact, 
rpt_energy_usage.avg_effic, 
rpt_energy_usage.kwhr_mgal, 
rpt_energy_usage.avg_kw, 
rpt_energy_usage.peak_kw, 
rpt_energy_usage.cost_day 
FROM rpt_energy_usage,rpt_selector_compare 
WHERE ((rpt_selector_compare.result_id) = (rpt_energy_usage.result_id))
AND rpt_selector_compare.cur_user="current_user"();


DROP VIEW IF EXISTS "v_rpt_comp_hydraulic_status" CASCADE;
CREATE VIEW "v_rpt_comp_hydraulic_status" AS 
SELECT 
rpt_hydraulic_status.id, 
rpt_hydraulic_status.result_id, 
rpt_hydraulic_status."time", 
rpt_hydraulic_status.text 
FROM rpt_hydraulic_status ,rpt_selector_compare
WHERE ((rpt_selector_compare.result_id) = (rpt_hydraulic_status.result_id))
AND rpt_selector_compare.cur_user="current_user"();


DROP VIEW IF EXISTS "v_rpt_comp_node" CASCADE;
CREATE VIEW "v_rpt_comp_node" AS 
SELECT 
node.node_id, 
rpt_selector_compare.result_id, 
node.node_type,
node.nodecat_id,
max(rpt_node.elevation) AS elevation, 
max(rpt_node.demand) AS max_demand, 
min(rpt_node.demand) AS min_demand, 
max(rpt_node.head) AS max_head, 
min(rpt_node.head) AS min_head, 
max(rpt_node.press) AS max_pressure, 
min(rpt_node.press) AS min_pressure, 
max(rpt_node.quality) AS max_quality, 
min(rpt_node.quality) AS min_quality, node.the_geom 
FROM rpt_selector_compare, rpt_inp_node node
JOIN rpt_node ON ((rpt_node.node_id) = (node.node_id))
WHERE ((rpt_node.result_id) = (rpt_selector_compare.result_id))
AND rpt_selector_compare.cur_user="current_user"()
GROUP BY node.node_id,  node_type, nodecat_id, rpt_selector_compare.result_id, node.the_geom 
ORDER BY node.node_id;



CREATE OR REPLACE VIEW v_rpt_comp_arc_hourly AS
SELECT rpt_arc.id,
arc.arc_id,
rpt_selector_compare.result_id,
rpt_arc.flow,
rpt_arc.vel,
rpt_arc.headloss,
rpt_arc.setting,
rpt_arc.ffactor,
rpt_arc.time,
arc.the_geom
FROM rpt_selector_compare, rpt_selector_hourly, rpt_inp_arc arc
JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
WHERE rpt_arc.result_id::text = rpt_selector_compare.result_id::text
AND rpt_arc.time=rpt_selector_hourly.time
AND rpt_selector_compare.cur_user = "current_user"()::text
AND rpt_selector_hourly.cur_user = "current_user"()::text
ORDER BY time, arc.arc_id;


CREATE OR REPLACE VIEW v_rpt_comp_node_hourly AS
SELECT rpt_node.id,
node.node_id,
rpt_selector_compare.result_id,
rpt_node.elevation,
rpt_node.demand,
rpt_node.head,
rpt_node.press,
rpt_node.quality,
rpt_node.time,
node.the_geom
FROM rpt_selector_compare, rpt_selector_hourly, rpt_inp_node node
JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
WHERE rpt_node.result_id::text = rpt_selector_compare.result_id::text
AND rpt_node.time=rpt_selector_hourly.time
AND rpt_selector_compare.cur_user = "current_user"()::text
AND rpt_selector_hourly.cur_user = "current_user"()::text
ORDER BY rpt_node.time, node.node_id;

