/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/03/2026
CREATE OR REPLACE VIEW ve_inp_dscenario_pattern
AS SELECT p.dscenario_id,
    p.pattern_id,
    p.pattern_type,
    p.observ,
    p.tscode,
    p.tsparameters,
    p.expl_id,
    p.log,
    p.active
FROM inp_dscenario_pattern p
JOIN cat_dscenario d USING (dscenario_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id
	AND s.cur_user = CURRENT_USER
);

CREATE OR REPLACE VIEW ve_inp_dscenario_pattern_value
AS SELECT DISTINCT pv.id,
	p.dscenario_id,
    p.pattern_id,
    p.observ,
    p.tscode,
    p.tsparameters::text AS tsparameters,
    p.expl_id,
    pv.factor_1,
    pv.factor_2,
    pv.factor_3,
    pv.factor_4,
    pv.factor_5,
    pv.factor_6,
    pv.factor_7,
    pv.factor_8,
    pv.factor_9,
    pv.factor_10,
    pv.factor_11,
    pv.factor_12,
    pv.factor_13,
    pv.factor_14,
    pv.factor_15,
    pv.factor_16,
    pv.factor_17,
    pv.factor_18
FROM inp_dscenario_pattern p
JOIN inp_dscenario_pattern_value pv USING (pattern_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id
	AND s.cur_user = CURRENT_USER
) ORDER BY pv.id;


CREATE OR REPLACE VIEW ve_inp_dscenario_demand
AS SELECT
    idd.id,
    idd.dscenario_id,
    idd.feature_id,
    idd.feature_type,
    idd.demand,
    idd.pattern_id,
    idd.demand_type,
    idd.source,
    n.sector_id,
    n.expl_id,
    n.presszone_id,
    n.dma_id,
    n.the_geom
FROM inp_dscenario_demand idd
JOIN node n ON n.node_id = idd.feature_id
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = idd.dscenario_id
	AND s.cur_user = CURRENT_USER
) AND EXISTS (
	SELECT 1
	FROM selector_sector s
	WHERE s.sector_id = n.sector_id
	AND s.cur_user = CURRENT_USER
)
UNION
SELECT
    idd.id,
    idd.dscenario_id,
    idd.feature_id,
    idd.feature_type,
    idd.demand,
    idd.pattern_id,
    idd.demand_type,
    idd.source,
    c.sector_id,
    c.expl_id,
    c.presszone_id,
    c.dma_id,
    c.the_geom
FROM inp_dscenario_demand idd
JOIN connec c ON c.connec_id = idd.feature_id
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = idd.dscenario_id
	AND s.cur_user = CURRENT_USER
) AND EXISTS (
	SELECT 1
	FROM selector_sector s
	WHERE s.sector_id = c.sector_id
	AND s.cur_user = CURRENT_USER
);

CREATE OR REPLACE VIEW ve_epa_valve
AS SELECT inp_valve.node_id,
    inp_valve.valve_type,
    cat_node.dint,
    inp_valve.custom_dint,
    inp_valve.setting,
    inp_valve.curve_id,
    inp_valve.minorloss,
    v.to_arc,
        CASE
            WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN v.broken IS FALSE AND (v.to_arc IS NOT null or inp_valve.valve_type = 'TCV') THEN 'ACTIVE'::character varying(12)
            ELSE 'OPEN'::character varying(12)
        END AS status,
    inp_valve.add_settings,
    inp_valve.init_quality,
    inp_valve.head,
    inp_valve.pattern_id,
    inp_valve.demand,
    inp_valve.demand_pattern_id,
    inp_valve.emitter_coeff,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
   FROM node
     JOIN inp_valve USING (node_id)
     LEFT JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     LEFT JOIN v_rpt_arc_stats ON concat(inp_valve.node_id, '_n2a') = v_rpt_arc_stats.arc_id
     LEFT JOIN man_valve v ON v.node_id = inp_valve.node_id;



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
    mu.region_id,
    mu.province_id,
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
    COALESCE(pp.state, n.state) AS p_state,
    n.uuid,
    n.uncertain,
    n.xyz_date,
	m.to_arc
   FROM node n
     LEFT JOIN LATERAL ( SELECT pp_1.state
           FROM plan_psector_x_node pp_1
          WHERE pp_1.node_id = n.node_id AND (pp_1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER))
          ORDER BY pp_1.psector_id DESC
         LIMIT 1) pp ON true
     JOIN cat_node ON cat_node.id::text = n.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_node.node_type::text
     JOIN value_state_type vst ON vst.id = n.state_type
     JOIN exploitation ON n.expl_id = exploitation.expl_id
     JOIN v_municipality mu ON n.muni_id = mu.muni_id
     JOIN sector_table ON sector_table.sector_id = n.sector_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = n.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = n.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = n.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = n.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = n.omzone_id
     LEFT JOIN node_add ON node_add.node_id = n.node_id
     LEFT JOIN man_valve m ON m.node_id = n.node_id
  WHERE (EXISTS ( SELECT 1
           FROM selector_state ss
          WHERE ss.state_id = COALESCE(pp.state, n.state) AND ss.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_sector ssec
          WHERE ssec.sector_id = n.sector_id AND ssec.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_municipality sm
          WHERE sm.muni_id = n.muni_id AND sm.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_expl se
          WHERE (se.expl_id = ANY (array_append(n.expl_visibility, n.expl_id))) AND se.cur_user = CURRENT_USER));
		  
 
