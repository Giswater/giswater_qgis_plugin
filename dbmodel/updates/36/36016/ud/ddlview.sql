/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2024/11/11
-- add brand_id, model_id, serial_number
CREATE OR REPLACE VIEW vu_node
AS WITH vu_node AS (
         SELECT node.node_id,
            node.code,
            node.top_elev,
            node.custom_top_elev,
                CASE
                    WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev
                    ELSE node.top_elev
                END AS sys_top_elev,
            node.ymax,
            node.custom_ymax,
                CASE
                    WHEN node.custom_ymax IS NOT NULL THEN node.custom_ymax
                    ELSE node.ymax
                END AS sys_ymax,
            node.elev,
            node.custom_elev,
                CASE
                    WHEN node.elev IS NOT NULL AND node.custom_elev IS NULL THEN node.elev
                    WHEN node.custom_elev IS NOT NULL THEN node.custom_elev
                    ELSE NULL::numeric(12,3)
                END AS sys_elev,
            node.node_type,
            cat_feature.system_id AS sys_type,
            node.nodecat_id,
                CASE
                    WHEN node.matcat_id IS NULL THEN cat_node.matcat_id
                    ELSE node.matcat_id
                END AS matcat_id,
            node.epa_type,
            node.expl_id,
            exploitation.macroexpl_id,
            node.sector_id,
            sector.sector_type,
            sector.macrosector_id,
            node.state,
            node.state_type,
            node.annotation,
            node.observ,
            node.comment,
            node.dma_id,
            dma.macrodma_id,
            dma.dma_type,
            node.soilcat_id,
            node.function_type,
            node.category_type,
            node.fluid_type,
            node.location_type,
            node.workcat_id,
            node.workcat_id_end,
            node.workcat_id_plan,
            node.buildercat_id,
            node.builtdate,
            node.enddate,
            node.ownercat_id,
            node.muni_id,
            node.postcode,
            node.district_id,
            c.descript::character varying(100) AS streetname,
            node.postnumber,
            node.postcomplement,
            d.descript::character varying(100) AS streetname2,
            node.postnumber2,
            node.postcomplement2,
            mu.region_id,
            mu.province_id,
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
            node.label_quadrant,
            node.publish,
            node.inventory,
            node.uncertain,
            node.xyz_date,
            node.unconnected,
            node.num_value,
            node.asset_id,
            node.drainzone_id,
            drainzone.drainzone_type,
            node.parent_id,
            node.arc_id,
            node.expl_id2,
            vst.is_operative,
            node.minsector_id,
            node.macrominsector_id,
            node.adate,
            node.adescript,
            node.placement_type,
            node.access_type,
            date_trunc('second'::text, node.tstamp) AS tstamp,
            node.insert_user,
            date_trunc('second'::text, node.lastupdate) AS lastupdate,
            node.lastupdate_user,
            node.the_geom,
            node.brand_id,
            node.model_id,
            node.serial_number
           FROM node
             LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
             LEFT JOIN cat_feature ON cat_feature.id::text = node.node_type::text
             LEFT JOIN dma ON node.dma_id = dma.dma_id
             LEFT JOIN sector ON node.sector_id = sector.sector_id
             LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
             LEFT JOIN v_ext_streetaxis c ON c.id::text = node.streetaxis_id::text
             LEFT JOIN v_ext_streetaxis d ON d.id::text = node.streetaxis2_id::text
             LEFT JOIN value_state_type vst ON vst.id = node.state_type
             LEFT JOIN ext_municipality mu ON node.muni_id = mu.muni_id
             LEFT JOIN drainzone USING (drainzone_id)
        ), streetaxis AS (
         SELECT v_ext_streetaxis.id,
            v_ext_streetaxis.descript
           FROM v_ext_streetaxis
        )
 SELECT node_id,
    code,
    top_elev,
    custom_top_elev,
    sys_top_elev,
    ymax,
    custom_ymax,
        CASE
            WHEN sys_ymax IS NOT NULL THEN sys_ymax
            ELSE (sys_top_elev - sys_elev)::numeric(12,3)
        END AS sys_ymax,
    elev,
    custom_elev,
        CASE
            WHEN sys_elev IS NOT NULL THEN sys_elev
            ELSE (sys_top_elev - sys_ymax)::numeric(12,3)
        END AS sys_elev,
    node_type,
    sys_type,
    nodecat_id,
    matcat_id,
    epa_type,
    state,
    state_type,
    expl_id,
    macroexpl_id,
    sector_id,
    sector_type,
    macrosector_id,
    drainzone_id,
    drainzone_type,
    annotation,
    observ,
    comment,
    dma_id,
    macrodma_id,
    soilcat_id,
    function_type,
    category_type,
    fluid_type,
    location_type,
    workcat_id,
    workcat_id_end,
    buildercat_id,
    builtdate,
    enddate,
    ownercat_id,
    muni_id,
    postcode,
    district_id,
    streetname,
    postnumber,
    postcomplement,
    streetname2,
    postnumber2,
    postcomplement2,
    region_id,
    province_id,
    descript,
    svg,
    rotation,
    link,
    verified,
    the_geom,
    undelete,
    label,
    label_x,
    label_y,
    label_rotation,
    label_quadrant,
    publish,
    inventory,
    uncertain,
    xyz_date,
    unconnected,
    num_value,
    tstamp,
    insert_user,
    lastupdate,
    lastupdate_user,
    workcat_id_plan,
    asset_id,
    parent_id,
    arc_id,
    expl_id2,
    is_operative,
    minsector_id,
    macrominsector_id,
    adate,
    adescript,
    placement_type,
    access_type,
    brand_id,
    model_id,
    serial_number
   FROM vu_node;

