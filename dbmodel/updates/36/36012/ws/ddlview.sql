/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--26/07/2024
CREATE OR REPLACE VIEW v_ui_rpt_cat_result
AS SELECT DISTINCT ON (rpt_cat_result.result_id) rpt_cat_result.result_id,
    rpt_cat_result.expl_id,
    rpt_cat_result.sector_id,
    t2.idval AS network_type,
    t1.idval AS status,
    rpt_cat_result.iscorporate,
    rpt_cat_result.descript,
    rpt_cat_result.exec_date,
    rpt_cat_result.cur_user,
    rpt_cat_result.export_options,
    rpt_cat_result.network_stats,
    rpt_cat_result.inp_options,
    rpt_cat_result.rpt_stats,
    rpt_cat_result.addparam
   FROM selector_expl s,
    rpt_cat_result
     LEFT JOIN inp_typevalue t1 ON rpt_cat_result.status::text = t1.id::text
     LEFT JOIN inp_typevalue t2 ON rpt_cat_result.network_type::text = t2.id::text
  WHERE t1.typevalue::text = 'inp_result_status'::text AND t2.typevalue::text = 'inp_options_networkmode'::text AND ((s.expl_id = ANY (rpt_cat_result.expl_id)) AND s.cur_user = CURRENT_USER OR rpt_cat_result.expl_id = ARRAY[NULL]::INTEGER[]);

/*
v_edit_field_valve
v_ui_node_x_relations
v_ui_workcat_x_feature_end
ve_pol_node
ve_pol_register
ve_pol_tank
v_edit_inp_dscenario_junction
v_edit_inp_dscenario_pump
v_edit_inp_dscenario_pump_additional
v_edit_inp_dscenario_shortpipe
v_edit_inp_dscenario_tank
v_edit_inp_dscenario_reservoir
v_edit_inp_dscenario_valve
v_edit_inp_dscenario_inlet
v_edit_inp_pump_additional
v_edit_inp_pump
v_edit_inp_shortpipe
v_edit_inp_tank
v_edit_inp_reservoir
v_edit_inp_valve
v_edit_inp_inlet
*/

CREATE OR REPLACE VIEW v_edit_field_valve AS
SELECT v_edit_node.node_id,
    v_edit_node.code,
    v_edit_node.elevation,
    v_edit_node.depth,
    v_edit_node.nodetype_id,
    v_edit_node.nodecat_id,
    v_edit_node.cat_matcat_id,
    v_edit_node.cat_pnom,
    v_edit_node.cat_dnom,
    v_edit_node.epa_type,
    v_edit_node.sector_id,
    v_edit_node.macrosector_id,
    v_edit_node.arc_id,
    v_edit_node.parent_id,
    v_edit_node.state,
    v_edit_node.state_type,
    v_edit_node.annotation,
    v_edit_node.observ,
    v_edit_node.comment,
    v_edit_node.dma_id,
    v_edit_node.presszone_id,
    v_edit_node.soilcat_id,
    v_edit_node.function_type,
    v_edit_node.category_type,
    v_edit_node.fluid_type,
    v_edit_node.location_type,
    v_edit_node.workcat_id,
    v_edit_node.workcat_id_end,
    v_edit_node.buildercat_id,
    v_edit_node.builtdate,
    v_edit_node.enddate,
    v_edit_node.ownercat_id,
    v_edit_node.muni_id,
    v_edit_node.postcode,
    v_edit_node.district_id,
    v_edit_node.streetname,
    v_edit_node.postnumber,
    v_edit_node.postcomplement,
    v_edit_node.postcomplement2,
    v_edit_node.streetname2,
    v_edit_node.postnumber2,
    v_edit_node.descript,
    v_edit_node.svg,
    v_edit_node.rotation,
    v_edit_node.link,
    v_edit_node.verified,
    v_edit_node.undelete,
    v_edit_node.label_x,
    v_edit_node.label_y,
    v_edit_node.label_rotation,
    v_edit_node.publish,
    v_edit_node.inventory,
    v_edit_node.macrodma_id,
    v_edit_node.expl_id,
    v_edit_node.hemisphere,
    v_edit_node.num_value,
    v_edit_node.the_geom,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2,
    man_valve.ordinarystatus
   FROM v_edit_node
     JOIN man_valve ON man_valve.node_id::text = v_edit_node.node_id::text;

CREATE OR REPLACE VIEW v_ui_node_x_relations AS
SELECT row_number() OVER (ORDER BY v_edit_node.node_id) AS rid,
    v_edit_node.parent_id AS node_id,
    v_edit_node.nodetype_id,
    v_edit_node.nodecat_id,
    v_edit_node.node_id AS child_id,
    v_edit_node.code,
    v_edit_node.sys_type,
    'v_edit_node'::text AS sys_table_id
   FROM v_edit_node
  WHERE v_edit_node.parent_id IS NOT NULL;

CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end as
SELECT row_number() OVER (ORDER BY v_edit_arc.arc_id) + 1000000 AS rid,
    'ARC'::character varying AS feature_type,
    v_edit_arc.arccat_id AS featurecat_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code,
    exploitation.name AS expl_name,
    v_edit_arc.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_arc
     JOIN exploitation ON exploitation.expl_id = v_edit_arc.expl_id
  WHERE v_edit_arc.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_node.node_id) + 2000000 AS rid,
    'NODE'::character varying AS feature_type,
    v_edit_node.nodecat_id AS featurecat_id,
    v_edit_node.node_id AS feature_id,
    v_edit_node.code,
    exploitation.name AS expl_name,
    v_edit_node.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_node
     JOIN exploitation ON exploitation.expl_id = v_edit_node.expl_id
  WHERE v_edit_node.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_connec.connec_id) + 3000000 AS rid,
    'CONNEC'::character varying AS feature_type,
    v_edit_connec.connecat_id AS featurecat_id,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code,
    exploitation.name AS expl_name,
    v_edit_connec.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_connec
     JOIN exploitation ON exploitation.expl_id = v_edit_connec.expl_id
  WHERE v_edit_connec.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_element.element_id) + 4000000 AS rid,
    'ELEMENT'::character varying AS feature_type,
    v_edit_element.elementcat_id AS featurecat_id,
    v_edit_element.element_id AS feature_id,
    v_edit_element.code,
    exploitation.name AS expl_name,
    v_edit_element.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_element
     JOIN exploitation ON exploitation.expl_id = v_edit_element.expl_id
  WHERE v_edit_element.state = 0;

CREATE OR REPLACE VIEW ve_pol_node as
SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM polygon
   JOIN v_edit_node ON polygon.feature_id::text = v_edit_node.node_id::text;

CREATE OR REPLACE VIEW ve_pol_register
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
    --JOIN v_edit_node on polygon.feature_id = v_edit_node.node_id
  WHERE polygon.sys_type::text = 'REGISTER'::text;

CREATE OR REPLACE VIEW ve_pol_tank
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
    FROM polygon
    --JOIN v_edit_node ON polygon.feature_id = v_edit_node.node_id
  WHERE polygon.sys_type::text = 'TANK'::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_junction AS
SELECT p.dscenario_id,
    p.node_id,
    p.demand,
    p.pattern_id,
    p.emitter_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
   FROM selector_sector,
    selector_inp_dscenario,
    v_edit_node n
     JOIN inp_dscenario_junction p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump as
SELECT d.dscenario_id,
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
   FROM selector_sector,
    selector_inp_dscenario,
    v_edit_node n
     JOIN inp_dscenario_pump p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_pump_additional
