/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_gully", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);

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
		WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
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
	omzone_table AS (
		SELECT 
			omzone.omzone_id,
			omzone.macroomzone_id,
			omzone.stylesheet,
			t.id::character varying(16) AS omzone_type
		FROM omzone
		LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
	), 
	drainzone_table AS (
		SELECT 
			drainzone.drainzone_id,
			drainzone.stylesheet,
			t.id::character varying(16) AS drainzone_type
		FROM drainzone
		LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
	), 
	dwfzone_table AS (
		SELECT 
			dwfzone.dwfzone_id,
			dwfzone.stylesheet,
			t.id::character varying(16) AS dwfzone_type,
			dwfzone.drainzone_id
		FROM dwfzone
		LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
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
			arc.elev1,
			arc.custom_elev1,
			CASE
				WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
				ELSE arc.sys_elev1
			END AS sys_elev1,
			arc.y1,
			arc.custom_y1,
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
			arc.elev2,
			arc.custom_elev2,
			CASE
					WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
					ELSE arc.sys_elev2
			END AS sys_elev2,
			arc.y2,
			arc.custom_y2,
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
			cat_feature.feature_class AS sys_type,
			arc.arc_type::text AS arc_type,
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
			arc.parent_id,
			arc.expl_id,
			e.macroexpl_id,
			arc.muni_id,
			arc.sector_id,
			sector_table.macrosector_id,
			sector_table.sector_type,
			dwfzone_table.drainzone_id,
			drainzone_table.drainzone_type,
			arc.drainzone_outfall,
			arc.dwfzone_id,
			dwfzone_table.dwfzone_type,
			arc.dwfzone_outfall,
			arc.omzone_id,
			omzone_table.macroomzone_id,
			omzone_table.omzone_type,
			arc.dma_id,
			arc.omunit_id,
			arc.minsector_id,
			arc.pavcat_id,
			arc.soilcat_id,
			arc.function_type,
			arc.category_type,
			arc.location_type,
			arc.fluid_type,
			arc.custom_length,
			st_length(arc.the_geom)::numeric(12,2) AS gis_length,
			arc.sys_slope AS slope,
			arc.descript,
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
			arc.registration_date,
			arc.enddate,
			arc.ownercat_id,
			arc.last_visitdate,
			arc.visitability,
			arc.om_state,
			arc.conserv_state,
			arc.brand_id,
			arc.model_id,
			arc.serial_number,
			arc.asset_id,
			arc.adate,
			arc.adescript,
			arc.verified,
			arc.uncertain,
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
							WHEN arc.sector_id > 0 AND vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN arc.epa_type
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
			arc.lock_level,
			arc.initoverflowpath,
			arc.inverted_slope,
			arc.negative_offset,
			arc.expl_visibility,
			date_trunc('second'::text, arc.created_at) AS created_at,
			arc.created_by,
			date_trunc('second'::text, arc.updated_at) AS updated_at,
			arc.updated_by,
			arc.the_geom,
			arc.meandering,
			arc_selector.p_state
			FROM arc_selector
				JOIN arc USING (arc_id)
				JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
				JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
				JOIN exploitation e ON e.expl_id = arc.expl_id
				JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
				JOIN value_state_type vst ON vst.id = arc.state_type
				JOIN sector_table ON sector_table.sector_id = arc.sector_id
				LEFT JOIN omzone_table ON omzone_table.omzone_id = arc.omzone_id
				LEFT JOIN drainzone_table ON arc.omzone_id = drainzone_table.drainzone_id
				LEFT JOIN dwfzone_table ON arc.dwfzone_id = dwfzone_table.dwfzone_id
				LEFT JOIN arc_add ON arc_add.arc_id = arc.arc_id
	)