-- add brand_id, model_id, serial_number and select distinct to avoid expl_id2 duplicate rows
CREATE OR REPLACE VIEW v_edit_node
AS SELECT a.node_id,
    a.code,
    a.top_elev,
    a.custom_top_elev,
    a.sys_top_elev,
    a.ymax,
    a.custom_ymax,
    a.sys_ymax,
    a.elev,
    a.custom_elev,
    a.sys_elev,
    a.node_type,
    a.sys_type,
    a.nodecat_id,
    a.matcat_id,
    a.epa_type,
    a.state,
    a.state_type,
    a.expl_id,
    a.macroexpl_id,
    a.sector_id,
    a.sector_type,
    a.macrosector_id,
    a.drainzone_id,
    a.drainzone_type,
    a.annotation,
    a.observ,
    a.comment,
    a.dma_id,
    a.macrodma_id,
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
    a.region_id,
    a.province_id,
    a.descript,
    a.svg,
    a.rotation,
    a.link,
    a.verified,
    a.the_geom,
    a.undelete,
    a.label,
    a.label_x,
    a.label_y,
    a.label_rotation,
    a.label_quadrant,
    a.publish,
    a.inventory,
    a.uncertain,
    a.xyz_date,
    a.unconnected,
    a.num_value,
    a.tstamp,
    a.insert_user,
    a.lastupdate,
    a.lastupdate_user,
    a.workcat_id_plan,
    a.asset_id,
    a.parent_id,
    a.arc_id,
    a.expl_id2,
    a.is_operative,
    a.minsector_id,
    a.macrominsector_id,
    a.adate,
    a.adescript,
    a.placement_type,
    a.access_type,
        CASE
            WHEN s.sector_id > 0 AND a.is_operative = true AND a.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN a.epa_type
            ELSE NULL::character varying(16)
        END AS inp_type,
    a.brand_id,
    a.model_id,
    a.serial_number
   FROM ( SELECT n.node_id,
            n.code,
            n.top_elev,
            n.custom_top_elev,
            n.sys_top_elev,
            n.ymax,
            n.custom_ymax,
            n.sys_ymax,
            n.elev,
            n.custom_elev,
            n.sys_elev,
            n.node_type,
            n.sys_type,
            n.nodecat_id,
            n.matcat_id,
            n.epa_type,
            n.state,
            n.state_type,
            n.expl_id,
            n.macroexpl_id,
            n.sector_id,
            n.sector_type,
            n.macrosector_id,
            n.drainzone_id,
            n.drainzone_type,
            n.annotation,
            n.observ,
            n.comment,
            n.dma_id,
            n.macrodma_id,
            n.soilcat_id,
            n.function_type,
            n.category_type,
            n.fluid_type,
            n.location_type,
            n.workcat_id,
            n.workcat_id_end,
            n.buildercat_id,
            n.builtdate,
            n.enddate,
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
            n.region_id,
            n.province_id,
            n.descript,
            n.svg,
            n.rotation,
            n.link,
            n.verified,
            n.the_geom,
            n.undelete,
            n.label,
            n.label_x,
            n.label_y,
            n.label_rotation,
            n.label_quadrant,
            n.publish,
            n.inventory,
            n.uncertain,
            n.xyz_date,
            n.unconnected,
            n.num_value,
            n.tstamp,
            n.insert_user,
            n.lastupdate,
            n.lastupdate_user,
            n.workcat_id_plan,
            n.asset_id,
            n.parent_id,
            n.arc_id,
            n.expl_id2,
            n.is_operative,
            n.minsector_id,
            n.macrominsector_id,
            n.adate,
            n.adescript,
            n.placement_type,
            n.access_type,
            n.brand_id,
            n.model_id,
            n.serial_number
           FROM ( SELECT selector_expl.expl_id
                   FROM selector_expl
                  WHERE selector_expl.cur_user = CURRENT_USER) s_1,
            vu_node n
             JOIN v_state_node USING (node_id)
          WHERE n.expl_id = s_1.expl_id OR n.expl_id2 = s_1.expl_id) a
     JOIN selector_sector s USING (sector_id)
     LEFT JOIN selector_municipality m USING (muni_id)
  WHERE s.cur_user = CURRENT_USER AND (m.cur_user = CURRENT_USER OR a.muni_id IS NULL);
     

