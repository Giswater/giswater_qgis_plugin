/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_edit_arc
AS WITH sel_state AS (
            SELECT selector_state.state_id FROM selector_state WHERE selector_state.cur_user = CURRENT_USER
        ), sel_sector AS (
            SELECT selector_sector.sector_id FROM selector_sector WHERE selector_sector.cur_user = CURRENT_USER
        ), sel_expl AS (
            SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
        ), sel_muni AS (
            SELECT selector_municipality.muni_id FROM selector_municipality WHERE selector_municipality.cur_user = CURRENT_USER
        ), sel_ps AS (
            SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
        ), typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'dma_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.name AS sector_name,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), dma_table AS (
         SELECT dma.dma_id,
            dma.name AS dma_name,
            dma.macrodma_id,
            dma.stylesheet,
            t.id::character varying(16) AS dma_type
           FROM dma
             LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.name AS drainzone_name,
            drainzone.stylesheet,
            t.id::character varying(16) AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), arc_psector AS (
         SELECT pp.arc_id,
            pp.state AS p_state
           FROM plan_psector_x_arc pp
             JOIN selector_psector sp ON sp.cur_user = CURRENT_USER AND sp.psector_id = pp.psector_id
        ), arc_selector AS (
            SELECT a.arc_id
            FROM arc a
            WHERE (a.state IN (SELECT sel_state.state_id FROM sel_state))
            AND (a.sector_id IN (SELECT sel_sector.sector_id FROM sel_sector))
            AND ((a.expl_id IN (SELECT sel_expl.expl_id FROM sel_expl)) OR (a.expl_id2 IN ( SELECT sel_expl.expl_id FROM sel_expl)))
            AND (a.muni_id IN (SELECT sel_muni.muni_id FROM sel_muni))
            AND NOT (
                    EXISTS (
                    SELECT 1
                    FROM arc_psector ap
                    WHERE ap.arc_id::text = a.arc_id::text AND ap.p_state = 0)
                )
            UNION ALL
            SELECT ap.arc_id
            FROM arc_psector ap
            WHERE ap.p_state = 1
        ), arc_selected AS (
         SELECT distinct on (arc_id) arc.arc_id,
            arc.code,
            arc.node_1,
            arc.nodetype_1,
            arc.y1,
            arc.custom_y1,
            arc.elev1,
            arc.custom_elev1,
                CASE
                    WHEN arc.sys_elev1 IS NULL THEN arc.node_sys_elev_1
                    ELSE arc.sys_elev1
                END AS sys_elev1,
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
            arc.y2,
            arc.custom_y2,
            arc.elev2,
            arc.custom_elev2,
                CASE
                    WHEN arc.sys_elev2 IS NULL THEN arc.node_sys_elev_2
                    ELSE arc.sys_elev2
                END AS sys_elev2,
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
            arc.sys_slope AS slope,
            arc.arc_type,
            cat_feature.system_id AS sys_type,
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
            arc.expl_id,
            e.macroexpl_id,
            arc.sector_id,
            sector_table.sector_type,
            sector_table.macrosector_id,
            arc.drainzone_id,
            drainzone_table.drainzone_type,
            arc.annotation,
            st_length(arc.the_geom)::numeric(12,2) AS gis_length,
            arc.custom_length,
            arc.inverted_slope,
            arc.observ,
            arc.comment,
            arc.dma_id,
            dma_table.macrodma_id,
            dma_table.dma_type,
            arc.soilcat_id,
            arc.function_type,
            arc.category_type,
            arc.fluid_type,
            arc.location_type,
            arc.workcat_id,
            arc.workcat_id_end,
            arc.workcat_id_plan,
            arc.builtdate,
            arc.enddate,
            arc.buildercat_id,
            arc.ownercat_id,
            arc.muni_id,
            arc.postcode,
            arc.district_id,
            arc.streetname,
            arc.postnumber,
            arc.postcomplement,
            arc.streetname2,
            arc.postnumber2,
            arc.postcomplement2,
            mu.region_id,
            mu.province_id,
            arc.descript,
            concat(cat_feature.link_path, arc.link) AS link,
            arc.verified,
            arc.undelete,
            cat_arc.label,
            arc.label_x,
            arc.label_y,
            arc.label_rotation,
            arc.label_quadrant,
            arc.publish,
            arc.inventory,
            arc.uncertain,
            arc.num_value,
            arc.asset_id,
            arc.pavcat_id,
            arc.parent_id,
            arc.expl_id2,
            vst.is_operative,
            arc.minsector_id,
            arc.macrominsector_id,
            arc.adate,
            arc.adescript,
            arc.visitability,
            date_trunc('second'::text, arc.tstamp) AS tstamp,
            arc.insert_user,
            date_trunc('second'::text, arc.lastupdate) AS lastupdate,
            arc.lastupdate_user,
            arc.the_geom,
                CASE
                    WHEN arc.sector_id > 0 AND vst.is_operative = true AND arc.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN arc.epa_type
                    ELSE NULL::character varying(16)
                END AS inp_type,
            arc.brand_id,
            arc.model_id,
            arc.serial_number
           FROM arc_selector
             JOIN arc USING (arc_id)
             JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
             JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
             JOIN exploitation e ON e.expl_id = arc.expl_id
             JOIN ext_municipality mu ON arc.muni_id = mu.muni_id
             JOIN value_state_type vst ON vst.id = arc.state_type
             JOIN sector_table ON sector_table.sector_id = arc.sector_id
             LEFT JOIN dma_table ON dma_table.dma_id = arc.dma_id
             LEFT JOIN drainzone_table ON arc.dma_id = drainzone_table.drainzone_id
        )
 SELECT arc_id,
    code,
    node_1,
    nodetype_1,
    y1,
    custom_y1,
    elev1,
    custom_elev1,
    sys_elev1,
    sys_y1,
    r1,
    z1,
    node_2,
    nodetype_2,
    y2,
    custom_y2,
    elev2,
    custom_elev2,
    sys_elev2,
    sys_y2,
    r2,
    z2,
    slope,
    arc_type,
    sys_type,
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
    expl_id,
    macroexpl_id,
    sector_id,
    sector_type,
    macrosector_id,
    drainzone_id,
    drainzone_type,
    annotation,
    gis_length,
    custom_length,
    inverted_slope,
    observ,
    comment,
    dma_id,
    macrodma_id,
    dma_type,
    soilcat_id,
    function_type,
    category_type,
    fluid_type,
    location_type,
    workcat_id,
    workcat_id_end,
    workcat_id_plan,
    builtdate,
    enddate,
    buildercat_id,
    ownercat_id,
    muni_id,
    postcode,
    district_id,
    streetname,
    postnumber,
    postcomplement,
    streetname2,
    postnumber2,
    postcomplement2,
    region_id,
    province_id,
    descript,
    link,
    verified,
    undelete,
    label,
    label_x,
    label_y,
    label_rotation,
    label_quadrant,
    publish,
    inventory,
    uncertain,
    num_value,
    asset_id,
    pavcat_id,
    parent_id,
    expl_id2,
    is_operative,
    minsector_id,
    macrominsector_id,
    adate,
    adescript,
    visitability,
    tstamp,
    insert_user,
    lastupdate,
    lastupdate_user,
    the_geom,
    inp_type,
    brand_id,
    model_id,
    serial_number
   FROM arc_selected;