SELECT
	arc_id,
	code,
	sys_code,
	node_1,
	nodetype_1,
	elev1,
	custom_elev1,
	sys_elev1,
	y1,
	custom_y1,
	sys_y1,
	r1,
	z1,
	node_2,
	nodetype_2,
	elev2,
	custom_elev2,
	sys_elev2,
	y2,
	custom_y2,
	sys_y2,
	r2,
	z2,
	sys_type,
	arc_type,
	arccat_id,
	matcat_id,
	cat_shape,
	cat_geom1,
	cat_geom2,
	cat_width,
	cat_area,
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
	drainzone_id,
	drainzone_type,
	drainzone_outfall,
	dwfzone_id,
	dwfzone_type,
	dwfzone_outfall,
	omzone_id,
	macroomzone_id,
	dma_id,
	omzone_type,
	omunit_id,
	minsector_id,
	pavcat_id,
	soilcat_id,
	function_type,
	category_type,
	location_type,
	fluid_type,
	custom_length,
	gis_length,
	slope,
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
	workcat_id,
	workcat_id_end,
	workcat_id_plan,
	builtdate,
	registration_date,
	enddate,
	ownercat_id,
	last_visitdate,
	visitability,
	om_state,
	conserv_state,
	brand_id,
	model_id,
	serial_number,
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
	label_quadrant,
	inventory,
	publish,
	is_operative,
	is_scadamap,
	inp_type,
	result_id,
	max_flow,
	max_veloc,
	mfull_flow,
	mfull_depth,
	manning_veloc,
	manning_flow,
	dwf_minflow,
	dwf_maxflow,
	dwf_minvel,
	dwf_maxvel,
	conduit_capacity,
	sector_style,
	drainzone_style,
	dwfzone_style,
	omzone_style,
	lock_level,
	initoverflowpath,
	inverted_slope,
	negative_offset,
	expl_visibility,
	created_at,
	created_by,
	updated_at,
	updated_by,
	the_geom,
	meandering,
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
		WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
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
	omzone_table AS (
		SELECT
			omzone.omzone_id,
			omzone.macroomzone_id,
			omzone.stylesheet,
			t.id::character varying(16) AS omzone_type
		FROM omzone
		LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
	), 
	drainzone_table AS (
		SELECT 
			drainzone.drainzone_id,
			drainzone.stylesheet,
			t.id::character varying(16) AS drainzone_type
		FROM drainzone
		LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
	), 
	dwfzone_table AS (
		SELECT 
			dwfzone.dwfzone_id,
			dwfzone.stylesheet,
			t.id::character varying(16) AS dwfzone_type,
			dwfzone.drainzone_id
		FROM dwfzone
		LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
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
			cat_feature.feature_class AS sys_type,
			node.node_type::text AS node_type,
			CASE
					WHEN node.matcat_id IS NULL THEN cat_node.matcat_id
					ELSE node.matcat_id
			END AS matcat_id,
			node.nodecat_id,
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
			dwfzone_table.drainzone_id,
			drainzone_table.drainzone_type,
			node.drainzone_outfall,
			node.dwfzone_id,
			dwfzone_table.dwfzone_type,
			node.dwfzone_outfall,
			node.omzone_id,
			omzone_table.macroomzone_id,
			node.dma_id,
			node.omunit_id,
			node.minsector_id,
			node.pavcat_id,
			node.soilcat_id,
			node.function_type,
			node.category_type,
			node.location_type,
			node.fluid_type,
			node.annotation,
			node.observ,
			node.comment,
			node.descript,
			concat(cat_feature.link_path, node.link) AS link,
			node.num_value,
			node.district_id,
			node.postcode,
			node.streetaxis_id,
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
			node.conserv_state,
			node.om_state,
			node.access_type,
			node.placement_type,
			node.brand_id,
			node.model_id,
			node.serial_number,
			node.asset_id,
			node.adate,
			node.adescript,
			node.verified,
			node.xyz_date,
			node.uncertain,
			node.datasource,
			node.unconnected,
			cat_node.label,
			node.label_x,
			node.label_y,
			node.label_rotation,
			node.rotation,
			node.label_quadrant,
			node.hemisphere,
			cat_node.svg,
			node.inventory,
			node.publish,
			vst.is_operative,
			node.is_scadamap,
					CASE
							WHEN node.sector_id > 0 AND vst.is_operative = true AND node.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN node.epa_type
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
			node.lock_level,
			node.expl_visibility,
			( SELECT st_x(node.the_geom) AS st_x) AS xcoord,
			( SELECT st_y(node.the_geom) AS st_y) AS ycoord,
			( SELECT st_y(st_transform(node.the_geom, 4326)) AS st_y) AS lat,
			( SELECT st_x(st_transform(node.the_geom, 4326)) AS st_x) AS long,
			date_trunc('second'::text, node.created_at) AS created_at,
			node.created_by,
			date_trunc('second'::text, node.updated_at) AS updated_at,
			node.updated_by,
			node.the_geom,
			node_selector.p_state
			FROM node_selector
				JOIN node USING (node_id)
				JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
				JOIN cat_feature ON cat_feature.id::text = node.node_type::text
				JOIN exploitation ON node.expl_id = exploitation.expl_id
				JOIN ext_municipality mu ON node.muni_id = mu.muni_id
				JOIN value_state_type vst ON vst.id = node.state_type
				JOIN sector_table ON sector_table.sector_id = node.sector_id
				LEFT JOIN omzone_table ON omzone_table.omzone_id = node.omzone_id
				LEFT JOIN drainzone_table ON node.omzone_id = drainzone_table.drainzone_id
				LEFT JOIN dwfzone_table ON node.dwfzone_id = dwfzone_table.dwfzone_id
				LEFT JOIN node_add ON node_add.node_id = node.node_id
	), node_base AS (
		SELECT node_selected.node_id,
			node_selected.code,
			node_selected.sys_code,
			node_selected.top_elev,
			node_selected.custom_top_elev,
			node_selected.sys_top_elev,
			node_selected.ymax,
			node_selected.custom_ymax,
					CASE
							WHEN node_selected.sys_ymax IS NOT NULL THEN node_selected.sys_ymax
							ELSE (node_selected.sys_top_elev - node_selected.sys_elev)::numeric(12,3)
					END AS sys_ymax,
			node_selected.elev,
			node_selected.custom_elev,
					CASE
							WHEN node_selected.elev IS NOT NULL AND node_selected.custom_elev IS NULL THEN node_selected.elev
							WHEN node_selected.custom_elev IS NOT NULL THEN node_selected.custom_elev
							ELSE (node_selected.sys_top_elev - node_selected.sys_ymax)::numeric(12,3)
					END AS sys_elev,
			node_selected.node_type,
			node_selected.sys_type,
			node_selected.matcat_id,
			node_selected.nodecat_id,
			node_selected.epa_type,
			node_selected.state,
			node_selected.state_type,
			node_selected.arc_id,
			node_selected.parent_id,
			node_selected.expl_id,
			node_selected.macroexpl_id,
			node_selected.muni_id,
			node_selected.sector_id,
			node_selected.macrosector_id,
			node_selected.sector_type,
			node_selected.drainzone_id,
			node_selected.drainzone_type,
			node_selected.drainzone_outfall,
			node_selected.dwfzone_id,
			node_selected.dwfzone_type,
			node_selected.dwfzone_outfall,
			node_selected.omzone_id,
			node_selected.macroomzone_id,
			node_selected.dma_id,
			node_selected.omunit_id,
			node_selected.minsector_id,
			node_selected.pavcat_id,
			node_selected.soilcat_id,
			node_selected.function_type,
			node_selected.category_type,
			node_selected.location_type,
			node_selected.fluid_type,
			node_selected.annotation,
			node_selected.observ,
			node_selected.comment,
			node_selected.descript,
			node_selected.link,
			node_selected.num_value,
			node_selected.district_id,
			node_selected.postcode,
			node_selected.streetaxis_id,
			node_selected.postnumber,
			node_selected.postcomplement,
			node_selected.streetaxis2_id,
			node_selected.postnumber2,
			node_selected.postcomplement2,
			node_selected.region_id,
			node_selected.province_id,
			node_selected.workcat_id,
			node_selected.workcat_id_end,
			node_selected.workcat_id_plan,
			node_selected.builtdate,
			node_selected.enddate,
			node_selected.ownercat_id,
			node_selected.conserv_state,
			node_selected.om_state,
			node_selected.access_type,
			node_selected.placement_type,
			node_selected.brand_id,
			node_selected.model_id,
			node_selected.serial_number,
			node_selected.asset_id,
			node_selected.adate,
			node_selected.adescript,
			node_selected.verified,
			node_selected.xyz_date,
			node_selected.uncertain,
			node_selected.datasource,
			node_selected.unconnected,
			node_selected.label,
			node_selected.label_x,
			node_selected.label_y,
			node_selected.label_rotation,
			node_selected.rotation,
			node_selected.label_quadrant,
			node_selected.hemisphere,
			node_selected.svg,
			node_selected.inventory,
			node_selected.publish,
			node_selected.is_operative,
			node_selected.is_scadamap,
			node_selected.inp_type,
			node_selected.result_id,
			node_selected.max_depth,
			node_selected.max_height,
			node_selected.flooding_rate,
			node_selected.flooding_vol,
			node_selected.sector_style,
			node_selected.omzone_style,
			node_selected.drainzone_style,
			node_selected.dwfzone_style,
			node_selected.lock_level,
			node_selected.expl_visibility,
			node_selected.xcoord,
			node_selected.ycoord,
			node_selected.lat,
			node_selected.long,
			node_selected.created_at,
			node_selected.created_by,
			node_selected.updated_at,
			node_selected.updated_by,
			node_selected.the_geom,
			node_selected.p_state
			FROM node_selected
	)