CREATE OR REPLACE VIEW ve_inp_valve
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_valve.valve_type,
    inp_valve.setting,
    inp_valve.curve_id,
    inp_valve.minorloss,
    n.to_arc,
		CASE
            WHEN n.closed_valve IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN n.broken_valve IS FALSE AND (n.to_arc IS NOT NULL OR inp_valve.valve_type::text = 'TCV'::text) THEN 'ACTIVE'::character varying(12)
            ELSE 'OPEN'::character varying(12)
        END AS status,
    n.cat_dint,
    inp_valve.custom_dint,
    inp_valve.add_settings,
    inp_valve.init_quality,
    inp_valve.head,
    inp_valve.pattern_id,
    inp_valve.demand,
    inp_valve.demand_pattern_id,
    inp_valve.emitter_coeff,
    n.the_geom
   FROM ve_node n
     JOIN inp_valve USING (node_id)
  WHERE n.is_operative IS TRUE;



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
    mu.region_id,
    mu.province_id,
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
    COALESCE(pp.state, a.state) AS p_state,
    a.uuid,
    a.uncertain
   FROM arc a
     LEFT JOIN LATERAL ( SELECT pp_1.state
           FROM plan_psector_x_arc pp_1
          WHERE pp_1.arc_id = a.arc_id AND (pp_1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER))
          ORDER BY pp_1.psector_id DESC
         LIMIT 1) pp ON true
     JOIN cat_arc ON cat_arc.id::text = a.arccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arc_type::text
     JOIN exploitation ON a.expl_id = exploitation.expl_id
     JOIN v_municipality mu ON a.muni_id = mu.muni_id
     JOIN sector_table ON sector_table.sector_id = a.sector_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = a.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = a.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = a.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = a.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = a.omzone_id
     LEFT JOIN arc_add ON arc_add.arc_id = a.arc_id
     LEFT JOIN value_state_type vst ON vst.id = a.state_type
  WHERE (EXISTS ( SELECT 1
           FROM selector_state ss
          WHERE ss.state_id = COALESCE(pp.state, a.state) AND ss.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_sector ssec
          WHERE ssec.sector_id = a.sector_id AND ssec.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_municipality sm
          WHERE sm.muni_id = a.muni_id AND sm.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_expl se
          WHERE (se.expl_id = ANY (array_append(a.expl_visibility::integer[], a.expl_id))) AND se.cur_user = CURRENT_USER));



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
    COALESCE(pp.arc_id, c.arc_id) AS arc_id,
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
    dma_table.dma_type::character varying AS dma_type,
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
    mu.region_id,
    mu.province_id,
    c.block_code,
	c.plot_id,
    c.workcat_id,
    c.workcat_id_end,
    c.workcat_id_plan,
    c.builtdate,
    c.enddate,
    c.ownercat_id,
    COALESCE(pp.exit_id, c.pjoint_id) AS pjoint_id,
    COALESCE(pp.exit_type, c.pjoint_type) AS pjoint_type,
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
    COALESCE(pp.state, c.state) AS p_state,
    c.uuid,
    c.uncertain,
    c.xyz_date
   FROM connec c
     LEFT JOIN LATERAL ( SELECT pp_1.state,
            pp_1.arc_id,
            l.exit_id,
            l.exit_type
           FROM plan_psector_x_connec pp_1
            LEFT JOIN link l ON l.link_id = pp_1.link_id AND l.state = 2
          WHERE pp_1.connec_id = c.connec_id AND (pp_1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER))
          ORDER BY pp_1.psector_id DESC, pp_1.state DESC
         LIMIT 1) pp ON true
     JOIN cat_connec ON cat_connec.id::text = c.conneccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_connec.connec_type::text
     JOIN exploitation ON c.expl_id = exploitation.expl_id
     JOIN v_municipality mu ON c.muni_id = mu.muni_id
     JOIN sector_table ON sector_table.sector_id = c.sector_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = c.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = c.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = c.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = c.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = c.omzone_id
     LEFT JOIN crmzone ON crmzone.crmzone_id = c.crmzone_id
     LEFT JOIN connec_add ON connec_add.connec_id = c.connec_id
     LEFT JOIN value_state_type vst ON vst.id = c.state_type
     LEFT JOIN inp_network_mode ON true
  WHERE (EXISTS ( SELECT 1
           FROM selector_state ss
          WHERE ss.state_id = COALESCE(pp.state, c.state) AND ss.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_sector ssec
          WHERE ssec.sector_id = c.sector_id AND ssec.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_municipality sm
          WHERE sm.muni_id = c.muni_id AND sm.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_expl se
          WHERE (se.expl_id = ANY (array_append(c.expl_visibility::integer[], c.expl_id))) AND se.cur_user = CURRENT_USER));



CREATE OR REPLACE VIEW v_rtc_hydrometer_x_node
AS WITH sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT ext_rtc_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    COALESCE(node.node_id, NULL::integer) AS node_id,
    COALESCE(ext_rtc_hydrometer.customer_code::character varying, 'XXXX'::character varying) AS node_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    v_municipality.name AS muni_name,
    node.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN ext_rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), ext_rtc_hydrometer.link)
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.customer_code::text
     JOIN node ON node.node_id = man_netwjoin.node_id
     LEFT JOIN v_municipality ON v_municipality.muni_id = node.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = node.expl_id));



CREATE OR REPLACE VIEW v_rtc_hydrometer_x_connec
AS WITH sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT ext_rtc_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    COALESCE(connec.connec_id, NULL::integer) AS connec_id,
    COALESCE(ext_rtc_hydrometer.customer_code::character varying, 'XXXX'::character varying) AS connec_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    v_municipality.name AS muni_name,
    connec.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN ext_rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), ext_rtc_hydrometer.link)
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.customer_code::text
     LEFT JOIN v_municipality ON v_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = connec.expl_id));



CREATE OR REPLACE VIEW v_rtc_hydrometer
AS WITH sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        ), node_data AS (
         SELECT ext_rtc_hydrometer.hydrometer_id,
            node.node_id,
            node.expl_id,
            exploitation.name AS expl_name,
            v_municipality.name AS muni_name
           FROM ext_rtc_hydrometer
             JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.customer_code::text
             JOIN node ON node.node_id = man_netwjoin.node_id
             LEFT JOIN v_municipality ON v_municipality.muni_id = node.muni_id
             LEFT JOIN exploitation ON exploitation.expl_id = node.expl_id
        ), connec_data AS (
         SELECT ext_rtc_hydrometer.hydrometer_id,
            connec.connec_id,
            connec.expl_id,
            exploitation.name AS expl_name,
            v_municipality.name AS muni_name
           FROM ext_rtc_hydrometer
             JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.customer_code::text
             LEFT JOIN v_municipality ON v_municipality.muni_id = connec.muni_id
             LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
        ), feature_data AS (
         SELECT connec_data.hydrometer_id,
            connec_data.connec_id AS feature_id,
            'CONNEC'::text AS feature_type,
            connec_data.expl_name,
            connec_data.muni_name,
            connec_data.expl_id
           FROM connec_data
        UNION
         SELECT node_data.hydrometer_id,
            node_data.node_id AS feature_id,
            'NODE'::text AS feature_type,
            node_data.expl_name,
            node_data.muni_name,
            node_data.expl_id
           FROM node_data
        )
 SELECT ext_rtc_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    d.feature_id,
    d.feature_type,
    COALESCE(ext_rtc_hydrometer.customer_code, 'XXXX'::character varying(30)) AS customer_code,
    ext_rtc_hydrometer_state.name AS state,
    d.muni_name,
    d.expl_id,
    d.expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN ext_rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), ext_rtc_hydrometer.link)
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
   FROM feature_data d
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.hydrometer_id = d.hydrometer_id
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = d.expl_id));



CREATE OR REPLACE VIEW v_ui_hydrometer
AS SELECT v_rtc_hydrometer.hydrometer_id,
    v_rtc_hydrometer.feature_id,
    v_rtc_hydrometer.hydrometer_customer_code,
    v_rtc_hydrometer.customer_code AS feature_customer_code,
    v_rtc_hydrometer.state,
    v_rtc_hydrometer.expl_name,
    v_rtc_hydrometer.hydrometer_link
   FROM v_rtc_hydrometer;


