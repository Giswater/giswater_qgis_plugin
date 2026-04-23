/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW vf_link AS 
SELECT l.link_id, COALESCE(pp.state, l.state) AS p_state
  FROM link l
  LEFT JOIN LATERAL ( SELECT p.psector_id
        FROM ( SELECT pp1.connec_id AS feature_id,
                pp1.psector_id
                FROM plan_psector_x_connec pp1
              WHERE (pp1.psector_id IN ( SELECT sp.psector_id
                        FROM selector_psector sp
                      WHERE sp.cur_user = CURRENT_USER)) AND pp1.connec_id = l.feature_id
            UNION ALL
              SELECT pg1.gully_id AS feature_id,
                pg1.psector_id
                FROM plan_psector_x_gully pg1
              WHERE (pg1.psector_id IN ( SELECT sp.psector_id
                        FROM selector_psector sp
                      WHERE sp.cur_user = CURRENT_USER)) AND pg1.gully_id = l.feature_id) p
      ORDER BY p.psector_id DESC
      LIMIT 1) last_ps ON true
  LEFT JOIN LATERAL ( SELECT p.state
        FROM ( SELECT pp2.state
                FROM plan_psector_x_connec pp2
              WHERE pp2.link_id = l.link_id AND pp2.psector_id = last_ps.psector_id
            UNION ALL
              SELECT pg2.state
                FROM plan_psector_x_gully pg2
              WHERE pg2.link_id = l.link_id AND pg2.psector_id = last_ps.psector_id) p
      LIMIT 1) pp ON true
  WHERE (EXISTS ( SELECT 1
           FROM selector_state ss
          WHERE ss.state_id = COALESCE(pp.state, l.state) AND ss.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_sector ssec
          WHERE ssec.sector_id = l.sector_id AND ssec.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_municipality sm
          WHERE sm.muni_id = l.muni_id AND sm.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_expl se
          WHERE (se.expl_id = ANY (array_append(l.expl_visibility::integer[], l.expl_id))) AND se.cur_user = CURRENT_USER));

-- 19/03/2026
CREATE OR REPLACE VIEW ve_inp_dscenario_pattern
AS SELECT p.dscenario_id,
    p.pattern_id,
    p.pattern_type,
    p.observ,
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
AS SELECT 
	p.dscenario_id,
    p.pattern_id,
    p.observ,
    p.tsparameters,
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
    pv.factor_18,
    pv.factor_19,
    pv.factor_20,
    pv.factor_21,
    pv.factor_22,
    pv.factor_23,
    pv.factor_24
FROM inp_dscenario_pattern p
JOIN inp_dscenario_pattern_value pv USING (pattern_id)
WHERE EXISTS (
	SELECT 1
	FROM selector_inp_dscenario s
	WHERE s.dscenario_id = p.dscenario_id
	AND s.cur_user = CURRENT_USER
) AND EXISTS ( 
	SELECT 1
	FROM selector_expl s
	WHERE s.expl_id = p.expl_id
	AND s.cur_user = CURRENT_USER
);
  
  
CREATE OR REPLACE VIEW ve_node
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            omzone.macroomzone_id,
            omzone.stylesheet,
            t.id::character varying(16) AS omzone_type
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.stylesheet,
            t.id::character varying(16) AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), dwfzone_table AS (
         SELECT dwfzone.dwfzone_id,
            dwfzone.stylesheet,
            t.id::character varying(16) AS dwfzone_type,
            dwfzone.drainzone_id
           FROM dwfzone
             LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
        )
 SELECT n.node_id,
    n.code,
    n.sys_code,
    n.top_elev,
    n.custom_top_elev,
    COALESCE(n.custom_top_elev, n.top_elev) AS sys_top_elev,
    n.ymax,
    COALESCE(COALESCE(n.custom_top_elev, n.top_elev) - COALESCE(n.custom_elev, n.elev), n.ymax) AS sys_ymax,
    n.elev,
    n.custom_elev,
    COALESCE(n.custom_elev, n.elev) AS sys_elev,
    cat_feature.feature_class AS sys_type,
    n.node_type::text AS node_type,
    COALESCE(n.matcat_id, cat_node.matcat_id) AS matcat_id,
    n.nodecat_id,
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
    dwfzone_table.drainzone_id,
    drainzone_table.drainzone_type,
    n.drainzone_outfall,
    n.dwfzone_id,
    dwfzone_table.dwfzone_type,
    n.dwfzone_outfall,
    n.omzone_id,
    omzone_table.macroomzone_id,
    n.dma_id,
    n.omunit_id,
    n.minsector_id,
    n.pavcat_id,
    n.soilcat_id,
    n.function_type,
    n.category_type,
    n.location_type,
    n.fluid_type,
    n.annotation,
    n.observ,
    n.comment,
    n.descript,
    concat(cat_feature.link_path, n.link) AS link,
    n.num_value,
    n.district_id,
    n.postcode,
    n.streetaxis_id,
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
    n.conserv_state,
    n.om_state,
    n.access_type,
    n.placement_type,
    n.brand_id,
    n.model_id,
    n.serial_number,
    n.asset_id,
    n.adate,
    n.adescript,
    n.verified,
    n.xyz_date,
    n.uncertain,
    n.datasource,
    n.unconnected,
    cat_node.label,
    n.label_x,
    n.label_y,
    n.label_rotation,
    n.rotation,
    n.label_quadrant,
    n.hemisphere,
    cat_node.svg,
    n.inventory,
    n.publish,
    vst.is_operative,
    n.is_scadamap,
        CASE
            WHEN n.sector_id > 0 AND vst.is_operative = true AND n.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN n.epa_type
            ELSE NULL::character varying(16)
        END AS inp_type,
    node_add.result_id,
    node_add.max_depth,
    node_add.max_height,
    node_add.flooding_rate,
    node_add.flooding_vol,
    sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
    omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
    drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
    dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
    n.lock_level,
    n.expl_visibility,
    ( SELECT st_x(n.the_geom) AS st_x) AS xcoord,
    ( SELECT st_y(n.the_geom) AS st_y) AS ycoord,
    ( SELECT st_y(st_transform(n.the_geom, 4326)) AS st_y) AS lat,
    ( SELECT st_x(st_transform(n.the_geom, 4326)) AS st_x) AS long,
    date_trunc('second'::text, n.created_at) AS created_at,
    n.created_by,
    date_trunc('second'::text, n.updated_at) AS updated_at,
    n.updated_by,
    n.the_geom,
    vf.p_state,
    n.uuid,
    n.treatment_type
  FROM node n
  JOIN vf_node vf ON vf.node_id = n.node_id
  JOIN cat_node ON n.nodecat_id::text = cat_node.id::text
  JOIN cat_feature ON cat_feature.id::text = n.node_type::text
  JOIN exploitation ON n.expl_id = exploitation.expl_id
  JOIN v_municipality vm ON n.muni_id = vm.muni_id
  JOIN value_state_type vst ON vst.id = n.state_type
  JOIN sector_table ON sector_table.sector_id = n.sector_id
  LEFT JOIN omzone_table ON omzone_table.omzone_id = n.omzone_id
  LEFT JOIN drainzone_table ON n.omzone_id = drainzone_table.drainzone_id
  LEFT JOIN dwfzone_table ON n.dwfzone_id = dwfzone_table.dwfzone_id
  LEFT JOIN node_add ON node_add.node_id = n.node_id;