AS SELECT n.node_id,
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
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    n.the_geom
   FROM selector_sector,
    v_edit_node n
     JOIN inp_pump_additional p USING (node_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump_additional
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
   FROM selector_sector,
    selector_inp_dscenario,
    v_edit_node n
     JOIN inp_dscenario_pump_additional p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_pump
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern_id,
    inp_pump.to_arc,
    inp_pump.status,
    inp_pump.pump_type,
    inp_pump.effic_curve_id,
    inp_pump.energy_price,
    inp_pump.energy_pattern_id,
    n.the_geom
   FROM selector_sector,
    v_edit_node n
     JOIN inp_pump USING (node_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_shortpipe
AS SELECT d.dscenario_id,
    p.node_id,
    p.minorloss,
    p.status,
    p.bulk_coeff,
    p.wall_coeff,
    n.the_geom
   FROM selector_sector,
    selector_inp_dscenario,
    v_edit_node n
     JOIN inp_dscenario_shortpipe p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_shortpipe
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_shortpipe.minorloss,
    c.to_arc,
        CASE
            WHEN c.node_id IS NOT NULL THEN 'CV'::character varying(12)
            WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
            ELSE NULL::character varying(12)
        END AS status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    n.the_geom
   FROM selector_sector,
    v_edit_node n
     JOIN inp_shortpipe USING (node_id)
     LEFT JOIN config_graph_checkvalve c ON c.node_id::text = n.node_id::text
     LEFT JOIN man_valve v ON v.node_id::text = n.node_id::text
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_tank
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
   FROM selector_inp_dscenario,
    v_edit_node n
     JOIN inp_dscenario_tank p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
     JOIN v_sector_node s ON s.node_id::text = n.node_id::text
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_tank
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id,
    inp_tank.overflow,
    inp_tank.mixing_model,
    inp_tank.mixing_fraction,
    inp_tank.reaction_coeff,
    inp_tank.init_quality,
    inp_tank.source_type,
    inp_tank.source_quality,
    inp_tank.source_pattern_id,
    n.the_geom
   FROM v_edit_node n
     JOIN inp_tank USING (node_id)
     JOIN v_sector_node s ON s.node_id::text = n.node_id::text
  WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_reservoir
AS SELECT d.dscenario_id,
    p.node_id,
    p.pattern_id,
    p.head,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
   FROM selector_sector,
    selector_inp_dscenario,
    v_edit_node n
     JOIN inp_dscenario_reservoir p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_reservoir
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_reservoir.pattern_id,
    inp_reservoir.head,
    inp_reservoir.init_quality,
    inp_reservoir.source_type,
    inp_reservoir.source_quality,
    inp_reservoir.source_pattern_id,
    n.the_geom
   FROM selector_sector,
    v_edit_node n
     JOIN inp_reservoir USING (node_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_valve
AS SELECT d.dscenario_id,
    p.node_id,
    concat(p.node_id, '_n2a') AS nodarc_id,
    p.valv_type,
    p.pressure,
    p.flow,
    p.coef_loss,
    p.curve_id,
    p.minorloss,
    p.status,
    p.add_settings,
    p.init_quality,
    n.the_geom
   FROM selector_sector,
    selector_inp_dscenario,
    v_edit_node n
     JOIN inp_dscenario_valve p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_valve
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_valve.valv_type,
    inp_valve.pressure,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    inp_valve.to_arc,
    inp_valve.status,
    inp_valve.custom_dint,
    inp_valve.add_settings,
    inp_valve.init_quality,
    n.the_geom
   FROM selector_sector,
    v_edit_node n
     JOIN inp_valve USING (node_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_inlet
AS SELECT p.dscenario_id,
    n.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    p.head,
    p.pattern_id,
    p.mixing_model,
    p.mixing_fraction,
    p.reaction_coeff,
    p.init_quality,
    p.source_type,
    p.source_quality,
    p.source_pattern_id,
    n.the_geom
   FROM selector_inp_dscenario,
    v_edit_node n
     JOIN inp_dscenario_inlet p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
     JOIN v_sector_node s ON s.node_id::text = n.node_id::text
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND n.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_inlet
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.overflow,
    inp_inlet.pattern_id,
    inp_inlet.head,
    inp_inlet.mixing_model,
    inp_inlet.mixing_fraction,
    inp_inlet.reaction_coeff,
    inp_inlet.init_quality,
    inp_inlet.source_type,
    inp_inlet.source_quality,
    inp_inlet.source_pattern_id,
    n.the_geom
   FROM v_edit_node n
     JOIN inp_inlet USING (node_id)
     JOIN v_sector_node s ON s.node_id::text = n.node_id::text
  WHERE n.is_operative IS TRUE;

/*
vi_parent_arc
v_edit_inp_virtualpump
v_ui_arc_x_node
v_edit_inp_dscenario_pipe
v_edit_inp_pipe
v_edit_inp_dscenario_virtualvalve
v_edit_inp_virtualvalve
*/

CREATE OR REPLACE VIEW vi_parent_arc
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.code,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.elevation1,
    v_edit_arc.depth1,
    v_edit_arc.elevation2,
    v_edit_arc.depth2,
    v_edit_arc.arccat_id,
    v_edit_arc.arc_type,
    v_edit_arc.sys_type,
    v_edit_arc.cat_matcat_id,
    v_edit_arc.cat_pnom,
    v_edit_arc.cat_dnom,
    v_edit_arc.epa_type,
    v_edit_arc.expl_id,
    v_edit_arc.macroexpl_id,
    v_edit_arc.sector_id,
    v_edit_arc.sector_name,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.annotation,
    v_edit_arc.observ,
    v_edit_arc.comment,
    v_edit_arc.gis_length,
    v_edit_arc.custom_length,
    v_edit_arc.minsector_id,
    v_edit_arc.dma_id,
    v_edit_arc.dma_name,
    v_edit_arc.macrodma_id,
    v_edit_arc.presszone_id,
    v_edit_arc.presszone_name,
    v_edit_arc.dqa_id,
    v_edit_arc.dqa_name,
    v_edit_arc.macrodqa_id,
    v_edit_arc.soilcat_id,
    v_edit_arc.function_type,
    v_edit_arc.category_type,
    v_edit_arc.fluid_type,
    v_edit_arc.location_type,
    v_edit_arc.workcat_id,
    v_edit_arc.workcat_id_end,
    v_edit_arc.buildercat_id,
    v_edit_arc.builtdate,
    v_edit_arc.enddate,
    v_edit_arc.ownercat_id,
    v_edit_arc.muni_id,
    v_edit_arc.postcode,
    v_edit_arc.district_id,
    v_edit_arc.streetname,
    v_edit_arc.postnumber,
    v_edit_arc.postcomplement,
    v_edit_arc.streetname2,
    v_edit_arc.postnumber2,
    v_edit_arc.postcomplement2,
    v_edit_arc.descript,
    v_edit_arc.link,
    v_edit_arc.verified,
    v_edit_arc.undelete,
    v_edit_arc.label,
    v_edit_arc.label_x,
    v_edit_arc.label_y,
    v_edit_arc.label_rotation,
    v_edit_arc.publish,
    v_edit_arc.inventory,
    v_edit_arc.num_value,
    v_edit_arc.cat_arctype_id,
    v_edit_arc.nodetype_1,
    v_edit_arc.staticpress1,
    v_edit_arc.nodetype_2,
    v_edit_arc.staticpress2,
    v_edit_arc.tstamp,
    v_edit_arc.insert_user,
    v_edit_arc.lastupdate,
    v_edit_arc.lastupdate_user,
    v_edit_arc.the_geom
   FROM v_edit_arc,
    selector_sector
  WHERE v_edit_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_inp_virtualpump
AS SELECT a.arc_id,
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
    p.energyvalue,
    p.effic_curve_id,
    p.energy_price,
    p.energy_pattern_id,
    p.pump_type,
    a.the_geom
   FROM selector_sector ss,
    v_edit_arc a
     JOIN inp_virtualpump p USING (arc_id)
  WHERE a.sector_id = ss.sector_id AND ss.cur_user = "current_user"()::text AND a.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_ui_arc_x_node
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    st_x(a.the_geom) AS x1,
    st_y(a.the_geom) AS y1,
    v_edit_arc.node_2,
    st_x(b.the_geom) AS x2,
    st_y(b.the_geom) AS y2
   FROM v_edit_arc
     LEFT JOIN node a ON a.node_id::text = v_edit_arc.node_1::text
     LEFT JOIN node b ON b.node_id::text = v_edit_arc.node_2::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_pipe
AS SELECT d.dscenario_id,
    p.arc_id,
    p.minorloss,
    p.status,
    p.roughness,
    p.dint,
    p.bulk_coeff,
    p.wall_coeff,
    a.the_geom
   FROM selector_sector,
    selector_inp_dscenario,
    v_edit_arc a
     JOIN inp_dscenario_pipe p USING (arc_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE a.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND a.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_pipe
AS SELECT arc.arc_id,
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
    inp_pipe.minorloss,
    inp_pipe.status,
    inp_pipe.custom_roughness,
    inp_pipe.custom_dint,
    inp_pipe.bulk_coeff,
    inp_pipe.wall_coeff,
    arc.the_geom
   FROM selector_sector,
    v_edit_arc arc
     JOIN inp_pipe USING (arc_id)
  WHERE arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND arc.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_virtualvalve
AS SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    (v_edit_arc.elevation1 + v_edit_arc.elevation2) / 2::numeric AS elevation,
    (v_edit_arc.depth1 + v_edit_arc.depth2) / 2::numeric AS depth,
    v_edit_arc.arccat_id,
    v_edit_arc.expl_id,
    v_edit_arc.sector_id,
    v_edit_arc.dma_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.custom_length,
    v_edit_arc.annotation,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.pressure,
    inp_virtualvalve.flow,
    inp_virtualvalve.coef_loss,
    inp_virtualvalve.curve_id,
    inp_virtualvalve.minorloss,
    inp_virtualvalve.status,
    inp_virtualvalve.init_quality,
    v_edit_arc.the_geom
   FROM selector_sector,
    v_edit_arc
     JOIN inp_virtualvalve USING (arc_id)
  WHERE v_edit_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND v_edit_arc.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_virtualvalve
AS SELECT d.dscenario_id,
    p.arc_id,
    p.valv_type,
    p.pressure,
    p.diameter,
    p.flow,
    p.coef_loss,
    p.curve_id,
    p.minorloss,
    p.status,
    p.init_quality,
    a.the_geom
   FROM selector_sector,
    selector_inp_dscenario,
    v_edit_arc a
     JOIN inp_dscenario_virtualvalve p USING (arc_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE a.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text AND a.is_operative IS TRUE;

/*
v_rtc_period_hydrometer
ve_pol_fountain
v_edit_inp_connec
v_ui_arc_x_relations
*/

CREATE OR REPLACE VIEW v_rtc_period_hydrometer
AS SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    NULL::character varying(16) AS pjoint_id,
    temp_arc.node_1,
    temp_arc.node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_arc ON v_edit_connec.arc_id::text = temp_arc.arc_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND c.dma_id::integer = v_edit_connec.dma_id
  WHERE ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_node ON concat('VN', v_edit_connec.pjoint_id) = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE v_edit_connec.pjoint_type::text = 'VNODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    temp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_node ON v_edit_connec.pjoint_id::text = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE v_edit_connec.pjoint_type::text = 'NODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text));

CREATE OR REPLACE VIEW ve_pol_fountain
AS SELECT polygon.pol_id,
    polygon.feature_id AS connec_id,
    polygon.the_geom
    FROM polygon
    WHERE polygon.sys_type::text = 'FOUNTAIN'::text;

CREATE OR REPLACE VIEW v_edit_inp_connec
AS SELECT v_edit_connec.connec_id,
    v_edit_connec.elevation,
    v_edit_connec.depth,
    v_edit_connec.connecat_id,
    v_edit_connec.arc_id,
    v_edit_connec.expl_id,
    v_edit_connec.sector_id,
    v_edit_connec.dma_id,
    v_edit_connec.state,
    v_edit_connec.state_type,
    v_edit_connec.pjoint_type,
    v_edit_connec.pjoint_id,
    v_edit_connec.annotation,
    inp_connec.demand,
    inp_connec.pattern_id,
    inp_connec.peak_factor,
    inp_connec.status,
    inp_connec.minorloss,
    inp_connec.custom_roughness,
    inp_connec.custom_length,
    inp_connec.custom_dint,
    inp_connec.emitter_coeff,
    inp_connec.init_quality,
    inp_connec.source_type,
    inp_connec.source_quality,
    inp_connec.source_pattern_id,
    v_edit_connec.the_geom
   FROM selector_sector,
    v_edit_connec
     JOIN inp_connec USING (connec_id)
  WHERE v_edit_connec.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND v_edit_connec.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_ui_arc_x_relations
AS WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM node n
             JOIN link l ON n.node_id::text = l.exit_id::text
          WHERE l.state = 1
        )
 SELECT row_number() OVER () + 1000000 AS rid,
    v_edit_connec.arc_id,
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.connecat_id AS catalog,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code AS feature_code,
    v_edit_connec.sys_type,
    a.state AS arc_state,
    v_edit_connec.state AS feature_state,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM v_edit_connec
     JOIN link l ON v_edit_connec.connec_id::text = l.feature_id::text
     JOIN arc a ON a.arc_id::text = v_edit_connec.arc_id::text
  WHERE v_edit_connec.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (c.connec_id) row_number() OVER () + 2000000 AS rid,
    a.arc_id,
    c.connec_type AS featurecat_id,
    c.connecat_id AS catalog,
    c.connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    a.state AS arc_state,
    c.state AS feature_state,
    st_x(c.the_geom) AS x,
    st_y(c.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1::text = n.node_id::text
     JOIN v_edit_connec c ON c.connec_id::text = n.feature_id::text;

CREATE OR REPLACE VIEW vi_parent_hydrometer
AS SELECT v_rtc_hydrometer_x_connec.hydrometer_id,
    v_rtc_hydrometer_x_connec.hydrometer_customer_code,
    v_rtc_hydrometer_x_connec.connec_id,
    v_rtc_hydrometer_x_connec.connec_customer_code,
    v_rtc_hydrometer_x_connec.state,
    v_rtc_hydrometer_x_connec.muni_name,
    v_rtc_hydrometer_x_connec.expl_id,
    v_rtc_hydrometer_x_connec.expl_name,
    v_rtc_hydrometer_x_connec.plot_code,
    v_rtc_hydrometer_x_connec.priority_id,
    v_rtc_hydrometer_x_connec.catalog_id,
    v_rtc_hydrometer_x_connec.category_id,
    v_rtc_hydrometer_x_connec.hydro_number,
    v_rtc_hydrometer_x_connec.hydro_man_date,
    v_rtc_hydrometer_x_connec.crm_number,
    v_rtc_hydrometer_x_connec.customer_name,
    v_rtc_hydrometer_x_connec.address1,
    v_rtc_hydrometer_x_connec.address2,
    v_rtc_hydrometer_x_connec.address3,
    v_rtc_hydrometer_x_connec.address2_1,
    v_rtc_hydrometer_x_connec.address2_2,
    v_rtc_hydrometer_x_connec.address2_3,
    v_rtc_hydrometer_x_connec.m3_volume,
    v_rtc_hydrometer_x_connec.start_date,
    v_rtc_hydrometer_x_connec.end_date,
    v_rtc_hydrometer_x_connec.update_date,
    v_rtc_hydrometer_x_connec.hydrometer_link
   FROM v_rtc_hydrometer_x_connec
     JOIN v_edit_connec USING (connec_id);

CREATE OR REPLACE VIEW vi_parent_connec
AS SELECT v_edit_connec.connec_id,
    v_edit_connec.code,
    v_edit_connec.elevation,
    v_edit_connec.depth,
    v_edit_connec.connec_type,
    v_edit_connec.sys_type,
    v_edit_connec.connecat_id,
    v_edit_connec.expl_id,
    v_edit_connec.macroexpl_id,
    v_edit_connec.sector_id,
    v_edit_connec.sector_name,
    v_edit_connec.macrosector_id,
    v_edit_connec.customer_code,
    v_edit_connec.cat_matcat_id,
    v_edit_connec.cat_pnom,
    v_edit_connec.cat_dnom,
    v_edit_connec.connec_length,
    v_edit_connec.state,
    v_edit_connec.state_type,
    v_edit_connec.n_hydrometer,
    v_edit_connec.arc_id,
    v_edit_connec.annotation,
    v_edit_connec.observ,
    v_edit_connec.comment,
    v_edit_connec.minsector_id,
    v_edit_connec.dma_id,
    v_edit_connec.dma_name,
    v_edit_connec.macrodma_id,
    v_edit_connec.presszone_id,
    v_edit_connec.presszone_name,
    v_edit_connec.staticpressure,
    v_edit_connec.dqa_id,
    v_edit_connec.dqa_name,
    v_edit_connec.macrodqa_id,
    v_edit_connec.soilcat_id,
    v_edit_connec.function_type,
    v_edit_connec.category_type,
    v_edit_connec.fluid_type,
    v_edit_connec.location_type,
    v_edit_connec.workcat_id,
    v_edit_connec.workcat_id_end,
    v_edit_connec.buildercat_id,
    v_edit_connec.builtdate,
    v_edit_connec.enddate,
    v_edit_connec.ownercat_id,
    v_edit_connec.muni_id,
    v_edit_connec.postcode,
    v_edit_connec.district_id,
    v_edit_connec.streetname,
    v_edit_connec.postnumber,
    v_edit_connec.postcomplement,
    v_edit_connec.streetname2,
    v_edit_connec.postnumber2,
    v_edit_connec.postcomplement2,
    v_edit_connec.descript,
    v_edit_connec.svg,
    v_edit_connec.rotation,
    v_edit_connec.link,
    v_edit_connec.verified,
    v_edit_connec.undelete,
    v_edit_connec.label,
    v_edit_connec.label_x,
    v_edit_connec.label_y,
    v_edit_connec.label_rotation,
    v_edit_connec.publish,
    v_edit_connec.inventory,
    v_edit_connec.num_value,
    v_edit_connec.connectype_id,
    v_edit_connec.pjoint_id,
    v_edit_connec.pjoint_type,
    v_edit_connec.tstamp,
    v_edit_connec.insert_user,
    v_edit_connec.lastupdate,
    v_edit_connec.lastupdate_user,
    v_edit_connec.the_geom
   FROM v_edit_connec,
    selector_sector
  WHERE v_edit_connec.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;



-- v_plan / v_edit



CREATE OR REPLACE VIEW v_plan_node
AS SELECT a.node_id,
    a.nodecat_id,
    a.node_type,
    a.top_elev,
    a.elev,
    a.epa_type,
    a.state,
    a.sector_id,
    a.expl_id,
    a.annotation,
    a.cost_unit,
    a.descript,
    a.cost,
    a.measurement,
    a.budget,
    a.the_geom
   FROM ( SELECT v_edit_node.node_id,
            v_edit_node.nodecat_id,
            v_edit_node.sys_type AS node_type,
            v_edit_node.elevation AS top_elev,
            v_edit_node.elevation - v_edit_node.depth AS elev,
            v_edit_node.epa_type,
            v_edit_node.state,
            v_edit_node.sector_id,
            v_edit_node.expl_id,
            v_edit_node.annotation,
            v_price_x_catnode.cost_unit,
            v_price_compost.descript,
            v_price_compost.price AS cost,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'PUMP'::text THEN
                        CASE
                            WHEN man_pump.pump_number IS NOT NULL THEN man_pump.pump_number
                            ELSE 1
                        END
                        ELSE 1
                    END::numeric
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'TANK'::text THEN man_tank.vmax
                        ELSE NULL::numeric
                    END
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN v_edit_node.depth = 0::numeric THEN v_price_x_catnode.estimated_depth
                        WHEN v_edit_node.depth IS NULL THEN v_price_x_catnode.estimated_depth
                        ELSE v_edit_node.depth
                    END
                    ELSE NULL::numeric
                END::numeric(12,2) AS measurement,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'PUMP'::text THEN
                        CASE
                            WHEN man_pump.pump_number IS NOT NULL THEN man_pump.pump_number
                            ELSE 1
                        END
                        ELSE 1
                    END::numeric * v_price_x_catnode.cost
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN v_edit_node.sys_type::text = 'TANK'::text THEN man_tank.vmax
                        ELSE NULL::numeric
                    END * v_price_x_catnode.cost
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN v_edit_node.depth = 0::numeric THEN v_price_x_catnode.estimated_depth
                        WHEN v_edit_node.depth IS NULL THEN v_price_x_catnode.estimated_depth
                        ELSE v_edit_node.depth
                    END * v_price_x_catnode.cost
                    ELSE NULL::numeric
                END::numeric(12,2) AS budget,
            v_edit_node.the_geom
           FROM v_edit_node
             LEFT JOIN v_price_x_catnode ON v_edit_node.nodecat_id::text = v_price_x_catnode.id::text
             LEFT JOIN man_tank ON man_tank.node_id::text = v_edit_node.node_id::text
             LEFT JOIN man_pump ON man_pump.node_id::text = v_edit_node.node_id::text
             LEFT JOIN cat_node ON cat_node.id::text = v_edit_node.nodecat_id::text
             LEFT JOIN v_price_compost ON v_price_compost.id::text = cat_node.cost::text) a;

CREATE OR REPLACE VIEW v_plan_arc
AS SELECT d.arc_id,
    d.node_1,
    d.node_2,
    d.arc_type,
    d.arccat_id,
    d.epa_type,
    d.state,
    d.sector_id,
    d.expl_id,
    d.annotation,
    d.soilcat_id,
    d.y1,
    d.y2,
    d.mean_y,
    d.z1,
    d.z2,
    d.thickness,
    d.width,
    d.b,
    d.bulk,
    d.geom1,
    d.area,
    d.y_param,
    d.total_y,
    d.rec_y,
    d.geom1_ext,
    d.calculed_y,
    d.m3mlexc,
    d.m2mltrenchl,
    d.m2mlbottom,
    d.m2mlpav,
    d.m3mlprotec,
    d.m3mlfill,
    d.m3mlexcess,
    d.m3exc_cost,
    d.m2trenchl_cost,
    d.m2bottom_cost,
    d.m2pav_cost,
    d.m3protec_cost,
    d.m3fill_cost,
    d.m3excess_cost,
    d.cost_unit,
    d.pav_cost,
    d.exc_cost,
    d.trenchl_cost,
    d.base_cost,
    d.protec_cost,
    d.fill_cost,
    d.excess_cost,
    d.arc_cost,
    d.cost,
    d.length,
    d.budget,
    d.other_budget,
    d.total_budget,
    d.the_geom
   FROM ( WITH v_plan_aux_arc_cost AS (
                 WITH v_plan_aux_arc_ml AS (
                         SELECT v_edit_arc.arc_id,
                            v_edit_arc.depth1,
                            v_edit_arc.depth2,
                                CASE
                                    WHEN (v_edit_arc.depth1 * v_edit_arc.depth2) = 0::numeric OR (v_edit_arc.depth1 * v_edit_arc.depth2) IS NULL THEN v_price_x_catarc.estimated_depth
                                    ELSE ((v_edit_arc.depth1 + v_edit_arc.depth2) / 2::numeric)::numeric(12,2)
                                END AS mean_depth,
                            v_edit_arc.arccat_id,
                            COALESCE(v_price_x_catarc.dint / 1000::numeric, 0::numeric)::numeric(12,4) AS dint,
                            COALESCE(v_price_x_catarc.z1, 0::numeric)::numeric(12,2) AS z1,
                            COALESCE(v_price_x_catarc.z2, 0::numeric)::numeric(12,2) AS z2,
                            COALESCE(v_price_x_catarc.area, 0::numeric)::numeric(12,4) AS area,
                            COALESCE(v_price_x_catarc.width, 0::numeric)::numeric(12,2) AS width,
                            COALESCE(v_price_x_catarc.bulk / 1000::numeric, 0::numeric)::numeric(12,4) AS bulk,
                            v_price_x_catarc.cost_unit,
                            COALESCE(v_price_x_catarc.cost, 0::numeric)::numeric(12,2) AS arc_cost,
                            COALESCE(v_price_x_catarc.m2bottom_cost, 0::numeric)::numeric(12,2) AS m2bottom_cost,
                            COALESCE(v_price_x_catarc.m3protec_cost, 0::numeric)::numeric(12,2) AS m3protec_cost,
                            v_price_x_catsoil.id AS soilcat_id,
                            COALESCE(v_price_x_catsoil.y_param, 10::numeric)::numeric(5,2) AS y_param,
                            COALESCE(v_price_x_catsoil.b, 0::numeric)::numeric(5,2) AS b,
                            COALESCE(v_price_x_catsoil.trenchlining, 0::numeric) AS trenchlining,
                            COALESCE(v_price_x_catsoil.m3exc_cost, 0::numeric)::numeric(12,2) AS m3exc_cost,
                            COALESCE(v_price_x_catsoil.m3fill_cost, 0::numeric)::numeric(12,2) AS m3fill_cost,
                            COALESCE(v_price_x_catsoil.m3excess_cost, 0::numeric)::numeric(12,2) AS m3excess_cost,
                            COALESCE(v_price_x_catsoil.m2trenchl_cost, 0::numeric)::numeric(12,2) AS m2trenchl_cost,
                            COALESCE(v_plan_aux_arc_pavement.thickness, 0::numeric)::numeric(12,2) AS thickness,
                            COALESCE(v_plan_aux_arc_pavement.m2pav_cost, 0::numeric) AS m2pav_cost,
                            v_edit_arc.state,
                            v_edit_arc.expl_id,
                            v_edit_arc.the_geom
                           FROM v_edit_arc
                             LEFT JOIN v_price_x_catarc ON v_edit_arc.arccat_id::text = v_price_x_catarc.id::text
                             LEFT JOIN v_price_x_catsoil ON v_edit_arc.soilcat_id::text = v_price_x_catsoil.id::text
                             LEFT JOIN v_plan_aux_arc_pavement ON v_plan_aux_arc_pavement.arc_id::text = v_edit_arc.arc_id::text
                          WHERE v_plan_aux_arc_pavement.arc_id IS NOT NULL
                        )
                 SELECT v_plan_aux_arc_ml.arc_id,
                    v_plan_aux_arc_ml.depth1,
                    v_plan_aux_arc_ml.depth2,
                    v_plan_aux_arc_ml.mean_depth,
                    v_plan_aux_arc_ml.arccat_id,
                    v_plan_aux_arc_ml.dint,
                    v_plan_aux_arc_ml.z1,
                    v_plan_aux_arc_ml.z2,
                    v_plan_aux_arc_ml.area,
                    v_plan_aux_arc_ml.width,
                    v_plan_aux_arc_ml.bulk,
                    v_plan_aux_arc_ml.cost_unit,
                    v_plan_aux_arc_ml.arc_cost,
                    v_plan_aux_arc_ml.m2bottom_cost,
                    v_plan_aux_arc_ml.m3protec_cost,
                    v_plan_aux_arc_ml.soilcat_id,
                    v_plan_aux_arc_ml.y_param,
                    v_plan_aux_arc_ml.b,
                    v_plan_aux_arc_ml.trenchlining,
                    v_plan_aux_arc_ml.m3exc_cost,
                    v_plan_aux_arc_ml.m3fill_cost,
                    v_plan_aux_arc_ml.m3excess_cost,
                    v_plan_aux_arc_ml.m2trenchl_cost,
                    v_plan_aux_arc_ml.thickness,
                    v_plan_aux_arc_ml.m2pav_cost,
                    v_plan_aux_arc_ml.state,
                    v_plan_aux_arc_ml.expl_id,
                    (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric)::numeric(12,3) AS m2mlpavement,
                    (2::numeric * v_plan_aux_arc_ml.b + v_plan_aux_arc_ml.width)::numeric(12,3) AS m2mlbase,
                    (v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness)::numeric(12,3) AS calculed_depth,
                    (v_plan_aux_arc_ml.trenchlining * 2::numeric * (v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness))::numeric(12,3) AS m2mltrenchl,
                    ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric)::numeric(12,3) AS m3mlexc,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric) - v_plan_aux_arc_ml.area)::numeric(12,3) AS m3mlprotec,
                    ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric - (v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlfill,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlexcess,
                    v_plan_aux_arc_ml.the_geom
                   FROM v_plan_aux_arc_ml
                  WHERE v_plan_aux_arc_ml.arc_id IS NOT NULL
                )
         SELECT v_plan_aux_arc_cost.arc_id,
            arc.node_1,
            arc.node_2,
            v_plan_aux_arc_cost.arccat_id AS arc_type,
            v_plan_aux_arc_cost.arccat_id,
            arc.epa_type,
            v_plan_aux_arc_cost.state,
            arc.sector_id,
            v_plan_aux_arc_cost.expl_id,
            arc.annotation,
            v_plan_aux_arc_cost.soilcat_id,
            v_plan_aux_arc_cost.depth1 AS y1,
            v_plan_aux_arc_cost.depth2 AS y2,
            v_plan_aux_arc_cost.mean_depth AS mean_y,
            v_plan_aux_arc_cost.z1,
            v_plan_aux_arc_cost.z2,
            v_plan_aux_arc_cost.thickness,
            v_plan_aux_arc_cost.width,
            v_plan_aux_arc_cost.b,
            v_plan_aux_arc_cost.bulk,
            v_plan_aux_arc_cost.dint AS geom1,
            v_plan_aux_arc_cost.area,
            v_plan_aux_arc_cost.y_param,
            (v_plan_aux_arc_cost.calculed_depth + v_plan_aux_arc_cost.thickness)::numeric(12,2) AS total_y,
            (v_plan_aux_arc_cost.calculed_depth - 2::numeric * v_plan_aux_arc_cost.bulk - v_plan_aux_arc_cost.z1 - v_plan_aux_arc_cost.z2 - v_plan_aux_arc_cost.dint)::numeric(12,2) AS rec_y,
            (v_plan_aux_arc_cost.dint + 2::numeric * v_plan_aux_arc_cost.bulk)::numeric(12,2) AS geom1_ext,
            v_plan_aux_arc_cost.calculed_depth AS calculed_y,
            v_plan_aux_arc_cost.m3mlexc,
            v_plan_aux_arc_cost.m2mltrenchl,
            v_plan_aux_arc_cost.m2mlbase AS m2mlbottom,
            v_plan_aux_arc_cost.m2mlpavement AS m2mlpav,
            v_plan_aux_arc_cost.m3mlprotec,
            v_plan_aux_arc_cost.m3mlfill,
            v_plan_aux_arc_cost.m3mlexcess,
            v_plan_aux_arc_cost.m3exc_cost,
            v_plan_aux_arc_cost.m2trenchl_cost,
            v_plan_aux_arc_cost.m2bottom_cost,
            v_plan_aux_arc_cost.m2pav_cost::numeric(12,2) AS m2pav_cost,
            v_plan_aux_arc_cost.m3protec_cost,
            v_plan_aux_arc_cost.m3fill_cost,
            v_plan_aux_arc_cost.m3excess_cost,
            v_plan_aux_arc_cost.cost_unit,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost
                END::numeric(12,3) AS pav_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost
                END::numeric(12,3) AS exc_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost
                END::numeric(12,3) AS trenchl_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost
                END::numeric(12,3) AS base_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost
                END::numeric(12,3) AS protec_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost
                END::numeric(12,3) AS fill_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
                    ELSE v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost
                END::numeric(12,3) AS excess_cost,
            v_plan_aux_arc_cost.arc_cost::numeric(12,3) AS arc_cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
                    ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost
                END::numeric(12,2) AS cost,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::double precision
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)
                END::numeric(12,2) AS length,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2)
                END::numeric(14,2) AS budget,
            v_plan_aux_arc_connec.connec_total_cost AS other_budget,
                CASE
                    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost +
                    CASE
                        WHEN v_plan_aux_arc_connec.connec_total_cost IS NULL THEN 0::numeric
                        ELSE v_plan_aux_arc_connec.connec_total_cost
                    END
                    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2) +
                    CASE
                        WHEN v_plan_aux_arc_connec.connec_total_cost IS NULL THEN 0::numeric
                        ELSE v_plan_aux_arc_connec.connec_total_cost
                    END
                END::numeric(14,2) AS total_budget,
            v_plan_aux_arc_cost.the_geom
           FROM v_plan_aux_arc_cost
             JOIN arc ON arc.arc_id::text = v_plan_aux_arc_cost.arc_id::text
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (p.price * count(*)::numeric)::numeric(12,2) AS connec_total_cost
                   FROM v_edit_connec c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  WHERE c.arc_id IS NOT NULL
                  GROUP BY c.arc_id, p.price) v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id::text = v_plan_aux_arc_cost.arc_id::text) d
  WHERE d.arc_id IS NOT NULL;





