/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/12/22
CREATE OR REPLACE VIEW v_edit_sector AS 
 SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
    sector.grafconfig::text AS grafconfig,
    sector.stylesheet::text AS stylesheet,
    sector.active,
    sector.parent_id,
    sector.pattern_id
   FROM selector_sector,sector
  WHERE sector.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_pattern AS 
 SELECT DISTINCT p.pattern_id,
    p.observ,
    p.tscode,
    p.tsparameters::text AS tsparameters,
    p.sector_id,
    p.log
   FROM selector_sector, inp_pattern p
  WHERE p.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text OR p.sector_id IS NULL
  ORDER BY p.pattern_id;


CREATE OR REPLACE VIEW v_edit_inp_curve AS 
 SELECT DISTINCT c.id,
    c.curve_type,
    c.descript,
    c.sector_id,
    c.log
   FROM selector_sector, inp_curve c
  WHERE c.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text OR c.sector_id IS NULL
  ORDER BY c.id;
  

CREATE OR REPLACE VIEW vi_reservoirs AS 
 SELECT node_id,
    elevation AS head,
    pattern_id,
    concat(';', sector_id, ' ', dma_id, ' ', presszone_id, ' ', dqa_id, ' ', minsector_id, ' ', node_type) as "other"
   FROM temp_node
   WHERE epa_type = 'RESERVOIR'
   ORDER BY node_id;


CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT node_id,
    elevation,
    (addparam::json ->> 'initlevel'::text)::numeric AS initlevel,
    (addparam::json ->> 'minlevel'::text)::numeric AS minlevel,
    (addparam::json ->> 'maxlevel'::text)::numeric AS maxlevel,
    (addparam::json ->> 'diameter'::text)::numeric AS diameter,
    (addparam::json ->> 'minvol'::text)::numeric AS minvol,
    addparam::json ->> 'curve_id'::text AS curve_id,
    addparam::json ->> 'overflow'::text AS overflow,
    concat(';', sector_id, ' ', dma_id, ' ', presszone_id, ' ', dqa_id, ' ', minsector_id, ' ', node_type) as "other"
   FROM temp_node
   WHERE epa_type = 'TANK'
   ORDER BY node_id;

CREATE OR REPLACE VIEW vi_junctions AS 
 SELECT node_id,
    elevation,
    demand,
    pattern_id,
    concat(';', sector_id, ' ', dma_id, ' ', presszone_id, ' ', dqa_id, ' ', minsector_id, ' ', node_type) as "other"
    FROM temp_node
    WHERE epa_type NOT IN ('RESERVOIR', 'TANK')
  ORDER BY node_id;

CREATE OR REPLACE VIEW vi_pipes AS 
 SELECT arc_id,
    node_1,
    node_2,
    length,
    diameter,
    roughness,
    minorloss,
    status::varchar(30),
    concat(';', sector_id, ' ', dma_id, ' ', presszone_id, ' ', dqa_id, ' ', minsector_id, ' ', arccat_id) as "other"
    FROM temp_arc
    WHERE epa_type IN ('PIPE', 'SHORTPIPE', 'NODE2NODE');