CREATE OR REPLACE VIEW v_ui_hydroval_x_connec
AS SELECT ext_rtc_hydrometer_x_data.id,
    connec.connec_id,
    connec.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.catalog_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum,
    crmtype.idval AS value_type,
    crmstatus.idval AS value_status,
    crmstate.idval AS value_state
   FROM ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id = ext_rtc_hydrometer.hydrometer_id
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.catalog_id::text
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.customer_code::text
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
  ORDER BY ext_rtc_hydrometer_x_data.id;


CREATE OR REPLACE VIEW v_ui_hydroval
AS SELECT ext_rtc_hydrometer_x_data.id,
    node.node_id AS feature_id,
    node.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    ext_rtc_hydrometer.catalog_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum,
    crmtype.idval AS value_type,
    crmstatus.idval AS value_status,
    crmstate.idval AS value_state
   FROM ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id = ext_rtc_hydrometer.hydrometer_id
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.catalog_id::text
     JOIN man_netwjoin ON man_netwjoin.customer_code::text = ext_rtc_hydrometer.customer_code::text
     JOIN node ON node.node_id = man_netwjoin.node_id
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
UNION
 SELECT ext_rtc_hydrometer_x_data.id,
    connec.connec_id AS feature_id,
    connec.arc_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    ext_rtc_hydrometer.catalog_id,
    ext_cat_hydrometer.madeby,
    ext_cat_hydrometer.class,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum,
    crmtype.idval AS value_type,
    crmstatus.idval AS value_status,
    crmstate.idval AS value_state
   FROM ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id = ext_rtc_hydrometer.hydrometer_id
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.catalog_id::text
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.customer_code::text
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text;


CREATE OR REPLACE VIEW v_om_mincut
AS WITH sel_mincut_result AS (
         SELECT selector_mincut_result.result_id
           FROM selector_mincut_result
          WHERE selector_mincut_result.cur_user = CURRENT_USER
        )
 SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    v_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    v_streetaxis.name AS street_name,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_the_geom,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output,
    om_mincut.reagent_lot,
    om_mincut.equipment_code,
    om_mincut.shutoff_required
   FROM om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON om_mincut.expl_id = exploitation.expl_id
     LEFT JOIN v_streetaxis ON om_mincut.streetaxis_id::text = v_streetaxis.id::text
     LEFT JOIN macroexploitation ON om_mincut.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN v_municipality ON om_mincut.muni_id = v_municipality.muni_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_mincut_result
          WHERE sel_mincut_result.result_id = om_mincut.id)) AND om_mincut.id > 0;


CREATE OR REPLACE VIEW v_om_mincut_initpoint
AS WITH sel_mincut_result AS (
         SELECT selector_mincut_result.result_id,
            selector_mincut_result.result_type
           FROM selector_mincut_result
          WHERE selector_mincut_result.cur_user = CURRENT_USER
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
    v_municipality.name AS muni_name,
    om.postcode,
    om.streetaxis_id,
    v_streetaxis.name AS street_name,
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
    sm.result_type,
    om.shutoff_required
   FROM om_mincut om
     LEFT JOIN om_typevalue a ON a.id::integer = om.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON om.expl_id = exploitation.expl_id
     LEFT JOIN v_streetaxis ON om.streetaxis_id::text = v_streetaxis.id::text
     LEFT JOIN macroexploitation ON om.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN v_municipality ON om.muni_id = v_municipality.muni_id
     LEFT JOIN sel_mincut_result sm ON sm.result_id = om.id AND om.id > 0;



CREATE OR REPLACE VIEW v_om_mincut_polygon
AS WITH sel_mincut_result AS (
         SELECT selector_mincut_result.result_id
           FROM selector_mincut_result
          WHERE selector_mincut_result.cur_user = CURRENT_USER
        )
 SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    v_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    v_streetaxis.name AS street_name,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_the_geom,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output,
    om_mincut.reagent_lot,
    om_mincut.equipment_code,
    om_mincut.polygon_the_geom,
    om_mincut.shutoff_required
   FROM om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON om_mincut.expl_id = exploitation.expl_id
     LEFT JOIN v_streetaxis ON om_mincut.streetaxis_id::text = v_streetaxis.id::text
     LEFT JOIN macroexploitation ON om_mincut.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN v_municipality ON om_mincut.muni_id = v_municipality.muni_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_mincut_result
          WHERE sel_mincut_result.result_id = om_mincut.id)) AND om_mincut.id > 0;


CREATE OR REPLACE VIEW v_ui_mincut
AS SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    exploitation.name AS exploitation,
    v_municipality.name AS municipality,
    om_mincut.postcode,
    v_streetaxis.name AS streetaxis,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    cat_users.name AS assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output,
    om_mincut.reagent_lot,
    om_mincut.equipment_code,
    om_mincut.shutoff_required
   FROM om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON exploitation.expl_id = om_mincut.expl_id
     LEFT JOIN macroexploitation ON macroexploitation.macroexpl_id = om_mincut.macroexpl_id
     LEFT JOIN v_municipality ON v_municipality.muni_id = om_mincut.muni_id
     LEFT JOIN v_streetaxis ON v_streetaxis.id::text = om_mincut.streetaxis_id::text
     LEFT JOIN cat_users ON cat_users.id::text = om_mincut.assigned_to::text
  WHERE om_mincut.id > 0;


DROP VIEW IF EXISTS ve_link;
CREATE OR REPLACE VIEW ve_link AS
WITH typevalue AS (
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
    COALESCE(pp.state, l.state) AS p_state,
    l.uuid
   FROM link l
     LEFT JOIN connec c ON c.connec_id = l.feature_id
     LEFT JOIN LATERAL ( SELECT pp1.connec_id,
            pp1.psector_id
           FROM plan_psector_x_connec pp1
          WHERE (pp1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER)) AND pp1.connec_id = l.feature_id
          ORDER BY pp1.psector_id DESC
         LIMIT 1) last_ps ON true
     LEFT JOIN LATERAL ( SELECT pp2.state
           FROM plan_psector_x_connec pp2
          WHERE pp2.link_id = l.link_id AND pp2.psector_id = last_ps.psector_id
         LIMIT 1) pp ON true
     JOIN sector_table ON sector_table.sector_id = l.sector_id
     JOIN cat_link ON cat_link.id::text = l.linkcat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_link.link_type::text
     JOIN exploitation ON l.expl_id = exploitation.expl_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = l.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = l.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = l.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = l.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = l.omzone_id
     LEFT JOIN inp_network_mode ON true
  WHERE (EXISTS ( SELECT 1
           FROM selector_state ss
          WHERE ss.state_id = COALESCE(pp.state, l.state) AND ss.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_sector ssec
          WHERE ssec.sector_id = l.sector_id AND ssec.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_municipality sm
          WHERE sm.muni_id = l.muni_id AND sm.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_expl se
          WHERE (se.expl_id = ANY (array_append(l.expl_visibility::integer[], l.expl_id))) AND se.cur_user = CURRENT_USER));
		  


CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end
AS SELECT row_number() OVER (ORDER BY ve_arc.arc_id) + 1000000 AS rid,
    'ARC'::character varying AS feature_type,
    ve_arc.arccat_id AS featurecat_id,
    ve_arc.arc_id AS feature_id,
    ve_arc.code,
    exploitation.name AS expl_name,
    ve_arc.workcat_id_end,
    exploitation.expl_id
   FROM ve_arc
     JOIN exploitation ON exploitation.expl_id = ve_arc.expl_id
  WHERE ve_arc.state = 0
UNION
 SELECT row_number() OVER (ORDER BY ve_node.node_id) + 2000000 AS rid,
    'NODE'::character varying AS feature_type,
    ve_node.nodecat_id AS featurecat_id,
    ve_node.node_id AS feature_id,
    ve_node.code,
    exploitation.name AS expl_name,
    ve_node.workcat_id_end,
    exploitation.expl_id
   FROM ve_node
     JOIN exploitation ON exploitation.expl_id = ve_node.expl_id
  WHERE ve_node.state = 0
UNION
 SELECT row_number() OVER (ORDER BY ve_connec.connec_id) + 3000000 AS rid,
    'CONNEC'::character varying AS feature_type,
    ve_connec.conneccat_id AS featurecat_id,
    ve_connec.connec_id AS feature_id,
    ve_connec.code,
    exploitation.name AS expl_name,
    ve_connec.workcat_id_end,
    exploitation.expl_id
   FROM ve_connec
     JOIN exploitation ON exploitation.expl_id = ve_connec.expl_id
  WHERE ve_connec.state = 0
UNION
 SELECT row_number() OVER (ORDER BY element.element_id) + 4000000 AS rid,
    'ELEMENT'::character varying AS feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id_end,
    exploitation.expl_id
   FROM element
     JOIN exploitation ON exploitation.expl_id = element.expl_id
  WHERE element.state = 0;







CREATE OR REPLACE VIEW ve_inp_connec
AS SELECT ve_connec.connec_id,
    ve_connec.top_elev,
    ve_connec.depth,
    ve_connec.conneccat_id,
    ve_connec.arc_id,
    ve_connec.expl_id,
    ve_connec.sector_id,
    ve_connec.dma_id,
    ve_connec.state,
    ve_connec.state_type,
    ve_connec.pjoint_type,
    ve_connec.pjoint_id,
    ve_connec.annotation,
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
    ve_connec.the_geom
   FROM ve_connec
     JOIN inp_connec USING (connec_id)
  WHERE ve_connec.is_operative IS TRUE;



