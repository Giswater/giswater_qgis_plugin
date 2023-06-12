/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


drop view if exists vi_reactions;
drop view if exists vi_energy;
drop view if exists vi_emitters;
drop view if exists vi_quality;
drop view if exists vi_sources;
drop view if exists vi_mixing;
drop view if exists vi_pumps;
drop view if exists vi_pjoint;

DROP VIEW v_rpt_arc CASCADE;
CREATE OR REPLACE VIEW v_rpt_arc AS 
 SELECT arc.arc_id,
    selector_rpt_main.result_id,
    arc.arc_type,
    arc.sector_id,
    arc.arccat_id,
    max(rpt_arc.flow) AS flow_max,
    min(rpt_arc.flow) AS flow_min,
    (avg(rpt_arc.flow))::numeric(12,2) AS flow_avg,
    max(rpt_arc.vel) AS vel_max,
    min(rpt_arc.vel) AS vel_min,
    (avg(rpt_arc.vel))::numeric(12,2) AS vel_avg,
    max(rpt_arc.headloss) AS headloss_max,
    min(rpt_arc.headloss) AS headloss_min,
    max(rpt_arc.setting) AS setting_max,
    min(rpt_arc.setting) AS setting_min,
    max(rpt_arc.reaction) AS reaction_max,
    min(rpt_arc.reaction) AS reaction_min,
    max(rpt_arc.ffactor) AS ffactor_max,
    min(rpt_arc.ffactor) AS ffactor_min,
    arc.the_geom
   FROM selector_rpt_main,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_main.result_id::text
  GROUP BY arc.arc_id, arc.arc_type, arc.sector_id, arc.arccat_id, selector_rpt_main.result_id, arc.the_geom
  ORDER BY arc.arc_id;

DROP VIEW v_rpt_comp_arc;
CREATE OR REPLACE VIEW v_rpt_comp_arc AS 
 SELECT arc.arc_id,
    arc.sector_id,
    selector_rpt_compare.result_id,
    max(rpt_arc.flow) AS max_flow,
    min(rpt_arc.flow) AS min_flow,
   (avg(rpt_arc.flow))::numeric(12,2) AS flow_avg, 
    max(rpt_arc.vel) AS max_vel,
    min(rpt_arc.vel) AS min_vel,
   (avg(rpt_arc.vel))::numeric(12,2) AS vel_avg,
    max(rpt_arc.headloss) AS max_headloss,
    min(rpt_arc.headloss) AS min_headloss,
    max(rpt_arc.setting) AS max_setting,
    min(rpt_arc.setting) AS min_setting,
    max(rpt_arc.reaction) AS max_reaction,
    min(rpt_arc.reaction) AS min_reaction,
    max(rpt_arc.ffactor) AS max_ffactor,
    min(rpt_arc.ffactor) AS min_ffactor,
    arc.the_geom
   FROM selector_rpt_compare,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND arc.result_id::text = selector_rpt_compare.result_id::text
  GROUP BY arc.arc_id, arc.sector_id, arc.arc_type, arc.arccat_id, selector_rpt_compare.result_id, arc.the_geom
  ORDER BY arc.arc_id;


DROP VIEW v_rpt_node CASCADE;
CREATE OR REPLACE VIEW v_rpt_node AS 
 SELECT node.node_id,
    selector_rpt_main.result_id,
    node.node_type,
    node.sector_id,
    node.nodecat_id,
    max(rpt_node.elevation) AS elevation,
    max(rpt_node.demand) AS demand_max,
    min(rpt_node.demand) AS demand_min,
    (avg(rpt_node.demand))::numeric(12,2) AS demand_avg,
    max(rpt_node.head) AS head_max,
    min(rpt_node.head) AS head_min,
    (avg(rpt_node.head))::numeric(12,2) AS head_avg,
    max(rpt_node.press) AS press_max,
    min(rpt_node.press) AS press_min,
    (avg(rpt_node.press))::numeric(12,2) AS press_avg,
    max(rpt_node.quality) AS quality_max,
    min(rpt_node.quality) AS quality_min,
   (avg(rpt_node.quality))::numeric(12,2) AS quality_avg,
    node.the_geom
   FROM selector_rpt_main,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_main.result_id::text
  GROUP BY node.node_id, node.node_type, node.sector_id, node.nodecat_id, selector_rpt_main.result_id, node.the_geom
  ORDER BY node.node_id;

DROP VIEW v_rpt_comp_node ;
CREATE OR REPLACE VIEW v_rpt_comp_node AS 
 SELECT node.node_id,
    selector_rpt_compare.result_id,
    node.node_type,
    node.sector_id,
    node.nodecat_id,
    max(rpt_node.elevation) AS elevation,
    max(rpt_node.demand) AS max_demand,
    min(rpt_node.demand) AS min_demand,
    (avg(rpt_node.demand))::numeric(12,2) AS demand_avg,
    max(rpt_node.head) AS max_head,
    min(rpt_node.head) AS min_head,
    (avg(rpt_node.head))::numeric(12,2) AS head_avg,
    max(rpt_node.press) AS max_pressure,
    min(rpt_node.press) AS min_pressure,
    (avg(rpt_node.press))::numeric(12,2) AS avg_pressure,
    max(rpt_node.quality) AS max_quality,
    min(rpt_node.quality) AS min_quality,
    (avg(rpt_node.quality))::numeric(12,2) AS quality_avg,
    node.the_geom
   FROM selector_rpt_compare,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_compare.result_id::text
  GROUP BY node.node_id, node.node_type, node.sector_id, node.nodecat_id, selector_rpt_compare.result_id, node.the_geom
  ORDER BY node.node_id;


-- reactions
drop view if exists vi_reactions;
CREATE OR REPLACE VIEW vi_reactions AS 
SELECT 'BULK' as param, inp_pipe.arc_id, inp_pipe.bulk_coeff::text as coeff FROM inp_pipe LEFT JOIN temp_arc ON inp_pipe.arc_id::text = temp_arc.arc_id::text WHERE bulk_coeff is not null
UNION
SELECT 'WALL' as param, inp_pipe.arc_id, inp_pipe.wall_coeff::text as coeff FROM inp_pipe JOIN temp_arc ON inp_pipe.arc_id::text = temp_arc.arc_id::text WHERE wall_coeff is not null 
UNION
SELECT 'BULK' as param, p.arc_id, p.bulk_coeff::text as coeff FROM inp_dscenario_pipe p LEFT JOIN temp_arc ON p.arc_id::text = temp_arc.arc_id::text WHERE bulk_coeff is not null
UNION
SELECT 'WALL' as param, p.arc_id, p.wall_coeff::text as coeff FROM inp_dscenario_pipe p JOIN temp_arc ON p.arc_id::text = temp_arc.arc_id::text WHERE wall_coeff is not null 
UNION
SELECT idval as  param, NULL AS arc_id, value::character varying AS coeff FROM config_param_user JOIN sys_param_user ON id=parameter 
WHERE (parameter='inp_reactions_bulk_order' OR parameter = 'inp_reactions_wall_order' OR parameter = 'inp_reactions_global_bulk' OR  
parameter = 'inp_reactions_global_wall' OR parameter = 'inp_reactions_limit_concentration' OR parameter ='inp_reactions_wall_coeff_correlation') 
AND value IS NOT NULL AND  cur_user=current_user order by 1;

