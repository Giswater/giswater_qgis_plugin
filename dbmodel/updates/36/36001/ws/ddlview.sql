/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


drop view if exists vi_reactions;
drop view if exists vi_curves;
drop view if exists vi_energy;
drop view if exists vi_emitters;
drop view if exists vi_quality;
drop view if exists vi_sources;
drop view if exists vi_mixing;
drop view if exists vi_pumps;

drop view if exists vi_reactions;
CREATE OR REPLACE VIEW vi_reactions AS 
SELECT 'BULK' as param,
inp_pipe.arc_id,
inp_pipe.bulk_coeff::text as coeff
FROM selector_inp_result, inp_pipe
LEFT JOIN rpt_inp_arc ON inp_pipe.arc_id::text = rpt_inp_arc.arc_id::text
WHERE bulk_coeff is not null AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT 'WALL' as param,
inp_pipe.arc_id,
inp_pipe.wall_coeff::text as coeff
FROM selector_inp_result, inp_pipe
JOIN rpt_inp_arc ON inp_pipe.arc_id::text = rpt_inp_arc.arc_id::text
WHERE wall_coeff is not null AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT idval as  param,
NULL AS arc_id,
value::character varying AS coeff
FROM config_param_user
JOIN sys_param_user ON id=parameter
WHERE (parameter='inp_reactions_bulk_order' OR parameter = 'inp_reactions_wall_order' OR parameter = 'inp_reactions_global_bulk' OR 
parameter = 'inp_reactions_global_wall' OR parameter = 'inp_reactions_limit_concentration' OR parameter ='inp_reactions_wall_coeff_correlation')
AND value IS NOT NULL AND  cur_user=current_user order by 1;


CREATE OR REPLACE VIEW vi_energy AS 
SELECT concat('PUMP ', rpt_inp_arc.arc_id) AS pump_id,
'EFFIC' as idval,
effic_curve_id AS energyvalue
FROM selector_inp_result, inp_pump
LEFT JOIN rpt_inp_arc ON concat(inp_pump.node_id, '_n2a') = rpt_inp_arc.arc_id::text
WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND 
inp_pump.effic_curve_id IS NOT NULL
UNION
SELECT concat('PUMP ', rpt_inp_arc.arc_id) AS pump_id,
'PRICE' as idval,
energy_price::TEXT AS energyvalue
FROM selector_inp_result,  inp_pump
LEFT JOIN rpt_inp_arc ON concat(inp_pump.node_id, '_n2a') = rpt_inp_arc.arc_id::text
WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND 
inp_pump.energy_price IS NOT NULL
UNION
SELECT concat('PUMP ', rpt_inp_arc.arc_id) AS pump_id,
'PATTERN' as idval,
energy_pattern_id AS energyvalue
FROM selector_inp_result,   inp_pump
LEFT JOIN rpt_inp_arc ON concat(inp_pump.node_id, '_n2a') = rpt_inp_arc.arc_id::text
WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND 
inp_pump.energy_pattern_id IS NOT NULL
UNION
SELECT concat('PUMP ', rpt_inp_arc.arc_id) AS pump_id,
'EFFIC' as idval,
effic_curve_id AS energyvalue
FROM selector_inp_result, inp_pump_additional
LEFT JOIN rpt_inp_arc ON concat(inp_pump_additional.node_id, '_n2a') = rpt_inp_arc.arc_id::text
WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND 
inp_pump_additional.effic_curve_id IS NOT NULL
UNION
SELECT concat('PUMP ', rpt_inp_arc.arc_id) AS pump_id,
'PRICE' as idval,
energy_price::TEXT AS energyvalue
FROM selector_inp_result,  inp_pump_additional
LEFT JOIN rpt_inp_arc ON concat(inp_pump_additional.node_id, '_n2a') = rpt_inp_arc.arc_id::text
WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND 
inp_pump_additional.energy_price IS NOT NULL
UNION
SELECT concat('PUMP ', rpt_inp_arc.arc_id) AS pump_id,
'PATTERN' as idval,
energy_pattern_id AS energyvalue
FROM selector_inp_result,  inp_pump_additional
LEFT JOIN rpt_inp_arc ON concat(inp_pump_additional.node_id, '_n2a') = rpt_inp_arc.arc_id::text
WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND 
inp_pump_additional.energy_pattern_id IS NOT NULL
UNION
SELECT idval AS pump_id,
value::text AS idval,
NULL::text AS energyvalue
FROM config_param_user
JOIN sys_param_user ON id=parameter
WHERE (parameter='inp_energy_price' OR parameter = 'inp_energy_pump_effic' OR parameter = 'inp_energy_price_pattern') AND value IS NOT NULL AND 
config_param_user.cur_user::name = current_user order by 1;
   
