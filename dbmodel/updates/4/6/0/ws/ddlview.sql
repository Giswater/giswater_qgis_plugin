/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 28/10/2025
CREATE OR REPLACE VIEW ve_plan_netscenario_dma
AS WITH plan_netscenario_current AS (
         SELECT config_param_user.value::integer AS netscenario_id
           FROM config_param_user
          WHERE config_param_user.cur_user::text = CURRENT_USER AND config_param_user.parameter::text = 'plan_netscenario_current'::text
         LIMIT 1
        ), sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.dma_id,
    n.dma_name AS name,
    n.pattern_id,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.stylesheet::text AS stylesheet,
    n.expl_id,
    n.muni_id,
    n.sector_id
   FROM plan_netscenario_dma n
     JOIN plan_netscenario p USING (netscenario_id)
     JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = p.expl_id));

CREATE OR REPLACE VIEW ve_plan_netscenario_presszone
AS WITH plan_netscenario_current AS (
         SELECT config_param_user.value::integer AS netscenario_id
           FROM config_param_user
          WHERE config_param_user.cur_user::text = CURRENT_USER AND config_param_user.parameter::text = 'plan_netscenario_current'::text
         LIMIT 1
        ), sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT n.netscenario_id,
    p.name AS netscenario_name,
    n.presszone_id,
    n.presszone_name AS name,
    n.head,
    n.graphconfig,
    n.the_geom,
    n.active,
    n.presszone_type,
    n.stylesheet::text AS stylesheet,
    n.expl_id,
    n.muni_id,
    n.sector_id
   FROM plan_netscenario_presszone n
     JOIN plan_netscenario p USING (netscenario_id)
     JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = p.expl_id));