SELECT
	node_id,
	code,
	sys_code,
	top_elev,
	custom_top_elev,
	sys_top_elev,
	ymax,
	custom_ymax,
	sys_ymax,
	elev,
	custom_elev,
	sys_elev,
	node_type,
	sys_type,
	matcat_id,
	nodecat_id,
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
	drainzone_id,
	drainzone_type,
	drainzone_outfall,
	dwfzone_id,
	dwfzone_type,
	dwfzone_outfall,
	omzone_id,
	macroomzone_id,
	dma_id,
	omunit_id,
	minsector_id,
	pavcat_id,
	soilcat_id,
	function_type,
	category_type,
	location_type,
	fluid_type,
	annotation,
	observ,
	comment,
	descript,
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
	conserv_state,
	om_state,
	access_type,
	placement_type,
	brand_id,
	model_id,
	serial_number,
	asset_id,
	adate,
	adescript,
	verified,
	xyz_date,
	uncertain,
	datasource,
	unconnected,
	label,
	label_x,
	label_y,
	label_rotation,
	rotation,
	label_quadrant,
	hemisphere,
	svg,
	inventory,
	publish,
	is_operative,
	is_scadamap,
	inp_type,
	result_id,
	max_depth,
	max_height,
	flooding_rate,
	flooding_vol,
	sector_style,
	omzone_style,
	drainzone_style,
	dwfzone_style,
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
FROM node_base;

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
		WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
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
	omzone_table AS (
		SELECT 
			omzone.omzone_id,
			omzone.macroomzone_id,
			omzone.stylesheet,
			t.id::character varying(16) AS omzone_type
			FROM omzone
			LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
	), 
	drainzone_table AS (
		SELECT 
			drainzone.drainzone_id,
			drainzone.stylesheet,
			t.id::character varying(16) AS drainzone_type
		FROM drainzone
		LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
	), 
	dwfzone_table AS (
		SELECT 
			dwfzone.dwfzone_id,
			dwfzone.stylesheet,
			t.id::character varying(16) AS dwfzone_type,
			dwfzone.drainzone_id
		FROM dwfzone
		LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
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
			connec.plot_code,
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
			connec.diagonal,
			connec_selector.p_state
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
SELECT 
	connec_id,
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
	plot_code,
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
	diagonal,
	p_state
FROM connec_selected;

CREATE OR REPLACE VIEW ve_gully
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
		WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
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
	omzone_table AS (
		SELECT 
			omzone.omzone_id,
			omzone.macroomzone_id,
			omzone.stylesheet,
			t.id::character varying(16) AS omzone_type
		FROM omzone
		LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
	), 
	drainzone_table AS (
		SELECT 
			drainzone.drainzone_id,
			drainzone.stylesheet,
			t.id::character varying(16) AS drainzone_type
		FROM drainzone
		LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
	), 
	dwfzone_table AS (
		SELECT 
			dwfzone.dwfzone_id,
			dwfzone.stylesheet,
			t.id::character varying(16) AS dwfzone_type,
			dwfzone.drainzone_id
		FROM dwfzone
		LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
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
			l.omzone_id,
			omzone_table.omzone_type,
			omzone_table.macroomzone_id,
			dwfzone_table.drainzone_id,
			drainzone_table.drainzone_type,
			l.dwfzone_id,
			dwfzone_table.dwfzone_type,
			l.fluid_type,
			l.dma_id
		FROM link l
		JOIN exploitation USING (expl_id)
		JOIN sector_table ON l.sector_id = sector_table.sector_id
		LEFT JOIN omzone_table ON l.omzone_id = omzone_table.omzone_id
		LEFT JOIN drainzone_table ON l.omzone_id = drainzone_table.drainzone_id
		LEFT JOIN dwfzone_table ON l.dwfzone_id = dwfzone_table.dwfzone_id
		WHERE l.state = 2
	), 
	gully_psector AS (
    SELECT DISTINCT ON (pp.gully_id, pp.state) 
    pp.gully_id,
    pp.state AS p_state,
    pp.psector_id,
    pp.arc_id,
    pp.link_id
  FROM plan_psector_x_gully pp
  WHERE (EXISTS (SELECT 1 FROM sel_ps s WHERE s.psector_id = pp.psector_id))
  ORDER BY pp.gully_id, pp.state, pp.link_id DESC NULLS LAST
  ), 
  gully_selector AS (
    SELECT 
      g.gully_id,
      g.arc_id,
      NULL::integer AS link_id,
      NULL AS p_state
    FROM gully g
    WHERE (EXISTS ( SELECT 1 FROM sel_state s WHERE s.state_id = g.state)) 
    AND (EXISTS ( SELECT 1 FROM sel_sector s WHERE s.sector_id = g.sector_id)) 
    AND (EXISTS ( SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(g.expl_visibility::integer[], g.expl_id)))) 
    AND (EXISTS ( SELECT 1 FROM sel_muni s WHERE s.muni_id = g.muni_id)) 
    AND NOT (EXISTS ( SELECT 1 FROM gully_psector gp WHERE gp.gully_id = g.gully_id))
    UNION ALL
    SELECT 
      gp.gully_id,
      gp.arc_id,
      gp.link_id,
      gp.p_state
    FROM gully_psector gp
    WHERE (EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = gp.p_state))
  ), 
	gully_selected AS (
		SELECT 
			gully.gully_id,
			gully.code,
			gully.sys_code,
			gully.top_elev,
			CASE
					WHEN gully.width IS NULL THEN cat_gully.width
					ELSE gully.width
			END AS width,
			CASE
					WHEN gully.length IS NULL THEN cat_gully.length
					ELSE gully.length
			END AS length,
			CASE
					WHEN gully.ymax IS NULL THEN cat_gully.ymax
					ELSE gully.ymax
			END AS ymax,
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
			CASE
					WHEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric) IS NOT NULL THEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric)::numeric(12,3)
					ELSE gully.connec_depth
			END AS connec_depth,
			CASE
					WHEN gully._connec_matcat_id IS NULL THEN cc.matcat_id::text
					ELSE gully._connec_matcat_id
			END AS connec_matcat_id,
			gully.top_elev - gully.ymax + gully.sandbox AS connec_y1,
			gully.connec_y2,
			gully_selector.arc_id,
			gully.epa_type,
			gully.state,
			gully.state_type,
			gully.expl_id,
			exploitation.macroexpl_id,
			gully.muni_id,
			CASE
					WHEN link_planned.sector_id IS NULL THEN sector_table.sector_id
					ELSE link_planned.sector_id
			END AS sector_id,
			CASE
					WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
					ELSE link_planned.macrosector_id
			END AS macrosector_id,
			CASE
					WHEN link_planned.sector_id IS NULL THEN sector_table.sector_type
					ELSE link_planned.sector_type
			END AS sector_type,
			CASE
					WHEN link_planned.drainzone_id IS NULL THEN dwfzone_table.drainzone_id
					ELSE link_planned.drainzone_id
			END AS drainzone_id,
			CASE
					WHEN link_planned.drainzone_type IS NULL THEN drainzone_table.drainzone_type
					ELSE link_planned.drainzone_type
			END AS drainzone_type,
			gully.drainzone_outfall,
			CASE
					WHEN link_planned.dwfzone_id IS NULL THEN dwfzone_table.dwfzone_id
					ELSE link_planned.dwfzone_id
			END AS dwfzone_id,
			CASE
					WHEN link_planned.dwfzone_type IS NULL THEN dwfzone_table.dwfzone_type
					ELSE link_planned.dwfzone_type
			END AS dwfzone_type,
			gully.dwfzone_outfall,
			CASE
					WHEN link_planned.omzone_id IS NULL THEN omzone_table.omzone_id
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
					WHEN link_planned.dma_id IS NULL THEN gully.dma_id
					ELSE link_planned.dma_id
			END AS dma_id,
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
			mu.region_id,
			mu.province_id,
			gully.workcat_id,
			gully.workcat_id_end,
			gully.workcat_id_plan,
			gully.builtdate,
			gully.enddate,
			gully.ownercat_id,
			gully.om_state,
			CASE
					WHEN link_planned.exit_id IS NULL THEN gully.pjoint_id
					ELSE link_planned.exit_id
			END AS pjoint_id,
			CASE
					WHEN link_planned.exit_type IS NULL THEN gully.pjoint_type
					ELSE link_planned.exit_type
			END AS pjoint_type,
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
			gully_selector.p_state
		FROM gully_selector
		JOIN gully USING (gully_id)
		JOIN cat_gully ON gully.gullycat_id::text = cat_gully.id::text
		JOIN exploitation ON gully.expl_id = exploitation.expl_id
		JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
		LEFT JOIN cat_connec cc ON cc.id::text = gully._connec_arccat_id::text
		JOIN value_state_type vst ON vst.id = gully.state_type
		JOIN ext_municipality mu ON gully.muni_id = mu.muni_id
		JOIN sector_table ON gully.sector_id = sector_table.sector_id
		LEFT JOIN omzone_table ON gully.omzone_id = omzone_table.omzone_id
		LEFT JOIN drainzone_table ON gully.omzone_id = drainzone_table.drainzone_id
		LEFT JOIN dwfzone_table ON gully.dwfzone_id = dwfzone_table.dwfzone_id
		LEFT JOIN link_planned ON gully.gully_id = link_planned.feature_id
		LEFT JOIN inp_network_mode ON true
	)