CREATE OR REPLACE VIEW v_edit_connec
AS WITH sel_state AS (
            SELECT selector_state.state_id FROM selector_state WHERE selector_state.cur_user = CURRENT_USER
        ), sel_sector AS (
            SELECT selector_sector.sector_id FROM selector_sector WHERE selector_sector.cur_user = CURRENT_USER
        ), sel_expl AS (
            SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
        ), sel_muni AS (
            SELECT selector_municipality.muni_id FROM selector_municipality WHERE selector_municipality.cur_user = CURRENT_USER
        ), sel_ps AS (
            SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
        ), typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'dma_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.name AS sector_name,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), dma_table AS (
         SELECT dma.dma_id,
            dma.name AS dma_name,
            dma.macrodma_id,
            dma.stylesheet,
            t.id::character varying(16) AS dma_type
           FROM dma
             LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.name AS drainzone_name,
            drainzone.stylesheet,
            t.id::character varying(16) AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), link_planned AS (
         SELECT l.link_id,
            l.feature_id,
            l.feature_type,
            l.exit_id,
            l.exit_type,
            l.expl_id,
            exploitation.macroexpl_id,
            l.sector_id,
            sector_table.sector_name,
            sector_table.macrosector_id,
            l.dma_id,
            dma_table.dma_name,
            dma_table.macrodma_id,
            l.drainzone_id,
            drainzone_table.drainzone_name,
            l.fluid_type,
            sector_table.sector_type,
            drainzone_table.drainzone_type,
            dma_table.dma_type
           FROM link l
             JOIN exploitation USING (expl_id)
             JOIN sector_table ON l.sector_id = sector_table.sector_id
             LEFT JOIN dma_table ON l.dma_id = dma_table.dma_id
             LEFT JOIN drainzone_table ON l.dma_id = drainzone_table.drainzone_id
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
            SELECT c.connec_id, c.arc_id, NULL::integer AS link_id
            FROM connec c
            WHERE (c.state IN ( SELECT sel_state.state_id FROM sel_state))
            AND (c.sector_id IN ( SELECT sel_sector.sector_id FROM sel_sector))
            AND ((c.expl_id IN ( SELECT sel_expl.expl_id FROM sel_expl)) OR (c.expl_id2 IN ( SELECT sel_expl.expl_id FROM sel_expl)))
            AND (c.muni_id IN ( SELECT sel_muni.muni_id FROM sel_muni))
            AND NOT (
                EXISTS (
                    SELECT 1
                    FROM connec_psector cp
                    WHERE cp.connec_id::text = c.connec_id::text AND cp.p_state = 0
                )
            )
            UNION ALL
            SELECT cp.connec_id, cp.arc_id, cp.link_id
            FROM connec_psector cp
            WHERE cp.p_state = 1
        ), connec_selected AS (
         SELECT distinct on (connec_id) connec.connec_id,
            connec.code,
            connec.customer_code,
            connec.top_elev,
            connec.y1,
            connec.y2,
            connec.connecat_id,
            connec.connec_type,
            cat_feature.system_id AS sys_type,
            connec.private_connecat_id,
            connec.matcat_id,
            connec.state,
            connec.state_type,
            connec.expl_id,
            exploitation.macroexpl_id,
                CASE
                    WHEN link_planned.sector_id IS NULL THEN connec.sector_id
                    ELSE link_planned.sector_id
                END AS sector_id,
            sector_table.sector_type,
                CASE
                    WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
                    ELSE link_planned.macrosector_id
                END AS macrosector_id,
                CASE
                    WHEN link_planned.drainzone_id IS NULL THEN connec.drainzone_id
                    ELSE link_planned.drainzone_id
                END AS drainzone_id,
                CASE
                    WHEN link_planned.drainzone_type IS NULL THEN drainzone_table.drainzone_type
                    ELSE link_planned.drainzone_type
                END AS drainzone_type,
            connec.demand,
            connec.connec_depth,
            connec.connec_length,
            connec_selector.arc_id,
            connec.annotation,
            connec.observ,
            connec.comment,
                CASE
                    WHEN link_planned.dma_id IS NULL THEN connec.dma_id
                    ELSE link_planned.dma_id
                END AS dma_id,
                CASE
                    WHEN link_planned.macrodma_id IS NULL THEN dma_table.macrodma_id
                    ELSE link_planned.macrodma_id
                END AS macrodma_id,
                CASE
                    WHEN link_planned.dma_type IS NULL THEN dma_table.dma_type
                    ELSE link_planned.dma_type
                END AS dma_type,
            connec.soilcat_id,
            connec.function_type,
            connec.category_type,
            connec.fluid_type,
            connec.location_type,
            connec.workcat_id,
            connec.workcat_id_end,
            connec.buildercat_id,
            connec.builtdate,
            connec.enddate,
            connec.ownercat_id,
            connec.muni_id,
            connec.postcode,
            connec.district_id,
            connec.streetname,
            connec.postnumber,
            connec.postcomplement,
            connec.streetname2,
            connec.postnumber2,
            connec.postcomplement2,
            mu.region_id,
            mu.province_id,
            connec.descript,
            cat_connec.svg,
            connec.rotation,
            connec.link::text AS link,
            connec.verified,
            connec.undelete,
            cat_connec.label,
            connec.label_x,
            connec.label_y,
            connec.label_rotation,
            connec.label_quadrant,
            connec.accessibility,
            connec.diagonal,
            connec.publish,
            connec.inventory,
            connec.uncertain,
            connec.num_value,
                CASE
                    WHEN link_planned.exit_id IS NULL THEN connec.pjoint_id
                    ELSE link_planned.exit_id
                END AS pjoint_id,
                CASE
                    WHEN link_planned.exit_type IS NULL THEN connec.pjoint_type
                    ELSE link_planned.exit_type
                END AS pjoint_type,
            connec.tstamp,
            connec.insert_user,
            connec.lastupdate,
            connec.lastupdate_user,
            connec.the_geom,
            connec.workcat_id_plan,
            connec.asset_id,
            connec.expl_id2,
            vst.is_operative,
            connec.minsector_id,
            connec.macrominsector_id,
            connec.adate,
            connec.adescript,
            connec.plot_code,
            connec.placement_type,
            connec.access_type
           FROM connec_selector
             JOIN connec USING (connec_id)
             JOIN cat_connec ON cat_connec.id::text = connec.connecat_id::text
             JOIN cat_feature ON cat_feature.id::text = connec.connec_type::text
             JOIN exploitation ON connec.expl_id = exploitation.expl_id
             JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
             JOIN value_state_type vst ON vst.id = connec.state_type
             JOIN sector_table ON sector_table.sector_id = connec.sector_id
             LEFT JOIN dma_table ON dma_table.dma_id = connec.dma_id
             LEFT JOIN drainzone_table ON connec.dma_id = drainzone_table.drainzone_id
             LEFT JOIN link_planned USING (link_id)
        )
 SELECT connec_id,
    code,
    customer_code,
    top_elev,
    y1,
    y2,
    connecat_id,
    connec_type,
    sys_type,
    private_connecat_id,
    matcat_id,
    state,
    state_type,
    expl_id,
    macroexpl_id,
    sector_id,
    sector_type,
    macrosector_id,
    drainzone_id,
    drainzone_type,
    demand,
    connec_depth,
    connec_length,
    arc_id,
    annotation,
    observ,
    comment,
    dma_id,
    macrodma_id,
    dma_type,
    soilcat_id,
    function_type,
    category_type,
    fluid_type,
    location_type,
    workcat_id,
    workcat_id_end,
    buildercat_id,
    builtdate,
    enddate,
    ownercat_id,
    muni_id,
    postcode,
    district_id,
    streetname,
    postnumber,
    postcomplement,
    streetname2,
    postnumber2,
    postcomplement2,
    region_id,
    province_id,
    descript,
    svg,
    rotation,
    link,
    verified,
    undelete,
    label,
    label_x,
    label_y,
    label_rotation,
    label_quadrant,
    accessibility,
    diagonal,
    publish,
    inventory,
    uncertain,
    num_value,
    pjoint_id,
    pjoint_type,
    tstamp,
    insert_user,
    lastupdate,
    lastupdate_user,
    the_geom,
    workcat_id_plan,
    asset_id,
    expl_id2,
    is_operative,
    minsector_id,
    macrominsector_id,
    adate,
    adescript,
    plot_code,
    placement_type,
    access_type
   FROM connec_selected;


