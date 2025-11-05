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


-- recreate views
CREATE OR REPLACE VIEW v_ui_workcat_x_feature
AS SELECT row_number() OVER (ORDER BY arc.arc_id) + 1000000 AS rid,
    arc.feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    exploitation.name AS expl_name,
    arc.workcat_id,
    exploitation.expl_id
   FROM arc
     JOIN exploitation ON exploitation.expl_id = arc.expl_id
  WHERE arc.state = 1
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    exploitation.name AS expl_name,
    node.workcat_id,
    exploitation.expl_id
   FROM node
     JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE node.state = 1
UNION
 SELECT row_number() OVER (ORDER BY connec.connec_id) + 3000000 AS rid,
    connec.feature_type,
    connec.conneccat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    exploitation.name AS expl_name,
    connec.workcat_id,
    exploitation.expl_id
   FROM connec
     JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE connec.state = 1
UNION
 SELECT row_number() OVER (ORDER BY gully.gully_id) + 4000000 AS rid,
    gully.feature_type,
    gully.gullycat_id AS featurecat_id,
    gully.gully_id AS feature_id,
    gully.code,
    exploitation.name AS expl_name,
    gully.workcat_id,
    exploitation.expl_id
   FROM gully
     JOIN exploitation ON exploitation.expl_id = gully.expl_id
  WHERE gully.state = 1
UNION
 SELECT row_number() OVER (ORDER BY element.element_id) + 5000000 AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id,
    exploitation.expl_id
   FROM element
     JOIN exploitation ON exploitation.expl_id = element.expl_id
  WHERE element.state = 1;


CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end
AS SELECT row_number() OVER (ORDER BY ve_arc.arc_id) + 1000000 AS rid,
    'ARC'::character varying AS feature_type,
    ve_arc.arccat_id AS featurecat_id,
    ve_arc.arc_id AS feature_id,
    ve_arc.code,
    exploitation.name AS expl_name,
    ve_arc.workcat_id_end AS workcat_id,
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
    ve_node.workcat_id_end AS workcat_id,
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
    ve_connec.workcat_id_end AS workcat_id,
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
    element.workcat_id_end AS workcat_id,
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
    ve_gully.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM ve_gully
     JOIN exploitation ON exploitation.expl_id = ve_gully.expl_id
  WHERE ve_gully.state = 0;


CREATE OR REPLACE VIEW v_rtc_hydrometer_x_connec
AS WITH sel_hydrometer AS (
    SELECT state_id
    FROM selector_hydrometer
    WHERE cur_user = CURRENT_USER
), sel_expl AS (
    SELECT expl_id
    FROM selector_expl
    WHERE cur_user = CURRENT_USER
)
SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN connec.connec_id IS NULL THEN NULL::integer
            ELSE connec.connec_id
        END AS connec_id,
        CASE
            WHEN ext_rtc_hydrometer.connec_id IS NULL THEN 'XXXX'::text::character varying
            ELSE ext_rtc_hydrometer.connec_id
        END AS connec_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
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
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link
FROM rtc_hydrometer
LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id::text
LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
WHERE EXISTS (
    SELECT 1
    FROM sel_hydrometer
    WHERE sel_hydrometer.state_id = ext_rtc_hydrometer.state_id
)
AND EXISTS (
    SELECT 1
    FROM sel_expl
    WHERE sel_expl.expl_id = connec.expl_id
);

CREATE OR REPLACE VIEW v_ui_hydrometer
AS SELECT hydrometer_id,
    connec_id AS feature_id,
    hydrometer_customer_code,
    connec_customer_code AS feature_customer_code,
    state,
    expl_name,
    hydrometer_link
   FROM v_rtc_hydrometer_x_connec;