-- energy
CREATE OR REPLACE VIEW vi_energy AS 
SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id, 'EFFIC' as idval, effic_curve_id AS energyvalue FROM inp_pump LEFT JOIN temp_arc ON concat(inp_pump.node_id, '_n2a') = temp_arc.arc_id::text WHERE effic_curve_id IS NOT NULL
UNION
SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id, 'PRICE' as idval, energy_price::TEXT AS energyvalue FROM inp_pump LEFT JOIN temp_arc ON concat(inp_pump.node_id, '_n2a') = temp_arc.arc_id::text WHERE energy_price IS NOT NULL
UNION
SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id, 'PATTERN' as idval, energy_pattern_id AS energyvalue FROM inp_pump LEFT JOIN temp_arc ON concat(inp_pump.node_id, '_n2a') = temp_arc.arc_id::text WHERE energy_pattern_id IS NOT NULL
UNION
SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id, 'EFFIC' as idval, effic_curve_id AS energyvalue FROM inp_pump_additional LEFT JOIN temp_arc ON concat(inp_pump_additional.node_id, '_n2a') = temp_arc.arc_id::text WHERE effic_curve_id IS NOT NULL
UNION
SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id, 'PRICE' as idval, energy_price::TEXT AS energyvalue FROM inp_pump_additional LEFT JOIN temp_arc ON concat(inp_pump_additional.node_id, '_n2a') = temp_arc.arc_id::text WHERE energy_price IS NOT NULL
UNION
SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id, 'PATTERN' as idval, energy_pattern_id AS energyvalue FROM inp_pump_additional p LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text WHERE energy_pattern_id IS NOT NULL
UNION
SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id, 'EFFIC' as idval, effic_curve_id AS energyvalue FROM inp_dscenario_pump p LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text WHERE effic_curve_id IS NOT NULL
UNION
SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id, 'PRICE' as idval, energy_price::TEXT AS energyvalue FROM inp_dscenario_pump p LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text WHERE energy_price IS NOT NULL
UNION
SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id, 'PATTERN' as idval, energy_pattern_id AS energyvalue FROM inp_dscenario_pump p LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text WHERE energy_pattern_id IS NOT NULL
UNION
SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id, 'EFFIC' as idval, effic_curve_id AS energyvalue FROM inp_dscenario_pump_additional p LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text WHERE effic_curve_id IS NOT NULL
UNION
SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id, 'PRICE' as idval, energy_price::TEXT AS energyvalue FROM inp_dscenario_pump_additional p LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text WHERE energy_price IS NOT NULL
UNION
SELECT concat('PUMP ', temp_arc.arc_id) AS pump_id, 'PATTERN' as idval, energy_pattern_id AS energyvalue FROM inp_pump_additional p LEFT JOIN temp_arc ON concat(p.node_id, '_n2a') = temp_arc.arc_id::text WHERE energy_pattern_id IS NOT NULL
UNION
SELECT idval AS pump_id, value::text AS idval, NULL::text AS energyvalue FROM config_param_user JOIN sys_param_user ON id=parameter 
WHERE (parameter='inp_energy_price' OR parameter = 'inp_energy_pump_effic' OR parameter = 'inp_energy_price_pattern') AND value IS NOT NULL AND  config_param_user.cur_user::name = current_user order by 1;

-- pumps
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


-- emitters
CREATE OR REPLACE VIEW vi_emitters AS 
SELECT node_id, emitter_coeff FROM inp_junction LEFT JOIN temp_node USING (node_id) WHERE emitter_coeff IS NOT NULL 
UNION
SELECT node_id, emitter_coeff FROM inp_dscenario_junction LEFT JOIN temp_node USING (node_id) WHERE emitter_coeff IS NOT NULL 
UNION
SELECT connec_id, emitter_coeff FROM inp_connec LEFT JOIN temp_node ON connec_id=node_id WHERE emitter_coeff IS NOT NULL 
UNION
SELECT connec_id, emitter_coeff FROM inp_dscenario_connec LEFT JOIN temp_node ON connec_id=node_id WHERE emitter_coeff IS NOT NULL;

--quality
CREATE OR REPLACE VIEW vi_quality AS 
SELECT node_id, init_quality FROM inp_junction LEFT JOIN temp_node USING (node_id) WHERE init_quality IS NOT NULL 
UNION
SELECT node_id, init_quality FROM inp_dscenario_junction LEFT JOIN temp_node USING (node_id) WHERE init_quality IS NOT NULL 
UNION
SELECT node_id, init_quality FROM inp_inlet LEFT JOIN temp_node USING (node_id) WHERE inp_inlet.init_quality IS NOT NULL
UNION
SELECT node_id, init_quality FROM inp_dscenario_inlet LEFT JOIN temp_node USING (node_id) WHERE inp_dscenario_inlet.init_quality IS NOT NULL 
UNION
SELECT node_id, init_quality FROM inp_tank LEFT JOIN temp_node USING (node_id) WHERE init_quality IS NOT NULL 
UNION
SELECT node_id, init_quality FROM inp_dscenario_tank LEFT JOIN temp_node USING (node_id) WHERE init_quality IS NOT NULL 
UNION
SELECT node_id, init_quality FROM inp_reservoir LEFT JOIN temp_node USING (node_id) WHERE init_quality IS NOT NULL 
UNION
SELECT node_id, init_quality FROM inp_dscenario_reservoir LEFT JOIN temp_node USING (node_id) WHERE init_quality IS NOT NULL 
UNION
SELECT arc_id, init_quality FROM inp_virtualvalve LEFT JOIN temp_arc USING (arc_id) WHERE init_quality IS NOT NULL 
UNION
SELECT arc_id, init_quality FROM inp_dscenario_virtualvalve LEFT JOIN temp_arc USING (arc_id) WHERE init_quality IS NOT NULL;

