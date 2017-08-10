/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

	 
	 
-- ----------------------------
-- View structure for v_inp
-- ----------------------------
DROP VIEW IF EXISTS "v_inp_curve" CASCADE;
CREATE VIEW "v_inp_curve" AS 
SELECT inp_curve.curve_id, inp_curve.x_value, inp_curve.y_value FROM inp_curve ORDER BY inp_curve.id;


DROP VIEW IF EXISTS "v_inp_energy_el" CASCADE;
CREATE VIEW "v_inp_energy_el" AS 
SELECT 'PUMP' AS type_pump, inp_energy_el.pump_id, inp_energy_el.parameter, inp_energy_el.value FROM inp_energy_el;


DROP VIEW IF EXISTS "v_inp_options" CASCADE;
CREATE VIEW "v_inp_options" AS 
SELECT inp_options.units, inp_options.headloss, (((inp_options.hydraulics) || ' ') || (inp_options.hydraulics_fname)) AS hydraulics, 
inp_options.specific_gravity AS "specific gravity", inp_options.viscosity, inp_options.trials, inp_options.accuracy, 
(((inp_options.unbalanced) || ' ') || (inp_options.unbalanced_n)) AS unbalanced, inp_options.checkfreq, inp_options.maxcheck, 
inp_options.damplimit, inp_options.pattern, inp_options.demand_multiplier AS "demand multiplier", inp_options.emitter_exponent AS "emitter exponent", 
CASE WHEN inp_options.quality = 'TRACE' THEN ((inp_options.quality || ' ') || inp_options.node_id)::character varying ELSE inp_options.quality END AS quality, 
inp_options.diffusivity, inp_options.tolerance FROM inp_options;


DROP VIEW IF EXISTS "v_inp_report" CASCADE;
CREATE VIEW "v_inp_report" AS 
SELECT inp_report.pagesize,inp_report.status,inp_report.summary,inp_report.energy,inp_report.nodes,inp_report.links,inp_report.elevation,inp_report.demand,
inp_report.head,inp_report.pressure,inp_report.quality,inp_report."length",inp_report.diameter,inp_report.flow,inp_report.velocity,inp_report.headloss,
inp_report.setting,inp_report.reaction,inp_report.f_factor AS "f-factor" FROM inp_report;


DROP VIEW IF EXISTS "v_inp_rules" CASCADE;
CREATE VIEW "v_inp_rules" AS 
SELECT inp_rules_x_arc.id, text 
FROM inp_rules_x_arc
	JOIN temp_arc on inp_rules_x_arc.arc_id=temp_arc.arc_id
	JOIN inp_selector_sector ON temp_arc.sector_id=inp_selector_sector.sector_id
UNION
SELECT inp_rules_x_node.id, text 
FROM inp_rules_x_node 
	JOIN temp_node on inp_rules_x_node.node_id=temp_node.node_id
	JOIN inp_selector_sector ON temp_node.sector_id=inp_selector_sector.sector_id
ORDER BY id;


DROP VIEW IF EXISTS "v_inp_times" CASCADE; 
CREATE VIEW "v_inp_times" AS 
SELECT inp_times.duration, inp_times.hydraulic_timestep AS "hydraulic timestep", inp_times.quality_timestep AS "quality timestep", 
inp_times.rule_timestep AS "rule timestep", inp_times.pattern_timestep AS "pattern timestep", inp_times.pattern_start AS "pattern start", 
inp_times.report_timestep AS "report timestep", inp_times.report_start AS "report start", inp_times.start_clocktime AS "start clocktime", 
inp_times.statistic FROM inp_times;




-- ------------------------------------------------------------------
-- View structure for v_inp ARC & NODE  (SELECTED BY STATE SELECTION)
-- ------------------------------------------------------------------

DROP VIEW IF EXISTS "v_inp_mixing" CASCADE;
CREATE VIEW "v_inp_mixing" AS 
SELECT 
	inp_mixing.node_id, inp_mixing.mix_type, inp_mixing.value, inp_selector_sector.sector_id 
	FROM ((inp_mixing 
	JOIN v_node node ON (((inp_mixing.node_id) = (node.node_id)))) 
	JOIN inp_selector_sector ON (((node.sector_id) = (inp_selector_sector.sector_id))));