CREATE OR REPLACE VIEW ve_inp_dscenario_connec
AS SELECT d.dscenario_id,
    connec.connec_id,
    connec.pjoint_type,
    connec.pjoint_id,
    c.demand,
    c.pattern_id,
    c.peak_factor,
    c.status,
    c.minorloss,
    c.custom_roughness,
    c.custom_length,
    c.custom_dint,
    c.emitter_coeff,
    c.init_quality,
    c.source_type,
    c.source_quality,
    c.source_pattern_id,
    connec.the_geom
   FROM ve_inp_connec connec
     JOIN inp_dscenario_connec c USING (connec_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE (EXISTS ( SELECT 1
           FROM selector_inp_dscenario s
          WHERE s.dscenario_id = c.dscenario_id AND s.cur_user = CURRENT_USER));



CREATE OR REPLACE VIEW v_ui_arc_x_relations
AS WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM node n
             JOIN link l ON n.node_id = l.exit_id
          WHERE l.state = 1
        )
 SELECT row_number() OVER () + 1000000 AS rid,
    ve_connec.arc_id,
    ve_connec.connec_type AS featurecat_id,
    ve_connec.conneccat_id AS catalog,
    ve_connec.connec_id AS feature_id,
    ve_connec.code AS feature_code,
    ve_connec.sys_type,
    a.state AS arc_state,
    ve_connec.state AS feature_state,
    st_x(ve_connec.the_geom) AS x,
    st_y(ve_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    've_connec'::text AS sys_table_id
   FROM ve_connec
     JOIN link l ON ve_connec.connec_id = l.feature_id
     JOIN arc a ON a.arc_id = ve_connec.arc_id
  WHERE ve_connec.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (c.connec_id) row_number() OVER () + 2000000 AS rid,
    a.arc_id,
    c.connec_type AS featurecat_id,
    c.conneccat_id AS catalog,
    c.connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    a.state AS arc_state,
    c.state AS feature_state,
    st_x(c.the_geom) AS x,
    st_y(c.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    've_connec'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1 = n.node_id
     JOIN ve_connec c ON c.connec_id = n.feature_id;


CREATE OR REPLACE VIEW v_plan_arc
AS SELECT arc_id,
    node_1,
    node_2,
    arc_type,
    arccat_id,
    epa_type,
    state,
    sector_id,
    expl_id,
    annotation,
    soilcat_id,
    y1,
    y2,
    mean_y,
    z1,
    z2,
    thickness,
    width,
    b,
    bulk,
    geom1,
    area,
    y_param,
    total_y,
    rec_y,
    geom1_ext,
    calculed_y,
    m3mlexc,
    m2mltrenchl,
    m2mlbottom,
    m2mlpav,
    m3mlprotec,
    m3mlfill,
    m3mlexcess,
    m3exc_cost,
    m2trenchl_cost,
    m2bottom_cost,
    m2pav_cost,
    m3protec_cost,
    m3fill_cost,
    m3excess_cost,
    cost_unit,
    pav_cost,
    exc_cost,
    trenchl_cost,
    base_cost,
    protec_cost,
    fill_cost,
    excess_cost,
    arc_cost,
    cost,
    length,
    budget,
    other_budget,
    total_budget,
    the_geom
   FROM ( WITH v_plan_aux_arc_cost AS (
                 WITH v_plan_aux_arc_ml AS (
                         SELECT ve_arc.arc_id,
                            ve_arc.depth1,
                            ve_arc.depth2,
                                CASE
                                    WHEN (ve_arc.depth1 * ve_arc.depth2) = 0::numeric OR (ve_arc.depth1 * ve_arc.depth2) IS NULL THEN v_price_x_catarc.estimated_depth
                                    ELSE ((ve_arc.depth1 + ve_arc.depth2) / 2::numeric)::numeric(12,2)
                                END AS mean_depth,
                            ve_arc.arccat_id,
                            COALESCE(v_price_x_catarc.dint / 1000::numeric, 0::numeric)::numeric(12,4) AS dint,
                            COALESCE(v_price_x_catarc.z1, 0::numeric)::numeric(12,2) AS z1,
                            COALESCE(v_price_x_catarc.z2, 0::numeric)::numeric(12,2) AS z2,
                            COALESCE(v_price_x_catarc.area, 0::numeric)::numeric(12,4) AS area,
                            COALESCE(v_price_x_catarc.width, 0::numeric)::numeric(12,2) AS width,
                            COALESCE(v_price_x_catarc.thickness / 1000::numeric, 0::numeric)::numeric(12,4) AS bulk,
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
                            ve_arc.state,
                            ve_arc.expl_id,
                            ve_arc.the_geom
                           FROM ve_arc
                             LEFT JOIN v_price_x_catarc ON ve_arc.arccat_id::text = v_price_x_catarc.id::text
                             LEFT JOIN v_price_x_catsoil ON ve_arc.soilcat_id::text = v_price_x_catsoil.id::text
                             LEFT JOIN v_plan_aux_arc_pavement ON v_plan_aux_arc_pavement.arc_id = ve_arc.arc_id
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
             JOIN arc ON arc.arc_id = v_plan_aux_arc_cost.arc_id
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (p.price * count(*)::numeric)::numeric(12,2) AS connec_total_cost
                   FROM ve_connec c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  WHERE c.arc_id IS NOT NULL
                  GROUP BY c.arc_id, p.price) v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id = v_plan_aux_arc_cost.arc_id) d
  WHERE arc_id IS NOT NULL;
  
  
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
            a.arc_type,
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
            a.thickness,
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_type_1, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
    p.m2mlpav AS measurement,
    p.m2mlpav*a.m2pav_cost AS total_cost,
    p.length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN v_plan_aux_arc_pavement a ON a.arc_id = p.arc_id
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
    count(ve_connec.connec_id) AS measurement,
    (min(v.price) * count(ve_connec.connec_id)::numeric / COALESCE(min(p.length), 1::numeric))::numeric(12,2) AS total_cost,
    min(p.length)::numeric(12,2) AS length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, act_type, matcat_id, pnom, dnom, dint, dext, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, shape, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN ve_connec USING (arc_id)
     JOIN v_price_compost v ON p.cat_connect_cost = v.id::text
  GROUP BY p.arc_id
  ORDER BY 1, 2;


CREATE OR REPLACE VIEW v_plan_result_arc
AS SELECT plan_rec_result_arc.arc_id,
    plan_rec_result_arc.node_1,
    plan_rec_result_arc.node_2,
    plan_rec_result_arc.arc_type,
    plan_rec_result_arc.arccat_id,
    plan_rec_result_arc.epa_type,
    plan_rec_result_arc.sector_id,
    plan_rec_result_arc.expl_id,
    plan_rec_result_arc.state,
    plan_rec_result_arc.annotation,
    plan_rec_result_arc.soilcat_id,
    plan_rec_result_arc.y1,
    plan_rec_result_arc.y2,
    plan_rec_result_arc.mean_y,
    plan_rec_result_arc.z1,
    plan_rec_result_arc.z2,
    plan_rec_result_arc.thickness,
    plan_rec_result_arc.width,
    plan_rec_result_arc.b,
    plan_rec_result_arc.bulk,
    plan_rec_result_arc.geom1,
    plan_rec_result_arc.area,
    plan_rec_result_arc.y_param,
    plan_rec_result_arc.total_y,
    plan_rec_result_arc.rec_y,
    plan_rec_result_arc.geom1_ext,
    plan_rec_result_arc.calculed_y,
    plan_rec_result_arc.m3mlexc,
    plan_rec_result_arc.m2mltrenchl,
    plan_rec_result_arc.m2mlbottom,
    plan_rec_result_arc.m2mlpav,
    plan_rec_result_arc.m3mlprotec,
    plan_rec_result_arc.m3mlfill,
    plan_rec_result_arc.m3mlexcess,
    plan_rec_result_arc.m3exc_cost,
    plan_rec_result_arc.m2trenchl_cost,
    plan_rec_result_arc.m2bottom_cost,
    plan_rec_result_arc.m2pav_cost,
    plan_rec_result_arc.m3protec_cost,
    plan_rec_result_arc.m3fill_cost,
    plan_rec_result_arc.m3excess_cost,
    plan_rec_result_arc.cost_unit,
    plan_rec_result_arc.pav_cost,
    plan_rec_result_arc.exc_cost,
    plan_rec_result_arc.trenchl_cost,
    plan_rec_result_arc.base_cost,
    plan_rec_result_arc.protec_cost,
    plan_rec_result_arc.fill_cost,
    plan_rec_result_arc.excess_cost,
    plan_rec_result_arc.arc_cost,
    plan_rec_result_arc.cost,
    plan_rec_result_arc.length,
    plan_rec_result_arc.budget,
    plan_rec_result_arc.other_budget,
    plan_rec_result_arc.total_budget,
    plan_rec_result_arc.the_geom,
    plan_rec_result_arc.builtcost,
    plan_rec_result_arc.builtdate,
    plan_rec_result_arc.age,
    plan_rec_result_arc.acoeff,
    plan_rec_result_arc.aperiod,
    plan_rec_result_arc.arate,
    plan_rec_result_arc.amortized,
    plan_rec_result_arc.pending
   FROM selector_plan_result,
    plan_rec_result_arc
  WHERE plan_rec_result_arc.result_id::text = selector_plan_result.result_id::text AND selector_plan_result.cur_user = CURRENT_USER AND plan_rec_result_arc.state = 1
UNION
 SELECT v_plan_arc.arc_id,
    v_plan_arc.node_1,
    v_plan_arc.node_2,
    v_plan_arc.arc_type,
    v_plan_arc.arccat_id,
    v_plan_arc.epa_type,
    v_plan_arc.sector_id,
    v_plan_arc.expl_id,
    v_plan_arc.state,
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
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_arc
  WHERE v_plan_arc.state = 2;


CREATE OR REPLACE VIEW v_plan_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
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
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  WHERE plan_psector_x_arc.doable IS TRUE
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id = v_plan_node.node_id
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  WHERE plan_psector_x_node.doable IS TRUE
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_plan_current_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric)::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec,
    plan_psector.vat,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM config_param_user,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
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
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id = v_plan_node.node_id
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE config_param_user.cur_user::text = CURRENT_USER AND config_param_user.parameter::text = 'plan_psector_current'::text AND config_param_user.value::integer = plan_psector.psector_id;


CREATE OR REPLACE VIEW v_plan_psector_budget
AS SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    'arc'::text AS feature_type,
    v_plan_arc.arccat_id AS featurecat_id,
    v_plan_arc.arc_id AS feature_id,
    v_plan_arc.length,
    (v_plan_arc.total_budget / v_plan_arc.length)::numeric(14,2) AS unitary_cost,
    v_plan_arc.total_budget
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
  WHERE plan_psector_x_arc.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_plan_node.node_id) + 9999 AS rid,
    plan_psector_x_node.psector_id,
    'node'::text AS feature_type,
    v_plan_node.nodecat_id AS featurecat_id,
    v_plan_node.node_id AS feature_id,
    1 AS length,
    v_plan_node.budget AS unitary_cost,
    v_plan_node.budget AS total_budget
   FROM v_plan_node
     JOIN plan_psector_x_node ON plan_psector_x_node.node_id = v_plan_node.node_id
  WHERE plan_psector_x_node.doable = true
UNION
 SELECT row_number() OVER (ORDER BY ve_plan_psector_x_other.id) + 19999 AS rid,
    ve_plan_psector_x_other.psector_id,
    'other'::text AS feature_type,
    ve_plan_psector_x_other.price_id AS featurecat_id,
    NULL::integer AS feature_id,
    ve_plan_psector_x_other.measurement AS length,
    ve_plan_psector_x_other.price AS unitary_cost,
    ve_plan_psector_x_other.total_budget
   FROM ve_plan_psector_x_other
  ORDER BY 1, 2, 4;


CREATE OR REPLACE VIEW v_plan_psector_budget_arc
AS SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    plan_psector.psector_type,
    v_plan_arc.arc_id,
    v_plan_arc.arccat_id,
    v_plan_arc.cost_unit,
    v_plan_arc.cost::numeric(14,2) AS cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.state,
    plan_psector.expl_id,
    plan_psector.atlas_id,
    plan_psector_x_arc.doable,
    plan_psector.priority,
    v_plan_arc.the_geom
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
  WHERE plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id;


CREATE OR REPLACE VIEW v_plan_psector_budget_detail
AS SELECT v_plan_arc.arc_id,
    plan_psector_x_arc.psector_id,
    v_plan_arc.arccat_id,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.arc_cost AS mlarc_cost,
    v_plan_arc.m3mlexc,
    v_plan_arc.exc_cost AS mlexc_cost,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.trenchl_cost AS mltrench_cost,
    v_plan_arc.m2mlbottom AS m2mlbase,
    v_plan_arc.base_cost AS mlbase_cost,
    v_plan_arc.m2mlpav,
    v_plan_arc.pav_cost AS mlpav_cost,
    v_plan_arc.m3mlprotec,
    v_plan_arc.protec_cost AS mlprotec_cost,
    v_plan_arc.m3mlfill,
    v_plan_arc.fill_cost AS mlfill_cost,
    v_plan_arc.m3mlexcess,
    v_plan_arc.excess_cost AS mlexcess_cost,
    v_plan_arc.cost AS mltotal_cost,
    v_plan_arc.length,
    v_plan_arc.budget AS other_budget,
    v_plan_arc.total_budget
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
  WHERE plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id, v_plan_arc.soilcat_id, v_plan_arc.arccat_id;

  
-- v_plan_psector_all source
CREATE OR REPLACE VIEW v_plan_psector_all
AS WITH sel_psector AS (
         SELECT selector_psector.psector_id
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        )
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2)::double precision + ((100::numeric + plan_psector.vat) / 100::numeric * (plan_psector.other / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
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
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id = v_plan_node.node_id
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_psector
          WHERE sel_psector.psector_id = plan_psector.psector_id));
		  
		  