CREATE OR REPLACE VIEW v_rtc_hydrometer
AS WITH sel_hydrometer AS (
    SELECT state_id
    FROM selector_hydrometer
    WHERE cur_user = CURRENT_USER
), sel_expl AS (
    SELECT expl_id
    FROM selector_expl
    WHERE cur_user = CURRENT_USER
)
SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN connec.connec_id IS NULL THEN NULL::integer
            ELSE connec.connec_id
        END AS feature_id,
    'CONNEC'::text AS feature_type,
        CASE
            WHEN ext_rtc_hydrometer.connec_id IS NULL THEN 'XXXX'::text::character varying
            ELSE ext_rtc_hydrometer.connec_id
        END AS customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
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
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
FROM rtc_hydrometer
LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id::text
LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
WHERE EXISTS (
    SELECT 1
    FROM sel_hydrometer
    WHERE sel_hydrometer.state_id = ext_rtc_hydrometer.state_id
)
AND EXISTS (
    SELECT 1
    FROM sel_expl
    WHERE sel_expl.expl_id = connec.expl_id
);

CREATE OR REPLACE VIEW v_ui_sector
AS WITH sel_sector AS (
    SELECT sector_id
    FROM selector_sector
    WHERE cur_user = CURRENT_USER
)
SELECT s.sector_id,
    s.code,
    s.name,
    s.descript,
    s.active,
    et.idval AS sector_type,
    ms.name AS macrosector,
    s.expl_id,
    s.muni_id,
    s.graphconfig::text AS graphconfig,
    s.stylesheet::text AS stylesheet,
    s.lock_level,
    s.link,
    s.addparam::text AS addparam,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
FROM sector s
LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
LEFT JOIN edit_typevalue et ON et.id::text = s.sector_type::text AND et.typevalue::text = 'sector_type'::text
WHERE EXISTS (
    SELECT 1
    FROM sel_sector
    WHERE sel_sector.sector_id = s.sector_id
)
AND s.sector_id > 0
ORDER BY s.sector_id;


CREATE OR REPLACE VIEW ve_sector
AS WITH sel_sector AS (
    SELECT sector_id
    FROM selector_sector
    WHERE cur_user = CURRENT_USER
)
SELECT s.sector_id,
    s.code,
    s.name,
    s.descript,
    s.active,
    s.sector_type,
    s.macrosector_id,
    s.expl_id,
    s.muni_id,
    s.graphconfig::text AS graphconfig,
    s.stylesheet::text AS stylesheet,
    s.lock_level,
    s.link,
    s.the_geom,
    s.addparam::text AS addparam,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
FROM sector s
WHERE EXISTS (
    SELECT 1
    FROM sel_sector
    WHERE sel_sector.sector_id = s.sector_id
)
AND s.sector_id > 0
ORDER BY s.sector_id;

CREATE OR REPLACE VIEW v_ui_omzone
AS WITH sel_expl AS (
    SELECT expl_id
    FROM selector_expl
    WHERE cur_user = CURRENT_USER
)
SELECT DISTINCT ON (o.omzone_id) o.omzone_id,
    o.code,
    o.name,
    o.descript,
    o.active,
    et.idval AS omzone_type,
    o.macroomzone_id,
    o.expl_id,
    o.sector_id,
    o.muni_id,
    o.graphconfig,
    o.stylesheet,
    o.lock_level,
    o.link,
    o.addparam,
    o.created_at,
    o.created_by,
    o.updated_at,
    o.updated_by
FROM omzone o
LEFT JOIN edit_typevalue et ON et.id::text = o.omzone_type::text AND et.typevalue::text = 'omzone_type'::text
WHERE EXISTS (
    SELECT 1
    FROM sel_expl
    WHERE sel_expl.expl_id = ANY(o.expl_id)
)
AND o.omzone_id > 0
ORDER BY o.omzone_id;

CREATE OR REPLACE VIEW ve_omzone
AS WITH sel_expl AS (
    SELECT expl_id
    FROM selector_expl
    WHERE cur_user = CURRENT_USER
)
SELECT DISTINCT ON (o.omzone_id) o.omzone_id,
    o.code,
    o.name,
    o.descript,
    o.active,
    et.idval AS omzone_type,
    o.macroomzone_id,
    o.expl_id,
    o.sector_id,
    o.muni_id,
    o.graphconfig,
    o.stylesheet,
    o.lock_level,
    o.link,
    o.the_geom,
    o.addparam,
    o.created_at,
    o.created_by,
    o.updated_at,
    o.updated_by