SELECT 
	gully_id,
	code,
	sys_code,
	top_elev,
	width,
	length,
	ymax,
	sandbox,
	matcat_id,
	gully_type,
	sys_type,
	gullycat_id,
	cat_gully_matcat,
	units,
	units_placement,
	groove,
	groove_height,
	groove_length,
	siphon,
	siphon_type,
	odorflap,
	connec_arccat_id,
	connec_length,
	connec_depth,
	connec_matcat_id,
	connec_y1,
	connec_y2,
	arc_id,
	epa_type,
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
	omzone_type,
	omunit_id,
	minsector_id,
	soilcat_id,
	function_type,
	category_type,
	location_type,
	fluid_type,
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
	workcat_id,
	workcat_id_end,
	workcat_id_plan,
	builtdate,
	enddate,
	ownercat_id,
	om_state,
	pjoint_id,
	pjoint_type,
	placement_type,
	access_type,
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
	inp_type,
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
	the_geom,
	p_state
FROM gully_selected;

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
		WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
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
	omzone_table AS (
		SELECT 
			omzone.omzone_id,
			omzone.macroomzone_id,
			omzone.stylesheet,
			t.id::character varying(16) AS omzone_type
		FROM omzone
		LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
	), 
	drainzone_table AS (
		SELECT 
			drainzone.drainzone_id,
			drainzone.stylesheet,
			t.id::character varying(16) AS drainzone_type
		FROM drainzone
		LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
	), 
	dwfzone_table AS (
		SELECT 
			dwfzone.dwfzone_id,
			dwfzone.stylesheet,
			t.id::character varying(16) AS dwfzone_type,
			dwfzone.drainzone_id
		FROM dwfzone
		LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
	), 
	inp_network_mode AS (
		SELECT config_param_user.value
		FROM config_param_user
		WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
	), 
	link_psector AS (
    (SELECT DISTINCT ON (pp.connec_id, pp.state) 
      'CONNEC'::text AS feature_type,
      pp.connec_id AS feature_id,
      pp.state AS p_state,
      pp.psector_id,
      pp.link_id
    FROM plan_psector_x_connec pp
    WHERE (EXISTS (SELECT 1 FROM sel_ps s WHERE s.psector_id = pp.psector_id))
    ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
		)
		UNION ALL
		(SELECT DISTINCT ON (pp.gully_id, pp.state) 
      'GULLY'::text AS feature_type,
      pp.gully_id AS feature_id,
      pp.state AS p_state,
      pp.psector_id,
      pp.link_id
    FROM plan_psector_x_gully pp
    WHERE (EXISTS (SELECT 1 FROM sel_ps s WHERE s.psector_id = pp.psector_id))
    ORDER BY pp.gully_id, pp.state, pp.link_id DESC NULLS LAST
		)
  ),
	link_selector AS (
    SELECT 
      l.link_id,
      NULL AS p_state
    FROM link l
    WHERE (EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = l.state)) 
    AND (EXISTS (SELECT 1 FROM sel_sector s WHERE s.sector_id = l.sector_id)) 
    AND (EXISTS (SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(l.expl_visibility::integer[], l.expl_id)))) 
    AND (EXISTS (SELECT 1 FROM sel_muni s WHERE s.muni_id = l.muni_id)) 
    AND NOT (EXISTS (SELECT 1 FROM link_psector lp WHERE lp.link_id = l.link_id))
    UNION ALL
    SELECT 
      lp.link_id,
      lp.p_state
    FROM link_psector lp
    WHERE (EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = lp.p_state))
  ),
	link_selected AS (
		SELECT
			l.link_id,
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
			link_selector.p_state
		FROM link_selector
		JOIN link l USING (link_id)
		JOIN exploitation ON l.expl_id = exploitation.expl_id
		JOIN ext_municipality mu ON l.muni_id = mu.muni_id
		JOIN sector_table ON l.sector_id = sector_table.sector_id
		JOIN cat_link ON cat_link.id::text = l.linkcat_id::text
		JOIN cat_feature ON cat_feature.id::text = l.link_type::text
		LEFT JOIN omzone_table ON l.omzone_id = omzone_table.omzone_id
		LEFT JOIN drainzone_table ON l.omzone_id = drainzone_table.drainzone_id
		LEFT JOIN dwfzone_table ON l.dwfzone_id = dwfzone_table.dwfzone_id
		LEFT JOIN inp_network_mode ON true
	)
