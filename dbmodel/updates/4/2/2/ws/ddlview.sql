/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_rpt_comp_arc
AS WITH main AS (
         SELECT r.arc_id,
            r.result_id,
            r.arc_type,
            r.sector_id,
            r.arccat_id,
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
            r.ffactor_min,
            arc.diameter,
            r.the_geom
           FROM rpt_arc_stats r
             JOIN selector_rpt_main s ON s.result_id::text = r.result_id::text
           	 LEFT JOIN rpt_inp_arc arc ON arc.arc_id::text = r.arc_id::TEXT AND arc.result_id = s.result_id 
          WHERE s.cur_user = CURRENT_USER
        ), compare AS (
         SELECT r.arc_id,
            r.result_id,
            r.arc_type,
            r.sector_id,
            r.arccat_id,
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
            r.ffactor_min,
            arc.diameter,
            r.the_geom
            FROM rpt_arc_stats r
             JOIN selector_rpt_compare s ON s.result_id::text = r.result_id::text
           	 LEFT JOIN rpt_inp_arc arc ON arc.arc_id::text = r.arc_id::TEXT AND arc.result_id = s.result_id 
          WHERE s.cur_user = CURRENT_USER
        )
 SELECT main.arc_id,
    main.arc_type,
    main.sector_id,
    main.arccat_id,
    main.result_id AS main_result,
    compare.result_id AS compare_result,
    main.flow_max AS flow_max_main,
    compare.flow_max AS flow_max_compare,
    main.flow_max - compare.flow_max AS flow_max_diff,
    main.flow_min AS flow_min_main,
    compare.flow_min AS flow_min_compare,
    main.flow_min - compare.flow_min AS flow_min_diff,
    main.flow_avg AS flow_avg_main,
    compare.flow_avg AS flow_avg_compare,
    main.flow_avg - compare.flow_avg AS flow_avg_diff,
    main.vel_max AS vel_max_main,
    compare.vel_max AS vel_max_compare,
    main.vel_max - compare.vel_max AS vel_max_diff,
    main.vel_min AS vel_min_main,
    compare.vel_min AS vel_min_compare,
    main.vel_min - compare.vel_min AS vel_min_diff,
    main.vel_avg AS vel_avg_main,
    compare.vel_avg AS vel_avg_compare,
    main.vel_avg - compare.vel_avg AS vel_avg_diff,
    main.headloss_max AS headloss_max_main,
    compare.headloss_max AS headloss_max_compare,
    main.headloss_max - compare.headloss_max AS headloss_max_diff,
    main.headloss_min AS headloss_min_main,
    compare.headloss_min AS headloss_min_compare,
    main.headloss_min - compare.headloss_min AS headloss_min_diff,
    main.setting_max AS setting_max_main,
    compare.setting_max AS setting_max_compare,
    main.setting_max - compare.setting_max AS setting_max_diff,
    main.setting_min AS setting_min_main,
    compare.setting_min AS setting_min_compare,
    main.setting_min - compare.setting_min AS setting_min_diff,
    main.reaction_max AS reaction_max_main,
    compare.reaction_max AS reaction_max_compare,
    main.reaction_max - compare.reaction_max AS reaction_max_diff,
    main.reaction_min AS reaction_min_main,
    compare.reaction_min AS reaction_min_compare,
    main.reaction_min - compare.reaction_min AS reaction_min_diff,
    main.ffactor_max AS ffactor_max_main,
    compare.ffactor_max AS ffactor_max_compare,
    main.ffactor_max - compare.ffactor_max AS ffactor_max_diff,
    main.ffactor_min AS ffactor_min_main,
    compare.ffactor_min AS ffactor_min_compare,
    main.ffactor_min - compare.ffactor_min AS ffactor_min_diff,
    main.diameter AS diameter_main,
    compare.diameter AS diameter_compare,
    main.diameter - compare.diameter AS diameter_diff,
    main.the_geom
   FROM main
     JOIN compare ON main.arc_id::text = compare.arc_id::text;

