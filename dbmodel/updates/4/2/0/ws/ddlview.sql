/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS ve_link_link;
DROP VIEW IF EXISTS v_edit_link;

ALTER VIEW v_edit_arc RENAME COLUMN staticpress1 TO staticpressure1;
ALTER VIEW v_edit_arc RENAME COLUMN staticpress2 TO staticpressure2;
ALTER VIEW v_edit_arc RENAME COLUMN mincut_impact TO mincut_impact_topo;
ALTER VIEW v_edit_arc RENAME COLUMN mincut_affectation TO mincut_impact_hydro;

CREATE OR REPLACE VIEW v_edit_link
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
        ), link_psector AS (
         SELECT DISTINCT ON (pp.connec_id, pp.state) 'CONNEC'::text AS feature_type,
            pp.connec_id AS feature_id,
            pp.state AS p_state,
            pp.psector_id,
            pp.link_id
           FROM plan_psector_x_connec pp
             JOIN selector_psector sp ON sp.cur_user = CURRENT_USER AND sp.psector_id = pp.psector_id
          ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
        ), link_selector AS (
         SELECT l_1.link_id
           FROM link l_1
             JOIN selector_state s ON s.cur_user = CURRENT_USER AND l_1.state = s.state_id
             LEFT JOIN ( SELECT link_psector.link_id
                   FROM link_psector
                  WHERE link_psector.p_state = 0) a ON a.link_id = l_1.link_id
          WHERE a.link_id IS NULL AND (EXISTS ( SELECT 1
                   FROM selector_expl se
                  WHERE s.cur_user = CURRENT_USER AND (se.expl_id = ANY (array_append(l_1.expl_visibility::integer[], l_1.expl_id))))) AND (EXISTS ( SELECT 1
                   FROM selector_sector sc
                  WHERE sc.cur_user = CURRENT_USER AND sc.sector_id = l_1.sector_id)) AND (EXISTS ( SELECT 1
                   FROM selector_municipality sm
                  WHERE sm.cur_user = CURRENT_USER AND sm.muni_id = l_1.muni_id))
        UNION ALL
         SELECT link_psector.link_id
           FROM link_psector
          WHERE link_psector.p_state = 1
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
            l_1.epa_type,
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
                    WHEN l_1.sector_id > 0 AND l_1.is_operative = true AND l_1.epa_type::text = 'JUNCTION'::text AND inp_network_mode.value = '4'::text THEN l_1.epa_type::text
                    ELSE NULL::text
                END AS inp_type,
            l_1.lock_level,
            l_1.expl_visibility,
            l_1.created_at,
            l_1.created_by,
            l_1.updated_at,
            l_1.updated_by,
            l_1.the_geom
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
    epa_type,
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
    the_geom
   FROM link_selected l;

-- CREATE PARENT VIEWS WITH NEW NAMES
SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views($${"data":{"action":"MULTI-DELETE" }}$$);

ALTER VIEW v_edit_arc RENAME TO ve_arc;
ALTER VIEW v_edit_connec RENAME TO ve_connec;
ALTER VIEW v_edit_link RENAME TO ve_link;
ALTER VIEW v_edit_node RENAME TO ve_node;

CREATE OR REPLACE VIEW ve_link_link
AS SELECT ve_link.link_id,
    ve_link.code,
    ve_link.sys_code,
    ve_link.top_elev1,
    ve_link.depth1,
    ve_link.elevation1,
    ve_link.exit_id,
    ve_link.exit_type,
    ve_link.top_elev2,
    ve_link.depth2,
    ve_link.elevation2,
    ve_link.feature_type,
    ve_link.feature_id,
    ve_link.link_type,
    ve_link.sys_type,
    ve_link.linkcat_id,
    ve_link.epa_type,
    ve_link.state,
    ve_link.state_type,
    ve_link.expl_id,
    ve_link.macroexpl_id,
    ve_link.muni_id,
    ve_link.sector_id,
    ve_link.macrosector_id,
    ve_link.sector_type,
    ve_link.supplyzone_id,
    ve_link.supplyzone_type,
    ve_link.presszone_id,
    ve_link.presszone_type,
    ve_link.presszone_head,
    ve_link.dma_id,
    ve_link.macrodma_id,
    ve_link.dma_type,
    ve_link.dqa_id,
    ve_link.macrodqa_id,
    ve_link.dqa_type,
    ve_link.omzone_id,
    ve_link.macroomzone_id,
    ve_link.omzone_type,
    ve_link.minsector_id,
    ve_link.location_type,
    ve_link.fluid_type,
    ve_link.custom_length,
    ve_link.gis_length,
    ve_link.staticpressure1,
    ve_link.staticpressure2,
    ve_link.annotation,
    ve_link.observ,
    ve_link.comment,
    ve_link.descript,
    ve_link.link,
    ve_link.num_value,
    ve_link.workcat_id,
    ve_link.workcat_id_end,
    ve_link.builtdate,
    ve_link.enddate,
	ve_link.brand_id,
	ve_link.model_id,
    ve_link.verified,
    ve_link.uncertain,
    ve_link.userdefined_geom,
    ve_link.datasource,
    ve_link.is_operative,
    ve_link.inp_type,
    ve_link.lock_level,
    ve_link.expl_visibility,
    ve_link.created_at,
    ve_link.created_by,
    ve_link.updated_at,
    ve_link.updated_by,
    ve_link.the_geom
   FROM ve_link
     JOIN man_link USING (link_id)
  WHERE ve_link.link_type::text = 'LINK'::text;

CREATE OR REPLACE VIEW ve_arc
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
	arc_psector AS (
		SELECT pp.arc_id, pp.state AS p_state
		FROM plan_psector_x_arc pp
		JOIN selector_psector sp ON sp.cur_user = CURRENT_USER AND sp.psector_id = pp.psector_id
	),
	arc_selector AS (
		SELECT a.arc_id
		FROM arc a
		WHERE EXISTS ((SELECT 1 FROM sel_state s WHERE s.state_id = a.state))
		AND EXISTS ((SELECT 1 FROM sel_sector s WHERE s.sector_id = a.sector_id))
		AND EXISTS ((SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(expl_visibility, a.expl_id))))
		AND EXISTS ((SELECT 1 FROM sel_muni s WHERE s.muni_id = a.muni_id))
		AND NOT (
			EXISTS (
				SELECT 1
				FROM arc_psector ap
				WHERE ap.arc_id = a.arc_id AND ap.p_state = 0
			)
		)
		UNION ALL
		SELECT ap.arc_id
		FROM arc_psector ap
		WHERE ap.p_state = 1
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
				WHEN arc.sector_id > 0 AND vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::text THEN arc.epa_type
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
	SELECT arc_selected.*
	FROM arc_selected;

CREATE OR REPLACE VIEW ve_node
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
    node_psector AS (
      	SELECT pp.node_id, pp.state AS p_state
      	FROM plan_psector_x_node pp
      	JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
    ),
    node_selector AS (
		SELECT n.node_id
		FROM node n
		WHERE EXISTS ((SELECT 1 FROM sel_state s WHERE s.state_id = n.state))
		AND EXISTS ((SELECT 1 FROM sel_sector s WHERE s.sector_id = n.sector_id))
		AND EXISTS ((SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(expl_visibility, n.expl_id))))
		AND EXISTS ((SELECT 1 FROM sel_muni s WHERE s.muni_id = n.muni_id))
		AND NOT (
			EXISTS (
				SELECT 1
				FROM node_psector np
				WHERE np.node_id = n.node_id AND np.p_state = 0
			)
		)
		UNION ALL
		SELECT np.node_id
		FROM node_psector np
		WHERE np.p_state = 1
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
			streetaxis_id,
			node.postcode,
			node.postnumber,
			node.postcomplement,
			streetaxis2_id,
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
			WHEN node.sector_id > 0 AND vst.is_operative = true AND node.epa_type::text <> 'UNDEFINED'::text THEN node.epa_type
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
			(SELECT ST_X(node.the_geom)) AS xcoord,
			(SELECT ST_Y(node.the_geom)) AS ycoord,
			(SELECT ST_Y(ST_Transform(node.the_geom, 4326))) AS lat,
			(SELECT ST_X(ST_Transform(node.the_geom, 4326))) AS long,
			m.closed as closed_valve,
			m.broken as broken_valve,
			date_trunc('second'::text, node.created_at) AS created_at,
			node.created_by,
			date_trunc('second'::text, node.updated_at) AS updated_at,
			node.updated_by,
			node.the_geom
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
    SELECT n.*
    FROM node_selected n;

CREATE OR REPLACE VIEW ve_link
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
    link_psector AS (
        SELECT DISTINCT ON (pp.connec_id, pp.state) 'CONNEC' AS feature_type, pp.connec_id AS feature_id, pp.state AS p_state, pp.psector_id, pp.link_id
        FROM plan_psector_x_connec pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
	),
    link_selector AS (
        SELECT l.link_id
        FROM link l
		WHERE EXISTS ((SELECT 1 FROM sel_state s WHERE s.state_id = l.state))
		AND EXISTS ((SELECT 1 FROM sel_sector s WHERE s.sector_id = l.sector_id))
		AND EXISTS ((SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(expl_visibility, l.expl_id))))
		AND EXISTS ((SELECT 1 FROM sel_muni s WHERE s.muni_id = l.muni_id))
		AND NOT (
			EXISTS (
				SELECT 1
				FROM link_psector lp
				WHERE lp.link_id = l.link_id AND lp.p_state = 0
			)
		)
		UNION ALL
		SELECT lp.link_id
		FROM link_psector lp
		WHERE lp.p_state = 1
    ),
    link_selected AS (
        SELECT
			l.link_id,
			l.code,
			l.sys_code,
			l.top_elev1,
			l.depth1,
			CASE
			WHEN l.top_elev1 IS NULL OR l.depth1 IS NULL THEN NULL
			ELSE (l.top_elev1 - l.depth1)
			END AS elevation1,
			l.exit_id,
			l.exit_type,
			l.top_elev2,
			l.depth2,
			CASE
			WHEN l.top_elev2 IS NULL OR l.depth2 IS NULL THEN NULL
			ELSE (l.top_elev2 - l.depth2)
			END AS elevation2,
			l.feature_type,
			l.feature_id,
			cat_link.link_type,
			cat_feature.feature_class AS sys_type,
			l.linkcat_id,
			l.epa_type,
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
			CASE
			WHEN l.sector_id > 0 AND l.is_operative = true AND l.epa_type = 'JUNCTION'::text AND inp_network_mode.value = '4'::text
			THEN l.epa_type::text
			ELSE NULL::text
			END AS inp_type,
			l.lock_level,
			l.expl_visibility,
			l.created_at,
			l.created_by,
			l.updated_at,
			l.updated_by,
			l.the_geom
			FROM link_selector
			JOIN link l ON l.link_id = link_selector.link_id
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
			LEFT JOIN inp_network_mode ON true
	)
    SELECT l.*
    FROM link_selected l;