DROP VIEW IF EXISTS "v_inp_source" CASCADE;
CREATE VIEW "v_inp_source" AS 
SELECT 
	inp_source.node_id, inp_source.sourc_type, inp_source.quality, inp_source.pattern_id, inp_selector_sector.sector_id 
	FROM ((inp_source 
	JOIN v_node node ON (((inp_source.node_id) = (node.node_id)))) 
	JOIN inp_selector_sector ON (((node.sector_id) = (inp_selector_sector.sector_id))));


CREATE OR REPLACE VIEW v_inp_status AS
SELECT 
arc.arc_id,
inp_valve.status
FROM temp_arc arc
JOIN inp_valve ON arc.arc_id = concat(inp_valve.node_id, '_n2a')
WHERE inp_valve.status = 'OPEN' OR inp_valve.status = 'CLOSED'
UNION
SELECT 
arc.arc_id,
inp_pump.status
FROM temp_arc arc
JOIN inp_pump ON arc.arc_id = concat(inp_pump.node_id, '_n2a')
WHERE inp_pump.status = 'OPEN' OR inp_pump.status = 'CLOSED';


DROP VIEW IF EXISTS "v_inp_emitter" CASCADE;
CREATE VIEW "v_inp_emitter" AS 
SELECT 
	inp_emitter.node_id, inp_emitter.coef, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, 
	inp_selector_sector.sector_id 
	FROM ((inp_emitter 
	JOIN v_node node ON (((inp_emitter.node_id) = (node.node_id)))) 
	JOIN inp_selector_sector ON (((node.sector_id) = (inp_selector_sector.sector_id))));


DROP VIEW IF EXISTS "v_inp_reservoir" CASCADE;
CREATE VIEW "v_inp_reservoir" AS 
SELECT 
inp_reservoir.node_id, 
inp_reservoir.head, 
inp_reservoir.pattern_id, 
(st_x(node.the_geom))::numeric(16,3) AS xcoord, 
(st_y(node.the_geom))::numeric(16,3) AS ycoord, node.sector_id 
FROM temp_node node
	JOIN inp_reservoir ON (((inp_reservoir.node_id) = (node.node_id)));


DROP VIEW IF EXISTS "v_inp_tank" CASCADE;
CREATE VIEW "v_inp_tank" AS 
SELECT 
	inp_tank.node_id, node.elevation, inp_tank.initlevel, inp_tank.minlevel, inp_tank.maxlevel, inp_tank.diameter, inp_tank.minvol, 
	inp_tank.curve_id, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, node.sector_id 
	FROM (((inp_tank 
	JOIN v_node node ON (((inp_tank.node_id) = (node.node_id))))));


DROP VIEW IF EXISTS "v_inp_junction" CASCADE;
CREATE OR REPLACE VIEW v_inp_junction AS 
 SELECT node.node_id, 
node.elevation, 
(node.elevation - node.depth)::numeric(12,4) AS elev, 
inp_junction.demand, 
inp_junction.pattern_id, 
st_x(node.the_geom)::numeric(16,3) AS xcoord, 
st_y(node.the_geom)::numeric(16,3) AS ycoord, 
node.sector_id
   FROM v_node node
   LEFT JOIN inp_junction ON inp_junction.node_id = node.node_id
   WHERE epa_type='JUNCTION'
   ORDER BY node.node_id;


DROP VIEW IF EXISTS "v_inp_pump" CASCADE;
CREATE VIEW "v_inp_pump" AS 
SELECT 
	concat(inp_pump.node_id, '_n2a') AS arc_id,
	arc.node_1, 
	arc.node_2, 
	(('POWER' || ' ') || (inp_pump.power)) AS power, 
	(('HEAD' || ' ') || (inp_pump.curve_id)) AS head, (('SPEED' || ' ') || inp_pump.speed) AS speed, 
	(('PATTERN' || ' ') || (inp_pump.pattern)) AS pattern, 
	arc.sector_id 
	FROM temp_arc arc
	JOIN inp_pump ON arc.arc_id = concat(inp_pump.node_id, '_n2a');


DROP VIEW IF EXISTS v_inp_valve_cu CASCADE;
CREATE OR REPLACE VIEW v_inp_valve_cu AS 
SELECT 
	concat(inp_valve.node_id, '_n2a') AS arc_id,
arc.node_1,
arc.node_2,
cat_arc.dint AS diameter,
inp_valve.valv_type,
inp_valve.curve_id,
inp_valve.minorloss,
arc.sector_id
	FROM temp_arc arc
	JOIN inp_valve ON arc.arc_id = concat(inp_valve.node_id, '_n2a')
	JOIN cat_arc ON arc.arccat_id = cat_arc.id
	WHERE inp_valve.valv_type = 'GPV';
  

