/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_frvalve", "column":"status", "dataType":"varchar(16)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"inp_dscenario_frvalve", "column":"status", "dataType":"varchar(18)"}}$$);

DROP VIEW IF EXISTS ve_inp_dscenario_frvalve;


DROP VIEW IF EXISTS ve_inp_frvalve;
CREATE OR REPLACE VIEW ve_inp_frvalve
AS SELECT f.element_id,
    f.node_id,
    f.to_arc,
    f.flwreg_length,
    v.valve_type,
    v.custom_dint,
    v.setting,
    v.curve_id,
    v.minorloss,
    v.add_settings,
    v.init_quality,
    v.status,
    f.the_geom
   FROM ve_man_frelem f
     JOIN inp_frvalve v ON f.element_id = v.element_id;

DROP VIEW IF EXISTS ve_epa_frvalve;
CREATE OR REPLACE VIEW ve_epa_frvalve
AS SELECT v.element_id,
    man_frelem.node_id,
    man_frelem.to_arc,
    v.valve_type,
    v.custom_dint,
    v.setting,
    v.curve_id,
    v.minorloss,
    v.add_settings,
    v.init_quality,
    v.status,
    r.flow_max,
    r.flow_min,
    r.flow_avg,
    r.vel_max,
    r.vel_min,
    r.vel_avg,
    r.headloss_max,
    r.headloss_min,
    r.setting_max,
    r.setting_min,
    r.reaction_max,
    r.reaction_min,
    r.ffactor_max,
    r.ffactor_min
   FROM inp_frvalve v
     LEFT JOIN man_frelem USING (element_id)
     LEFT JOIN v_rpt_arc_stats r ON r.arc_id::text = man_frelem.element_id::text;

CREATE OR REPLACE VIEW ve_inp_dscenario_frvalve
AS SELECT s.dscenario_id,
    v.element_id,
    n.node_id,
    v.valve_type,
    v.custom_dint,
    v.setting,
    v.curve_id,
    v.minorloss,
    v.add_settings,
    v.init_quality,
    n.the_geom
   FROM selector_inp_dscenario s,
    inp_dscenario_frvalve v
     JOIN ve_inp_frvalve n ON n.element_id = v.element_id
  WHERE s.dscenario_id = v.dscenario_id AND s.cur_user = CURRENT_USER::text;


-- to add uuid columns
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
            node.uuid
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
    uuid
   FROM node_selected n;


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
            arc.uuid
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
    uuid
   FROM arc_selected;


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
         SELECT DISTINCT ON (pp.connec_id, pp.state) pp.connec_id,
            pp.state AS p_state,
            pp.psector_id,
            pp.arc_id,
            pp.link_id
           FROM plan_psector_x_connec pp
          WHERE (EXISTS ( SELECT 1
                   FROM sel_ps s
                  WHERE s.psector_id = pp.psector_id))
          ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
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
            connec.uuid
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
    uuid
   FROM connec_selected c;