-- sources
CREATE OR REPLACE VIEW vi_sources AS 
SELECT node_id, source_type, source_quality, source_pattern_id FROM inp_junction LEFT JOIN temp_node USING (node_id) WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
UNION
SELECT node_id, source_type, source_quality, source_pattern_id FROM inp_dscenario_junction LEFT JOIN temp_node USING (node_id) WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
UNION
SELECT node_id, source_type, source_quality, source_pattern_id FROM inp_tank LEFT JOIN temp_node USING (node_id) WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
UNION
SELECT node_id, source_type, source_quality, source_pattern_id FROM inp_dscenario_tank LEFT JOIN temp_node USING (node_id) WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
UNION
SELECT node_id, source_type, source_quality, source_pattern_id FROM inp_reservoir LEFT JOIN temp_node USING (node_id) WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
UNION
SELECT node_id, source_type, source_quality, source_pattern_id FROM inp_dscenario_reservoir LEFT JOIN temp_node USING (node_id) WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
UNION 
SELECT node_id, source_type, source_quality, source_pattern_id FROM inp_inlet LEFT JOIN temp_node USING (node_id) WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) 
UNION
SELECT node_id, source_type, source_quality, source_pattern_id FROM inp_dscenario_inlet LEFT JOIN temp_node USING (node_id) WHERE (source_type IS NOT NULL OR source_quality IS NOT NULL OR source_pattern_id IS NOT NULL) ;

--mixing
CREATE OR REPLACE VIEW vi_mixing AS 
SELECT node_id, mixing_model, mixing_fraction FROM inp_tank LEFT JOIN temp_node USING (node_id) WHERE (mixing_model IS NOT NULL OR mixing_fraction IS NOT NULL)  
UNION
SELECT node_id, mixing_model, mixing_fraction FROM inp_dscenario_tank LEFT JOIN temp_node USING (node_id) WHERE (mixing_model IS NOT NULL OR mixing_fraction IS NOT NULL) 
UNION
SELECT node_id, mixing_model, mixing_fraction FROM inp_inlet LEFT JOIN temp_node USING (node_id) WHERE (mixing_model IS NOT NULL OR mixing_fraction IS NOT NULL) AND epa_type ='TANK'
UNION
SELECT node_id, mixing_model, mixing_fraction FROM inp_dscenario_inlet LEFT JOIN temp_node USING (node_id) WHERE (mixing_model IS NOT NULL OR mixing_fraction IS NOT NULL) AND epa_type ='TANK';



CREATE OR REPLACE VIEW ve_epa_junction AS 
SELECT inp_junction.*,
result_id,
demand_max as demandmax, 
demand_min as demandmin,
demand_avg as demandavg,
head_max as headmax,
head_min as headmin, 
head_avg as headavg,
press_max as pressmax,
press_min as pressmin, 
press_avg as pressavg,
quality_max as qualmax, 
quality_min as qualmin, 
quality_avg as qualavg
FROM inp_junction 
LEFT JOIN v_rpt_node USING (node_id);

CREATE OR REPLACE VIEW ve_epa_tank AS 
SELECT inp_tank.*, 
result_id,
demand_max as demandmax, 
demand_min as demandmin,
demand_avg as demandavg,
head_max as headmax,
head_min as headmin, 
head_avg as headavg,
press_max as pressmax,
press_min as pressmin, 
press_avg as pressavg,
quality_max as qualmax, 
quality_min as qualmin, 
quality_avg as qualavg
FROM inp_tank 
LEFT JOIN v_rpt_node USING (node_id);

CREATE OR REPLACE VIEW ve_epa_reservoir AS 
SELECT inp_reservoir.*, 
result_id,
demand_max as demandmax, 
demand_min as demandmin,
demand_avg as demandavg,
head_max as headmax,
head_min as headmin, 
head_avg as headavg,
press_max as pressmax,
press_min as pressmin, 
press_avg as pressavg,
quality_max as qualmax, 
quality_min as qualmin, 
quality_avg as qualavg
FROM inp_reservoir 
LEFT JOIN v_rpt_node USING (node_id);

CREATE OR REPLACE VIEW ve_epa_inlet AS 
SELECT inp_inlet.*, 
result_id,
demand_max as demandmax, 
demand_min as demandmin,
demand_avg as demandavg,
head_max as headmax,
head_min as headmin, 
head_avg as headavg,
press_max as pressmax,
press_min as pressmin, 
press_avg as pressavg,
quality_max as qualmax, 
quality_min as qualmin, 
quality_avg as qualavg
FROM inp_inlet 
LEFT JOIN v_rpt_node USING (node_id);

CREATE OR REPLACE VIEW ve_epa_pipe AS 
SELECT inp_pipe.*, 
result_id,
round(avg(flow_max), 2) as flowmax, 
round(avg(flow_min), 2) as flowmin, 
round(avg(flow_avg), 2) as flowavg,
round(avg(vel_max), 2) as velmax, 
round(avg(vel_min), 2) as velmin,
round(avg(vel_avg), 2) as velavg, 
round(avg(headloss_max), 2) as headloss_max, 
round(avg(headloss_min), 2) as headloss_min,
round(avg(setting_max), 2) as setting_max, 
round(avg(setting_min), 2) as setting_min, 
round(avg(reaction_max), 2) as reaction_max, 
round(avg(reaction_min), 2) as reaction_min, 
round(avg(ffactor_max), 2) as ffactor_max, 
round(avg(ffactor_min), 2) as ffactor_min
FROM inp_pipe 
LEFT JOIN v_rpt_arc on split_part(v_rpt_arc.arc_id, 'P',1) = inp_pipe.arc_id 
group by inp_pipe.arc_id, result_id;


CREATE OR REPLACE VIEW ve_epa_pump AS 
SELECT inp_pump.*, 
concat(node_id,'_n2a') as nodarc_id,
result_id,
v_rpt_arc.flow_max as flowmax,
v_rpt_arc.flow_min as flowmin,
v_rpt_arc.flow_avg as flowavg,
v_rpt_arc.vel_max as velmax,
v_rpt_arc.vel_min as velmin,
v_rpt_arc.vel_avg as velavg,
headloss_max, 
headloss_min, 
setting_max, 
setting_min, 
reaction_max, 
reaction_min, 
ffactor_max, 
ffactor_min
FROM inp_pump 
LEFT JOIN v_rpt_arc ON concat(node_id,'_n2a') = arc_id;

CREATE OR REPLACE VIEW ve_epa_valve AS 
SELECT inp_valve.*, 
concat(node_id,'_n2a') as nodarc_id,
result_id,
v_rpt_arc.flow_max as flowmax,
v_rpt_arc.flow_min as flowmin,
v_rpt_arc.flow_avg as flowavg,
v_rpt_arc.vel_max as velmax,
v_rpt_arc.vel_min as velmin,
v_rpt_arc.vel_avg as velavg,
headloss_max, 
headloss_min, 
setting_max, 
setting_min, 
reaction_max, 
reaction_min, 
ffactor_max, 
ffactor_min
FROM inp_valve 
LEFT JOIN v_rpt_arc ON concat(node_id,'_n2a') = arc_id;

CREATE OR REPLACE VIEW ve_epa_shortpipe AS 
 SELECT inp_shortpipe.*,
