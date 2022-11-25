/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/11/14

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
    connec.annotation,
    connec.expl_id,
    connec.pjoint_type,
    connec.pjoint_id,
    inp_connec.demand,
    inp_connec.pattern_id,
    connec.the_geom,
    inp_connec.peak_factor,
    inp_connec.custom_roughness,
    inp_connec.custom_length,
    inp_connec.custom_dint,
    connec.epa_type,
    inp_connec.status,
    inp_connec.minorloss
   FROM selector_sector,
    v_connec connec
     JOIN inp_connec USING (connec_id)
     JOIN value_state_type vs ON vs.id=state_type
  WHERE connec.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_inlet AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.pattern_id,
    n.the_geom,
    inp_inlet.overflow,
    inp_inlet.head
   FROM selector_sector,
    v_node n
     JOIN inp_inlet USING (node_id)
     JOIN value_state_type vs ON vs.id=state_type
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_junction.demand,
    inp_junction.pattern_id,
    n.the_geom,
    inp_junction.peak_factor
   FROM selector_sector,
    v_edit_node n
     JOIN inp_junction USING (node_id)
     JOIN value_state_type vs ON vs.id=state_type
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_pipe AS 
 SELECT arc.arc_id,
    arc.node_1,
    arc.node_2,
    arc.arccat_id,
    arc.sector_id,
    arc.macrosector_id,
    arc.dma_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    arc.expl_id,
    arc.custom_length,
    inp_pipe.minorloss,
    inp_pipe.status,
    inp_pipe.custom_roughness,
    inp_pipe.custom_dint,
    arc.the_geom
   FROM selector_sector,
    v_arc arc
     JOIN inp_pipe USING (arc_id)
     JOIN value_state_type vs ON vs.id=state_type
  WHERE arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_pump AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    n.dma_id,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern,
    inp_pump.to_arc,
    inp_pump.status,
    inp_pump.pump_type,
    n.the_geom
   FROM selector_sector,
    v_node n
     JOIN inp_pump USING (node_id)
     JOIN value_state_type vs ON vs.id=state_type
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_reservoir AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_reservoir.pattern_id,
    inp_reservoir.head,
    n.the_geom
   FROM selector_sector,
    v_node n
     JOIN inp_reservoir USING (node_id)
     JOIN value_state_type vs ON vs.id=state_type
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_shortpipe AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_shortpipe.minorloss,
    inp_shortpipe.to_arc,
    inp_shortpipe.status,
    n.the_geom
   FROM selector_sector,
    v_node n
     JOIN inp_shortpipe USING (node_id)
     JOIN value_state_type vs ON vs.id=state_type
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_tank AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id,
    n.the_geom,
    inp_tank.overflow
   FROM selector_sector,
    v_node n
     JOIN inp_tank USING (node_id)
     JOIN value_state_type vs ON vs.id=state_type
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_valve AS 
 SELECT v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.expl_id,
    inp_valve.valv_type,
    inp_valve.pressure,
    inp_valve.flow,
    inp_valve.coef_loss,
    inp_valve.curve_id,
    inp_valve.minorloss,
    inp_valve.to_arc,
    inp_valve.status,
    v_node.the_geom,
    inp_valve.custom_dint,
    inp_valve.add_settings
   FROM selector_sector,
    v_node
     JOIN inp_valve USING (node_id)
     JOIN value_state_type vs ON vs.id=state_type
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_virtualvalve AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    (v_arc.elevation1 + v_arc.elevation2) / 2::numeric AS elevation,
    (v_arc.depth1 + v_arc.depth2) / 2::numeric AS depth,
    v_arc.arccat_id,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.dma_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.expl_id,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.pressure,
    inp_virtualvalve.flow,
    inp_virtualvalve.coef_loss,
    inp_virtualvalve.curve_id,
    inp_virtualvalve.minorloss,
    inp_virtualvalve.to_arc,
    inp_virtualvalve.status,
    v_arc.the_geom
   FROM selector_sector,
    v_arc
     JOIN inp_virtualvalve USING (arc_id)
     JOIN value_state_type vs ON vs.id=state_type
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