CREATE OR REPLACE VIEW v_edit_connec
AS WITH sel_state AS (
      	SELECT selector_state.state_id FROM selector_state WHERE selector_state.cur_user = CURRENT_USER
    ),
    sel_sector AS (
		SELECT selector_sector.sector_id FROM selector_sector WHERE selector_sector.cur_user = CURRENT_USER
    ),
    sel_expl AS (
      	SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
    ),
    sel_muni AS (
      	SELECT selector_municipality.muni_id FROM selector_municipality WHERE selector_municipality.cur_user = CURRENT_USER
    ),
    sel_ps AS (
      	SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
    ),
    typevalue AS (
		SELECT edit_typevalue.typevalue, edit_typevalue.id, edit_typevalue.idval
		FROM edit_typevalue
		WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
	),
    sector_table AS (
        SELECT sector_id, macrosector_id, stylesheet, id::varchar(16) AS sector_type
        FROM sector
        LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
	),
    dma_table AS (
        SELECT dma_id, macrodma_id, stylesheet, id::varchar(16) AS dma_type
        FROM dma
        LEFT JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
	),
    presszone_table AS (
        SELECT presszone_id, head AS presszone_head, stylesheet, id::varchar(16) AS presszone_type
        FROM presszone
        LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
	),
    dqa_table AS (
        SELECT dqa_id, stylesheet, id::varchar(16) AS dqa_type, macrodqa_id
        FROM dqa
        LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type AND t.typevalue::text = 'dqa_type'::text
	),
    supplyzone_table AS (
        SELECT supplyzone_id, stylesheet, id::varchar(16) AS supplyzone_type
        FROM supplyzone
        LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type AND t.typevalue::text = 'supplyzone_type'::text
      ),
    omzone_table AS (
        SELECT omzone_id, id::varchar(16) AS omzone_type, macroomzone_id
        FROM omzone
        LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type AND t.typevalue::text = 'omzone_type'::text
	),
    inp_network_mode AS (
        SELECT value FROM config_param_user WHERE parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
	),
    link_planned as (
        SELECT link_id, feature_id, feature_type, exit_id, exit_type, l.expl_id, macroexpl_id, l.sector_id, sector_type, macrosector_id,
        l.dma_id, dma_type, l.omzone_id, omzone_type, macrodma_id, l.presszone_id, presszone_type, presszone_head, l.dqa_id, dqa_type, dqa_table.macrodqa_id,
        l.supplyzone_id, supplyzone_type, fluid_type,
        minsector_id, staticpressure1 AS staticpressure
        FROM link l
        JOIN exploitation USING (expl_id)
        JOIN sector_table ON sector_table.sector_id = l.sector_id
        LEFT JOIN presszone_table ON presszone_table.presszone_id = l.presszone_id
        LEFT JOIN dma_table ON dma_table.dma_id = l.dma_id
        LEFT JOIN dqa_table ON dqa_table.dqa_id = l.dqa_id
        LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = l.supplyzone_id
        LEFT JOIN omzone_table ON omzone_table.omzone_id = l.omzone_id
        WHERE l.state = 2
	),
    connec_psector AS (
        SELECT DISTINCT ON (pp.connec_id, pp.state) pp.connec_id, pp.state AS p_state, pp.psector_id, pp.arc_id, pp.link_id
        FROM plan_psector_x_connec pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
	),
    connec_selector AS (
        SELECT c.connec_id, c.arc_id, NULL::integer AS link_id
        FROM connec c
		WHERE EXISTS ((SELECT 1 FROM sel_state s WHERE s.state_id = c.state))
		AND EXISTS ((SELECT 1 FROM sel_sector s WHERE s.sector_id = c.sector_id))
		AND EXISTS ((SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(expl_visibility, c.expl_id))))
		AND EXISTS ((SELECT 1 FROM sel_muni s WHERE s.muni_id = c.muni_id))
		AND NOT (
			EXISTS (
				SELECT 1
				FROM connec_psector cp
				WHERE cp.connec_id = c.connec_id AND cp.p_state = 0
			)
		)
		UNION ALL
		SELECT cp.connec_id, cp.arc_id, cp.link_id
		FROM connec_psector cp
		WHERE cp.p_state = 1
	),
    connec_selected AS (
        SELECT
			connec.connec_id,
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
			WHEN link_planned.dma_type IS NULL then dma_table.dma_type
			ELSE link_planned.dma_type::varchar
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
			ELSE link_planned.fluid_type::character varying(50)
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
			streetaxis_id,
			connec.postnumber,
			connec.postcomplement,
			streetaxis2_id,
			connec.postnumber2,
			connec.postcomplement2,
			mu.region_id,
			mu.province_id,
			connec.block_code,
			connec.plot_id,
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
			WHEN connec.sector_id > 0 AND vst.is_operative = true AND connec.epa_type = 'JUNCTION'::text AND inp_network_mode.value = '4'::text THEN connec.epa_type::character varying
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
			(SELECT ST_X(connec.the_geom)) AS xcoord,
			(SELECT ST_Y(connec.the_geom)) AS ycoord,
			(SELECT ST_Y(ST_Transform(connec.the_geom, 4326))) AS lat,
			(SELECT ST_X(ST_Transform(connec.the_geom, 4326))) AS long,
			date_trunc('second'::text, connec.created_at) AS created_at,
			connec.created_by,
			date_trunc('second'::text, connec.updated_at) AS updated_at,
			connec.updated_by,
			connec.the_geom
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
		LEFT JOIN crmzone ON crmzone.crmzone_id = connec.crmzone_id
		LEFT JOIN link_planned USING (link_id)
		LEFT JOIN connec_add ON connec_add.connec_id = connec.connec_id
		LEFT JOIN value_state_type vst ON vst.id = connec.state_type
		LEFT JOIN inp_network_mode ON true
	)
    SELECT c.*
    FROM connec_selected c;