CREATE OR REPLACE VIEW ve_arc AS 
WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            omzone.macroomzone_id,
            omzone.stylesheet,
            t.id::character varying(16) AS omzone_type
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.stylesheet,
            t.id::character varying(16) AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), dwfzone_table AS (
         SELECT dwfzone.dwfzone_id,
            dwfzone.stylesheet,
            t.id::character varying(16) AS dwfzone_type,
            dwfzone.drainzone_id
           FROM dwfzone
             LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
        )
 SELECT a.arc_id,
    a.code,
    a.sys_code,
    a.node_1,
    a.nodetype_1,
    a.node_top_elev_1,
    a.node_custom_top_elev_1,
    COALESCE(a.node_custom_top_elev_1, a.node_top_elev_1) AS node_sys_top_elev_1,
    a.elev1,
    a.custom_elev1,
    COALESCE(a.custom_elev1, a.elev1, a.node_custom_elev_1, a.node_elev_1) AS sys_elev1,
    a.y1,
    COALESCE(COALESCE(a.node_custom_top_elev_1, a.node_top_elev_1) - COALESCE(a.custom_elev1, a.elev1, a.node_custom_elev_1, a.node_elev_1), a.y1) AS sys_y1,
    COALESCE(COALESCE(a.node_custom_top_elev_1, a.node_top_elev_1) - COALESCE(a.custom_elev1, a.elev1, a.node_custom_elev_1, a.node_elev_1), a.y1) - cat_arc.geom1 AS r1,
    COALESCE(a.custom_elev1, a.elev1, a.node_custom_elev_1, a.node_elev_1) - COALESCE(a.node_custom_elev_1, a.node_elev_1) AS z1,
    a.node_2,
    a.nodetype_2,
    a.node_top_elev_2,
    a.node_custom_top_elev_2,
    COALESCE(a.node_custom_top_elev_2, a.node_top_elev_2) AS node_sys_top_elev_2,
    a.elev2,
    a.custom_elev2,
    COALESCE(a.custom_elev2, a.elev2, a.node_custom_elev_2, a.node_elev_2) AS sys_elev2,
    a.y2,
    COALESCE(COALESCE(a.node_custom_top_elev_2, a.node_top_elev_2) - COALESCE(a.custom_elev2, a.elev2, a.node_custom_elev_2, a.node_elev_2), a.y2) AS sys_y2,
    COALESCE(COALESCE(a.node_custom_top_elev_2, a.node_top_elev_2) - COALESCE(a.custom_elev2, a.elev2, a.node_custom_elev_2, a.node_elev_2), a.y2) - cat_arc.geom1 AS r2,
    COALESCE(a.custom_elev2, a.elev2, a.node_custom_elev_2, a.node_elev_2) - COALESCE(a.node_custom_elev_2, a.node_elev_2) AS z2,
    cat_feature.feature_class AS sys_type,
    a.arc_type::text AS arc_type,
    a.arccat_id,
    COALESCE(a.matcat_id, cat_arc.matcat_id) AS matcat_id,
    cat_arc.shape AS cat_shape,
    cat_arc.geom1 AS cat_geom1,
    cat_arc.geom2 AS cat_geom2,
    cat_arc.width AS cat_width,
    cat_arc.area AS cat_area,
    a.epa_type,
    a.state,
    a.state_type,
    a.parent_id,
    a.expl_id,
    e.macroexpl_id,
    a.muni_id,
    a.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    dwfzone_table.drainzone_id,
    drainzone_table.drainzone_type,
    a.drainzone_outfall,
    a.dwfzone_id,
    dwfzone_table.dwfzone_type,
    a.dwfzone_outfall,
    a.omzone_id,
    omzone_table.macroomzone_id,
    a.dma_id,
    omzone_table.omzone_type,
    a.omunit_id,
    a.minsector_id,
    a.pavcat_id,
    a.soilcat_id,
    a.function_type,
    a.category_type,
    a.location_type,
    a.fluid_type,
    a.custom_length,
    st_length(a.the_geom)::numeric(12,2) AS gis_length,
	(case when sys_slope is null then
	((coalesce (node_custom_elev_1, node_elev_1, elev1, node_top_elev_1-y1, node_elev_1)-coalesce (node_custom_elev_2, node_elev_2, elev2, node_top_elev_2-y2, node_elev_2))/st_length(a.the_geom))::numeric(12,4)
	else sys_slope end) as slope,
    a.descript,
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
    a.registration_date,
    a.enddate,
    a.ownercat_id,
    a.last_visitdate,
    a.visitability,
    a.om_state,
    a.conserv_state,
    a.brand_id,
    a.model_id,
    a.serial_number,
    a.asset_id,
    a.adate,
    a.adescript,
    a.verified,
    a.uncertain,
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
            WHEN a.sector_id > 0 AND vst.is_operative = true AND a.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN a.epa_type
            ELSE NULL::character varying(16)
        END AS inp_type,
    arc_add.result_id,
    arc_add.max_flow,
    arc_add.max_veloc,
    arc_add.mfull_flow,
    arc_add.mfull_depth,
    arc_add.manning_veloc,
    arc_add.manning_flow,
    arc_add.dwf_minflow,
    arc_add.dwf_maxflow,
    arc_add.dwf_minvel,
    arc_add.dwf_maxvel,
    arc_add.conduit_capacity,
    sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
    drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
    dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
    omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
    a.lock_level,
    a.initoverflowpath,
    a.inverted_slope,
    a.negative_offset,
    a.expl_visibility,
    date_trunc('second'::text, a.created_at) AS created_at,
    a.created_by,
    date_trunc('second'::text, a.updated_at) AS updated_at,
    a.updated_by,
    a.the_geom,
    a.meandering,
    vf.p_state,
    a.uuid,
    a.treatment_type
  FROM arc a
  JOIN vf_arc vf ON vf.arc_id = a.arc_id
  JOIN cat_arc ON a.arccat_id::text = cat_arc.id::text
  JOIN cat_feature ON a.arc_type::text = cat_feature.id::text
  JOIN exploitation e ON e.expl_id = a.expl_id
  JOIN v_municipality vm ON a.muni_id = vm.muni_id
  JOIN value_state_type vst ON vst.id = a.state_type
  JOIN sector_table ON sector_table.sector_id = a.sector_id
  LEFT JOIN omzone_table ON omzone_table.omzone_id = a.omzone_id
  LEFT JOIN drainzone_table ON a.omzone_id = drainzone_table.drainzone_id
  LEFT JOIN dwfzone_table ON a.dwfzone_id = dwfzone_table.dwfzone_id
  LEFT JOIN arc_add ON arc_add.arc_id = a.arc_id;