CREATE OR REPLACE VIEW vi_valves AS 
 SELECT DISTINCT ON (a.arc_id) a.arc_id,
    a.node_1,
    a.node_2,
    a.diameter,
    a.valv_type,
    a.setting,
    a.minorloss,
    concat(';', sector_id, ' ', dma_id, ' ', presszone_id, ' ', dqa_id, ' ', minsector_id, ' ', arccat_id) as "other"
   FROM ( SELECT arc_id::text AS arc_id,
            node_1,
            node_2,
            diameter,
            ((addparam::json ->> 'valv_type'::text))::character varying(18) AS valv_type,
            addparam::json ->> 'pressure'::text AS setting,
            minorloss, sector_id, dma_id, presszone_id, dqa_id, minsector_id, arccat_id
            FROM temp_arc
            WHERE ((addparam::json ->> 'valv_type'::text) = 'PRV'::text OR (addparam::json ->> 'valv_type'::text) = 'PSV'::text OR (addparam::json ->> 'valv_type'::text) = 'PBV'::text) 
        UNION
         SELECT arc_id,
            node_1,
            node_2,
            diameter,
            addparam::json ->> 'valv_type'::text AS valv_type,
            addparam::json ->> 'flow'::text AS setting,
            minorloss, sector_id, dma_id, presszone_id, dqa_id, minsector_id, arccat_id
            FROM temp_arc
            WHERE (addparam::json ->> 'valv_type'::text) = 'FCV'::text 
        UNION
         SELECT arc_id,
            node_1,
            node_2,
            diameter,
            addparam::json ->> 'valv_type'::text AS valv_type,
            addparam::json ->> 'coef_loss'::text AS setting,
            minorloss, sector_id, dma_id, presszone_id, dqa_id, minsector_id, arccat_id
            FROM temp_arc
            WHERE (addparam::json ->> 'valv_type'::text) = 'TCV'::text
        UNION
         SELECT arc_id,
            node_1,
            node_2,
            diameter,
            addparam::json ->> 'valv_type'::text AS valv_type,
            addparam::json ->> 'curve_id'::text AS setting,
            minorloss, sector_id, dma_id, presszone_id, dqa_id, minsector_id, arccat_id
           FROM temp_arc
          WHERE (addparam::json ->> 'valv_type'::text) = 'GPV'::text
        UNION
         SELECT arc_id,
            node_1,
            node_2,
            diameter,
            'PRV'::character varying(18) AS valv_type,
            addparam::json ->> 'pressure'::text AS setting,
            minorloss, sector_id, dma_id, presszone_id, dqa_id, minsector_id, arccat_id
            FROM temp_arc
            JOIN inp_pump ON arc_id::text = concat(inp_pump.node_id, '_n2a_4')) a;

CREATE OR REPLACE VIEW vi_pumps AS 
 SELECT arc_id,
    node_1,
    node_2,
        CASE
            WHEN (addparam::json ->> 'power'::text) <> ''::text THEN ('POWER'::text || ' '::text) || (addparam::json ->> 'power'::text)
            ELSE NULL::text
        END AS power,
        CASE
            WHEN (addparam::json ->> 'curve_id'::text) <> ''::text THEN ('HEAD'::text || ' '::text) || (addparam::json ->> 'curve_id'::text)
            ELSE NULL::text
        END AS head,
        CASE
            WHEN (addparam::json ->> 'speed'::text) <> ''::text THEN ('SPEED'::text || ' '::text) || (addparam::json ->> 'speed'::text)
            ELSE NULL::text
        END AS speed,
        CASE
            WHEN (addparam::json ->> 'pattern'::text) <> ''::text THEN ('PATTERN'::text || ' '::text) || (addparam::json ->> 'pattern'::text)
            ELSE NULL::text
        END AS pattern,
    concat(';', sector_id, ' ', dma_id, ' ', presszone_id, ' ', dqa_id, ' ', minsector_id, ' ', arccat_id) as "other"
    FROM temp_arc
    WHERE epa_type IN ('PUMP') AND arc_id NOT IN (SELECT arc_id FROM vi_valves)
  ORDER BY arc_id;


DROP VIEW vi_tags;
CREATE OR REPLACE VIEW vi_tags AS 
 SELECT inp_tags.feature_type,
    inp_tags.feature_id,
    inp_tags.tag
   FROM inp_tags
  ORDER BY inp_tags.feature_type;