DROP VIEW IF EXISTS v_inp_valve_fl CASCADE;
CREATE OR REPLACE VIEW v_inp_valve_fl AS 
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
arc.node_1,
arc.node_2,
cat_arc.dint AS diameter,
inp_valve.valv_type,
inp_valve.flow,
inp_valve.minorloss,
arc.sector_id
FROM temp_arc arc
JOIN inp_valve ON arc.arc_id = concat(inp_valve.node_id, '_n2a')
JOIN cat_arc ON arc.arccat_id = cat_arc.id
	WHERE inp_valve.valv_type = 'FCV';


DROP VIEW IF EXISTS v_inp_valve_lc CASCADE;
CREATE OR REPLACE VIEW v_inp_valve_lc AS 
SELECT 
	concat(inp_valve.node_id, '_n2a') AS arc_id,
arc.node_1,
arc.node_2,
cat_arc.dint AS diameter,
inp_valve.valv_type,
inp_valve.coef_loss,
inp_valve.minorloss,
arc.sector_id
	FROM temp_arc arc
JOIN inp_valve ON arc.arc_id = concat(inp_valve.node_id, '_n2a')
JOIN cat_arc ON arc.arccat_id = cat_arc.id
	WHERE inp_valve.valv_type = 'TCV';


DROP VIEW IF EXISTS v_inp_valve_pr CASCADE;
CREATE OR REPLACE VIEW v_inp_valve_pr AS 
SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
arc.node_1,
arc.node_2,
cat_arc.dint AS diameter,
inp_valve.valv_type,
inp_valve.pressure,
inp_valve.minorloss,
arc.sector_id
FROM temp_arc arc
JOIN inp_valve ON arc.arc_id = concat(inp_valve.node_id, '_n2a')
JOIN cat_arc ON arc.arccat_id = cat_arc.id
WHERE inp_valve.valv_type = 'PRV' OR inp_valve.valv_type = 'PSV' OR inp_valve.valv_type = 'PBV';


DROP VIEW IF EXISTS v_inp_pipe CASCADE;
CREATE OR REPLACE VIEW v_inp_pipe AS 
SELECT arc.arc_id, 
arc.node_1, 
arc.node_2, 
CASE
	WHEN st_length2d(arc.the_geom)< 0.10 THEN 0.100::numeric(12,3)
	ELSE st_length2d(arc.the_geom)
END AS length, 
--arc.arccat_id, 
arc.sector_id, 
arc.state, 
CASE
	WHEN arc.builtdate IS NOT NULL THEN arc.builtdate
	ELSE now()::date
	END AS builtdate, 
CASE
	WHEN custom_dint IS NOT NULL THEN custom_dint
	ELSE dint
	END AS diameter, 
CASE
	WHEN custom_roughness IS NOT NULL THEN custom_roughness
	ELSE inp_cat_mat_roughness.roughness
	END AS roughness,  
inp_pipe.minorloss, 
inp_pipe.status
FROM temp_arc arc
   JOIN inp_pipe ON arc.arc_id = inp_pipe.arc_id
   JOIN cat_arc ON arc.arccat_id = cat_arc.id
   JOIN cat_mat_arc ON cat_arc.matcat_id = cat_mat_arc.id
   JOIN inp_cat_mat_roughness ON inp_cat_mat_roughness.matcat_id = cat_mat_arc.id 
   --where (now()::date - builtdate)/365 >= inp_cat_mat_roughness.init_age and (now()::date - builtdate)/365 < inp_cat_mat_roughness.end_age 
UNION 
SELECT 
arc.arc_id, 
arc.node_1, 
arc.node_2, 
CASE
	WHEN st_length2d(arc.the_geom) < 0.10 THEN 0.100::numeric(12,3)
	ELSE st_length2d(arc.the_geom)
END AS length, 
--arc.arccat_id, 
arc.sector_id, 
arc.state,
arc.builtdate, 
cat_arc.dint AS diameter, 
inp_cat_mat_roughness.roughness, 
inp_shortpipe.minorloss, 
inp_shortpipe.status
FROM temp_arc arc
   JOIN inp_shortpipe ON arc.arc_id = concat(inp_shortpipe.node_id, '_n2a')
   JOIN cat_arc ON arc.arccat_id = cat_arc.id
   JOIN cat_mat_arc ON cat_arc.matcat_id = cat_mat_arc.id
   JOIN inp_cat_mat_roughness ON inp_cat_mat_roughness.matcat_id = cat_mat_arc.id;
   --WHERE (now()::date - builtdate)/365 >= inp_cat_mat_roughness.init_age and (now()::date - builtdate)/365 < inp_cat_mat_roughness.end_age;