FROM omzone o
LEFT JOIN edit_typevalue et ON et.id::text = o.omzone_type::text AND et.typevalue::text = 'omzone_type'::text
WHERE EXISTS (
    SELECT 1
    FROM sel_expl
    WHERE sel_expl.expl_id = ANY(o.expl_id)
)
AND o.omzone_id > 0
ORDER BY o.omzone_id;

CREATE OR REPLACE VIEW v_ui_dma
AS WITH sel_expl AS (
    SELECT expl_id
    FROM selector_expl
    WHERE cur_user = CURRENT_USER
)
SELECT d.dma_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS dma_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text AS graphconfig,
    d.stylesheet,
    d.lock_level,
    d.link,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
FROM dma d
LEFT JOIN edit_typevalue et ON et.id::text = d.dma_type::text AND et.typevalue::text = 'dma_type'::text
WHERE EXISTS (
    SELECT 1
    FROM sel_expl
    WHERE sel_expl.expl_id = ANY(d.expl_id)
)
AND d.dma_id > 0;

CREATE OR REPLACE VIEW ve_dma
AS WITH sel_expl AS (
    SELECT expl_id
    FROM selector_expl
    WHERE cur_user = CURRENT_USER
)
SELECT d.dma_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.dma_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text AS graphconfig,
    d.stylesheet,
    d.lock_level,
    d.link,
    d.the_geom,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
FROM dma d
WHERE EXISTS (
    SELECT 1
    FROM sel_expl
    WHERE sel_expl.expl_id = ANY(d.expl_id)
)
AND d.dma_id > 0;

CREATE OR REPLACE VIEW v_ui_dwfzone
AS WITH sel_expl AS (
    SELECT expl_id
    FROM selector_expl
    WHERE cur_user = CURRENT_USER
)
SELECT DISTINCT ON (d.dwfzone_id) d.dwfzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS dwfzone_type,
    da.name AS drainzone,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.lock_level,
    d.link,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
FROM dwfzone d
LEFT JOIN edit_typevalue et ON et.id::text = d.dwfzone_type::text AND et.typevalue::text = 'dwfzone_type'::text
LEFT JOIN drainzone da ON d.drainzone_id = da.drainzone_id
WHERE EXISTS (
    SELECT 1
    FROM sel_expl
    WHERE sel_expl.expl_id = ANY(d.expl_id)
)
AND d.dwfzone_id > 0
ORDER BY d.dwfzone_id;

CREATE OR REPLACE VIEW ve_dwfzone
AS WITH sel_expl AS (
    SELECT expl_id
    FROM selector_expl
    WHERE cur_user = CURRENT_USER
)
SELECT DISTINCT ON (d.dwfzone_id) d.dwfzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.dwfzone_type,
    d.drainzone_id,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.lock_level,
    d.link,
    d.the_geom,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
FROM dwfzone d
WHERE EXISTS (
    SELECT 1
    FROM sel_expl
    WHERE sel_expl.expl_id = ANY(d.expl_id)
)
AND d.dwfzone_id > 0
ORDER BY d.dwfzone_id;

CREATE OR REPLACE VIEW v_ui_drainzone
AS SELECT DISTINCT ON (d.drainzone_id) d.drainzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS drainzone_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.lock_level,
    d.link,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
FROM drainzone d
LEFT JOIN edit_typevalue et ON et.id::text = d.drainzone_type::text AND et.typevalue::text = 'drainzone_type'::text
WHERE d.drainzone_id > 0
ORDER BY d.drainzone_id;

CREATE OR REPLACE VIEW ve_drainzone
AS SELECT DISTINCT ON (drainzone_id) drainzone_id,
    code,
    name,
    descript,
    active,
    drainzone_type,
    expl_id,
    sector_id,
    muni_id,
    graphconfig::text AS graphconfig,
    stylesheet::text AS stylesheet,
    lock_level,
    link,
    addparam::text AS addparam,
    created_at,
    created_by,
    updated_at,
    updated_by,
    the_geom
FROM drainzone d
WHERE drainzone_id > 0
ORDER BY drainzone_id;
