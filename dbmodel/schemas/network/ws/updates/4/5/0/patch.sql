/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TABLE IF NOT EXISTS om_mincut_conflict (
    id uuid DEFAULT gen_random_uuid(),
    mincut_id integer NOT NULL,
    CONSTRAINT om_mincut_conflict_pkey PRIMARY KEY (id, mincut_id),
    CONSTRAINT om_mincut_conflict_mincut_id_fkey FOREIGN KEY (mincut_id) REFERENCES om_mincut(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX IF NOT EXISTS om_mincut_conflict_mincut_id_idx ON om_mincut_conflict (mincut_id);

ALTER TABLE selector_mincut_result ADD COLUMN IF NOT EXISTS result_type text;

ALTER TABLE minsector_mincut_valve ADD COLUMN IF NOT EXISTS closed bool NULL;
ALTER TABLE minsector_mincut_valve ADD COLUMN IF NOT EXISTS broken bool NULL;
ALTER TABLE minsector_mincut_valve ADD COLUMN IF NOT EXISTS unaccess bool NULL;
ALTER TABLE minsector_mincut_valve ADD COLUMN IF NOT EXISTS to_arc int4 NULL;
ALTER TABLE minsector_mincut_valve ADD COLUMN IF NOT EXISTS changestatus bool NULL;


ALTER TABLE om_mincut_valve ADD COLUMN IF NOT EXISTS changestatus bool NULL;

DROP VIEW IF EXISTS v_ui_rpt_cat_result;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"inp_typevalue", "column":"idval", "dataType":"varchar(100)"}}$$);

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


CREATE OR REPLACE VIEW v_ui_rpt_cat_result
AS SELECT DISTINCT ON (rpt_cat_result.result_id) rpt_cat_result.result_id,
    rpt_cat_result.expl_id,
    rpt_cat_result.sector_id,
    rpt_cat_result.dma_id,
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
     LEFT JOIN inp_typevalue t2 ON rpt_cat_result.network_type = t2.id::text
  WHERE t1.typevalue::text = 'inp_result_status'::text AND t2.typevalue::text = 'inp_options_networkmode'::text AND ((s.expl_id = ANY (rpt_cat_result.expl_id)) AND s.cur_user = CURRENT_USER OR rpt_cat_result.expl_id = ARRAY[NULL::integer]);

DELETE FROM sys_message WHERE id = 4026;
DELETE FROM sys_message WHERE id = 4028;


UPDATE config_form_fields SET ismandatory=false
WHERE formname='inp_dscenario_valve' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_none';

UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_inp_dscenario_valve' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_none';

UPDATE config_form_fields SET dv_isnullvalue=true
WHERE formname='inp_dscenario_valve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_none';
UPDATE config_form_fields SET dv_isnullvalue=true
WHERE formname='ve_inp_dscenario_valve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_none';
UPDATE config_form_fields SET dv_isnullvalue=true
WHERE formname='inp_dscenario_virtualvalve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_none';
UPDATE config_form_fields SET dv_isnullvalue=true
WHERE formname='ve_inp_dscenario_virtualvalve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_none';

UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_air_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_check_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_fl_contr_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_gen_purp_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_green_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_outfall_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_pr_break_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_pr_reduc_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_pr_susta_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_shutoff_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';
UPDATE config_form_fields SET ismandatory=false
WHERE formname='ve_node_throttle_valve' AND formtype='form_feature' AND columnname='connection_type' AND tabname='tab_data';

INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) 
VALUES('man_vconnec', 'Additional information for vconnec management', 'role_edit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL) ON CONFLICT DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) 
VALUES('minsector_mincut_valve', 'Table of minsector mincut valves', 'role_edit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL) ON CONFLICT DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) 
VALUES('macrocrmzone', 'macrocrmzone', 'role_edit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) 
VALUES('inp_dscenario_frshortpipe', 'Table to manage scenario for short pipes', 'role_epa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL) ON CONFLICT DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) 
VALUES('element_add', 'element_add', 'role_edit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL) ON CONFLICT DO NOTHING;

INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) 
VALUES('mincut_state', '5', 'Conflict', NULL, NULL);

UPDATE sys_style
SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.8-Bratislava" styleCategories="Symbology|Labeling" labelsEnabled="0">
  <renderer-v2 type="RuleRenderer" forceraster="0" symbollevels="0" enableorderby="0" referencescale="-1">
    <rules key="{fe59b236-7757-4f2f-bf2c-359f48943171}">
      <rule symbol="0" key="{0f18df46-1b7b-40d9-88f3-4fbe45f7bfae}" label="Proposed to close" filter="proposed = true"/>
      <rule symbol="1" key="{22675754-6166-4d98-8a0b-7000f3878811}" label="Proposed unaccess" filter="unaccess = true"/>
      <rule symbol="2" key="{8c72728b-43dc-40b0-86b1-1ceeeba84852}" label="Do not operate" filter="unaccess = false AND proposed = false"/>
    </rules>
    <symbols>
      <symbol is_animated="0" frame_rate="10" type="marker" alpha="1" name="0" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{df6cd293-fef4-4a6e-a813-9711cd93d23a}" class="SimpleMarker" locked="0" pass="0" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="237,55,58,255,rgb:0.92941176470588238,0.21568627450980393,0.22745098039215686,1" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="134,13,13,255,rgb:0.52549019607843139,0.05098039215686274,0.05098039215686274,1" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="3.4" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" frame_rate="10" type="marker" alpha="1" name="1" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{056d6dab-db90-43c2-8c86-e516523aee9a}" class="SimpleMarker" locked="0" pass="0" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="51,160,44,255,rgb:0.20000000000000001,0.62745098039215685,0.17254901960784313,1" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="6,94,0,255,rgb:0.02352941176470588,0.36862745098039218,0,1" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="3.4" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{df6cd293-fef4-4a6e-a813-9711cd93d23a}" class="SimpleMarker" locked="0" pass="0" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="237,55,58,255,rgb:0.92941176470588238,0.21568627450980393,0.22745098039215686,1" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="203,21,21,255,hsv:0,0.89721522850385294,0.79760433356221871,1" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="1.8" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" frame_rate="10" type="marker" alpha="1" name="2" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{adea55e8-1ca0-4555-9fd6-781f98d4f0e8}" class="SimpleMarker" locked="0" pass="0" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="51,160,44,255,rgb:0.20000000000000001,0.62745098039215685,0.17254901960784313,1" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="6,94,0,255,rgb:0.02352941176470588,0.36862745098039218,0,1" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="3.4" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <data-defined-properties>
      <Option type="Map">
        <Option type="QString" value="" name="name"/>
        <Option name="properties"/>
        <Option type="QString" value="collection" name="type"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol is_animated="0" frame_rate="10" type="marker" alpha="1" name="" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{da497ce3-31a2-4557-88ad-ccd4654886bb}" class="SimpleMarker" locked="0" pass="0" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="255,0,0,255,rgb:1,0,0,1" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>'
WHERE layername='v_om_mincut_valve' AND styleconfig_id=101;

UPDATE sys_style
SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.8-Bratislava" styleCategories="Symbology">
  <renderer-v2 type="RuleRenderer" forceraster="0" symbollevels="0" enableorderby="0" referencescale="-1">
    <rules key="{f4a5c688-11cd-4fc8-ae33-96ca34b16fe2}">
      <rule symbol="0" key="{725625c9-855c-4667-b2bf-f2a4cfc21164}" label="Current Nodes" filter="result_type = ''current''"/>
      <rule symbol="1" key="{6e0c12a1-7098-4a03-aca4-cf0caf6b0581}" label="Conflict Nodes" filter="result_type = ''conflict''"/>
      <rule symbol="2" key="{836c8b1c-8562-4d1b-8a2b-7b76d469de9e}" label="Affected Nodes" filter="result_type = ''affected''"/>
    </rules>
    <symbols>
      <symbol is_animated="0" frame_rate="10" type="marker" alpha="1" name="0" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{3aeb7608-c8c4-4e6f-b49d-a95f31155ef7}" class="SimpleMarker" locked="0" pass="0" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="255,157,0,255,hsv:0.10236111111111111,1,1,1" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" frame_rate="10" type="marker" alpha="1" name="1" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{bce694ea-872e-47ec-accf-8f2acbc77ea2}" class="SimpleMarker" locked="0" pass="0" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="0,150,255,255,hsv:0.56841666666666668,1,1,1" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" frame_rate="10" type="marker" alpha="1" name="2" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{59c7e4a1-adf9-4887-9a37-e7ec38604ce0}" class="SimpleMarker" locked="0" pass="0" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="167,60,255,255,hsv:0.75788888888888883,0.76316472114137479,1,1" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <data-defined-properties>
      <Option type="Map">
        <Option type="QString" value="" name="name"/>
        <Option name="properties"/>
        <Option type="QString" value="collection" name="type"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol is_animated="0" frame_rate="10" type="marker" alpha="1" name="" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer id="{30d74c83-2615-4e7a-8695-6b29276c2e0f}" class="SimpleMarker" locked="0" pass="0" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="255,0,0,255,rgb:1,0,0,1" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>'
WHERE layername='v_om_mincut_node' AND styleconfig_id=101;

UPDATE sys_style
SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.5-Bratislava">
  <renderer-v2 symbollevels="0" type="RuleRenderer" referencescale="-1" enableorderby="0" forceraster="0">
    <rules key="{eff80f83-60fb-4774-ac5d-f26af5b90547}">
      <rule symbol="0" key="{0c41817d-1002-4f2c-89b1-422a67fd979a}" filter="result_type = ''current''" label="Current Connecs"/>
      <rule symbol="1" key="{c98cfc4f-ec3c-4ea9-96e6-72842bcfc548}" filter="result_type = ''conflict''" label="Conflict Connecs"/>
      <rule symbol="2" key="{f6126c21-ade7-4083-ba51-c0d44c145510}" filter="result_type = ''affected''" label="Affected Connecs"/>
    </rules>
    <symbols>
      <symbol frame_rate="10" clip_to_extent="1" type="marker" name="0" alpha="1" is_animated="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" class="SimpleMarker" pass="0" id="{f2ab1ad1-f5f2-4938-bca5-a3fb1434a06f}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="255,206,128,255,rgb:1,0.80784313725490198,0.50196078431372548,1"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" clip_to_extent="1" type="marker" name="1" alpha="1" is_animated="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" class="SimpleMarker" pass="0" id="{be69a3c0-b907-4c3d-b405-213d737092a3}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="128,203,255,255,hsv:0.56841666666666668,0.49803921568627452,1,1"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" clip_to_extent="1" type="marker" name="2" alpha="1" is_animated="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" class="SimpleMarker" pass="0" id="{4ac53499-e333-4922-80ed-fb5b89cbb83f}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="198,128,255,255,hsv:0.75788888888888883,0.49803921568627452,1,1"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <data-defined-properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol frame_rate="10" clip_to_extent="1" type="marker" name="" alpha="1" is_animated="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" class="SimpleMarker" pass="0" id="{ace63ba6-3ae3-4d34-b39c-54b6c547bb53}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="255,0,0,255,rgb:1,0,0,1"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
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
'
WHERE layername='v_om_mincut_connec' AND styleconfig_id=101;

UPDATE sys_style
SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.5-Bratislava">
  <renderer-v2 symbollevels="0" type="RuleRenderer" referencescale="-1" enableorderby="0" forceraster="0">
    <rules key="{029b7435-2be8-41c2-8153-d8127f8dc90d}">
      <rule symbol="0" key="{d86f5d33-ec6f-4f16-98bb-096a079727b7}" filter="result_type = ''current''" label="Current Arcs"/>
      <rule symbol="1" key="{d090f851-dbfe-4911-8ca5-deea0b9db9a1}" filter="result_type = ''conflict''" label="Conflict Arcs"/>
      <rule symbol="2" key="{0fc4f7dc-03fe-4596-b9b6-163f45706be0}" filter="result_type = ''affected''" label="Affected Arcs"/>
    </rules>
    <symbols>
      <symbol frame_rate="10" clip_to_extent="1" type="line" name="0" alpha="1" is_animated="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" class="SimpleLine" pass="0" id="{506f2501-7a96-4c51-91bb-420581388655}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="76,38,0,255,rgb:0.29803921568627451,0.14901960784313725,0,1"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="1.7"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" class="SimpleLine" pass="0" id="{a941765c-bae2-4fe9-b17d-bfeb3703bf7c}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="255,206,128,255,rgb:1,0.80784313725490198,0.50196078431372548,1"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="1.5"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" clip_to_extent="1" type="line" name="1" alpha="1" is_animated="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" class="SimpleLine" pass="0" id="{b6589955-e648-4ade-9bf3-b1ec4841411f}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="76,38,0,255,rgb:0.29803921568627451,0.14901960784313725,0,1"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="1.7"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" class="SimpleLine" pass="0" id="{1006d9e6-f70e-4996-9547-7e6d32e65511}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="128,203,255,255,hsv:0.56841666666666668,0.49803921568627452,1,1"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="1.5"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" clip_to_extent="1" type="line" name="2" alpha="1" is_animated="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" class="SimpleLine" pass="0" id="{c75e9f64-8436-4dbf-ac33-66461841c44a}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="76,38,0,255,rgb:0.29803921568627451,0.14901960784313725,0,1"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="1.7"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" class="SimpleLine" pass="0" id="{a4cce020-911e-4db9-af96-9d88ce4b3424}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="198,128,255,255,hsv:0.75788888888888883,0.49803921568627452,1,1"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="1.5"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <data-defined-properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol frame_rate="10" clip_to_extent="1" type="line" name="" alpha="1" is_animated="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" class="SimpleLine" pass="0" id="{4137bffd-64f4-45fb-8101-647f5498594b}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="0.26"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
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
'
WHERE layername='v_om_mincut_arc' AND styleconfig_id=101;

UPDATE sys_style
SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.5-Bratislava">
  <renderer-v2 symbollevels="0" type="RuleRenderer" referencescale="-1" enableorderby="0" forceraster="0">
    <rules key="{1e5dbc1d-a0b4-4a52-bf03-ab4d7c71747f}">
      <rule symbol="0" key="{2c251799-4c26-42af-b4c4-8e47b7aabfcf}" filter="result_type = ''current''" label="Current Mincut init point"/>
      <rule symbol="1" key="{d82af677-70ef-4363-a0bd-5acddc1280cd}" filter="result_type = ''conflict''" label="Conflict Mincut init point"/>
    </rules>
    <symbols>
      <symbol frame_rate="10" clip_to_extent="1" type="marker" name="0" alpha="1" is_animated="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" class="SimpleMarker" pass="0" id="{f0871bfc-50c9-4ccc-8c28-879c47565fe6}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="45,84,255,255,rgb:0.17647058823529413,0.32941176470588235,1,1"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,24,124,255,rgb:0,0.09411764705882353,0.48627450980392156,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2.4"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" clip_to_extent="1" type="marker" name="1" alpha="1" is_animated="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" class="SimpleMarker" pass="0" id="{f48286a3-4e1a-4832-a14c-cb9ebd1ad885}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="255,211,45,255,hsv:0.13158333333333333,0.82352941176470584,1,1"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2.4"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <data-defined-properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol frame_rate="10" clip_to_extent="1" type="marker" name="" alpha="1" is_animated="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" class="SimpleMarker" pass="0" id="{0cac209c-9ac8-46b7-8ad0-3b8fd22fe3c3}" enabled="1">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="255,0,0,255,rgb:1,0,0,1"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
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
'
WHERE layername='v_om_mincut_initpoint' AND styleconfig_id=101;

UPDATE config_toolbox SET inputparams='[
{"label": "Exploitation:", "tooltip": "Choose exploitation to work with", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": "", "widgetname": "exploitation", "widgettype": "combo", "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", "layoutorder": 1},
{"label": "Use masterplan psectors:", "value": "", "datatype": "boolean", "layoutname": "grl_option_parameters", "widgetname": "usePlanPsector", "widgettype": "check", "layoutorder": 2},
{"label": "Commit changes:", "value": "", "datatype": "boolean", "layoutname": "grl_option_parameters", "widgetname": "commitChanges", "widgettype": "check", "layoutorder": 3},
{"label": "Update mapzone geometry method:", "comboIds": [0, 1, 2, 3], "datatype": "integer", "comboNames": ["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "layoutname": "grl_option_parameters", "selectedId": "", "widgetname": "updateMapZone", "widgettype": "combo", "layoutorder": 4},
{"label": "Geometry parameter:", "value": "", "datatype": "float", "layoutname": "grl_option_parameters", "widgetname": "geomParamUpdate", "widgettype": "text", "isMandatory": false, "layoutorder": 5, "placeholder": "5-30"},
{"label": "Execute Massive Mincut:", "value": "", "datatype": "boolean", "layoutname": "grl_option_parameters", "widgetname": "executeMassiveMincut", "widgettype": "check", "layoutorder": 6},
{"label": "Ignore Unaccess Valves Mincut:", "value": "", "datatype": "boolean", "layoutname": "grl_option_parameters", "widgetname": "ignoreUnaccessValvesMincut", "widgettype": "check", "layoutorder": 7},
{"label": "Ignore ChangeStatus Valves Mincut:", "value": "", "datatype": "boolean", "layoutname": "grl_option_parameters", "widgetname": "ignoreChangeStatusValvesMincut", "widgettype": "check", "layoutorder": 8}
]'::json WHERE id=2706;

UPDATE config_function SET layermanager=NULL WHERE id=2706;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4418, 'Mincut conflicts: [%array%]', '', 0, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4420, 'MINCUT AFFECTED STATS', '', 0, true, 'ws', 'core', 'AUDIT');

UPDATE sys_message SET error_message='Mincut have been executed with conflicts. All additional affetations have created a new mincut with state_type = %state_type%' WHERE id=4406;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4422, 'New affected mincuts have been created: [%array%]', '', 0, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4424, 'New affected mincut id: %id%', '', 0, true, 'ws', 'core', 'AUDIT');

insert into sys_message (id, error_message, hint_message, log_level, show_user, project_type, source, message_type) 
VALUES(4426, 'Conflict Interval: %interval%', '', 0, true, 'ws', 'core', 'AUDIT');

INSERT INTO sys_style
(layername, styleconfig_id, styletype, stylevalue, active)
VALUES('ve_arc', 110, 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.8-Bratislava" styleCategories="Symbology">
  <renderer-v2 referencescale="-1" symbollevels="0" enableorderby="0" type="RuleRenderer" forceraster="0">
    <rules key="{c00d5268-ffda-4054-b5b0-549e3eb53b7c}">
      <rule filter="&quot;state&quot; = 0" label="OBSOLETE" key="{dec50635-2b21-4fe8-88c0-1868ce289fdf}" symbol="0"/>
      <rule filter="&quot;state&quot; = 1 and (p_state &lt;> 0 or p_state is null)" label="OPERATIVE" key="{7f9930f4-6639-4164-9552-96b2d0cb5ce0}" symbol="1"/>
      <rule filter="&quot;state&quot; = 2" label="PLANIFIED" key="{79a0d8f1-4f52-4993-b94b-bd2d1c139495}" symbol="2"/>
      <rule filter="state = 1 and p_state = 0" label="PHASE-OUT" key="{3a8eb8d6-f50f-4d54-8a8b-300d6e1ae0a2}" symbol="3"/>
      <rule filter="ELSE" label="(drawing)" key="{aaf1a0b3-b366-4d6f-88f8-ef3936591e7c}" symbol="4"/>
    </rules>
    <symbols>
      <symbol frame_rate="10" is_animated="0" type="line" alpha="1" clip_to_extent="1" name="0" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" id="{7495e564-1f2e-4c4e-adf2-96c2a06cbe10}" locked="0" class="SimpleLine" pass="0">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="162,162,162,255,hsv:0,0,0.63682001983672842,1"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="0.5"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" name="active" value="true"/>
                  <Option type="QString" name="expression" value="case when cat_dnom is not null then&#xd;&#xa;-4.862 + 0.977 * ln(&quot;cat_dnom&quot; + 159.243)&#xd;&#xa;else 0.25 end"/>
                  <Option type="int" name="type" value="3"/>
                </Option>
              </Option>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" is_animated="0" type="line" alpha="1" clip_to_extent="1" name="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" id="{b64bb163-e03e-4b0d-843e-76c497204421}" locked="0" class="SimpleLine" pass="0">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="31,120,180,255,rgb:0.12156862745098039,0.47058823529411764,0.70588235294117652,1"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="0.5"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" name="active" value="true"/>
                  <Option type="QString" name="expression" value="case when cat_dnom is not null then&#xd;&#xa;-4.862 + 0.977 * ln(&quot;cat_dnom&quot; + 159.243)&#xd;&#xa;else 0.25 end"/>
                  <Option type="int" name="type" value="3"/>
                </Option>
              </Option>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" is_animated="0" type="line" alpha="1" clip_to_extent="1" name="2" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" id="{8e6baa60-d3ad-4440-baf0-f5e293ac693f}" locked="0" class="SimpleLine" pass="0">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="245,128,26,255,rgb:0.96078431372549022,0.50196078431372548,0.10196078431372549,1"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="0.5"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" name="active" value="true"/>
                  <Option type="QString" name="expression" value="case when cat_dnom is not null then&#xd;&#xa;-4.862 + 0.977 * ln(&quot;cat_dnom&quot; + 159.243)&#xd;&#xa;else 0.25 end"/>
                  <Option type="int" name="type" value="3"/>
                </Option>
              </Option>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" is_animated="0" type="line" alpha="1" clip_to_extent="1" name="3" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" id="{c1dd7591-7c13-46c8-b3a8-495843eb24cb}" locked="0" class="SimpleLine" pass="0">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="121,208,255,255,rgb:0.47450980392156861,0.81568627450980391,1,1"/>
            <Option type="QString" name="line_style" value="dash"/>
            <Option type="QString" name="line_width" value="0.5"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" name="active" value="true"/>
                  <Option type="QString" name="expression" value="case when cat_dnom is not null then&#xd;&#xa;-4.862 + 0.977 * ln(&quot;cat_dnom&quot; + 159.243)&#xd;&#xa;else 0.25 end"/>
                  <Option type="int" name="type" value="3"/>
                </Option>
              </Option>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" is_animated="0" type="line" alpha="1" clip_to_extent="1" name="4" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" id="{02aed3f9-a912-44fa-8432-84e6d86c257b}" locked="0" class="SimpleLine" pass="0">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="round"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="round"/>
            <Option type="QString" name="line_color" value="85,95,105,255,hsv:0.58761111111111108,0.19267566948958573,0.41322957198443577,1"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="0.35"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <data-defined-properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol frame_rate="10" is_animated="0" type="line" alpha="1" clip_to_extent="1" name="" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer enabled="1" id="{f0817fea-ea6c-4aa3-912a-22eceb8fe77a}" locked="0" class="SimpleLine" pass="0">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="square"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="line_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="0.26"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
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
', true);

INSERT INTO sys_style
(layername, styleconfig_id, styletype, stylevalue, active)
VALUES('ve_node', 110, 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.8-Bratislava">
  <renderer-v2 referencescale="-1" forceraster="0" symbollevels="0" type="RuleRenderer" enableorderby="0">
    <rules key="{f9bd1dda-e8cb-4456-b498-a3f1312029f9}">
      <rule filter="&quot;sys_type&quot; = ''WTP''" symbol="0" scalemaxdenom="25000" label="Wtp" key="{d0729bdd-7dcb-4e5d-9962-cd92c35d405e}"/>
      <rule filter="&quot;sys_type&quot; = ''WATERWELL''" symbol="1" scalemaxdenom="25000" label="Waterwell" key="{2ecb80ea-9da6-4533-aad0-7275c5a08550}"/>
      <rule filter="&quot;sys_type&quot; = ''SOURCE''" symbol="2" scalemaxdenom="25000" label="Source" key="{88ef1cea-1727-4681-9d7e-964bcfee179f}"/>
      <rule filter="&quot;sys_type&quot; = ''TANK''" symbol="3" scalemaxdenom="25000" label="Tank" key="{5d885b4a-fd95-42b2-8da9-717face5a272}"/>
      <rule filter="&quot;sys_type&quot; = ''EXPANSIONTANK''" symbol="4" scalemaxdenom="10000" label="Expantank" key="{eed06555-2d38-4bfe-b114-13e014b63af1}"/>
      <rule filter="&quot;sys_type&quot; = ''FILTER''" symbol="5" scalemaxdenom="10000" label="Filter" key="{d2138541-5cb8-4896-b97e-494fa6df6d40}"/>
      <rule filter="&quot;sys_type&quot; = ''FLEXUNION''" symbol="6" scalemaxdenom="10000" label="Flexunion" key="{9f0ffeda-84af-4676-9263-119eb6042786}"/>
      <rule filter="&quot;sys_type&quot; = ''HYDRANT''" symbol="7" scalemaxdenom="10000" label="Hydrant" key="{bfe404fe-23c9-4c26-a91e-bc5e89b7203b}"/>
      <rule filter="&quot;sys_type&quot; = ''METER''" symbol="8" scalemaxdenom="10000" label="Meter" key="{70f23680-8f8d-4eb8-ad9d-b6c222b1359a}"/>
      <rule filter="&quot;sys_type&quot; = ''NETELEMENT''" symbol="9" scalemaxdenom="10000" label="Netelement" key="{086f2a29-0a69-4a25-9b96-9f5d9f2955c1}"/>
      <rule filter="&quot;sys_type&quot; = ''NETSAMPLEPOINT''" symbol="10" scalemaxdenom="10000" label="Netsamplepoint" key="{c0f1b0c8-34ee-4ec4-a914-97824ad2c467}"/>
      <rule filter="&quot;sys_type&quot; = ''PUMP''" symbol="11" scalemaxdenom="10000" label="Pump" key="{01479095-8f9e-40cf-b92b-6e13874561ae}"/>
      <rule filter="&quot;sys_type&quot; = ''REGISTER''" symbol="12" scalemaxdenom="10000" label="Register" key="{8e1a0afb-c274-48ae-95a9-9c35583776c7}"/>
      <rule filter="&quot;sys_type&quot; = ''MANHOLE''" symbol="13" scalemaxdenom="10000" label="Manhole" key="{118313b2-195c-4998-a2e3-965b368f9482}"/>
      <rule filter="&quot;sys_type&quot; = ''REDUCTION''" symbol="14" scalemaxdenom="10000" label="Reduction" key="{94bc6268-f342-4b79-a7f0-d8ba6498eb62}"/>
      <rule filter="&quot;sys_type&quot; = ''JUNCTION''" symbol="15" scalemaxdenom="5000" label="Junction" key="{4006148d-3986-44fc-b269-0707485e9bd0}"/>
      <rule filter="&quot;sys_type&quot; = ''NETWJOIN''" symbol="16" scalemaxdenom="10000" label="Netwjoin" key="{2efa5954-7163-4c85-b608-6e6326bf4b5b}"/>
      <rule filter="&quot;sys_type&quot; = ''VALVE'' and (&quot;closed_valve&quot;  =  false or  &quot;closed_valve&quot; =  NULL )" symbol="17" scalemaxdenom="10000" label="Valve Open" key="{d6c2b118-3f7e-4809-a8e8-e6857e5a3f87}"/>
      <rule filter="&quot;sys_type&quot; = ''VALVE'' and (&quot;closed_valve&quot;  =  true )" symbol="18" scalemaxdenom="10000" label="Valve Closed" key="{82481050-9411-4920-bf5b-aa8cde85e324}"/>
      <rule filter="state=0 AND sys_type NOT IN (''WTP'', ''WATERWELL'', ''SOURCE'', ''TANK'', ''JUNCTION'')" symbol="19" scalemaxdenom="10000" label="OBSOLETE" key="{efb4dc05-3472-4eed-8d10-5355fb2d7bbe}"/>
      <rule filter="state=0 AND sys_type IN (''WTP'', ''WATERWELL'', ''SOURCE'', ''TANK'')" symbol="20" scalemaxdenom="25000" label="OBSOLETE Header" key="{cc9aab97-b14f-45fc-bf18-b9111090fe44}"/>
      <rule filter="state=0 AND sys_type = ''JUNCTION''" symbol="21" scalemaxdenom="5000" label="OBSOLETE Junction" key="{14ff68cf-8eb2-41db-9463-6097aec9dd2b}"/>
      <rule filter="state=2 AND sys_type NOT IN (''WTP'', ''WATERWELL'', ''SOURCE'', ''TANK'', ''JUNCTION'')" symbol="22" scalemaxdenom="10000" label="PLANIFIED" key="{0a59c677-670e-4503-a159-8d6c9ab0eccf}"/>
      <rule filter="state=2 AND sys_type = ''JUNCTION''" symbol="23" scalemaxdenom="5000" label="PLANIFIED Junction" key="{291d54c9-ee3f-456b-baeb-9a09c1ac8bec}"/>
      <rule filter="state=2 AND sys_type IN (''WTP'', ''WATERWELL'', ''SOURCE'', ''TANK'')" symbol="24" scalemaxdenom="25000" label="PLANIFIED Header" key="{18949285-1558-4fbb-bf6d-078f684e19eb}"/>
      <rule filter="state=1 AND p_state=0 AND sys_type NOT IN (''WTP'', ''WATERWELL'', ''SOURCE'', ''TANK'', ''JUNCTION'')" symbol="25" scalemaxdenom="10000" label="PHASE-OUT" key="{46f559c1-c7c1-49a3-b52a-129708d86ea3}"/>
      <rule filter="state=1 AND p_state=0  AND sys_type = ''JUNCTION''" symbol="26" scalemaxdenom="5000" label="PHASE-OUT Junction" key="{fa228635-5492-41e2-bea2-9748f9a258cd}"/>
      <rule filter="state=1 AND p_state=0  AND sys_type IN (''WTP'', ''WATERWELL'', ''SOURCE'', ''TANK'')" symbol="27" scalemaxdenom="25000" label="PHASE-OUT Header" key="{11c4e900-bb0b-43c3-8c0f-0d9f1a6b0197}"/>
      <rule filter="ELSE" symbol="28" label="(drawing)" key="{1f0819cf-ab04-45e1-8de1-bca89d930864}"/>
    </rules>
    <symbols>
      <symbol alpha="1" name="0" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{2426fdf4-b863-4a31-8d22-75d3b87db206}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="50,48,55,255,rgb:0.19607843137254902,0.18823529411764706,0.21568627450980393,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.36999999999999994" name="exponent" type="double"/>
                      <Option value="2" name="maxSize" type="double"/>
                      <Option value="25000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{60f8cb73-bd3f-4499-81be-3df8dc0b9276}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="W" name="chr" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="Normal" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0.20000000000000001,-0.20000000000000001" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="1" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{bc3fd64a-7e37-4600-a277-2a6e0beed2f2}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,127,0,255,rgb:1,0.49803921568627452,0,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,0,rgb:1,1,1,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.36999999999999994" name="exponent" type="double"/>
                      <Option value="2" name="maxSize" type="double"/>
                      <Option value="25000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{6491853f-3db7-4599-8f47-82ea692a3939}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="W" name="chr" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0.20000000000000001,-0.20000000000000001" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="10" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{3a816b27-397e-4ff3-84c6-ffe6d22b372d}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="0,100,200,255,rgb:0,0.39215686274509803,0.78431372549019607,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255,hsv:0.56711111111111112,0.82777141985198743,0,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{23bcf08d-7c4e-47b3-8c8e-8bac2a91a2f8}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="S" name="chr" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="char" type="Map">
                  <Option value="false" name="active" type="bool"/>
                  <Option value="1" name="type" type="int"/>
                  <Option value="" name="val" type="QString"/>
                </Option>
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="11" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{8dc8a232-f679-482d-b793-ac2b53347478}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,127,0,255,rgb:1,0.49803921568627452,0,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{3afd08f1-43b6-467e-a8ef-4a35b950ef4a}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="P" name="chr" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="12" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{680b46d0-028b-48eb-abf8-6b72554acb67}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="32,10,129,255,rgb:0.12549019607843137,0.0392156862745098,0.50588235294117645,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{cf489170-55a0-4d90-8676-2128de54ea7c}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="R" name="chr" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="13" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{a6a44934-0dbe-4f33-abcf-2aa1924e6f07}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="166,206,227,255,rgb:0.65098039215686276,0.80784313725490198,0.8901960784313725,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{3d10fcb3-5875-4796-a630-8f37f10a6db5}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="M" name="chr" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="14" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{e713d3d0-79b7-4a2e-938b-7b27ae020cb5}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="237,183,25,255,rgb:0.92941176470588238,0.71764705882352942,0.09803921568627451,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,0,rgb:1,1,1,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{99c6600d-cec6-4008-8248-a7379dc5646a}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="R" name="chr" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="15" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{c3168ec5-08d4-4f23-95b2-b9080a65290a}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="0,242,255,255,rgb:0,0.94901960784313721,1,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="50,48,55,255,rgb:0.19607843137254902,0.18823529411764706,0.21568627450980393,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.8" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="1" name="maxSize" type="double"/>
                      <Option value="5000" name="maxValue" type="double"/>
                      <Option value="2" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="16" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{3a816b27-397e-4ff3-84c6-ffe6d22b372d}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="70,151,75,255,rgb:0.27450980392156865,0.59215686274509804,0.29411764705882354,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{37ce3b30-f2bc-417c-a59b-156c6c6ad560}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="70,151,75,255,rgb:0.27450980392156865,0.59215686274509804,0.29411764705882354,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="cross" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="17" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{592e9086-2d83-4d08-9568-51d5431fb897}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="31,120,180,255,rgb:0.12156862745098039,0.47058823529411764,0.70588235294117652,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="angle" type="Map">
                  <Option value="false" name="active" type="bool"/>
                  <Option value="rotation" name="field" type="QString"/>
                  <Option value="2" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{6544b1be-a893-4047-b925-e492b240f401}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="V" name="chr" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="angle" type="Map">
                  <Option value="false" name="active" type="bool"/>
                  <Option value="rotation" name="field" type="QString"/>
                  <Option value="2" name="type" type="int"/>
                </Option>
                <Option name="char" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="case when node_type IN ( ''AIR_VALVE'' , ''CHECK_VALVE'' , ''PR_REDUC_VALVE'' )then left( &quot;node_type&quot; , 1) else ''V'' end" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="18" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{3a816b27-397e-4ff3-84c6-ffe6d22b372d}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="199,28,31,255,rgb:0.7803921568627451,0.10980392156862745,0.12156862745098039,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{23bcf08d-7c4e-47b3-8c8e-8bac2a91a2f8}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="V" name="chr" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="char" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="case when node_type IN ( ''AIR_VALVE'' , ''CHECK_VALVE'' , ''PR_REDUC_VALVE'' )then left( &quot;node_type&quot; , 1) else ''V'' end" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="19" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{592e9086-2d83-4d08-9568-51d5431fb897}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="120,120,120,153,hsv:0.56711111111111112,0,0.4690928511482414,0.59999999999999998" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="angle" type="Map">
                  <Option value="false" name="active" type="bool"/>
                  <Option value="rotation" name="field" type="QString"/>
                  <Option value="2" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="2" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{a7d527ec-c92e-4b39-90ad-ef546a13966c}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="35,200,120,255,rgb:0.13725490196078433,0.78431372549019607,0.47058823529411764,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.36999999999999994" name="exponent" type="double"/>
                      <Option value="2" name="maxSize" type="double"/>
                      <Option value="25000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{dd1def90-d6fa-4b87-9bdc-e4534a97034d}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="S" name="chr" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0.20000000000000001,-0.20000000000000001" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="20" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{2426fdf4-b863-4a31-8d22-75d3b87db206}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="120,120,120,153,hsv:0.56711111111111112,0,0.4690928511482414,0.59999999999999998" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.36999999999999994" name="exponent" type="double"/>
                      <Option value="2" name="maxSize" type="double"/>
                      <Option value="25000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="21" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{c3168ec5-08d4-4f23-95b2-b9080a65290a}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="120,120,120,153,hsv:0.56711111111111112,0,0.4690928511482414,0.59999999999999998" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="120,120,120,153,hsv:0.56711111111111112,0,0.4690928511482414,0.59999999999999998" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.8" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="1" name="maxSize" type="double"/>
                      <Option value="5000" name="maxValue" type="double"/>
                      <Option value="2" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="22" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{592e9086-2d83-4d08-9568-51d5431fb897}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="120,120,120,0,hsv:0.56711111111111112,0,0.4690928511482414,0" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="245,128,26,255,rgb:0.96078431372549022,0.50196078431372548,0.10196078431372549,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.6" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="angle" type="Map">
                  <Option value="false" name="active" type="bool"/>
                  <Option value="rotation" name="field" type="QString"/>
                  <Option value="2" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="23" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{c3168ec5-08d4-4f23-95b2-b9080a65290a}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="245,128,26,255,rgb:0.96078431372549022,0.50196078431372548,0.10196078431372549,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="208,100,6,255,hsv:0.07763888888888888,0.97120622568093384,0.81702906843671319,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.8" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="1" name="maxSize" type="double"/>
                      <Option value="5000" name="maxValue" type="double"/>
                      <Option value="2" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="24" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{2426fdf4-b863-4a31-8d22-75d3b87db206}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="245,128,26,0,rgb:0.96078431372549022,0.50196078431372548,0.10196078431372549,0" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="245,128,26,255,rgb:0.96078431372549022,0.50196078431372548,0.10196078431372549,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.6" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.36999999999999994" name="exponent" type="double"/>
                      <Option value="2" name="maxSize" type="double"/>
                      <Option value="25000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="25" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{592e9086-2d83-4d08-9568-51d5431fb897}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="120,120,120,0,hsv:0.56711111111111112,0,0.4690928511482414,0" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="121,208,255,255,rgb:0.47450980392156861,0.81568627450980391,1,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.6" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="angle" type="Map">
                  <Option value="false" name="active" type="bool"/>
                  <Option value="rotation" name="field" type="QString"/>
                  <Option value="2" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="26" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{c3168ec5-08d4-4f23-95b2-b9080a65290a}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="121,208,255,255,rgb:0.47450980392156861,0.81568627450980391,1,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="61,180,244,255,hsv:0.55844444444444441,0.74923323414969101,0.95664911879148551,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.8" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="1" name="maxSize" type="double"/>
                      <Option value="5000" name="maxValue" type="double"/>
                      <Option value="2" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="27" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{2426fdf4-b863-4a31-8d22-75d3b87db206}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="245,128,26,0,rgb:0.96078431372549022,0.50196078431372548,0.10196078431372549,0" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="121,208,255,255,rgb:0.47450980392156861,0.81568627450980391,1,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.6" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.36999999999999994" name="exponent" type="double"/>
                      <Option value="2" name="maxSize" type="double"/>
                      <Option value="25000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="28" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{08733df3-bc13-4eac-bf5c-58b353a68ba7}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="85,95,105,255,hsv:0.58761111111111108,0.19267566948958573,0.41322957198443577,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.6" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="3" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{4179f10b-4e31-4983-a9cd-ec5fbc3b6eb7}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="26,115,162,255,rgb:0.10196078431372549,0.45098039215686275,0.63529411764705879,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.37" name="exponent" type="double"/>
                      <Option value="2" name="maxSize" type="double"/>
                      <Option value="25000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{a448a54c-2934-4e3f-bdbe-e6406ca777af}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="D" name="chr" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0.20000000000000001,-0.20000000000000001" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="4" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{e58b92e2-1f0d-44eb-9935-334695a38e22}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="25,237,206,255,rgb:0.09803921568627451,0.92941176470588238,0.80784313725490198,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{02d4b74a-f777-457b-9601-4a3ef69b405c}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="E" name="chr" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="5" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{5c06718c-3f7d-4ce0-9cd6-20a447774d9d}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="251,154,153,255,rgb:0.98431372549019602,0.60392156862745094,0.59999999999999998,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{85d6b24f-f9af-47cf-b64a-dcf9f311b03b}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="F" name="chr" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="6" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{c76bb1e8-5a31-4354-b5fd-a41a2cb4aac4}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="191,246,61,255,rgb:0.74901960784313726,0.96470588235294119,0.23921568627450981,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{bc070515-6a58-47fc-b850-6fc0deb93cf5}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="F" name="chr" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="7" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{3a816b27-397e-4ff3-84c6-ffe6d22b372d}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,0,0,255,hsv:0,1,1,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{23bcf08d-7c4e-47b3-8c8e-8bac2a91a2f8}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="H" name="chr" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="char" type="Map">
                  <Option value="false" name="active" type="bool"/>
                  <Option value="1" name="type" type="int"/>
                  <Option value="" name="val" type="QString"/>
                </Option>
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="8" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{ab36f7c9-d62b-4b43-8c4f-5e89e62e4a2b}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="133,133,133,255,rgb:0.52156862745098043,0.52156862745098043,0.52156862745098043,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{a21eceef-f8ec-408e-90cc-21515599a898}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="M" name="chr" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="9" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{a2fe185b-9594-40fa-b75b-44ed3f0d1f45}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="129,10,78,255,rgb:0.50588235294117645,0.0392156862745098,0.30588235294117649,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,0,rgb:0,0,0,0" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="0.7" name="maxSize" type="double"/>
                      <Option value="10000" name="maxValue" type="double"/>
                      <Option value="5.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{994f37d8-bd5b-4699-9434-22b4c78faaa9}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="E" name="chr" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="255,255,255,255,rgb:1,1,1,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <data-defined-properties>
      <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol alpha="1" name="" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{71ca92da-75c9-49ce-a629-80db92f6b424}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,0,0,255,rgb:1,0,0,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
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
', true);

INSERT INTO sys_style
(layername, styleconfig_id, styletype, stylevalue, active)
VALUES('ve_connec', 110, 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology|Labeling" version="3.40.8-Bratislava" labelsEnabled="1">
  <renderer-v2 referencescale="-1" forceraster="0" symbollevels="0" type="RuleRenderer" enableorderby="0">
    <rules key="{cd75f41e-3b1d-443c-8148-fbc4436aa9cb}">
      <rule filter="state = 1 and (p_state &lt;> 0 or p_state is null) AND &quot;sys_type&quot; = ''GREENTAP''" symbol="0" scalemaxdenom="1500" label="Greentap" key="{24b63ac0-a836-4203-bd64-161a0112ee9a}"/>
      <rule filter="state = 1 and (p_state &lt;> 0 or p_state is null) AND &quot;sys_type&quot; =''WJOIN''" symbol="1" scalemaxdenom="1500" label="Wjoin" key="{abcdb374-fe6a-4d04-a466-31fdd93144e8}"/>
      <rule filter="state = 1 and (p_state &lt;> 0 or p_state is null) AND &quot;sys_type&quot; =''TAP''" symbol="2" scalemaxdenom="1500" label="Tap" key="{7dc90f4d-d098-491a-b817-e7ea68fc2fd6}"/>
      <rule filter="state = 1 and (p_state &lt;> 0 or p_state is null) AND &quot;sys_type&quot; =''FOUNTAIN''" symbol="3" scalemaxdenom="1500" label="Fountain" key="{39e4856f-0fc3-4498-8d4b-44d2851b421f}"/>
      <rule filter="state=0" symbol="4" scalemaxdenom="1500" label="OBSOLETE" key="{5ed6d5c8-0054-42c1-a268-53e042760284}"/>
      <rule filter="state=2" symbol="5" scalemaxdenom="1500" label="PLANIFIED" key="{deedf78b-1b14-4314-b775-536678965a4f}"/>
      <rule filter="state=1 AND p_state=0" symbol="6" scalemaxdenom="1500" label="PHASE-OUT" key="{b0e34206-b0d8-424d-a80a-21fec3287f94}"/>
      <rule filter="ELSE" symbol="7" label="(drawing)" key="{fcb93b3a-1412-448e-b95f-627bfe328230}"/>
    </rules>
    <symbols>
      <symbol alpha="1" name="0" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{12cc35f6-2de1-4246-b4e0-8a183935eeae}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="201,246,158,255,rgb:0.78823529411764703,0.96470588235294119,0.61960784313725492,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.6" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.57" name="exponent" type="double"/>
                      <Option value="1" name="maxSize" type="double"/>
                      <Option value="1500" name="maxValue" type="double"/>
                      <Option value="3.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="2" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="1" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{362f8968-f888-433b-90e4-e5098d869499}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="49,180,227,255,rgb:0.19215686274509805,0.70588235294117652,0.8901960784313725,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="49,180,227,255,rgb:0.19215686274509805,0.70588235294117652,0.8901960784313725,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="angle" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="rotation" name="field" type="QString"/>
                  <Option value="2" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.666667*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 3.5, 2, 0.37), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{67948e1f-e6bb-4593-b5ad-8bb9fcf49d7d}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,0,0,255,rgb:1,0,0,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="cross" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="3" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="angle" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="rotation" name="field" type="QString"/>
                  <Option value="2" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.37" name="exponent" type="double"/>
                      <Option value="2" name="maxSize" type="double"/>
                      <Option value="1500" name="maxValue" type="double"/>
                      <Option value="3.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="2" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{9be7c088-b096-4952-9c7a-3fe50ee2852a}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="31,120,180,255,rgb:0.12156862745098039,0.47058823529411764,0.70588235294117652,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="square" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.37" name="exponent" type="double"/>
                      <Option value="1.5" name="maxSize" type="double"/>
                      <Option value="1500" name="maxValue" type="double"/>
                      <Option value="3.5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="3" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{d8e73060-669b-4565-9660-e859c06a83fd}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="44,67,207,83,rgb:0.17254901960784313,0.2627450980392157,0.81176470588235294,0.32549019607843138" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="triangle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="22,0,148,255,rgb:0.08627450980392157,0,0.58039215686274515,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="4.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.37" name="exponent" type="double"/>
                      <Option value="2.5" name="maxSize" type="double"/>
                      <Option value="1500" name="maxValue" type="double"/>
                      <Option value="5" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{b07449ae-bcc9-48eb-8ebd-ae0ffa344f84}" enabled="1" locked="0" class="FontMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="F" name="chr" type="QString"/>
            <Option value="22,0,148,255,rgb:0.08627450980392157,0,0.58039215686274515,1" name="color" type="QString"/>
            <Option value="Arial" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0.20000000000000001,0.20000000000000001" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255,rgb:0,0,0,1" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="3" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="offset" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 5, 2.5, 0.37), 0)))|| '','' || tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 5, 2.5, 0.37), 0)))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="0.714286*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 5, 2.5, 0.37), 0))" name="expression" type="QString"/>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="4" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{c3168ec5-08d4-4f23-95b2-b9080a65290a}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="120,120,120,153,hsv:0.56711111111111112,0,0.4690928511482414,0.59999999999999998" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="120,120,120,153,hsv:0.56711111111111112,0,0.4690928511482414,0.59999999999999998" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.8" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="1" name="maxSize" type="double"/>
                      <Option value="5000" name="maxValue" type="double"/>
                      <Option value="2" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="5" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{c3168ec5-08d4-4f23-95b2-b9080a65290a}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="245,128,26,255,rgb:0.96078431372549022,0.50196078431372548,0.10196078431372549,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="208,100,6,255,hsv:0.07763888888888888,0.97120622568093384,0.81702906843671319,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.8" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="1" name="maxSize" type="double"/>
                      <Option value="5000" name="maxValue" type="double"/>
                      <Option value="2" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="6" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{c3168ec5-08d4-4f23-95b2-b9080a65290a}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="121,208,255,255,rgb:0.47450980392156861,0.81568627450980391,1,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="61,180,244,255,hsv:0.55844444444444441,0.74923323414969101,0.95664911879148551,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.8" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option value="true" name="active" type="bool"/>
                  <Option value="var(''map_scale'')" name="expression" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option value="0.52" name="exponent" type="double"/>
                      <Option value="1" name="maxSize" type="double"/>
                      <Option value="5000" name="maxValue" type="double"/>
                      <Option value="2" name="minSize" type="double"/>
                      <Option value="0" name="minValue" type="double"/>
                      <Option value="0" name="nullSize" type="double"/>
                      <Option value="3" name="scaleType" type="int"/>
                    </Option>
                    <Option value="1" name="t" type="int"/>
                  </Option>
                  <Option value="3" name="type" type="int"/>
                </Option>
              </Option>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" name="7" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{08733df3-bc13-4eac-bf5c-58b353a68ba7}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="85,95,105,255,hsv:0.58761111111111108,0.19267566948958573,0.41322957198443577,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.6" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <data-defined-properties>
      <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol alpha="1" name="" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{593cbcfc-245e-4774-ad13-56169b965bf5}" enabled="1" locked="0" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,0,0,255,rgb:1,0,0,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style textColor="50,50,50,255,rgb:0.19607843137254902,0.19607843137254902,0.19607843137254902,1" textOpacity="1" blendMode="0" multilineHeight="1" namedStyle="Regular" useSubstitutions="0" fontStrikeout="0" fontKerning="1" fontWordSpacing="0" isExpression="0" fontSizeUnit="Point" capitalization="0" fontUnderline="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" tabStopDistance="80" multilineHeightUnit="Percentage" tabStopDistanceMapUnitScale="3x:0,0,0,0,0,0" fontFamily="Open Sans" stretchFactor="100" textOrientation="horizontal" fontItalic="0" allowHtml="0" fontWeight="50" fontSize="10" forcedItalic="0" forcedBold="0" previewBkgrdColor="255,255,255,255,rgb:1,1,1,1" tabStopDistanceUnit="Point" legendString="Aa" fontLetterSpacing="0" fieldName="arc_id">
        <families/>
        <text-buffer bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferJoinStyle="128" bufferNoFill="1" bufferSizeUnits="MM" bufferBlendMode="0" bufferSize="1" bufferDraw="0" bufferColor="250,250,250,255,rgb:0.98039215686274506,0.98039215686274506,0.98039215686274506,1" bufferOpacity="1"/>
        <text-mask maskType="0" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskEnabled="0" maskedSymbolLayers="" maskOpacity="1" maskSize2="1.5" maskSize="1.5" maskSizeUnits="MM" maskJoinStyle="128"/>
        <background shapeOffsetUnit="Point" shapeRadiiX="0" shapeType="0" shapeRadiiUnit="Point" shapeOpacity="1" shapeOffsetY="0" shapeSizeY="0" shapeDraw="0" shapeFillColor="255,255,255,255,rgb:1,1,1,1" shapeRotation="0" shapeSVGFile="" shapeBorderWidthUnit="Point" shapeJoinStyle="64" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeBlendMode="0" shapeSizeType="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidth="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiY="0" shapeRotationType="0" shapeOffsetX="0" shapeSizeX="0" shapeBorderColor="128,128,128,255,rgb:0.50196078431372548,0.50196078431372548,0.50196078431372548,1" shapeSizeUnit="Point">
          <symbol alpha="1" name="markerSymbol" force_rhr="0" type="marker" frame_rate="10" is_animated="0" clip_to_extent="1">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer id="" enabled="1" locked="0" class="SimpleMarker" pass="0">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="213,180,60,255,rgb:0.83529411764705885,0.70588235294117652,0.23529411764705882,1" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="2" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
          <symbol alpha="1" name="fillSymbol" force_rhr="0" type="fill" frame_rate="10" is_animated="0" clip_to_extent="1">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer id="" enabled="1" locked="0" class="SimpleFill" pass="0">
              <Option type="Map">
                <Option value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale" type="QString"/>
                <Option value="255,255,255,255,rgb:1,1,1,1" name="color" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="128,128,128,255,rgb:0.50196078431372548,0.50196078431372548,0.50196078431372548,1" name="outline_color" type="QString"/>
                <Option value="no" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="Point" name="outline_width_unit" type="QString"/>
                <Option value="solid" name="style" type="QString"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </background>
        <shadow shadowDraw="0" shadowOffsetUnit="MM" shadowOpacity="0.69999999999999996" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowColor="0,0,0,255,rgb:0,0,0,1" shadowRadius="1.5" shadowUnder="0" shadowOffsetGlobal="1" shadowRadiusUnit="MM" shadowRadiusAlphaOnly="0" shadowOffsetAngle="135" shadowOffsetDist="1" shadowScale="100" shadowBlendMode="6"/>
        <dd_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format formatNumbers="0" autoWrapLength="0" reverseDirectionSymbol="0" placeDirectionSymbol="0" useMaxLineLengthForAutoWrap="1" decimals="3" multilineAlign="3" addDirectionSymbol="0" plussign="0" rightDirectionSymbol=">" wrapChar="" leftDirectionSymbol="&lt;"/>
      <placement repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" maximumDistance="0" layerType="PointGeometry" lineAnchorPercent="0.5" dist="0" lineAnchorType="0" offsetType="1" rotationAngle="0" yOffset="0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" geometryGeneratorType="PointGeometry" fitInPolygonOnly="0" rotationUnit="AngleDegrees" maxCurvedCharAngleIn="25" repeatDistanceUnits="MM" priority="5" overrunDistance="0" xOffset="0" preserveRotation="1" lineAnchorTextPoint="FollowPlacement" quadOffset="4" offsetUnits="MM" maximumDistanceUnit="MM" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" distUnits="MM" centroidInside="0" polygonPlacementFlags="2" placementFlags="10" lineAnchorClipping="0" placement="6" distMapUnitScale="3x:0,0,0,0,0,0" maxCurvedCharAngleOut="-25" prioritization="PreferCloser" overlapHandling="PreventOverlap" maximumDistanceMapUnitScale="3x:0,0,0,0,0,0" centroidWhole="0" geometryGeneratorEnabled="0" repeatDistance="0" allowDegraded="0" overrunDistanceUnit="MM" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" geometryGenerator=""/>
      <rendering obstacleType="1" fontLimitPixelSize="0" minFeatureSize="0" unplacedVisibility="0" labelPerPart="0" scaleVisibility="1" drawLabels="1" obstacle="1" mergeLines="0" fontMaxPixelSize="10000" upsidedownLabels="0" maxNumLabels="2000" fontMinPixelSize="3" limitNumLabels="0" scaleMin="0" obstacleFactor="1" scaleMax="500" zIndex="0"/>
      <dd_properties>
        <Option type="Map">
          <Option value="" name="name" type="QString"/>
          <Option name="properties"/>
          <Option value="collection" name="type" type="QString"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option value="pole_of_inaccessibility" name="anchorPoint" type="QString"/>
          <Option value="0" name="blendMode" type="int"/>
          <Option name="ddProperties" type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
          <Option value="false" name="drawToAllParts" type="bool"/>
          <Option value="0" name="enabled" type="QString"/>
          <Option value="point_on_exterior" name="labelAnchorPoint" type="QString"/>
          <Option value="&lt;symbol alpha=&quot;1&quot; name=&quot;symbol&quot; force_rhr=&quot;0&quot; type=&quot;line&quot; frame_rate=&quot;10&quot; is_animated=&quot;0&quot; clip_to_extent=&quot;1&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer id=&quot;{8b192846-a06f-4f5a-bc59-5574a887e5a5}&quot; enabled=&quot;1&quot; locked=&quot;0&quot; class=&quot;SimpleLine&quot; pass=&quot;0&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;0&quot; name=&quot;align_dash_pattern&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;square&quot; name=&quot;capstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;5;2&quot; name=&quot;customdash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;customdash_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;customdash_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;dash_pattern_offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;dash_pattern_offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;dash_pattern_offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;draw_inside_polygon&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;bevel&quot; name=&quot;joinstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;60,60,60,255,rgb:0.23529411764705882,0.23529411764705882,0.23529411764705882,1&quot; name=&quot;line_color&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;solid&quot; name=&quot;line_style&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0.3&quot; name=&quot;line_width&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;line_width_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;ring_filter&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_end&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_end_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_end_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_start&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_start_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_start_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;tweak_dash_pattern_on_corners&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;use_custom_dash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;width_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
          <Option value="0" name="minLength" type="double"/>
          <Option value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale" type="QString"/>
          <Option value="MM" name="minLengthUnit" type="QString"/>
          <Option value="0" name="offsetFromAnchor" type="double"/>
          <Option value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale" type="QString"/>
          <Option value="MM" name="offsetFromAnchorUnit" type="QString"/>
          <Option value="0" name="offsetFromLabel" type="double"/>
          <Option value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale" type="QString"/>
          <Option value="MM" name="offsetFromLabelUnit" type="QString"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
', true);

CREATE TRIGGER gw_trg_ui_rpt_cat_result INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_ui_rpt_cat_result FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_rpt_cat_result();