CREATE OR REPLACE VIEW ve_link
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
        ), link_psector AS (
         SELECT DISTINCT ON (pp.connec_id, pp.state) 'CONNEC'::text AS feature_type,
            pp.connec_id AS feature_id,
            pp.state AS p_state,
            pp.psector_id,
            pp.link_id
           FROM plan_psector_x_connec pp
          WHERE (EXISTS ( SELECT 1
                   FROM sel_ps s
                  WHERE s.psector_id = pp.psector_id))
          ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
        ), link_selector AS (
         SELECT l_1.link_id,
            NULL::smallint AS p_state
           FROM link l_1
          WHERE (EXISTS ( SELECT 1
                   FROM sel_state s
                  WHERE s.state_id = l_1.state)) AND (EXISTS ( SELECT 1
                   FROM sel_sector s
                  WHERE s.sector_id = l_1.sector_id)) AND (EXISTS ( SELECT 1
                   FROM sel_expl s
                  WHERE s.expl_id = ANY (array_append(l_1.expl_visibility::integer[], l_1.expl_id)))) AND (EXISTS ( SELECT 1
                   FROM sel_muni s
                  WHERE s.muni_id = l_1.muni_id)) AND NOT (EXISTS ( SELECT 1
                   FROM link_psector lp
                  WHERE lp.link_id = l_1.link_id))
        UNION ALL
         SELECT lp.link_id,
            lp.p_state
           FROM link_psector lp
          WHERE (EXISTS ( SELECT 1
                   FROM sel_state s
                  WHERE s.state_id = lp.p_state))
        ), link_selected AS (
         SELECT l_1.link_id,
            l_1.code,
            l_1.sys_code,
            l_1.top_elev1,
            l_1.depth1,
                CASE
                    WHEN l_1.top_elev1 IS NULL OR l_1.depth1 IS NULL THEN NULL::double precision
                    ELSE l_1.top_elev1 - l_1.depth1::double precision
                END AS elevation1,
            l_1.exit_id,
            l_1.exit_type,
            l_1.top_elev2,
            l_1.depth2,
                CASE
                    WHEN l_1.top_elev2 IS NULL OR l_1.depth2 IS NULL THEN NULL::double precision
                    ELSE l_1.top_elev2 - l_1.depth2::double precision
                END AS elevation2,
            l_1.feature_type,
            l_1.feature_id,
            cat_link.link_type,
            cat_feature.feature_class AS sys_type,
            l_1.linkcat_id,
            l_1.state,
            l_1.state_type,
            l_1.expl_id,
            exploitation.macroexpl_id,
            l_1.muni_id,
            l_1.sector_id,
            sector_table.macrosector_id,
            sector_table.sector_type,
            l_1.supplyzone_id,
            supplyzone_table.supplyzone_type,
            l_1.presszone_id,
            presszone_table.presszone_type,
            presszone_table.presszone_head,
            l_1.dma_id,
            dma_table.macrodma_id,
            dma_table.dma_type,
            l_1.dqa_id,
            dqa_table.macrodqa_id,
            dqa_table.dqa_type,
            l_1.omzone_id,
            omzone_table.macroomzone_id,
            omzone_table.omzone_type,
            l_1.minsector_id,
            l_1.location_type,
            l_1.fluid_type,
            l_1.custom_length,
            st_length(l_1.the_geom)::numeric(12,3) AS gis_length,
            l_1.staticpressure1,
            l_1.staticpressure2,
            l_1.annotation,
            l_1.observ,
            l_1.comment,
            l_1.descript,
            l_1.link,
            l_1.num_value,
            l_1.workcat_id,
            l_1.workcat_id_end,
            l_1.builtdate,
            l_1.enddate,
            l_1.brand_id,
            l_1.model_id,
            l_1.verified,
            l_1.uncertain,
            l_1.userdefined_geom,
            l_1.datasource,
            l_1.is_operative,
                CASE
                    WHEN l_1.sector_id > 0 AND l_1.is_operative = true AND c.epa_type = 'JUNCTION'::text AND inp_network_mode.value = '4'::text THEN c.epa_type
                    ELSE NULL::text
                END AS inp_type,
            l_1.lock_level,
            l_1.expl_visibility,
            l_1.created_at,
            l_1.created_by,
            l_1.updated_at,
            l_1.updated_by,
            l_1.the_geom,
            link_selector.p_state,
            l_1.uuid
           FROM link_selector
             JOIN link l_1 ON l_1.link_id = link_selector.link_id
             LEFT JOIN connec c ON c.connec_id = l_1.feature_id
             JOIN sector_table ON sector_table.sector_id = l_1.sector_id
             JOIN cat_link ON cat_link.id::text = l_1.linkcat_id::text
             JOIN cat_feature ON cat_feature.id::text = cat_link.link_type::text
             JOIN exploitation ON l_1.expl_id = exploitation.expl_id
             LEFT JOIN presszone_table ON presszone_table.presszone_id = l_1.presszone_id
             LEFT JOIN dma_table ON dma_table.dma_id = l_1.dma_id
             LEFT JOIN dqa_table ON dqa_table.dqa_id = l_1.dqa_id
             LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = l_1.supplyzone_id
             LEFT JOIN omzone_table ON omzone_table.omzone_id = l_1.omzone_id
             LEFT JOIN inp_network_mode ON true
        )
 SELECT link_id,
    code,
    sys_code,
    top_elev1,
    depth1,
    elevation1,
    exit_id,
    exit_type,
    top_elev2,
    depth2,
    elevation2,
    feature_type,
    feature_id,
    link_type,
    sys_type,
    linkcat_id,
    state,
    state_type,
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
    location_type,
    fluid_type,
    custom_length,
    gis_length,
    staticpressure1,
    staticpressure2,
    annotation,
    observ,
    comment,
    descript,
    link,
    num_value,
    workcat_id,
    workcat_id_end,
    builtdate,
    enddate,
    brand_id,
    model_id,
    verified,
    uncertain,
    userdefined_geom,
    datasource,
    is_operative,
    inp_type,
    lock_level,
    expl_visibility,
    created_at,
    created_by,
    updated_at,
    updated_by,
    the_geom,
    p_state,
    uuid
   FROM link_selected l;


CREATE OR REPLACE VIEW ve_element
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
        ), element_selector AS (
         SELECT e.element_id,
            e.code,
            e.sys_code,
            e.top_elev,
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
            e.uuid
           FROM element e
          WHERE (EXISTS ( SELECT 1
                   FROM sel_sector s
                  WHERE s.sector_id = e.sector_id)) AND (EXISTS ( SELECT 1
                   FROM sel_expl e_1
                  WHERE e_1.expl_id = e_1.expl_id)) AND (EXISTS ( SELECT 1
                   FROM sel_state s
                  WHERE s.state_id = e.state)) AND (EXISTS ( SELECT 1
                   FROM sel_muni m
                  WHERE m.muni_id = e.muni_id))
        ), element_selected AS (
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
            e.uuid
           FROM element_selector e
             JOIN cat_element ON e.elementcat_id::text = cat_element.id::text
        )
 SELECT element_id,
    code,
    sys_code,
    top_elev,
    element_type,
    elementcat_id,
    num_elements,
    epa_type,
    state,
    state_type,
    expl_id,
    muni_id,
    sector_id,
    omzone_id,
    function_type,
    category_type,
    location_type,
    observ,
    comment,
    link,
    workcat_id,
    workcat_id_end,
    builtdate,
    enddate,
    ownercat_id,
    brand_id,
    model_id,
    serial_number,
    asset_id,
    verified,
    datasource,
    label_x,
    label_y,
    label_rotation,
    rotation,
    inventory,
    publish,
    trace_featuregeom,
    lock_level,
    expl_visibility,
    created_at,
    created_by,
    updated_at,
    updated_by,
    the_geom,
    uuid
   FROM element_selected; 
  

