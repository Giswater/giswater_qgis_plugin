/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- ingnore TCV valves
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_valve WHERE to_arc IS NULL AND valve_type <> ''TCV'''
WHERE fid=368;

-- ve_arc source

CREATE OR REPLACE VIEW ve_arc
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), dma_table AS (
         SELECT dma.dma_id,
            dma.macrodma_id,
            dma.stylesheet,
            t.id AS dma_type
           FROM dma
             LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
        ), presszone_table AS (
         SELECT presszone.presszone_id,
            presszone.head AS presszone_head,
            presszone.stylesheet,
            t.id AS presszone_type
           FROM presszone
             LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
        ), dqa_table AS (
         SELECT dqa.dqa_id,
            dqa.stylesheet,
            t.id AS dqa_type,
            dqa.macrodqa_id
           FROM dqa
             LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type::text AND t.typevalue::text = 'dqa_type'::text
        ), supplyzone_table AS (
         SELECT supplyzone.supplyzone_id,
            supplyzone.stylesheet,
            t.id AS supplyzone_type
           FROM supplyzone
             LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type::text AND t.typevalue::text = 'supplyzone_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            t.id AS omzone_type,
            omzone.macroomzone_id
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        )
 SELECT a.arc_id,
    a.code,
    a.sys_code,
    a.node_1,
    a.nodetype_1,
    a.elevation1,
    a.depth1,
    a.staticpressure1,
    a.node_2,
    a.nodetype_2,
    a.staticpressure2,
    a.elevation2,
    a.depth2,
    ((COALESCE(a.depth1) + COALESCE(a.depth2)) / 2::numeric)::numeric(12,2) AS depth,
    cat_arc.arc_type,
    a.arccat_id,
    cat_feature.feature_class AS sys_type,
    cat_arc.matcat_id AS cat_matcat_id,
    cat_arc.pnom AS cat_pnom,
    cat_arc.dnom AS cat_dnom,
    cat_arc.dint AS cat_dint,
    cat_arc.dr AS cat_dr,
    a.epa_type,
    a.state,
    a.state_type,
    a.parent_id,
    a.expl_id,
    exploitation.macroexpl_id,
    a.muni_id,
    a.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    a.supplyzone_id,
    supplyzone_table.supplyzone_type,
    a.presszone_id,
    presszone_table.presszone_type,
    presszone_table.presszone_head,
    a.dma_id,
    dma_table.macrodma_id,
    dma_table.dma_type,
    a.dqa_id,
    dqa_table.macrodqa_id,
    dqa_table.dqa_type,
    a.omzone_id,
    omzone_table.macroomzone_id,
    omzone_table.omzone_type,
    a.minsector_id,
    a.pavcat_id,
    a.soilcat_id,
    a.function_type,
    a.category_type,
    a.location_type,
    a.fluid_type,
    a.descript,
    st_length2d(a.the_geom)::numeric(12,2) AS gis_length,
    a.custom_length,
    a.annotation,
    a.observ,
    a.comment,
    concat(cat_feature.link_path, a.link) AS link,
    a.num_value,
    a.district_id,
    a.postcode,
    a.streetaxis_id,
    a.postnumber,
    a.postcomplement,
    a.streetaxis2_id,
    a.postnumber2,
    a.postcomplement2,
    vm.region_id,
    vm.province_id,
    a.workcat_id,
    a.workcat_id_end,
    a.workcat_id_plan,
    a.builtdate,
    a.enddate,
    a.ownercat_id,
    a.om_state,
    a.conserv_state,
    COALESCE(a.brand_id, cat_arc.brand_id) AS brand_id,
    COALESCE(a.model_id, cat_arc.model_id) AS model_id,
    a.serial_number,
    a.asset_id,
    a.adate,
    a.adescript,
    a.verified,
    a.datasource,
    cat_arc.label,
    a.label_x,
    a.label_y,
    a.label_rotation,
    a.label_quadrant,
    a.inventory,
    a.publish,
    vst.is_operative,
    a.is_scadamap,
        CASE
            WHEN a.sector_id > 0 AND vst.is_operative = true AND a.epa_type::text <> 'UNDEFINED'::text THEN a.epa_type::text
            ELSE NULL::text
        END AS inp_type,
    arc_add.result_id,
    arc_add.flow_max,
    arc_add.flow_min,
    arc_add.flow_avg,
    arc_add.vel_max,
    arc_add.vel_min,
    arc_add.vel_avg,
    arc_add.tot_headloss_max,
    arc_add.tot_headloss_min,
    arc_add.mincut_connecs,
    arc_add.mincut_hydrometers,
    arc_add.mincut_length,
    arc_add.mincut_watervol,
    arc_add.mincut_criticality,
    arc_add.hydraulic_criticality,
    arc_add.pipe_capacity,
    arc_add.mincut_impact_topo,
    arc_add.mincut_impact_hydro,
    sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
    dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
    dqa_table.stylesheet ->> 'featureColor'::text AS dqa_style,
    supplyzone_table.stylesheet ->> 'featureColor'::text AS supplyzone_style,
    a.lock_level,
    a.expl_visibility,
    date_trunc('second'::text, a.created_at) AS created_at,
    a.created_by,
    date_trunc('second'::text, a.updated_at) AS updated_at,
    a.updated_by,
    a.the_geom,
    vf.p_state,
    a.uuid,
    a.uncertain,
    a.dataquality,
    a.dataquality_obs
   FROM arc a
     JOIN vf_arc vf ON vf.arc_id = a.arc_id
     JOIN cat_arc ON cat_arc.id::text = a.arccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arc_type::text
     JOIN exploitation ON a.expl_id = exploitation.expl_id
     JOIN v_municipality vm ON a.muni_id = vm.muni_id
     JOIN sector_table ON sector_table.sector_id = a.sector_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = a.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = a.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = a.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = a.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = a.omzone_id
     LEFT JOIN arc_add ON arc_add.arc_id = a.arc_id
     LEFT JOIN value_state_type vst ON vst.id = a.state_type;

-- ve_node source

CREATE OR REPLACE VIEW ve_node
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), dma_table AS (
         SELECT dma.dma_id,
            dma.macrodma_id,
            dma.stylesheet,
            t.id AS dma_type
           FROM dma
             LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
        ), presszone_table AS (
         SELECT presszone.presszone_id,
            presszone.head AS presszone_head,
            presszone.stylesheet,
            t.id AS presszone_type
           FROM presszone
             LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
        ), dqa_table AS (
         SELECT dqa.dqa_id,
            dqa.stylesheet,
            t.id AS dqa_type,
            dqa.macrodqa_id
           FROM dqa
             LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type::text AND t.typevalue::text = 'dqa_type'::text
        ), supplyzone_table AS (
         SELECT supplyzone.supplyzone_id,
            supplyzone.stylesheet,
            t.id AS supplyzone_type
           FROM supplyzone
             LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type::text AND t.typevalue::text = 'supplyzone_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            t.id AS omzone_type,
            omzone.macroomzone_id
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), sector_visibility_agg AS (
         SELECT node_x_sector_visibility.node_id,
            array_agg(node_x_sector_visibility.sector_id ORDER BY node_x_sector_visibility.sector_id) AS sector_visibility
           FROM node_x_sector_visibility
          GROUP BY node_x_sector_visibility.node_id
        ), muni_visibility_agg AS (
         SELECT node_x_municipality_visibility.node_id,
            array_agg(node_x_municipality_visibility.muni_id ORDER BY node_x_municipality_visibility.muni_id) AS muni_visibility
           FROM node_x_municipality_visibility
          GROUP BY node_x_municipality_visibility.node_id
        )
 SELECT n.node_id,
    n.code,
    n.sys_code,
    n.top_elev,
    n.custom_top_elev,
    COALESCE(n.custom_top_elev, n.top_elev) AS sys_top_elev,
    n.depth,
    cat_node.node_type,
    cat_feature.feature_class AS sys_type,
    n.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    cat_node.dint AS cat_dint,
    n.epa_type,
    n.state,
    n.state_type,
    n.arc_id,
    n.parent_id,
    n.expl_id,
    exploitation.macroexpl_id,
    n.muni_id,
    n.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    n.supplyzone_id,
    supplyzone_table.supplyzone_type,
    n.presszone_id,
    presszone_table.presszone_type,
    presszone_table.presszone_head,
    n.dma_id,
    dma_table.macrodma_id,
    dma_table.dma_type,
    n.dqa_id,
    dqa_table.macrodqa_id,
    dqa_table.dqa_type,
    n.omzone_id,
    omzone_table.macroomzone_id,
    omzone_table.omzone_type,
    n.minsector_id,
    n.pavcat_id,
    n.soilcat_id,
    n.function_type,
    n.category_type,
    n.location_type,
    n.fluid_type,
    n.staticpressure,
    n.annotation,
    n.observ,
    n.comment,
    n.descript,
    concat(cat_feature.link_path, n.link) AS link,
    n.num_value,
    n.district_id,
    n.streetaxis_id,
    n.postcode,
    n.postnumber,
    n.postcomplement,
    n.streetaxis2_id,
    n.postnumber2,
    n.postcomplement2,
    vm.region_id,
    vm.province_id,
    n.workcat_id,
    n.workcat_id_end,
    n.workcat_id_plan,
    n.builtdate,
    n.enddate,
    n.ownercat_id,
    n.accessibility,
    n.om_state,
    n.conserv_state,
    n.access_type,
    n.placement_type,
    COALESCE(n.brand_id, cat_node.brand_id) AS brand_id,
    COALESCE(n.model_id, cat_node.model_id) AS model_id,
    n.serial_number,
    n.asset_id,
    n.adate,
    n.adescript,
    n.verified,
    n.datasource,
    n.hemisphere,
    cat_node.label,
    n.label_x,
    n.label_y,
    n.label_rotation,
    n.rotation,
    n.label_quadrant,
    cat_node.svg,
    n.inventory,
    n.publish,
    vst.is_operative,
    n.is_scadamap,
        CASE
            WHEN n.sector_id > 0 AND vst.is_operative = true AND n.epa_type::text <> 'UNDEFINED'::text THEN n.epa_type::text
            ELSE NULL::text
        END AS inp_type,
    node_add.demand_max,
    node_add.demand_min,
    node_add.demand_avg,
    node_add.press_max,
    node_add.press_min,
    node_add.press_avg,
    node_add.head_max,
    node_add.head_min,
    node_add.head_avg,
    node_add.quality_max,
    node_add.quality_min,
    node_add.quality_avg,
    node_add.result_id,
    sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
    dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
    dqa_table.stylesheet ->> 'featureColor'::text AS dqa_style,
    supplyzone_table.stylesheet ->> 'featureColor'::text AS supplyzone_style,
    n.lock_level,
    n.expl_visibility,
    ( SELECT st_x(n.the_geom) AS st_x) AS xcoord,
    ( SELECT st_y(n.the_geom) AS st_y) AS ycoord,
    ( SELECT st_y(st_transform(n.the_geom, 4326)) AS st_y) AS lat,
    ( SELECT st_x(st_transform(n.the_geom, 4326)) AS st_x) AS long,
    m.closed AS closed_valve,
    m.broken AS broken_valve,
    date_trunc('second'::text, n.created_at) AS created_at,
    n.created_by,
    date_trunc('second'::text, n.updated_at) AS updated_at,
    n.updated_by,
    n.the_geom,
    COALESCE(vf.p_state, n.state) AS p_state,
    n.uuid,
    n.uncertain,
    n.xyz_date,
    m.to_arc,
    sva.sector_visibility,
    mva.muni_visibility,
    n.dataquality,
    n.dataquality_obs
   FROM node n
     JOIN vf_node vf ON vf.node_id = n.node_id
     JOIN cat_node ON cat_node.id::text = n.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_node.node_type::text
     JOIN value_state_type vst ON vst.id = n.state_type
     JOIN exploitation ON n.expl_id = exploitation.expl_id
     JOIN v_municipality vm ON n.muni_id = vm.muni_id
     JOIN sector_table ON sector_table.sector_id = n.sector_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = n.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = n.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = n.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = n.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = n.omzone_id
     LEFT JOIN node_add ON node_add.node_id = n.node_id
     LEFT JOIN man_valve m ON m.node_id = n.node_id
     LEFT JOIN sector_visibility_agg sva ON sva.node_id = n.node_id
     LEFT JOIN muni_visibility_agg mva ON mva.node_id = n.node_id;

CREATE OR REPLACE VIEW ve_connec
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), dma_table AS (
         SELECT dma.dma_id,
            dma.macrodma_id,
            dma.stylesheet,
            t.id AS dma_type
           FROM dma
             LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
        ), presszone_table AS (
         SELECT presszone.presszone_id,
            presszone.head AS presszone_head,
            presszone.stylesheet,
            t.id AS presszone_type
           FROM presszone
             LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
        ), dqa_table AS (
         SELECT dqa.dqa_id,
            dqa.stylesheet,
            t.id AS dqa_type,
            dqa.macrodqa_id
           FROM dqa
             LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type::text AND t.typevalue::text = 'dqa_type'::text
        ), supplyzone_table AS (
         SELECT supplyzone.supplyzone_id,
            supplyzone.stylesheet,
            t.id AS supplyzone_type
           FROM supplyzone
             LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type::text AND t.typevalue::text = 'supplyzone_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            t.id AS omzone_type,
            omzone.macroomzone_id
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), inp_network_mode AS (
         SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        )
 SELECT c.connec_id,
    c.code,
    c.sys_code,
    c.top_elev,
    c.depth,
    cat_connec.connec_type,
    cat_feature.feature_class AS sys_type,
    c.conneccat_id,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    cat_connec.dint AS cat_dint,
    c.customer_code,
    c.connec_length,
    c.epa_type,
    c.state,
    c.state_type,
    vf.arc_id,
    c.expl_id,
    exploitation.macroexpl_id,
    c.muni_id,
    c.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    supplyzone_table.supplyzone_id,
    supplyzone_table.supplyzone_type,
    presszone_table.presszone_id,
    presszone_table.presszone_type,
    presszone_table.presszone_head,
    dma_table.dma_id,
    dma_table.macrodma_id,
    dma_table.dma_type,
    dqa_table.dqa_id,
    dqa_table.macrodqa_id,
    dqa_table.dqa_type,
    omzone_table.omzone_id,
    omzone_table.omzone_type,
    c.crmzone_id,
    crmzone.macrocrmzone_id,
    crmzone.name AS crmzone_name,
    c.minsector_id,
    c.soilcat_id,
    c.function_type,
    c.category_type,
    c.location_type,
    c.fluid_type,
    c.n_hydrometer,
    c.n_inhabitants,
    c.staticpressure,
    c.descript,
    c.annotation,
    c.observ,
    c.comment,
    concat(cat_feature.link_path, c.link) AS link,
    c.num_value,
    c.district_id,
    c.postcode,
    c.streetaxis_id,
    c.postnumber,
    c.postcomplement,
    c.streetaxis2_id,
    c.postnumber2,
    c.postcomplement2,
    vm.region_id,
    vm.province_id,
    c.block_code,
    c.plot_id,
    c.workcat_id,
    c.workcat_id_end,
    c.workcat_id_plan,
    c.builtdate,
    c.enddate,
    c.ownercat_id,
    vf.pjoint_id,
    vf.pjoint_type,
    c.om_state,
    c.conserv_state,
    c.accessibility,
    c.access_type,
    c.placement_type,
    c.priority,
    COALESCE(c.brand_id, cat_connec.brand_id) AS brand_id,
    COALESCE(c.model_id, cat_connec.model_id) AS model_id,
    c.serial_number,
    c.asset_id,
    c.adate,
    c.adescript,
    c.verified,
    c.datasource,
    cat_connec.label,
    c.label_x,
    c.label_y,
    c.label_rotation,
    c.rotation,
    c.label_quadrant,
    cat_connec.svg,
    c.inventory,
    c.publish,
    vst.is_operative,
        CASE
            WHEN c.sector_id > 0 AND vst.is_operative = true AND c.epa_type = 'JUNCTION'::text AND inp_network_mode.value = '4'::text THEN c.epa_type::character varying::text
            ELSE NULL::text
        END AS inp_type,
    connec_add.demand_base,
    connec_add.demand_max,
    connec_add.demand_min,
    connec_add.demand_avg,
    connec_add.press_max,
    connec_add.press_min,
    connec_add.press_avg,
    connec_add.quality_max,
    connec_add.quality_min,
    connec_add.quality_avg,
    connec_add.flow_max,
    connec_add.flow_min,
    connec_add.flow_avg,
    connec_add.vel_max,
    connec_add.vel_min,
    connec_add.vel_avg,
    connec_add.result_id,
    sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
    dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
    dqa_table.stylesheet ->> 'featureColor'::text AS dqa_style,
    supplyzone_table.stylesheet ->> 'featureColor'::text AS supplyzone_style,
    c.lock_level,
    c.expl_visibility,
    ( SELECT st_x(c.the_geom) AS st_x) AS xcoord,
    ( SELECT st_y(c.the_geom) AS st_y) AS ycoord,
    ( SELECT st_y(st_transform(c.the_geom, 4326)) AS st_y) AS lat,
    ( SELECT st_x(st_transform(c.the_geom, 4326)) AS st_x) AS long,
    date_trunc('second'::text, c.created_at) AS created_at,
    c.created_by,
    date_trunc('second'::text, c.updated_at) AS updated_at,
    c.updated_by,
    c.the_geom,
    vf.p_state,
    c.uuid,
    c.uncertain,
    c.xyz_date,
    c.dataquality,
    c.dataquality_obs
   FROM connec c
     JOIN vf_connec vf ON vf.connec_id = c.connec_id
     JOIN cat_connec ON cat_connec.id::text = c.conneccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_connec.connec_type::text
     JOIN exploitation ON c.expl_id = exploitation.expl_id
     JOIN v_municipality vm ON c.muni_id = vm.muni_id
     JOIN sector_table ON sector_table.sector_id = c.sector_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = c.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = c.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = c.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = c.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = c.omzone_id
     LEFT JOIN crmzone ON crmzone.crmzone_id = c.crmzone_id
     LEFT JOIN connec_add ON connec_add.connec_id = c.connec_id
     LEFT JOIN value_state_type vst ON vst.id = c.state_type
     LEFT JOIN inp_network_mode ON true;

-- ve_link source

CREATE OR REPLACE VIEW ve_link
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), dma_table AS (
         SELECT dma.dma_id,
            dma.macrodma_id,
            dma.stylesheet,
            t.id AS dma_type
           FROM dma
             LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
        ), presszone_table AS (
         SELECT presszone.presszone_id,
            presszone.head AS presszone_head,
            presszone.stylesheet,
            t.id AS presszone_type
           FROM presszone
             LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
        ), dqa_table AS (
         SELECT dqa.dqa_id,
            dqa.stylesheet,
            t.id AS dqa_type,
            dqa.macrodqa_id
           FROM dqa
             LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type::text AND t.typevalue::text = 'dqa_type'::text
        ), supplyzone_table AS (
         SELECT supplyzone.supplyzone_id,
            supplyzone.stylesheet,
            t.id AS supplyzone_type
           FROM supplyzone
             LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type::text AND t.typevalue::text = 'supplyzone_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            t.id AS omzone_type,
            omzone.macroomzone_id,
            omzone.stylesheet
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), inp_network_mode AS (
         SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        )
 SELECT l.link_id,
    l.code,
    l.sys_code,
    l.top_elev1,
    l.depth1,
        CASE
            WHEN l.top_elev1 IS NULL OR l.depth1 IS NULL THEN NULL::double precision
            ELSE l.top_elev1 - l.depth1::double precision
        END AS elevation1,
    l.exit_id,
    l.exit_type,
    l.top_elev2,
    l.depth2,
        CASE
            WHEN l.top_elev2 IS NULL OR l.depth2 IS NULL THEN NULL::double precision
            ELSE l.top_elev2 - l.depth2::double precision
        END AS elevation2,
    l.feature_type,
    l.feature_id,
    cat_link.link_type,
    cat_feature.feature_class AS sys_type,
    l.linkcat_id,
    cat_link.matcat_id,
    cat_link.dnom AS cat_dnom,
    cat_link.dint AS cat_dint,
    cat_link.pnom AS cat_pnom,
    l.state,
    l.state_type,
    l.expl_id,
    exploitation.macroexpl_id,
    l.muni_id,
    l.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    l.supplyzone_id,
    supplyzone_table.supplyzone_type,
    l.presszone_id,
    presszone_table.presszone_type,
    presszone_table.presszone_head,
    l.dma_id,
    dma_table.macrodma_id,
    dma_table.dma_type,
    l.dqa_id,
    dqa_table.macrodqa_id,
    dqa_table.dqa_type,
    l.omzone_id,
    omzone_table.macroomzone_id,
    omzone_table.omzone_type,
    l.minsector_id,
    l.location_type,
    l.fluid_type,
    l.custom_length,
    st_length(l.the_geom)::numeric(12,3) AS gis_length,
    l.staticpressure1,
    l.staticpressure2,
    l.annotation,
    l.observ,
    l.comment,
    l.descript,
    l.link,
    l.num_value,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate,
    l.brand_id,
    l.model_id,
    l.verified,
    l.uncertain,
    l.userdefined_geom,
    l.datasource,
    l.is_operative,
    sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
    omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
    dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
    dqa_table.stylesheet ->> 'featureColor'::text AS dqa_style,
    supplyzone_table.stylesheet ->> 'featureColor'::text AS supplyzone_style,
        CASE
            WHEN l.sector_id > 0 AND l.is_operative = true AND c.epa_type = 'JUNCTION'::text AND inp_network_mode.value = '4'::text THEN c.epa_type
            ELSE NULL::text
        END AS inp_type,
    l.lock_level,
    l.expl_visibility,
    l.created_at,
    l.created_by,
    l.updated_at,
    l.updated_by,
    l.the_geom,
    vf.p_state,
    l.uuid,
    l.dataquality,
    l.dataquality_obs
   FROM link l
     JOIN vf_link vf ON vf.link_id = l.link_id
     LEFT JOIN connec c ON c.connec_id = l.feature_id
     JOIN sector_table ON sector_table.sector_id = l.sector_id
     JOIN cat_link ON cat_link.id::text = l.linkcat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_link.link_type::text
     JOIN exploitation ON l.expl_id = exploitation.expl_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = l.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = l.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = l.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = l.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = l.omzone_id
     LEFT JOIN inp_network_mode ON true;

     -- ve_element source

CREATE OR REPLACE VIEW ve_element
AS WITH sector_visibility_agg AS (
         SELECT element_x_sector_visibility.element_id,
            array_agg(element_x_sector_visibility.sector_id ORDER BY element_x_sector_visibility.sector_id) AS sector_visibility
           FROM element_x_sector_visibility
          GROUP BY element_x_sector_visibility.element_id
        ), muni_visibility_agg AS (
         SELECT element_x_municipality_visibility.element_id,
            array_agg(element_x_municipality_visibility.muni_id ORDER BY element_x_municipality_visibility.muni_id) AS muni_visibility
           FROM element_x_municipality_visibility
          GROUP BY element_x_municipality_visibility.element_id
        )
 SELECT e.element_id,
    e.code,
    e.sys_code,
    e.top_elev,
    cat_element.element_type,
    e.elementcat_id,
    e.num_elements,
    e.epa_type,
    e.state,
    e.state_type,
    e.expl_id,
    e.muni_id,
    e.sector_id,
    e.omzone_id,
    e.function_type,
    e.category_type,
    e.location_type,
    e.observ,
    e.comment,
    cat_element.link,
    e.workcat_id,
    e.workcat_id_end,
    e.builtdate,
    e.enddate,
    e.ownercat_id,
    e.brand_id,
    e.model_id,
    e.serial_number,
    e.asset_id,
    e.verified,
    e.datasource,
    e.label_x,
    e.label_y,
    e.label_rotation,
    e.rotation,
    e.inventory,
    e.publish,
    e.trace_featuregeom,
    e.lock_level,
    e.expl_visibility,
    e.created_at,
    e.created_by,
    e.updated_at,
    e.updated_by,
    e.the_geom,
    e.uuid,
    sva.sector_visibility,
    mva.muni_visibility,
    e.dataquality,
    e.dataquality_obs
   FROM element e
     JOIN vf_element vf ON vf.element_id = e.element_id
     JOIN cat_element ON e.elementcat_id::text = cat_element.id::text
     LEFT JOIN sector_visibility_agg sva ON sva.element_id = e.element_id
     LEFT JOIN muni_visibility_agg mva ON mva.element_id = e.element_id;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
SELECT child_layer, 'form_feature', 'tab_data', 'dataquality', 'lyt_data_1', (SELECT max(layoutorder)+1 FROM config_form_fields WHERE formname = child_layer AND formtype='form_feature' AND tabname='tab_data' AND layoutname='lyt_data_2'), 'integer', 'text', 'Dataquality', 'To indicate the number of closing-opening turns when operating the valve.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL 
FROM cat_feature ON CONFLICT DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
SELECT child_layer, 'form_feature', 'tab_data', 'dataquality_obs', 'lyt_data_1', (SELECT max(layoutorder)+1 FROM config_form_fields WHERE formname = child_layer AND formtype='form_feature' AND tabname='tab_data' AND layoutname='lyt_data_2'), 'text', 'text', 'Dataquality_obs', 'Observations supporting the assigned utility survey quality level.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL 
FROM cat_feature ON CONFLICT DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
SELECT child_layer, 'form_feature', 'tab_data', 'turns_count', 'lyt_data_2', (SELECT max(layoutorder)+1 FROM config_form_fields WHERE formname = child_layer AND formtype='form_feature' AND tabname='tab_data' AND layoutname='lyt_data_2'), 'numeric', 'text', 'Turns count', 'To indicate the number of closing-opening turns when operating the valve.', NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL 
FROM cat_feature WHERE feature_class = 'VALVE' ON CONFLICT DO NOTHING;