CREATE OR REPLACE VIEW v_edit_gully
AS WITH sel_state AS (
        SELECT selector_state.state_id FROM selector_state WHERE selector_state.cur_user = CURRENT_USER
    ), sel_sector AS (
        SELECT selector_sector.sector_id FROM selector_sector WHERE selector_sector.cur_user = CURRENT_USER
    ), sel_expl AS (
        SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
    ), sel_muni AS (
        SELECT selector_municipality.muni_id FROM selector_municipality WHERE selector_municipality.cur_user = CURRENT_USER
    ), sel_ps AS (
        SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
    ), typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'dma_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.name AS sector_name,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), dma_table AS (
         SELECT dma.dma_id,
            dma.name AS dma_name,
            dma.macrodma_id,
            dma.stylesheet,
            t.id::character varying(16) AS dma_type
           FROM dma
             LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.name AS drainzone_name,
            drainzone.stylesheet,
            t.id::character varying(16) AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
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
            sector_table.sector_name,
            sector_table.macrosector_id,
            l.dma_id,
            dma_table.dma_name,
            dma_table.macrodma_id,
            l.drainzone_id,
            drainzone_table.drainzone_name,
            l.fluid_type,
            sector_table.sector_type,
            drainzone_table.drainzone_type,
            dma_table.dma_type
           FROM link l
             JOIN exploitation USING (expl_id)
             JOIN sector_table ON l.sector_id = sector_table.sector_id
             LEFT JOIN dma_table ON l.dma_id = dma_table.dma_id
             LEFT JOIN drainzone_table ON l.dma_id = drainzone_table.drainzone_id
          WHERE l.state = 2
        ), gully_psector AS (
         SELECT DISTINCT ON (pp.gully_id, pp.state) pp.gully_id,
            pp.state AS p_state,
            pp.psector_id,
            pp.arc_id,
            pp.link_id
           FROM plan_psector_x_gully pp
             JOIN selector_psector sp ON sp.cur_user = CURRENT_USER AND sp.psector_id = pp.psector_id
          ORDER BY pp.gully_id, pp.state, pp.link_id DESC NULLS LAST
        ), gully_selector AS (
            SELECT g.gully_id, g.arc_id, NULL::integer AS link_id
            FROM gully g
            WHERE (g.state IN ( SELECT sel_state.state_id FROM sel_state))
            AND (g.sector_id IN ( SELECT sel_sector.sector_id FROM sel_sector))
            AND ((g.expl_id IN ( SELECT sel_expl.expl_id FROM sel_expl)) OR (g.expl_id2 IN ( SELECT sel_expl.expl_id FROM sel_expl)))
            AND (g.muni_id IN ( SELECT sel_muni.muni_id FROM sel_muni))
            AND NOT (
                EXISTS (
                    SELECT 1
                    FROM gully_psector gp
                    WHERE gp.gully_id::text = g.gully_id::text AND gp.p_state = 0
                )
            )
            UNION ALL
            SELECT gp.gully_id, gp.arc_id, gp.link_id
            FROM gully_psector gp
            WHERE gp.p_state = 1
        ), gully_selected AS (
         SELECT distinct on (gully_id) gully.gully_id,
            gully.code,
            gully.top_elev,
            gully.ymax,
            gully.sandbox,
            gully.matcat_id,
            gully.gully_type,
            cat_feature.system_id AS sys_type,
            gully.gratecat_id,
            cat_grate.matcat_id AS cat_grate_matcat,
            gully.units,
            gully.groove,
            gully.groove_height,
            gully.groove_length,
            gully.siphon,
            gully.connec_arccat_id,
            gully.connec_length,
                CASE
                    WHEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric) IS NOT NULL THEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric)::numeric(12,3)
                    ELSE gully.connec_depth
                END AS connec_depth,
                CASE
                    WHEN gully.connec_matcat_id IS NULL THEN cc.matcat_id::text
                    ELSE gully.connec_matcat_id
                END AS connec_matcat_id,
            gully.top_elev - gully.ymax + gully.sandbox AS connec_y1,
            gully.connec_y2,
            cat_grate.width AS grate_width,
            cat_grate.length AS grate_length,
            gully.arc_id,
            gully.epa_type,
                CASE
                    WHEN gully.sector_id > 0 AND vst.is_operative = true AND gully.epa_type::text = 'GULLY'::character varying(16)::text AND inp_network_mode.value = '2'::text THEN gully.epa_type
                    ELSE NULL::character varying(16)
                END AS inp_type,
            gully.state,
            gully.state_type,
            gully.expl_id,
            exploitation.macroexpl_id,
                CASE
                    WHEN link_planned.sector_id IS NULL THEN sector_table.sector_id
                    ELSE link_planned.sector_id
                END AS sector_id,
                CASE
                    WHEN link_planned.sector_id IS NULL THEN sector_table.sector_type
                    ELSE link_planned.sector_type
                END AS sector_type,
                CASE
                    WHEN link_planned.macrosector_id IS NULL THEN sector_table.macrosector_id
                    ELSE link_planned.macrosector_id
                END AS macrosector_id,
                CASE
                    WHEN link_planned.drainzone_id IS NULL THEN drainzone_table.drainzone_id
                    ELSE link_planned.drainzone_id
                END AS drainzone_id,
                CASE
                    WHEN link_planned.drainzone_type IS NULL THEN drainzone_table.drainzone_type
                    ELSE link_planned.drainzone_type
                END AS drainzone_type,
                CASE
                    WHEN link_planned.dma_id IS NULL THEN dma_table.dma_id
                    ELSE link_planned.dma_id
                END AS dma_id,
                CASE
                    WHEN link_planned.macrodma_id IS NULL THEN dma_table.macrodma_id
                    ELSE link_planned.macrodma_id
                END AS macrodma_id,
            gully.annotation,
            gully.observ,
            gully.comment,
            gully.soilcat_id,
            gully.function_type,
            gully.category_type,
            gully.fluid_type,
            gully.location_type,
            gully.workcat_id,
            gully.workcat_id_end,
            gully.workcat_id_plan,
            gully.buildercat_id,
            gully.builtdate,
            gully.enddate,
            gully.ownercat_id,
            gully.muni_id,
            gully.postcode,
            gully.district_id,
            gully.streetname,
            gully.postnumber,
            gully.postcomplement,
            gully.streetname2,
            gully.postnumber2,
            gully.postcomplement2,
            mu.region_id,
            mu.province_id,
            gully.descript,
            cat_grate.svg,
            gully.rotation,
            concat(cat_feature.link_path, gully.link) AS link,
            gully.verified,
            gully.undelete,
            cat_grate.label,
            gully.label_x,
            gully.label_y,
            gully.label_rotation,
            gully.label_quadrant,
            gully.publish,
            gully.inventory,
            gully.uncertain,
            gully.num_value,
                CASE
                    WHEN link_planned.exit_id IS NULL THEN gully.pjoint_id
                    ELSE link_planned.exit_id
                END AS pjoint_id,
                CASE
                    WHEN link_planned.exit_type IS NULL THEN gully.pjoint_type
                    ELSE link_planned.exit_type
                END AS pjoint_type,
            gully.asset_id,
            gully.gratecat2_id,
            gully.units_placement,
            gully.expl_id2,
            vst.is_operative,
            gully.minsector_id,
            gully.macrominsector_id,
            gully.adate,
            gully.adescript,
            gully.siphon_type,
            gully.odorflap,
            gully.placement_type,
            gully.access_type,
            date_trunc('second'::text, gully.tstamp) AS tstamp,
            gully.insert_user,
            date_trunc('second'::text, gully.lastupdate) AS lastupdate,
            gully.lastupdate_user,
            gully.the_geom
           FROM gully_selector
             JOIN gully USING (gully_id)
             JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
             JOIN exploitation ON gully.expl_id = exploitation.expl_id
             JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
             LEFT JOIN cat_connec cc ON cc.id::text = gully.connec_arccat_id::text
             JOIN value_state_type vst ON vst.id = gully.state_type
             JOIN ext_municipality mu ON gully.muni_id = mu.muni_id
             JOIN sector_table ON gully.sector_id = sector_table.sector_id
             LEFT JOIN dma_table ON gully.dma_id = dma_table.dma_id
             LEFT JOIN drainzone_table ON gully.dma_id = drainzone_table.drainzone_id
             LEFT JOIN link_planned ON gully.gully_id::text = link_planned.feature_id::text
             LEFT JOIN inp_network_mode ON true
        )
 SELECT gully_id,
    code,
    top_elev,
    ymax,
    sandbox,
    matcat_id,
    gully_type,
    sys_type,
    gratecat_id,
    cat_grate_matcat,
    units,
    groove,
    groove_height,
    groove_length,
    siphon,
    connec_arccat_id,
    connec_length,
    connec_depth,
    connec_matcat_id,
    connec_y1,
    connec_y2,
    grate_width,
    grate_length,
    arc_id,
    epa_type,
    inp_type,
    state,
    state_type,
    expl_id,
    macroexpl_id,
    sector_id,
    sector_type,
    macrosector_id,
    drainzone_id,
    drainzone_type,
    dma_id,
    macrodma_id,
    annotation,
    observ,
    comment,
    soilcat_id,
    function_type,
    category_type,
    fluid_type,
    location_type,
    workcat_id,
    workcat_id_end,
    workcat_id_plan,
    buildercat_id,
    builtdate,
    enddate,
    ownercat_id,
    muni_id,
    postcode,
    district_id,
    streetname,
    postnumber,
    postcomplement,
    streetname2,
    postnumber2,
    postcomplement2,
    region_id,
    province_id,
    descript,
    svg,
    rotation,
    link,
    verified,
    undelete,
    label,
    label_x,
    label_y,
    label_rotation,
    label_quadrant,
    publish,
    inventory,
    uncertain,
    num_value,
    pjoint_id,
    pjoint_type,
    asset_id,
    gratecat2_id,
    units_placement,
    expl_id2,
    is_operative,
    minsector_id,
    macrominsector_id,
    adate,
    adescript,
    siphon_type,
    odorflap,
    placement_type,
    access_type,
    tstamp,
    insert_user,
    lastupdate,
    lastupdate_user,
    the_geom
   FROM gully_selected;


