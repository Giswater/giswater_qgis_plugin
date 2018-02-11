/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

	 
	 
-- ----------------------------
-- View structure for v_inp
-- ----------------------------
DROP VIEW IF EXISTS "v_inp_curve" CASCADE;
CREATE OR REPLACE VIEW v_inp_curve AS
SELECT 
CASE 
	WHEN x_value is null THEN curve_type::varchar(16)
	ELSE curve_id END AS curve_id,
x_value::numeric(12,4),
y_value::numeric(12,4)

FROM (

SELECT DISTINCT ON (curve_id)
(SElECT min(sub.id)::integer AS min FROM inp_curve sub WHERE sub.curve_id = inp_curve.curve_id) AS id,
curve_id,
concat(';',inp_curve_id.curve_type,':') AS curve_type,
null as x_value,
null as y_value
   FROM inp_curve_id
   JOIN inp_curve ON inp_curve.curve_id=inp_curve_id.id

UNION
SELECT
inp_curve.id,
inp_curve.curve_id,
curve_type,
inp_curve.x_value,
inp_curve.y_value
   FROM inp_curve
   JOIN inp_curve_id ON inp_curve.curve_id=inp_curve_id.id
 ORDER BY id ASC ,x_value DESC 
 ) a;

 


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




DROP VIEW IF EXISTS "v_inp_demand" CASCADE;
CREATE VIEW "v_inp_demand" AS 
SELECT 
inp_demand.id,
inp_demand.node_id,
inp_demand.demand,
inp_demand.pattern_id,
inp_demand.deman_type
FROM inp_selector_dscenario, inp_selector_result, inp_demand
   JOIN rpt_inp_node ON inp_demand.node_id::text = rpt_inp_node.node_id::text
   WHERE inp_selector_dscenario.dscenario_id = inp_demand.dscenario_id AND inp_selector_dscenario.cur_user = "current_user"()::text
   AND inp_selector_result.result_id=rpt_inp_node.result_id AND inp_selector_result.cur_user = "current_user"()::text;
	

DROP VIEW IF EXISTS "v_inp_rules" CASCADE;
CREATE VIEW "v_inp_rules" AS 
SELECT 
inp_rules_x_arc.id, 
text 
FROM inp_selector_result, inp_rules_x_arc
	JOIN rpt_inp_arc on inp_rules_x_arc.arc_id=rpt_inp_arc.arc_id
    WHERE inp_selector_result.result_id=rpt_inp_arc.result_id AND inp_selector_result.cur_user=current_user

UNION
SELECT 
inp_rules_x_node.id, 
text 
FROM inp_selector_result, inp_rules_x_node 
	JOIN rpt_inp_node on inp_rules_x_node.node_id=rpt_inp_node.node_id
    WHERE inp_selector_result.result_id=rpt_inp_node.result_id AND inp_selector_result.cur_user=current_user

ORDER BY id;
	
	
DROP VIEW IF EXISTS "v_inp_controls" CASCADE;
CREATE VIEW "v_inp_controls" AS 
SELECT inp_controls_x_arc.id, text 
FROM inp_selector_result, inp_controls_x_arc
	JOIN rpt_inp_arc on inp_controls_x_arc.arc_id=rpt_inp_arc.arc_id
    WHERE inp_selector_result.result_id=rpt_inp_arc.result_id AND inp_selector_result.cur_user=current_user

UNION
SELECT inp_controls_x_node.id, text 
FROM inp_selector_result, inp_controls_x_node 
	JOIN rpt_inp_node on inp_controls_x_node.node_id=rpt_inp_node.node_id
    WHERE inp_selector_result.result_id=rpt_inp_node.result_id AND inp_selector_result.cur_user=current_user

ORDER BY id;



DROP VIEW IF EXISTS "v_inp_times" CASCADE; 
CREATE VIEW "v_inp_times" AS 
SELECT inp_times.duration, inp_times.hydraulic_timestep AS "hydraulic timestep", inp_times.quality_timestep AS "quality timestep", 
inp_times.rule_timestep AS "rule timestep", inp_times.pattern_timestep AS "pattern timestep", inp_times.pattern_start AS "pattern start", 
inp_times.report_timestep AS "report timestep", inp_times.report_start AS "report start", inp_times.start_clocktime AS "start clocktime", 
inp_times.statistic FROM inp_times;