CREATE OR REPLACE VIEW ve_connec
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            omzone.macroomzone_id,
            omzone.stylesheet,
            t.id::character varying(16) AS omzone_type
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.stylesheet,
            t.id::character varying(16) AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), dwfzone_table AS (
         SELECT dwfzone.dwfzone_id,
            dwfzone.stylesheet,
            t.id::character varying(16) AS dwfzone_type,
            dwfzone.drainzone_id
           FROM dwfzone
             LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
        )
 SELECT c.connec_id,
    c.code,
    c.sys_code,
    c.top_elev,
    c.y1,
    c.y2,
    cat_feature.feature_class AS sys_type,
    c.connec_type::text AS connec_type,
    c.matcat_id,
    c.conneccat_id,
    c.customer_code,
    c.connec_depth,
    c.connec_length,
    c.state,
    c.state_type,
    vf.arc_id,
    c.expl_id,
    exploitation.macroexpl_id,
    c.muni_id,
    c.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    dwfzone_table.drainzone_id,
    drainzone_table.drainzone_type,
    c.drainzone_outfall,
    c.dwfzone_id,
    dwfzone_table.dwfzone_type,
    c.dwfzone_outfall,
    c.omzone_id,
    omzone_table.macroomzone_id,
    omzone_table.omzone_type,
    c.dma_id,
    c.omunit_id,
    c.minsector_id,
    c.soilcat_id,
    c.function_type,
    c.category_type,
    c.location_type,
    c.fluid_type,
    c.n_hydrometer,
    c.n_inhabitants,
    c.demand,
    c.descript,
    c.annotation,
    c.observ,
    c.comment,
    c.link::text AS link,
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
    c.om_state,
    vf.pjoint_id,
    vf.pjoint_type,
    c.access_type,
    c.placement_type,
    c.accessibility,
    c.brand_id,
    c.model_id,
    c.asset_id,
    c.adate,
    c.adescript,
    c.verified,
    c.uncertain,
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
    sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
    drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
    dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
    omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
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
    c.diagonal,
    vf.p_state,
    c.uuid,
    c.treatment_type,
    c.xyz_date
  FROM connec c
  JOIN vf_connec vf on vf.connec_id = c.connec_id
  JOIN cat_connec ON cat_connec.id::text = c.conneccat_id::text
  JOIN cat_feature ON cat_feature.id::text = c.connec_type::text
  JOIN exploitation ON c.expl_id = exploitation.expl_id
  JOIN v_municipality vm ON c.muni_id = vm.muni_id
  JOIN value_state_type vst ON vst.id = c.state_type
  JOIN sector_table ON sector_table.sector_id = c.sector_id
  LEFT JOIN omzone_table ON omzone_table.omzone_id = c.omzone_id
  LEFT JOIN drainzone_table ON c.omzone_id = drainzone_table.drainzone_id
  LEFT JOIN dwfzone_table ON c.dwfzone_id = dwfzone_table.dwfzone_id;


CREATE OR REPLACE VIEW vf_gully AS 
SELECT 
  g.gully_id, 
  COALESCE(pp.state, g.state) AS p_state, 
  COALESCE(pp.arc_id, g.arc_id) AS arc_id, 
  COALESCE(pp.exit_id, g.pjoint_id) AS pjoint_id, 
  COALESCE(pp.exit_type, g.pjoint_type) AS pjoint_type
FROM gully g
LEFT JOIN LATERAL ( SELECT pp_1.state,
            pp_1.arc_id,
            l.exit_id,
            l.exit_type
           FROM plan_psector_x_gully pp_1
             LEFT JOIN link l ON l.link_id = pp_1.link_id AND l.state = 2
          WHERE pp_1.gully_id = g.gully_id AND (pp_1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER))
          ORDER BY pp_1.psector_id DESC, pp_1.state DESC
         LIMIT 1) pp ON true
  WHERE (EXISTS ( SELECT 1
           FROM selector_state ss
          WHERE ss.state_id = COALESCE(pp.state, g.state) AND ss.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_sector ssec
          WHERE ssec.sector_id = g.sector_id AND ssec.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_municipality sm
          WHERE sm.muni_id = g.muni_id AND sm.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_expl se
          WHERE (se.expl_id = ANY (array_append(g.expl_visibility::integer[], g.expl_id))) AND se.cur_user = CURRENT_USER));

CREATE OR REPLACE VIEW ve_gully
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            omzone.macroomzone_id,
            omzone.stylesheet,
            t.id::character varying(16) AS omzone_type
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.stylesheet,
            t.id::character varying(16) AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), dwfzone_table AS (
         SELECT dwfzone.dwfzone_id,
            dwfzone.stylesheet,
            t.id::character varying(16) AS dwfzone_type,
            dwfzone.drainzone_id
           FROM dwfzone
             LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
        ), inp_network_mode AS (
         SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        )
 SELECT gully.gully_id,
    gully.code,
    gully.sys_code,
    gully.top_elev,
    COALESCE(gully.width, cat_gully.width) AS width,
    COALESCE(gully.length, cat_gully.length) AS length,
    COALESCE(gully.ymax, cat_gully.ymax) AS ymax,
    gully.sandbox,
    gully.matcat_id,
    gully.gully_type,
    cat_feature.feature_class AS sys_type,
    gully.gullycat_id,
    cat_gully.matcat_id AS cat_gully_matcat,
    gully.units,
    gully.units_placement,
    gully.groove,
    gully.groove_height,
    gully.groove_length,
    gully.siphon,
    gully.siphon_type,
    gully.odorflap,
    gully._connec_arccat_id AS connec_arccat_id,
    gully.connec_length,
    COALESCE(((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric)::numeric(12,3), gully.connec_depth) AS connec_depth,
    COALESCE(gully._connec_matcat_id, cc.matcat_id::text) AS connec_matcat_id,
    gully.top_elev - gully.ymax + gully.sandbox AS connec_y1,
    gully.connec_y2,
    vf.arc_id,
    gully.epa_type,
    gully.state,
    gully.state_type,
    gully.expl_id,
    exploitation.macroexpl_id,
    gully.muni_id,
    sector_table.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    dwfzone_table.drainzone_id,
    drainzone_table.drainzone_type,
    gully.drainzone_outfall,
    dwfzone_table.dwfzone_id,
    dwfzone_table.dwfzone_type,
    gully.dwfzone_outfall,
    omzone_table.omzone_id,
    omzone_table.macroomzone_id,
    gully.dma_id,
    omzone_table.omzone_type,
    gully.omunit_id,
    gully.minsector_id,
    gully.soilcat_id,
    gully.function_type,
    gully.category_type,
    gully.location_type,
    gully.fluid_type,
    gully.descript,
    gully.annotation,
    gully.observ,
    gully.comment,
    concat(cat_feature.link_path, gully.link) AS link,
    gully.num_value,
    gully.district_id,
    gully.postcode,
    gully.streetaxis_id,
    gully.postnumber,
    gully.postcomplement,
    gully.streetaxis2_id,
    gully.postnumber2,
    gully.postcomplement2,
    vm.region_id,
    vm.province_id,
    gully.workcat_id,
    gully.workcat_id_end,
    gully.workcat_id_plan,
    gully.builtdate,
    gully.enddate,
    gully.ownercat_id,
    gully.om_state,
    vf.pjoint_id,
    vf.pjoint_type,
    gully.placement_type,
    gully.access_type,
    gully.brand_id,
    gully.model_id,
    gully.asset_id,
    gully.adate,
    gully.adescript,
    gully.verified,
    gully.uncertain,
    gully.datasource,
    cat_gully.label,
    gully.label_x,
    gully.label_y,
    gully.label_rotation,
    gully.rotation,
    gully.label_quadrant,
    cat_gully.svg,
    gully.inventory,
    gully.publish,
    vst.is_operative,
        CASE
            WHEN gully.sector_id > 0 AND vst.is_operative = true AND gully.epa_type::text = 'GULLY'::character varying(16)::text AND inp_network_mode.value = '2'::text THEN gully.epa_type
            ELSE NULL::character varying(16)
        END AS inp_type,
    sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
    omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
    drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
    dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
    gully.lock_level,
    gully.expl_visibility,
    date_trunc('second'::text, gully.created_at) AS created_at,
    gully.created_by,
    date_trunc('second'::text, gully.updated_at) AS updated_at,
    gully.updated_by,
    gully.the_geom,
    vf.p_state,
    gully.uuid,
    gully.treatment_type,
    gully.xyz_date
  FROM gully
  JOIN vf_gully vf ON vf.gully_id = gully.gully_id
  JOIN cat_gully ON gully.gullycat_id::text = cat_gully.id::text
  JOIN exploitation ON gully.expl_id = exploitation.expl_id
  JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
  LEFT JOIN cat_connec cc ON cc.id::text = gully._connec_arccat_id::text
  JOIN value_state_type vst ON vst.id = gully.state_type
  JOIN v_municipality vm ON gully.muni_id = vm.muni_id
  JOIN sector_table ON gully.sector_id = sector_table.sector_id
  LEFT JOIN omzone_table ON gully.omzone_id = omzone_table.omzone_id
  LEFT JOIN drainzone_table ON gully.omzone_id = drainzone_table.drainzone_id
  LEFT JOIN dwfzone_table ON gully.dwfzone_id = dwfzone_table.dwfzone_id
  LEFT JOIN inp_network_mode ON true;

CREATE OR REPLACE VIEW v_rtc_hydrometer
AS WITH sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT ext_rtc_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    connec.connec_id AS feature_id,
    'CONNEC'::text AS feature_type,
    COALESCE(ext_rtc_hydrometer.customer_code, 'XXXX'::character varying) AS customer_code,
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
     JOIN connec ON connec.customer_code = ext_rtc_hydrometer.customer_code
     LEFT JOIN v_municipality ON v_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = connec.expl_id));



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
        END AS hydrometer_link
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN connec ON connec.customer_code = ext_rtc_hydrometer.customer_code
     LEFT JOIN v_municipality ON v_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = connec.expl_id));