DROP VIEW IF EXISTS ve_minsector_mincut;
CREATE OR REPLACE VIEW ve_minsector_mincut
AS WITH sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        ), minsector_mapzones AS (
         SELECT t.mincut_minsector_id AS minsector_id,
            array_agg(DISTINCT t.dma_id) AS dma_id,
            array_agg(DISTINCT t.dqa_id) AS dqa_id,
            array_agg(DISTINCT t.presszone_id) AS presszone_id,
            array_agg(DISTINCT t.expl_id) AS expl_id,
            array_agg(DISTINCT t.sector_id) AS sector_id,
            array_agg(DISTINCT t.muni_id) AS muni_id,
            array_agg(DISTINCT t.supplyzone_id) AS supplyzone_id,
            st_union(t.the_geom) AS the_geom
           FROM ( SELECT m_1.minsector_id,
                    mm.minsector_id AS mincut_minsector_id,
                    unnest(m_1.dma_id) AS dma_id,
                    unnest(m_1.dqa_id) AS dqa_id,
                    unnest(m_1.presszone_id) AS presszone_id,
                    unnest(m_1.expl_id) AS expl_id,
                    unnest(m_1.sector_id) AS sector_id,
                    unnest(m_1.muni_id) AS muni_id,
                    unnest(m_1.supplyzone_id) AS supplyzone_id,
                    m_1.the_geom
                   FROM minsector m_1
                     JOIN minsector_mincut mm ON mm.mincut_minsector_id = m_1.minsector_id) t
          GROUP BY t.mincut_minsector_id
        ), minsector_sums AS (
         SELECT mm.minsector_id,
            sum(m_1.num_border) AS num_border,
            sum(m_1.num_connec) AS num_connec,
            sum(m_1.num_hydro) AS num_hydro,
            sum(m_1.length) AS length
           FROM minsector_mincut mm
             JOIN minsector m_1 ON m_1.minsector_id = mm.mincut_minsector_id
          GROUP BY mm.minsector_id
        )
 SELECT m.minsector_id,
    m.dma_id,
    m.dqa_id,
    m.presszone_id,
    m.expl_id,
    m.sector_id,
    m.muni_id,
    m.supplyzone_id,
    s.num_border,
    s.num_connec,
    s.num_hydro,
    s.length,
    m.the_geom::geometry(Polygon, SRID_VALUE) AS the_geom
   FROM minsector_mapzones m
     JOIN minsector_sums s ON s.minsector_id = m.minsector_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = ANY (m.expl_id)));


CREATE OR REPLACE VIEW v_rpt_arc_stats
AS SELECT r.arc_id,
    r.result_id,
    rpt_cat_result.flow_units,
    rpt_cat_result.quality_units,
    r.arc_type,
    r.sector_id,
    r.arccat_id,
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
    r.ffactor_min,
    r.length,
    r.tot_headloss_max,
    r.tot_headloss_min,
    arc.diameter,
    r.the_geom
   FROM rpt_arc_stats r
     JOIN selector_rpt_main s ON s.result_id::text = r.result_id::text
     JOIN rpt_inp_arc arc ON arc.result_id::text = s.result_id::text AND arc.arc_id = r.arc_id 
     JOIN rpt_cat_result ON rpt_cat_result.result_id::text = s.result_id::text
  WHERE s.cur_user = CURRENT_USER;
  
  
CREATE OR REPLACE VIEW ve_arc
AS 
WITH sel_state AS (
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
		SELECT DISTINCT ON (pp.arc_id) pp.arc_id,
		pp.state AS p_state
		FROM plan_psector_x_arc pp
		JOIN selector_psector sp ON sp.cur_user = CURRENT_USER AND sp.psector_id = pp.psector_id
		ORDER BY pp.arc_id, pp.state
		), arc_selector AS (
		SELECT a.arc_id, NULL AS p_state
		FROM arc a
		WHERE (EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = a.state)) 
		AND (EXISTS (SELECT 1 FROM sel_sector s WHERE s.sector_id = a.sector_id)) 
		AND (EXISTS (SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(a.expl_visibility::integer[], a.expl_id)))) 
		AND (EXISTS (SELECT 1 FROM sel_muni s WHERE s.muni_id = a.muni_id)) 
		AND NOT (EXISTS (SELECT 1 FROM arc_psector ap WHERE ap.arc_id = a.arc_id))
        UNION ALL
        SELECT ap.arc_id, ap.p_state
		FROM arc_psector ap
		WHERE (EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = ap.p_state))
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
			--arc_selector.p_state,
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
            arc.the_geom
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
	--p_state,
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
    the_geom
   FROM arc_selected;