CREATE OR REPLACE VIEW vi_curves AS 
 SELECT
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value,
    NULL::text AS other
   FROM ( SELECT DISTINCT ON (inp_curve_value.curve_id) ( SELECT min(sub.id) AS min
                   FROM inp_curve_value sub
                  WHERE sub.curve_id::text = inp_curve_value.curve_id::text) AS id,
            inp_curve_value.curve_id,
            concat(';', inp_curve.curve_type, ':', inp_curve.descript) AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM inp_curve
             JOIN inp_curve_value ON inp_curve_value.curve_id::text = inp_curve.id::text
        UNION
         SELECT inp_curve_value.id,
            inp_curve_value.curve_id,
            inp_curve.curve_type,
            inp_curve_value.x_value,
            inp_curve_value.y_value
           FROM inp_curve_value
             JOIN inp_curve ON inp_curve_value.curve_id::text = inp_curve.id::text
  ORDER BY 1, 4 DESC) a
  WHERE (a.curve_id::text IN ( SELECT vi_tanks.curve_id
           FROM vi_tanks)) OR (concat('HEAD ', a.curve_id) IN ( SELECT vi_pumps.head
           FROM vi_pumps)) OR (a.curve_id::text IN ( SELECT vi_valves.setting
           FROM vi_valves)) OR (a.curve_id::text IN ( SELECT vi_energy.energyvalue
           FROM vi_energy
          WHERE vi_energy.idval::text = 'EFFIC'::text)) OR ((( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'inp_options_buildup_mode'::text AND config_param_user.cur_user::name = "current_user"()))::integer) = 1;


drop view vi_demands;
CREATE OR REPLACE VIEW vi_demands AS 
SELECT temp_demand.feature_id,
    temp_demand.demand,
    temp_demand.pattern_id,
    concat(';',dscenario_id,' ',source,' ', demand_type) as other
   FROM temp_demand
   JOIN temp_node ON temp_demand.feature_id::text = temp_node.node_id::text
   ORDER BY 1,4;

     
CREATE OR REPLACE VIEW v_edit_inp_dscenario_demand AS 
 SELECT inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source
   FROM selector_sector,
    selector_inp_dscenario,
    inp_dscenario_demand
     JOIN v_node ON v_node.node_id::text = inp_dscenario_demand.feature_id::text
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
  AND inp_dscenario_demand.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
UNION
 SELECT inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source
   FROM selector_sector,
    selector_inp_dscenario,
    inp_dscenario_demand
     JOIN v_connec ON v_connec.connec_id::text = inp_dscenario_demand.feature_id::text
  WHERE v_connec.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
  AND inp_dscenario_demand.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


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
   FROM selector_sector, v_connec connec
     JOIN inp_connec USING (connec_id)
  WHERE connec.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_tank;