CREATE OR REPLACE VIEW vi_pumps AS 
SELECT temp_arc.arc_id,
temp_arc.node_1,
temp_arc.node_2,
    CASE
        WHEN (temp_arc.addparam::json ->> 'power'::text) <> ''::text THEN ('POWER'::text || ' '::text) || (temp_arc.addparam::json ->> 'power'::text)
        ELSE NULL::text
    END AS power,
    CASE
        WHEN (temp_arc.addparam::json ->> 'curve_id'::text) <> ''::text THEN ('HEAD'::text || ' '::text) || (temp_arc.addparam::json ->> 'curve_id'::text)
        ELSE NULL::text
    END AS head,
    CASE
        WHEN (temp_arc.addparam::json ->> 'speed'::text) <> ''::text THEN ('SPEED'::text || ' '::text) || (temp_arc.addparam::json ->> 'speed'::text)
        ELSE NULL::text
    END AS speed,
    CASE
        WHEN (temp_arc.addparam::json ->> 'pattern'::text) <> ''::text THEN ('PATTERN'::text || ' '::text) || (temp_arc.addparam::json ->> 'pattern'::text)
        ELSE NULL::text
    END AS pattern_id,
concat(';', temp_arc.sector_id, ' ', temp_arc.dma_id, ' ', temp_arc.presszone_id, ' ', temp_arc.dqa_id, ' ', temp_arc.minsector_id, ' ', temp_arc.arccat_id) AS other
FROM temp_arc
WHERE temp_arc.epa_type::text = 'PUMP'::text AND NOT (temp_arc.arc_id::text IN ( SELECT vi_valves.arc_id
FROM vi_valves))
ORDER BY temp_arc.arc_id;


CREATE OR REPLACE VIEW vi_curves AS 
SELECT
CASE WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
ELSE a.curve_id
END AS curve_id,
a.x_value::numeric(12,4) AS x_value,
a.y_value::numeric(12,4) AS y_value,
NULL::text AS other
FROM ( SELECT DISTINCT ON (inp_curve_value.curve_id) ( SELECT min(sub.id) AS min
    FROM SCHEMA_NAME.inp_curve_value sub
    WHERE sub.curve_id::text = inp_curve_value.curve_id::text) AS id,
    inp_curve_value.curve_id,
    concat(';', inp_curve.curve_type, ':', inp_curve.descript) AS curve_type,
    NULL::numeric AS x_value,
    NULL::numeric AS y_value
    FROM SCHEMA_NAME.inp_curve
    JOIN SCHEMA_NAME.inp_curve_value ON inp_curve_value.curve_id::text = inp_curve.id::text
    UNION
    SELECT inp_curve_value.id,
    inp_curve_value.curve_id,
    inp_curve.curve_type,
    inp_curve_value.x_value,
    inp_curve_value.y_value
    FROM SCHEMA_NAME.inp_curve_value
    JOIN SCHEMA_NAME.inp_curve ON inp_curve_value.curve_id::text = inp_curve.id::text
    ORDER BY 1, 4 DESC) a
WHERE (a.curve_id::text IN ( SELECT vi_tanks.curve_id
FROM SCHEMA_NAME.vi_tanks)) OR (concat('HEAD ', a.curve_id) IN ( SELECT vi_pumps.head
FROM SCHEMA_NAME.vi_pumps)) OR (a.curve_id::text IN ( SELECT vi_valves.setting
FROM SCHEMA_NAME.vi_valves)) OR (a.curve_id::text IN ( SELECT vi_energy.energyvalue
FROM SCHEMA_NAME.vi_energy
WHERE vi_energy.idval::text = 'EFFIC'::text)) OR ((( SELECT config_param_user.value
FROM SCHEMA_NAME.config_param_user
WHERE config_param_user.parameter::text = 'inp_options_buildup_mode'::text AND config_param_user.cur_user::name = "current_user"()))::integer) = 1;