CREATE OR REPLACE VIEW v_ui_hydroval
AS SELECT ext_rtc_hydrometer_x_data.id,
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
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::text = ext_rtc_hydrometer.hydrometer_id::text
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.catalog_id::text
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.customer_code::text
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
  ORDER BY ext_rtc_hydrometer_x_data.id;


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
     JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::text = ext_rtc_hydrometer.hydrometer_id::text
     LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.catalog_id::text
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.customer_code::text
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
  ORDER BY ext_rtc_hydrometer_x_data.id;


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

SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views($${"data":{"action":"MULTI-DELETE"}, "feature":{"parentLayer":"ve_link"}}$$);
DROP VIEW IF EXISTS ve_link_gully;
DROP VIEW IF EXISTS ve_link_connec;
DROP VIEW IF EXISTS ve_link;

CREATE OR REPLACE VIEW ve_link
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            omzone.macroomzone_id,
            omzone.stylesheet,
            t.id::character varying(16) AS omzone_type
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.stylesheet,
            t.id::character varying(16) AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), dwfzone_table AS (
         SELECT dwfzone.dwfzone_id,
            dwfzone.stylesheet,
            t.id::character varying(16) AS dwfzone_type,
            dwfzone.drainzone_id
           FROM dwfzone
             LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
        ), inp_network_mode AS (
         SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        )
 SELECT l.link_id,
    l.code,
    l.sys_code,
    l.top_elev1,
    l.y1,
        CASE
            WHEN l.top_elev1 IS NULL OR l.y1 IS NULL THEN NULL::double precision
            ELSE l.top_elev1 - l.y1::double precision
        END AS elevation1,
    l.exit_id,
    l.exit_type,
    l.top_elev2,
    l.y2,
        CASE
            WHEN l.top_elev2 IS NULL OR l.y2 IS NULL THEN NULL::double precision
            ELSE l.top_elev2 - l.y2::double precision
        END AS elevation2,
    l.feature_type,
    l.feature_id,
    l.link_type,
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
    dwfzone_table.drainzone_id,
    drainzone_table.drainzone_type,
    l.drainzone_outfall,
    l.dwfzone_id,
    dwfzone_table.dwfzone_type,
    l.dwfzone_outfall,
    l.omzone_id,
    omzone_table.macroomzone_id,
    l.dma_id,
    l.location_type,
    l.fluid_type,
    l.custom_length,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.sys_slope,
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
    l.private_linkcat_id,
    l.verified,
    l.uncertain,
    l.userdefined_geom,
    l.datasource,
    l.is_operative,
    sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
    omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
    drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
    dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
    l.lock_level,
    l.expl_visibility,
    l.created_at,
    l.created_by,
    date_trunc('second'::text, l.updated_at) AS updated_at,
    l.updated_by,
    l.the_geom,
    vf.p_state,
    l.uuid,
    l.omunit_id,
    l.treatment_type
  FROM link l
  JOIN vf_link vf ON vf.link_id = l.link_id
  JOIN exploitation ON l.expl_id = exploitation.expl_id
  JOIN sector_table ON l.sector_id = sector_table.sector_id
  JOIN cat_link ON cat_link.id::text = l.linkcat_id::text
  JOIN cat_feature ON cat_feature.id::text = l.link_type::text
  LEFT JOIN omzone_table ON l.omzone_id = omzone_table.omzone_id
  LEFT JOIN drainzone_table ON l.omzone_id = drainzone_table.drainzone_id
  LEFT JOIN dwfzone_table ON l.dwfzone_id = dwfzone_table.dwfzone_id
  LEFT JOIN inp_network_mode ON true;

CREATE OR REPLACE VIEW ve_link_connec
AS SELECT link_id,
    code,
    sys_code,
    top_elev1,
    y1,
    elevation1,
    exit_id,
    exit_type,
    top_elev2,
    y2,
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
    drainzone_id,
    drainzone_type,
    drainzone_outfall,
    dwfzone_id,
    dwfzone_type,
    dwfzone_outfall,
    omzone_id,
    macroomzone_id,
    dma_id,
    location_type,
    fluid_type,
    custom_length,
    gis_length,
    sys_slope,
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
    private_linkcat_id,
    verified,
    uncertain,
    userdefined_geom,
    datasource,
    is_operative,
    sector_style,
    omzone_style,
    drainzone_style,
    dwfzone_style,
    lock_level,
    expl_visibility,
    created_at,
    created_by,
    updated_at,
    updated_by,
    the_geom
   FROM ve_link
  WHERE feature_type::text = 'CONNEC'::text;


CREATE OR REPLACE VIEW ve_link_gully
AS SELECT link_id,
    code,
    sys_code,
    top_elev1,
    y1,
    elevation1,
    exit_id,
    exit_type,
    top_elev2,
    y2,
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
    drainzone_id,
    drainzone_type,
    drainzone_outfall,
    dwfzone_id,
    dwfzone_type,
    dwfzone_outfall,
    omzone_id,
    macroomzone_id,
    dma_id,
    location_type,
    fluid_type,
    custom_length,
    gis_length,
    sys_slope,
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
    private_linkcat_id,
    verified,
    uncertain,
    userdefined_geom,
    datasource,
    is_operative,
    sector_style,
    omzone_style,
    drainzone_style,
    dwfzone_style,
    lock_level,
    expl_visibility,
    created_at,
    created_by,
    updated_at,
    updated_by,
    the_geom
   FROM ve_link
  WHERE feature_type::text = 'GULLY'::text;
  
  
  
