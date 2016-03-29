/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- View structure for v_inp
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_curve" AS 
SELECT inp_curve.curve_id, inp_curve.x_value, inp_curve.y_value FROM SCHEMA_NAME.inp_curve ORDER BY inp_curve.id;


CREATE VIEW "SCHEMA_NAME"."v_inp_energy_el" AS 
SELECT 'PUMP'::text AS type_pump, inp_energy_el.pump_id, inp_energy_el.parameter, inp_energy_el.value FROM SCHEMA_NAME.inp_energy_el;


CREATE VIEW "SCHEMA_NAME"."v_inp_options" AS 
SELECT inp_options.units, inp_options.headloss, (((inp_options.hydraulics)::text || ' '::text) || (inp_options.hydraulics_fname)::text) AS hydraulics, inp_options.specific_gravity AS "specific gravity", inp_options.viscosity, inp_options.trials, inp_options.accuracy, (((inp_options.unbalanced)::text || ' '::text) || (inp_options.unbalanced_n)::text) AS unbalanced, inp_options.checkfreq, inp_options.maxcheck, inp_options.damplimit, inp_options.pattern, inp_options.demand_multiplier AS "demand multiplier", inp_options.emitter_exponent AS "emitter exponent", CASE WHEN inp_options.quality::text = 'TRACE'::text THEN ((inp_options.quality::text || ' '::text) || inp_options.node_id::text)::character varying ELSE inp_options.quality END AS quality, inp_options.diffusivity, inp_options.tolerance FROM SCHEMA_NAME.inp_options;


CREATE VIEW "SCHEMA_NAME"."v_inp_report" AS 
SELECT inp_report.pagesize,inp_report.status,inp_report.summary,inp_report.energy,inp_report.nodes,inp_report.links,inp_report.elevation,inp_report.demand,inp_report.head,inp_report.pressure,inp_report.quality,inp_report."length",inp_report.diameter,inp_report.flow,inp_report.velocity,inp_report.headloss,inp_report.setting,inp_report.reaction,inp_report.f_factor AS "f-factor" FROM SCHEMA_NAME.inp_report;


CREATE VIEW "SCHEMA_NAME"."v_inp_rules" AS 
SELECT inp_rules.text FROM SCHEMA_NAME.inp_rules ORDER BY inp_rules.id;


CREATE VIEW "SCHEMA_NAME"."v_inp_times" AS 
SELECT inp_times.duration, inp_times.hydraulic_timestep AS "hydraulic timestep", inp_times.quality_timestep AS "quality timestep", inp_times.rule_timestep AS "rule timestep", inp_times.pattern_timestep AS "pattern timestep", inp_times.pattern_start AS "pattern start", inp_times.report_timestep AS "report timestep", inp_times.report_start AS "report start", inp_times.start_clocktime AS "start clocktime", inp_times.statistic FROM SCHEMA_NAME.inp_times;



-- ------------------------------------------------------------------
-- View structure for v_inp ARC & NODE  (SELECTED BY STATE SELECTION)
-- ------------------------------------------------------------------