CREATE OR REPLACE VIEW v_ui_element_x_node
AS SELECT element_x_node.node_id,
    element_x_node.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    element.epa_type,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory,
    element_x_node.node_uuid
   FROM element_x_node
     JOIN element ON element.element_id::text = element_x_node.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;


CREATE OR REPLACE VIEW v_ui_element_x_arc
AS SELECT element_x_arc.arc_id,
    element_x_arc.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    element.epa_type,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory,
    element_x_arc.arc_uuid
   FROM element_x_arc
     JOIN element ON element.element_id::text = element_x_arc.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

CREATE OR REPLACE VIEW v_ui_element_x_connec
AS SELECT element_x_connec.connec_id,
    element_x_connec.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    element.epa_type,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory,
    element_x_connec.connec_uuid
   FROM element_x_connec
     JOIN element ON element.element_id::text = element_x_connec.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;
  
CREATE OR REPLACE VIEW v_ui_element_x_link
AS SELECT element_x_link.link_id,
    element_x_link.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    element.epa_type,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.link,
    element.publish,
    element.inventory,
    element_x_link.link_uuid
   FROM element_x_link
     JOIN element ON element.element_id::text = element_x_link.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

CREATE OR REPLACE VIEW v_ui_om_visit_x_node
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_node.node_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document,
    om_visit.class_id,
    om_visit_x_node.node_uuid
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_node ON om_visit_x_node.visit_id = om_visit.id
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_node.node_id;

CREATE OR REPLACE VIEW v_ui_om_visit_x_arc
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_arc.arc_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document,
    om_visit.class_id,
    om_visit_x_arc.arc_uuid
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_arc ON om_visit_x_arc.visit_id = om_visit.id
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     JOIN arc ON arc.arc_id = om_visit_x_arc.arc_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_arc.arc_id;


CREATE OR REPLACE VIEW v_ui_om_visit_x_connec
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_connec.connec_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document,
    om_visit.class_id,
    om_visit_x_connec.connec_uuid
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_connec ON om_visit_x_connec.visit_id = om_visit.id
     JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN connec ON connec.connec_id = om_visit_x_connec.connec_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_connec.connec_id;

CREATE OR REPLACE VIEW v_ui_om_visit_x_link
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_link.link_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document,
    om_visit.class_id,
    om_visit_x_link.link_uuid
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_link ON om_visit_x_link.visit_id = om_visit.id
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     JOIN link ON link.link_id = om_visit_x_link.link_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_link.link_id;

CREATE OR REPLACE VIEW v_ui_doc_x_node
AS SELECT doc_x_node.doc_id,
    doc_x_node.node_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_node.node_uuid
   FROM doc_x_node
     JOIN doc ON doc.id::text = doc_x_node.doc_id::text;

CREATE OR REPLACE VIEW v_ui_doc_x_arc
AS SELECT doc_x_arc.doc_id,
    doc_x_arc.arc_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_arc.arc_uuid
   FROM doc_x_arc
     JOIN doc ON doc.id::text = doc_x_arc.doc_id::text;

CREATE OR REPLACE VIEW v_ui_doc_x_connec
AS SELECT doc_x_connec.doc_id,
    doc_x_connec.connec_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_connec.connec_uuid
   FROM doc_x_connec
     JOIN doc ON doc.id::text = doc_x_connec.doc_id::text;

CREATE OR REPLACE VIEW v_ui_doc_x_element
AS SELECT doc_x_element.doc_id,
    doc_x_element.element_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_element.element_uuid
   FROM doc_x_element
     JOIN doc ON doc.id::text = doc_x_element.doc_id::text;

CREATE OR REPLACE VIEW v_ui_doc_x_link
AS SELECT doc_x_link.doc_id,
    doc_x_link.link_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_link.link_uuid
   FROM doc_x_link
     JOIN doc ON doc.id::text = doc_x_link.doc_id::text;

UPDATE sys_table SET alias = 'Inp Raingage' WHERE id = 've_raingage';


UPDATE config_form_fields
	SET "label"='Internal diameter:',tooltip='Internal diameter'
	WHERE formname='ve_inp_dscenario_pipe' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Internal diameter:',tooltip='Internal diameter'
	WHERE formname='cat_arc' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Internal diameter:'
	WHERE formname='cat_node' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Internal diameter:',tooltip='Internal diameter'
	WHERE formname='cat_connec' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Internal diameter:',tooltip='Internal diameter'
	WHERE formname='inp_dscenario_pipe' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Internal diameter:',tooltip='Internal diameter'
	WHERE formname='cat_link' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';

DELETE FROM sys_param_user WHERE id='edit_connec_linkcat_vdefault';

-- Dma type
UPDATE config_form_fields
	SET "label"='Dma type:'
	WHERE formname='ve_dma' AND formtype='form_feature' AND columnname='dma_type' AND tabname='tab_none';

-- plan_netscenario
UPDATE config_form_fields
	SET "label"='Netscenario id:'
	WHERE formname='ve_plan_netscenario_dma' AND formtype='form_feature' AND columnname='netscenario_id' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Netscenario name:'
	WHERE formname='ve_plan_netscenario_dma' AND formtype='form_feature' AND columnname='netscenario_name' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Dma id:'
	WHERE formname='ve_plan_netscenario_dma' AND formtype='form_feature' AND columnname='dma_id' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Pattern id:'
	WHERE formname='ve_plan_netscenario_dma' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Expl id2:'
	WHERE formname='ve_plan_netscenario_dma' AND formtype='form_feature' AND columnname='expl_id2' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Netscenario id:'
	WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='netscenario_id' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Dma id:'
	WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='dma_id' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Pattern id:'
	WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Lastupdate user:'
	WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='lastupdate_user' AND tabname='tab_none';


UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_adaptation' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_air_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_bypass_register' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_check_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_clorinathor' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_control_register' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_curve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_endline' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_expantank' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_filter' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_fl_contr_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_flexunion' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_flowmeter' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_gen_purp_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_green_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_hydrant' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_junction' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_manhole' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_netsamplepoint' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_outfall_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_pr_break_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_pr_reduc_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_pr_susta_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_pressure_meter' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_pump' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_reduction' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_register' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_shutoff_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_source' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_t' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_tank' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_throttle_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_valve_register' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_waterwell' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_x' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_fountain' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_greentap' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_tap' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_vconnec' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_wjoin' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_water_connection' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype,
"label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden,web_layoutorder)
VALUES('inp_dscenario_frvalve', 'form_feature', 'tab_none', 'status', 'lyt_main_1', 9, 'string', 'combo', 'Status:', 'Status', NULL,
false, NULL, true, NULL, NULL, 'SELECT DISTINCT (id) AS id,  idval  AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status_valve''',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;


UPDATE config_toolbox SET inputparams='[
{"label": "Create mapzones for netscenario:", "value": null, "tooltip": "Create mapzone for a selected netscenario", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "netscenario", "widgettype": "combo", "dvQueryText": "select netscenario_id as id, name as idval from plan_netscenario  order by name", "isNullValue": "true", "layoutorder": 1}, 
{"label": "Exploitation:", "value": null, "tooltip": "Choose exploitation to work with", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "exploitation", "widgettype": "combo", "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", "layoutorder": 2}, 
{"label": "Force open nodes: (*)", "value": null, "tooltip": "Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "forceOpen", "widgettype": "linetext", "isMandatory": false, "layoutorder": 3, "placeholder": "1015,2231,3123"}, 
{"label": "Force closed nodes: (*)", "value": null, "tooltip": "Optative node id(s) to temporary close open node(s) to force algorithm to stop there", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "forceClosed", "widgettype": "text", "isMandatory": false, "layoutorder": 4, "placeholder": "1015,2231,3123"}, 
{"label": "Use selected psectors:", "value": null, "tooltip": "If true, use selected psectors. If false ignore selected psectors and only works with on-service network", "datatype": "boolean", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "usePlanPsector", "widgettype": "check", "layoutorder": 5}, 
{"label": "Mapzone constructor method:", "value": null, "comboIds": [0, 1, 2, 3, 4], "datatype": "integer", "comboNames": ["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER", "LINK & PIPE BUFFER"], "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "updateMapZone", "widgettype": "combo", "layoutorder": 6}, 
{"label": "Pipe buffer", "value": null, "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "datatype": "float", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "geomParamUpdate", "widgettype": "text", "isMandatory": false, "layoutorder": 7, "placeholder": "5-30"}]'::json WHERE id=3256;

ALTER TABLE plan_netscenario_dma RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE plan_netscenario_dma ALTER COLUMN updated_at TYPE timestamptz USING updated_at::timestamptz;
ALTER TABLE plan_netscenario_dma RENAME COLUMN lastupdate_user TO updated_by;

ALTER TABLE plan_netscenario_presszone RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE plan_netscenario_presszone ALTER COLUMN updated_at TYPE timestamptz USING updated_at::timestamptz;
ALTER TABLE plan_netscenario_presszone RENAME COLUMN lastupdate_user TO updated_by;

UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'updateField','top_elev'::text) WHERE parameter = 'admin_raster_dem' and value ilike '%elevation%';

UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.7-Bratislava">
 <renderer-v2 symbollevels="0" referencescale="-1" forceraster="0" type="RuleRenderer" enableorderby="0">
  <rules key="{f9bd1dda-e8cb-4456-b498-a3f1312029f9}">
   <rule scalemaxdenom="25000" label="Wtp" key="{d0729bdd-7dcb-4e5d-9962-cd92c35d405e}" filter="&quot;sys_type&quot; = ''WTP''" symbol="0"/>
   <rule scalemaxdenom="25000" label="Waterwell" key="{2ecb80ea-9da6-4533-aad0-7275c5a08550}" filter="&quot;sys_type&quot; = ''WATERWELL''" symbol="1"/>
   <rule scalemaxdenom="25000" label="Source" key="{88ef1cea-1727-4681-9d7e-964bcfee179f}" filter="&quot;sys_type&quot; = ''SOURCE''" symbol="2"/>
   <rule scalemaxdenom="25000" label="Tank" key="{5d885b4a-fd95-42b2-8da9-717face5a272}" filter="&quot;sys_type&quot; = ''TANK''" symbol="3"/>
   <rule scalemaxdenom="10000" label="Expantank" key="{eed06555-2d38-4bfe-b114-13e014b63af1}" filter="&quot;sys_type&quot; = ''EXPANSIONTANK''" symbol="4"/>
   <rule scalemaxdenom="10000" label="Filter" key="{d2138541-5cb8-4896-b97e-494fa6df6d40}" filter="&quot;sys_type&quot; = ''FILTER''" symbol="5"/>
   <rule scalemaxdenom="10000" label="Flexunion" key="{9f0ffeda-84af-4676-9263-119eb6042786}" filter="&quot;sys_type&quot; = ''FLEXUNION''" symbol="6"/>
   <rule scalemaxdenom="10000" label="Hydrant" key="{bfe404fe-23c9-4c26-a91e-bc5e89b7203b}" filter="&quot;sys_type&quot; = ''HYDRANT''" symbol="7"/>
   <rule scalemaxdenom="10000" label="Meter" key="{70f23680-8f8d-4eb8-ad9d-b6c222b1359a}" filter="&quot;sys_type&quot; = ''METER''" symbol="8"/>
   <rule scalemaxdenom="10000" label="Netelement" key="{086f2a29-0a69-4a25-9b96-9f5d9f2955c1}" filter="&quot;sys_type&quot; = ''NETELEMENT''" symbol="9"/>
   <rule scalemaxdenom="10000" label="Netsamplepoint" key="{c0f1b0c8-34ee-4ec4-a914-97824ad2c467}" filter="&quot;sys_type&quot; = ''NETSAMPLEPOINT''" symbol="10"/>
   <rule scalemaxdenom="10000" label="Pump" key="{01479095-8f9e-40cf-b92b-6e13874561ae}" filter="&quot;sys_type&quot; = ''PUMP''" symbol="11"/>
   <rule scalemaxdenom="10000" label="Register" key="{8e1a0afb-c274-48ae-95a9-9c35583776c7}" filter="&quot;sys_type&quot; = ''REGISTER''" symbol="12"/>
   <rule scalemaxdenom="10000" label="Manhole" key="{118313b2-195c-4998-a2e3-965b368f9482}" filter="&quot;sys_type&quot; = ''MANHOLE''" symbol="13"/>
   <rule scalemaxdenom="10000" label="Reduction" key="{94bc6268-f342-4b79-a7f0-d8ba6498eb62}" filter="&quot;sys_type&quot; = ''REDUCTION''" symbol="14"/>
   <rule scalemaxdenom="5000" label="Junction" key="{4006148d-3986-44fc-b269-0707485e9bd0}" filter="&quot;sys_type&quot; = ''JUNCTION''" symbol="15"/>
   <rule scalemaxdenom="10000" label="Netwjoin" key="{2efa5954-7163-4c85-b608-6e6326bf4b5b}" filter="&quot;sys_type&quot; = ''NETWJOIN''" symbol="16"/>
   <rule scalemaxdenom="10000" label="Valve Open" key="{d6c2b118-3f7e-4809-a8e8-e6857e5a3f87}" filter="&quot;sys_type&quot; = ''VALVE'' and (&quot;closed_valve&quot;  =  false or  &quot;closed_valve&quot; =  NULL )" symbol="17"/>
   <rule scalemaxdenom="10000" label="Valve Closed" key="{82481050-9411-4920-bf5b-aa8cde85e324}" filter="&quot;sys_type&quot; = ''VALVE'' and (&quot;closed_valve&quot;  =  true )" symbol="18"/>
   <rule scalemaxdenom="5000" label="ELSE" key="{efa48ca5-15b2-40e0-ae34-55ea7492a71b}" filter="ELSE" symbol="19"/>
  </rules>
  <symbols>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{2426fdf4-b863-4a31-8d22-75d3b87db206}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="50,48,55,255,rgb:0.19607843137254902,0.18823529411764706,0.21568627450980393,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.36999999999999994" type="double" name="exponent"/>
           <Option value="2" type="double" name="maxSize"/>
           <Option value="25000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{60f8cb73-bd3f-4499-81be-3df8dc0b9276}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="W" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="Normal" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0.20000000000000001,-0.20000000000000001" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="1" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{bc3fd64a-7e37-4600-a277-2a6e0beed2f2}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,127,0,255,rgb:1,0.49803921568627452,0,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,0,rgb:1,1,1,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.36999999999999994" type="double" name="exponent"/>
           <Option value="2" type="double" name="maxSize"/>
           <Option value="25000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{6491853f-3db7-4599-8f47-82ea692a3939}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="W" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0.20000000000000001,-0.20000000000000001" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="10" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{cafe2365-bf84-40bc-b4fd-71716f972139}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="0,100,200,255,rgb:0,0.39215686274509803,0.78431372549019607,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="square" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="3" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="4.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{219fcf31-f2fe-4d0d-9707-a0eb69de422a}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="S" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="2.5" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.0666667*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 4.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.833333*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 4.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="11" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{8dc8a232-f679-482d-b793-ac2b53347478}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,127,0,255,rgb:1,0.49803921568627452,0,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{3afd08f1-43b6-467e-a8ef-4a35b950ef4a}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="P" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="12" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{680b46d0-028b-48eb-abf8-6b72554acb67}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="32,10,129,255,rgb:0.12549019607843137,0.0392156862745098,0.50588235294117645,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{cf489170-55a0-4d90-8676-2128de54ea7c}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="R" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="13" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{a6a44934-0dbe-4f33-abcf-2aa1924e6f07}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="166,206,227,255,rgb:0.65098039215686276,0.80784313725490198,0.8901960784313725,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{3d10fcb3-5875-4796-a630-8f37f10a6db5}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="M" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="14" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{e713d3d0-79b7-4a2e-938b-7b27ae020cb5}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="237,183,25,255,rgb:0.92941176470588238,0.71764705882352942,0.09803921568627451,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,0,rgb:1,1,1,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{99c6600d-cec6-4008-8248-a7379dc5646a}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="R" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="15" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{c3168ec5-08d4-4f23-95b2-b9080a65290a}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="0,242,255,255,rgb:0,0.94901960784313721,1,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="50,48,55,255,rgb:0.19607843137254902,0.18823529411764706,0.21568627450980393,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="1.8" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="1" type="double" name="maxSize"/>
           <Option value="5000" type="double" name="maxValue"/>
           <Option value="2" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="16" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{a1265017-edec-4d00-80fd-b7b30430a661}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="70,151,75,255,rgb:0.27450980392156865,0.59215686274509804,0.29411764705882354,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="3.75" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.75*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="SimpleMarker" pass="0" id="{7bbb273b-2b48-4e46-8049-c6a5b6beb6fe}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="cross" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="5" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="17" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{592e9086-2d83-4d08-9568-51d5431fb897}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="31,120,180,255,rgb:0.12156862745098039,0.47058823529411764,0.70588235294117652,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="angle">
         <Option value="false" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{6544b1be-a893-4047-b925-e492b240f401}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="V" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="angle">
         <Option value="false" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="char">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when node_type IN ( ''AIR_VALVE'' , ''CHECK_VALVE'' , ''PR_REDUC_VALVE'' )then left( &quot;node_type&quot; , 1) else ''V'' end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="18" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{3a816b27-397e-4ff3-84c6-ffe6d22b372d}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="199,28,31,255,rgb:0.7803921568627451,0.10980392156862745,0.12156862745098039,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{23bcf08d-7c4e-47b3-8c8e-8bac2a91a2f8}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="V" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="char">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when node_type IN ( ''AIR_VALVE'' , ''CHECK_VALVE'' , ''PR_REDUC_VALVE'' )then left( &quot;node_type&quot; , 1) else ''V'' end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="19" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{c3168ec5-08d4-4f23-95b2-b9080a65290a}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="121,208,255,255,rgb:0.473685816739147,0.81579308766308078,1,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="50,48,55,255,rgb:0.19607843137254902,0.18823529411764706,0.21568627450980393,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="1.8" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="1" type="double" name="maxSize"/>
           <Option value="5000" type="double" name="maxValue"/>
           <Option value="2" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="2" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{a7d527ec-c92e-4b39-90ad-ef546a13966c}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="35,200,120,255,rgb:0.13725490196078433,0.78431372549019607,0.47058823529411764,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.36999999999999994" type="double" name="exponent"/>
           <Option value="2" type="double" name="maxSize"/>
           <Option value="25000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{dd1def90-d6fa-4b87-9bdc-e4534a97034d}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="S" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0.20000000000000001,-0.20000000000000001" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="3" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{4179f10b-4e31-4983-a9cd-ec5fbc3b6eb7}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="26,115,162,255,rgb:0.10196078431372549,0.45098039215686275,0.63529411764705879,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.37" type="double" name="exponent"/>
           <Option value="2" type="double" name="maxSize"/>
           <Option value="25000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{a448a54c-2934-4e3f-bdbe-e6406ca777af}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="D" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0.20000000000000001,-0.20000000000000001" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="4" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{e58b92e2-1f0d-44eb-9935-334695a38e22}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="25,237,206,255,rgb:0.09803921568627451,0.92941176470588238,0.80784313725490198,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{02d4b74a-f777-457b-9601-4a3ef69b405c}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="E" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="5" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{5c06718c-3f7d-4ce0-9cd6-20a447774d9d}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="251,154,153,255,rgb:0.98431372549019602,0.60392156862745094,0.59999999999999998,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{85d6b24f-f9af-47cf-b64a-dcf9f311b03b}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="F" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="6" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{c76bb1e8-5a31-4354-b5fd-a41a2cb4aac4}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="191,246,61,255,rgb:0.74901960784313726,0.96470588235294119,0.23921568627450981,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{bc070515-6a58-47fc-b850-6fc0deb93cf5}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="F" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="7" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{1984c6a8-1af1-4fb5-ab16-083f08f31657}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="249,53,57,255,rgb:0.97647058823529409,0.20784313725490197,0.22352941176470589,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="square" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="angle">
         <Option value="false" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="4.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{186c2840-36b7-44b7-a198-0f5c96a45f52}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="H" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,-0.00000000000000006" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="angle">
         <Option value="false" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.37), 0)))|| '','' || ''0''" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.37), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="8" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{ab36f7c9-d62b-4b43-8c4f-5e89e62e4a2b}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="133,133,133,255,rgb:0.52156862745098043,0.52156862745098043,0.52156862745098043,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{a21eceef-f8ec-408e-90cc-21515599a898}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="M" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="9" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{a2fe185b-9594-40fa-b75b-44ed3f0d1f45}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="129,10,78,255,rgb:0.50588235294117645,0.0392156862745098,0.30588235294117649,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{994f37d8-bd5b-4699-9434-22b4c78faaa9}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="E" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </symbols>
  <data-defined-properties>
   <Option type="Map">
    <Option value="" type="QString" name="name"/>
    <Option name="properties"/>
    <Option value="collection" type="QString" name="type"/>
   </Option>
  </data-defined-properties>
 </renderer-v2>
 <selection mode="Default">
  <selectionColor invalid="1"/>
  <selectionSymbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{71ca92da-75c9-49ce-a629-80db92f6b424}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,0,0,255,rgb:1,0,0,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </selectionSymbol>
 </selection>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerGeometryType>0</layerGeometryType>