CREATE OR REPLACE VIEW v_edit_inp_dwf
AS SELECT i.dwfscenario_id,
    node_id,
    i.value,
    i.pat1,
    i.pat2,
    i.pat3,
    i.pat4,
    node.the_geom
   FROM config_param_user c,
    inp_dwf i
     JOIN node USING (node_id)
  WHERE c.cur_user::name = CURRENT_USER AND c.parameter::text = 'inp_options_dwfscenario'::text AND c.value::integer = i.dwfscenario_id;
  
 
CREATE OR REPLACE VIEW v_edit_raingage
AS SELECT raingage.rg_id,
    raingage.form_type,
    raingage.intvl,
    raingage.scf,
    raingage.rgage_type,
    raingage.timser_id,
    raingage.fname,
    raingage.sta,
    raingage.units,
    raingage.the_geom,
    raingage.expl_id,
    raingage.muni_id
   FROM selector_expl, raingage
  WHERE raingage.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_subcatchment AS 
 SELECT a.* from (SELECT inp_subcatchment.hydrology_id,
    inp_subcatchment.subc_id,
    inp_subcatchment.outlet_id,
    inp_subcatchment.rg_id,
    inp_subcatchment.area,
    inp_subcatchment.imperv,
    inp_subcatchment.width,
    inp_subcatchment.slope,
    inp_subcatchment.clength,
    inp_subcatchment.snow_id,
    inp_subcatchment.nimp,
    inp_subcatchment.nperv,
    inp_subcatchment.simp,
    inp_subcatchment.sperv,
    inp_subcatchment.zero,
    inp_subcatchment.routeto,
    inp_subcatchment.rted,
    inp_subcatchment.maxrate,
    inp_subcatchment.minrate,
    inp_subcatchment.decay,
    inp_subcatchment.drytime,
    inp_subcatchment.maxinfil,
    inp_subcatchment.suction,
    inp_subcatchment.conduct,
    inp_subcatchment.initdef,
    inp_subcatchment.curveno,
    inp_subcatchment.conduct_2,
    inp_subcatchment.drytime_2,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom,
    inp_subcatchment.descript,
    inp_subcatchment.minelev,
    muni_id
   FROM inp_subcatchment
   LEFT JOIN node ON node_id = outlet_id
   ) a, config_param_user, selector_sector, selector_municipality
   WHERE a.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
   AND ((a.muni_id = selector_municipality.muni_id AND selector_municipality.cur_user = "current_user"()::text) or a.muni_id is null)
   AND a.hydrology_id = config_param_user.value::integer AND config_param_user.cur_user::text = "current_user"()::text
   AND config_param_user.parameter::text = 'inp_options_hydrology_scenario'::text;