CREATE OR REPLACE VIEW vi_emitters AS 
SELECT node_id,
emitter_coeff
FROM selector_inp_result, inp_junction
LEFT JOIN rpt_inp_node USING (node_id)
WHERE emitter_coeff IS NOT NULL AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
emitter_coeff
FROM selector_inp_result, inp_dscenario_junction
LEFT JOIN rpt_inp_node USING (node_id)
WHERE emitter_coeff IS NOT NULL AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_quality AS 
SELECT node_id,
init_quality
FROM selector_inp_result, inp_junction
LEFT JOIN rpt_inp_node USING (node_id)
WHERE init_quality IS NOT NULL AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
init_quality
FROM selector_inp_result, inp_dscenario_junction
LEFT JOIN rpt_inp_node USING (node_id)
WHERE init_quality IS NOT NULL AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
init_quality
FROM selector_inp_result, inp_inlet
LEFT JOIN rpt_inp_node USING (node_id)
WHERE inp_inlet.init_quality IS NOT NULL AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
init_quality
FROM selector_inp_result, inp_dscenario_inlet
LEFT JOIN rpt_inp_node USING (node_id)
WHERE inp_dscenario_inlet.init_quality IS NOT NULL AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
init_quality
FROM selector_inp_result, inp_tank
LEFT JOIN rpt_inp_node USING (node_id)
WHERE init_quality IS NOT NULL AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
init_quality
FROM selector_inp_result, inp_dscenario_tank
LEFT JOIN rpt_inp_node USING (node_id)
WHERE init_quality IS NOT NULL AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
init_quality
FROM selector_inp_result, inp_reservoir
LEFT JOIN rpt_inp_node USING (node_id)
WHERE init_quality IS NOT NULL AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
init_quality
FROM selector_inp_result, inp_dscenario_reservoir
LEFT JOIN rpt_inp_node USING (node_id)
WHERE init_quality IS NOT NULL AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT arc_id,
init_quality
FROM selector_inp_result, inp_virtualvalve
LEFT JOIN rpt_inp_arc USING (arc_id)
WHERE init_quality IS NOT NULL AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT arc_id,
init_quality
FROM selector_inp_result, inp_dscenario_virtualvalve
LEFT JOIN rpt_inp_arc USING (arc_id)
WHERE init_quality IS NOT NULL AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW vi_sources AS 
SELECT node_id,
source_type,
source_quality,
source_pattern_id
FROM selector_inp_result, inp_junction
LEFT JOIN rpt_inp_node USING (node_id)
WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
source_type,
source_quality,
source_pattern_id
FROM selector_inp_result, inp_dscenario_junction
LEFT JOIN rpt_inp_node USING (node_id)
WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
source_type,
source_quality,
source_pattern_id
FROM selector_inp_result, inp_tank
LEFT JOIN rpt_inp_node USING (node_id)
WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
source_type,
source_quality,
source_pattern_id
FROM selector_inp_result, inp_dscenario_tank
LEFT JOIN rpt_inp_node USING (node_id)
WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
source_type,
source_quality,
source_pattern_id
FROM selector_inp_result, inp_reservoir
LEFT JOIN rpt_inp_node USING (node_id)
WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
source_type,
source_quality,
source_pattern_id
FROM selector_inp_result, inp_dscenario_reservoir
LEFT JOIN rpt_inp_node USING (node_id)
WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
source_type,
source_quality,
source_pattern_id
FROM selector_inp_result, inp_inlet
LEFT JOIN rpt_inp_node USING (node_id)
WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
source_type,
source_quality,
source_pattern_id
FROM selector_inp_result, inp_dscenario_inlet
LEFT JOIN rpt_inp_node USING (node_id)
WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW vi_mixing AS 
SELECT node_id,
mixing_model,
mixing_fraction
FROM selector_inp_result, inp_tank
LEFT JOIN rpt_inp_node USING (node_id)
WHERE (mixing_model IS NOT NULL OR mixing_fraction IS NOT NULL) 
AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
mixing_model,
mixing_fraction
FROM selector_inp_result, inp_dscenario_tank
LEFT JOIN rpt_inp_node USING (node_id)
WHERE (mixing_model IS NOT NULL OR mixing_fraction IS NOT NULL) 
AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
mixing_model,
mixing_fraction
FROM selector_inp_result, inp_inlet
LEFT JOIN rpt_inp_node USING (node_id)
WHERE (mixing_model IS NOT NULL OR mixing_fraction IS NOT NULL) 
AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text
UNION
SELECT node_id,
mixing_model,
mixing_fraction
FROM selector_inp_result, inp_dscenario_inlet
LEFT JOIN rpt_inp_node USING (node_id)
WHERE (mixing_model IS NOT NULL OR mixing_fraction IS NOT NULL) 
AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
AND selector_inp_result.cur_user = "current_user"()::text;