concat(inp_shortpipe.node_id, '_n2a') AS nodarc_id,
v_rpt_arc.result_id,
v_rpt_arc.flow_max as flowmax,
v_rpt_arc.flow_min as flowmin,
v_rpt_arc.flow_avg as flowavg,
v_rpt_arc.vel_max as velmax,
v_rpt_arc.vel_min as velmin,
v_rpt_arc.vel_avg as velavg,
v_rpt_arc.headloss_max,
v_rpt_arc.headloss_min,
v_rpt_arc.setting_max,
v_rpt_arc.setting_min,
v_rpt_arc.reaction_max,
v_rpt_arc.reaction_min,
v_rpt_arc.ffactor_max,
v_rpt_arc.ffactor_min
FROM inp_shortpipe
LEFT JOIN v_rpt_arc ON concat(inp_shortpipe.node_id, '_n2a') = v_rpt_arc.arc_id::text;

CREATE OR REPLACE VIEW ve_epa_virtualvalve AS 
SELECT inp_virtualvalve.*, 
result_id,
v_rpt_arc.flow_max as flowmax,
v_rpt_arc.flow_min as flowmin,
v_rpt_arc.flow_avg as flowavg,
v_rpt_arc.vel_max as velmax,
v_rpt_arc.vel_min as velmin,
v_rpt_arc.vel_avg as velavg,
headloss_max, 
headloss_min, 
setting_max, 
setting_min, 
reaction_max, 
reaction_min, 
ffactor_max, 
ffactor_min
FROM inp_virtualvalve 
LEFT JOIN v_rpt_arc USING (arc_id);

CREATE OR REPLACE VIEW ve_epa_pump_additional AS
SELECT inp_pump_additional.*, 
concat(node_id,'_n2a') as nodarc_id,
result_id,
v_rpt_arc.flow_max as flowmax,
v_rpt_arc.flow_min as flowmin,
v_rpt_arc.flow_avg as flowavg,
v_rpt_arc.vel_max as velmax,
v_rpt_arc.vel_min as velmin,
v_rpt_arc.vel_avg as velavg, 
headloss_max, 
headloss_min, 
setting_max, 
setting_min, 
reaction_max, 
reaction_min, 
ffactor_max, 
ffactor_min
FROM inp_pump_additional 
LEFT JOIN v_rpt_arc ON concat(node_id,'_n2a',order_id) = arc_id;


CREATE OR REPLACE VIEW ve_epa_connec AS
SELECT inp_connec.*, 
result_id,
demand_max as demandmax, 
demand_min as demandmin,
demand_avg as demandavg,
head_max as headmax,
head_min as headmin, 
head_avg as headavg,
press_max as pressmax,
press_min as pressmin, 
press_avg as pressavg,
quality_max as qualmax, 
quality_min as qualmin, 
quality_avg as qualavg
FROM inp_connec 
LEFT JOIN v_rpt_node ON connec_id = node_id;


CREATE OR REPLACE VIEW vu_arc  AS
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.node_2,
    arc.elevation1,
    arc.depth1,
    arc.elevation2,
    arc.depth2,
    arc.arccat_id,
    cat_arc.arctype_id AS arc_type,
    cat_feature.system_id AS sys_type,
    cat_arc.matcat_id AS cat_matcat_id,
    cat_arc.pnom AS cat_pnom,
    cat_arc.dnom AS cat_dnom,
    arc.epa_type,
    arc.expl_id,
    exploitation.macroexpl_id,
    arc.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    arc.observ,
    arc.comment,
    st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.minsector_id,
    arc.dma_id,
    dma.name AS dma_name,
    dma.macrodma_id,
    arc.presszone_id,
    presszone.name AS presszone_name,
    arc.dqa_id,
    dqa.name AS dqa_name,
    dqa.macrodqa_id,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.buildercat_id,
    arc.builtdate,
    arc.enddate,
    arc.ownercat_id,
    arc.muni_id,
    arc.postcode,
    arc.district_id,
    c.descript::character varying(100) AS streetname,
    arc.postnumber,
    arc.postcomplement,
    d.descript::character varying(100) AS streetname2,
    arc.postnumber2,
    arc.postcomplement2,
    arc.descript,
    concat(cat_feature.link_path, arc.link) AS link,
    arc.verified,
    arc.undelete,
    cat_arc.label,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.publish,
    arc.inventory,
    arc.num_value,
    cat_arc.arctype_id AS cat_arctype_id,
    arc.nodetype_1,
    arc.staticpress1,
    arc.nodetype_2,
    arc.staticpress2,
    date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
    arc.depth,
    arc.adate,
    arc.adescript,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    arc.workcat_id_plan,
    arc.asset_id,
    arc.pavcat_id,
    arc.om_state,
    arc.conserv_state,
    e.flow_max,
    e.flow_min,
    e.flow_avg,
    e.vel_max,
    e.vel_min,
    e.vel_avg,
    arc.parent_id,
    arc.expl_id2,
    vst.is_operative,
    mu.region_id,
    mu.province_id
   FROM arc
     LEFT JOIN sector ON arc.sector_id = sector.sector_id
     LEFT JOIN exploitation ON arc.expl_id = exploitation.expl_id
     LEFT JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arctype_id::text
     LEFT JOIN dma ON arc.dma_id = dma.dma_id
     LEFT JOIN dqa ON arc.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id::text = arc.presszone_id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text
     LEFT JOIN arc_add e ON arc.arc_id::text = e.arc_id::text
     LEFT JOIN value_state_type vst ON vst.id = state_type
     LEFT JOIN ext_municipality mu ON arc.muni_id = mu.muni_id;


CREATE OR REPLACE VIEW v_arc AS 
SELECT vu_arc.*
FROM vu_arc
JOIN v_state_arc USING (arc_id)
JOIN v_expl_arc e on e.arc_id = vu_arc.arc_id;


CREATE OR REPLACE VIEW v_edit_arc AS 
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW ve_arc AS 
SELECT * FROM v_arc;


SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_arc"], "fieldName":"is_operative", "action":"ADD-FIELD","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_arc"], "fieldName":"region_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_arc"], "fieldName":"province_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);


