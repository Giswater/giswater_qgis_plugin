/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/03/2026

CREATE OR REPLACE VIEW ve_inp_dscenario_inlet
AS SELECT p.dscenario_id,
    n.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    p.mixing_model,
    p.mixing_fraction,
    p.reaction_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    p.head,
    p.pattern_id,
    p.demand,
    p.demand_pattern_id,
    p.emitter_coeff,
    n.the_geom
FROM ve_node n
JOIN inp_dscenario_inlet p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id 
	AND s.cur_user = CURRENT_USER
) AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_junction
AS SELECT p.dscenario_id,
	p.node_id,
	p.demand,
	p.pattern_id,
	p.emitter_coeff,
	p.init_quality,
	p.source_type,
	p.source_quality,
	p.source_pattern_id,
	n.the_geom
FROM ve_node n
JOIN inp_dscenario_junction p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id 
	AND s.cur_user = CURRENT_USER
) AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_pipe
AS SELECT d.dscenario_id,
    p.arc_id,
    p.minorloss,
    p.status,
    p.roughness,
    p.dint,
    p.bulk_coeff,
    p.wall_coeff,
    a.the_geom
FROM ve_arc a
JOIN inp_dscenario_pipe p USING (arc_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id 
	AND s.cur_user = CURRENT_USER
) AND a.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_pump
AS SELECT d.dscenario_id,
    p.node_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    n.the_geom
FROM ve_node n
JOIN inp_dscenario_pump p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id 
	AND s.cur_user = CURRENT_USER
) AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_pump_additional
AS SELECT d.dscenario_id,
    p.node_id,
    p.order_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern_id,
    p.status,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    n.the_geom
FROM ve_node n
JOIN inp_dscenario_pump_additional p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id 
	AND s.cur_user = CURRENT_USER
) AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_reservoir
AS SELECT d.dscenario_id,
    p.node_id,
    p.pattern_id,
    p.head,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
FROM ve_node n
JOIN inp_dscenario_reservoir p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id 
	AND s.cur_user = CURRENT_USER
) AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_rules
AS SELECT i.id,
    d.dscenario_id,
    i.sector_id,
    i.text,
    i.active
FROM inp_dscenario_rules i
JOIN cat_dscenario d USING (dscenario_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = i.dscenario_id 
	AND s.cur_user = CURRENT_USER
);

CREATE OR REPLACE VIEW ve_inp_dscenario_shortpipe
AS SELECT d.dscenario_id,
    p.node_id,
    p.minorloss,
    p.status,
    p.bulk_coeff,
    p.wall_coeff,
    p.to_arc,
    p.head,
    p.pattern_id,
    p.demand,
    p.demand_pattern_id,
    p.emitter_coeff,
    n.the_geom
FROM ve_node n
JOIN inp_dscenario_shortpipe p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id 
	AND s.cur_user = CURRENT_USER
) AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_tank
AS SELECT d.dscenario_id,
    p.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    p.mixing_model,
    p.mixing_fraction,
    p.reaction_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
FROM ve_node n
JOIN inp_dscenario_tank p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id 
	AND s.cur_user = CURRENT_USER
) AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_valve
AS SELECT d.dscenario_id,
    p.node_id,
    concat(p.node_id, '_n2a') AS nodarc_id,
    p.valve_type,
    p.setting,
    p.curve_id,
    p.minorloss,
    p.status,
    p.add_settings,
    p.init_quality,
    p.to_arc,
    p.head,
    p.pattern_id,
    p.demand,
    p.demand_pattern_id,
    p.emitter_coeff,
    n.the_geom
FROM ve_node n
JOIN inp_dscenario_valve p USING (node_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id 
	AND s.cur_user = CURRENT_USER
) AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_virtualpump
AS SELECT v.dscenario_id,
    p.arc_id,
    v.power,
    v.curve_id,
    v.speed,
    v.pattern_id,
    v.status,
    v.pump_type,
    v.effic_curve_id,
    v.energy_price,
    v.energy_pattern_id,
    p.the_geom
FROM ve_inp_virtualpump p
JOIN inp_dscenario_virtualpump v USING (arc_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = v.dscenario_id 
	AND s.cur_user = CURRENT_USER
);

CREATE OR REPLACE VIEW ve_inp_dscenario_virtualvalve
AS SELECT d.dscenario_id,
    p.arc_id,
    p.valve_type,
    p.diameter,
    p.setting,
    p.curve_id,
    p.minorloss,
    p.status,
    p.init_quality,
    a.the_geom
FROM ve_arc a
JOIN inp_dscenario_virtualvalve p USING (arc_id)
JOIN cat_dscenario d USING (dscenario_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id 
	AND s.cur_user = CURRENT_USER
) AND a.is_operative IS TRUE;