CREATE OR REPLACE VIEW v_edit_inp_tank
AS SELECT n.node_id,
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
    overflow
   FROM selector_sector,
    v_node n
     JOIN inp_tank USING (node_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


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
    inp_inlet.overflow
   FROM selector_sector, v_node n
     JOIN inp_inlet USING (node_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_connec AS 
 SELECT 
    d.dscenario_id,
    connec.connec_id,
    connec.pjoint_type,
    connec.pjoint_id,
    c.demand,
    c.pattern_id,
    c.demand_type,
    c.peak_factor,
	c.status,
	c.minorloss,
    c.custom_roughness,
    c.custom_length,
    c.custom_dint,
    connec.the_geom
   FROM selector_inp_dscenario,
    v_edit_inp_connec connec
     JOIN inp_dscenario_connec c USING (connec_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE c.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_junction AS 
 SELECT 
    d.dscenario_id,
    n.node_id,
    j.demand,
    j.pattern_id,
    j.demand_type,
    j.peak_factor,
    n.the_geom
   FROM selector_inp_dscenario,
    v_edit_inp_junction n
     JOIN inp_dscenario_junction j USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE j.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_inlet AS 
 SELECT
    d.dscenario_id,
    n.node_id,
    i.initlevel,
    i.minlevel,
    i.maxlevel,
    i.diameter,
    i.minvol,
    i.curve_id,
    i.pattern_id,
    i.overflow,
    i.head,
    n.the_geom
   FROM  selector_inp_dscenario, v_edit_inp_inlet n
     JOIN inp_dscenario_inlet i USING (node_id)
      JOIN cat_dscenario d USING (dscenario_id)
  WHERE i.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_pipe AS 
 SELECT d.dscenario_id,
    p.arc_id,
    p.minorloss,
    p.status,
    p.roughness,
    p.dint,
    the_geom
   FROM  selector_inp_dscenario, v_edit_inp_pipe
     JOIN inp_dscenario_pipe p USING (arc_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_dscenario_pump;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump AS 
 SELECT d.dscenario_id,
    p.node_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern,
    p.status,
    the_geom
   FROM selector_inp_dscenario, v_edit_inp_pump
     JOIN inp_dscenario_pump p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump_additional AS 
 SELECT d.dscenario_id,
    p.node_id,
    p.order_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern,
    p.status
   FROM selector_inp_dscenario, v_edit_inp_pump
     JOIN inp_dscenario_pump_additional p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_reservoir AS 
 SELECT 
    d.dscenario_id,
    p.node_id,
    p.pattern_id,
    p.head,
    the_geom
   FROM  selector_inp_dscenario,  v_edit_inp_reservoir
     JOIN inp_dscenario_reservoir p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_dscenario_shortpipe;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_shortpipe AS 
 SELECT 
    d.dscenario_id,
    p.node_id,
    p.minorloss,
    p.status
   FROM selector_inp_dscenario, v_edit_inp_shortpipe v
     JOIN inp_dscenario_shortpipe p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_dscenario_tank AS 
 SELECT 
    d.dscenario_id,
    p.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    the_geom
   FROM  selector_inp_dscenario, v_edit_inp_tank v
     JOIN inp_dscenario_tank p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_dscenario_valve;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_valve AS 
 SELECT 
    d.dscenario_id,
    p.node_id,
    p.valv_type,
    p.pressure,
    p.flow,
    p.coef_loss,
    p.curve_id,
    p.minorloss,
    p.status,
    p.add_settings,
    the_geom
   FROM selector_inp_dscenario, v_edit_inp_valve v
     JOIN inp_dscenario_valve p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;

 

CREATE OR REPLACE VIEW v_edit_inp_dscenario_virtualvalve AS 
 SELECT 
	d.dscenario_id,
	arc_id,
	v.valv_type,
	v.pressure,
	v.diameter,
	v.flow,
	v.coef_loss,
	v.curve_id,
	v.minorloss, 
	v.status,
	the_geom 
   FROM selector_inp_dscenario, v_edit_inp_virtualvalve
     JOIN inp_dscenario_virtualvalve v USING (arc_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE v.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


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
	arc.pavcat_id
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
     LEFT JOIN v_ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text;


CREATE OR REPLACE VIEW v_arc AS 
SELECT * FROM vu_arc
JOIN v_state_arc USING (arc_id);

CREATE OR REPLACE VIEW v_edit_arc AS 
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW ve_arc AS 
SELECT * FROM v_arc;

SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"featureType":"ARC"},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-UPDATE", "newColumn":"pavcat_id" }}$$);


CREATE OR REPLACE VIEW v_plan_aux_arc_pavement AS 
 SELECT a.arc_id,
        CASE 
            WHEN v_price_x_catpavement.thickness IS NULL THEN 0::numeric(12,2)
            ELSE v_price_x_catpavement.thickness::numeric(12,2)
        END AS thickness,
        CASE
            WHEN v_price_x_catpavement.m2pav_cost IS NULL THEN 0::numeric
            ELSE v_price_x_catpavement.m2pav_cost::numeric
        END AS m2pav_cost
   FROM v_edit_arc a
     LEFT JOIN v_price_x_catpavement ON v_price_x_catpavement.pavcat_id::text = a.pavcat_id::text;