-- 20/11/2024
CREATE OR REPLACE VIEW vu_gully
AS WITH streetaxis AS (
         SELECT v_ext_streetaxis.id,
            v_ext_streetaxis.descript
           FROM v_ext_streetaxis
        ), inp_netw_mode AS (
         WITH inp_netw_mode_aux AS (
                 SELECT count(*) AS t
                   FROM config_param_user
                  WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
                )
         SELECT
                CASE
                    WHEN inp_netw_mode_aux.t > 0 THEN ( SELECT config_param_user.value
                       FROM config_param_user
                      WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER)
                    ELSE NULL::text
                END AS value
           FROM inp_netw_mode_aux
        )
 SELECT gully.gully_id,
    gully.code,
    gully.top_elev,
    gully.ymax,
    gully.sandbox,
    gully.matcat_id,
    gully.gully_type,
    cat_feature.system_id AS sys_type,
    gully.gratecat_id,
    cat_grate.matcat_id AS cat_grate_matcat,
    cat_grate.width AS grate_width,
    cat_grate.length AS grate_length,
    gully.units,
    gully.groove,
    gully.groove_height,
    gully.groove_length,
    gully.siphon,
    gully.connec_arccat_id,
    gully.connec_length,
    gully.top_elev - gully.ymax + gully.sandbox AS connec_y1,
    gully.connec_y2,
        CASE
            WHEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric) IS NOT NULL THEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric)::numeric(12,3)
            ELSE gully.connec_depth
        END AS connec_depth,
    gully.arc_id,
    gully.epa_type,
    gully.expl_id,
    exploitation.macroexpl_id,
    gully.sector_id,
    sector.macrosector_id,
    sector.sector_type,
    gully.drainzone_id,
    drainzone.drainzone_type,
    gully.state,
    gully.state_type,
    gully.annotation,
    gully.observ,
    gully.comment,
    gully.dma_id,
    dma.macrodma_id,
    dma.dma_type,
    gully.soilcat_id,
    gully.function_type,
    gully.category_type,
    gully.fluid_type,
    gully.location_type,
    gully.workcat_id,
    gully.workcat_id_end,
    gully.workcat_id_plan,
    gully.buildercat_id,
    gully.builtdate,
    gully.enddate,
    gully.ownercat_id,
    gully.muni_id,
    gully.postcode,
    gully.district_id,
    c.descript::character varying(100) AS streetname,
    gully.postnumber,
    gully.postcomplement,
    d.descript::character varying(100) AS streetname2,
    gully.postnumber2,
    gully.postcomplement2,
    mu.region_id,
    mu.province_id,
    gully.descript,
    cat_grate.svg,
    gully.rotation,
    concat(cat_feature.link_path, gully.link) AS link,
    gully.verified,
    gully.undelete,
    cat_grate.label,
    gully.label_x,
    gully.label_y,
    gully.label_rotation,
    gully.label_quadrant,
    gully.publish,
    gully.inventory,
    gully.uncertain,
    gully.num_value,
    gully.pjoint_id,
    gully.pjoint_type,
    gully.asset_id,
        CASE
            WHEN gully.connec_matcat_id IS NULL THEN cc.matcat_id::text
            ELSE gully.connec_matcat_id
        END AS connec_matcat_id,
    gully.gratecat2_id,
    gully.units_placement,
    gully.expl_id2,
    vst.is_operative,
    gully.minsector_id,
    gully.macrominsector_id,
    gully.adate,
    gully.adescript,
    gully.siphon_type,
    gully.odorflap,
    gully.placement_type,
    gully.access_type,
    date_trunc('second'::text, gully.tstamp) AS tstamp,
    gully.insert_user,
    date_trunc('second'::text, gully.lastupdate) AS lastupdate,
    gully.lastupdate_user,
    gully.the_geom,
        CASE
            WHEN gully.sector_id > 0 AND vst.is_operative = true AND gully.epa_type::text = 'GULLY'::character varying(16)::text AND cpu.value = '2'::text THEN gully.epa_type
            ELSE NULL::character varying(16)
        END AS inp_type
   FROM (SELECT inp_netw_mode.value FROM inp_netw_mode) cpu, gully
     LEFT JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
     LEFT JOIN dma ON gully.dma_id = dma.dma_id
     LEFT JOIN sector ON gully.sector_id = sector.sector_id
     LEFT JOIN exploitation ON gully.expl_id = exploitation.expl_id
     LEFT JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
     LEFT JOIN streetaxis c ON c.id::text = gully.streetaxis_id::text
     LEFT JOIN streetaxis d ON d.id::text = gully.streetaxis2_id::text
     LEFT JOIN cat_connec cc ON cc.id::text = gully.connec_arccat_id::text
     LEFT JOIN value_state_type vst ON vst.id = gully.state_type
     LEFT JOIN ext_municipality mu ON gully.muni_id = mu.muni_id
     LEFT JOIN drainzone USING (drainzone_id);
     
     