CREATE OR REPLACE VIEW vu_node AS
 SELECT node.node_id,
    node.code,
    node.elevation,
    node.depth,
    cat_node.nodetype_id AS node_type,
    cat_feature.system_id AS sys_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.expl_id,
    exploitation.macroexpl_id,
    node.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    node.arc_id,
    node.parent_id,
    node.state,
    node.state_type,
    node.annotation,
    node.observ,
    node.comment,
    node.minsector_id,
    node.dma_id,
    dma.name AS dma_name,
    dma.macrodma_id,
    node.presszone_id,
    presszone.name AS presszone_name,
    node.staticpressure,
    node.dqa_id,
    dqa.name AS dqa_name,
    dqa.macrodqa_id,
    node.soilcat_id,
    node.function_type,
    node.category_type,
    node.fluid_type,
    node.location_type,
    node.workcat_id,
    node.workcat_id_end,
    node.builtdate,
    node.enddate,
    node.buildercat_id,
    node.ownercat_id,
    node.muni_id,
    node.postcode,
    node.district_id,
    a.descript::character varying(100) AS streetname,
    node.postnumber,
    node.postcomplement,
    b.descript::character varying(100) AS streetname2,
    node.postnumber2,
    node.postcomplement2,
    node.descript,
    cat_node.svg,
    node.rotation,
    concat(cat_feature.link_path, node.link) AS link,
    node.verified,
    node.undelete,
    cat_node.label,
    node.label_x,
    node.label_y,
    node.label_rotation,
    node.publish,
    node.inventory,
    node.hemisphere,
    node.num_value,
    cat_node.nodetype_id,
    date_trunc('second'::text, node.tstamp) AS tstamp,
    node.insert_user,
    date_trunc('second'::text, node.lastupdate) AS lastupdate,
    node.lastupdate_user,
    node.the_geom,
    node.adate,
    node.adescript,
    node.accessibility,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    node.workcat_id_plan,
    node.asset_id,
    node.om_state,
    node.conserv_state,
    node.access_type,
    node.placement_type,
    e.demand_max,
    e.demand_min,
    e.demand_avg,
    e.press_max,
    e.press_min,
    e.press_avg,
    e.head_max,
    e.head_min,
    e.head_avg,
    e.quality_max,
    e.quality_min,
    e.quality_avg,
    node.expl_id2,
    vst.is_operative,
    mu.region_id,
    mu.province_id
   FROM node
     LEFT JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_node.nodetype_id::text
     LEFT JOIN dma ON node.dma_id = dma.dma_id
     LEFT JOIN sector ON node.sector_id = sector.sector_id
     LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
     LEFT JOIN dqa ON node.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id::text = node.presszone_id::text
     LEFT JOIN v_ext_streetaxis a ON a.id::text = node.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis b ON b.id::text = node.streetaxis2_id::text
     LEFT JOIN node_add e ON e.node_id::text = node.node_id::text
     LEFT JOIN value_state_type vst ON vst.id = state_type
     LEFT JOIN ext_municipality mu ON node.muni_id = mu.muni_id;


CREATE OR REPLACE VIEW v_node AS 
SELECT vu_node.*
FROM vu_node
JOIN v_state_node USING (node_id)
JOIN v_expl_node e on e.node_id = vu_node.node_id;


CREATE OR REPLACE VIEW v_edit_node AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.node_type,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.expl_id,
    v_node.macroexpl_id,
    v_node.sector_id,
    v_node.sector_name,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.minsector_id,
    v_node.dma_id,
    v_node.dma_name,
    v_node.macrodma_id,
    v_node.presszone_id,
    v_node.presszone_name,
    v_node.staticpressure,
    v_node.dqa_id,
    v_node.dqa_name,
    v_node.macrodqa_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.builtdate,
    v_node.enddate,
    v_node.buildercat_id,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.district_id,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.undelete,
    v_node.label,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.hemisphere,
    v_node.num_value,
    v_node.nodetype_id,
    v_node.tstamp,
    v_node.insert_user,
    v_node.lastupdate,
    v_node.lastupdate_user,
    v_node.the_geom,
    v_node.adate,
    v_node.adescript,
    v_node.accessibility,
    v_node.dma_style,
    v_node.presszone_style,
    man_valve.closed AS closed_valve,
    man_valve.broken AS broken_valve,
    v_node.workcat_id_plan,
    v_node.asset_id,
    v_node.om_state,
    v_node.conserv_state,
    v_node.access_type,
    v_node.placement_type,
    v_node.demand_max, 
    v_node.demand_min, 
    v_node.demand_avg, 
    v_node.press_max, 
    v_node.press_min, 
    v_node.press_avg, 
    v_node.head_max, 
    v_node.head_min, 
    v_node.head_avg, 
    v_node.quality_max, 
    v_node.quality_min, 
    v_node.quality_avg,
    v_node.expl_id2,
    v_node.is_operative,
    v_node.region_id,
    v_node.province_id
   FROM v_node
     LEFT JOIN man_valve USING (node_id);

CREATE OR REPLACE VIEW ve_node AS 
SELECT * FROM v_node;


SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"is_operative", "action":"ADD-FIELD","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"region_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"province_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);



CREATE OR REPLACE VIEW vu_connec  AS
 SELECT connec.connec_id,
    connec.code,
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id AS connec_type,
    cat_feature.system_id AS sys_type,
    connec.connecat_id,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    connec.customer_code,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    connec.connec_length,
    connec.state,
    connec.state_type,
    a.n_hydrometer,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.minsector_id,
    connec.dma_id,
    dma.name AS dma_name,
    dma.macrodma_id,
    connec.presszone_id,
    presszone.name AS presszone_name,
    connec.staticpressure,
    connec.dqa_id,
    dqa.name AS dqa_name,
    dqa.macrodqa_id,
    connec.soilcat_id,
    connec.function_type,
    connec.category_type,
    connec.fluid_type,
    connec.location_type,
    connec.workcat_id,
    connec.workcat_id_end,
    connec.buildercat_id,
    connec.builtdate,
    connec.enddate,
    connec.ownercat_id,
    connec.muni_id,
    connec.postcode,
    connec.district_id,
    c.descript::character varying(100) AS streetname,
    connec.postnumber,
    connec.postcomplement,
    b.descript::character varying(100) AS streetname2,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    cat_connec.svg,
    connec.rotation,
    concat(cat_feature.link_path, connec.link) AS link,
    connec.verified,
    connec.undelete,
    cat_connec.label,
    connec.label_x,
    connec.label_y, 
    connec.label_rotation,
    connec.publish,
    connec.inventory,
    connec.num_value,
    cat_connec.connectype_id,
    connec.pjoint_id,
    connec.pjoint_type,
    date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom,
    connec.adate,
    connec.adescript,
    connec.accessibility,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    connec.workcat_id_plan,
    connec.asset_id,
    connec.epa_type,
    connec.om_state,
    connec.conserv_state,
    connec.priority,
    connec.valve_location,
    connec.valve_type,
    connec.shutoff_valve,
    connec.access_type,
    connec.placement_type,
    connec.crmzone_id,
    crm_zone.name AS crmzone_name,
    e.press_max,
    e.press_min,
    e.press_avg,
    e.demand,
    connec.expl_id2,
    e.quality_max,
    e.quality_min,
    e.quality_avg,
	vst.is_operative,
    mu.region_id,
    mu.province_id
   FROM connec
     LEFT JOIN ( SELECT connec_1.connec_id,
            count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
           FROM selector_hydrometer,
            ext_rtc_hydrometer
             JOIN connec connec_1 ON ext_rtc_hydrometer.connec_id::text = connec_1.customer_code::text
          WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text
          GROUP BY connec_1.connec_id) a USING (connec_id)
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN cat_feature ON cat_feature.id::text = cat_connec.connectype_id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
     LEFT JOIN dqa ON connec.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id::text = connec.presszone_id::text
     LEFT JOIN crm_zone ON crm_zone.id::text = connec.crmzone_id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = connec.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis b ON b.id::text = connec.streetaxis2_id::text
     LEFT JOIN connec_add e ON e.connec_id::text = connec.connec_id::text
     LEFT JOIN value_state_type vst ON vst.id = state_type
     LEFT JOIN ext_municipality mu ON connec.muni_id = mu.muni_id;