CREATE OR REPLACE VIEW ve_arc
AS WITH sel_state AS (
         SELECT selector_state.state_id
           FROM selector_state
          WHERE selector_state.cur_user = CURRENT_USER
        ), sel_sector AS (
         SELECT selector_sector.sector_id
           FROM selector_sector
          WHERE selector_sector.cur_user = CURRENT_USER
        ), sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        ), sel_muni AS (
         SELECT selector_municipality.muni_id
           FROM selector_municipality
          WHERE selector_municipality.cur_user = CURRENT_USER
        ), sel_ps AS (
         SELECT selector_psector.psector_id
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), dma_table AS (
         SELECT dma.dma_id,
            dma.macrodma_id,
            dma.stylesheet,
            t.id::character varying(16) AS dma_type
           FROM dma
             LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
        ), presszone_table AS (
         SELECT presszone.presszone_id,
            presszone.head AS presszone_head,
            presszone.stylesheet,
            t.id::character varying(16) AS presszone_type
           FROM presszone
             LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
        ), dqa_table AS (
         SELECT dqa.dqa_id,
            dqa.stylesheet,
            t.id::character varying(16) AS dqa_type,
            dqa.macrodqa_id
           FROM dqa
             LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type::text AND t.typevalue::text = 'dqa_type'::text
        ), supplyzone_table AS (
         SELECT supplyzone.supplyzone_id,
            supplyzone.stylesheet,
            t.id::character varying(16) AS supplyzone_type
           FROM supplyzone
             LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type::text AND t.typevalue::text = 'supplyzone_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            t.id::character varying(16) AS omzone_type,
            omzone.macroomzone_id
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), arc_psector AS (
         SELECT DISTINCT ON (pp.arc_id, pp.state) pp.arc_id,
            pp.state AS p_state
           FROM plan_psector_x_arc pp
          WHERE (EXISTS ( SELECT 1
                   FROM sel_ps s
                  WHERE s.psector_id = pp.psector_id))
          ORDER BY pp.arc_id, pp.state
        ), arc_selector AS (
         SELECT a.arc_id,
            NULL::smallint AS p_state
           FROM arc a
          WHERE (EXISTS ( SELECT 1
                   FROM sel_state s
                  WHERE s.state_id = a.state)) AND (EXISTS ( SELECT 1
                   FROM sel_sector s
                  WHERE s.sector_id = a.sector_id)) AND (EXISTS ( SELECT 1
                   FROM sel_expl s
                  WHERE s.expl_id = ANY (array_append(a.expl_visibility::integer[], a.expl_id)))) AND (EXISTS ( SELECT 1
                   FROM sel_muni s
                  WHERE s.muni_id = a.muni_id)) AND NOT (EXISTS ( SELECT 1
                   FROM arc_psector ap
                  WHERE ap.arc_id = a.arc_id))
        UNION ALL
         SELECT ap.arc_id,
            ap.p_state
           FROM arc_psector ap
          WHERE (EXISTS ( SELECT 1
                   FROM sel_state s
                  WHERE s.state_id = ap.p_state))
        ), arc_selected AS (
         SELECT arc.arc_id,
            arc.code,
            arc.sys_code,
            arc.node_1,
            arc.nodetype_1,
            arc.elevation1,
            arc.depth1,
            arc.staticpressure1,
            arc.node_2,
            arc.nodetype_2,
            arc.staticpressure2,
            arc.elevation2,
            arc.depth2,
            ((COALESCE(arc.depth1) + COALESCE(arc.depth2)) / 2::numeric)::numeric(12,2) AS depth,
            cat_arc.arc_type,
            arc.arccat_id,
            cat_feature.feature_class AS sys_type,
            cat_arc.matcat_id AS cat_matcat_id,
            cat_arc.pnom AS cat_pnom,
            cat_arc.dnom AS cat_dnom,
            cat_arc.dint AS cat_dint,
            cat_arc.dr AS cat_dr,
            arc.epa_type,
            arc.state,
            arc.state_type,
            arc.parent_id,
            arc.expl_id,
            exploitation.macroexpl_id,
            arc.muni_id,
            arc.sector_id,
            sector_table.macrosector_id,
            sector_table.sector_type,
            arc.supplyzone_id,
            supplyzone_table.supplyzone_type,
            arc.presszone_id,
            presszone_table.presszone_type,
            presszone_table.presszone_head,
            arc.dma_id,
            dma_table.macrodma_id,
            dma_table.dma_type,
            arc.dqa_id,
            dqa_table.macrodqa_id,
            dqa_table.dqa_type,
            arc.omzone_id,
            omzone_table.macroomzone_id,
            omzone_table.omzone_type,
            arc.minsector_id,
            arc.pavcat_id,
            arc.soilcat_id,
            arc.function_type,
            arc.category_type,
            arc.location_type,
            arc.fluid_type,
            arc.descript,
            st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
            arc.custom_length,
            arc.annotation,
            arc.observ,
            arc.comment,
            concat(cat_feature.link_path, arc.link) AS link,
            arc.num_value,
            arc.district_id,
            arc.postcode,
            arc.streetaxis_id,
            arc.postnumber,
            arc.postcomplement,
            arc.streetaxis2_id,
            arc.postnumber2,
            arc.postcomplement2,
            mu.region_id,
            mu.province_id,
            arc.workcat_id,
            arc.workcat_id_end,
            arc.workcat_id_plan,
            arc.builtdate,
            arc.enddate,
            arc.ownercat_id,
            arc.om_state,
            arc.conserv_state,
                CASE
                    WHEN arc.brand_id IS NULL THEN cat_arc.brand_id
                    ELSE arc.brand_id
                END AS brand_id,
                CASE
                    WHEN arc.model_id IS NULL THEN cat_arc.model_id
                    ELSE arc.model_id
                END AS model_id,
            arc.serial_number,
            arc.asset_id,
            arc.adate,
            arc.adescript,
            arc.verified,
            arc.datasource,
            cat_arc.label,
            arc.label_x,
            arc.label_y,
            arc.label_rotation,
            arc.label_quadrant,
            arc.inventory,
            arc.publish,
            vst.is_operative,
            arc.is_scadamap,
                CASE
                    WHEN arc.sector_id > 0 AND vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::text THEN arc.epa_type::text
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
            arc.lock_level,
            arc.expl_visibility,
            date_trunc('second'::text, arc.created_at) AS created_at,
            arc.created_by,
            date_trunc('second'::text, arc.updated_at) AS updated_at,
            arc.updated_by,
            arc.the_geom,
            arc_selector.p_state,
            arc.uuid,
            arc.uncertain
           FROM arc_selector
             JOIN arc ON arc.arc_id = arc_selector.arc_id
             JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
             JOIN cat_feature ON cat_feature.id::text = cat_arc.arc_type::text
             JOIN exploitation ON arc.expl_id = exploitation.expl_id
             JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
             JOIN sector_table ON sector_table.sector_id = arc.sector_id
             LEFT JOIN presszone_table ON presszone_table.presszone_id = arc.presszone_id
             LEFT JOIN dma_table ON dma_table.dma_id = arc.dma_id
             LEFT JOIN dqa_table ON dqa_table.dqa_id = arc.dqa_id
             LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = arc.supplyzone_id
             LEFT JOIN omzone_table ON omzone_table.omzone_id = arc.omzone_id
             LEFT JOIN arc_add ON arc_add.arc_id = arc.arc_id
             LEFT JOIN value_state_type vst ON vst.id = arc.state_type
        )
 SELECT arc_id,
    code,
    sys_code,
    node_1,
    nodetype_1,
    elevation1,
    depth1,
    staticpressure1,
    node_2,
    nodetype_2,
    staticpressure2,
    elevation2,
    depth2,
    depth,
    arc_type,
    arccat_id,
    sys_type,
    cat_matcat_id,
    cat_pnom,
    cat_dnom,
    cat_dint,
    cat_dr,
    epa_type,
    state,
    state_type,
    parent_id,
    expl_id,
    macroexpl_id,
    muni_id,
    sector_id,
    macrosector_id,
    sector_type,
    supplyzone_id,
    supplyzone_type,
    presszone_id,
    presszone_type,
    presszone_head,
    dma_id,
    macrodma_id,
    dma_type,
    dqa_id,
    macrodqa_id,
    dqa_type,
    omzone_id,
    macroomzone_id,
    omzone_type,
    minsector_id,
    pavcat_id,
    soilcat_id,
    function_type,
    category_type,
    location_type,
    fluid_type,
    descript,
    gis_length,
    custom_length,
    annotation,
    observ,
    comment,
    link,
    num_value,
    district_id,
    postcode,
    streetaxis_id,
    postnumber,
    postcomplement,
    streetaxis2_id,
    postnumber2,
    postcomplement2,
    region_id,
    province_id,
    workcat_id,
    workcat_id_end,
    workcat_id_plan,
    builtdate,
    enddate,
    ownercat_id,
    om_state,
    conserv_state,
    brand_id,
    model_id,
    serial_number,
    asset_id,
    adate,
    adescript,
    verified,
    datasource,
    label,
    label_x,
    label_y,
    label_rotation,
    label_quadrant,
    inventory,
    publish,
    is_operative,
    is_scadamap,
    inp_type,
    result_id,
    flow_max,
    flow_min,
    flow_avg,
    vel_max,
    vel_min,
    vel_avg,
    tot_headloss_max,
    tot_headloss_min,
    mincut_connecs,
    mincut_hydrometers,
    mincut_length,
    mincut_watervol,
    mincut_criticality,
    hydraulic_criticality,
    pipe_capacity,
    mincut_impact_topo,
    mincut_impact_hydro,
    sector_style,
    dma_style,
    presszone_style,
    dqa_style,
    supplyzone_style,
    lock_level,
    expl_visibility,
    created_at,
    created_by,
    updated_at,
    updated_by,
    the_geom,
    p_state,
    uuid,
    uncertain
   FROM arc_selected;