-- add brand_id, model_id, serial_number
CREATE OR REPLACE VIEW vu_arc
AS WITH streetaxis AS (
         SELECT v_ext_streetaxis.id,
            v_ext_streetaxis.descript
           FROM v_ext_streetaxis
        )
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.nodetype_1,
    arc.y1,
    arc.custom_y1,
    arc.elev1,
    arc.custom_elev1,
        CASE
            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
            ELSE arc.sys_elev1
        END AS sys_elev1,
        CASE
            WHEN
            CASE
                WHEN arc.custom_y1 IS NULL THEN arc.y1
                ELSE arc.custom_y1
            END IS NULL THEN arc.node_sys_top_elev_1 - arc.sys_elev1
            ELSE
            CASE
                WHEN arc.custom_y1 IS NULL THEN arc.y1
                ELSE arc.custom_y1
            END
        END AS sys_y1,
    arc.node_sys_top_elev_1 -
        CASE
            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
            ELSE arc.sys_elev1
        END - cat_arc.geom1 AS r1,
        CASE
            WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
            ELSE arc.sys_elev1
        END - arc.node_sys_elev_1 AS z1,
    arc.node_2,
    arc.nodetype_2,
    arc.y2,
    arc.custom_y2,
    arc.elev2,
    arc.custom_elev2,
        CASE
            WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
            ELSE arc.sys_elev2
        END AS sys_elev2,
        CASE
            WHEN
            CASE
                WHEN arc.custom_y2 IS NULL THEN arc.y2
                ELSE arc.custom_y2
            END IS NULL THEN arc.node_sys_top_elev_2 - arc.sys_elev2
            ELSE
            CASE
                WHEN arc.custom_y2 IS NULL THEN arc.y2
                ELSE arc.custom_y2
            END
        END AS sys_y2,
    arc.node_sys_top_elev_2 -
        CASE
            WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
            ELSE arc.sys_elev2
        END - cat_arc.geom1 AS r2,
        CASE
            WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
            ELSE arc.sys_elev2
        END - arc.node_sys_elev_2 AS z2,
    arc.sys_slope AS slope,
    arc.arc_type,
    cat_feature.system_id AS sys_type,
    arc.arccat_id,
        CASE
            WHEN arc.matcat_id IS NULL THEN cat_arc.matcat_id
            ELSE arc.matcat_id
        END AS matcat_id,
    cat_arc.shape AS cat_shape,
    cat_arc.geom1 AS cat_geom1,
    cat_arc.geom2 AS cat_geom2,
    cat_arc.width AS cat_width,
    cat_arc.area AS cat_area,
    arc.epa_type,
    arc.state,
    arc.state_type,
    arc.expl_id,
    e.macroexpl_id,
    arc.sector_id,
    s.sector_type,
    s.macrosector_id,
    arc.drainzone_id,
    drainzone.drainzone_type,
    arc.annotation,
    st_length(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.inverted_slope,
    arc.observ,
    arc.comment,
    arc.dma_id,
    m.macrodma_id,
    m.dma_type,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.workcat_id_plan,
    arc.builtdate,
    arc.enddate,
    arc.buildercat_id,
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
    mu.region_id,
    mu.province_id,
    arc.descript,
    concat(cat_feature.link_path, arc.link) AS link,
    arc.verified,
    arc.undelete,
    cat_arc.label,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.label_quadrant,
    arc.publish,
    arc.inventory,
    arc.uncertain,
    arc.num_value,
    arc.asset_id,
    arc.pavcat_id,
    arc.parent_id,
    arc.expl_id2,
    vst.is_operative,
    arc.minsector_id,
    arc.macrominsector_id,
    arc.adate,
    arc.adescript,
    arc.visitability,
    date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
        CASE
            WHEN arc.sector_id > 0 AND vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN arc.epa_type
            ELSE NULL::character varying(16)
        END AS inp_type,
    arc.brand_id,
    arc.model_id,
    arc.serial_number
   FROM arc
     JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
     JOIN sector s ON s.sector_id = arc.sector_id
     JOIN exploitation e USING (expl_id)
     LEFT JOIN dma m USING (dma_id)
     LEFT JOIN streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN streetaxis d ON d.id::text = arc.streetaxis2_id::text
     LEFT JOIN value_state_type vst ON vst.id = arc.state_type
     LEFT JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
     LEFT JOIN drainzone USING (drainzone_id);

-- add brand_id, model_id, serial_number
CREATE OR REPLACE VIEW v_edit_arc
AS SELECT a.arc_id,
    a.code,
    a.node_1,
    a.nodetype_1,
    a.y1,
    a.custom_y1,
    a.elev1,
    a.custom_elev1,
    a.sys_elev1,
    a.sys_y1,
    a.r1,
    a.z1,
    a.node_2,
    a.nodetype_2,
    a.y2,
    a.custom_y2,
    a.elev2,
    a.custom_elev2,
    a.sys_elev2,
    a.sys_y2,
    a.r2,
    a.z2,
    a.slope,
    a.arc_type,
    a.sys_type,
    a.arccat_id,
    a.matcat_id,
    a.cat_shape,
    a.cat_geom1,
    a.cat_geom2,
    a.cat_width,
    a.cat_area,
    a.epa_type,
    a.state,
    a.state_type,
    a.expl_id,
    a.macroexpl_id,
    a.sector_id,
    a.sector_type,
    a.macrosector_id,
    a.drainzone_id,
    a.drainzone_type,
    a.annotation,
    a.gis_length,
    a.custom_length,
    a.inverted_slope,
    a.observ,
    a.comment,
    a.dma_id,
    a.macrodma_id,
    a.dma_type,
    a.soilcat_id,
    a.function_type,
    a.category_type,
    a.fluid_type,
    a.location_type,
    a.workcat_id,
    a.workcat_id_end,
    a.workcat_id_plan,
    a.builtdate,
    a.enddate,
    a.buildercat_id,
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
    a.region_id,
    a.province_id,
    a.descript,
    a.link,
    a.verified,
    a.undelete,
    a.label,
    a.label_x,
    a.label_y,
    a.label_rotation,
    a.label_quadrant,
    a.publish,
    a.inventory,
    a.uncertain,
    a.num_value,
    a.asset_id,
    a.pavcat_id,
    a.parent_id,
    a.expl_id2,
    a.is_operative,
    a.minsector_id,
    a.macrominsector_id,
    a.adate,
    a.adescript,
    a.visitability,
    a.tstamp,
    a.insert_user,
    a.lastupdate,
    a.lastupdate_user,
    a.the_geom,
    a.inp_type,
    a.brand_id,
    a.model_id,
    a.serial_number
   FROM ( SELECT a_1.arc_id,
            a_1.code,
            a_1.node_1,
            a_1.nodetype_1,
            a_1.y1,
            a_1.custom_y1,
            a_1.elev1,
            a_1.custom_elev1,
            a_1.sys_elev1,
            a_1.sys_y1,
            a_1.r1,
            a_1.z1,
            a_1.node_2,
            a_1.nodetype_2,
            a_1.y2,
            a_1.custom_y2,
            a_1.elev2,
            a_1.custom_elev2,
            a_1.sys_elev2,
            a_1.sys_y2,
            a_1.r2,
            a_1.z2,
            a_1.slope,
            a_1.arc_type,
            a_1.sys_type,
            a_1.arccat_id,
            a_1.matcat_id,
            a_1.cat_shape,
            a_1.cat_geom1,
            a_1.cat_geom2,
            a_1.cat_width,
            a_1.cat_area,
            a_1.epa_type,
            a_1.state,
            a_1.state_type,
            a_1.expl_id,
            a_1.macroexpl_id,
            a_1.sector_id,
            a_1.sector_type,
            a_1.macrosector_id,
            a_1.drainzone_id,
            a_1.drainzone_type,
            a_1.annotation,
            a_1.gis_length,
            a_1.custom_length,
            a_1.inverted_slope,
            a_1.observ,
            a_1.comment,
            a_1.dma_id,
            a_1.macrodma_id,
            a_1.dma_type,
            a_1.soilcat_id,
            a_1.function_type,
            a_1.category_type,
            a_1.fluid_type,
            a_1.location_type,
            a_1.workcat_id,
            a_1.workcat_id_end,
            a_1.workcat_id_plan,
            a_1.builtdate,
            a_1.enddate,
            a_1.buildercat_id,
            a_1.ownercat_id,
            a_1.muni_id,
            a_1.postcode,
            a_1.district_id,
            a_1.streetname,
            a_1.postnumber,
            a_1.postcomplement,
            a_1.streetname2,
            a_1.postnumber2,
            a_1.postcomplement2,
            a_1.region_id,
            a_1.province_id,
            a_1.descript,
            a_1.link,
            a_1.verified,
            a_1.undelete,
            a_1.label,
            a_1.label_x,
            a_1.label_y,
            a_1.label_rotation,
            a_1.label_quadrant,
            a_1.publish,
            a_1.inventory,
            a_1.uncertain,
            a_1.num_value,
            a_1.asset_id,
            a_1.pavcat_id,
            a_1.parent_id,
            a_1.expl_id2,
            a_1.is_operative,
            a_1.minsector_id,
            a_1.macrominsector_id,
            a_1.adate,
            a_1.adescript,
            a_1.visitability,
            a_1.tstamp,
            a_1.insert_user,
            a_1.lastupdate,
            a_1.lastupdate_user,
            a_1.the_geom,
            a_1.inp_type,
            a_1.brand_id,
            a_1.model_id,
            a_1.serial_number
           FROM ( SELECT selector_expl.expl_id
                   FROM selector_expl
                  WHERE selector_expl.cur_user = CURRENT_USER) s_1,
            vu_arc a_1
             JOIN v_state_arc USING (arc_id)
          WHERE a_1.expl_id = s_1.expl_id OR a_1.expl_id2 = s_1.expl_id) a
     JOIN selector_sector s USING (sector_id)
     LEFT JOIN selector_municipality m USING (muni_id)
  WHERE s.cur_user = CURRENT_USER AND (m.cur_user = CURRENT_USER OR a.muni_id IS NULL);