-- ------------------------------------------------------------------
-- View structure for views from arc & node
-- ------------------------------------------------------------------

DROP VIEW IF EXISTS "v_inp_energy_el" CASCADE;
CREATE VIEW "v_inp_energy_el" AS 
SELECT 
inp_energy_el.id,
'PUMP'::text AS type_pump, 
inp_energy_el.pump_id, 
inp_energy_el.parameter, 
inp_energy_el.value 
FROM inp_selector_result, inp_energy_el
	JOIN rpt_inp_node ON inp_energy_el.pump_id=rpt_inp_node.node_id
	WHERE rpt_inp_node.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"()
	ORDER BY id;

	

DROP VIEW IF EXISTS "v_inp_reactions_el" CASCADE;
CREATE VIEW "v_inp_reactions_el"  AS
SELECT 
inp_reactions_el.id,
parameter,
inp_reactions_el.arc_id,
value
FROM inp_selector_result, inp_reactions_el
	JOIN rpt_inp_arc ON inp_reactions_el.arc_id=rpt_inp_arc.arc_id
	WHERE rpt_inp_arc.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"()
	ORDER BY id;



DROP VIEW IF EXISTS "v_inp_mixing" CASCADE;
CREATE VIEW "v_inp_mixing" AS 
SELECT 
inp_mixing.node_id, 
inp_mixing.mix_type, 
inp_mixing.value
FROM inp_selector_result, inp_mixing 
	JOIN rpt_inp_node ON inp_mixing.node_id=rpt_inp_node.node_id
	WHERE rpt_inp_node.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"();

	

DROP VIEW IF EXISTS "v_inp_source" CASCADE;
CREATE VIEW "v_inp_source" AS 
SELECT 
inp_source.node_id, 
inp_source.sourc_type, 
inp_source.quality, 
inp_source.pattern_id
FROM inp_selector_result, inp_source 
	JOIN rpt_inp_node ON inp_source.node_id=rpt_inp_node.node_id
	WHERE rpt_inp_node.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"();

	
DROP VIEW IF EXISTS "v_inp_status" CASCADE;
CREATE OR REPLACE VIEW "v_inp_status" AS
SELECT 
rpt_inp_arc.arc_id,
rpt_inp_arc.status
FROM inp_selector_result, rpt_inp_arc
	JOIN inp_valve ON rpt_inp_arc.arc_id = concat(inp_valve.node_id, '_n2a')
	WHERE rpt_inp_arc.status = 'OPEN' OR rpt_inp_arc.status = 'CLOSED'
	AND rpt_inp_arc.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"()
UNION
SELECT 
rpt_inp_arc.arc_id,
inp_pump.status
FROM inp_selector_result, rpt_inp_arc
	JOIN inp_pump ON rpt_inp_arc.arc_id = concat(inp_pump.node_id, '_n2a')
	WHERE inp_pump.status = 'OPEN' OR inp_pump.status = 'CLOSED'
	AND rpt_inp_arc.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"()
UNION
SELECT
rpt_inp_arc.arc_id,
inp_pump_additional.status
FROM inp_selector_result, rpt_inp_arc
    JOIN inp_pump_additional ON rpt_inp_arc.arc_id::text = concat(inp_pump_additional.node_id, '_n2a', inp_pump_additional.order_id)
	WHERE inp_pump_additional.status::text = 'OPEN'::text OR inp_pump_additional.status::text = 'CLOSED'::text
	AND rpt_inp_arc.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"();


	

DROP VIEW IF EXISTS "v_inp_emitter" CASCADE;
CREATE VIEW "v_inp_emitter" AS 
SELECT 
inp_emitter.node_id, 
inp_emitter.coef, 
(st_x(the_geom))::numeric(16,3) AS xcoord, 
(st_y(the_geom))::numeric(16,3) AS ycoord
FROM inp_selector_result, inp_emitter 
	JOIN rpt_inp_node ON inp_emitter.node_id = rpt_inp_node.node_id
	WHERE rpt_inp_node.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"();


	