CREATE OR REPLACE VIEW v_connec AS 
 SELECT vu_connec.connec_id,
    vu_connec.code,
    vu_connec.elevation,
    vu_connec.depth,
    vu_connec.connec_type,
    vu_connec.sys_type,
    vu_connec.connecat_id,
    vu_connec.expl_id,
    vu_connec.macroexpl_id,
    (case when a.sector_id is null then vu_connec.sector_id else a.sector_id end) as sector_id,
    vu_connec.sector_name,
    vu_connec.macrosector_id,
    vu_connec.customer_code,
    vu_connec.cat_matcat_id,
    vu_connec.cat_pnom,
    vu_connec.cat_dnom,
    vu_connec.connec_length,
    vu_connec.state,
    vu_connec.state_type,
    vu_connec.n_hydrometer,
    v_state_connec.arc_id,
    vu_connec.annotation,
    vu_connec.observ,
    vu_connec.comment,
    (case when a.minsector_id is null then vu_connec.minsector_id else a.minsector_id end) as minsector_id,
    (case when a.dma_id is null then vu_connec.dma_id else a.dma_id end) as dma_id,
    (case when a.dma_name is null then vu_connec.dma_name else a.dma_name end) as dma_name,
    (case when a.macrodma_id is null then vu_connec.macrodma_id else a.macrodma_id end) as macrodma_id,
    (case when a.presszone_id is null then vu_connec.presszone_id::varchar(30) else a.presszone_id::varchar(30) end) as presszone_id,
    (case when a.presszone_name is null then vu_connec.presszone_name else a.presszone_name end) as presszone_name,
    vu_connec.staticpressure,
    (case when a.dqa_id is null then vu_connec.dqa_id else a.dqa_id end) as dqa_id,
    (case when a.dqa_name is null then vu_connec.dqa_name else a.dqa_name end) as dqa_name,
    (case when a.macrodqa_id is null then vu_connec.macrodqa_id else a.macrodqa_id end) as macrodqa_id,
    vu_connec.soilcat_id,
    vu_connec.function_type,
    vu_connec.category_type,
    vu_connec.fluid_type,
    vu_connec.location_type,
    vu_connec.workcat_id,
    vu_connec.workcat_id_end,
    vu_connec.buildercat_id,
    vu_connec.builtdate,
    vu_connec.enddate,
    vu_connec.ownercat_id,
    vu_connec.muni_id,
    vu_connec.postcode,
    vu_connec.district_id,
    vu_connec.streetname,
    vu_connec.postnumber,
    vu_connec.postcomplement,
    vu_connec.streetname2,
    vu_connec.postnumber2,
    vu_connec.postcomplement2,
    vu_connec.descript,
    vu_connec.svg,
    vu_connec.rotation,
    vu_connec.link,
    vu_connec.verified,
    vu_connec.undelete,
    vu_connec.label,
    vu_connec.label_x,
    vu_connec.label_y,
    vu_connec.label_rotation,
    vu_connec.publish,
    vu_connec.inventory,
    vu_connec.num_value,
    vu_connec.connectype_id,
    (case when a.exit_id is null then vu_connec.pjoint_id else a.exit_id end) as pjoint_id,
    (case when a.exit_type is null then vu_connec.pjoint_type else a.exit_type end) as pjoint_type,
    vu_connec.tstamp,
    vu_connec.insert_user,
    vu_connec.lastupdate,
    vu_connec.lastupdate_user,
    vu_connec.the_geom,
    vu_connec.adate,
    vu_connec.adescript,
    vu_connec.accessibility,
    vu_connec.workcat_id_plan,
    vu_connec.asset_id,
    vu_connec.dma_style,
    vu_connec.presszone_style,
    vu_connec.epa_type,
    vu_connec.priority,
    vu_connec.valve_location,
    vu_connec.valve_type,
    vu_connec.shutoff_valve,
    vu_connec.access_type,
    vu_connec.placement_type,
    vu_connec.press_max,
    vu_connec.press_min,
    vu_connec.press_avg,
    vu_connec.demand,
    vu_connec.om_state,
    vu_connec.conserv_state,
    crmzone_id,
    crmzone_name,
    vu_connec.expl_id2,
    vu_connec.quality_max,
    vu_connec.quality_min,
    vu_connec.quality_avg,	
    vu_connec.is_operative,
    vu_connec.region_id,
    vu_connec.province_id
   FROM vu_connec
     JOIN v_state_connec USING (connec_id)
    LEFT JOIN (SELECT DISTINCT ON (feature_id) * FROM v_link_connec WHERE state = 2) a ON feature_id = connec_id;
    

CREATE OR REPLACE VIEW v_edit_connec AS 
SELECT * FROM v_connec;

CREATE OR REPLACE VIEW ve_connec AS 
SELECT * FROM v_connec;


SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_connec"], "fieldName":"is_operative", "action":"ADD-FIELD","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_connec"], "fieldName":"region_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_connec"], "fieldName":"province_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);


CREATE OR REPLACE VIEW vu_link AS
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    presszone_id::character varying(16) AS presszone_id,
    l.dqa_id,
    l.minsector_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    d.name AS dma_name,
    q.name AS dqa_name,
    p.name AS presszone_name,
    s.macrosector_id,
    d.macrodma_id,
    q.macrodqa_id,
    l.expl_id2,
    l.epa_type,
    l.is_operative
   FROM link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN presszone p USING (presszone_id)
     LEFT JOIN dma d USING (dma_id)
     LEFT JOIN dqa q USING (dqa_id);


create or replace view v_link_connec as 
select * from vu_link
JOIN v_state_link_connec USING (link_id);


create or replace view v_link as 
select * from vu_link
JOIN v_state_link USING (link_id);

CREATE OR REPLACE VIEW v_edit_link AS SELECT *
FROM v_link l;


DROP VIEW IF EXISTS v_rtc_hydrometer_x_connec;
ALTER VIEW IF EXISTS v_rtc_hydrometer RENAME TO v_rtc_hydrometer_x_connec ;


CREATE OR REPLACE VIEW v_rtc_hydrometer_x_node
 AS
SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN node.node_id IS NULL THEN 'XXXX'::character varying
            ELSE node.node_id
        END AS node_id,
        CASE
            WHEN ext_rtc_hydrometer.connec_id::text IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id::text
        END AS node_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    node.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
   FROM selector_hydrometer,
    selector_expl,
    rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.connec_id::text
     JOIN node ON node.node_id = man_netwjoin.node_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = node.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text AND selector_expl.expl_id = node.expl_id AND selector_expl.cur_user = "current_user"()::text;

DROP VIEW IF EXISTS v_ui_hydrometer;
CREATE OR REPLACE VIEW v_ui_hydrometer
 AS
 SELECT hydrometer_id,
    connec_id as feature_id,
    hydrometer_customer_code,
    connec_customer_code AS feature_customer_code,
    state,
    expl_name,
    hydrometer_link
   FROM v_rtc_hydrometer_x_connec
UNION
 SELECT hydrometer_id,
    node_id,
    hydrometer_customer_code,
    node_customer_code,
    state,
    expl_name,
    hydrometer_link
   FROM v_rtc_hydrometer_x_node;

CREATE OR REPLACE VIEW v_rtc_hydrometer
 AS
 SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN connec.connec_id IS NULL THEN 'XXXX'::character varying
            ELSE connec.connec_id
        END AS feature_id,
        'CONNEC' AS feature_type,
        CASE
            WHEN ext_rtc_hydrometer.connec_id::text IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id::text
        END AS customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    connec.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
   FROM selector_hydrometer,
    selector_expl,
    rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id::text
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text AND selector_expl.expl_id = connec.expl_id AND selector_expl.cur_user = "current_user"()::text
UNION
SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN node.node_id IS NULL THEN 'XXXX'::character varying
            ELSE node.node_id
        END AS node_id,
        'NODE' AS feature_type,
        CASE
            WHEN ext_rtc_hydrometer.connec_id::text IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id::text
        END AS node_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    node.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
   FROM selector_hydrometer,
    selector_expl,
    rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.connec_id::text
     JOIN node ON node.node_id = man_netwjoin.node_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = node.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text AND selector_expl.expl_id = node.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_ui_hydroval
 AS
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_node.node_id as feature_id,
    node.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    ext_rtc_hydrometer.catalog_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum,
    crmtype.idval AS value_type,
    crmstatus.idval AS value_status,
    crmstate.idval AS value_state
   FROM ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::text = ext_rtc_hydrometer.id::text
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.catalog_id::text
     JOIN rtc_hydrometer_x_node ON rtc_hydrometer_x_node.hydrometer_id::text = ext_rtc_hydrometer_x_data.hydrometer_id::text
     JOIN node ON rtc_hydrometer_x_node.node_id::text = node.node_id::text
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
UNION
 SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
    connec.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    ext_rtc_hydrometer.catalog_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum,
    crmtype.idval AS value_type,
    crmstatus.idval AS value_status,
    crmstate.idval AS value_state
   FROM ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::text = ext_rtc_hydrometer.id::text
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.catalog_id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::text = ext_rtc_hydrometer_x_data.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
  ORDER BY 1;


-- 28/05/2023
CREATE OR REPLACE VIEW v_edit_inp_virtualpump AS 
 SELECT
    a.arc_id,
    a.node_1,
    a.node_2,
    a.arccat_id,
    a.sector_id,
    a.state,
    a.state_type,
    a.annotation,
    a.expl_id,
    a.dma_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    energyvalue,
    effic_curve_id,
    energy_price,
    energy_pattern_id,
    p.pump_type,
    a.the_geom
   FROM selector_sector ss, v_arc a
     JOIN inp_virtualpump p USING (arc_id)
     WHERE a.sector_id = ss.sector_id AND ss.cur_user = "current_user"()::text AND a.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_virtualpump AS 
 SELECT
    v.dscenario_id,
    p.arc_id,
    v.power,
    v.curve_id,
    v.speed,
    v.pattern_id,
    v.status,
    v.pump_type,
    v.energyvalue,
    v.effic_curve_id,
    v.energy_price,
    v.energy_pattern_id,
    p.the_geom
   FROM selector_inp_dscenario, v_edit_inp_virtualpump p 
     JOIN inp_dscenario_virtualpump v USING (arc_id)
  WHERE v.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_epa_virtualpump AS 
 SELECT p.arc_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.energyvalue,
    p.pump_type,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    v_rpt_arc.result_id,
    v_rpt_arc.flow_max AS flowmax,
    v_rpt_arc.flow_min AS flowmin,
    v_rpt_arc.flow_avg AS flowavg,
    v_rpt_arc.vel_max AS velmax,
    v_rpt_arc.vel_min AS velmin,
    v_rpt_arc.vel_avg AS velavg,
    v_rpt_arc.headloss_max,
    v_rpt_arc.headloss_min,
    v_rpt_arc.setting_max,
    v_rpt_arc.setting_min,
    v_rpt_arc.reaction_max,
    v_rpt_arc.reaction_min,
    v_rpt_arc.ffactor_max,
    v_rpt_arc.ffactor_min
   FROM inp_virtualpump p
     LEFT JOIN v_rpt_arc USING (arc_id);


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
  WHERE temp_arc.epa_type::text IN('PUMP', 'VIRTUALPUMP') AND NOT (temp_arc.arc_id::text IN ( SELECT vi_valves.arc_id
           FROM vi_valves))
  ORDER BY temp_arc.arc_id;
  
  --2022/01/03
DROP VIEW IF EXISTS v_edit_inp_dscenario_junction;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_junction AS 
SELECT p.dscenario_id,
p.node_id,
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
AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND is_operative is true;


DROP VIEW IF EXISTS v_edit_inp_junction;
CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.expl_id,
n.sector_id,
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
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative is true;


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
FROM selector_sector, selector_inp_dscenario,v_node n
JOIN inp_dscenario_pump p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id 
AND selector_inp_dscenario.cur_user = "current_user"()::text AND is_operative is true;



DROP VIEW IF EXISTS v_edit_inp_pump_additional;
CREATE OR REPLACE VIEW v_edit_inp_pump_additional AS 
SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.expl_id,
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
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative is true;


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
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id 
AND selector_inp_dscenario.cur_user = "current_user"()::text AND is_operative is true;

DROP VIEW IF EXISTS v_edit_inp_pump;
CREATE OR REPLACE VIEW v_edit_inp_pump AS 
SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.expl_id,
n.sector_id,
n.dma_id,
n.state,
n.state_type,
n.annotation,
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
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative is true;