CREATE OR REPLACE VIEW ve_connec
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
		LEFT JOIN crmzone ON crmzone.id::text = connec.crmzone_id::text
		LEFT JOIN link_planned USING (link_id)
		LEFT JOIN connec_add ON connec_add.connec_id = connec.connec_id
		LEFT JOIN value_state_type vst ON vst.id = connec.state_type
		LEFT JOIN inp_network_mode ON true
	)
    SELECT c.*
    FROM connec_selected c;

-- old v_edit parent tables:
CREATE OR REPLACE VIEW v_edit_arc
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
	arc_psector AS (
		SELECT pp.arc_id, pp.state AS p_state
		FROM plan_psector_x_arc pp
		JOIN selector_psector sp ON sp.cur_user = CURRENT_USER AND sp.psector_id = pp.psector_id
	),
	arc_selector AS (
		SELECT a.arc_id
		FROM arc a
		WHERE EXISTS ((SELECT 1 FROM sel_state s WHERE s.state_id = a.state))
		AND EXISTS ((SELECT 1 FROM sel_sector s WHERE s.sector_id = a.sector_id))
		AND EXISTS ((SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(expl_visibility, a.expl_id))))
		AND EXISTS ((SELECT 1 FROM sel_muni s WHERE s.muni_id = a.muni_id))
		AND NOT (
			EXISTS (
				SELECT 1
				FROM arc_psector ap
				WHERE ap.arc_id = a.arc_id AND ap.p_state = 0
			)
		)
		UNION ALL
		SELECT ap.arc_id
		FROM arc_psector ap
		WHERE ap.p_state = 1
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
				WHEN arc.sector_id > 0 AND vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::text THEN arc.epa_type
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
	SELECT arc_selected.*
	FROM arc_selected;

