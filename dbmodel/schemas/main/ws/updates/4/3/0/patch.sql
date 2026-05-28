/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"rpt_inp_pattern_value", "column":"result_id", "dataType":"varchar(100)"}}$$);

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
    m.the_geom::geometry(MultiPolygon, SRID_VALUE) AS the_geom
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
AS WITH 
  sel_state AS (
    SELECT selector_state.state_id
    FROM selector_state
    WHERE selector_state.cur_user = CURRENT_USER
  ),
  sel_sector AS (
    SELECT selector_sector.sector_id
    FROM selector_sector
    WHERE selector_sector.cur_user = CURRENT_USER
  ),
  sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
  ),
  sel_muni AS (
    SELECT selector_municipality.muni_id
    FROM selector_municipality
    WHERE selector_municipality.cur_user = CURRENT_USER
  ),
  sel_ps AS (
    SELECT selector_psector.psector_id
    FROM selector_psector
    WHERE selector_psector.cur_user = CURRENT_USER
  ),
  typevalue AS (
    SELECT 
      edit_typevalue.typevalue,
      edit_typevalue.id,
      edit_typevalue.idval
    FROM edit_typevalue
    WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
  ),
  sector_table AS (
    SELECT
      sector.sector_id,
      sector.macrosector_id,
      sector.stylesheet,
      t.id::character varying(16) AS sector_type
    FROM sector
    LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
  ),
  dma_table AS (
    SELECT
      dma.dma_id,
      dma.macrodma_id,
      dma.stylesheet,
      t.id::character varying(16) AS dma_type
    FROM dma
    LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
  ),
  presszone_table AS (
    SELECT 
      presszone.presszone_id,
      presszone.head AS presszone_head,
      presszone.stylesheet,
      t.id::character varying(16) AS presszone_type
    FROM presszone
    LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
  ),
  dqa_table AS (
    SELECT
      dqa.dqa_id,
      dqa.stylesheet,
      t.id::character varying(16) AS dqa_type,
      dqa.macrodqa_id
    FROM dqa
    LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type::text AND t.typevalue::text = 'dqa_type'::text
  ),
  supplyzone_table AS (
    SELECT
      supplyzone.supplyzone_id,
      supplyzone.stylesheet,
      t.id::character varying(16) AS supplyzone_type
    FROM supplyzone
    LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type::text AND t.typevalue::text = 'supplyzone_type'::text
  ),
  omzone_table AS (
    SELECT
      omzone.omzone_id,
      t.id::character varying(16) AS omzone_type,
      omzone.macroomzone_id
      FROM omzone
        LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
  ),
  arc_psector AS (
		SELECT DISTINCT ON (pp.arc_id, pp.state)
      pp.arc_id,
		  pp.state AS p_state
		FROM plan_psector_x_arc pp
    WHERE (EXISTS (SELECT 1 FROM sel_ps s WHERE s.psector_id = pp.psector_id))
		ORDER BY pp.arc_id, pp.state
	),
  arc_selector AS (
		SELECT 
      a.arc_id, 
      NULL AS p_state
		FROM arc a
		WHERE (EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = a.state)) 
		AND (EXISTS (SELECT 1 FROM sel_sector s WHERE s.sector_id = a.sector_id)) 
		AND (EXISTS (SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(a.expl_visibility::integer[], a.expl_id)))) 
		AND (EXISTS (SELECT 1 FROM sel_muni s WHERE s.muni_id = a.muni_id)) 
		AND NOT (EXISTS (SELECT 1 FROM arc_psector ap WHERE ap.arc_id = a.arc_id))
    UNION ALL
    SELECT
      ap.arc_id,
      ap.p_state
		FROM arc_psector ap
		WHERE (EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = ap.p_state))
  ),
  arc_selected AS (
    SELECT
      arc.arc_id,
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
      arc_selector.p_state
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
SELECT 
  arc_id,
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
  p_state
FROM arc_selected;

CREATE OR REPLACE VIEW ve_node
AS WITH 
  sel_state AS (
    SELECT selector_state.state_id
    FROM selector_state
    WHERE selector_state.cur_user = CURRENT_USER
    ),
  sel_sector AS (
    SELECT selector_sector.sector_id
    FROM selector_sector
    WHERE selector_sector.cur_user = CURRENT_USER
  ),
  sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
  ), 
  sel_muni AS (
    SELECT selector_municipality.muni_id
    FROM selector_municipality
    WHERE selector_municipality.cur_user = CURRENT_USER
  ), 
  sel_ps AS (
    SELECT selector_psector.psector_id
    FROM selector_psector
    WHERE selector_psector.cur_user = CURRENT_USER
  ), 
  typevalue AS (
    SELECT 
      edit_typevalue.typevalue,
      edit_typevalue.id,
      edit_typevalue.idval
    FROM edit_typevalue
    WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
  ),
  sector_table AS (
    SELECT 
      sector.sector_id,
      sector.macrosector_id,
      sector.stylesheet,
      t.id::character varying(16) AS sector_type
    FROM sector
    LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
  ), 
  dma_table AS (
    SELECT 
      dma.dma_id,
      dma.macrodma_id,
      dma.stylesheet,
      t.id::character varying(16) AS dma_type
    FROM dma
    LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
  ),
  presszone_table AS (
    SELECT 
      presszone.presszone_id,
      presszone.head AS presszone_head,
      presszone.stylesheet,
      t.id::character varying(16) AS presszone_type
    FROM presszone
    LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
  ),
  dqa_table AS (
    SELECT 
      dqa.dqa_id,
      dqa.stylesheet,
      t.id::character varying(16) AS dqa_type,
      dqa.macrodqa_id
    FROM dqa
    LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type::text AND t.typevalue::text = 'dqa_type'::text
  ), 
  supplyzone_table AS (
    SELECT 
      supplyzone.supplyzone_id,
      supplyzone.stylesheet,
      t.id::character varying(16) AS supplyzone_type
    FROM supplyzone
    LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type::text AND t.typevalue::text = 'supplyzone_type'::text
  ), 
  omzone_table AS (
    SELECT 
      omzone.omzone_id,
      t.id::character varying(16) AS omzone_type,
      omzone.macroomzone_id
    FROM omzone
    LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
  ), 
  node_psector AS (
    SELECT DISTINCT ON (pp.node_id, pp.state) 
      pp.node_id,
      pp.state AS p_state
    FROM plan_psector_x_node pp
    WHERE (EXISTS (SELECT 1 FROM sel_ps s WHERE s.psector_id = pp.psector_id))
    ORDER BY pp.node_id, pp.state
  ), 
  node_selector AS (
    SELECT 
      n_1.node_id, 
      NULL AS p_state
    FROM node n_1
    WHERE (EXISTS ( SELECT 1 FROM sel_state s WHERE s.state_id = n_1.state)) 
    AND (EXISTS ( SELECT 1 FROM sel_sector s WHERE s.sector_id = n_1.sector_id)) 
    AND (EXISTS ( SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(n_1.expl_visibility, n_1.expl_id)))) 
    AND (EXISTS ( SELECT 1 FROM sel_muni s WHERE s.muni_id = n_1.muni_id)) 
    AND NOT (EXISTS ( SELECT 1 FROM node_psector np WHERE np.node_id = n_1.node_id))
    UNION ALL
    SELECT 
      np.node_id,
      np.p_state
    FROM node_psector np
    WHERE (EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = np.p_state))
  ),
  node_selected AS (
    SELECT 
      node.node_id,
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
      node_selector.p_state
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
SELECT 
  node_id,
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
  p_state
FROM node_selected n;

CREATE OR REPLACE VIEW ve_connec
AS WITH 
  sel_state AS (
    SELECT selector_state.state_id
    FROM selector_state
    WHERE selector_state.cur_user = CURRENT_USER
  ), 
  sel_sector AS (
    SELECT selector_sector.sector_id
    FROM selector_sector
    WHERE selector_sector.cur_user = CURRENT_USER
  ), 
  sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
  ), 
  sel_muni AS (
    SELECT selector_municipality.muni_id
    FROM selector_municipality
    WHERE selector_municipality.cur_user = CURRENT_USER
  ), 
  sel_ps AS (
    SELECT selector_psector.psector_id
      FROM selector_psector
    WHERE selector_psector.cur_user = CURRENT_USER
  ), 
  typevalue AS (
    SELECT 
      edit_typevalue.typevalue,
      edit_typevalue.id,
      edit_typevalue.idval
    FROM edit_typevalue
    WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
  ), 
  sector_table AS (
    SELECT 
      sector.sector_id,
      sector.macrosector_id,
      sector.stylesheet,
      t.id::character varying(16) AS sector_type
    FROM sector
    LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
  ), 
  dma_table AS (
    SELECT 
      dma.dma_id,
      dma.macrodma_id,
      dma.stylesheet,
      t.id::character varying(16) AS dma_type
    FROM dma
    LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
  ), 
  presszone_table AS (
    SELECT 
      presszone.presszone_id,
      presszone.head AS presszone_head,
      presszone.stylesheet,
      t.id::character varying(16) AS presszone_type
    FROM presszone
    LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
  ), 
  dqa_table AS (
    SELECT 
      dqa.dqa_id,
      dqa.stylesheet,
      t.id::character varying(16) AS dqa_type,
      dqa.macrodqa_id
    FROM dqa
    LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type::text AND t.typevalue::text = 'dqa_type'::text
  ), 
  supplyzone_table AS (
    SELECT 
      supplyzone.supplyzone_id,
      supplyzone.stylesheet,
      t.id::character varying(16) AS supplyzone_type
    FROM supplyzone
    LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type::text AND t.typevalue::text = 'supplyzone_type'::text
  ), 
  omzone_table AS (
    SELECT 
      omzone.omzone_id,
      t.id::character varying(16) AS omzone_type,
      omzone.macroomzone_id
    FROM omzone
    LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
  ), 
  inp_network_mode AS (
    SELECT config_param_user.value
    FROM config_param_user
    WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
  ), 
  link_planned AS (
    SELECT 
      l.link_id,
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
  ), 
  connec_psector AS (
    SELECT DISTINCT ON (pp.connec_id, pp.state) 
    pp.connec_id,
    pp.state AS p_state,
    pp.psector_id,
    pp.arc_id,
    pp.link_id
  FROM plan_psector_x_connec pp
  WHERE (EXISTS (SELECT 1 FROM sel_ps s WHERE s.psector_id = pp.psector_id))
  ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
  ), 
  connec_selector AS (
    SELECT 
      c_1.connec_id,
      c_1.arc_id,
      NULL::integer AS link_id,
      NULL AS p_state
    FROM connec c_1
    WHERE (EXISTS ( SELECT 1 FROM sel_state s WHERE s.state_id = c_1.state)) 
    AND (EXISTS ( SELECT 1 FROM sel_sector s WHERE s.sector_id = c_1.sector_id)) 
    AND (EXISTS ( SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(c_1.expl_visibility::integer[], c_1.expl_id)))) 
    AND (EXISTS ( SELECT 1 FROM sel_muni s WHERE s.muni_id = c_1.muni_id)) 
    AND NOT (EXISTS ( SELECT 1 FROM connec_psector cp WHERE cp.connec_id = c_1.connec_id))
    UNION ALL
    SELECT 
      cp.connec_id,
      cp.arc_id,
      cp.link_id,
      cp.p_state
    FROM connec_psector cp
    WHERE (EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = cp.p_state))
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
      connec_selector.p_state
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
SELECT 
  connec_id,
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
  p_state