DROP VIEW v_rpt_arc;
CREATE OR REPLACE VIEW v_rpt_arc AS 
 SELECT arc.arc_id,
    selector_rpt_main.result_id,
    arc.arc_type,
    arc.arccat_id,
    max(rpt_arc.flow) AS flow_max,
    min(rpt_arc.flow) AS flow_min,
    avg(rpt_arc.flow) AS flow_avg,
    max(rpt_arc.vel) AS vel_max,
    min(rpt_arc.vel) AS vel_min,
    avg(rpt_arc.vel) AS vel_avg,
    max(rpt_arc.headloss) AS headloss_max,
    min(rpt_arc.headloss) AS headloss_min,
    max(rpt_arc.headloss::double precision / (st_length2d(arc.the_geom) * 10::double precision + 0.1::double precision))::numeric(12,2) AS uheadloss_max,
    min(rpt_arc.headloss::double precision / (st_length2d(arc.the_geom) * 10::double precision + 0.1::double precision))::numeric(12,2) AS uheadloss_min,
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
  GROUP BY arc.arc_id, arc.arc_type, arc.arccat_id, selector_rpt_main.result_id, arc.the_geom
  ORDER BY arc.arc_id;


DROP VIEW v_rpt_node;
CREATE OR REPLACE VIEW v_rpt_node AS 
 SELECT node.node_id,
    selector_rpt_main.result_id,
    node.node_type,
    node.nodecat_id,
    max(rpt_node.elevation) AS elevation,
    max(rpt_node.demand) AS demand_max,
    min(rpt_node.demand) AS demand_min,
    avg(rpt_node.demand) AS demand_avg,
    max(rpt_node.head) AS head_max,
    min(rpt_node.head) AS head_min,
    avg(rpt_node.head) AS head_avg,
    max(rpt_node.press) AS press_max,
    min(rpt_node.press) AS press_min,
    avg(rpt_node.press) AS press_avg,
    max(rpt_node.quality) AS quality_max,
    min(rpt_node.quality) AS quality_min,
    avg(rpt_node.quality) AS quality_avg,
    node.the_geom
   FROM selector_rpt_main,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND node.result_id::text = selector_rpt_main.result_id::text
  GROUP BY node.node_id, node.node_type, node.nodecat_id, selector_rpt_main.result_id, node.the_geom
  ORDER BY node.node_id;


CREATE OR REPLACE VIEW vu_arc AS 
 WITH query_node AS (
         SELECT node.node_id,
            node.elevation,
            node.depth,
            cat_node.nodetype_id,
            node.staticpressure
           FROM node
             JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
        )
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.node_2,
    a.elevation AS elevation1,
    a.depth AS depth1,
    b.elevation AS elevation2,
    b.depth AS depth2,
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
    a.nodetype_id AS nodetype_1,
    a.staticpressure AS staticpress1,
    b.nodetype_id AS nodetype_2,
    b.staticpressure AS staticpress2,
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
    e.flow_max, 
    e.flow_min, 
    e.flow_avg, 
    e.vel_max, 
    e.vel_min, 
    e.vel_avg
   FROM arc
     LEFT JOIN sector ON arc.sector_id = sector.sector_id
     LEFT JOIN exploitation ON arc.expl_id = exploitation.expl_id
     LEFT JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arctype_id::text
     LEFT JOIN dma ON arc.dma_id = dma.dma_id
     LEFT JOIN query_node a ON a.node_id::text = arc.node_1::text
     LEFT JOIN query_node b ON b.node_id::text = arc.node_2::text
     LEFT JOIN dqa ON arc.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id::text = arc.presszone_id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text
     LEFT JOIN arc_add e ON arc.arc_id=e.arc_id;


CREATE OR REPLACE VIEW v_arc AS 
SELECT vu_arc.* FROM vu_arc
JOIN v_state_arc USING (arc_id);

