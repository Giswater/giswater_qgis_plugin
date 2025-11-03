/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

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
        ), link_psector AS (
        ( SELECT DISTINCT ON (pp.connec_id, pp.state) 'CONNEC'::text AS feature_type,
            pp.connec_id AS feature_id,
            pp.state AS p_state,
            pp.psector_id,
            pp.link_id
           FROM plan_psector_x_connec pp
          WHERE (EXISTS ( SELECT 1
                   FROM sel_ps s
                  WHERE s.psector_id = pp.psector_id))
          ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST)
        UNION ALL
        ( SELECT DISTINCT ON (pp.gully_id, pp.state) 'GULLY'::text AS feature_type,
            pp.gully_id AS feature_id,
            pp.state AS p_state,
            pp.psector_id,
            pp.link_id
           FROM plan_psector_x_gully pp
          WHERE (EXISTS ( SELECT 1
                   FROM sel_ps s
                  WHERE s.psector_id = pp.psector_id))
          ORDER BY pp.gully_id, pp.state, pp.link_id DESC NULLS LAST)
        ), link_selector AS (
         SELECT l.link_id,
            NULL::smallint AS p_state
           FROM link l
          WHERE (EXISTS ( SELECT 1
                   FROM sel_state s
                  WHERE s.state_id = l.state)) AND (EXISTS ( SELECT 1
                   FROM sel_sector s
                  WHERE s.sector_id = l.sector_id)) AND (EXISTS ( SELECT 1
                   FROM sel_expl s
                  WHERE s.expl_id = ANY (array_append(l.expl_visibility::integer[], l.expl_id)))) AND (EXISTS ( SELECT 1
                   FROM sel_muni s
                  WHERE s.muni_id = l.muni_id)) AND NOT (EXISTS ( SELECT 1
                   FROM link_psector lp
                  WHERE lp.link_id = l.link_id))
        UNION ALL
         SELECT lp.link_id,
            lp.p_state
           FROM link_psector lp
          WHERE (EXISTS ( SELECT 1
                   FROM sel_state s
                  WHERE s.state_id = lp.p_state))
        ), link_selected AS (
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
            link_selector.p_state,
            l.uuid,
            l.omunit_id
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
    p_state,
    uuid,
    omunit_id
   FROM link_selected;