CREATE OR REPLACE VIEW v_edit_node
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
    node_psector AS (
      	SELECT pp.node_id, pp.state AS p_state
      	FROM plan_psector_x_node pp
      	JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
    ),
    node_selector AS (
		SELECT n.node_id
		FROM node n
		WHERE EXISTS ((SELECT 1 FROM sel_state s WHERE s.state_id = n.state))
		AND EXISTS ((SELECT 1 FROM sel_sector s WHERE s.sector_id = n.sector_id))
		AND EXISTS ((SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(expl_visibility, n.expl_id))))
		AND EXISTS ((SELECT 1 FROM sel_muni s WHERE s.muni_id = n.muni_id))
		AND NOT (
			EXISTS (
				SELECT 1
				FROM node_psector np
				WHERE np.node_id = n.node_id AND np.p_state = 0
			)
		)
		UNION ALL
		SELECT np.node_id
		FROM node_psector np
		WHERE np.p_state = 1
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
			streetaxis_id,
			node.postcode,
			node.postnumber,
			node.postcomplement,
			streetaxis2_id,
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
			WHEN node.sector_id > 0 AND vst.is_operative = true AND node.epa_type::text <> 'UNDEFINED'::text THEN node.epa_type
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
			(SELECT ST_X(node.the_geom)) AS xcoord,
			(SELECT ST_Y(node.the_geom)) AS ycoord,
			(SELECT ST_Y(ST_Transform(node.the_geom, 4326))) AS lat,
			(SELECT ST_X(ST_Transform(node.the_geom, 4326))) AS long,
			m.closed as closed_valve,
			m.broken as broken_valve,
			date_trunc('second'::text, node.created_at) AS created_at,
			node.created_by,
			date_trunc('second'::text, node.updated_at) AS updated_at,
			node.updated_by,
			node.the_geom
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
    SELECT n.*
    FROM node_selected n;