CREATE OR REPLACE VIEW v_edit_node
AS WITH sel_state AS (
            SELECT selector_state.state_id FROM selector_state WHERE selector_state.cur_user = CURRENT_USER
        ), sel_sector AS (
            SELECT selector_sector.sector_id FROM selector_sector WHERE selector_sector.cur_user = CURRENT_USER
        ), sel_expl AS (
            SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
        ), sel_muni AS (
            SELECT selector_municipality.muni_id FROM selector_municipality WHERE selector_municipality.cur_user = CURRENT_USER
        ), sel_ps AS (
            SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
        ), typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'dma_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.name AS sector_name,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), dma_table AS (
         SELECT dma.dma_id,
            dma.name AS dma_name,
            dma.macrodma_id,
            dma.stylesheet,
            t.id::character varying(16) AS dma_type
           FROM dma
             LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.name AS drainzone_name,
            drainzone.stylesheet,
            t.id::character varying(16) AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), node_psector AS (
         SELECT pp.node_id,
            pp.state AS p_state
           FROM plan_psector_x_node pp
             JOIN selector_psector sp ON sp.cur_user = CURRENT_USER AND sp.psector_id = pp.psector_id
        ), node_selector AS (
            SELECT n.node_id
            FROM node n
            WHERE (n.state IN ( SELECT sel_state.state_id FROM sel_state))
            AND (n.sector_id IN ( SELECT sel_sector.sector_id FROM sel_sector))
            AND ((n.expl_id IN ( SELECT sel_expl.expl_id FROM sel_expl)) OR (n.expl_id2 IN ( SELECT sel_expl.expl_id FROM sel_expl)))
            AND (n.muni_id IN ( SELECT sel_muni.muni_id FROM sel_muni))
            AND NOT (
                EXISTS (
                    SELECT 1
                    FROM node_psector np
                    WHERE np.node_id::text = n.node_id::text AND np.p_state = 0
                    )
                )
            UNION ALL
            SELECT np.node_id
            FROM node_psector np
            WHERE np.p_state = 1
        ), node_selected AS (
         SELECT distinct on (node_id) node.node_id,
            node.code,
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
            node.node_type,
            cat_feature.system_id AS sys_type,
            node.nodecat_id,
                CASE
                    WHEN node.matcat_id IS NULL THEN cat_node.matcat_id
                    ELSE node.matcat_id
                END AS matcat_id,
            node.epa_type,
            node.state,
            node.state_type,
            node.expl_id,
            exploitation.macroexpl_id,
            node.sector_id,
            sector_table.sector_type,
            sector_table.macrosector_id,
            node.drainzone_id,
            drainzone_table.drainzone_type,
            node.annotation,
            node.observ,
            node.comment,
            node.dma_id,
            dma_table.macrodma_id,
            node.soilcat_id,
            node.function_type,
            node.category_type,
            node.fluid_type,
            node.location_type,
            node.workcat_id,
            node.workcat_id_end,
            node.buildercat_id,
            node.builtdate,
            node.enddate,
            node.ownercat_id,
            node.muni_id,
            node.postcode,
            node.district_id,
            node.streetname,
            node.postnumber,
            node.postcomplement,
            node.streetname2,
            node.postnumber2,
            node.postcomplement2,
            mu.region_id,
            mu.province_id,
            node.descript,
            cat_node.svg,
            node.rotation,
            concat(cat_feature.link_path, node.link) AS link,
            node.verified,
            node.the_geom,
            node.undelete,
            cat_node.label,
            node.label_x,
            node.label_y,
            node.label_rotation,
            node.label_quadrant,
            node.publish,
            node.inventory,
            node.uncertain,
            node.xyz_date,
            node.unconnected,
            node.num_value,
            date_trunc('second'::text, node.tstamp) AS tstamp,
            node.insert_user,
            date_trunc('second'::text, node.lastupdate) AS lastupdate,
            node.lastupdate_user,
            node.workcat_id_plan,
            node.asset_id,
            node.parent_id,
            node.arc_id,
            node.expl_id2,
            vst.is_operative,
            node.minsector_id,
            node.macrominsector_id,
            node.adate,
            node.adescript,
            node.placement_type,
            node.access_type,
                CASE
                    WHEN node.sector_id > 0 AND vst.is_operative = true AND node.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN node.epa_type
                    ELSE NULL::character varying(16)
                END AS inp_type,
            node.brand_id,
            node.model_id,
            node.serial_number,
            node.hemisphere
           FROM node_selector
             JOIN node USING (node_id)
             JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
             JOIN cat_feature ON cat_feature.id::text = node.node_type::text
             JOIN exploitation ON node.expl_id = exploitation.expl_id
             JOIN ext_municipality mu ON node.muni_id = mu.muni_id
             JOIN value_state_type vst ON vst.id = node.state_type
             JOIN sector_table ON sector_table.sector_id = node.sector_id
             LEFT JOIN dma_table ON dma_table.dma_id = node.dma_id
             LEFT JOIN drainzone_table ON node.dma_id = drainzone_table.drainzone_id
        ), node_base AS (
         SELECT node_selected.node_id,
            node_selected.code,
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
            node_selected.nodecat_id,
            node_selected.matcat_id,
            node_selected.epa_type,
            node_selected.state,
            node_selected.state_type,
            node_selected.expl_id,
            node_selected.macroexpl_id,
            node_selected.sector_id,
            node_selected.sector_type,
            node_selected.macrosector_id,
            node_selected.drainzone_id,
            node_selected.drainzone_type,
            node_selected.annotation,
            node_selected.observ,
            node_selected.comment,
            node_selected.dma_id,
            node_selected.macrodma_id,
            node_selected.soilcat_id,
            node_selected.function_type,
            node_selected.category_type,
            node_selected.fluid_type,
            node_selected.location_type,
            node_selected.workcat_id,
            node_selected.workcat_id_end,
            node_selected.buildercat_id,
            node_selected.builtdate,
            node_selected.enddate,
            node_selected.ownercat_id,
            node_selected.muni_id,
            node_selected.postcode,
            node_selected.district_id,
            node_selected.streetname,
            node_selected.postnumber,
            node_selected.postcomplement,
            node_selected.streetname2,
            node_selected.postnumber2,
            node_selected.postcomplement2,
            node_selected.region_id,
            node_selected.province_id,
            node_selected.descript,
            node_selected.svg,
            node_selected.rotation,
            node_selected.link,
            node_selected.verified,
            node_selected.the_geom,
            node_selected.undelete,
            node_selected.label,
            node_selected.label_x,
            node_selected.label_y,
            node_selected.label_rotation,
            node_selected.label_quadrant,
            node_selected.publish,
            node_selected.inventory,
            node_selected.uncertain,
            node_selected.xyz_date,
            node_selected.unconnected,
            node_selected.num_value,
            node_selected.tstamp,
            node_selected.insert_user,
            node_selected.lastupdate,
            node_selected.lastupdate_user,
            node_selected.workcat_id_plan,
            node_selected.asset_id,
            node_selected.parent_id,
            node_selected.arc_id,
            node_selected.expl_id2,
            node_selected.is_operative,
            node_selected.minsector_id,
            node_selected.macrominsector_id,
            node_selected.adate,
            node_selected.adescript,
            node_selected.placement_type,
            node_selected.access_type,
            node_selected.inp_type,
            node_selected.brand_id,
            node_selected.model_id,
            node_selected.serial_number,
            node_selected.hemisphere
           FROM node_selected
        )
 SELECT node_id,
    code,
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
    nodecat_id,
    matcat_id,
    epa_type,
    state,
    state_type,
    expl_id,
    macroexpl_id,
    sector_id,
    sector_type,
    macrosector_id,
    drainzone_id,
    drainzone_type,
    annotation,
    observ,
    comment,
    dma_id,
    macrodma_id,
    soilcat_id,
    function_type,
    category_type,
    fluid_type,
    location_type,
    workcat_id,
    workcat_id_end,
    buildercat_id,
    builtdate,
    enddate,
    ownercat_id,
    muni_id,
    postcode,
    district_id,
    streetname,
    postnumber,
    postcomplement,
    streetname2,
    postnumber2,
    postcomplement2,
    region_id,
    province_id,
    descript,
    svg,
    rotation,
    link,
    verified,
    the_geom,
    undelete,
    label,
    label_x,
    label_y,
    label_rotation,
    label_quadrant,
    publish,
    inventory,
    uncertain,
    xyz_date,
    unconnected,
    num_value,
    tstamp,
    insert_user,
    lastupdate,
    lastupdate_user,
    workcat_id_plan,
    asset_id,
    parent_id,
    arc_id,
    expl_id2,
    is_operative,
    minsector_id,
    macrominsector_id,
    adate,
    adescript,
    placement_type,
    access_type,
    inp_type,
    brand_id,
    model_id,
    serial_number,
    hemisphere
   FROM node_base;