CREATE OR REPLACE VIEW v_edit_arc AS 
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW ve_arc AS 
SELECT * FROM v_arc;



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
    e.quality_avg
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
     LEFT JOIN node_add e ON e.node_id = node.node_id;


CREATE OR REPLACE VIEW v_node AS 
SELECT vu_node.* FROM vu_node
JOIN v_state_node USING (node_id);


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
    v_node.quality_avg
   FROM v_node
     LEFT JOIN man_valve USING (node_id);

CREATE OR REPLACE VIEW ve_node AS 
SELECT * FROM v_node;


CREATE OR REPLACE VIEW vu_connec AS 
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
    e.press_max, 
    e.press_min, 
    e.press_avg
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
     LEFT JOIN v_ext_streetaxis c ON c.id::text = connec.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis b ON b.id::text = connec.streetaxis2_id::text
     LEFT JOIN connec_add e ON e.connec_id = connec.connec_id;


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
    vu_connec.sector_id,
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
    vu_connec.minsector_id,
    vu_connec.dma_id,
    vu_connec.dma_name,
    vu_connec.macrodma_id,
    vu_connec.presszone_id,
    vu_connec.presszone_name,
    vu_connec.staticpressure,
    vu_connec.dqa_id,
    vu_connec.dqa_name,
    vu_connec.macrodqa_id,
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
    vu_connec.pjoint_id,
    vu_connec.pjoint_type,
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
    vu_connec.press_max, 
    vu_connec.press_min, 
    vu_connec.press_avg
   FROM vu_connec
     JOIN v_state_connec USING (connec_id);

CREATE OR REPLACE VIEW v_edit_connec AS 
SELECT * FROM v_connec;

CREATE OR REPLACE VIEW ve_connec AS 
SELECT * FROM v_connec;

DROP VIEW v_edit_review_node;
CREATE OR REPLACE VIEW v_edit_review_node AS 
 SELECT review_node.node_id,
    review_node.elevation,
    review_node.depth,
    review_node.nodecat_id,
    review_node.annotation,
    review_node.observ,
    review_node.review_obs,
    review_node.expl_id,
    review_node.the_geom,
    review_node.field_date,
    review_node.field_checked,
    review_node.is_validated
   FROM review_node,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_node.expl_id = selector_expl.expl_id;

DROP VIEW v_edit_review_connec;
CREATE OR REPLACE VIEW v_edit_review_connec AS 
 SELECT review_connec.connec_id,
    review_connec.connecat_id,
    review_connec.annotation,
    review_connec.observ,
    review_connec.review_obs,
    review_connec.expl_id,
    review_connec.the_geom,
    review_connec.field_date,
    review_connec.field_checked,
    review_connec.is_validated
   FROM review_connec,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_connec.expl_id = selector_expl.expl_id;


DROP VIEW v_edit_review_arc;
CREATE OR REPLACE VIEW v_edit_review_arc AS 
 SELECT review_arc.arc_id,
    review_arc.arccat_id,
    review_arc.annotation,
    review_arc.observ,
    review_arc.review_obs,
    review_arc.expl_id,
    review_arc.the_geom,
    review_arc.field_date,
    review_arc.field_checked,
    review_arc.is_validated
   FROM review_arc,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_arc.expl_id = selector_expl.expl_id;