CREATE OR REPLACE VIEW v_edit_link
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
    link_psector AS (
        SELECT DISTINCT ON (pp.connec_id, pp.state) 'CONNEC' AS feature_type, pp.connec_id AS feature_id, pp.state AS p_state, pp.psector_id, pp.link_id
        FROM plan_psector_x_connec pp
        JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
        ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
	),
    link_selector AS (
        SELECT l.link_id
        FROM link l
		WHERE EXISTS ((SELECT 1 FROM sel_state s WHERE s.state_id = l.state))
		AND EXISTS ((SELECT 1 FROM sel_sector s WHERE s.sector_id = l.sector_id))
		AND EXISTS ((SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY (array_append(expl_visibility, l.expl_id))))
		AND EXISTS ((SELECT 1 FROM sel_muni s WHERE s.muni_id = l.muni_id))
		AND NOT (
			EXISTS (
				SELECT 1
				FROM link_psector lp
				WHERE lp.link_id = l.link_id AND lp.p_state = 0
			)
		)
		UNION ALL
		SELECT lp.link_id
		FROM link_psector lp
		WHERE lp.p_state = 1
    ),
    link_selected AS (
        SELECT
			l.link_id,
			l.code,
			l.sys_code,
			l.top_elev1,
			l.depth1,
			CASE
			WHEN l.top_elev1 IS NULL OR l.depth1 IS NULL THEN NULL
			ELSE (l.top_elev1 - l.depth1)
			END AS elevation1,
			l.exit_id,
			l.exit_type,
			l.top_elev2,
			l.depth2,
			CASE
			WHEN l.top_elev2 IS NULL OR l.depth2 IS NULL THEN NULL
			ELSE (l.top_elev2 - l.depth2)
			END AS elevation2,
			l.feature_type,
			l.feature_id,
			cat_link.link_type,
			cat_feature.feature_class AS sys_type,
			l.linkcat_id,
			l.epa_type,
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
			l.verified,
			l.uncertain,
			l.userdefined_geom,
			l.datasource,
			l.is_operative,
			CASE
			WHEN l.sector_id > 0 AND l.is_operative = true AND l.epa_type = 'JUNCTION'::text AND inp_network_mode.value = '4'::text
			THEN l.epa_type::text
			ELSE NULL::text
			END AS inp_type,
			l.lock_level,
			l.expl_visibility,
			l.created_at,
			l.created_by,
			l.updated_at,
			l.updated_by,
			l.the_geom
			FROM link_selector
			JOIN link l ON l.link_id = link_selector.link_id
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
			LEFT JOIN inp_network_mode ON true
	)
    SELECT l.*
    FROM link_selected l;

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
		LEFT JOIN crmzone ON crmzone.id::text = connec.crmzone_id::text
		LEFT JOIN link_planned USING (link_id)
		LEFT JOIN connec_add ON connec_add.connec_id = connec.connec_id
		LEFT JOIN value_state_type vst ON vst.id = connec.state_type
		LEFT JOIN inp_network_mode ON true
	)
    SELECT c.*
    FROM connec_selected c;