CREATE OR REPLACE VIEW v_edit_link AS
WITH sel_state AS (
        SELECT selector_state.state_id FROM selector_state WHERE selector_state.cur_user = CURRENT_USER
    ), sel_sector AS (
        SELECT selector_sector.sector_id FROM selector_sector WHERE selector_sector.cur_user = CURRENT_USER
    ), sel_expl AS (
        SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
    ), sel_muni AS (
        SELECT selector_municipality.muni_id FROM selector_municipality WHERE selector_municipality.cur_user = CURRENT_USER
    ), sel_ps AS (
        SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
    ), typevalue AS
  (
    SELECT edit_typevalue.typevalue, edit_typevalue.id,  edit_typevalue.idval
    FROM edit_typevalue
    WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'dma_type'::character varying::text, 'dwfzone_type'::character varying::text])
  ), sector_table AS
  (
    SELECT sector_id, name as sector_name, macrosector_id, stylesheet, id::varchar(16) as sector_type
    FROM sector
    LEFT JOIN typevalue t ON t.id::text = sector.sector_type AND t.typevalue::text = 'sector_type'::text
  ), dma_table AS
  (
    SELECT dma_id, name as dma_name, macrodma_id, stylesheet, id::varchar(16) as dma_type
    FROM dma
    LEFT JOIN typevalue t ON t.id::text = dma.dma_type AND t.typevalue::text = 'dma_type'::text
  ), drainzone_table AS
  (
    SELECT drainzone_id, name as drainzone_name, stylesheet, id::varchar(16) as drainzone_type
    FROM drainzone
    LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type AND t.typevalue::text = 'drainzone_type'::text
  ), inp_network_mode AS
  (
    SELECT value
    FROM config_param_user
    WHERE parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
  ), link_psector AS
  (
    (
      SELECT DISTINCT ON (pp.connec_id, pp.state) 'CONNEC' AS feature_type, pp.connec_id AS feature_id, pp.state AS p_state, pp.psector_id, pp.link_id
      FROM plan_psector_x_connec pp
      JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
      ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
    )
		UNION ALL
    (
      SELECT DISTINCT ON (pp.gully_id, pp.state) 'GULLY' AS feature_type, pp.gully_id AS feature_id, pp.state AS p_state, pp.psector_id, pp.link_id
      FROM plan_psector_x_gully pp
      JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
      ORDER BY pp.gully_id, pp.state, pp.link_id DESC NULLS LAST
    )
  ), link_selector AS
  (
    SELECT l.link_id
    FROM link l
    WHERE (l.state IN ( SELECT sel_state.state_id FROM sel_state))
    AND (l.sector_id IN ( SELECT sel_sector.sector_id FROM sel_sector))
    AND ((l.expl_id IN ( SELECT sel_expl.expl_id FROM sel_expl)) OR (l.expl_id2 IN ( SELECT sel_expl.expl_id FROM sel_expl)))
    AND (l.muni_id IN ( SELECT sel_muni.muni_id FROM sel_muni))
    AND NOT (
        EXISTS (
            SELECT 1
            FROM link_psector lp
            WHERE lp.link_id::text = l.link_id::text AND lp.p_state = 0
            )
        )
    UNION ALL
    SELECT lp.link_id
    FROM link_psector lp
    WHERE lp.p_state = 1
  ), link_selected AS
  (
    SELECT DISTINCT ON (l.link_id) l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    macroexpl_id,
    l.sector_id,
    sector_type,
    macrosector_id,
    l.muni_id,
    l.drainzone_id,
    drainzone_type,
    l.dma_id,
    macrodma_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
    sector_name,
    dma_name,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.connecat_id,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate,
    date_trunc('second'::text, l.lastupdate) AS lastupdate,
    l.lastupdate_user,
    l.uncertain
    FROM link_selector
    JOIN link l USING (link_id)
    JOIN exploitation ON l.expl_id = exploitation.expl_id
    JOIN ext_municipality mu ON l.muni_id = mu.muni_id
    JOIN sector_table ON l.sector_id = sector_table.sector_id
    LEFT JOIN dma_table ON l.dma_id = dma_table.dma_id
    LEFT JOIN drainzone_table ON l.dma_id = drainzone_table.drainzone_id
    LEFT JOIN inp_network_mode ON true
  )
  SELECT link_selected.*
  FROM link_selected;

DROP VIEW IF EXISTS v_edit_link_connec;
CREATE OR REPLACE VIEW v_edit_link_connec AS SELECT * FROM v_edit_link WHERE feature_type = 'CONNEC';

DROP VIEW IF EXISTS v_edit_link_gully;
CREATE OR REPLACE VIEW v_edit_link_gully AS SELECT * FROM v_edit_link WHERE feature_type = 'GULLY';