CREATE OR REPLACE VIEW v_ui_plan_arc_cost
AS WITH p AS (
         SELECT v_plan_arc.arc_id,
            v_plan_arc.node_1,
            v_plan_arc.node_2,
            v_plan_arc.arc_type,
            v_plan_arc.arccat_id,
            v_plan_arc.epa_type,
            v_plan_arc.state,
            v_plan_arc.sector_id,
            v_plan_arc.expl_id,
            v_plan_arc.annotation,
            v_plan_arc.soilcat_id,
            v_plan_arc.y1,
            v_plan_arc.y2,
            v_plan_arc.mean_y,
            v_plan_arc.z1,
            v_plan_arc.z2,
            v_plan_arc.thickness,
            v_plan_arc.width,
            v_plan_arc.b,
            v_plan_arc.bulk,
            v_plan_arc.geom1,
            v_plan_arc.area,
            v_plan_arc.y_param,
            v_plan_arc.total_y,
            v_plan_arc.rec_y,
            v_plan_arc.geom1_ext,
            v_plan_arc.calculed_y,
            v_plan_arc.m3mlexc,
            v_plan_arc.m2mltrenchl,
            v_plan_arc.m2mlbottom,
            v_plan_arc.m2mlpav,
            v_plan_arc.m3mlprotec,
            v_plan_arc.m3mlfill,
            v_plan_arc.m3mlexcess,
            v_plan_arc.m3exc_cost,
            v_plan_arc.m2trenchl_cost,
            v_plan_arc.m2bottom_cost,
            v_plan_arc.m2pav_cost,
            v_plan_arc.m3protec_cost,
            v_plan_arc.m3fill_cost,
            v_plan_arc.m3excess_cost,
            v_plan_arc.cost_unit,
            v_plan_arc.pav_cost,
            v_plan_arc.exc_cost,
            v_plan_arc.trenchl_cost,
            v_plan_arc.base_cost,
            v_plan_arc.protec_cost,
            v_plan_arc.fill_cost,
            v_plan_arc.excess_cost,
            v_plan_arc.arc_cost,
            v_plan_arc.cost,
            v_plan_arc.length,
            v_plan_arc.budget,
            v_plan_arc.other_budget,
            v_plan_arc.total_budget,
            v_plan_arc.the_geom,
            a.id,
            a.arctype_id,
            a.matcat_id,
            a.pnom,
            a.dnom,
            a.dint,
            a.dext,
            a.descript,
            a.link,
            a.brand_id,
            a.model_id,
            a.svg,
            a.z1,
            a.z2,
            a.width,
            a.area,
            a.estimated_depth,
            a.bulk,
            a.cost_unit,
            a.cost,
            a.m2bottom_cost,
            a.m3protec_cost,
            a.active,
            a.label,
            a.shape,
            a.acoeff,
            a.connect_cost,
            s.id,
            s.descript,
            s.link,
            s.y_param,
            s.b,
            s.trenchlining,
            s.m3exc_cost,
            s.m3fill_cost,
            s.m3excess_cost,
            s.m2trenchl_cost,
            s.active,
            a.cost AS cat_cost,
            a.m2bottom_cost AS cat_m2bottom_cost,
            a.connect_cost AS cat_connect_cost,
            a.m3protec_cost AS cat_m3_protec_cost,
            s.m3exc_cost AS cat_m3exc_cost,
            s.m3fill_cost AS cat_m3fill_cost,
            s.m3excess_cost AS cat_m3excess_cost,
            s.m2trenchl_cost AS cat_m2trenchl_cost
           FROM v_plan_arc
             JOIN cat_arc a ON a.id::text = v_plan_arc.arccat_id::text
             JOIN cat_soil s ON s.id::text = v_plan_arc.soilcat_id::text
        )
 SELECT p.arc_id,
    1 AS orderby,
    'element'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    2 AS orderby,
    'm2bottom'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mlbottom AS measurement,
    p.m2mlbottom * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m2bottom_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    3 AS orderby,
    'm3protec'::text AS identif,
    p.arccat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlprotec AS measurement,
    p.m3mlprotec * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3_protec_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    4 AS orderby,
    'm3exc'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexc AS measurement,
    p.m3mlexc * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3exc_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    5 AS orderby,
    'm3fill'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlfill AS measurement,
    p.m3mlfill * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3fill_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    6 AS orderby,
    'm3excess'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m3mlexcess AS measurement,
    p.m3mlexcess * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m3excess_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    7 AS orderby,
    'm2trenchl'::text AS identif,
    p.soilcat_id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    p.m2mltrenchl AS measurement,
    p.m2mltrenchl * v_price_compost.price AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_price_compost ON p.cat_m2trenchl_cost::text = v_price_compost.id::text