DROP VIEW IF EXISTS v_inp_vertice CASCADE;
CREATE OR REPLACE VIEW v_inp_vertice AS 
  SELECT nextval ('"SCHEMA_NAME".inp_vertice_id_seq'::regclass) AS id, 
arc.arc_id, 
st_x(arc.point)::numeric(16,3) AS xcoord, 
st_y(arc.point)::numeric(16,3) AS ycoord
   FROM ( SELECT (st_dumppoints(arc_1.the_geom)).geom AS point, 
st_startpoint(arc_1.the_geom) AS startpoint, 
st_endpoint(arc_1.the_geom) AS endpoint, 
arc_1.sector_id, 
arc_1.arc_id
   FROM temp_arc arc_1) arc
  WHERE ((arc.point < arc.startpoint OR arc.point > arc.startpoint) AND (arc.point < arc.endpoint OR arc.point > arc.endpoint))
  ORDER BY 1;

  

-- ----------------------------
-- Direct views from tables
-- ----------------------------

DROP VIEW IF EXISTS "v_inp_project_id" CASCADE;
CREATE VIEW "v_inp_project_id" AS
SELECT title,
author,
date
FROM inp_project_id
ORDER BY title;


DROP VIEW IF EXISTS "v_inp_tags" CASCADE;
CREATE VIEW "v_inp_tags" AS
SELECT object,
node_id,
tag
FROM inp_tags
ORDER BY object;


DROP VIEW IF EXISTS "v_inp_pattern" CASCADE;
CREATE VIEW "v_inp_pattern" AS
SELECT id,
pattern_id,
factor_1,
factor_2,
factor_3,
factor_4,
factor_5,
factor_6,
factor_7,
factor_8,
factor_9,
factor_10,
factor_11,
factor_12,
factor_13,
factor_14,
factor_15,
factor_16,
factor_17,
factor_18,
factor_19,
factor_20,
factor_21,
factor_22,
factor_23,
factor_24
FROM inp_pattern
ORDER BY id;


DROP VIEW IF EXISTS "v_inp_controls" CASCADE;
CREATE VIEW "v_inp_controls" AS 
SELECT inp_controls_x_arc.id, text 
FROM inp_controls_x_arc
	JOIN temp_arc on inp_controls_x_arc.arc_id=temp_arc.arc_id
	JOIN inp_selector_sector ON temp_arc.sector_id=inp_selector_sector.sector_id
UNION
SELECT inp_controls_x_node.id, text 
FROM inp_controls_x_node 
	JOIN temp_node on inp_controls_x_node.node_id=temp_node.node_id
	JOIN inp_selector_sector ON temp_node.sector_id=inp_selector_sector.sector_id
ORDER BY id;



DROP VIEW IF EXISTS "v_inp_energy_gl"  CASCADE;
CREATE VIEW "v_inp_energy_gl"  AS
SELECT id,
energ_type,
parameter,
value
FROM inp_energy_gl
ORDER BY id;


DROP VIEW IF EXISTS "v_inp_quality"  CASCADE;
CREATE VIEW "v_inp_quality"  AS
SELECT node_id,
initqual
FROM inp_quality
ORDER BY node_id;


DROP VIEW IF EXISTS "v_inp_reactions_el" CASCADE;
CREATE VIEW "v_inp_reactions_el"  AS
SELECT id,
parameter,
arc_id,
value
FROM inp_reactions_el
ORDER BY id;


DROP VIEW IF EXISTS "v_inp_reactions_gl" CASCADE;
CREATE VIEW "v_inp_reactions_gl"  AS
SELECT id,
react_type,
parameter,
value
FROM inp_reactions_gl
ORDER BY id;

DROP VIEW IF EXISTS "v_inp_label" CASCADE;
CREATE VIEW "v_inp_label"  AS
SELECT id,
xcoord,
ycoord,
label,
node_id
FROM inp_label
ORDER BY id;


DROP VIEW IF EXISTS "v_inp_backdrop" CASCADE;
CREATE VIEW "v_inp_backdrop"  AS
SELECT id,
text
FROM inp_backdrop
ORDER BY id;
  
  