--2022/01/03
DROP VIEW IF EXISTS v_edit_inp_dscenario_junction;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_junction AS 
SELECT p.dscenario_id,
p.node_id,
--p.demand_type,
p.demand,
p.pattern_id,
emitter_coeff,
init_quality,
source_type,
source_quality,
source_pattern_id,
n.the_geom
FROM selector_sector,selector_inp_dscenario, v_node n
JOIN inp_dscenario_junction p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;

DROP VIEW IF EXISTS v_edit_inp_junction;
CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.sector_id,
-- macrosector
n.dma_id,
n.state,
n.state_type,
n.annotation,
demand,
pattern_id,
peak_factor,
emitter_coeff,
init_quality,
source_type,
source_quality,
source_pattern_id,
n.the_geom
FROM selector_sector, v_edit_node n
JOIN inp_junction USING (node_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_dscenario_pump;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump AS 
SELECT d.dscenario_id,
p.node_id,
p.power,
p.curve_id,
p.speed,
p.pattern_id,
p.status,
effic_curve_id,
energy_price,
energy_pattern_id,
n.the_geom
FROM selector_sector,
selector_inp_dscenario,v_node n
JOIN inp_dscenario_pump p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS v_edit_inp_pump_additional;
CREATE OR REPLACE VIEW v_edit_inp_pump_additional AS 
SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.sector_id,
n.state,
n.state_type,
n.annotation,
n.dma_id,
p.order_id,
p.power,
p.curve_id,
p.speed,
p.pattern_id,
p.status,
effic_curve_id,
energy_price,
energy_pattern_id,
n.the_geom
FROM selector_sector,v_node n
JOIN inp_pump_additional p USING (node_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_dscenario_pump_additional;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump_additional AS 
SELECT d.dscenario_id,
p.node_id,
p.order_id,
p.power,
p.curve_id,
p.speed,
p.pattern_id,
p.status,
effic_curve_id,
energy_price,
energy_pattern_id,
n.the_geom
FROM selector_sector,
selector_inp_dscenario,v_node n
JOIN inp_dscenario_pump_additional p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;

DROP VIEW IF EXISTS v_edit_inp_pump;
CREATE OR REPLACE VIEW v_edit_inp_pump AS 
SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.sector_id,
n.dma_id,
--n.macrosector_id,
n.state,
n.state_type,
n.annotation,
--n.expl_id,
concat(node_id,'_n2a') as nodarc_id,
power,
curve_id,
speed,
pattern_id,
to_arc,
status,
pump_type,
effic_curve_id,
energy_price,
energy_pattern_id,
n.the_geom
FROM selector_sector, v_node n
JOIN inp_pump USING (node_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS v_edit_inp_dscenario_pipe;
CREATE OR REPLACE VIEW SCHEMA_NAME.v_edit_inp_dscenario_pipe AS 
 SELECT d.dscenario_id,
p.arc_id,
p.minorloss,
p.status,
p.roughness,
p.dint,
bulk_coeff,
wall_coeff,
a.the_geom
FROM selector_sector,selector_inp_dscenario, v_arc a
JOIN SCHEMA_NAME.inp_dscenario_pipe p USING (arc_id)
JOIN SCHEMA_NAME.cat_dscenario d USING (dscenario_id)
WHERE a.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_pipe;
CREATE OR REPLACE VIEW v_edit_inp_pipe AS 
 SELECT arc.arc_id,
arc.node_1,
arc.node_2,
arc.arccat_id,
arc.sector_id,
--arc.macrosector_id,
arc.dma_id,
arc.state,
arc.state_type,
arc.custom_length,
arc.annotation,
--arc.expl_id,
minorloss,
status,
custom_roughness,
custom_dint,
bulk_coeff,
wall_coeff,
arc.the_geom
FROM selector_sector,v_arc arc
JOIN inp_pipe USING (arc_id)
WHERE arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_dscenario_shortpipe;
CREATE OR REPLACE VIEW SCHEMA_NAME.v_edit_inp_dscenario_shortpipe AS 
SELECT d.dscenario_id,
p.node_id,
p.minorloss,
p.status,
bulk_coeff,
wall_coeff,
n.the_geom
FROM selector_sector, selector_inp_dscenario, v_node n
JOIN inp_dscenario_shortpipe p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND 
p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_shortpipe;
CREATE OR REPLACE VIEW v_edit_inp_shortpipe AS 
 SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.sector_id,
--n.macrosector_id,
n.dma_id,
n.state,
n.state_type,
n.annotation,
--n.expl_id,
concat(n.node_id,'_n2a') AS nodarc_id,
minorloss,
to_arc,
status,
bulk_coeff,
wall_coeff,
n.the_geom
FROM selector_sector, v_node n
JOIN inp_shortpipe USING (node_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;
  

DROP VIEW IF EXISTS v_edit_inp_dscenario_tank;
CREATE OR REPLACE VIEW SCHEMA_NAME.v_edit_inp_dscenario_tank AS 
SELECT d.dscenario_id,
p.node_id,
p.initlevel,
p.minlevel,
p.maxlevel,
p.diameter,
p.minvol,
p.curve_id,
mixing_model,
mixing_fraction,
reaction_coeff,
init_quality,
source_type,
source_quality,
source_pattern_id,
n.the_geom
FROM selector_sector, selector_inp_dscenario, v_node n
JOIN inp_dscenario_tank p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;

  
DROP VIEW IF EXISTS v_edit_inp_tank;
CREATE OR REPLACE VIEW v_edit_inp_tank AS 
 SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.sector_id,
--n.macrosector_id,
n.dma_id,
n.state,
n.state_type,
n.annotation,
--n.expl_id,
initlevel,
minlevel,
maxlevel,
diameter,
minvol,
curve_id,
mixing_model,
mixing_fraction,
reaction_coeff,
init_quality,
source_type,
source_quality,
source_pattern_id,
n.the_geom
FROM selector_sector, v_node n
JOIN inp_tank USING (node_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

DROP VIEW IF EXISTS v_edit_inp_dscenario_reservoir;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_reservoir AS 
SELECT d.dscenario_id,
p.node_id,
p.pattern_id,
p.head,
init_quality,
source_type,
source_quality,
source_pattern_id,
n.the_geom
FROM selector_sector,
selector_inp_dscenario, v_node n
JOIN inp_dscenario_reservoir p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;

  
DROP VIEW IF EXISTS v_edit_inp_reservoir;
CREATE OR REPLACE VIEW v_edit_inp_reservoir AS 
 SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.sector_id,
--n.macrosector_id,
n.dma_id,
n.state,
n.state_type,
n.annotation,
--n.expl_id,
pattern_id,
head,
init_quality,
source_type,
source_quality,
source_pattern_id,
n.the_geom
FROM selector_sector, v_node n
JOIN inp_reservoir USING (node_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

DROP VIEW IF EXISTS v_edit_inp_dscenario_valve;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_valve AS 
SELECT d.dscenario_id,
p.node_id,
concat(p.node_id,'_n2a') AS nodarc_id,
p.valv_type,
p.pressure,
p.flow,
p.coef_loss,
p.curve_id,
p.minorloss,
p.status,
p.add_settings,
init_quality,
n.the_geom
FROM selector_sector, selector_inp_dscenario, v_node n
JOIN inp_dscenario_valve p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;

  
DROP VIEW IF EXISTS v_edit_inp_valve;
CREATE OR REPLACE VIEW v_edit_inp_valve AS 
SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.sector_id,
n.dma_id,
--v_node.macrosector_id,
n.state,
n.state_type,
n.annotation,
--v_node.expl_id,
concat(n.node_id,'_n2a') AS nodarc_id,
valv_type,
pressure,
flow,
coef_loss,
curve_id,
minorloss,
to_arc,
status,
custom_dint,
add_settings,
init_quality,
n.the_geom
FROM selector_sector, v_node n
JOIN inp_valve USING (node_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

DROP VIEW IF EXISTS v_edit_inp_dscenario_virtualvalve;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_virtualvalve AS 
SELECT d.dscenario_id,
p.arc_id,
p.valv_type,
p.pressure,
P.diameter,
p.flow,
p.coef_loss,
p.curve_id,
p.minorloss,
p.status,
--p.add_settings,
init_quality,
a.the_geom
FROM selector_sector, selector_inp_dscenario, v_arc a
JOIN inp_dscenario_virtualvalve p USING (arc_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE a.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_virtualvalve;
CREATE OR REPLACE VIEW v_edit_inp_virtualvalve AS 
SELECT v_arc.arc_id,
v_arc.node_1,
v_arc.node_2,
(v_arc.elevation1 + v_arc.elevation2) / 2::numeric AS elevation,
(v_arc.depth1 + v_arc.depth2) / 2::numeric AS depth,
v_arc.arccat_id,
v_arc.sector_id,
--v_arc.macrosector_id,
v_arc.dma_id,
v_arc.state,
v_arc.state_type,
v_arc.custom_length,
v_arc.annotation,
--v_arc.expl_id,
valv_type,
pressure,
flow,
coef_loss,
curve_id,
minorloss,
to_arc,
status,
init_quality,
v_arc.the_geom
FROM selector_sector,v_arc
JOIN inp_virtualvalve USING (arc_id)
WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_dscenario_inlet;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_inlet AS 
SELECT p.dscenario_id, 
node_id, 
initlevel, 
minlevel, 
maxlevel,
diameter, 
minvol, 
curve_id, 
overflow, 
head, 
pattern_id,
mixing_model,
mixing_fraction,
reaction_coeff,
init_quality,
source_type,
source_quality,
source_pattern_id,
n.the_geom
FROM selector_sector, selector_inp_dscenario, v_node n
JOIN inp_dscenario_inlet p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_inlet;
CREATE OR REPLACE VIEW v_edit_inp_inlet AS 
 SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.sector_id,
--n.macrosector_id,
n.dma_id,
n.state,
n.state_type,
n.annotation,
--n.expl_id,
initlevel,
minlevel,
maxlevel,
diameter,
minvol,
curve_id,
pattern_id,
mixing_model,
mixing_fraction,
reaction_coeff,
init_quality,
source_type,
source_quality,
source_pattern_id,
n.the_geom
FROM selector_sector,v_node n
JOIN inp_inlet USING (node_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

/*
DROP VIEW IF EXISTS v_edit_inp_connec;
CREATE OR REPLACE VIEW v_edit_inp_connec AS 
 SELECT connec.connec_id,
connec.elevation,
connec.depth,
connec.connecat_id,
connec.arc_id,
connec.sector_id,
connec.dma_id,
connec.state,
connec.state_type,
--connec.expl_id,
connec.pjoint_type,
connec.pjoint_id,
connec.annotation,
inp_connec.demand,
inp_connec.pattern_id,
inp_connec.peak_factor,
inp_connec.custom_roughness,
inp_connec.custom_length,
inp_connec.custom_dint,
--connec.epa_type
connec.the_geom
FROM selector_sector,v_connec connec
JOIN inp_connec USING (connec_id)
WHERE connec.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;*/



CREATE OR REPLACE VIEW ve_epa_junction AS 
SELECT inp_junction.*,
max_demand, 
min_demand, 
max_head, 
min_head, 
max_pressure, 
min_pressure, 
max_quality, 
min_quality
FROM inp_junction 
LEFT JOIN v_rpt_node USING (node_id);

CREATE OR REPLACE VIEW ve_epa_tank AS 
SELECT inp_tank.*, 
max_demand, 
min_demand, 
max_head, 
min_head, 
max_pressure, 
min_pressure, 
max_quality, 
min_quality
FROM inp_tank 
LEFT JOIN v_rpt_node USING (node_id);

CREATE OR REPLACE VIEW ve_epa_reservoir AS 
SELECT inp_reservoir.*, 
max_demand, 
min_demand, 
max_head, 
min_head, 
max_pressure, 
min_pressure, 
max_quality, 
min_quality
FROM inp_reservoir 
LEFT JOIN v_rpt_node USING (node_id);

CREATE OR REPLACE VIEW ve_epa_inlet AS 
SELECT inp_inlet.*, 
max_demand, 
min_demand, 
max_head, 
min_head, 
max_pressure, 
min_pressure, 
max_quality, 
min_quality
FROM inp_inlet 
LEFT JOIN v_rpt_node USING (node_id);

CREATE OR REPLACE VIEW ve_epa_pipe AS 
SELECT inp_pipe.*, 
max_flow, 
min_flow, 
max_vel, 
min_vel, 
max_headloss, 
min_headloss, 
max_setting, 
min_setting, 
max_reaction, 
min_reaction, 
max_ffactor, 
min_ffactor
FROM inp_pipe 
LEFT JOIN v_rpt_arc USING (arc_id);

CREATE OR REPLACE VIEW ve_epa_pump AS 
SELECT inp_pump.*, 
concat(node_id,'_n2a') as nodarc_id,
max_flow, 
min_flow, 
max_vel, 
min_vel, 
max_headloss, 
min_headloss, 
max_setting, 
min_setting, 
max_reaction, 
min_reaction, 
max_ffactor, 
min_ffactor
FROM inp_pump 
LEFT JOIN v_rpt_arc ON concat(node_id,'_n2a') = arc_id;

CREATE OR REPLACE VIEW ve_epa_valve AS 
SELECT inp_valve.*, 
concat(node_id,'_n2a') as nodarc_id,
max_flow, 
min_flow, 
max_vel, 
min_vel, 
max_headloss, 
min_headloss, 
max_setting, 
min_setting, 
max_reaction, 
min_reaction, 
max_ffactor, 
min_ffactor
FROM inp_valve 
LEFT JOIN v_rpt_arc ON concat(node_id,'_n2a') = arc_id;

CREATE OR REPLACE VIEW ve_epa_shortpipe AS 
SELECT inp_shortpipe.*, 
concat(node_id,'_n2a') as nodarc_id,
max_flow, 
min_flow, 
max_vel, 
min_vel, 
max_headloss, 
min_headloss, 
max_setting, 
min_setting, 
max_reaction, 
min_reaction, 
max_ffactor, 
min_ffactor
FROM inp_shortpipe 
LEFT JOIN v_rpt_arc ON concat(node_id,'_n2a') = arc_id;

CREATE OR REPLACE VIEW ve_epa_virtualvalve AS 
SELECT inp_virtualvalve.*, 
max_flow, 
min_flow, 
max_vel, 
min_vel, 
max_headloss, 
min_headloss, 
max_setting, 
min_setting, 
max_reaction, 
min_reaction, 
max_ffactor, 
min_ffactor
FROM inp_virtualvalve 
LEFT JOIN v_rpt_arc USING (arc_id);

CREATE OR REPLACE VIEW ve_epa_pump_additional AS
SELECT inp_pump_additional.*, 
concat(node_id,'_n2a') as nodarc_id,
max_flow, 
min_flow, 
max_vel, 
min_vel, 
max_headloss, 
min_headloss, 
max_setting, 
min_setting, 
max_reaction, 
min_reaction, 
max_ffactor, 
min_ffactor
FROM inp_pump_additional 
LEFT JOIN v_rpt_arc ON concat(node_id,'_n2a',order_id) = arc_id;

CREATE OR REPLACE VIEW ve_epa_connec AS
SELECT inp_connec.*, 
max_demand, 
min_demand, 
max_head, 
min_head, 
max_pressure, 
min_pressure, 
max_quality, 
min_quality
FROM inp_connec 
LEFT JOIN v_rpt_node ON connec_id = node_id;