-- 02/04/2026
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
    n.name,
    n.code,
    n.descript,
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


CREATE OR REPLACE VIEW v_ui_mincut_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.hydrometer_id,
    connec.connec_id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut.mincut_state,
    om_mincut.mincut_class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_appropiate,
        CASE
            WHEN om_mincut.mincut_state = 0 THEN om_mincut.forecast_start::timestamp with time zone
            WHEN om_mincut.mincut_state = 1 THEN now()
            WHEN om_mincut.mincut_state = 2 THEN om_mincut.exec_start::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS start_date,
        CASE
            WHEN om_mincut.mincut_state = 0 THEN om_mincut.forecast_end::timestamp with time zone
            WHEN om_mincut.mincut_state = 1 THEN now()
            WHEN om_mincut.mincut_state = 2 THEN om_mincut.exec_end::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS end_date,
    om_mincut.shutoff_required
   FROM om_mincut_hydrometer
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.hydrometer_id::text = om_mincut_hydrometer.hydrometer_id::text
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.customer_code::text;


CREATE OR REPLACE VIEW v_om_mincut_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    connec.connec_id,
    connec.code AS connec_code
   FROM selector_mincut_result,
    om_mincut_hydrometer
     JOIN ext_rtc_hydrometer ON om_mincut_hydrometer.hydrometer_id = ext_rtc_hydrometer.hydrometer_id
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.customer_code::text
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_hydrometer.result_id::text AND selector_mincut_result.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW ve_rtc_hydro_data_x_connec
AS SELECT ext_rtc_hydrometer_x_data.id,
    connec.connec_id,
    ext_rtc_hydrometer_x_data.hydrometer_id,
    ext_rtc_hydrometer.code,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer_x_data.cat_period_id,
    ext_cat_period.code AS cat_period_code,
    ext_rtc_hydrometer_x_data.value_date,
    ext_rtc_hydrometer_x_data.sum,
    ext_rtc_hydrometer_x_data.custom_sum
   FROM ext_rtc_hydrometer_x_data
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.hydrometer_id::bigint
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::bigint = ext_rtc_hydrometer.catalog_id::bigint
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.customer_code::text
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
  ORDER BY ext_rtc_hydrometer_x_data.hydrometer_id, ext_rtc_hydrometer_x_data.cat_period_id DESC;


CREATE OR REPLACE VIEW v_om_mincut_current_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    connec.connec_id,
    connec.code AS connec_code
   FROM om_mincut_hydrometer
     JOIN ext_rtc_hydrometer ON om_mincut_hydrometer.hydrometer_id = ext_rtc_hydrometer.hydrometer_id
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.customer_code::text
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
  WHERE om_mincut.mincut_state = 1;

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
    n.name,
    n.code,
    n.descript,
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


-- NOTE: ve_arc
CREATE OR REPLACE VIEW ve_arc AS 
WITH typevalue AS (
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
    mu.region_id,
    mu.province_id,
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
    COALESCE(pp.state, a.state) AS p_state,
    a.uuid,
    a.uncertain
   FROM arc a
     LEFT JOIN LATERAL ( SELECT pp_1.state
           FROM plan_psector_x_arc pp_1
          WHERE pp_1.arc_id = a.arc_id AND (pp_1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER))
          ORDER BY pp_1.psector_id DESC
         LIMIT 1) pp ON true
     JOIN cat_arc ON cat_arc.id::text = a.arccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arc_type::text
     JOIN exploitation ON a.expl_id = exploitation.expl_id
     JOIN ext_municipality mu ON a.muni_id = mu.muni_id
     JOIN sector_table ON sector_table.sector_id = a.sector_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = a.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = a.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = a.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = a.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = a.omzone_id
     LEFT JOIN arc_add ON arc_add.arc_id = a.arc_id
     LEFT JOIN value_state_type vst ON vst.id = a.state_type
     JOIN vf_arc z ON a.arc_id = z.arc_id;

-- NOTE: ve_node
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
    mu.region_id,
    mu.province_id,
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
    COALESCE(pp.state, n.state) AS p_state,
    n.uuid,
    n.uncertain,
    n.xyz_date,
    m.to_arc
   FROM node n
     LEFT JOIN LATERAL ( SELECT pp_1.state
           FROM plan_psector_x_node pp_1
          WHERE pp_1.node_id = n.node_id AND (pp_1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER))
          ORDER BY pp_1.psector_id DESC
         LIMIT 1) pp ON true
     JOIN cat_node ON cat_node.id::text = n.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_node.node_type::text
     JOIN value_state_type vst ON vst.id = n.state_type
     JOIN exploitation ON n.expl_id = exploitation.expl_id
     JOIN v_municipality mu ON n.muni_id = mu.muni_id
     JOIN sector_table ON sector_table.sector_id = n.sector_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = n.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = n.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = n.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = n.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = n.omzone_id
     LEFT JOIN node_add ON node_add.node_id = n.node_id
     LEFT JOIN man_valve m ON m.node_id = n.node_id
     JOIN vf_node z on z.node_id = n.node_id;