CREATE OR REPLACE VIEW v_plan_arc
AS SELECT arc_id,
    node_1,
    node_2,
    arc_type,
    arccat_id,
    epa_type,
    state,
    expl_id,
    sector_id,
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
        CASE
            WHEN other_budget IS NOT NULL THEN (budget + other_budget)::numeric(14,2)
            ELSE budget
        END AS total_budget,
    the_geom
   FROM ( WITH v_plan_aux_arc_cost AS (
                 WITH v_plan_aux_arc_ml AS (
                         SELECT ve_arc.arc_id,
                            ve_arc.y1,
                            ve_arc.y2,
                                CASE
                                    WHEN (ve_arc.y1 * ve_arc.y2) = 0::numeric OR (ve_arc.y1 * ve_arc.y2) IS NULL THEN v_price_x_catarc.estimated_depth
                                    ELSE ((ve_arc.y1 + ve_arc.y2) / 2::numeric)::numeric(12,2)
                                END AS mean_y,
                            ve_arc.arccat_id,
                            COALESCE(v_price_x_catarc.geom1, 0::numeric)::numeric(12,4) AS geom1,
                            COALESCE(v_price_x_catarc.z1, 0::numeric)::numeric(12,2) AS z1,
                            COALESCE(v_price_x_catarc.z2, 0::numeric)::numeric(12,2) AS z2,
                            COALESCE(v_price_x_catarc.area, 0::numeric)::numeric(12,4) AS area,
                            COALESCE(v_price_x_catarc.width, 0::numeric)::numeric(12,2) AS width,
                            COALESCE(v_price_x_catarc.thickness / 1000::numeric, 0::numeric)::numeric(12,2) AS bulk,
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
                    v_plan_aux_arc_ml.y1,
                    v_plan_aux_arc_ml.y2,
                    v_plan_aux_arc_ml.mean_y,
                    v_plan_aux_arc_ml.arccat_id,
                    v_plan_aux_arc_ml.geom1,
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
                    (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric)::numeric(12,3) AS m2mlpavement,
                    (2::numeric * v_plan_aux_arc_ml.b + v_plan_aux_arc_ml.width)::numeric(12,3) AS m2mlbase,
                    (v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness)::numeric(12,3) AS calculed_y,
                    (v_plan_aux_arc_ml.trenchlining * 2::numeric * (v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness))::numeric(12,3) AS m2mltrenchl,
                    ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric)::numeric(12,3) AS m3mlexc,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric) - v_plan_aux_arc_ml.area)::numeric(12,3) AS m3mlprotec,
                    ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric - (v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlfill,
                    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlexcess,
                    v_plan_aux_arc_ml.the_geom
                   FROM v_plan_aux_arc_ml
                  WHERE v_plan_aux_arc_ml.arc_id IS NOT NULL
                )
         SELECT v_plan_aux_arc_cost.arc_id,
            arc.node_1,
            arc.node_2,
            arc.arc_type::text AS arc_type,
            v_plan_aux_arc_cost.arccat_id,
            arc.epa_type,
            v_plan_aux_arc_cost.state,
            v_plan_aux_arc_cost.expl_id,
            arc.sector_id,
            arc.annotation,
            v_plan_aux_arc_cost.soilcat_id,
            v_plan_aux_arc_cost.y1,
            v_plan_aux_arc_cost.y2,
            v_plan_aux_arc_cost.mean_y,
            v_plan_aux_arc_cost.z1,
            v_plan_aux_arc_cost.z2,
            v_plan_aux_arc_cost.thickness,
            v_plan_aux_arc_cost.width,
            v_plan_aux_arc_cost.b,
            v_plan_aux_arc_cost.bulk,
            v_plan_aux_arc_cost.geom1,
            v_plan_aux_arc_cost.area,
            v_plan_aux_arc_cost.y_param,
            (v_plan_aux_arc_cost.calculed_y + v_plan_aux_arc_cost.thickness)::numeric(12,2) AS total_y,
            (v_plan_aux_arc_cost.calculed_y - 2::numeric * v_plan_aux_arc_cost.bulk - v_plan_aux_arc_cost.z1 - v_plan_aux_arc_cost.z2 - v_plan_aux_arc_cost.geom1)::numeric(12,2) AS rec_y,
            (v_plan_aux_arc_cost.geom1 + 2::numeric * v_plan_aux_arc_cost.bulk)::numeric(12,2) AS geom1_ext,
            v_plan_aux_arc_cost.calculed_y,
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
            COALESCE(v_plan_aux_arc_connec.connec_total_cost, 0::numeric) + COALESCE(v_plan_aux_arc_gully.gully_total_cost, 0::numeric) AS other_budget,
            v_plan_aux_arc_cost.the_geom
           FROM v_plan_aux_arc_cost
             JOIN arc ON v_plan_aux_arc_cost.arc_id = arc.arc_id
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (min(p.price) * count(*)::numeric)::numeric(12,2) AS connec_total_cost
                   FROM ve_connec c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  WHERE c.arc_id IS NOT NULL
                  GROUP BY c.arc_id) v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id = v_plan_aux_arc_cost.arc_id
             LEFT JOIN ( SELECT DISTINCT ON (c.arc_id) c.arc_id,
                    (min(p.price) * count(*)::numeric)::numeric(12,2) AS gully_total_cost
                   FROM ve_gully c
                     JOIN arc arc_1 USING (arc_id)
                     JOIN cat_arc ON cat_arc.id::text = arc_1.arccat_id::text
                     LEFT JOIN v_price_compost p ON cat_arc.connect_cost = p.id::text
                  WHERE c.arc_id IS NOT NULL
                  GROUP BY c.arc_id) v_plan_aux_arc_gully ON v_plan_aux_arc_gully.arc_id = v_plan_aux_arc_cost.arc_id) d;
  
  
