/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS ve_link_link;
DROP VIEW IF EXISTS v_edit_link;

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

CREATE OR REPLACE VIEW ve_link_link
AS SELECT v_edit_link.link_id,
    v_edit_link.code,
    v_edit_link.sys_code,
    v_edit_link.top_elev1,
    v_edit_link.depth1,
    v_edit_link.elevation1,
    v_edit_link.exit_id,
    v_edit_link.exit_type,
    v_edit_link.top_elev2,
    v_edit_link.depth2,
    v_edit_link.elevation2,
    v_edit_link.feature_type,
    v_edit_link.feature_id,
    v_edit_link.link_type,
    v_edit_link.sys_type,
    v_edit_link.linkcat_id,
    v_edit_link.epa_type,
    v_edit_link.state,
    v_edit_link.state_type,
    v_edit_link.expl_id,
    v_edit_link.macroexpl_id,
    v_edit_link.muni_id,
    v_edit_link.sector_id,
    v_edit_link.macrosector_id,
    v_edit_link.sector_type,
    v_edit_link.supplyzone_id,
    v_edit_link.supplyzone_type,
    v_edit_link.presszone_id,
    v_edit_link.presszone_type,
    v_edit_link.presszone_head,
    v_edit_link.dma_id,
    v_edit_link.macrodma_id,
    v_edit_link.dma_type,
    v_edit_link.dqa_id,
    v_edit_link.macrodqa_id,
    v_edit_link.dqa_type,
    v_edit_link.omzone_id,
    v_edit_link.macroomzone_id,
    v_edit_link.omzone_type,
    v_edit_link.minsector_id,
    v_edit_link.location_type,
    v_edit_link.fluid_type,
    v_edit_link.custom_length,
    v_edit_link.gis_length,
    v_edit_link.staticpressure1,
    v_edit_link.staticpressure2,
    v_edit_link.annotation,
    v_edit_link.observ,
    v_edit_link.comment,
    v_edit_link.descript,
    v_edit_link.link,
    v_edit_link.num_value,
    v_edit_link.workcat_id,
    v_edit_link.workcat_id_end,
    v_edit_link.builtdate,
    v_edit_link.enddate,
    v_edit_link.verified,
    v_edit_link.uncertain,
    v_edit_link.userdefined_geom,
    v_edit_link.datasource,
    v_edit_link.is_operative,
    v_edit_link.inp_type,
    v_edit_link.lock_level,
    v_edit_link.expl_visibility,
    v_edit_link.created_at,
    v_edit_link.created_by,
    v_edit_link.updated_at,
    v_edit_link.updated_by,
    v_edit_link.the_geom
   FROM v_edit_link
     JOIN man_link USING (link_id)
  WHERE v_edit_link.link_type::text = 'LINK'::text;