UNION
 SELECT p.arc_id,
    8 AS orderby,
    'pavement'::text AS identif,
        CASE
            WHEN a.price_id IS NULL THEN 'Various pavements'::character varying
            ELSE a.pavcat_id
        END AS catalog_id,
        CASE
            WHEN a.price_id IS NULL THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS price_id,
    'm2'::character varying AS unit,
        CASE
            WHEN a.price_id IS NULL THEN 'Various prices'::character varying
            ELSE a.pavcat_id
        END AS descript,
    a.m2pav_cost AS cost,
    1 AS measurement,
    a.m2pav_cost AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_plan_aux_arc_pavement a ON a.arc_id::text = p.arc_id::text
     JOIN cat_pavement c ON a.pavcat_id::text = c.id::text
     LEFT JOIN v_price_compost r ON a.price_id::text = c.m2_cost::text
UNION
 SELECT p.arc_id,
    9 AS orderby,
    'connec'::text AS identif,
    'Various connecs'::character varying AS catalog_id,
    'VARIOUS'::character varying AS price_id,
    'PP'::character varying AS unit,
    'Proportional cost of connec connections (pjoint cost)'::character varying AS descript,
    min(v.price) AS cost,
    count(v_edit_connec.connec_id) AS measurement,
    (min(v.price) * count(v_edit_connec.connec_id)::numeric / COALESCE(min(p.length), 1::numeric))::numeric(12,2) AS total_cost,
    min(p.length)::numeric(12,2) AS length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, bulk_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_edit_connec USING (arc_id)
     JOIN v_price_compost v ON p.cat_connect_cost = v.id::text
  GROUP BY p.arc_id
  ORDER BY 1, 2;