SELECT link_id,
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
	the_geom,
	p_state
FROM link_selected;



CREATE OR REPLACE VIEW ve_inp_subcatchment
AS SELECT inp_subcatchment.hydrology_id,
    inp_subcatchment.subc_id,
    inp_subcatchment.sector_id,
    inp_subcatchment.minelev,
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
    inp_subcatchment.nperv_pattern_id,
    inp_subcatchment.dstore_pattern_id,
    inp_subcatchment.infil_pattern_id,
    inp_subcatchment.muni_id,
    inp_subcatchment.descript,
    inp_subcatchment.the_geom
   FROM inp_subcatchment,
    config_param_user,
    selector_sector,
    selector_municipality
  WHERE inp_subcatchment.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND inp_subcatchment.muni_id = selector_municipality.muni_id AND selector_municipality.cur_user = "current_user"()::text AND inp_subcatchment.hydrology_id = config_param_user.value::integer AND config_param_user.cur_user::text = "current_user"()::text AND config_param_user.parameter::text = 'inp_options_hydrology_current'::text;

UPDATE sys_table SET descript='ve_inp_frorifice',alias='Inp flwreg orifice' WHERE id='ve_inp_frorifice';
UPDATE sys_table SET descript='ve_inp_frpump',alias='Inp flwreg pump' WHERE id='ve_inp_frpump';
UPDATE sys_table SET descript='ve_inp_froutlet',alias='Inp flwreg outlet' WHERE id='ve_inp_froutlet';
UPDATE sys_table SET descript='ve_inp_frweir',alias='Inp flwreg weir' WHERE id='ve_inp_frweir';


INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'id', 0, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'gully_id', 1, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'arc_id', 2, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'psector_id', 3, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'state', 4, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'doable', 5, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'descript', 6, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', '_link_geom_', 7, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', '_userdefined_geom_', 8, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'link_id', 9, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'insert_tstamp', 10, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_gully', 'insert_user', 11, false, NULL, NULL, NULL);


UPDATE sys_table SET context = '{"levels": ["EPA", "HYDROLOGY"]}' WHERE id = 've_raingage';

UPDATE sys_param_user SET id='inp_options_hydrology_current' WHERE id='inp_options_hydrology_scenario';

UPDATE config_toolbox SET inputparams = replace(inputparams::text, '''ALL VISIBLE SECTORS''', '''ALL VISIBLE SECTORS''')::json WHERE id = '3102' or id = '3100';

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND  typevalue = ''inp_typevalue_orifice'''
WHERE formname='ve_epa_frorifice' AND formtype='form_feature' AND columnname='orifice_type' AND tabname='tab_epa';

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND  typevalue = ''inp_typevalue_weir'''
WHERE formname='ve_epa_frweir' AND formtype='form_feature' AND columnname='weir_type' AND tabname='tab_epa';


UPDATE sys_param_user SET id='inp_options_dwfscenario_current' WHERE id='inp_options_dwfscenario';

UPDATE config_toolbox
	SET inputparams='[
  {
    "label": "Name: (*)",
    "value": null,
    "tooltip": "Name for dscenario (mandatory)",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "name",
    "widgettype": "linetext",
    "isMandatory": true,
    "layoutorder": 1,
    "placeholder": ""
  },
  {
    "label": "Descript:",
    "value": null,
    "tooltip": "Descript for dscenario",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "descript",
    "widgettype": "linetext",
    "isMandatory": false,
    "layoutorder": 2,
    "placeholder": ""
  },
  {
    "label": "Parent:",
    "value": null,
    "tooltip": "Parent for dscenario",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "parent",
    "widgettype": "linetext",
    "isMandatory": false,
    "layoutorder": 3,
    "placeholder": ""
  },
  {
    "label": "Type:",
    "value": null,
    "tooltip": "Dscenario type",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "type",
    "widgettype": "combo",
    "dvQueryText": "SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_dscenario''",
    "isMandatory": true,
    "layoutorder": 4
  },
  {
    "label": "Exploitation:",
    "value": null,
    "tooltip": "Dscenario type",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "expl",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id AS id, name as idval FROM ve_exploitation",
    "isMandatory": true,
    "layoutorder": 6
  }
]'::json
	WHERE id=3134;
UPDATE config_toolbox
	SET inputparams='[
  {
    "label": "Name: (*)",
    "value": null,
    "tooltip": "Name for hydrology scenario (mandatory)",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "name",
    "widgettype": "linetext",
    "isMandatory": true,
    "layoutorder": 1,
    "placeholder": ""
  },
  {
    "label": "Infiltration:",
    "value": null,
    "tooltip": "Infiltration",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "infiltration",
    "widgettype": "combo",
    "dvQueryText": "SELECT id, idval FROM inp_typevalue WHERE typevalue =''inp_value_options_in''",
    "isMandatory": true,
    "layoutorder": 2
  },
  {
    "label": "Text:",
    "value": null,
    "tooltip": "Text of hydrology scenario",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "text",
    "widgettype": "linetext",
    "isMandatory": false,
    "layoutorder": 3,
    "placeholder": ""
  },
  {
    "label": "Exploitation:",
    "value": null,
    "tooltip": "hydrology scenario type",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "expl",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id AS id, name as idval FROM ve_exploitation",
    "isMandatory": true,
    "layoutorder": 4
  }
]'::json
	WHERE id=3290;
UPDATE config_toolbox
	SET inputparams='[
  {
    "label": "Name: (*)",
    "value": null,
    "tooltip": "Name for dwf scenario (mandatory)",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "idval",
    "widgettype": "linetext",
    "isMandatory": true,
    "layoutorder": 1,
    "placeholder": ""
  },
  {
    "label": "Startdate:",
    "value": null,
    "tooltip": "Start date for dwf scenario",
    "datatype": "date",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "startdate",
    "widgettype": "datetime",
    "isMandatory": false,
    "layoutorder": 2,
    "placeholder": ""
  },
  {
    "label": "Enddate:",
    "value": null,
    "tooltip": "End date",
    "datatype": "date",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "enddate",
    "widgettype": "datetime",
    "isMandatory": false,
    "layoutorder": 3,
    "placeholder": "End date for dwf scenario"
  },
  {
    "label": "Observ:",
    "value": null,
    "tooltip": "Observations of dwf scenario",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "observ",
    "widgettype": "linetext",
    "isMandatory": false,
    "layoutorder": 4,
    "placeholder": ""
  },
  {
    "label": "Exploitation:",
    "value": null,
    "tooltip": "dwf scenario type",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "expl",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id AS id, name as idval FROM ve_exploitation",
    "isMandatory": true,
    "layoutorder": 5
  }
]'::json
	WHERE id=3292;