CREATE OR REPLACE VIEW v_ui_node_x_connection_upstream
AS SELECT row_number() OVER (ORDER BY ve_arc.node_2) + 1000000 AS rid,
    ve_arc.node_2 AS node_id,
    ve_arc.arc_id AS feature_id,
    ve_arc.code AS feature_code,
    ve_arc.arc_type AS featurecat_id,
    ve_arc.arccat_id,
    ve_arc.y1 AS depth,
    st_length2d(ve_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS upstream_id,
    node.code AS upstream_code,
    node.node_type AS upstream_type,
    ve_arc.y2 AS upstream_depth,
    ve_arc.sys_type,
    st_x(st_lineinterpolatepoint(ve_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(ve_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    've_arc'::text AS sys_table_id
   FROM ve_arc
     JOIN node ON ve_arc.node_1 = node.node_id
     LEFT JOIN cat_arc ON ve_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON ve_arc.state = value_state.id
UNION
 SELECT DISTINCT ON (ve_connec.connec_id) row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.node_id,
    ve_connec.connec_id AS feature_id,
    ve_connec.code AS feature_code,
    ve_connec.connec_type AS featurecat_id,
    ve_connec.conneccat_id AS arccat_id,
    ve_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    ve_connec.connec_id AS upstream_id,
    ve_connec.code AS upstream_code,
    ve_connec.connec_type AS upstream_type,
    ve_connec.y2 AS upstream_depth,
    ve_connec.sys_type,
    st_x(ve_connec.the_geom) AS x,
    st_y(ve_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    've_connec'::text AS sys_table_id
   FROM ve_connec
     JOIN link ON link.feature_id = ve_connec.connec_id AND link.feature_type::text = 'CONNEC'::text
     JOIN node ON ve_connec.pjoint_id = node.node_id AND ve_connec.pjoint_type::text = 'NODE'::text
     LEFT JOIN cat_connec ON ve_connec.conneccat_id::text = cat_connec.id::text
     JOIN value_state ON ve_connec.state = value_state.id
UNION
 SELECT DISTINCT ON (ve_connec.connec_id) row_number() OVER (ORDER BY node.node_id) + 3000000 AS rid,
    node.node_id,
    ve_connec.connec_id AS feature_id,
    ve_connec.code AS feature_code,
    ve_connec.connec_type AS featurecat_id,
    ve_connec.conneccat_id AS arccat_id,
    ve_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    ve_connec.connec_id AS upstream_id,
    ve_connec.code AS upstream_code,
    ve_connec.connec_type AS upstream_type,
    ve_connec.y2 AS upstream_depth,
    ve_connec.sys_type,
    st_x(ve_connec.the_geom) AS x,
    st_y(ve_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    've_connec'::text AS sys_table_id
   FROM ve_connec
     JOIN link ON link.feature_id = ve_connec.connec_id AND link.feature_type::text = 'CONNEC'::text AND link.exit_type::text = 'CONNEC'::text
     JOIN connec ON connec.connec_id = link.exit_id AND connec.pjoint_type::text = 'NODE'::text
     JOIN node ON connec.pjoint_id = node.node_id
     LEFT JOIN cat_connec ON ve_connec.conneccat_id::text = cat_connec.id::text
     JOIN value_state ON ve_connec.state = value_state.id
UNION
 SELECT DISTINCT ON (ve_gully.gully_id) row_number() OVER (ORDER BY node.node_id) + 4000000 AS rid,
    node.node_id,
    ve_gully.gully_id AS feature_id,
    ve_gully.code AS feature_code,
    ve_gully.gully_type AS featurecat_id,
    ve_gully.connec_arccat_id AS arccat_id,
    ve_gully.ymax - ve_gully.sandbox AS depth,
    ve_gully.connec_length AS length,
    ve_gully.gully_id AS upstream_id,
    ve_gully.code AS upstream_code,
    ve_gully.gully_type AS upstream_type,
    ve_gully.connec_depth AS upstream_depth,
    ve_gully.sys_type,
    st_x(ve_gully.the_geom) AS x,
    st_y(ve_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    've_gully'::text AS sys_table_id
   FROM ve_gully
     JOIN link ON link.feature_id = ve_gully.gully_id AND link.feature_type::text = 'GULLY'::text
     JOIN node ON ve_gully.pjoint_id = node.node_id AND ve_gully.pjoint_type::text = 'NODE'::text
     LEFT JOIN cat_connec ON ve_gully.connec_arccat_id::text = cat_connec.id::text
     JOIN value_state ON ve_gully.state = value_state.id
UNION
 SELECT DISTINCT ON (ve_gully.gully_id) row_number() OVER (ORDER BY node.node_id) + 5000000 AS rid,
    node.node_id,
    ve_gully.gully_id AS feature_id,
    ve_gully.code AS feature_code,
    ve_gully.gully_type AS featurecat_id,
    ve_gully.connec_arccat_id AS arccat_id,
    ve_gully.ymax - ve_gully.sandbox AS depth,
    ve_gully.connec_length AS length,
    ve_gully.gully_id AS upstream_id,
    ve_gully.code AS upstream_code,
    ve_gully.gully_type AS upstream_type,
    ve_gully.connec_depth AS upstream_depth,
    ve_gully.sys_type,
    st_x(ve_gully.the_geom) AS x,
    st_y(ve_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    've_gully'::text AS sys_table_id
   FROM ve_gully
     JOIN link ON link.feature_id = ve_gully.gully_id AND link.feature_type::text = 'GULLY'::text AND link.exit_type::text = 'GULLY'::text
     JOIN gully ON gully.gully_id = link.exit_id AND gully.pjoint_type::text = 'NODE'::text
     JOIN node ON gully.pjoint_id = node.node_id
     LEFT JOIN cat_connec ON ve_gully.connec_arccat_id::text = cat_connec.id::text
     JOIN value_state ON ve_gully.state = value_state.id;
	 
	 
	 
CREATE OR REPLACE VIEW v_plan_result_arc
AS SELECT plan_rec_result_arc.arc_id,
    plan_rec_result_arc.node_1,
    plan_rec_result_arc.node_2,
    plan_rec_result_arc.arc_type::text AS arc_type,
    plan_rec_result_arc.arccat_id,
    plan_rec_result_arc.epa_type,
    plan_rec_result_arc.state,
    plan_rec_result_arc.sector_id,
    plan_rec_result_arc.expl_id,
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
  WHERE plan_rec_result_arc.result_id::text = selector_plan_result.result_id::text AND selector_plan_result.cur_user = "current_user"()::text AND plan_rec_result_arc.state = 1
UNION
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
  WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


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
  WHERE config_param_user.cur_user::text = "current_user"()::text AND config_param_user.parameter::text = 'plan_psector_vdefault'::text AND config_param_user.value::integer = plan_psector.psector_id;
  
  

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



CREATE OR REPLACE VIEW v_plan_psector_all
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
                    v_plan_arc.expl_id,
                    v_plan_arc.sector_id,
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
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
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
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id;
		  
		  
		  
CREATE OR REPLACE VIEW v_ui_plan_arc_cost
AS WITH p AS (
         SELECT v_plan_arc.arc_id,
            v_plan_arc.node_1,
            v_plan_arc.node_2,
            v_plan_arc.arc_type,
            v_plan_arc.arccat_id,
            v_plan_arc.epa_type,
            v_plan_arc.state,
            v_plan_arc.expl_id,
            v_plan_arc.sector_id,
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
            a.matcat_id,
            a.shape,
            a.geom1,
            a.geom2,
            a.geom3,
            a.geom4,
            a.geom5,
            a.geom6,
            a.geom7,
            a.geom8,
            a.geom_r,
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
            a.tsect_id,
            a.curve_id,
            a.arc_type,
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
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
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN ve_connec USING (arc_id)
     JOIN v_price_compost v ON p.cat_connect_cost = v.id::text
  GROUP BY p.arc_id
UNION
 SELECT p.arc_id,
    10 AS orderby,
    'connec'::text AS identif,
    'Various connecs'::character varying AS catalog_id,
    'VARIOUS'::character varying AS price_id,
    'PP'::character varying AS unit,
    'Proportional cost of gully connections (pjoint cost)'::character varying AS descript,
    min(v.price) AS cost,
    count(ve_gully.gully_id) AS measurement,
    (min(v.price) * count(ve_gully.gully_id)::numeric / COALESCE(min(p.length), 1::numeric))::numeric(12,2) AS total_cost,
    min(p.length)::numeric(12,2) AS length
   FROM p p(arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, expl_id, sector_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, matcat_id, shape, geom1_1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1_1, z2_1, width_1, area_1, estimated_depth, thickness_1, cost_unit_1, cost_1, m2bottom_cost_1, m3protec_cost_1, active, label, tsect_id, curve_id, arc_type_1, acoeff, connect_cost, id_1, descript_1, link_1, y_param_1, b_1, trenchlining, m3exc_cost_1, m3fill_cost_1, m3excess_cost_1, m2trenchl_cost_1, active_1, cat_cost, cat_m2bottom_cost, cat_connect_cost, cat_m3_protec_cost, cat_m3exc_cost, cat_m3fill_cost, cat_m3excess_cost, cat_m2trenchl_cost)
     JOIN ve_gully USING (arc_id)
     JOIN v_price_compost v ON p.cat_connect_cost = v.id::text
  GROUP BY p.arc_id
  ORDER BY 1, 2;


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
     JOIN ve_connec c ON c.connec_id = n.feature_id
UNION
 SELECT row_number() OVER () + 3000000 AS rid,
    ve_gully.arc_id,
    ve_gully.gully_type AS featurecat_id,
    ve_gully.gullycat_id AS catalog,
    ve_gully.gully_id AS feature_id,
    ve_gully.code AS feature_code,
    ve_gully.sys_type,
    a.state AS arc_state,
    ve_gully.state AS feature_state,
    st_x(ve_gully.the_geom) AS x,
    st_y(ve_gully.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    've_gully'::text AS sys_table_id
   FROM ve_gully
     JOIN link l ON ve_gully.gully_id = l.feature_id
     JOIN arc a ON a.arc_id = ve_gully.arc_id
  WHERE ve_gully.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (g.gully_id) row_number() OVER () + 4000000 AS rid,
    a.arc_id,
    g.gully_type AS featurecat_id,
    g.gullycat_id AS catalog,
    g.gully_id AS feature_id,
    g.code AS feature_code,
    g.sys_type,
    a.state AS arc_state,
    g.state AS feature_state,
    st_x(g.the_geom) AS x,
    st_y(g.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    've_gully'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1 = n.node_id
     JOIN ve_gully g ON g.gully_id = n.feature_id;
	 
	 
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
  WHERE element.state = 0
UNION
 SELECT row_number() OVER (ORDER BY ve_gully.gully_id) + 4000000 AS rid,
    'GULLY'::character varying AS feature_type,
    ve_gully.gullycat_id AS featurecat_id,
    ve_gully.gully_id AS feature_id,
    ve_gully.code,
    exploitation.name AS expl_name,
    ve_gully.workcat_id_end,
    exploitation.expl_id
   FROM ve_gully
     JOIN exploitation ON exploitation.expl_id = ve_gully.expl_id
  WHERE ve_gully.state = 0;
  
  
CREATE OR REPLACE VIEW v_edit_connec
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            omzone.macroomzone_id,
            omzone.stylesheet,
            t.id::character varying(16) AS omzone_type
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.stylesheet,
            t.id::character varying(16) AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), dwfzone_table AS (
         SELECT dwfzone.dwfzone_id,
            dwfzone.stylesheet,
            t.id::character varying(16) AS dwfzone_type,
            dwfzone.drainzone_id
           FROM dwfzone
             LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
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
            l.omzone_id,
            omzone_table.macroomzone_id,
            omzone_table.omzone_type,
            dwfzone_table.drainzone_id,
            drainzone_table.drainzone_type,
            l.dwfzone_id,
            dwfzone_table.dwfzone_type,
            l.dma_id,
            l.fluid_type
           FROM link l
             JOIN exploitation USING (expl_id)
             JOIN sector_table ON l.sector_id = sector_table.sector_id
             LEFT JOIN omzone_table ON l.omzone_id = omzone_table.omzone_id
             LEFT JOIN drainzone_table ON l.omzone_id = drainzone_table.drainzone_id
             LEFT JOIN dwfzone_table ON l.dwfzone_id = dwfzone_table.dwfzone_id
          WHERE l.state = 2
        ), connec_psector AS (
         SELECT DISTINCT ON (pp.connec_id, pp.state) pp.connec_id,
            pp.state AS p_state,
            pp.psector_id,
            pp.arc_id,
            pp.link_id
           FROM plan_psector_x_connec pp
             JOIN selector_psector sp ON sp.cur_user = CURRENT_USER AND sp.psector_id = pp.psector_id
          ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
        ), connec_selector AS (
         SELECT connec.connec_id,
            connec.arc_id,
            NULL::integer AS link_id
           FROM connec
             JOIN selector_state s ON s.cur_user = CURRENT_USER AND connec.state = s.state_id
             LEFT JOIN ( SELECT connec_psector.connec_id
                   FROM connec_psector
                  WHERE connec_psector.p_state = 0) a USING (connec_id)
          WHERE a.connec_id IS NULL AND (EXISTS ( SELECT 1
                   FROM selector_expl se
                  WHERE s.cur_user = CURRENT_USER AND (se.expl_id = ANY (array_append(connec.expl_visibility::integer[], connec.expl_id))))) AND (EXISTS ( SELECT 1
                   FROM selector_sector sc
                  WHERE sc.cur_user = CURRENT_USER AND sc.sector_id = connec.sector_id)) AND (EXISTS ( SELECT 1
                   FROM selector_municipality sm
                  WHERE sm.cur_user = CURRENT_USER AND sm.muni_id = connec.muni_id))
        UNION ALL
         SELECT connec_psector.connec_id,
            connec_psector.arc_id,
            connec_psector.link_id
           FROM connec_psector
          WHERE connec_psector.p_state = 1
        ), connec_selected AS (
         SELECT connec.connec_id,
            connec.code,
            connec.sys_code,
            connec.top_elev,
            connec.y1,
            connec.y2,
            cat_feature.feature_class AS sys_type,
            connec.connec_type::text AS connec_type,
            connec.matcat_id,
            connec.conneccat_id,
            connec.customer_code,
            connec.connec_depth,
            connec.connec_length,
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
            sector_table.sector_type,
                CASE
                    WHEN link_planned.drainzone_id IS NULL THEN dwfzone_table.drainzone_id
                    ELSE link_planned.drainzone_id
                END AS drainzone_id,
                CASE
                    WHEN link_planned.drainzone_type IS NULL THEN drainzone_table.drainzone_type
                    ELSE link_planned.drainzone_type
                END AS drainzone_type,
            connec.drainzone_outfall,
                CASE
                    WHEN link_planned.dwfzone_id IS NULL THEN connec.dwfzone_id
                    ELSE link_planned.dwfzone_id
                END AS dwfzone_id,
                CASE
                    WHEN link_planned.dwfzone_type IS NULL THEN dwfzone_table.dwfzone_type
                    ELSE link_planned.dwfzone_type
                END AS dwfzone_type,
            connec.dwfzone_outfall,
                CASE
                    WHEN link_planned.omzone_id IS NULL THEN connec.omzone_id
                    ELSE link_planned.omzone_id
                END AS omzone_id,
                CASE
                    WHEN link_planned.macroomzone_id IS NULL THEN omzone_table.macroomzone_id
                    ELSE link_planned.macroomzone_id
                END AS macroomzone_id,
                CASE
                    WHEN link_planned.omzone_type IS NULL THEN omzone_table.omzone_type
                    ELSE link_planned.omzone_type
                END AS omzone_type,
                CASE
                    WHEN link_planned.dma_id IS NULL THEN connec.dma_id
                    ELSE link_planned.dma_id
                END AS dma_id,
            connec.omunit_id,
            connec.minsector_id,
            connec.soilcat_id,
            connec.function_type,
            connec.category_type,
            connec.location_type,
            connec.fluid_type,
            connec.n_hydrometer,
            connec.n_inhabitants,
            connec.demand,
            connec.descript,
            connec.annotation,
            connec.observ,
            connec.comment,
            connec.link::text AS link,
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
            connec.plot_id,
            connec.workcat_id,
            connec.workcat_id_end,
            connec.workcat_id_plan,
            connec.builtdate,
            connec.enddate,
            connec.ownercat_id,
            connec.om_state,
                CASE
                    WHEN link_planned.exit_id IS NULL THEN connec.pjoint_id
                    ELSE link_planned.exit_id
                END AS pjoint_id,
                CASE
                    WHEN link_planned.exit_type IS NULL THEN connec.pjoint_type
                    ELSE link_planned.exit_type
                END AS pjoint_type,
            connec.access_type,
            connec.placement_type,
            connec.accessibility,
            connec.brand_id,
            connec.model_id,
            connec.asset_id,
            connec.adate,
            connec.adescript,
            connec.verified,
            connec.uncertain,
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
            sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
            drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
            dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
            omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
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
            connec.diagonal
           FROM connec_selector
             JOIN connec USING (connec_id)
             JOIN cat_connec ON cat_connec.id::text = connec.conneccat_id::text
             JOIN cat_feature ON cat_feature.id::text = connec.connec_type::text
             JOIN exploitation ON connec.expl_id = exploitation.expl_id
             JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
             JOIN value_state_type vst ON vst.id = connec.state_type
             JOIN sector_table ON sector_table.sector_id = connec.sector_id
             LEFT JOIN omzone_table ON omzone_table.omzone_id = connec.omzone_id
             LEFT JOIN drainzone_table ON connec.omzone_id = drainzone_table.drainzone_id
             LEFT JOIN dwfzone_table ON connec.dwfzone_id = dwfzone_table.dwfzone_id
             LEFT JOIN link_planned USING (link_id)
        )
 SELECT connec_id,
    code,
    sys_code,
    top_elev,
    y1,
    y2,
    sys_type,
    connec_type,
    matcat_id,
    conneccat_id,
    customer_code,
    connec_depth,
    connec_length,
    state,
    state_type,
    arc_id,
    expl_id,
    macroexpl_id,
    muni_id,
    sector_id,
    macrosector_id,
    sector_type,
    drainzone_id,
    drainzone_type,
    drainzone_outfall,
    dwfzone_id,
    dwfzone_type,
    dwfzone_outfall,
    omzone_id,
    macroomzone_id,
    omzone_type,
    dma_id,
    omunit_id,
    minsector_id,
    soilcat_id,
    function_type,
    category_type,
    location_type,
    fluid_type,
    n_hydrometer,
    n_inhabitants,
    demand,
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
    plot_id,
    workcat_id,
    workcat_id_end,
    workcat_id_plan,
    builtdate,
    enddate,
    ownercat_id,
    om_state,
    pjoint_id,
    pjoint_type,
    access_type,
    placement_type,
    accessibility,
    brand_id,
    model_id,
    asset_id,
    adate,
    adescript,
    verified,
    uncertain,
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
    sector_style,
    drainzone_style,
    dwfzone_style,
    omzone_style,
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
    diagonal
   FROM connec_selected;
   
CREATE or replace VIEW v_anl_node_massiveinterpolate
AS SELECT
    n.id,
    n.node_id,
    n.expl_id,
    fid,
    descript,
    top_elev::numeric(12,3),
    elev::numeric(12,3),
    ymax::numeric(12,3),
    n.cur_user,
    the_geom
  FROM anl_node n
    JOIN selector_expl s ON n.expl_id = s.expl_id 
  WHERE fid = 496 AND s.cur_user = current_user;

create or replace VIEW v_anl_arc_massiveinterpolate
AS SELECT
    a.id,
    a.arc_id,
    a.expl_id,
    fid,
    descript,
    a.cur_user,
    the_geom
  FROM anl_arc a
    JOIN selector_expl s ON a.expl_id = s.expl_id 
  WHERE fid = 496 AND s.cur_user = current_user;


DROP VIEW IF EXISTS ve_epa_conduit;
DROP VIEW IF EXISTS v_rpt_arcflow_sum;

CREATE OR REPLACE VIEW v_rpt_arcflow_sum AS 
SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_arcflow_sum.arc_type AS swarc_type,
    rpt_arcflow_sum.max_flow,
    rpt_arcflow_sum.time_days,
    rpt_arcflow_sum.time_hour,
    rpt_arcflow_sum.max_veloc,
    COALESCE(rpt_arcflow_sum.mfull_flow, 0::numeric(12,4)) AS mfull_flow,
    COALESCE(rpt_arcflow_sum.mfull_depth, 0::numeric(12,4)) AS mfull_depth,
    rpt_arcflow_sum.max_shear,
    rpt_arcflow_sum.max_hr,
    rpt_arcflow_sum.max_slope,
    rpt_arcflow_sum.day_max,
    rpt_arcflow_sum.time_max,
    rpt_arcflow_sum.min_shear,
    rpt_arcflow_sum.day_min,
    rpt_arcflow_sum.time_min
   FROM rpt_inp_arc
   JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = rpt_inp_arc.arc_id::TEXT
   AND rpt_arcflow_sum.result_id = rpt_inp_arc.result_id
  WHERE
EXISTS (SELECT 1 FROM selector_rpt_main r WHERE r.result_id = rpt_inp_arc.result_id AND r.cur_user = CURRENT_USER);


CREATE OR REPLACE VIEW ve_epa_conduit
AS SELECT inp_conduit.arc_id,
    inp_conduit.barrels,
    inp_conduit.culvert,
    inp_conduit.kentry,
    inp_conduit.kexit,
    inp_conduit.kavg,
    inp_conduit.flap,
    inp_conduit.q0,
    inp_conduit.qmax,
    inp_conduit.seepage,
    inp_conduit.custom_n,
    v_rpt_arcflow_sum.max_flow,
    v_rpt_arcflow_sum.time_days,
    v_rpt_arcflow_sum.time_hour,
    v_rpt_arcflow_sum.max_veloc,
    v_rpt_arcflow_sum.mfull_flow,
    v_rpt_arcflow_sum.mfull_depth,
    v_rpt_arcflow_sum.max_shear,
    v_rpt_arcflow_sum.max_hr,
    v_rpt_arcflow_sum.max_slope,
    v_rpt_arcflow_sum.day_max,
    v_rpt_arcflow_sum.time_max,
    v_rpt_arcflow_sum.min_shear,
    v_rpt_arcflow_sum.day_min,
    v_rpt_arcflow_sum.time_min
   FROM inp_conduit
     LEFT JOIN v_rpt_arcflow_sum ON inp_conduit.arc_id::text = v_rpt_arcflow_sum.arc_id::text;