DROP VIEW IF EXISTS "v_inp_reservoir" CASCADE;
CREATE OR REPLACE VIEW "v_inp_reservoir" AS
SELECT 
inp_reservoir.node_id,
elevation as head,
inp_reservoir.pattern_id,
st_x(the_geom)::numeric(16,3) AS xcoord,
st_y(the_geom)::numeric(16,3) AS ycoord
FROM inp_selector_result, inp_reservoir
    JOIN rpt_inp_node ON inp_reservoir.node_id = rpt_inp_node.node_id
	WHERE rpt_inp_node.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"();


	
DROP VIEW IF EXISTS "v_inp_tank" CASCADE;
CREATE VIEW "v_inp_tank" AS 
SELECT 
inp_tank.node_id, 
elevation, 
inp_tank.initlevel, 
inp_tank.minlevel, 
inp_tank.maxlevel, 
inp_tank.diameter, 
inp_tank.minvol, 
inp_tank.curve_id, 
(st_x(the_geom))::numeric(16,3) AS xcoord, 
(st_y(the_geom))::numeric(16,3) AS ycoord
FROM inp_selector_result, inp_tank 
	JOIN rpt_inp_node ON inp_tank.node_id=rpt_inp_node.node_id
	WHERE rpt_inp_node.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"();


DROP VIEW IF EXISTS "v_inp_junction" CASCADE;
CREATE OR REPLACE VIEW v_inp_junction AS 
SELECT 
rpt_inp_node.node_id, 
elevation, 
elev, 
rpt_inp_node.demand, 
pattern_id, 
st_x(the_geom)::numeric(16,3) AS xcoord, 
st_y(the_geom)::numeric(16,3) AS ycoord
FROM inp_selector_result, rpt_inp_node
   LEFT JOIN inp_junction ON inp_junction.node_id = rpt_inp_node.node_id
   WHERE epa_type='JUNCTION'
   AND rpt_inp_node.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"()
   ORDER BY rpt_inp_node.node_id;

  
   
   
DROP VIEW IF EXISTS "v_inp_pump" CASCADE;
CREATE VIEW "v_inp_pump" AS 
SELECT 
concat(inp_pump.node_id, '_n2a') AS arc_id,
rpt_inp_arc.node_1, 
rpt_inp_arc.node_2, 
(('POWER' || ' ') || (inp_pump.power)) AS power, 
(('HEAD' || ' ') || (inp_pump.curve_id)) AS head, (('SPEED' || ' ') || inp_pump.speed) AS speed, 
(('PATTERN' || ' ') || (inp_pump.pattern)) AS pattern
FROM inp_selector_result, inp_pump
	JOIN rpt_inp_arc ON rpt_inp_arc.arc_id = concat(inp_pump.node_id, '_n2a')
	WHERE rpt_inp_arc.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"();


DROP VIEW IF EXISTS v_inp_valve_cu CASCADE;
CREATE OR REPLACE VIEW v_inp_valve_cu AS 
SELECT 
concat(inp_valve.node_id, '_n2a') AS arc_id,
rpt_inp_arc.node_1,
rpt_inp_arc.node_2,
cat_arc.dint AS diameter,
inp_valve.valv_type,
inp_valve.curve_id,
inp_valve.minorloss
FROM inp_selector_result, rpt_inp_arc
	JOIN inp_valve ON rpt_inp_arc.arc_id = concat(inp_valve.node_id, '_n2a')
	JOIN cat_arc ON rpt_inp_arc.arccat_id = cat_arc.id
	WHERE inp_valve.valv_type = 'GPV'
  	AND rpt_inp_arc.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"();


DROP VIEW IF EXISTS v_inp_valve_fl CASCADE;
CREATE OR REPLACE VIEW v_inp_valve_fl AS 
 SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
rpt_inp_arc.node_1,
rpt_inp_arc.node_2,
rpt_inp_arc.diameter,
inp_valve.valv_type,
inp_valve.flow,
inp_valve.minorloss
FROM inp_selector_result, rpt_inp_arc
	JOIN inp_valve ON rpt_inp_arc.arc_id = concat(inp_valve.node_id, '_n2a')
	WHERE inp_valve.valv_type = 'FCV'
	AND rpt_inp_arc.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"();