-- ===============================

ALTER VIEW v_edit_anl_hydrant RENAME TO ve_anl_hydrant;
ALTER VIEW v_edit_cad_auxcircle RENAME TO ve_cad_auxcircle;
ALTER VIEW v_edit_cad_auxline RENAME TO ve_cad_auxline;
ALTER VIEW v_edit_cad_auxpoint RENAME TO ve_cad_auxpoint;
ALTER VIEW v_edit_cat_dscenario RENAME TO ve_cat_dscenario;
ALTER VIEW v_edit_cat_feature_arc RENAME TO ve_cat_feature_arc;
ALTER VIEW v_edit_cat_feature_connec RENAME TO ve_cat_feature_connec;
ALTER VIEW v_edit_cat_feature_element RENAME TO ve_cat_feature_element;
ALTER VIEW v_edit_cat_feature_link RENAME TO ve_cat_feature_link;
ALTER VIEW v_edit_cat_feature_node RENAME TO ve_cat_feature_node;
ALTER VIEW v_edit_dimensions RENAME TO ve_dimensions;
ALTER VIEW v_edit_dma RENAME TO ve_dma;
ALTER VIEW v_edit_dqa RENAME TO ve_dqa;
ALTER VIEW v_edit_exploitation RENAME TO ve_exploitation;
ALTER VIEW v_edit_inp_connec RENAME TO ve_inp_connec;
ALTER VIEW v_edit_inp_controls RENAME TO ve_inp_controls;
ALTER VIEW v_edit_inp_curve RENAME TO ve_inp_curve;
ALTER VIEW v_edit_inp_curve_value RENAME TO ve_inp_curve_value;
ALTER VIEW v_edit_inp_dscenario_connec RENAME TO ve_inp_dscenario_connec;
ALTER VIEW v_edit_inp_dscenario_controls RENAME TO ve_inp_dscenario_controls;
ALTER VIEW v_edit_inp_dscenario_demand RENAME TO ve_inp_dscenario_demand;
ALTER VIEW v_edit_inp_dscenario_frpump RENAME TO ve_inp_dscenario_frpump;
ALTER VIEW v_edit_inp_dscenario_frvalve RENAME TO ve_inp_dscenario_frvalve;
ALTER VIEW v_edit_inp_dscenario_inlet RENAME TO ve_inp_dscenario_inlet;
ALTER VIEW v_edit_inp_dscenario_junction RENAME TO ve_inp_dscenario_junction;
ALTER VIEW v_edit_inp_dscenario_pipe RENAME TO ve_inp_dscenario_pipe;
ALTER VIEW v_edit_inp_dscenario_pump RENAME TO ve_inp_dscenario_pump;
ALTER VIEW v_edit_inp_dscenario_pump_additional RENAME TO ve_inp_dscenario_pump_additional;
ALTER VIEW v_edit_inp_dscenario_reservoir RENAME TO ve_inp_dscenario_reservoir;
ALTER VIEW v_edit_inp_dscenario_rules RENAME TO ve_inp_dscenario_rules;
ALTER VIEW v_edit_inp_dscenario_shortpipe RENAME TO ve_inp_dscenario_shortpipe;
ALTER VIEW v_edit_inp_dscenario_tank RENAME TO ve_inp_dscenario_tank;
ALTER VIEW v_edit_inp_dscenario_valve RENAME TO ve_inp_dscenario_valve;
ALTER VIEW v_edit_inp_dscenario_virtualpump RENAME TO ve_inp_dscenario_virtualpump;
ALTER VIEW v_edit_inp_dscenario_virtualvalve RENAME TO ve_inp_dscenario_virtualvalve;
ALTER VIEW v_edit_inp_frpump RENAME TO ve_inp_frpump;
ALTER VIEW v_edit_inp_frvalve RENAME TO ve_inp_frvalve;
ALTER VIEW v_edit_inp_inlet RENAME TO ve_inp_inlet;
ALTER VIEW v_edit_inp_junction RENAME TO ve_inp_junction;
ALTER VIEW v_edit_inp_pattern RENAME TO ve_inp_pattern;
ALTER VIEW v_edit_inp_pattern_value RENAME TO ve_inp_pattern_value;
ALTER VIEW v_edit_inp_pipe RENAME TO ve_inp_pipe;
ALTER VIEW v_edit_inp_pump RENAME TO ve_inp_pump;
ALTER VIEW v_edit_inp_pump_additional RENAME TO ve_inp_pump_additional;
ALTER VIEW v_edit_inp_reservoir RENAME TO ve_inp_reservoir;
ALTER VIEW v_edit_inp_rules RENAME TO ve_inp_rules;
ALTER VIEW v_edit_inp_shortpipe RENAME TO ve_inp_shortpipe;
ALTER VIEW v_edit_inp_tank RENAME TO ve_inp_tank;
ALTER VIEW v_edit_inp_valve RENAME TO ve_inp_valve;
ALTER VIEW v_edit_inp_virtualpump RENAME TO ve_inp_virtualpump;
ALTER VIEW v_edit_inp_virtualvalve RENAME TO ve_inp_virtualvalve;
ALTER VIEW v_edit_macrodma RENAME TO ve_macrodma;
ALTER VIEW v_edit_macrodqa RENAME TO ve_macrodqa;
ALTER VIEW v_edit_macroexploitation RENAME TO ve_macroexploitation;
ALTER VIEW v_edit_macroomzone RENAME TO ve_macroomzone;
ALTER VIEW v_edit_macrosector RENAME TO ve_macrosector;
ALTER VIEW v_edit_minsector RENAME TO ve_minsector;
ALTER VIEW v_edit_minsector_mincut RENAME TO ve_minsector_mincut;
ALTER VIEW v_edit_om_visit RENAME TO ve_om_visit;
ALTER VIEW v_edit_omzone RENAME TO ve_omzone;
ALTER VIEW v_edit_plan_netscenario_dma RENAME TO ve_plan_netscenario_dma;
ALTER VIEW v_edit_plan_netscenario_presszone RENAME TO ve_plan_netscenario_presszone;
ALTER VIEW v_edit_plan_netscenario_valve RENAME TO ve_plan_netscenario_valve;
ALTER VIEW v_edit_plan_psector_x_connec RENAME TO ve_plan_psector_x_connec;
ALTER VIEW v_edit_plan_psector_x_other RENAME TO ve_plan_psector_x_other;
ALTER VIEW v_edit_presszone RENAME TO ve_presszone;
ALTER VIEW v_edit_review_arc RENAME TO ve_review_arc;
ALTER VIEW v_edit_review_audit_arc RENAME TO ve_review_audit_arc;
ALTER VIEW v_edit_review_audit_connec RENAME TO ve_review_audit_connec;
ALTER VIEW v_edit_review_audit_node RENAME TO ve_review_audit_node;
ALTER VIEW v_edit_review_connec RENAME TO ve_review_connec;
ALTER VIEW v_edit_review_node RENAME TO ve_review_node;
ALTER VIEW v_edit_rtc_hydro_data_x_connec RENAME TO ve_rtc_hydro_data_x_connec;
ALTER VIEW v_edit_samplepoint RENAME TO ve_samplepoint;
ALTER VIEW v_edit_sector RENAME TO ve_sector;
ALTER VIEW v_edit_supplyzone RENAME TO ve_supplyzone;