CREATE VIEW "SCHEMA_NAME"."v_inp_mixing" AS 
SELECT inp_mixing.node_id, inp_mixing.mix_type, inp_mixing.value, sector_selection.sector_id 
FROM (((SCHEMA_NAME.inp_mixing JOIN SCHEMA_NAME.node ON (((inp_mixing.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_demand" AS 
SELECT inp_demand.node_id, inp_demand.demand, inp_demand.pattern_id, inp_demand.deman_type, sector_selection.sector_id FROM (((SCHEMA_NAME.inp_demand 
JOIN SCHEMA_NAME.node ON (((inp_demand.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_source" AS 
SELECT inp_source.node_id, inp_source.sourc_type, inp_source.quality, inp_source.pattern_id, sector_selection.sector_id FROM (((SCHEMA_NAME.inp_source JOIN SCHEMA_NAME.node ON (((inp_source.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_status" AS 
SELECT inp_valve.node_id, inp_valve.status FROM ((SCHEMA_NAME.inp_valve
JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (inp_valve.node_id)::text)))
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)))
WHERE inp_valve.status::text = 'OPEN'::text OR inp_valve.status::text = 'CLOSED'::text;


CREATE VIEW "SCHEMA_NAME"."v_inp_status_pump" AS 
SELECT inp_pump.node_id, inp_pump.status FROM ((SCHEMA_NAME.inp_pump
JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (inp_pump.node_id)::text)))
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)))
WHERE inp_pump.status::text = 'OPEN'::text OR inp_pump.status::text = 'CLOSED'::text;


CREATE VIEW "SCHEMA_NAME"."v_inp_emitter" AS 
SELECT inp_emitter.node_id, inp_emitter.coef, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id 
FROM (((SCHEMA_NAME.inp_emitter 
JOIN SCHEMA_NAME.node ON (((inp_emitter.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text))); 


CREATE VIEW "SCHEMA_NAME"."v_inp_junction" AS 
SELECT inp_junction.node_id, (node.elevation-node."depth")::numeric(12,4), elevation, inp_junction.demand, inp_junction.pattern_id, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id 
FROM (((SCHEMA_NAME.inp_junction 
JOIN SCHEMA_NAME.node ON ((inp_junction.node_id)::text = (node.node_id)::text))
JOIN SCHEMA_NAME.sector_selection ON ((node.sector_id)::text = (sector_selection.sector_id)::text))
JOIN SCHEMA_NAME.state_selection ON ((node."state")::text = (state_selection.id)::text))
UNION
SELECT inp_junction.node_id, (temp_node.elevation-temp_node."depth")::numeric(12,4), elevation, inp_junction.demand, inp_junction.pattern_id, (st_x(temp_node.the_geom))::numeric(16,3) AS xcoord, (st_y(temp_node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id 
FROM (((SCHEMA_NAME.inp_junction 
JOIN SCHEMA_NAME.temp_node ON ((inp_junction.node_id)::text = (temp_node.node_id)::text))
JOIN SCHEMA_NAME.sector_selection ON ((temp_node.sector_id)::text = (sector_selection.sector_id)::text))
JOIN SCHEMA_NAME.state_selection ON ((temp_node."state")::text = (state_selection.id)::text))
ORDER BY node_id;


CREATE VIEW "SCHEMA_NAME"."v_inp_reservoir" AS 
SELECT inp_reservoir.node_id, inp_reservoir.head, inp_reservoir.pattern_id, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id 
FROM (((SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_reservoir ON (((inp_reservoir.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text))) ;


CREATE VIEW "SCHEMA_NAME"."v_inp_tank" AS 
SELECT inp_tank.node_id, node.elevation, inp_tank.initlevel, inp_tank.minlevel, inp_tank.maxlevel, inp_tank.diameter, inp_tank.minvol, inp_tank.curve_id, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, sector_selection.sector_id 
FROM (((SCHEMA_NAME.inp_tank JOIN SCHEMA_NAME.node ON (((inp_tank.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text))) ;


CREATE VIEW "SCHEMA_NAME"."v_inp_shortpipe" AS 
SELECT node.node_id, temp_arc.node_1, temp_arc.node_2, (st_length2d(temp_arc.the_geom))::numeric(16,3) AS length, 
cat_node.dint AS diameter, cat_mat_node.roughness, inp_shortpipe.minorloss, inp_shortpipe.status, sector_selection.sector_id 
FROM ((((((SCHEMA_NAME.temp_nodearcnode 
JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (temp_nodearcnode.node_id)::text))
JOIN SCHEMA_NAME.inp_shortpipe ON (((inp_shortpipe.node_id)::text = (temp_nodearcnode.node_id)::text)))
JOIN SCHEMA_NAME.cat_node ON (((cat_node.id)::text = (node.nodecat_id)::text)))
JOIN SCHEMA_NAME.cat_mat_node ON (((cat_mat_node.id)::text = (cat_node.matcat_id)::text)))
JOIN SCHEMA_NAME.temp_arc ON (((temp_arc.arc_id)::text = (temp_nodearcnode.arc_id)::text)))  
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_pump" AS 
SELECT inp_pump.node_id, temp_arc.node_1, temp_arc.node_2, 
(('POWER'::text || ' '::text) || (inp_pump.power)::text) AS power, 
(('HEAD'::text || ' '::text) || (inp_pump.curve_id)::text) AS head, (('SPEED'::text || ' '::text) || inp_pump.speed) AS speed, 
(('PATTERN'::text || ' '::text) || (inp_pump.pattern)::text) AS pattern, 
sector_selection.sector_id 
FROM ((((SCHEMA_NAME.temp_nodearcnode 
JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (temp_nodearcnode.node_id)::text))) 
JOIN SCHEMA_NAME.temp_arc ON (((temp_arc.arc_id)::text = (temp_nodearcnode.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_pump ON (((node.node_id)::text = (inp_pump.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text));


CREATE VIEW "SCHEMA_NAME"."v_inp_valve_cu" AS 
SELECT inp_valve.node_id, temp_arc.node_1, temp_arc.node_2, cat_node.dint AS diameter, inp_valve.valv_type, inp_valve.curve_id, inp_valve.minorloss, sector_selection.sector_id 
FROM ((((((SCHEMA_NAME.temp_nodearcnode 
JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (temp_nodearcnode.node_id)::text))) 
JOIN SCHEMA_NAME.cat_node ON (((cat_node.id)::text = (node.nodecat_id)::text)))
JOIN SCHEMA_NAME.temp_arc ON (((temp_arc.arc_id)::text = (temp_nodearcnode.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_valve ON (((node.node_id)::text = (inp_valve.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)))  
WHERE ((inp_valve.valv_type)::text = 'GPV'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_valve_fl" AS 
SELECT inp_valve.node_id, temp_arc.node_1, temp_arc.node_2, cat_node.dint AS diameter, inp_valve.valv_type, inp_valve.curve_id, inp_valve.minorloss, sector_selection.sector_id 
FROM ((((((SCHEMA_NAME.temp_nodearcnode 
JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (temp_nodearcnode.node_id)::text))) 
JOIN SCHEMA_NAME.cat_node ON (((cat_node.id)::text = (node.nodecat_id)::text)))
JOIN SCHEMA_NAME.temp_arc ON (((temp_arc.arc_id)::text = (temp_nodearcnode.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_valve ON (((node.node_id)::text = (inp_valve.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)))  
WHERE ((inp_valve.valv_type)::text = 'FCV'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_valve_lc" AS 
SELECT inp_valve.node_id, temp_arc.node_1, temp_arc.node_2, cat_node.dint AS diameter, inp_valve.valv_type, inp_valve.curve_id, inp_valve.minorloss, sector_selection.sector_id 
FROM ((((((SCHEMA_NAME.temp_nodearcnode 
JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (temp_nodearcnode.node_id)::text))) 
JOIN SCHEMA_NAME.cat_node ON (((cat_node.id)::text = (node.nodecat_id)::text)))
JOIN SCHEMA_NAME.temp_arc ON (((temp_arc.arc_id)::text = (temp_nodearcnode.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_valve ON (((node.node_id)::text = (inp_valve.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)))  
WHERE ((inp_valve.valv_type)::text = 'TCV'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_valve_pr" AS 
SELECT inp_valve.node_id, temp_arc.node_1, temp_arc.node_2, cat_node.dint AS diameter, inp_valve.valv_type, inp_valve.curve_id, inp_valve.minorloss, sector_selection.sector_id 
FROM ((((((SCHEMA_NAME.temp_nodearcnode 
JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (temp_nodearcnode.node_id)::text))) 
JOIN SCHEMA_NAME.cat_node ON (((cat_node.id)::text = (node.nodecat_id)::text)))
JOIN SCHEMA_NAME.temp_arc ON (((temp_arc.arc_id)::text = (temp_nodearcnode.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_valve ON (((node.node_id)::text = (inp_valve.node_id)::text))) 
JOIN SCHEMA_NAME.sector_selection ON (((node.sector_id)::text = (sector_selection.sector_id)::text)))
JOIN SCHEMA_NAME.state_selection ON (((node."state")::text = (state_selection.id)::text)))  
WHERE ((((inp_valve.valv_type)::text = 'PRV'::text) OR ((inp_valve.valv_type)::text = 'PSV'::text)) OR ((inp_valve.valv_type)::text = 'PBV'::text));


CREATE VIEW "SCHEMA_NAME"."v_inp_pipe" AS
SELECT
arc.arc_id, 
arc.node_1, 
arc.node_2, 
(st_length2d(arc.the_geom))::numeric(16,3) AS length,
arc.arccat_id,
arc.sector_id,
arc.state,
cat_arc.dint AS diameter, 
cat_mat_arc.roughness, 
inp_pipe.minorloss, 
inp_pipe.status
FROM "SCHEMA_NAME".arc
JOIN SCHEMA_NAME.inp_pipe ON (((arc.arc_id)::text = (inp_pipe.arc_id)::text))
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text))  
JOIN SCHEMA_NAME.cat_mat_arc ON (((cat_arc.matcat_id)::text = (cat_mat_arc.id)::text))
JOIN SCHEMA_NAME.state_selection ON (((arc."state")::text = (state_selection.id)::text)) 
JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text))
WHERE arc.arc_id NOT IN (SELECT arc_id FROM SCHEMA_NAME.temp_arc WHERE arc_id IS NOT NULL)
UNION
SELECT
arc.arc_id, 
arc.node_1, 
arc.node_2, 
(st_length2d(arc.the_geom))::numeric(16,3) AS length,
arc.arccat_id,
arc.sector_id,
arc.state,
cat_arc.dint AS diameter, 
cat_mat_arc.roughness, 
inp_pipe.minorloss, 
inp_pipe.status
FROM "SCHEMA_NAME".temp_arc arc
JOIN SCHEMA_NAME.inp_pipe ON (((arc.arc_id)::text = (inp_pipe.arc_id)::text))
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text))  
JOIN SCHEMA_NAME.cat_mat_arc ON (((cat_arc.matcat_id)::text = (cat_mat_arc.id)::text))
JOIN SCHEMA_NAME.state_selection ON (((arc."state")::text = (state_selection.id)::text)) 
JOIN SCHEMA_NAME.sector_selection ON (((arc.sector_id)::text = (sector_selection.sector_id)::text));


-- CREATE OR REPLACE VIEW SCHEMA_NAME.v_inp_vertice AS 
 (SELECT nextval('SCHEMA_NAME.inp_vertice_id_seq'::regclass) AS id, 
    arc.arc_id, 
    st_x(arc.point)::numeric(16,3) AS xcoord, 
    st_y(arc.point)::numeric(16,3) AS ycoord
   FROM ( SELECT (st_dumppoints(arc_1.the_geom)).geom AS point, 
            st_startpoint(arc_1.the_geom) AS startpoint, 
            st_endpoint(arc_1.the_geom) AS endpoint, 
            arc_1.sector_id, 
            arc_1.arc_id
           FROM SCHEMA_NAME.arc arc_1) arc
   JOIN SCHEMA_NAME.sector_selection ON arc.sector_id::text = sector_selection.sector_id::text
  WHERE ((arc.point < arc.startpoint OR arc.point > arc.startpoint) AND (arc.point < arc.endpoint OR arc.point > arc.endpoint)) AND
	  arc.arc_id NOT IN (SELECT arc_id FROM SCHEMA_NAME.temp_arc WHERE arc_id IS NOT NULL)
 UNION
  SELECT nextval('SCHEMA_NAME.inp_vertice_id_seq'::regclass) AS id, 
    arc.arc_id, 
    st_x(arc.point)::numeric(16,3) AS xcoord, 
    st_y(arc.point)::numeric(16,3) AS ycoord
   FROM ( SELECT (st_dumppoints(arc_1.the_geom)).geom AS point, 
            st_startpoint(arc_1.the_geom) AS startpoint, 
            st_endpoint(arc_1.the_geom) AS endpoint, 
            arc_1.sector_id, 
            arc_1.arc_id
           FROM SCHEMA_NAME.temp_arc arc_1) arc
   JOIN SCHEMA_NAME.sector_selection ON arc.sector_id::text = sector_selection.sector_id::text
  WHERE ((arc.point < arc.startpoint OR arc.point > arc.startpoint) AND (arc.point < arc.endpoint OR arc.point > arc.endpoint)))
  ORDER BY id;



-- ----------------------------
-- View structure for v_rpt_
-- ----------------------------


CREATE VIEW "SCHEMA_NAME"."v_rpt_arc" AS 
SELECT arc.arc_id, result_selection.result_id, max(rpt_arc.flow) AS max_flow, min(rpt_arc.flow) AS min_flow, max(rpt_arc.vel) AS max_vel, min(rpt_arc.vel) AS min_vel, max(rpt_arc.headloss) AS max_headloss, min(rpt_arc.headloss) AS min_headloss, max(rpt_arc.setting) AS max_setting, min(rpt_arc.setting) AS min_setting, max(rpt_arc.reaction) AS max_reaction, min(rpt_arc.reaction) AS min_reaction, max(rpt_arc.ffactor) AS max_ffactor, min(rpt_arc.ffactor) AS min_ffactor, arc.the_geom FROM ((SCHEMA_NAME.arc JOIN SCHEMA_NAME.rpt_arc ON (((rpt_arc.arc_id)::text = (arc.arc_id)::text))) JOIN SCHEMA_NAME.result_selection ON (((rpt_arc.result_id)::text = (result_selection.result_id)::text))) GROUP BY arc.arc_id, result_selection.result_id, arc.the_geom ORDER BY arc.arc_id;


CREATE VIEW "SCHEMA_NAME"."v_rpt_energy_usage" AS 
SELECT rpt_energy_usage.id, rpt_energy_usage.result_id, rpt_energy_usage.node_id, rpt_energy_usage.usage_fact, rpt_energy_usage.avg_effic, rpt_energy_usage.kwhr_mgal, rpt_energy_usage.avg_kw, rpt_energy_usage.peak_kw, rpt_energy_usage.cost_day FROM (SCHEMA_NAME.result_selection JOIN SCHEMA_NAME.rpt_energy_usage ON (((result_selection.result_id)::text = (rpt_energy_usage.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_hydraulic_status" AS 
SELECT rpt_hydraulic_status.id, rpt_hydraulic_status.result_id, rpt_hydraulic_status."time", rpt_hydraulic_status.text FROM (SCHEMA_NAME.rpt_hydraulic_status JOIN SCHEMA_NAME.result_selection ON (((result_selection.result_id)::text = (rpt_hydraulic_status.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_node" AS 
SELECT node.node_id, result_selection.result_id, max(rpt_node.elevation) AS elevation, max(rpt_node.demand) AS max_demand, min(rpt_node.demand) AS min_demand, max(rpt_node.head) AS max_head, min(rpt_node.head) AS min_head, max(rpt_node.press) AS max_pressure, min(rpt_node.press) AS min_pressure, max(rpt_node.quality) AS max_quality, min(rpt_node.quality) AS min_quality, node.the_geom FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.rpt_node ON (((rpt_node.node_id)::text = (node.node_id)::text))) JOIN SCHEMA_NAME.result_selection ON (((rpt_node.result_id)::text = (result_selection.result_id)::text))) GROUP BY node.node_id, result_selection.result_id, node.the_geom ORDER BY node.node_id;