DROP VIEW IF EXISTS v_inp_valve_lc CASCADE;
CREATE OR REPLACE VIEW v_inp_valve_lc AS 
SELECT 
concat(inp_valve.node_id, '_n2a') AS arc_id,
rpt_inp_arc.node_1,
rpt_inp_arc.node_2,
rpt_inp_arc.diameter,
inp_valve.valv_type,
inp_valve.coef_loss,
inp_valve.minorloss
FROM inp_selector_result, rpt_inp_arc
	JOIN inp_valve ON rpt_inp_arc.arc_id = concat(inp_valve.node_id, '_n2a')
	WHERE inp_valve.valv_type = 'TCV'
	AND rpt_inp_arc.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"();


DROP VIEW IF EXISTS v_inp_valve_pr CASCADE;
CREATE OR REPLACE VIEW v_inp_valve_pr AS 
SELECT concat(inp_valve.node_id, '_n2a') AS arc_id,
rpt_inp_arc.node_1,
rpt_inp_arc.node_2,
rpt_inp_arc.diameter,
inp_valve.valv_type,
inp_valve.pressure,
inp_valve.minorloss
FROM inp_selector_result, rpt_inp_arc
	JOIN inp_valve ON rpt_inp_arc.arc_id = concat(inp_valve.node_id, '_n2a')
	WHERE (inp_valve.valv_type = 'PRV' OR inp_valve.valv_type = 'PSV' OR inp_valve.valv_type = 'PBV')
	AND rpt_inp_arc.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"();


DROP VIEW IF EXISTS v_inp_pipe CASCADE;
CREATE OR REPLACE VIEW v_inp_pipe AS 
SELECT 
rpt_inp_arc.arc_id, 
rpt_inp_arc.node_1, 
rpt_inp_arc.node_2, 
rpt_inp_arc.arccat_id, 
rpt_inp_arc.sector_id, 
rpt_inp_arc.state,
rpt_inp_arc.diameter, 
rpt_inp_arc.roughness,  
rpt_inp_arc.length, 
inp_pipe.minorloss, 
rpt_inp_arc.status
FROM inp_selector_result,rpt_inp_arc
   JOIN inp_pipe ON rpt_inp_arc.arc_id = inp_pipe.arc_id
   WHERE rpt_inp_arc.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"()

UNION 
SELECT 
rpt_inp_arc.arc_id, 
rpt_inp_arc.node_1, 
rpt_inp_arc.node_2, 
rpt_inp_arc.arccat_id, 
rpt_inp_arc.sector_id, 
rpt_inp_arc.state,
rpt_inp_arc.diameter, 
rpt_inp_arc.roughness,  
rpt_inp_arc.length, 
inp_shortpipe.minorloss, 
rpt_inp_arc.status
FROM inp_selector_result, rpt_inp_arc
   JOIN inp_shortpipe ON rpt_inp_arc.arc_id = concat(inp_shortpipe.node_id, '_n2a')
   WHERE rpt_inp_arc.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"();




DROP VIEW IF EXISTS v_inp_vertice CASCADE;
CREATE OR REPLACE VIEW v_inp_vertice AS 
SELECT 
nextval ('"SCHEMA_NAME".inp_vertice_id_seq'::regclass) AS id, 
arc.arc_id, 
st_x(arc.point)::numeric(16,3) AS xcoord, 
st_y(arc.point)::numeric(16,3) AS ycoord
FROM ( SELECT (st_dumppoints(rpt_inp_arc.the_geom)).geom AS point, 
st_startpoint(rpt_inp_arc.the_geom) AS startpoint, 
st_endpoint(rpt_inp_arc.the_geom) AS endpoint, 
rpt_inp_arc.sector_id, 
rpt_inp_arc.arc_id
FROM inp_selector_result,rpt_inp_arc
   WHERE rpt_inp_arc.result_id=inp_selector_result.result_id AND inp_selector_result.cur_user="current_user"()) arc
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
FROM inp_pattern_value
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
  
  