CREATE OR REPLACE VIEW ve_node
AS WITH sel_state AS (
         SELECT selector_state.state_id
           FROM selector_state
          WHERE selector_state.cur_user = CURRENT_USER
        ), sel_sector AS (
         SELECT selector_sector.sector_id
           FROM selector_sector
          WHERE selector_sector.cur_user = CURRENT_USER
        ), sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        ), sel_muni AS (
         SELECT selector_municipality.muni_id
           FROM selector_municipality
          WHERE selector_municipality.cur_user = CURRENT_USER
        ), sel_ps AS (
         SELECT selector_psector.psector_id
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), dma_table AS (
         SELECT dma.dma_id,
            dma.macrodma_id,
            dma.stylesheet,
            t.id::character varying(16) AS dma_type
           FROM dma
             LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
        ), presszone_table AS (
         SELECT presszone.presszone_id,
            presszone.head AS presszone_head,
            presszone.stylesheet,
            t.id::character varying(16) AS presszone_type
           FROM presszone
             LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
        ), dqa_table AS (
         SELECT dqa.dqa_id,
            dqa.stylesheet,
            t.id::character varying(16) AS dqa_type,
            dqa.macrodqa_id
           FROM dqa
             LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type::text AND t.typevalue::text = 'dqa_type'::text
        ), supplyzone_table AS (
         SELECT supplyzone.supplyzone_id,
            supplyzone.stylesheet,
            t.id::character varying(16) AS supplyzone_type
           FROM supplyzone
             LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type::text AND t.typevalue::text = 'supplyzone_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            t.id::character varying(16) AS omzone_type,
            omzone.macroomzone_id
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), node_psector AS (
         SELECT DISTINCT ON (pp.node_id, pp.state) pp.node_id,
            pp.state AS p_state
           FROM plan_psector_x_node pp
          WHERE (EXISTS ( SELECT 1
                   FROM sel_ps s
                  WHERE s.psector_id = pp.psector_id))
          ORDER BY pp.node_id, pp.state
        ), node_selector AS (
         SELECT n_1.node_id,
            NULL::smallint AS p_state
           FROM node n_1
          WHERE (EXISTS ( SELECT 1
                   FROM sel_state s
                  WHERE s.state_id = n_1.state)) AND (EXISTS ( SELECT 1
                   FROM sel_sector s
                  WHERE s.sector_id = n_1.sector_id)) AND (EXISTS ( SELECT 1
                   FROM sel_expl s
                  WHERE s.expl_id = ANY (array_append(n_1.expl_visibility, n_1.expl_id)))) AND (EXISTS ( SELECT 1
                   FROM sel_muni s
                  WHERE s.muni_id = n_1.muni_id)) AND NOT (EXISTS ( SELECT 1
                   FROM node_psector np
                  WHERE np.node_id = n_1.node_id))
        UNION ALL
         SELECT np.node_id,
            np.p_state
           FROM node_psector np
          WHERE (EXISTS ( SELECT 1
                   FROM sel_state s
                  WHERE s.state_id = np.p_state))
        ), node_selected AS (
         SELECT node.node_id,
            node.code,
            node.sys_code,
            node.top_elev,
            node.custom_top_elev,
                CASE
                    WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev
                    ELSE node.top_elev
                END AS sys_top_elev,
            node.depth,
            cat_node.node_type,
            cat_feature.feature_class AS sys_type,
            node.nodecat_id,
            cat_node.matcat_id AS cat_matcat_id,
            cat_node.pnom AS cat_pnom,
            cat_node.dnom AS cat_dnom,
            cat_node.dint AS cat_dint,
            node.epa_type,
            node.state,
            node.state_type,
            node.arc_id,
            node.parent_id,
            node.expl_id,
            exploitation.macroexpl_id,
            node.muni_id,
            node.sector_id,
            sector_table.macrosector_id,
            sector_table.sector_type,
            node.supplyzone_id,
            supplyzone_table.supplyzone_type,
            node.presszone_id,
            presszone_table.presszone_type,
            presszone_table.presszone_head,
            node.dma_id,
            dma_table.macrodma_id,
            dma_table.dma_type,
            node.dqa_id,
            dqa_table.macrodqa_id,
            dqa_table.dqa_type,
            node.omzone_id,
            omzone_table.macroomzone_id,
            omzone_table.omzone_type,
            node.minsector_id,
            node.pavcat_id,
            node.soilcat_id,
            node.function_type,
            node.category_type,
            node.location_type,
            node.fluid_type,
            node.staticpressure,
            node.annotation,
            node.observ,
            node.comment,
            node.descript,
            concat(cat_feature.link_path, node.link) AS link,
            node.num_value,
            node.district_id,
            node.streetaxis_id,
            node.postcode,
            node.postnumber,
            node.postcomplement,
            node.streetaxis2_id,
            node.postnumber2,
            node.postcomplement2,
            mu.region_id,
            mu.province_id,
            node.workcat_id,
            node.workcat_id_end,
            node.workcat_id_plan,
            node.builtdate,
            node.enddate,
            node.ownercat_id,
            node.accessibility,
            node.om_state,
            node.conserv_state,
            node.access_type,
            node.placement_type,
                CASE
                    WHEN node.brand_id IS NULL THEN cat_node.brand_id
                    ELSE node.brand_id
                END AS brand_id,
                CASE
                    WHEN node.model_id IS NULL THEN cat_node.model_id
                    ELSE node.model_id
                END AS model_id,
            node.serial_number,
            node.asset_id,
            node.adate,
            node.adescript,
            node.verified,
            node.datasource,
            node.hemisphere,
            cat_node.label,
            node.label_x,
            node.label_y,
            node.label_rotation,
            node.rotation,
            node.label_quadrant,
            cat_node.svg,
            node.inventory,
            node.publish,
            vst.is_operative,
            node.is_scadamap,
                CASE
                    WHEN node.sector_id > 0 AND vst.is_operative = true AND node.epa_type::text <> 'UNDEFINED'::text THEN node.epa_type::text
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
            node.lock_level,
            node.expl_visibility,
            ( SELECT st_x(node.the_geom) AS st_x) AS xcoord,
            ( SELECT st_y(node.the_geom) AS st_y) AS ycoord,
            ( SELECT st_y(st_transform(node.the_geom, 4326)) AS st_y) AS lat,
            ( SELECT st_x(st_transform(node.the_geom, 4326)) AS st_x) AS long,
            m.closed AS closed_valve,
            m.broken AS broken_valve,
            date_trunc('second'::text, node.created_at) AS created_at,
            node.created_by,
            date_trunc('second'::text, node.updated_at) AS updated_at,
            node.updated_by,
            node.the_geom,
            node_selector.p_state,
            node.uuid,
            node.uncertain
           FROM node_selector
             JOIN node ON node.node_id = node_selector.node_id
             JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
             JOIN cat_feature ON cat_feature.id::text = cat_node.node_type::text
             JOIN value_state_type vst ON vst.id = node.state_type
             JOIN exploitation ON node.expl_id = exploitation.expl_id
             JOIN ext_municipality mu ON node.muni_id = mu.muni_id
             JOIN sector_table ON sector_table.sector_id = node.sector_id
             LEFT JOIN presszone_table ON presszone_table.presszone_id = node.presszone_id
             LEFT JOIN dma_table ON dma_table.dma_id = node.dma_id
             LEFT JOIN dqa_table ON dqa_table.dqa_id = node.dqa_id
             LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = node.supplyzone_id
             LEFT JOIN omzone_table ON omzone_table.omzone_id = node.omzone_id
             LEFT JOIN node_add ON node_add.node_id = node.node_id
             LEFT JOIN man_valve m ON m.node_id = node.node_id
        )
 SELECT node_id,
    code,
    sys_code,
    top_elev,
    custom_top_elev,
    sys_top_elev,
    depth,
    node_type,
    sys_type,
    nodecat_id,
    cat_matcat_id,
    cat_pnom,
    cat_dnom,
    cat_dint,
    epa_type,
    state,
    state_type,
    arc_id,
    parent_id,
    expl_id,
    macroexpl_id,
    muni_id,
    sector_id,
    macrosector_id,
    sector_type,
    supplyzone_id,
    supplyzone_type,
    presszone_id,
    presszone_type,
    presszone_head,
    dma_id,
    macrodma_id,
    dma_type,
    dqa_id,
    macrodqa_id,
    dqa_type,
    omzone_id,
    macroomzone_id,
    omzone_type,
    minsector_id,
    pavcat_id,
    soilcat_id,
    function_type,
    category_type,
    location_type,
    fluid_type,
    staticpressure,
    annotation,
    observ,
    comment,
    descript,
    link,
    num_value,
    district_id,
    streetaxis_id,
    postcode,
    postnumber,
    postcomplement,
    streetaxis2_id,
    postnumber2,
    postcomplement2,
    region_id,
    province_id,
    workcat_id,
    workcat_id_end,
    workcat_id_plan,
    builtdate,
    enddate,
    ownercat_id,
    accessibility,
    om_state,
    conserv_state,
    access_type,
    placement_type,
    brand_id,
    model_id,
    serial_number,
    asset_id,
    adate,
    adescript,
    verified,
    datasource,
    hemisphere,
    label,
    label_x,
    label_y,
    label_rotation,
    rotation,
    label_quadrant,
    svg,
    inventory,
    publish,
    is_operative,
    is_scadamap,
    inp_type,
    demand_max,
    demand_min,
    demand_avg,
    press_max,
    press_min,
    press_avg,
    head_max,
    head_min,
    head_avg,
    quality_max,
    quality_min,
    quality_avg,
    result_id,
    sector_style,
    dma_style,
    presszone_style,
    dqa_style,
    supplyzone_style,
    lock_level,
    expl_visibility,
    xcoord,
    ycoord,
    lat,
    long,
    closed_valve,
    broken_valve,
    created_at,
    created_by,
    updated_at,
    updated_by,
    the_geom,
    p_state,
    uuid,
    uncertain
   FROM node_selected n;