</qgis>
' WHERE layername='ve_node' AND styleconfig_id=101;


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.7-Bratislava">
 <renderer-v2 symbollevels="0" referencescale="-1" forceraster="0" type="categorizedSymbol" attr="state" enableorderby="0">
  <categories>
   <category render="true" value="0" label="OBSOLETE" type="long" uuid="{fafb3932-336b-408a-b613-7564fa603517}" symbol="0"/>
   <category render="true" value="1" label="OPERATIVE" type="string" uuid="{2e0bc629-0440-42a8-bf37-83a5302de991}" symbol="1"/>
   <category render="true" value="2" label="PLANIFIED" type="long" uuid="{a6c3dc9a-d6c8-41f1-b37d-f9bdb0a71f65}" symbol="2"/>
   <category render="true" value="NULL" label="ELSE" type="NULL" uuid="{0f6ce22d-4427-42a8-b477-4879f8b8e4d3}" symbol="3"/>
  </categories>
  <symbols>
   <symbol is_animated="0" force_rhr="0" type="line" clip_to_extent="1" frame_rate="10" name="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleLine" pass="0" id="{7495e564-1f2e-4c4e-adf2-96c2a06cbe10}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="227,26,28,255,rgb:0.8901960784313725,0.10196078431372549,0.10980392156862745,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.5" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when cat_dnom is not null then&#xd;&#xa;-4.862 + 0.977 * ln(&quot;cat_dnom&quot; + 159.243)&#xd;&#xa;else 0.25 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="line" clip_to_extent="1" frame_rate="10" name="1" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleLine" pass="0" id="{b64bb163-e03e-4b0d-843e-76c497204421}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="31,120,180,255,rgb:0.12156862745098039,0.47058823529411764,0.70588235294117652,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.5" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when cat_dnom is not null then&#xd;&#xa;-4.862 + 0.977 * ln(&quot;cat_dnom&quot; + 159.243)&#xd;&#xa;else 0.25 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="line" clip_to_extent="1" frame_rate="10" name="2" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleLine" pass="0" id="{8e6baa60-d3ad-4440-baf0-f5e293ac693f}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="230,186,68,255,rgb:0.90196078431372551,0.72941176470588232,0.26666666666666666,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.5" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when cat_dnom is not null then&#xd;&#xa;-4.862 + 0.977 * ln(&quot;cat_dnom&quot; + 159.243)&#xd;&#xa;else 0.25 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="line" clip_to_extent="1" frame_rate="10" name="3" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleLine" pass="0" id="{c1dd7591-7c13-46c8-b3a8-495843eb24cb}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="121,208,255,255,rgb:0.47450980392156861,0.81568627450980391,1,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.5" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </symbols>
  <source-symbol>
   <symbol is_animated="0" force_rhr="0" type="line" clip_to_extent="1" frame_rate="10" name="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleLine" pass="0" id="{38fef836-dca4-44ce-94cc-d00396fe66f2}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="227,61,39,255,rgb:0.8901960784313725,0.23921568627450981,0.15294117647058825,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.5" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </source-symbol>
  <colorramp type="randomcolors" name="[source]">
   <Option/>
  </colorramp>
  <rotation/>
  <sizescale/>
  <data-defined-properties>
   <Option type="Map">
    <Option value="" type="QString" name="name"/>
    <Option name="properties"/>
    <Option value="collection" type="QString" name="type"/>
   </Option>
  </data-defined-properties>
 </renderer-v2>
 <selection mode="Default">
  <selectionColor invalid="1"/>
  <selectionSymbol>
   <symbol is_animated="0" force_rhr="0" type="line" clip_to_extent="1" frame_rate="10" name="" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleLine" pass="0" id="{f0817fea-ea6c-4aa3-912a-22eceb8fe77a}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.26" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </selectionSymbol>
 </selection>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerGeometryType>1</layerGeometryType>