CREATE OR REPLACE VIEW vu_node
AS SELECT node.node_id,
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
    mu.province_id,
    CASE
    WHEN node.brand_id IS NULL THEN cat_node.brand_id
    ELSE node.brand_id
    END AS brand_id,
    CASE
        WHEN node.model_id IS NULL THEN cat_node.model_id
        ELSE node.model_id
    END AS model_id,
    node.serial_number
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
     LEFT JOIN value_state_type vst ON vst.id = node.state_type
     LEFT JOIN ext_municipality mu ON node.muni_id = mu.muni_id;

CREATE OR REPLACE VIEW vu_arc
AS SELECT arc.arc_id,
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
    mu.province_id,
    CASE
        WHEN arc.brand_id IS NULL THEN cat_arc.brand_id
        ELSE arc.brand_id
    END AS brand_id,
    CASE
        WHEN arc.model_id IS NULL THEN cat_arc.model_id
        ELSE arc.model_id
    END AS model_id,
    arc.serial_number
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
     LEFT JOIN value_state_type vst ON vst.id = arc.state_type
     LEFT JOIN ext_municipality mu ON arc.muni_id = mu.muni_id;


CREATE OR REPLACE VIEW vu_connec
AS SELECT connec.connec_id,
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
    mu.province_id,
    connec.plot_code,
    CASE
        WHEN connec.brand_id IS NULL THEN cat_connec.brand_id
        ELSE connec.brand_id
    END AS brand_id,
    CASE
        WHEN connec.model_id IS NULL THEN cat_connec.model_id
        ELSE connec.model_id
    END AS model_id,
    connec.serial_number
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
     LEFT JOIN value_state_type vst ON vst.id = connec.state_type
     LEFT JOIN ext_municipality mu ON connec.muni_id = mu.muni_id;


