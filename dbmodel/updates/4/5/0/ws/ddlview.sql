/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- v_plan_netscenario views

CREATE OR REPLACE VIEW v_plan_netscenario_node AS
WITH plan_netscenario_current AS (
  SELECT value::integer AS netscenario_id
  FROM config_param_user
  WHERE cur_user = CURRENT_USER
    AND parameter = 'plan_netscenario_current'
  LIMIT 1
), sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT
    n.netscenario_id,
    n.node_id,
    n.presszone_id,
    n.staticpressure,
    n.dma_id,
    n.pattern_id,
    n.the_geom,
    nd.nodecat_id,
    cn.node_type,
    nd.epa_type,
    nd.state,
    nd.state_type
FROM plan_netscenario_node n
JOIN plan_netscenario p ON n.netscenario_id = p.netscenario_id
LEFT JOIN node nd USING (node_id)
LEFT JOIN cat_node cn ON nd.nodecat_id::text = cn.id::text
JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = p.expl_id);

CREATE OR REPLACE VIEW v_plan_netscenario_connec
AS WITH plan_netscenario_current AS (
  SELECT value::integer AS netscenario_id
  FROM config_param_user
  WHERE cur_user = CURRENT_USER
    AND parameter = 'plan_netscenario_current'
  LIMIT 1
), sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT n.netscenario_id,
    n.connec_id,
    n.presszone_id,
    n.staticpressure,
    n.dma_id,
    n.pattern_id,
    n.the_geom,
    c.conneccat_id,
    cc.connec_type,
    c.epa_type,
    c.state,
    c.state_type
FROM plan_netscenario_connec n
JOIN plan_netscenario p ON n.netscenario_id = p.netscenario_id
LEFT JOIN connec c USING (connec_id)
LEFT JOIN cat_connec cc ON cc.id::text = c.conneccat_id::text
JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = p.expl_id);

CREATE OR REPLACE VIEW v_plan_netscenario_arc
AS WITH plan_netscenario_current AS (
  SELECT value::integer AS netscenario_id
  FROM config_param_user
  WHERE cur_user = CURRENT_USER
    AND parameter = 'plan_netscenario_current'
  LIMIT 1
), sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT n.netscenario_id,
    n.arc_id,
    n.presszone_id,
    n.dma_id,
    n.the_geom,
    a.arccat_id,
    a.epa_type,
    a.state,
    a.state_type
FROM plan_netscenario_arc n
JOIN plan_netscenario p ON n.netscenario_id = p.netscenario_id
LEFT JOIN arc a USING (arc_id)
JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = p.expl_id);

CREATE OR REPLACE VIEW ve_plan_netscenario_valve
AS WITH plan_netscenario_current AS (
  SELECT value::integer AS netscenario_id
  FROM config_param_user
  WHERE cur_user = CURRENT_USER
    AND parameter = 'plan_netscenario_current'
  LIMIT 1
), sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT v.netscenario_id,
    v.node_id,
    v.closed,
    n.the_geom
FROM plan_netscenario_valve v
JOIN node n USING (node_id)
JOIN plan_netscenario_current pnc ON v.netscenario_id = pnc.netscenario_id
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = n.expl_id);

CREATE OR REPLACE VIEW ve_plan_netscenario_presszone
AS WITH plan_netscenario_current AS (
  SELECT value::integer AS netscenario_id
  FROM config_param_user
  WHERE cur_user = CURRENT_USER
    AND parameter = 'plan_netscenario_current'
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
    n.expl_id2
FROM plan_netscenario_presszone n
JOIN plan_netscenario p USING (netscenario_id)
JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = p.expl_id);

CREATE OR REPLACE VIEW ve_plan_netscenario_dma
AS WITH plan_netscenario_current AS (
  SELECT value::integer AS netscenario_id
  FROM config_param_user
  WHERE cur_user = CURRENT_USER
    AND parameter = 'plan_netscenario_current'
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
    n.expl_id2
FROM plan_netscenario_dma n
JOIN plan_netscenario p USING (netscenario_id)
JOIN plan_netscenario_current pnc ON n.netscenario_id = pnc.netscenario_id
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = p.expl_id);