CREATE OR REPLACE VIEW v_edit_link
AS WITH query_text AS (
         SELECT a_1.link_id,
            a_1.feature_type,
            a_1.feature_id,
            a_1.macrosector_id,
            a_1.macrodma_id,
            a_1.exit_type,
            a_1.exit_id,
            a_1.vnode_topelev,
            a_1.fluid_type,
            a_1.sector_id,
            a_1.dma_id,
            a_1.expl_id,
            a_1.state,
            a_1.gis_length,
            a_1.userdefined_geom,
            a_1.the_geom,
            a_1.link_class,
            a_1.psector_rowid
           FROM ( SELECT link.link_id,
                    link.feature_type,
                    link.feature_id,
                    sector.macrosector_id,
                    dma.macrodma_id,
                    link.exit_type,
                    link.exit_id,
                    link.vnode_topelev,
                    c.fluid_type,
                    arc.sector_id,
                    arc.dma_id,
                    arc.expl_id,
                    c.state,
                    st_length2d(link.the_geom) AS gis_length,
                    link.userdefined_geom,
                    link.the_geom,
                    1 AS link_class,
                    0 AS psector_rowid
                   FROM selector_state,
                    v_edit_connec c
                     LEFT JOIN link ON link.feature_id::text = c.connec_id::text
                     LEFT JOIN arc USING (arc_id)
                     LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
                     LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
                  WHERE selector_state.cur_user = "current_user"()::text AND selector_state.state_id = c.state
                UNION
                 SELECT l.link_id,
                    l.feature_type,
                    l.feature_id,
                    sector.macrosector_id,
                    dma.macrodma_id,
                    l.exit_type,
                    l.exit_id,
                    l.vnode_topelev,
                    c.fluid_type,
                    a_1_1.sector_id,
                    a_1_1.dma_id,
                    a_1_1.expl_id,
                    p.state,
                        CASE
                            WHEN p.link_geom IS NULL THEN st_length2d(l.the_geom)
                            ELSE st_length2d(p.link_geom)
                        END AS gis_length,
                        CASE
                            WHEN p.userdefined_geom IS NULL THEN l.userdefined_geom
                            ELSE p.userdefined_geom
                        END AS userdefined_geom,
                        CASE
                            WHEN p.link_geom IS NULL THEN l.the_geom
                            ELSE p.link_geom
                        END AS the_geom,
                        CASE
                            WHEN p.link_geom IS NULL THEN 2
                            ELSE 3
                        END AS link_class,
                    p.id AS psector_rowid
                   FROM link l,
                    selector_psector s,
                    selector_expl e,
                    plan_psector_x_connec p
                     JOIN connec c USING (connec_id)
                     LEFT JOIN arc a_1_1 ON a_1_1.arc_id::text = p.arc_id::text
                     LEFT JOIN sector ON sector.sector_id::text = a_1_1.sector_id::text
                     LEFT JOIN dma ON dma.dma_id::text = a_1_1.dma_id::text
                  WHERE l.feature_id::text = p.connec_id::text AND p.state = 1 AND s.psector_id = p.psector_id AND s.cur_user = "current_user"()::text AND e.expl_id = c.expl_id AND e.cur_user = "current_user"()::text) a_1
        )
 SELECT a.link_id,
    a.feature_type,
    a.feature_id,
    a.macrosector_id,
    a.macrodma_id,
    a.exit_type,
    a.exit_id,
    a.sector_id,
    a.dma_id,
    a.expl_id,
    a.state,
    a.gis_length,
    a.userdefined_geom,
    a.the_geom,
    a.link_class,
    a.psector_rowid,
    a.fluid_type,
    a.vnode_topelev
   FROM query_text a
     JOIN ( SELECT query_text.link_id,
            max(query_text.link_class) AS link_class
           FROM query_text
          GROUP BY query_text.link_id) b USING (link_id)
  WHERE a.link_class = b.link_class;



SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_arc"], "fieldName":"flow_max", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_arc"], "fieldName":"flow_min", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_arc"], "fieldName":"flow_avg", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_arc"], "fieldName":"vel_max", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_arc"], "fieldName":"vel_min", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_arc"], "fieldName":"vel_avg", "action":"ADD-FIELD","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_connec"], "fieldName":"press_max", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_connec"], "fieldName":"press_min", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_connec"], "fieldName":"press_avg", "action":"ADD-FIELD","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"demand_max", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"demand_min", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"demand_avg", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"press_max", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"press_min", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"press_avg", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"head_max", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"head_min", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"head_avg", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"quality_max", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"quality_min", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"quality_avg", "action":"ADD-FIELD","hasChilds":"True"}}$$);