CREATE OR REPLACE VIEW v_edit_arc
AS SELECT a.arc_id,
    a.code,
    a.node_1,
    a.node_2,
    a.elevation1,
    a.depth1,
    a.elevation2,
    a.depth2,
    a.arccat_id,
    a.arc_type,
    a.sys_type,
    a.cat_matcat_id,
    a.cat_pnom,
    a.cat_dnom,
    a.epa_type,
    a.expl_id,
    a.macroexpl_id,
    a.sector_id,
    a.sector_name,
    a.macrosector_id,
    a.state,
    a.state_type,
    a.annotation,
    a.observ,
    a.comment,
    a.gis_length,
    a.custom_length,
    a.minsector_id,
    a.dma_id,
    a.dma_name,
    a.macrodma_id,
    a.presszone_id,
    a.presszone_name,
    a.dqa_id,
    a.dqa_name,
    a.macrodqa_id,
    a.soilcat_id,
    a.function_type,
    a.category_type,
    a.fluid_type,
    a.location_type,
    a.workcat_id,
    a.workcat_id_end,
    a.buildercat_id,
    a.builtdate,
    a.enddate,
    a.ownercat_id,
    a.muni_id,
    a.postcode,
    a.district_id,
    a.streetname,
    a.postnumber,
    a.postcomplement,
    a.streetname2,
    a.postnumber2,
    a.postcomplement2,
    a.descript,
    a.link,
    a.verified,
    a.undelete,
    a.label,
    a.label_x,
    a.label_y,
    a.label_rotation,
    a.publish,
    a.inventory,
    a.num_value,
    a.cat_arctype_id,
    a.nodetype_1,
    a.staticpress1,
    a.nodetype_2,
    a.staticpress2,
    a.tstamp,
    a.insert_user,
    a.lastupdate,
    a.lastupdate_user,
    a.the_geom,
    a.depth,
    a.adate,
    a.adescript,
    a.dma_style,
    a.presszone_style,
    a.workcat_id_plan,
    a.asset_id,
    a.pavcat_id,
    a.om_state,
    a.conserv_state,
    a.flow_max,
    a.flow_min,
    a.flow_avg,
    a.vel_max,
    a.vel_min,
    a.vel_avg,
    a.parent_id,
    a.expl_id2,
    a.is_operative,
    a.region_id,
    a.province_id,
    a.brand_id,
    a.model_id,
    a.serial_number
   FROM ( SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER) s,
    vu_arc a
     JOIN v_state_arc USING (arc_id)
  WHERE a.expl_id = s.expl_id OR a.expl_id2 = s.expl_id;