CREATE OR REPLACE VIEW v_ui_plan_netscenario
AS WITH sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT DISTINCT ON (netscenario_id) netscenario_id,
    name,
    descript,
    netscenario_type,
    parent_id,
    expl_id,
    active,
    log
FROM plan_netscenario
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = expl_id);

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

DROP VIEW IF EXISTS v_om_mincut_arc;
DROP VIEW IF EXISTS v_om_mincut_connec;
DROP VIEW IF EXISTS v_om_mincut_node;
DROP VIEW IF EXISTS v_om_mincut_initpoint;
CREATE OR REPLACE VIEW v_om_mincut_arc AS
WITH sel_mincut AS (
	SELECT result_id, result_type
	FROM selector_mincut_result
	WHERE cur_user = CURRENT_USER
)
SELECT oma.id,
    oma.result_id,
    om.mincut_class,
    om.work_order,
    oma.arc_id,
    sm.result_type,
    oma.the_geom
FROM om_mincut_arc oma
JOIN om_mincut om ON oma.result_id = om.id
JOIN sel_mincut sm ON sm.result_id = oma.result_id
ORDER BY oma.arc_id;

CREATE OR REPLACE VIEW v_om_mincut_connec
AS WITH sel_mincut AS (
	SELECT result_id, result_type
	FROM selector_mincut_result
	WHERE cur_user = CURRENT_USER
)
SELECT omc.id,
    omc.result_id,
    om.work_order,
    omc.connec_id,
    omc.customer_code,
    sm.result_type,
    omc.the_geom
FROM om_mincut_connec omc
JOIN om_mincut om ON omc.result_id = om.id
JOIN sel_mincut sm ON sm.result_id = omc.result_id
ORDER BY omc.connec_id;

CREATE OR REPLACE VIEW v_om_mincut_node
AS WITH sel_mincut AS (
	SELECT result_id, result_type
	FROM selector_mincut_result
	WHERE cur_user = CURRENT_USER
)
SELECT omn.id,
    omn.result_id,
    om.work_order,
    omn.node_id,
    omn.node_type,
    sm.result_type,
    omn.the_geom
FROM om_mincut_node omn
JOIN om_mincut om ON omn.result_id = om.id
JOIN sel_mincut sm ON sm.result_id = omn.result_id
ORDER BY omn.node_id;

CREATE OR REPLACE VIEW v_om_mincut_initpoint
AS WITH sel_mincut AS (
	SELECT result_id, result_type
	FROM selector_mincut_result
	WHERE cur_user = CURRENT_USER
)
SELECT om.id,
    om.work_order,
    a.idval AS state,
    b.idval AS class,
    om.mincut_type,
    om.received_date,
    om.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om.macroexpl_id,
    om.muni_id,
    ext_municipality.name AS muni_name,
    om.postcode,
    om.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om.postnumber,
    c.idval AS anl_cause,
    om.anl_tstamp,
    om.anl_user,
    om.anl_descript,
    om.anl_feature_id,
    om.anl_feature_type,
    om.anl_the_geom,
    om.forecast_start,
    om.forecast_end,
    om.assigned_to,
    om.exec_start,
    om.exec_end,
    om.exec_user,
    om.exec_descript,
    om.exec_from_plot,
    om.exec_depth,
    om.exec_appropiate,
    om.notified,
    om.output,
    sm.result_type
FROM om_mincut om
LEFT JOIN om_typevalue a ON a.id::integer = om.mincut_state AND a.typevalue = 'mincut_state'::text
LEFT JOIN om_typevalue b ON b.id::integer = om.mincut_class AND b.typevalue = 'mincut_class'::text
LEFT JOIN om_typevalue c ON c.id::integer = om.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
LEFT JOIN exploitation ON om.expl_id = exploitation.expl_id
LEFT JOIN ext_streetaxis ON om.streetaxis_id::text = ext_streetaxis.id::text
LEFT JOIN macroexploitation ON om.macroexpl_id = macroexploitation.macroexpl_id
LEFT JOIN ext_municipality ON om.muni_id = ext_municipality.muni_id
JOIN sel_mincut sm ON sm.result_id = om.id
WHERE om.id > 0;