-- NOTE: ve_connec
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
    COALESCE(pp.arc_id, c.arc_id) AS arc_id,
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
    dma_table.dma_type::character varying AS dma_type,
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
    mu.region_id,
    mu.province_id,
    c.block_code,
    c.plot_id,
    c.workcat_id,
    c.workcat_id_end,
    c.workcat_id_plan,
    c.builtdate,
    c.enddate,
    c.ownercat_id,
    COALESCE(pp.exit_id, c.pjoint_id) AS pjoint_id,
    COALESCE(pp.exit_type, c.pjoint_type) AS pjoint_type,
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
    COALESCE(pp.state, c.state) AS p_state,
    c.uuid,
    c.uncertain,
    c.xyz_date
   FROM connec c
     LEFT JOIN LATERAL ( SELECT pp_1.state,
            pp_1.arc_id,
            l.exit_id,
            l.exit_type
           FROM plan_psector_x_connec pp_1
             LEFT JOIN link l ON l.link_id = pp_1.link_id AND l.state = 2
          WHERE pp_1.connec_id = c.connec_id AND (pp_1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER))
          ORDER BY pp_1.psector_id DESC, pp_1.state DESC
         LIMIT 1) pp ON true
     JOIN cat_connec ON cat_connec.id::text = c.conneccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_connec.connec_type::text
     JOIN exploitation ON c.expl_id = exploitation.expl_id
     JOIN v_municipality mu ON c.muni_id = mu.muni_id
     JOIN sector_table ON sector_table.sector_id = c.sector_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = c.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = c.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = c.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = c.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = c.omzone_id
     LEFT JOIN crmzone ON crmzone.crmzone_id = c.crmzone_id
     LEFT JOIN connec_add ON connec_add.connec_id = c.connec_id
     LEFT JOIN value_state_type vst ON vst.id = c.state_type
     LEFT JOIN inp_network_mode ON true
     JOIN vf_connec z on z.connec_id = c.connec_id;

-- NOTE: ve_link
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
    COALESCE(pp.state, l.state) AS p_state,
    l.uuid
   FROM link l
     LEFT JOIN connec c ON c.connec_id = l.feature_id
     LEFT JOIN LATERAL ( SELECT pp1.connec_id,
            pp1.psector_id
           FROM plan_psector_x_connec pp1
          WHERE (pp1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER)) AND pp1.connec_id = l.feature_id
          ORDER BY pp1.psector_id DESC
         LIMIT 1) last_ps ON true
     LEFT JOIN LATERAL ( SELECT pp2.state
           FROM plan_psector_x_connec pp2
          WHERE pp2.link_id = l.link_id AND pp2.psector_id = last_ps.psector_id
         LIMIT 1) pp ON true
     JOIN sector_table ON sector_table.sector_id = l.sector_id
     JOIN cat_link ON cat_link.id::text = l.linkcat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_link.link_type::text
     JOIN exploitation ON l.expl_id = exploitation.expl_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = l.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = l.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = l.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = l.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = l.omzone_id
     LEFT JOIN inp_network_mode ON true
     JOIN vf_link z on z.link_id = l.link_id;

-- NOTE: ve_epa_valve
CREATE OR REPLACE VIEW ve_epa_valve
AS SELECT inp_valve.node_id,
    inp_valve.valve_type,
    cat_node.dint,
    inp_valve.custom_dint,
    inp_valve.setting,
    inp_valve.curve_id,
    inp_valve.minorloss,
    v.to_arc,
        CASE
            WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN v.broken IS FALSE AND (v.to_arc IS NOT NULL OR inp_valve.valve_type::text = 'TCV'::text) THEN 'ACTIVE'::character varying(12)
            ELSE 'OPEN'::character varying(12)
        END AS status,
    inp_valve.add_settings,
    inp_valve.init_quality,
    inp_valve.head,
    inp_valve.pattern_id,
    inp_valve.demand,
    inp_valve.demand_pattern_id,
    inp_valve.emitter_coeff,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min,
    v_rpt_arc_stats.arc_id as nodarc_id
   FROM node
     JOIN inp_valve USING (node_id)
     LEFT JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     LEFT JOIN v_rpt_arc_stats ON concat(inp_valve.node_id, '_n2a') = v_rpt_arc_stats.arc_id::text
     LEFT JOIN man_valve v ON v.node_id = inp_valve.node_id;

-- NOTE: ve_epa_pump
CREATE OR REPLACE VIEW ve_epa_pump
AS SELECT inp_pump.node_id,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern_id,
    inp_pump.status,
    p.to_arc,
    inp_pump.energyparam,
    inp_pump.energyvalue,
    inp_pump.pump_type,
    inp_pump.effic_curve_id,
    inp_pump.energy_price,
    inp_pump.energy_pattern_id,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min,
    v_rpt_arc_stats.arc_id as nodarc_id
   FROM inp_pump
     LEFT JOIN v_rpt_arc_stats ON concat(inp_pump.node_id, '_n2a') = v_rpt_arc_stats.arc_id::text
     LEFT JOIN man_pump p ON p.node_id = inp_pump.node_id;

-- NOTE: ve_epa_pump_additional
CREATE OR REPLACE VIEW ve_epa_pump_additional
AS SELECT inp_pump_additional.id,
    inp_pump_additional.node_id,
    inp_pump_additional.order_id,
    inp_pump_additional.power,
    inp_pump_additional.curve_id,
    inp_pump_additional.speed,
    inp_pump_additional.pattern_id,
    inp_pump_additional.status,
    inp_pump_additional.energyparam,
    inp_pump_additional.energyvalue,
    inp_pump_additional.effic_curve_id,
    inp_pump_additional.energy_price,
    inp_pump_additional.energy_pattern_id,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min,
    v_rpt_arc_stats.arc_id as nodarc_id
    FROM inp_pump_additional
     LEFT JOIN v_rpt_arc_stats ON concat(inp_pump_additional.node_id, '_n2a', inp_pump_additional.order_id) = v_rpt_arc_stats.arc_id::text;

-- NOTE: ve_epa_shortpipe
CREATE OR REPLACE VIEW ve_epa_shortpipe
AS SELECT inp_shortpipe.node_id,
    inp_shortpipe.minorloss,
    cat_node.dint,
    inp_shortpipe.custom_dint,
    v.to_arc,
        CASE
            WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN v.broken IS FALSE AND v.to_arc IS NOT NULL THEN 'CV'::character varying(12)
            ELSE 'OPEN'::character varying(12)
        END AS status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    inp_shortpipe.head,
    inp_shortpipe.pattern_id,
    inp_shortpipe.demand,
    inp_shortpipe.demand_pattern_id,
    inp_shortpipe.emitter_coeff,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min,
    v_rpt_arc_stats.arc_id as nodarc_id  
   FROM node
     LEFT JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN inp_shortpipe USING (node_id)
     LEFT JOIN v_rpt_arc_stats ON concat(inp_shortpipe.node_id, '_n2a') = v_rpt_arc_stats.arc_id::text
     LEFT JOIN man_valve v ON v.node_id = inp_shortpipe.node_id;