CREATE OR REPLACE VIEW v_edit_node
AS SELECT n.node_id,
    n.code,
    n.elevation,
    n.depth,
    n.node_type,
    n.sys_type,
    n.nodecat_id,
    n.cat_matcat_id,
    n.cat_pnom,
    n.cat_dnom,
    n.epa_type,
    n.expl_id,
    n.macroexpl_id,
    n.sector_id,
    n.sector_name,
    n.macrosector_id,
    n.arc_id,
    n.parent_id,
    n.state,
    n.state_type,
    n.annotation,
    n.observ,
    n.comment,
    n.minsector_id,
    n.dma_id,
    n.dma_name,
    n.macrodma_id,
    n.presszone_id,
    n.presszone_name,
    n.staticpressure,
    n.dqa_id,
    n.dqa_name,
    n.macrodqa_id,
    n.soilcat_id,
    n.function_type,
    n.category_type,
    n.fluid_type,
    n.location_type,
    n.workcat_id,
    n.workcat_id_end,
    n.builtdate,
    n.enddate,
    n.buildercat_id,
    n.ownercat_id,
    n.muni_id,
    n.postcode,
    n.district_id,
    n.streetname,
    n.postnumber,
    n.postcomplement,
    n.streetname2,
    n.postnumber2,
    n.postcomplement2,
    n.descript,
    n.svg,
    n.rotation,
    n.link,
    n.verified,
    n.undelete,
    n.label,
    n.label_x,
    n.label_y,
    n.label_rotation,
    n.publish,
    n.inventory,
    n.hemisphere,
    n.num_value,
    n.nodetype_id,
    n.tstamp,
    n.insert_user,
    n.lastupdate,
    n.lastupdate_user,
    n.the_geom,
    n.adate,
    n.adescript,
    n.accessibility,
    n.dma_style,
    n.presszone_style,
    man_valve.closed AS closed_valve,
    man_valve.broken AS broken_valve,
    n.workcat_id_plan,
    n.asset_id,
    n.om_state,
    n.conserv_state,
    n.access_type,
    n.placement_type,
    n.demand_max,
    n.demand_min,
    n.demand_avg,
    n.press_max,
    n.press_min,
    n.press_avg,
    n.head_max,
    n.head_min,
    n.head_avg,
    n.quality_max,
    n.quality_min,
    n.quality_avg,
    n.expl_id2,
    n.is_operative,
    n.region_id,
    n.province_id,
    n.brand_id,
    n.model_id,
    n.serial_number
   FROM ( SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER) s,
    vu_node n
     JOIN v_state_node USING (node_id)
     LEFT JOIN man_valve USING (node_id)
  WHERE n.expl_id = s.expl_id OR n.expl_id2 = s.expl_id;