UPDATE sys_table SET context='{"levels": ["EPA", "DSCENARIO"]}', alias = 'Lid Dscenario' WHERE id='ve_inp_dscenario_lids';


UPDATE config_toolbox
	SET inputparams='[
  {
    "label": "Name: (*)",
    "value": null,
    "tooltip": "Name for dscenario (mandatory)",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "name",
    "widgettype": "linetext",
    "isMandatory": true,
    "layoutorder": 1,
    "placeholder": ""
  },
  {
    "label": "Descript:",
    "value": null,
    "tooltip": "Descript for dscenario",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "descript",
    "widgettype": "linetext",
    "isMandatory": false,
    "layoutorder": 2,
    "placeholder": ""
  },
  {
    "label": "Parent:",
    "value": null,
    "tooltip": "Parent for dscenario",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "parent",
    "widgettype": "linetext",
    "isMandatory": false,
    "layoutorder": 3,
    "placeholder": ""
  },
  {
    "label": "Type:",
    "value": null,
    "tooltip": "Dscenario type",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "type",
    "widgettype": "combo",
    "dvQueryText": "SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_dscenario'' ORDER BY id",
    "isMandatory": true,
    "layoutorder": 4
  },
  {
    "label": "Exploitation:",
    "value": null,
    "tooltip": "Dscenario type",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "expl",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id AS id, name as idval FROM ve_exploitation",
    "isMandatory": true,
    "layoutorder": 6
  }
]'::json
	WHERE id=3134;
UPDATE config_toolbox
	SET inputparams='[
  {
    "label": "Scenario name:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "name",
    "widgettype": "text",
    "layoutorder": 1
  },
  {
    "label": "Scenario type:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "type",
    "widgettype": "combo",
    "dvQueryText": "SELECT id, idval FROM inp_typevalue where typevalue = ''inp_typevalue_dscenario'' ORDER BY id",
    "layoutorder": 2
  },
  {
    "label": "Exploitation:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "exploitation",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id as id, name as idval FROM ve_exploitation",
    "layoutorder": 4
  },
  {
    "label": "Descript:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "descript",
    "widgettype": "text",
    "layoutorder": 5
  }
]'::json
	WHERE id=3118;

INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_typevalue_dscenario', 'POLL', 'POLL', NULL, NULL);

UPDATE inp_typevalue SET idval='FRWEIR',id='FRWEIR' WHERE typevalue='inp_typevalue_dscenario' AND id='WEIR';
UPDATE inp_typevalue SET idval='FRPUMP',id='FRPUMP' WHERE typevalue='inp_typevalue_dscenario' AND id='PUMP';
UPDATE inp_typevalue SET idval='FRORIFICE',id='FRORIFICE' WHERE typevalue='inp_typevalue_dscenario' AND id='ORIFICE';
UPDATE inp_typevalue SET idval='FROUTLET',id='FROUTLET' WHERE typevalue='inp_typevalue_dscenario' AND id='OUTLET';

UPDATE config_form_fields
	SET dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND  typevalue = ''inp_typevalue_orifice'''
	WHERE formname='inp_dscenario_frorifice' AND formtype='form_feature' AND columnname='orifice_type' AND tabname='tab_none';
UPDATE config_form_fields
	SET dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_yesno'' '
	WHERE formname='inp_dscenario_frorifice' AND formtype='form_feature' AND columnname='flap' AND tabname='tab_none';
UPDATE config_form_fields
	SET dv_querytext='SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_orifice'''
	WHERE formname='inp_dscenario_frorifice' AND formtype='form_feature' AND columnname='shape' AND tabname='tab_none';


UPDATE sys_table SET context=NULL WHERE id='v_plan_psector_gully';

UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.7-Bratislava" styleCategories="Symbology">
 <renderer-v2 enableorderby="0" symbollevels="0" type="categorizedSymbol" forceraster="0" referencescale="-1" attr="state">
  <categories>
   <category symbol="0" uuid="{80823eb1-ba4e-4517-8d07-82b656725f9b}" type="double" value="0" label="OBSOLETE" render="true"/>
   <category symbol="1" uuid="{718813e6-c212-4d14-b2d5-b98922743e2c}" type="string" value="1" label="OPERATIVE" render="true"/>
   <category symbol="2" uuid="{f2a68c83-ffba-48c2-9142-acb8ab246deb}" type="double" value="2" label="PLANIFIED" render="true"/>
  </categories>
  <symbols>
   <symbol alpha="1" is_animated="0" type="line" name="0" clip_to_extent="1" force_rhr="0" frame_rate="10">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" name="name" value=""/>
      <Option name="properties"/>
      <Option type="QString" name="type" value="collection"/>
     </Option>
    </data_defined_properties>
    <layer locked="0" pass="0" id="{125567a8-a047-460b-9af5-14ba91bb9a69}" enabled="1" class="SimpleLine">
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
      <Option type="QString" name="line_color" value="234,81,83,255,hsv:0.99833333333333329,0.6537575341420615,0.91807431143663687,1"/>
      <Option type="QString" name="line_style" value="solid"/>
      <Option type="QString" name="line_width" value="0.36"/>
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
         <Option type="QString" name="expression" value="case when cat_geom2 > 0 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.25 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer locked="0" pass="0" id="{867127f5-d842-49bc-9fe7-f0c443d7eb32}" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option type="QString" name="average_angle_length" value="4"/>
      <Option type="QString" name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="average_angle_unit" value="MM"/>
      <Option type="QString" name="interval" value="3"/>
      <Option type="QString" name="interval_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="interval_unit" value="MM"/>
      <Option type="QString" name="offset" value="0"/>
      <Option type="QString" name="offset_along_line" value="0"/>
      <Option type="QString" name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_along_line_unit" value="MM"/>
      <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_unit" value="MM"/>
      <Option type="bool" name="place_on_every_part" value="true"/>
      <Option type="QString" name="placements" value="CentralPoint"/>
      <Option type="QString" name="ring_filter" value="0"/>
      <Option type="QString" name="rotate" value="1"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="case when cat_geom2 > 0 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.25 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
     <symbol alpha="1" is_animated="0" type="marker" name="@0@1" clip_to_extent="1" force_rhr="0" frame_rate="10">
      <data_defined_properties>
       <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
       </Option>
      </data_defined_properties>
      <layer locked="0" pass="0" id="{8ffd9947-55a5-4c75-8756-c2fe1b12e838}" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option type="QString" name="angle" value="0"/>
        <Option type="QString" name="cap_style" value="square"/>
        <Option type="QString" name="color" value="234,81,83,255,hsv:0.99833333333333329,0.6537575341420615,0.91807431143663687,1"/>
        <Option type="QString" name="horizontal_anchor_point" value="1"/>
        <Option type="QString" name="joinstyle" value="bevel"/>
        <Option type="QString" name="name" value="filled_arrowhead"/>
        <Option type="QString" name="offset" value="0,0"/>
        <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="offset_unit" value="MM"/>
        <Option type="QString" name="outline_color" value="0,0,0,255,rgb:0,0,0,1"/>
        <Option type="QString" name="outline_style" value="solid"/>
        <Option type="QString" name="outline_width" value="0"/>
        <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="outline_width_unit" value="MM"/>
        <Option type="QString" name="scale_method" value="diameter"/>
        <Option type="QString" name="size" value="0.36"/>
        <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="size_unit" value="MM"/>
        <Option type="QString" name="vertical_anchor_point" value="1"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option type="QString" name="name" value=""/>
         <Option type="Map" name="properties">
          <Option type="Map" name="size">
           <Option type="bool" name="active" value="true"/>
           <Option type="QString" name="expression" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 1000 THEN 0&#xd;&#xa;END"/>
           <Option type="int" name="type" value="3"/>
          </Option>
         </Option>
         <Option type="QString" name="type" value="collection"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol alpha="1" is_animated="0" type="line" name="1" clip_to_extent="1" force_rhr="0" frame_rate="10">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" name="name" value=""/>
      <Option name="properties"/>
      <Option type="QString" name="type" value="collection"/>
     </Option>
    </data_defined_properties>
    <layer locked="0" pass="0" id="{125567a8-a047-460b-9af5-14ba91bb9a69}" enabled="1" class="SimpleLine">
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
      <Option type="QString" name="line_color" value="45,84,255,255,rgb:0.17647058823529413,0.32941176470588235,1,1"/>
      <Option type="QString" name="line_style" value="solid"/>
      <Option type="QString" name="line_width" value="0.36"/>
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
         <Option type="QString" name="expression" value="case when cat_geom2 > 0 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.25 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer locked="0" pass="0" id="{7684a725-426f-47d3-859a-9e4bb0b9a024}" enabled="1" class="SimpleLine">
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
      <Option type="QString" name="line_color" value="219,219,219,0,hsv:0,0,0.86047150377660797,0"/>
      <Option type="QString" name="line_style" value="dot"/>
      <Option type="QString" name="line_width" value="0.3"/>
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
        <Option type="Map" name="outlineColor">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="case when initoverflowpath = true then color_rgba(255,255,255,200) else color_rgba(100,100,100,0) end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="case when cat_geom2 > 0 then&#xd;&#xa;0.1 + 0.415 * ln((cat_geom1*cat_geom2) + 0.10)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.1 + 0.415 * ln((3.14*cat_geom1*cat_geom1/2) + 0.10)&#xd;&#xa;else 0.25 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer locked="0" pass="0" id="{867127f5-d842-49bc-9fe7-f0c443d7eb32}" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option type="QString" name="average_angle_length" value="4"/>
      <Option type="QString" name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="average_angle_unit" value="MM"/>
      <Option type="QString" name="interval" value="3"/>
      <Option type="QString" name="interval_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="interval_unit" value="MM"/>
      <Option type="QString" name="offset" value="0"/>
      <Option type="QString" name="offset_along_line" value="0"/>
      <Option type="QString" name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_along_line_unit" value="MM"/>
      <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_unit" value="MM"/>
      <Option type="bool" name="place_on_every_part" value="true"/>
      <Option type="QString" name="placements" value="CentralPoint"/>
      <Option type="QString" name="ring_filter" value="0"/>
      <Option type="QString" name="rotate" value="1"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="case when cat_geom2 > 0 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.25 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
     <symbol alpha="1" is_animated="0" type="marker" name="@1@2" clip_to_extent="1" force_rhr="0" frame_rate="10">
      <data_defined_properties>
       <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
       </Option>
      </data_defined_properties>
      <layer locked="0" pass="0" id="{8ffd9947-55a5-4c75-8756-c2fe1b12e838}" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option type="QString" name="angle" value="0"/>
        <Option type="QString" name="cap_style" value="square"/>
        <Option type="QString" name="color" value="31,120,180,255,rgb:0.12156862745098039,0.47058823529411764,0.70588235294117652,1"/>
        <Option type="QString" name="horizontal_anchor_point" value="1"/>
        <Option type="QString" name="joinstyle" value="bevel"/>
        <Option type="QString" name="name" value="filled_arrowhead"/>
        <Option type="QString" name="offset" value="0,0"/>
        <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="offset_unit" value="MM"/>
        <Option type="QString" name="outline_color" value="0,0,0,255,rgb:0,0,0,1"/>
        <Option type="QString" name="outline_style" value="solid"/>
        <Option type="QString" name="outline_width" value="0"/>
        <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="outline_width_unit" value="MM"/>
        <Option type="QString" name="scale_method" value="diameter"/>
        <Option type="QString" name="size" value="2.56"/>
        <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="size_unit" value="MM"/>
        <Option type="QString" name="vertical_anchor_point" value="1"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option type="QString" name="name" value=""/>
         <Option type="Map" name="properties">
          <Option type="Map" name="size">
           <Option type="bool" name="active" value="true"/>
           <Option type="QString" name="expression" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1500 THEN 3.0 &#xd;&#xa;WHEN @map_scale  > 1500 THEN 0&#xd;&#xa;END"/>
           <Option type="int" name="type" value="3"/>
          </Option>
         </Option>
         <Option type="QString" name="type" value="collection"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol alpha="1" is_animated="0" type="line" name="2" clip_to_extent="1" force_rhr="0" frame_rate="10">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" name="name" value=""/>
      <Option name="properties"/>
      <Option type="QString" name="type" value="collection"/>
     </Option>
    </data_defined_properties>
    <layer locked="0" pass="0" id="{125567a8-a047-460b-9af5-14ba91bb9a69}" enabled="1" class="SimpleLine">
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
      <Option type="QString" name="line_color" value="255,127,0,255,rgb:1,0.49803921568627452,0,1"/>
      <Option type="QString" name="line_style" value="solid"/>
      <Option type="QString" name="line_width" value="0.36"/>
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
         <Option type="QString" name="expression" value="case when cat_geom2 > 0 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.25 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer locked="0" pass="0" id="{867127f5-d842-49bc-9fe7-f0c443d7eb32}" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option type="QString" name="average_angle_length" value="4"/>
      <Option type="QString" name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="average_angle_unit" value="MM"/>
      <Option type="QString" name="interval" value="3"/>
      <Option type="QString" name="interval_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="interval_unit" value="MM"/>
      <Option type="QString" name="offset" value="0"/>
      <Option type="QString" name="offset_along_line" value="0"/>
      <Option type="QString" name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_along_line_unit" value="MM"/>
      <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_unit" value="MM"/>
      <Option type="bool" name="place_on_every_part" value="true"/>
      <Option type="QString" name="placements" value="CentralPoint"/>
      <Option type="QString" name="ring_filter" value="0"/>
      <Option type="QString" name="rotate" value="1"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="case when cat_geom2 > 0 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.25 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
     <symbol alpha="1" is_animated="0" type="marker" name="@2@1" clip_to_extent="1" force_rhr="0" frame_rate="10">
      <data_defined_properties>
       <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
       </Option>
      </data_defined_properties>
      <layer locked="0" pass="0" id="{8ffd9947-55a5-4c75-8756-c2fe1b12e838}" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option type="QString" name="angle" value="0"/>
        <Option type="QString" name="cap_style" value="square"/>
        <Option type="QString" name="color" value="255,127,0,255,rgb:1,0.49803921568627452,0,1"/>
        <Option type="QString" name="horizontal_anchor_point" value="1"/>
        <Option type="QString" name="joinstyle" value="bevel"/>
        <Option type="QString" name="name" value="filled_arrowhead"/>
        <Option type="QString" name="offset" value="0,0"/>
        <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="offset_unit" value="MM"/>
        <Option type="QString" name="outline_color" value="0,0,0,255,rgb:0,0,0,1"/>
        <Option type="QString" name="outline_style" value="solid"/>
        <Option type="QString" name="outline_width" value="0"/>
        <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="outline_width_unit" value="MM"/>
        <Option type="QString" name="scale_method" value="diameter"/>
        <Option type="QString" name="size" value="0.36"/>
        <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="size_unit" value="MM"/>
        <Option type="QString" name="vertical_anchor_point" value="1"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option type="QString" name="name" value=""/>
         <Option type="Map" name="properties">
          <Option type="Map" name="size">
           <Option type="bool" name="active" value="true"/>
           <Option type="QString" name="expression" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 1000 THEN 0&#xd;&#xa;END"/>
           <Option type="int" name="type" value="3"/>
          </Option>
         </Option>
         <Option type="QString" name="type" value="collection"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
  </symbols>
  <source-symbol>
   <symbol alpha="1" is_animated="0" type="line" name="0" clip_to_extent="1" force_rhr="0" frame_rate="10">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" name="name" value=""/>
      <Option name="properties"/>
      <Option type="QString" name="type" value="collection"/>
     </Option>
    </data_defined_properties>
    <layer locked="0" pass="0" id="{3803a869-1bdf-438a-bb5c-37d3f352e512}" enabled="1" class="SimpleLine">
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
      <Option type="QString" name="line_color" value="45,84,255,255,rgb:0.17647058823529413,0.32941176470588235,1,1"/>
      <Option type="QString" name="line_style" value="solid"/>
      <Option type="QString" name="line_width" value="0.36"/>
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
         <Option type="QString" name="expression" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer locked="0" pass="0" id="{737b3486-832c-473a-a370-2cfc286e6e75}" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option type="QString" name="average_angle_length" value="4"/>
      <Option type="QString" name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="average_angle_unit" value="MM"/>
      <Option type="QString" name="interval" value="3"/>
      <Option type="QString" name="interval_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="interval_unit" value="MM"/>
      <Option type="QString" name="offset" value="0"/>
      <Option type="QString" name="offset_along_line" value="0"/>
      <Option type="QString" name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_along_line_unit" value="MM"/>
      <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_unit" value="MM"/>
      <Option type="bool" name="place_on_every_part" value="true"/>
      <Option type="QString" name="placements" value="CentralPoint"/>
      <Option type="QString" name="ring_filter" value="0"/>
      <Option type="QString" name="rotate" value="1"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
     <symbol alpha="1" is_animated="0" type="marker" name="@0@1" clip_to_extent="1" force_rhr="0" frame_rate="10">
      <data_defined_properties>
       <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
       </Option>
      </data_defined_properties>
      <layer locked="0" pass="0" id="{48a00b63-2aee-4e04-a1cf-ef06d7691b80}" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option type="QString" name="angle" value="0"/>
        <Option type="QString" name="cap_style" value="square"/>
        <Option type="QString" name="color" value="45,84,255,255,rgb:0.17647058823529413,0.32941176470588235,1,1"/>
        <Option type="QString" name="horizontal_anchor_point" value="1"/>
        <Option type="QString" name="joinstyle" value="bevel"/>
        <Option type="QString" name="name" value="filled_arrowhead"/>
        <Option type="QString" name="offset" value="0,0"/>
        <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="offset_unit" value="MM"/>
        <Option type="QString" name="outline_color" value="0,0,0,255,rgb:0,0,0,1"/>
        <Option type="QString" name="outline_style" value="solid"/>
        <Option type="QString" name="outline_width" value="0"/>
        <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="outline_width_unit" value="MM"/>
        <Option type="QString" name="scale_method" value="diameter"/>
        <Option type="QString" name="size" value="0.36"/>
        <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="size_unit" value="MM"/>
        <Option type="QString" name="vertical_anchor_point" value="1"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option type="QString" name="name" value=""/>
         <Option type="Map" name="properties">
          <Option type="Map" name="size">
           <Option type="bool" name="active" value="true"/>
           <Option type="QString" name="expression" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 1000 THEN 0&#xd;&#xa;END"/>
           <Option type="int" name="type" value="3"/>
          </Option>
         </Option>
         <Option type="QString" name="type" value="collection"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
  </source-symbol>
  <rotation/>
  <sizescale/>
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
   <symbol alpha="1" is_animated="0" type="line" name="" clip_to_extent="1" force_rhr="0" frame_rate="10">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" name="name" value=""/>
      <Option name="properties"/>
      <Option type="QString" name="type" value="collection"/>
     </Option>
    </data_defined_properties>
    <layer locked="0" pass="0" id="{3eade21d-240a-43fc-8947-ccec8cc9a73f}" enabled="1" class="SimpleLine">
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
' WHERE layername = 've_arc' AND styleconfig_id=101;

DROP TRIGGER IF EXISTS gw_trg_edit_arc ON ve_arc;
CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

DROP TRIGGER IF EXISTS gw_trg_edit_node ON ve_node;
CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_node 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

DROP TRIGGER IF EXISTS gw_trg_edit_connec ON ve_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_connec 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

DROP TRIGGER IF EXISTS gw_trg_edit_gully ON ve_gully;
CREATE TRIGGER gw_trg_edit_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_gully 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_gully('parent');

DROP TRIGGER IF EXISTS gw_trg_edit_link ON ve_link;
CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_link 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('LINK');