FROM connec_selected c;

CREATE OR REPLACE VIEW ve_link
AS WITH 
  sel_state AS (
    SELECT selector_state.state_id
    FROM selector_state
    WHERE selector_state.cur_user = CURRENT_USER
  ), 
  sel_sector AS (
    SELECT selector_sector.sector_id
    FROM selector_sector
    WHERE selector_sector.cur_user = CURRENT_USER
  ),
  sel_expl AS (
    SELECT selector_expl.expl_id
    FROM selector_expl
    WHERE selector_expl.cur_user = CURRENT_USER
  ),
  sel_muni AS (
    SELECT selector_municipality.muni_id
    FROM selector_municipality
    WHERE selector_municipality.cur_user = CURRENT_USER
  ),
  sel_ps AS (
    SELECT selector_psector.psector_id
    FROM selector_psector
    WHERE selector_psector.cur_user = CURRENT_USER
  ),
  typevalue AS (
    SELECT 
      edit_typevalue.typevalue,
      edit_typevalue.id,
      edit_typevalue.idval
    FROM edit_typevalue
    WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
  ),
  sector_table AS (
    SELECT 
      sector.sector_id,
      sector.macrosector_id,
      sector.stylesheet,
      t.id::character varying(16) AS sector_type
    FROM sector
    LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
  ),
  dma_table AS (
    SELECT 
      dma.dma_id,
      dma.macrodma_id,
      dma.stylesheet,
      t.id::character varying(16) AS dma_type
    FROM dma
    LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
  ),
    presszone_table AS (
    SELECT 
      presszone.presszone_id,
      presszone.head AS presszone_head,
      presszone.stylesheet,
      t.id::character varying(16) AS presszone_type
    FROM presszone
    LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
  ),
  dqa_table AS (
    SELECT
      dqa.dqa_id,
      dqa.stylesheet,
      t.id::character varying(16) AS dqa_type,
      dqa.macrodqa_id
    FROM dqa
    LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type::text AND t.typevalue::text = 'dqa_type'::text
  ),
  supplyzone_table AS (
    SELECT 
      supplyzone.supplyzone_id,
      supplyzone.stylesheet,
      t.id::character varying(16) AS supplyzone_type
    FROM supplyzone
    LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type::text AND t.typevalue::text = 'supplyzone_type'::text
  ),
    omzone_table AS (
    SELECT 
      omzone.omzone_id,
      t.id::character varying(16) AS omzone_type,
      omzone.macroomzone_id
    FROM omzone
    LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
  ),
  inp_network_mode AS (
    SELECT config_param_user.value
    FROM config_param_user
    WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
  ),
  link_psector AS (
    SELECT DISTINCT ON (pp.connec_id, pp.state) 
      'CONNEC'::text AS feature_type,
      pp.connec_id AS feature_id,
      pp.state AS p_state,
      pp.psector_id,
      pp.link_id
    FROM plan_psector_x_connec pp
    WHERE (EXISTS (SELECT 1 FROM sel_ps s WHERE s.psector_id = pp.psector_id))
    ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
  ),
  link_selector AS (
    SELECT 
      l_1.link_id,
      NULL AS p_state
    FROM link l_1
    WHERE (EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = l_1.state)) 
    AND (EXISTS (SELECT 1 FROM sel_sector s WHERE s.sector_id = l_1.sector_id)) 
    AND (EXISTS (SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(l_1.expl_visibility::integer[], l_1.expl_id)))) 
    AND (EXISTS (SELECT 1 FROM sel_muni s WHERE s.muni_id = l_1.muni_id)) 
    AND NOT (EXISTS (SELECT 1 FROM link_psector lp WHERE lp.link_id = l_1.link_id))
    UNION ALL
    SELECT 
      lp.link_id,
      lp.p_state
    FROM link_psector lp
    WHERE (EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = lp.p_state))
  ),
  link_selected AS (
    SELECT 
      l_1.link_id,
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
      link_selector.p_state
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
SELECT 
  link_id,
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
  p_state
FROM link_selected l;



DROP VIEW IF EXISTS ve_epa_valve;
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
            WHEN v.to_arc IS NOT NULL AND v.closed IS FALSE THEN 'ACTIVE'::character varying(12)
            WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN v.closed IS FALSE THEN 'OPEN'::character varying(12)
            ELSE NULL::character varying(12)
        END AS status,
    inp_valve.add_settings,
    inp_valve.init_quality,
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
     LEFT JOIN v_rpt_arc_stats ON concat(inp_valve.node_id, '_n2a') = v_rpt_arc_stats.arc_id::text
     LEFT JOIN man_valve v ON v.node_id = inp_valve.node_id;

INSERT INTO sys_table (id,descript,sys_role,alias, context) VALUES ('ve_inp_frshortpipe','ve_inp_frshortpipe','role_edit','Inp flwreg shortpipe', '{"levels": ["EPA", "HYDRAULICS"]}');
UPDATE sys_table SET descript='ve_inp_frpump', context = '{"levels": ["EPA", "HYDRAULICS"]}', alias = 'Inp flwreg pump' WHERE id='ve_inp_frpump';
UPDATE sys_table SET descript='ve_inp_frvalve', context = '{"levels": ["EPA", "HYDRAULICS"]}', alias = 'Inp flwreg valve' WHERE id='ve_inp_frvalve';

UPDATE config_form_fields SET dv_isnullvalue = true WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_epa';
UPDATE config_form_fields SET dv_isnullvalue = true WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
INSERT INTO sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('inp_frshortpipe', 'inp_frshortpipe', 'role_edit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


UPDATE sys_style SET layername='v_rpt_arc_stats' WHERE layername='v_rpt_arc' AND styleconfig_id=101;

UPDATE sys_style SET layername='v_rpt_node_stats' WHERE layername='v_rpt_node' AND styleconfig_id=101;

INSERT INTO sys_table (id,descript,sys_role,context,orderby,alias,"source")
VALUES ('ve_minsector_mincut','Shows editable information about mincut misectors','role_edit','{"levels": ["OM", "ANALYTICS"]}',3,'Minsector mincut','core');
UPDATE sys_table SET context='{"levels": ["OM", "ANALYTICS"]}', orderby =2 WHERE id='ve_minsector';

UPDATE sys_table SET context='{"levels": ["EPA", "RESULTS"]}' WHERE id='v_rpt_arc_stats' OR id='v_rpt_node_stats';
UPDATE sys_table SET alias = 'Node maximum values' WHERE id='v_rpt_node_stats';
UPDATE sys_table SET alias = 'Arc maximum values' WHERE id='v_rpt_arc_stats';
UPDATE sys_table SET alias = 'Node values' WHERE id='v_rpt_node';
UPDATE sys_table SET alias = 'Arc values' WHERE id='v_rpt_arc';

UPDATE sys_style SET stylevalue = replace(replace(stylevalue, 'max_pressure', 'press_max'), 'min_pressure', 'press_min') WHERE layername = 'v_rpt_node_stats' AND styleconfig_id = 101;
UPDATE sys_style SET stylevalue = replace(stylevalue, 'max_vel', 'vel_max') WHERE layername = 'v_rpt_arc_stats' AND styleconfig_id = 101;


INSERT INTO sys_style (layername,styleconfig_id,styletype,stylevalue,active)
	VALUES ('ve_anl_hydrant',101,'qml','<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.34.13-Prizren" minScale="100000000" maxScale="0" hasScaleBasedVisibilityFlag="0" simplifyDrawingTol="1" autoRefreshMode="Disabled" readOnly="0" labelsEnabled="0" simplifyAlgorithm="0" autoRefreshTime="0" simplifyDrawingHints="0" simplifyLocal="1" styleCategories="AllStyleCategories" simplifyMaxScale="1" symbologyReferenceScale="-1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
    <Private>0</Private>
  </flags>
  <temporal endField="" durationField="expl_id" fixedDuration="0" startField="" startExpression="" durationUnit="min" limitMode="0" endExpression="" mode="0" accumulate="0" enabled="0">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <elevation respectLayerSymbol="1" clamping="Terrain" binding="Centroid" extrusionEnabled="0" extrusion="0" zscale="1" symbology="Line" showMarkerSymbolInSurfacePlots="0" type="IndividualFeatures" zoffset="0">
    <data-defined-properties>
      <Option type="Map">
        <Option name="name" type="QString" value=""/>
        <Option name="properties"/>
        <Option name="type" type="QString" value="collection"/>
      </Option>
    </data-defined-properties>
    <profileLineSymbol>
      <symbol force_rhr="0" name="" clip_to_extent="1" is_animated="0" alpha="1" frame_rate="10" type="line">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" id="{df0aa392-6be4-48f7-8492-b8cb2c0a413d}" class="SimpleLine" pass="0" enabled="1">
          <Option type="Map">
            <Option name="align_dash_pattern" type="QString" value="0"/>
            <Option name="capstyle" type="QString" value="square"/>
            <Option name="customdash" type="QString" value="5;2"/>
            <Option name="customdash_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="customdash_unit" type="QString" value="MM"/>
            <Option name="dash_pattern_offset" type="QString" value="0"/>
            <Option name="dash_pattern_offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="dash_pattern_offset_unit" type="QString" value="MM"/>
            <Option name="draw_inside_polygon" type="QString" value="0"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="line_color" type="QString" value="225,89,137,255"/>
            <Option name="line_style" type="QString" value="solid"/>
            <Option name="line_width" type="QString" value="0.6"/>
            <Option name="line_width_unit" type="QString" value="MM"/>
            <Option name="offset" type="QString" value="0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="ring_filter" type="QString" value="0"/>
            <Option name="trim_distance_end" type="QString" value="0"/>
            <Option name="trim_distance_end_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="trim_distance_end_unit" type="QString" value="MM"/>
            <Option name="trim_distance_start" type="QString" value="0"/>
            <Option name="trim_distance_start_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="trim_distance_start_unit" type="QString" value="MM"/>
            <Option name="tweak_dash_pattern_on_corners" type="QString" value="0"/>
            <Option name="use_custom_dash" type="QString" value="0"/>
            <Option name="width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </profileLineSymbol>
    <profileFillSymbol>
      <symbol force_rhr="0" name="" clip_to_extent="1" is_animated="0" alpha="1" frame_rate="10" type="fill">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" id="{bf2031e6-1d46-47fa-b7f3-77d4f21905d5}" class="SimpleFill" pass="0" enabled="1">
          <Option type="Map">
            <Option name="border_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="color" type="QString" value="225,89,137,255"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="161,64,98,255"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0.2"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="style" type="QString" value="solid"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </profileFillSymbol>
    <profileMarkerSymbol>
      <symbol force_rhr="0" name="" clip_to_extent="1" is_animated="0" alpha="1" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" id="{5a2677f6-aa66-4ca1-b56e-24a86e654923}" class="SimpleMarker" pass="0" enabled="1">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="225,89,137,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="diamond"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="161,64,98,255"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0.2"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="3"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </profileMarkerSymbol>
  </elevation>
  <renderer-v2 referencescale="-1" forceraster="0" symbollevels="0" enableorderby="0" type="singleSymbol">
    <symbols>
      <symbol force_rhr="0" name="0" clip_to_extent="1" is_animated="0" alpha="1" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" id="{f59fe184-ae7f-48d2-b1c9-9663e9c42c1c}" class="SimpleMarker" pass="0" enabled="1">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="255,0,0,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="35,35,35,255"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="4"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" id="{39257a96-df20-4f1c-bb06-b83e567ccd96}" class="FontMarker" pass="0" enabled="1">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="chr" type="QString" value="H"/>
            <Option name="color" type="QString" value="255,255,255,255"/>
            <Option name="font" type="QString" value="Arial"/>
            <Option name="font_style" type="QString" value="Normal"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="128,17,25,255"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="size" type="QString" value="3"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol force_rhr="0" name="" clip_to_extent="1" is_animated="0" alpha="1" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" id="{dc58f076-b70b-4853-9388-0321dde98bf4}" class="SimpleMarker" pass="0" enabled="1">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="255,0,0,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="35,35,35,255"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="2"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <customproperties>
    <Option type="Map">
      <Option name="dualview/previewExpressions" type="List">
        <Option type="QString" value="&quot;node_id&quot;"/>
      </Option>
      <Option name="embeddedWidgets/count" type="int" value="0"/>
      <Option name="variableNames"/>
      <Option name="variableValues"/>
    </Option>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory backgroundAlpha="255" height="15" sizeType="MM" minimumSize="0" direction="0" width="15" penWidth="0" scaleBasedVisibility="0" backgroundColor="#ffffff" lineSizeType="MM" scaleDependency="Area" opacity="1" diagramOrientation="Up" enabled="0" maxScaleDenominator="1e+08" showAxis="1" sizeScale="3x:0,0,0,0,0,0" labelPlacementMethod="XHeight" barWidth="5" minScaleDenominator="0" spacingUnitScale="3x:0,0,0,0,0,0" lineSizeScale="3x:0,0,0,0,0,0" penAlpha="255" penColor="#000000" spacing="5" rotationOffset="270" spacingUnit="MM">
      <fontProperties strikethrough="0" style="" italic="0" description="MS Shell Dlg 2,7.8,-1,5,50,0,0,0,0,0" underline="0" bold="0"/>
      <axisSymbol>
        <symbol force_rhr="0" name="" clip_to_extent="1" is_animated="0" alpha="1" frame_rate="10" type="line">
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
          <layer locked="0" id="{9103bdcc-7c15-41a0-b913-db49344fbeb1}" class="SimpleLine" pass="0" enabled="1">
            <Option type="Map">
              <Option name="align_dash_pattern" type="QString" value="0"/>
              <Option name="capstyle" type="QString" value="square"/>
              <Option name="customdash" type="QString" value="5;2"/>
              <Option name="customdash_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
              <Option name="customdash_unit" type="QString" value="MM"/>
              <Option name="dash_pattern_offset" type="QString" value="0"/>
              <Option name="dash_pattern_offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
              <Option name="dash_pattern_offset_unit" type="QString" value="MM"/>
              <Option name="draw_inside_polygon" type="QString" value="0"/>
              <Option name="joinstyle" type="QString" value="bevel"/>
              <Option name="line_color" type="QString" value="35,35,35,255"/>
              <Option name="line_style" type="QString" value="solid"/>
              <Option name="line_width" type="QString" value="0.26"/>
              <Option name="line_width_unit" type="QString" value="MM"/>
              <Option name="offset" type="QString" value="0"/>
              <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
              <Option name="offset_unit" type="QString" value="MM"/>
              <Option name="ring_filter" type="QString" value="0"/>
              <Option name="trim_distance_end" type="QString" value="0"/>
              <Option name="trim_distance_end_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
              <Option name="trim_distance_end_unit" type="QString" value="MM"/>
              <Option name="trim_distance_start" type="QString" value="0"/>
              <Option name="trim_distance_start_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
              <Option name="trim_distance_start_unit" type="QString" value="MM"/>
              <Option name="tweak_dash_pattern_on_corners" type="QString" value="0"/>
              <Option name="use_custom_dash" type="QString" value="0"/>
              <Option name="width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            </Option>
            <data_defined_properties>
              <Option type="Map">
                <Option name="name" type="QString" value=""/>
                <Option name="properties"/>
                <Option name="type" type="QString" value="collection"/>
              </Option>
            </data_defined_properties>
          </layer>
        </symbol>
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings placement="0" linePlacementFlags="18" priority="0" obstacle="0" showAll="1" zIndex="0" dist="0">
    <properties>
      <Option type="Map">
        <Option name="name" type="QString" value=""/>
        <Option name="properties"/>
        <Option name="type" type="QString" value="collection"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <legend type="default-vector" showLabelLegend="0"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field name="node_id" configurationFlags="NoFlag">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="nodecat_id" configurationFlags="NoFlag">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="expl_id" configurationFlags="NoFlag">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias index="0" name="" field="node_id"/>
    <alias index="1" name="" field="nodecat_id"/>
    <alias index="2" name="" field="expl_id"/>
  </aliases>
  <splitPolicies>
    <policy policy="Duplicate" field="node_id"/>
    <policy policy="Duplicate" field="nodecat_id"/>
    <policy policy="Duplicate" field="expl_id"/>
  </splitPolicies>
  <defaults>
    <default applyOnUpdate="0" field="node_id" expression=""/>
    <default applyOnUpdate="0" field="nodecat_id" expression=""/>
    <default applyOnUpdate="0" field="expl_id" expression=""/>
  </defaults>
  <constraints>
    <constraint notnull_strength="1" exp_strength="0" constraints="3" field="node_id" unique_strength="1"/>
    <constraint notnull_strength="0" exp_strength="0" constraints="0" field="nodecat_id" unique_strength="0"/>
    <constraint notnull_strength="0" exp_strength="0" constraints="0" field="expl_id" unique_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="node_id" desc=""/>
    <constraint exp="" field="nodecat_id" desc=""/>
    <constraint exp="" field="expl_id" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig sortOrder="0" actionWidgetStyle="dropDown" sortExpression="">
    <columns>
      <column name="node_id" hidden="0" width="-1" type="field"/>
      <column name="nodecat_id" hidden="0" width="-1" type="field"/>
      <column name="expl_id" hidden="0" width="-1" type="field"/>
      <column hidden="1" width="-1" type="actions"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[QGISQGIS# -*- coding: utf-8 -*-
"""
Los formularios QGIS pueden tener una función de Python a la que se llama cuando el formulario es abierto.

Utilice esta función para agregar lógica adicional a sus formularios.

Ingrese el nombre de la función en el campo"Función de inicio de Python" .
A continuación se muestra un ejemplo:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
    geom = feature.geometry()
    control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
  <featformsuppress>1</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field name="expl_id" editable="1"/>
    <field name="node_id" editable="1"/>
    <field name="nodecat_id" editable="1"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="expl_id"/>
    <field labelOnTop="0" name="node_id"/>
    <field labelOnTop="0" name="nodecat_id"/>
  </labelOnTop>
  <reuseLastValue>
    <field reuseLastValue="0" name="expl_id"/>
    <field reuseLastValue="0" name="node_id"/>
    <field reuseLastValue="0" name="nodecat_id"/>
  </reuseLastValue>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"node_id"</previewExpression>
  <mapTip enabled="1"></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>',true);

UPDATE sys_table SET addparam = addparam::jsonb || '{"layerProp": {"hiddenForm": "true"}}'::jsonb WHERE id = 've_anl_hydrant';

INSERT INTO sys_style (layername, styleconfig_id, styletype, stylevalue, active) VALUES('ve_minsector_mincut', 101, 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis hasScaleBasedVisibilityFlag="0" minScale="0" version="3.40.9-Bratislava" simplifyMaxScale="1" autoRefreshTime="0" simplifyAlgorithm="0" symbologyReferenceScale="-1" autoRefreshMode="Disabled" labelsEnabled="0" simplifyDrawingTol="1" styleCategories="Symbology|Labeling|Rendering" simplifyDrawingHints="1" simplifyLocal="1" maxScale="0">
  <renderer-v2 referencescale="-1" enableorderby="0" type="categorizedSymbol" attr="minsector_id" forceraster="0" symbollevels="0">
    <categories>
      <category type="NULL" uuid="{09f6e5b3-3381-43d0-a3dd-b04839828075}" value="NULL" label="" symbol="0" render="true"/>
    </categories>
    <symbols>
      <symbol name="0" force_rhr="0" is_animated="0" type="fill" clip_to_extent="1" frame_rate="10" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" id="{2b25b7f3-ed4f-4e69-b51e-ff9508b6400f}" enabled="1" class="SimpleFill" pass="0">
          <Option type="Map">
            <Option name="border_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="color" type="QString" value="236,95,109,255,hsv:0.98333333333333328,0.59607843137254901,0.92549019607843142,1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0.26"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="style" type="QString" value="solid"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol name="0" force_rhr="0" is_animated="0" type="fill" clip_to_extent="1" frame_rate="10" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" id="{3aadf4b5-d916-4577-95b4-dc6c4144cdc2}" enabled="1" class="SimpleFill" pass="0">
          <Option type="Map">
            <Option name="border_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="color" type="QString" value="232,113,141,255,rgb:0.90980392156862744,0.44313725490196076,0.55294117647058827,1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0.26"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="style" type="QString" value="solid"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <colorramp name="[source]" type="randomcolors">
      <Option/>
    </colorramp>
    <rotation/>
    <sizescale/>
    <data-defined-properties>
      <Option type="Map">
        <Option name="name" type="QString" value=""/>
        <Option name="properties"/>
        <Option name="type" type="QString" value="collection"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol name="" force_rhr="0" is_animated="0" type="fill" clip_to_extent="1" frame_rate="10" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" id="{11244283-0840-4ab4-a852-e4a1565e800f}" enabled="1" class="SimpleFill" pass="0">
          <Option type="Map">
            <Option name="border_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="color" type="QString" value="0,0,255,255,rgb:0,0,1,1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0.26"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="style" type="QString" value="solid"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>0.5</layerOpacity>
  <layerGeometryType>2</layerGeometryType>
</qgis>
', true);

UPDATE sys_style
	SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis hasScaleBasedVisibilityFlag="0" minScale="0" version="3.40.9-Bratislava" simplifyMaxScale="1" autoRefreshTime="0" simplifyAlgorithm="0" symbologyReferenceScale="-1" autoRefreshMode="Disabled" labelsEnabled="0" simplifyDrawingTol="1" styleCategories="Symbology|Labeling|Rendering" simplifyDrawingHints="1" simplifyLocal="1" maxScale="0">
  <renderer-v2 referencescale="-1" enableorderby="0" type="categorizedSymbol" attr="minsector_id" forceraster="0" symbollevels="0">
    <categories>
      <category type="NULL" uuid="{40a87105-3552-4814-902d-1b9e5205699f}" value="NULL" label="" symbol="0" render="true"/>
    </categories>
    <symbols>
      <symbol name="0" force_rhr="0" is_animated="0" type="fill" clip_to_extent="1" frame_rate="10" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" id="{db92e3df-5111-4cf9-a019-f939062852ac}" enabled="1" class="SimpleFill" pass="0">
          <Option type="Map">
            <Option name="border_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="color" type="QString" value="138,209,239,255,hsv:0.55000000000000004,0.42352941176470588,0.93725490196078431,1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0.26"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="style" type="QString" value="solid"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol name="0" force_rhr="0" is_animated="0" type="fill" clip_to_extent="1" frame_rate="10" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" id="{3d441a44-ccb2-4060-bad2-1cad9e5883d1}" enabled="1" class="SimpleFill" pass="0">
          <Option type="Map">
            <Option name="border_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="color" type="QString" value="229,182,54,255,rgb:0.89803921568627454,0.71372549019607845,0.21176470588235294,1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0.26"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="style" type="QString" value="solid"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <colorramp name="[source]" type="randomcolors">
      <Option/>
    </colorramp>
    <rotation/>
    <sizescale/>
    <data-defined-properties>
      <Option type="Map">
        <Option name="name" type="QString" value=""/>
        <Option name="properties"/>
        <Option name="type" type="QString" value="collection"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol name="" force_rhr="0" is_animated="0" type="fill" clip_to_extent="1" frame_rate="10" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" id="{d77627be-48c9-4a05-8439-16d058d08f39}" enabled="1" class="SimpleFill" pass="0">
          <Option type="Map">
            <Option name="border_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="color" type="QString" value="0,0,255,255,rgb:0,0,1,1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0.26"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="style" type="QString" value="solid"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>0.5</layerOpacity>
  <layerGeometryType>2</layerGeometryType>
</qgis>
'
	WHERE layername='ve_minsector' AND styleconfig_id=101;

UPDATE sys_fprocess SET active=true,except_msg='virtualpumps with null values on pump_type column.', query_text='SELECT * FROM inp_virtualpump WHERE pump_type IS NULL' WHERE fid=600;
UPDATE sys_fprocess SET active=true,except_msg='virtualpumps with null values at least on mandatory column curve_id.', query_text='SELECT * FROM inp_virtualpump WHERE curve_id IS NULL' WHERE fid=601;

UPDATE config_form_fields SET columnname='dint' WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='cat_dint' AND tabname='tab_epa';


UPDATE sys_table SET project_template='{"template": [1],"visibility": false,"levels_to_read": 2}'::jsonb WHERE id='ve_dqa';

UPDATE config_toolbox SET inputparams='[
  {
    "widgetname": "graphClass",
    "label": "Graph class:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Graphanalytics method used",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "comboIds": [
      "PRESSZONE",
      "DQA",
      "DMA",
      "SECTOR"
    ],
    "comboNames": [
      "PRESSZONE",
      "DQA",
      "DMA",
      "SECTOR"
    ],
    "selectedId": null
  },
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose exploitation to work with",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC",
    "selectedId": null
  },
  {
    "widgetname": "forceOpen",
    "label": "Force open nodes: (*)",
    "widgettype": "linetext",
    "datatype": "text",
    "isMandatory": false,
    "tooltip": "Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there",
    "placeholder": "1015,2231,3123",
    "layoutname": "grl_option_parameters",
    "layoutorder": 5,
    "value": null
  },
  {
    "widgetname": "forceClosed",
    "label": "Force closed nodes: (*)",
    "widgettype": "text",
    "datatype": "text",
    "isMandatory": false,
    "tooltip": "Optative node id(s) to temporary close open node(s) to force algorithm to stop there",
    "placeholder": "1015,2231,3123",
    "layoutname": "grl_option_parameters",
    "layoutorder": 6,
    "value": null
  },
  {
    "widgetname": "usePlanPsector",
    "label": "Use selected psectors:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, use selected psectors. If false ignore selected psectors and only works with on-service network",
    "layoutname": "grl_option_parameters",
    "layoutorder": 7,
    "value": null
  },
  {
    "widgetname": "commitChanges",
    "label": "Commit changes:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables",
    "layoutname": "grl_option_parameters",
    "layoutorder": 8,
    "value": null
  },
  {
    "widgetname": "updateMapZone",
    "label": "Mapzone constructor method:",
    "widgettype": "combo",
    "datatype": "integer",
    "layoutname": "grl_option_parameters",
    "layoutorder": 10,
    "comboIds": [
      0,
      1,
      2,
      6
    ],
    "comboNames": [
      "NONE",
      "CONCAVE POLYGON",
      "PIPE BUFFER",
      "PLOT & PIPE BUFFER",
      "LINK & PIPE BUFFER"
    ],
    "selectedId": null
  },
  {
    "widgetname": "geomParamUpdate",
    "label": "Pipe buffer",
    "widgettype": "text",
    "datatype": "float",
    "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.",
    "layoutname": "grl_option_parameters",
    "layoutorder": 11,
    "isMandatory": false,
    "placeholder": "5-30",
    "value": null
  },
  {
    "widgetname": "fromZero",
    "label": "Mapzones from zero:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, mapzones are calculated automatically from zero",
    "layoutname": "grl_option_parameters",
    "layoutorder": 12,
    "value": null
  }
]'::json WHERE id=2768;

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM om_typevalue WHERE typevalue=''mincut_state'' AND id<>''4'''
WHERE formname='mincut_manager' AND formtype='form_mincut' AND columnname='state';


UPDATE config_param_system SET value = REPLACE(value, '"MINSECTOR":{"mode":"Random", "column":"name"}', '"MINSECTOR":{"mode":"Random", "column":"minsector_id"}') WHERE parameter='utils_graphanalytics_style';
UPDATE config_param_system SET value = (value::jsonb || '{"MINSECTOR_MINCUT":{"mode":"Random", "column":"minsector_id"}}'::jsonb)::TEXT WHERE "parameter" = 'utils_graphanalytics_style';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4354, 'Minsector dynamic analysis done successfully', null, 0, true, 'ws', 'core', 'AUDIT');

UPDATE sys_table
SET addparam='{"pkey": "netscenario_id, presszone_id"}'::json
WHERE id='plan_netscenario_presszone';


UPDATE config_form_tabs SET tabactions='[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false}, {"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false}, {"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false}, {"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false}, {"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false},
{"actionName":"actionMapZone", "actionTooltip":"Add Mapzone",  "disabled":false},
{"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false}, {"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false},
{"actionName": "actionRotation", "actionTooltip": "Rotation","disabled": false}]'::json WHERE formname='ve_node' AND tabname='tab_epa';

UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_typevalue_valve''', dv_isnullvalue=true WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_epa';
UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_typevalue_valve''', dv_isnullvalue=true WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_epa';



UPDATE config_form_fields SET columnname = 'dint', hidden = true WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='cat_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET hidden = true WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_epa';
UPDATE config_form_fields SET hidden = true WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_epa';
UPDATE config_form_fields SET columnname = 'dint', hidden = true WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='cat_dint' AND tabname='tab_epa';

UPDATE config_form_fields SET columnname='matcat_id', hidden = true WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='cat_matcat_id' AND tabname='tab_epa';
UPDATE config_form_fields SET hidden = true WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_epa';

UPDATE sys_table SET context=NULL WHERE id='v_om_mincut_connec';
UPDATE sys_table SET context=NULL WHERE id='v_om_mincut_arc';
UPDATE sys_table SET context=NULL WHERE id='v_om_mincut_node';
UPDATE sys_table SET context=NULL WHERE id='v_om_mincut_valve';
UPDATE sys_table SET context=NULL WHERE id='v_om_mincut_initpoint';

INSERT INTO config_typevalue (typevalue,id,addparam) VALUES ('sys_table_context','{"levels": ["OM", "ANALYTICS", "INPUT"]}','{"orderBy":31}'::json);
INSERT INTO config_typevalue (typevalue,id,addparam) VALUES ('sys_table_context','{"levels": ["OM", "ANALYTICS", "OUTPUT"]}','{"orderBy":32}'::json);

UPDATE sys_table SET alias='Proposed Hydrants', context='{"levels": ["OM", "ANALYTICS", "INPUT"]}' WHERE id='ve_anl_hydrant';
UPDATE sys_table SET context='{"levels": ["OM", "ANALYTICS", "OUTPUT"]}' WHERE id='ve_minsector';
UPDATE sys_table SET context='{"levels": ["OM", "ANALYTICS", "OUTPUT"]}' WHERE id='ve_minsector_mincut';

DROP TRIGGER IF EXISTS gw_trg_edit_arc ON ve_arc;
CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

DROP TRIGGER IF EXISTS gw_trg_edit_node ON ve_node;
CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_node 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

DROP TRIGGER IF EXISTS gw_trg_edit_connec ON ve_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_connec 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

DROP TRIGGER IF EXISTS gw_trg_edit_link ON ve_link;
CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_link 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('LINK');

CREATE TRIGGER gw_trg_edit_ve_epa_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('valve');
