/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_ui_event_x_link
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit.class_id as visit_class,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_link.link_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_link ON om_visit_x_link.visit_id = om_visit.id
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     JOIN link ON link.link_id = om_visit_x_link.link_id
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_link.link_id;


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
            connec_selector.p_state,
            connec.uuid
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
    p_state,
    uuid
   FROM connec_selected;

-- 20/10/2025
CREATE OR REPLACE VIEW v_ui_rpt_cat_result
AS SELECT DISTINCT ON (rpt_cat_result.result_id) rpt_cat_result.result_id,
    rpt_cat_result.expl_id,
    rpt_cat_result.sector_id,
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