-- ve_connec source

CREATE OR REPLACE VIEW ve_connec
AS WITH sel_state AS (
         SELECT selector_state.state_id
           FROM selector_state
          WHERE selector_state.cur_user = CURRENT_USER
        ), sel_sector AS (
         SELECT selector_sector.sector_id
           FROM selector_sector
          WHERE selector_sector.cur_user = CURRENT_USER
        ), sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        ), sel_muni AS (
         SELECT selector_municipality.muni_id
           FROM selector_municipality
          WHERE selector_municipality.cur_user = CURRENT_USER
        ), sel_ps AS (
         SELECT selector_psector.psector_id
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), dma_table AS (
         SELECT dma.dma_id,
            dma.macrodma_id,
            dma.stylesheet,
            t.id::character varying(16) AS dma_type
           FROM dma
             LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
        ), presszone_table AS (
         SELECT presszone.presszone_id,
            presszone.head AS presszone_head,
            presszone.stylesheet,
            t.id::character varying(16) AS presszone_type
           FROM presszone
             LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
        ), dqa_table AS (
         SELECT dqa.dqa_id,
            dqa.stylesheet,
            t.id::character varying(16) AS dqa_type,
            dqa.macrodqa_id
           FROM dqa
             LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type::text AND t.typevalue::text = 'dqa_type'::text
        ), supplyzone_table AS (
         SELECT supplyzone.supplyzone_id,
            supplyzone.stylesheet,
            t.id::character varying(16) AS supplyzone_type
           FROM supplyzone
             LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type::text AND t.typevalue::text = 'supplyzone_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            t.id::character varying(16) AS omzone_type,
            omzone.macroomzone_id
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), inp_network_mode AS (
         SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        ), link_planned AS (
         SELECT l.link_id,
            l.feature_id,
            l.feature_type,
            l.exit_id,
            l.exit_type,
            l.expl_id,
            exploitation.macroexpl_id,
            l.sector_id,
            sector_table.sector_type,
            sector_table.macrosector_id,
            l.dma_id,
            dma_table.dma_type,
            l.omzone_id,
            omzone_table.omzone_type,
            dma_table.macrodma_id,
            l.presszone_id,
            presszone_table.presszone_type,
            presszone_table.presszone_head,
            l.dqa_id,
            dqa_table.dqa_type,
            dqa_table.macrodqa_id,
            l.supplyzone_id,
            supplyzone_table.supplyzone_type,
            l.fluid_type,
            l.minsector_id,
            l.staticpressure1 AS staticpressure
           FROM link l
             JOIN exploitation USING (expl_id)
             JOIN sector_table ON sector_table.sector_id = l.sector_id
             LEFT JOIN presszone_table ON presszone_table.presszone_id = l.presszone_id
             LEFT JOIN dma_table ON dma_table.dma_id = l.dma_id
             LEFT JOIN dqa_table ON dqa_table.dqa_id = l.dqa_id
             LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = l.supplyzone_id
             LEFT JOIN omzone_table ON omzone_table.omzone_id = l.omzone_id
          WHERE l.state = 2
        ), connec_psector AS (
         SELECT DISTINCT ON (pp.connec_id) pp.connec_id,
            pp.state AS p_state,
            pp.psector_id,
            pp.arc_id,
            pp.link_id
           FROM plan_psector_x_connec pp
          WHERE (EXISTS ( SELECT 1
                   FROM sel_ps s
                  WHERE s.psector_id = pp.psector_id))
          ORDER BY pp.connec_id, pp.state DESC, pp.link_id DESC NULLS LAST
        ), connec_selector AS (
         SELECT c_1.connec_id,
            c_1.arc_id,
            NULL::integer AS link_id,
            NULL::smallint AS p_state
           FROM connec c_1
          WHERE (EXISTS ( SELECT 1
                   FROM sel_state s
                  WHERE s.state_id = c_1.state)) AND (EXISTS ( SELECT 1
                   FROM sel_sector s
                  WHERE s.sector_id = c_1.sector_id)) AND (EXISTS ( SELECT 1
                   FROM sel_expl s
                  WHERE s.expl_id = ANY (array_append(c_1.expl_visibility::integer[], c_1.expl_id)))) AND (EXISTS ( SELECT 1
                   FROM sel_muni s
                  WHERE s.muni_id = c_1.muni_id)) AND NOT (EXISTS ( SELECT 1
                   FROM connec_psector cp
                  WHERE cp.connec_id = c_1.connec_id))
        UNION ALL
         SELECT cp.connec_id,
            cp.arc_id,
            cp.link_id,
            cp.p_state
           FROM connec_psector cp
          WHERE (EXISTS ( SELECT 1
                   FROM sel_state s
                  WHERE s.state_id = cp.p_state))
        ), connec_selected AS (
         SELECT connec.connec_id,
            connec.code,
            connec.sys_code,
            connec.top_elev,
            connec.depth,
            cat_connec.connec_type,
            cat_feature.feature_class AS sys_type,
            connec.conneccat_id,
            cat_connec.matcat_id AS cat_matcat_id,
            cat_connec.pnom AS cat_pnom,
            cat_connec.dnom AS cat_dnom,
            cat_connec.dint AS cat_dint,
            connec.customer_code,
            connec.connec_length,
            connec.epa_type,
            connec.state,
            connec.state_type,
            connec_selector.arc_id,
            connec.expl_id,
            exploitation.macroexpl_id,
            connec.muni_id,
                CASE
                    WHEN link_planned.sector_id IS NULL THEN connec.sector_id
                    ELSE link_planned.sector_id
                END AS sector_id,
                CASE
                    WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
                    ELSE link_planned.macrosector_id
                END AS macrosector_id,
                CASE
                    WHEN link_planned.sector_type IS NULL THEN sector_table.sector_type
                    ELSE link_planned.sector_type
                END AS sector_type,
                CASE
                    WHEN link_planned.supplyzone_id IS NULL THEN supplyzone_table.supplyzone_id
                    ELSE link_planned.supplyzone_id
                END AS supplyzone_id,
                CASE
                    WHEN link_planned.supplyzone_type IS NULL THEN supplyzone_table.supplyzone_type
                    ELSE link_planned.supplyzone_type
                END AS supplyzone_type,
                CASE
                    WHEN link_planned.presszone_id IS NULL THEN presszone_table.presszone_id
                    ELSE link_planned.presszone_id
                END AS presszone_id,
                CASE
                    WHEN link_planned.presszone_type IS NULL THEN presszone_table.presszone_type
                    ELSE link_planned.presszone_type
                END AS presszone_type,
                CASE
                    WHEN link_planned.presszone_head IS NULL THEN presszone_table.presszone_head
                    ELSE link_planned.presszone_head
                END AS presszone_head,
                CASE
                    WHEN link_planned.dma_id IS NULL THEN dma_table.dma_id
                    ELSE link_planned.dma_id
                END AS dma_id,
                CASE
                    WHEN link_planned.macrodma_id IS NULL THEN dma_table.macrodma_id
                    ELSE link_planned.macrodma_id
                END AS macrodma_id,
                CASE
                    WHEN link_planned.dma_type IS NULL THEN dma_table.dma_type
                    ELSE link_planned.dma_type::character varying
                END AS dma_type,
                CASE
                    WHEN link_planned.dqa_id IS NULL THEN dqa_table.dqa_id
                    ELSE link_planned.dqa_id
                END AS dqa_id,
                CASE
                    WHEN link_planned.macrodqa_id IS NULL THEN dqa_table.macrodqa_id
                    ELSE link_planned.macrodqa_id
                END AS macrodqa_id,
                CASE
                    WHEN link_planned.dqa_type IS NULL THEN dqa_table.dqa_type
                    ELSE link_planned.dqa_type
                END AS dqa_type,
                CASE
                    WHEN link_planned.omzone_id IS NULL THEN omzone_table.omzone_id
                    ELSE link_planned.omzone_id
                END AS omzone_id,
                CASE
                    WHEN link_planned.omzone_type IS NULL THEN omzone_table.omzone_type
                    ELSE link_planned.omzone_type
                END AS omzone_type,
            connec.crmzone_id,
            crmzone.macrocrmzone_id,
            crmzone.name AS crmzone_name,
                CASE
                    WHEN link_planned.minsector_id IS NULL THEN connec.minsector_id
                    ELSE link_planned.minsector_id
                END AS minsector_id,
            connec.soilcat_id,
            connec.function_type,
            connec.category_type,
            connec.location_type,
                CASE
                    WHEN link_planned.fluid_type IS NULL THEN connec.fluid_type
                    ELSE link_planned.fluid_type
                END AS fluid_type,
            connec.n_hydrometer,
            connec.n_inhabitants,
                CASE
                    WHEN link_planned.staticpressure IS NULL THEN connec.staticpressure
                    ELSE link_planned.staticpressure
                END AS staticpressure,
            connec.descript,
            connec.annotation,
            connec.observ,
            connec.comment,
            concat(cat_feature.link_path, connec.link) AS link,
            connec.num_value,
            connec.district_id,
            connec.postcode,
            connec.streetaxis_id,
            connec.postnumber,
            connec.postcomplement,
            connec.streetaxis2_id,
            connec.postnumber2,
            connec.postcomplement2,
            mu.region_id,
            mu.province_id,
            connec.block_code,
            connec.plot_code,
            connec.workcat_id,
            connec.workcat_id_end,
            connec.workcat_id_plan,
            connec.builtdate,
            connec.enddate,
            connec.ownercat_id,
                CASE
                    WHEN link_planned.link_id IS NULL THEN connec.pjoint_id
                    ELSE link_planned.exit_id
                END AS pjoint_id,
                CASE
                    WHEN link_planned.link_id IS NULL THEN connec.pjoint_type
                    ELSE link_planned.exit_type
                END AS pjoint_type,
            connec.om_state,
            connec.conserv_state,
            connec.accessibility,
            connec.access_type,
            connec.placement_type,
            connec.priority,
                CASE
                    WHEN connec.brand_id IS NULL THEN cat_connec.brand_id
                    ELSE connec.brand_id
                END AS brand_id,
                CASE
                    WHEN connec.model_id IS NULL THEN cat_connec.model_id
                    ELSE connec.model_id
                END AS model_id,
            connec.serial_number,
            connec.asset_id,
            connec.adate,
            connec.adescript,
            connec.verified,
            connec.datasource,
            cat_connec.label,
            connec.label_x,
            connec.label_y,
            connec.label_rotation,
            connec.rotation,
            connec.label_quadrant,
            cat_connec.svg,
            connec.inventory,
            connec.publish,
            vst.is_operative,
                CASE
                    WHEN connec.sector_id > 0 AND vst.is_operative = true AND connec.epa_type = 'JUNCTION'::text AND inp_network_mode.value = '4'::text THEN connec.epa_type::character varying::text
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
            connec.lock_level,
            connec.expl_visibility,
            ( SELECT st_x(connec.the_geom) AS st_x) AS xcoord,
            ( SELECT st_y(connec.the_geom) AS st_y) AS ycoord,
            ( SELECT st_y(st_transform(connec.the_geom, 4326)) AS st_y) AS lat,
            ( SELECT st_x(st_transform(connec.the_geom, 4326)) AS st_x) AS long,
            date_trunc('second'::text, connec.created_at) AS created_at,
            connec.created_by,
            date_trunc('second'::text, connec.updated_at) AS updated_at,
            connec.updated_by,
            connec.the_geom,
            connec_selector.p_state,
            connec.uuid,
            connec.uncertain
           FROM connec_selector
             JOIN connec ON connec.connec_id = connec_selector.connec_id
             JOIN cat_connec ON cat_connec.id::text = connec.conneccat_id::text
             JOIN cat_feature ON cat_feature.id::text = cat_connec.connec_type::text
             JOIN exploitation ON connec.expl_id = exploitation.expl_id
             JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
             JOIN sector_table ON sector_table.sector_id = connec.sector_id
             LEFT JOIN presszone_table ON presszone_table.presszone_id = connec.presszone_id
             LEFT JOIN dma_table ON dma_table.dma_id = connec.dma_id
             LEFT JOIN dqa_table ON dqa_table.dqa_id = connec.dqa_id
             LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = connec.supplyzone_id
             LEFT JOIN omzone_table ON omzone_table.omzone_id = connec.omzone_id
             LEFT JOIN crmzone ON crmzone.id::text = connec.crmzone_id::text
             LEFT JOIN link_planned USING (link_id)
             LEFT JOIN connec_add ON connec_add.connec_id = connec.connec_id
             LEFT JOIN value_state_type vst ON vst.id = connec.state_type
             LEFT JOIN inp_network_mode ON true
        )
 SELECT connec_id,
    code,
    sys_code,
    top_elev,
    depth,
    connec_type,
    sys_type,
    conneccat_id,
    cat_matcat_id,
    cat_pnom,
    cat_dnom,
    cat_dint,
    customer_code,
    connec_length,
    epa_type,
    state,
    state_type,
    arc_id,
    expl_id,
    macroexpl_id,
    muni_id,
    sector_id,
    macrosector_id,
    sector_type,
    supplyzone_id,
    supplyzone_type,
    presszone_id,
    presszone_type,
    presszone_head,
    dma_id,
    macrodma_id,
    dma_type,
    dqa_id,
    macrodqa_id,
    dqa_type,
    omzone_id,
    omzone_type,
    crmzone_id,
    macrocrmzone_id,
    crmzone_name,
    minsector_id,
    soilcat_id,
    function_type,
    category_type,
    location_type,
    fluid_type,
    n_hydrometer,
    n_inhabitants,
    staticpressure,
    descript,
    annotation,
    observ,
    comment,
    link,
    num_value,
    district_id,
    postcode,
    streetaxis_id,
    postnumber,
    postcomplement,
    streetaxis2_id,
    postnumber2,
    postcomplement2,
    region_id,
    province_id,
    block_code,
    plot_code,
    workcat_id,
    workcat_id_end,
    workcat_id_plan,
    builtdate,
    enddate,
    ownercat_id,
    pjoint_id,
    pjoint_type,
    om_state,
    conserv_state,
    accessibility,
    access_type,
    placement_type,
    priority,
    brand_id,
    model_id,
    serial_number,
    asset_id,
    adate,
    adescript,
    verified,
    datasource,
    label,
    label_x,
    label_y,
    label_rotation,
    rotation,
    label_quadrant,
    svg,
    inventory,
    publish,
    is_operative,
    inp_type,
    demand_base,
    demand_max,
    demand_min,
    demand_avg,
    press_max,
    press_min,
    press_avg,
    quality_max,
    quality_min,
    quality_avg,
    flow_max,
    flow_min,
    flow_avg,
    vel_max,
    vel_min,
    vel_avg,
    result_id,
    sector_style,
    dma_style,
    presszone_style,
    dqa_style,
    supplyzone_style,
    lock_level,
    expl_visibility,
    xcoord,
    ycoord,
    lat,
    long,
    created_at,
    created_by,
    updated_at,
    updated_by,
    the_geom,
    p_state,
    uuid,
    uncertain
   FROM connec_selected c;