</qgis>
' WHERE layername='ve_arc' AND styleconfig_id=101;


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.7-Bratislava">
 <renderer-v2 symbollevels="0" referencescale="-1" forceraster="0" type="RuleRenderer" enableorderby="0">
  <rules key="{cd75f41e-3b1d-443c-8148-fbc4436aa9cb}">
   <rule scalemindenom="1" scalemaxdenom="1500" label="Greentap" key="{24b63ac0-a836-4203-bd64-161a0112ee9a}" filter=" &quot;sys_type&quot; = ''GREENTAP''" symbol="0"/>
   <rule scalemindenom="1" scalemaxdenom="1500" label="Wjoin" key="{abcdb374-fe6a-4d04-a466-31fdd93144e8}" filter=" &quot;sys_type&quot; =''WJOIN''" symbol="1"/>
   <rule scalemindenom="1" scalemaxdenom="1500" label="Tap" key="{7dc90f4d-d098-491a-b817-e7ea68fc2fd6}" filter=" &quot;sys_type&quot; =''TAP''" symbol="2"/>
   <rule scalemindenom="1" scalemaxdenom="1500" label="Fountain" key="{39e4856f-0fc3-4498-8d4b-44d2851b421f}" filter=" &quot;sys_type&quot; =''FOUNTAIN''" symbol="3"/>
   <rule scalemindenom="1" scalemaxdenom="1500" label="Wjoin" key="{60014a37-16d8-4086-a5f3-248ffeeeefa3}" filter="ELSE" symbol="4"/>
  </rules>
  <symbols>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{12cc35f6-2de1-4246-b4e0-8a183935eeae}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="201,246,158,255,rgb:0.78823529411764703,0.96470588235294119,0.61960784313725492,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="1.6" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.57" type="double" name="exponent"/>
           <Option value="1" type="double" name="maxSize"/>
           <Option value="1500" type="double" name="maxValue"/>
           <Option value="3.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="2" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="1" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{362f8968-f888-433b-90e4-e5098d869499}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="49,180,227,255,rgb:0.19215686274509805,0.70588235294117652,0.8901960784313725,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="49,180,227,255,rgb:0.19215686274509805,0.70588235294117652,0.8901960784313725,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="angle">
         <Option value="true" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.666667*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 3.5, 2, 0.37), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="SimpleMarker" pass="0" id="{67948e1f-e6bb-4593-b5ad-8bb9fcf49d7d}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,0,0,255,rgb:1,0,0,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="cross" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="3" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="angle">
         <Option value="true" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.37" type="double" name="exponent"/>
           <Option value="2" type="double" name="maxSize"/>
           <Option value="1500" type="double" name="maxValue"/>
           <Option value="3.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="2" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{9be7c088-b096-4952-9c7a-3fe50ee2852a}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="31,120,180,255,rgb:0.12156862745098039,0.47058823529411764,0.70588235294117652,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="square" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.37" type="double" name="exponent"/>
           <Option value="1.5" type="double" name="maxSize"/>
           <Option value="1500" type="double" name="maxValue"/>
           <Option value="3.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="3" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{d8e73060-669b-4565-9660-e859c06a83fd}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="44,67,207,83,rgb:0.17254901960784313,0.2627450980392157,0.81176470588235294,0.32549019607843138" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="triangle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="22,0,148,255,rgb:0.08627450980392157,0,0.58039215686274515,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.37" type="double" name="exponent"/>
           <Option value="2.5" type="double" name="maxSize"/>
           <Option value="1500" type="double" name="maxValue"/>
           <Option value="5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="FontMarker" pass="0" id="{b07449ae-bcc9-48eb-8ebd-ae0ffa344f84}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="F" type="QString" name="chr"/>
      <Option value="22,0,148,255,rgb:0.08627450980392157,0,0.58039215686274515,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0.20000000000000001,0.20000000000000001" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 5, 2.5, 0.37), 0)))|| '','' || tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 5, 2.5, 0.37), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.714286*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 5, 2.5, 0.37), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="4" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{362f8968-f888-433b-90e4-e5098d869499}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="121,208,255,255,rgb:0.47450980392156861,0.81568627450980391,1,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="121,208,255,255,rgb:0.47450980392156861,0.81568627450980391,1,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="angle">
         <Option value="true" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.666667*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 3.5, 2, 0.37), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="SimpleMarker" pass="0" id="{67948e1f-e6bb-4593-b5ad-8bb9fcf49d7d}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,0,0,255,rgb:1,0,0,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="cross" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="3" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="angle">
         <Option value="true" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.37" type="double" name="exponent"/>
           <Option value="2" type="double" name="maxSize"/>
           <Option value="1500" type="double" name="maxValue"/>
           <Option value="3.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </symbols>
  <data-defined-properties>
   <Option type="Map">
    <Option value="" type="QString" name="name"/>
    <Option name="properties"/>
    <Option value="collection" type="QString" name="type"/>
   </Option>
  </data-defined-properties>
 </renderer-v2>
 <selection mode="Default">
  <selectionColor invalid="1"/>
  <selectionSymbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{593cbcfc-245e-4774-ad13-56169b965bf5}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,0,0,255,rgb:1,0,0,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </selectionSymbol>
 </selection>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerGeometryType>0</layerGeometryType>