DROP VIEW IF EXISTS v_edit_inp_dscenario_pipe;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_pipe AS 
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
JOIN inp_dscenario_pipe p USING (arc_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE a.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND is_operative is true;


DROP VIEW IF EXISTS v_edit_inp_pipe;
CREATE OR REPLACE VIEW v_edit_inp_pipe AS 
 SELECT arc.arc_id,
arc.node_1,
arc.node_2,
arc.arccat_id,
arc.expl_id,
arc.sector_id,
arc.dma_id,
arc.state,
arc.state_type,
arc.custom_length,
arc.annotation,
minorloss,
status,
custom_roughness,
custom_dint,
bulk_coeff,
wall_coeff,
arc.the_geom
FROM selector_sector,v_arc arc
JOIN inp_pipe USING (arc_id)
WHERE arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative is true;


DROP VIEW IF EXISTS v_edit_inp_dscenario_shortpipe;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_shortpipe AS 
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
p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND is_operative is true;


DROP VIEW IF EXISTS v_edit_inp_shortpipe;
CREATE OR REPLACE VIEW v_edit_inp_shortpipe AS 
 SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.expl_id,
n.sector_id,
n.dma_id,
n.state,
n.state_type,
n.annotation,
concat(n.node_id,'_n2a') AS nodarc_id,
minorloss,
to_arc,
status,
bulk_coeff,
wall_coeff,
n.the_geom
FROM selector_sector, v_node n
JOIN inp_shortpipe USING (node_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative is true;
  

DROP VIEW IF EXISTS v_edit_inp_dscenario_tank;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_tank AS 
SELECT d.dscenario_id,
p.node_id,
p.initlevel,
p.minlevel,
p.maxlevel,
p.diameter,
p.minvol,
p.curve_id,
p.overflow,
mixing_model,
mixing_fraction,
reaction_coeff,
init_quality,
source_type,
source_quality,
source_pattern_id,
n.the_geom
FROM selector_inp_dscenario, v_node n
JOIN inp_dscenario_tank p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
JOIN v_sector_node s ON s.node_id = n. node_id
WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND is_operative is true;

  
DROP VIEW IF EXISTS v_edit_inp_tank;
CREATE OR REPLACE VIEW v_edit_inp_tank AS 
 SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.expl_id,
n.sector_id,
n.dma_id,
n.state,
n.state_type,
n.annotation,
initlevel,
minlevel,
maxlevel,
diameter,
minvol,
curve_id,
overflow,
mixing_model,
mixing_fraction,
reaction_coeff,
init_quality,
source_type,
source_quality,
source_pattern_id,
n.the_geom
FROM v_node n
JOIN inp_tank USING (node_id)
JOIN v_sector_node s ON s.node_id = n. node_id
WHERE is_operative is true;


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
AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND is_operative is true;

  
DROP VIEW IF EXISTS v_edit_inp_reservoir;
CREATE OR REPLACE VIEW v_edit_inp_reservoir AS 
 SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.expl_id,
n.sector_id,
n.dma_id,
n.state,
n.state_type,
n.annotation,
pattern_id,
head,
init_quality,
source_type,
source_quality,
source_pattern_id,
n.the_geom
FROM selector_sector, v_node n
JOIN inp_reservoir USING (node_id)
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative is true;


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
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id 
AND selector_inp_dscenario.cur_user = "current_user"()::text AND is_operative is true;

  
DROP VIEW IF EXISTS v_edit_inp_valve;
CREATE OR REPLACE VIEW v_edit_inp_valve AS 
SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.expl_id,
n.sector_id,
n.dma_id,
n.state,
n.state_type,
n.annotation,
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
WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative is true;

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
init_quality,
a.the_geom
FROM selector_sector, selector_inp_dscenario, v_arc a
JOIN inp_dscenario_virtualvalve p USING (arc_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE a.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND is_operative is true;


DROP VIEW IF EXISTS v_edit_inp_virtualvalve;
CREATE OR REPLACE VIEW v_edit_inp_virtualvalve AS 
SELECT v_arc.arc_id,
v_arc.node_1,
v_arc.node_2,
(v_arc.elevation1 + v_arc.elevation2) / 2::numeric AS elevation,
(v_arc.depth1 + v_arc.depth2) / 2::numeric AS depth,
v_arc.arccat_id,
v_arc.expl_id,
v_arc.sector_id,
v_arc.dma_id,
v_arc.state,
v_arc.state_type,
v_arc.custom_length,
v_arc.annotation,
valv_type,
pressure,
flow,
coef_loss,
curve_id,
minorloss,
status,
init_quality,
v_arc.the_geom
FROM selector_sector,v_arc
JOIN inp_virtualvalve USING (arc_id)
WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative is true;


DROP VIEW IF EXISTS v_edit_inp_dscenario_inlet;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_inlet AS 
SELECT p.dscenario_id, 
n.node_id, 
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
FROM selector_inp_dscenario, v_node n
JOIN inp_dscenario_inlet p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
JOIN v_sector_node s ON s.node_id = n. node_id
WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND is_operative is true;


DROP VIEW IF EXISTS v_edit_inp_inlet;
CREATE OR REPLACE VIEW v_edit_inp_inlet AS 
 SELECT n.node_id,
n.elevation,
n.depth,
n.nodecat_id,
n.expl_id,
n.sector_id,
n.dma_id,
n.state,
n.state_type,
n.annotation,
initlevel,
minlevel,
maxlevel,
diameter,
minvol,
curve_id,
overflow,
pattern_id,
head,
mixing_model,
mixing_fraction,
reaction_coeff,
init_quality,
source_type,
source_quality,
source_pattern_id,
n.the_geom
FROM v_node n
JOIN inp_inlet USING (node_id)
JOIN v_sector_node s ON s.node_id = n. node_id
WHERE is_operative is true;


DROP VIEW IF EXISTS v_edit_inp_dscenario_connec;
DROP VIEW IF EXISTS v_edit_inp_connec;
CREATE OR REPLACE VIEW v_edit_inp_connec AS 
 SELECT connec.connec_id,
connec.elevation,
connec.depth,
connec.connecat_id,
connec.arc_id,
connec.expl_id,
connec.sector_id,
connec.dma_id,
connec.state,
connec.state_type,
connec.pjoint_type,
connec.pjoint_id,
connec.annotation,
inp_connec.demand,
inp_connec.pattern_id,
inp_connec.peak_factor,
inp_connec.status,
inp_connec.minorloss,
inp_connec.custom_roughness,
inp_connec.custom_length,
inp_connec.custom_dint,
emitter_coeff,
init_quality,
source_type,
source_quality,
source_pattern_id,
connec.the_geom
FROM selector_sector,v_connec connec
JOIN inp_connec USING (connec_id)
WHERE connec.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative is true;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_connec AS 
SELECT d.dscenario_id,
connec.connec_id,
connec.pjoint_type,
connec.pjoint_id,
c.demand,
c.pattern_id,
c.peak_factor,
c.status,
c.minorloss,
c.custom_roughness,
c.custom_length,
c.custom_dint,
c.emitter_coeff,
c.init_quality,
c.source_type,
c.source_quality,
c.source_pattern_id,
connec.the_geom
   FROM selector_inp_dscenario,
    v_edit_inp_connec connec
     JOIN inp_dscenario_connec c USING (connec_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE c.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;