CREATE OR REPLACE VIEW v_edit_connec
AS WITH s AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT vu_connec.connec_id,
    vu_connec.code,
    vu_connec.elevation,
    vu_connec.depth,
    vu_connec.connec_type,
    vu_connec.sys_type,
    vu_connec.connecat_id,
    vu_connec.expl_id,
    vu_connec.macroexpl_id,
        CASE
            WHEN a.sector_id IS NULL THEN vu_connec.sector_id
            ELSE a.sector_id
        END AS sector_id,
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
        CASE
            WHEN a.minsector_id IS NULL THEN vu_connec.minsector_id
            ELSE a.minsector_id
        END AS minsector_id,
        CASE
            WHEN a.dma_id IS NULL THEN vu_connec.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN a.dma_name IS NULL THEN vu_connec.dma_name
            ELSE a.dma_name
        END AS dma_name,
        CASE
            WHEN a.macrodma_id IS NULL THEN vu_connec.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
        CASE
            WHEN a.presszone_id IS NULL THEN vu_connec.presszone_id
            ELSE a.presszone_id::character varying(30)
        END AS presszone_id,
        CASE
            WHEN a.presszone_name IS NULL THEN vu_connec.presszone_name
            ELSE a.presszone_name
        END AS presszone_name,
        CASE
            WHEN a.presszone_name IS NULL THEN vu_connec.staticpressure
            ELSE a.staticpressure
        END AS staticpressure,
        CASE
            WHEN a.dqa_id IS NULL THEN vu_connec.dqa_id
            ELSE a.dqa_id
        END AS dqa_id,
        CASE
            WHEN a.dqa_name IS NULL THEN vu_connec.dqa_name
            ELSE a.dqa_name
        END AS dqa_name,
        CASE
            WHEN a.macrodqa_id IS NULL THEN vu_connec.macrodqa_id
            ELSE a.macrodqa_id
        END AS macrodqa_id,
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
        CASE
            WHEN a.exit_id IS NULL THEN vu_connec.pjoint_id
            ELSE a.exit_id
        END AS pjoint_id,
        CASE
            WHEN a.exit_type IS NULL THEN vu_connec.pjoint_type
            ELSE a.exit_type
        END AS pjoint_type,
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
    vu_connec.crmzone_id,
    vu_connec.crmzone_name,
    vu_connec.expl_id2,
    vu_connec.quality_max,
    vu_connec.quality_min,
    vu_connec.quality_avg,
    vu_connec.is_operative,
    vu_connec.region_id,
    vu_connec.province_id,
    vu_connec.plot_code,
    vu_connec.brand_id,
    vu_connec.model_id,
    vu_connec.serial_number
   FROM s,
    vu_connec
     JOIN v_state_connec USING (connec_id)
     LEFT JOIN ( SELECT DISTINCT ON (vu_link.feature_id) vu_link.link_id,
            vu_link.feature_type,
            vu_link.feature_id,
            vu_link.exit_type,
            vu_link.exit_id,
            vu_link.state,
            vu_link.expl_id,
            vu_link.sector_id,
            vu_link.dma_id,
            vu_link.presszone_id,
            vu_link.dqa_id,
            vu_link.minsector_id,
            vu_link.exit_topelev,
            vu_link.exit_elev,
            vu_link.fluid_type,
            vu_link.gis_length,
            vu_link.the_geom,
            vu_link.sector_name,
            vu_link.dma_name,
            vu_link.dqa_name,
            vu_link.presszone_name,
            vu_link.macrosector_id,
            vu_link.macrodma_id,
            vu_link.macrodqa_id,
            vu_link.expl_id2,
            vu_link.staticpressure
           FROM vu_link,
            s s_1
          WHERE (vu_link.expl_id = s_1.expl_id OR vu_link.expl_id2 = s_1.expl_id) AND vu_link.state = 2) a ON a.feature_id::text = vu_connec.connec_id::text
  WHERE vu_connec.expl_id = s.expl_id OR vu_connec.expl_id2 = s.expl_id;


CREATE OR REPLACE VIEW vu_link
AS SELECT l.link_id,
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
    l.is_operative,
    l.staticpressure,
    l.connecat_id,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate,
    date_trunc('second'::text, l.lastupdate) AS lastupdate,
    l.lastupdate_user,
    l.uncertain
   FROM link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN presszone p USING (presszone_id)
     LEFT JOIN dma d USING (dma_id)
     LEFT JOIN dqa q USING (dqa_id);

CREATE OR REPLACE VIEW v_link_connec
AS SELECT vu_link.link_id,
    vu_link.feature_type,
    vu_link.feature_id,
    vu_link.exit_type,
    vu_link.exit_id,
    vu_link.state,
    vu_link.expl_id,
    vu_link.sector_id,
    vu_link.dma_id,
    vu_link.presszone_id,
    vu_link.dqa_id,
    vu_link.minsector_id,
    vu_link.exit_topelev,
    vu_link.exit_elev,
    vu_link.fluid_type,
    vu_link.gis_length,
    vu_link.the_geom,
    vu_link.sector_name,
    vu_link.dma_name,
    vu_link.dqa_name,
    vu_link.presszone_name,
    vu_link.macrosector_id,
    vu_link.macrodma_id,
    vu_link.macrodqa_id,
    vu_link.expl_id2,
    vu_link.epa_type,
    vu_link.is_operative,
    vu_link.staticpressure,
    vu_link.connecat_id,
    vu_link.workcat_id,
    vu_link.workcat_id_end,
    vu_link.builtdate,
    vu_link.enddate,
    vu_link.lastupdate,
    vu_link.lastupdate_user,
    vu_link.uncertain
   FROM vu_link
     JOIN v_state_link_connec USING (link_id);

CREATE OR REPLACE VIEW v_edit_link
AS SELECT vu_link.link_id,
    vu_link.feature_type,
    vu_link.feature_id,
    vu_link.exit_type,
    vu_link.exit_id,
    vu_link.state,
    vu_link.expl_id,
    vu_link.sector_id,
    vu_link.dma_id,
    vu_link.presszone_id,
    vu_link.dqa_id,
    vu_link.minsector_id,
    vu_link.exit_topelev,
    vu_link.exit_elev,
    vu_link.fluid_type,
    vu_link.gis_length,
    vu_link.the_geom,
    vu_link.sector_name,
    vu_link.dma_name,
    vu_link.dqa_name,
    vu_link.presszone_name,
    vu_link.macrosector_id,
    vu_link.macrodma_id,
    vu_link.macrodqa_id,
    vu_link.expl_id2,
    vu_link.epa_type,
    vu_link.is_operative,
    vu_link.staticpressure,
    vu_link.connecat_id,
    vu_link.workcat_id,
    vu_link.workcat_id_end,
    vu_link.builtdate,
    vu_link.enddate,
    vu_link.lastupdate,
    vu_link.lastupdate_user,
    vu_link.uncertain
   FROM vu_link
     JOIN v_state_link USING (link_id);


DROP VIEW IF EXISTS ve_connec cascade;
DROP VIEW IF EXISTS ve_arc cascade;
DROP VIEW IF EXISTS ve_node cascade;

DROP VIEW IF EXISTS v_link;
DROP VIEW IF EXISTS v_connec;
DROP VIEW IF EXISTS v_arc;
DROP VIEW IF EXISTS v_node;