</qgis>
' WHERE layername='ve_connec' AND styleconfig_id=101;

DROP RULE IF EXISTS presszone_conflict ON presszone;
DROP RULE IF EXISTS presszone_del_uconflict ON presszone;
DROP RULE IF EXISTS presszone_del_undefined ON presszone;
DROP RULE IF EXISTS presszone_undefined ON presszone;

DROP RULE IF EXISTS dma_del_conflict ON dma;
DROP RULE IF EXISTS dma_del_undefined ON dma;

DROP RULE IF EXISTS macrodma_del_undefined ON macrodma;
DROP RULE IF EXISTS macrodma_undefined ON macrodma;

DROP RULE IF EXISTS dqa_conflict ON dqa;
DROP RULE IF EXISTS dqa_del_conflict ON dqa;
DROP RULE IF EXISTS dqa_del_undefined ON dqa;
DROP RULE IF EXISTS dqa_undefined ON dqa;

DROP RULE IF EXISTS macrodqa_del_undefined ON macrodqa;
DROP RULE IF EXISTS macrodqa_undefined ON macrodqa;     

DROP RULE IF EXISTS supplyzone_conflict ON supplyzone;
DROP RULE IF EXISTS supplyzone_del_conflict ON supplyzone;
DROP RULE IF EXISTS supplyzone_del_undefined ON supplyzone;
DROP RULE IF EXISTS supplyzone_undefined ON supplyzone;     

ALTER TABLE inp_dscenario_frvalve DROP CONSTRAINT IF EXISTS inp_dscenario_frvalve_check_status;

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON sector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('sector_id');

CREATE TRIGGER gw_trg_edit_ve_epa_frvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_epa_frvalve FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('frvalve');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_frvalve FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-VALVE');
