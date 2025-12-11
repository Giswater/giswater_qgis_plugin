/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW ve_link
AS WITH typevalue AS (
    SELECT 
        edit_typevalue.typevalue,
        edit_typevalue.id,
        edit_typevalue.idval
    FROM edit_typevalue
    WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
), sector_table AS (
    SELECT 
        sector.sector_id,
        sector.macrosector_id,
        sector.stylesheet,
        t.id::character varying(16) AS sector_type
    FROM sector
    LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
), omzone_table AS (
    SELECT 
        omzone.omzone_id,
        omzone.macroomzone_id,
        omzone.stylesheet,
        t.id::character varying(16) AS omzone_type
    FROM omzone
    LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
), drainzone_table AS (
    SELECT 
        drainzone.drainzone_id,
        drainzone.stylesheet,
        t.id::character varying(16) AS drainzone_type
    FROM drainzone
    LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
), dwfzone_table AS (
    SELECT 
        dwfzone.dwfzone_id,
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
    COALESCE(pp.state, l.state) AS p_state,
    l.uuid,
    l.omunit_id
FROM link l
LEFT JOIN LATERAL (
    SELECT p.state
    FROM (
        SELECT pc.state
        FROM plan_psector_x_connec pc
        WHERE pc.link_id = l.link_id
        AND pc.psector_id IN (
            SELECT sp.psector_id
            FROM selector_psector sp
            WHERE sp.cur_user = CURRENT_USER
        )
        UNION ALL
        SELECT pg.state
        FROM plan_psector_x_gully pg
        WHERE pg.link_id = l.link_id
        AND pg.psector_id IN (
            SELECT sp.psector_id
            FROM selector_psector sp
            WHERE sp.cur_user = CURRENT_USER
        )
    ) p
    ORDER BY p.state DESC
    LIMIT 1
) pp ON TRUE
JOIN selector_state ss ON ss.state_id = COALESCE(pp.state, l.state) AND ss.cur_user = CURRENT_USER
JOIN selector_sector ssec ON ssec.sector_id = l.sector_id AND ssec.cur_user = CURRENT_USER
JOIN selector_municipality sm  ON sm.muni_id = l.muni_id AND sm.cur_user = CURRENT_USER
JOIN selector_expl se ON se.expl_id = ANY (array_append(l.expl_visibility::integer[], l.expl_id)) AND se.cur_user = CURRENT_USER
JOIN exploitation ON l.expl_id = exploitation.expl_id
JOIN ext_municipality mu ON l.muni_id = mu.muni_id
JOIN sector_table ON l.sector_id = sector_table.sector_id
JOIN cat_link ON cat_link.id::text = l.linkcat_id::text
JOIN cat_feature ON cat_feature.id::text = l.link_type::text
LEFT JOIN omzone_table ON l.omzone_id = omzone_table.omzone_id
LEFT JOIN drainzone_table ON l.omzone_id = drainzone_table.drainzone_id
LEFT JOIN dwfzone_table ON l.dwfzone_id = dwfzone_table.dwfzone_id
LEFT JOIN inp_network_mode ON true;


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


CREATE OR REPLACE VIEW v_rtc_hydrometer_x_connec
AS WITH sel_expl AS (
    SELECT expl_id
    FROM selector_expl
    WHERE cur_user = CURRENT_USER
)
SELECT ext_rtc_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    COALESCE(connec.connec_id, NULL::integer) AS connec_id,
    COALESCE(connec.customer_code, 'XXXX'::text::character varying) AS connec_customer_code,
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
            WHEN ((SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN ext_rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), ext_rtc_hydrometer.link)
        END AS hydrometer_link
FROM ext_rtc_hydrometer
JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id = ext_rtc_hydrometer.hydrometer_id
JOIN connec ON connec.connec_id = rtc_hydrometer_x_connec.connec_id
LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
WHERE EXISTS (
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
AS WITH sel_expl AS (
    SELECT expl_id
    FROM selector_expl
    WHERE cur_user = CURRENT_USER
)
SELECT ext_rtc_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    connec.connec_id AS feature_id,
    'CONNEC'::text AS feature_type,
    COALESCE(connec.customer_code, 'XXXX'::text::character varying) AS customer_code,
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
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text)) IS NULL THEN ext_rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'edit_hydro_link_absolute_path'::text), ext_rtc_hydrometer.link)
        END AS hydrometer_link,
    ext_rtc_hydrometer_state.is_operative,
    ext_rtc_hydrometer.shutdown_date
FROM ext_rtc_hydrometer
JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id = ext_rtc_hydrometer.hydrometer_id
JOIN connec ON connec.connec_id = rtc_hydrometer_x_connec.connec_id
LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
WHERE EXISTS (
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


CREATE OR REPLACE VIEW ve_node
AS WITH typevalue AS (
    SELECT 
        edit_typevalue.typevalue,
        edit_typevalue.id,
        edit_typevalue.idval
    FROM edit_typevalue
    WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
), sector_table AS (
    SELECT 
        sector.sector_id,
        sector.macrosector_id,
        sector.stylesheet,
        t.id::character varying(16) AS sector_type
    FROM sector
    LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
), omzone_table AS (
    SELECT 
        omzone.omzone_id,
        omzone.macroomzone_id,
        omzone.stylesheet,
        t.id::character varying(16) AS omzone_type
    FROM omzone
    LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
), drainzone_table AS (
    SELECT 
        drainzone.drainzone_id,
        drainzone.stylesheet,
        t.id::character varying(16) AS drainzone_type
    FROM drainzone
    LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
), dwfzone_table AS (
    SELECT 
        dwfzone.dwfzone_id,
        dwfzone.stylesheet,
        t.id::character varying(16) AS dwfzone_type,
        dwfzone.drainzone_id
    FROM dwfzone
    LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
)
SELECT 
    n.node_id,
    n.code,
    n.sys_code,
    n.top_elev,
    n.custom_top_elev,
    COALESCE(n.custom_top_elev, n.top_elev) AS sys_top_elev,
    n.ymax,
    CASE
        WHEN (n.custom_top_elev IS NOT NULL OR n.custom_elev IS NOT NULL)
        AND COALESCE(n.custom_top_elev, n.top_elev) IS NOT NULL
        AND COALESCE(n.custom_elev, n.elev) IS NOT NULL THEN
            (COALESCE(n.custom_top_elev, n.top_elev) - COALESCE(n.custom_elev, n.elev))
        ELSE
            n.ymax
    END AS sys_ymax,
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
    mu.region_id,
    mu.province_id,
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
    COALESCE(pp.state, n.state) AS p_state,
    n.uuid,
    n.treatment_type
FROM node n
LEFT JOIN LATERAL (
    SELECT pp.state
    FROM plan_psector_x_node pp
    WHERE pp.node_id = n.node_id
    AND pp.psector_id IN (
        SELECT sp.psector_id
        FROM selector_psector sp
        WHERE sp.cur_user = CURRENT_USER
    )
    ORDER BY pp.state DESC
    LIMIT 1
) pp ON TRUE
JOIN selector_state ss ON ss.state_id = COALESCE(pp.state, n.state) AND ss.cur_user = CURRENT_USER
JOIN selector_sector ssec ON ssec.sector_id = n.sector_id AND ssec.cur_user = CURRENT_USER
JOIN selector_municipality sm ON sm.muni_id = n.muni_id AND sm.cur_user = CURRENT_USER
JOIN selector_expl se ON se.expl_id = ANY (array_append(n.expl_visibility, n.expl_id)) AND se.cur_user = CURRENT_USER
JOIN cat_node ON n.nodecat_id::text = cat_node.id::text
JOIN cat_feature ON cat_feature.id::text = n.node_type::text
JOIN exploitation ON n.expl_id = exploitation.expl_id
JOIN ext_municipality mu ON n.muni_id = mu.muni_id
JOIN value_state_type vst ON vst.id = n.state_type
JOIN sector_table ON sector_table.sector_id = n.sector_id
LEFT JOIN omzone_table ON omzone_table.omzone_id = n.omzone_id
LEFT JOIN drainzone_table ON n.omzone_id = drainzone_table.drainzone_id
LEFT JOIN dwfzone_table ON n.dwfzone_id = dwfzone_table.dwfzone_id
LEFT JOIN node_add ON node_add.node_id = n.node_id;


CREATE OR REPLACE VIEW v_edit_node
AS WITH typevalue AS (
    SELECT 
        edit_typevalue.typevalue,
        edit_typevalue.id,
        edit_typevalue.idval
    FROM edit_typevalue
    WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
), sector_table AS (
    SELECT 
        sector.sector_id,
        sector.macrosector_id,
        sector.stylesheet,
        t.id::character varying(16) AS sector_type
    FROM sector
    LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
), omzone_table AS (
    SELECT 
        omzone.omzone_id,
        omzone.macroomzone_id,
        omzone.stylesheet,
        t.id::character varying(16) AS omzone_type
    FROM omzone
    LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
), drainzone_table AS (
    SELECT 
        drainzone.drainzone_id,
        drainzone.stylesheet,
        t.id::character varying(16) AS drainzone_type
    FROM drainzone
    LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
), dwfzone_table AS (
    SELECT 
        dwfzone.dwfzone_id,
        dwfzone.stylesheet,
        t.id::character varying(16) AS dwfzone_type,
        dwfzone.drainzone_id
    FROM dwfzone
    LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
)
SELECT 
    node.node_id,
    node.code,
    node.sys_code,
    node.top_elev,
    node.custom_top_elev,
    COALESCE(node.custom_top_elev, node.top_elev) AS sys_top_elev,
    node.ymax,
    CASE
        WHEN (node.custom_top_elev IS NOT NULL OR node.custom_elev IS NOT NULL)
        AND COALESCE(node.custom_top_elev, node.top_elev) IS NOT NULL
        AND COALESCE(node.custom_elev, node.elev) IS NOT NULL THEN
            (COALESCE(node.custom_top_elev, node.top_elev) - COALESCE(node.custom_elev, node.elev))
        ELSE
            node.ymax
    END AS sys_ymax,
    node.elev,
    node.custom_elev,
    COALESCE(node.custom_elev, node.elev) AS sys_elev,
    cat_feature.feature_class AS sys_type,
    node.node_type::text AS node_type,
    COALESCE(node.matcat_id, cat_node.matcat_id) AS matcat_id,
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
    COALESCE(pp.state, node.state) AS p_state,
    node.uuid,
    node.treatment_type
FROM node
LEFT JOIN LATERAL (
    SELECT pp.state
    FROM plan_psector_x_node pp
    WHERE pp.node_id = node.node_id
    AND pp.psector_id IN (
        SELECT sp.psector_id
        FROM selector_psector sp
        WHERE sp.cur_user = CURRENT_USER
    )
    ORDER BY pp.state DESC
    LIMIT 1
) pp ON TRUE
JOIN selector_state ss ON ss.state_id = COALESCE(pp.state, node.state) AND ss.cur_user = CURRENT_USER
JOIN selector_sector ssec ON ssec.sector_id = node.sector_id AND ssec.cur_user = CURRENT_USER
JOIN selector_municipality sm ON sm.muni_id = node.muni_id AND sm.cur_user = CURRENT_USER
JOIN selector_expl se ON se.expl_id = ANY (array_append(node.expl_visibility, node.expl_id)) AND se.cur_user = CURRENT_USER
JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
JOIN cat_feature ON cat_feature.id::text = node.node_type::text
JOIN exploitation ON node.expl_id = exploitation.expl_id
JOIN ext_municipality mu ON node.muni_id = mu.muni_id
JOIN value_state_type vst ON vst.id = node.state_type
JOIN sector_table ON sector_table.sector_id = node.sector_id
LEFT JOIN omzone_table ON omzone_table.omzone_id = node.omzone_id
LEFT JOIN drainzone_table ON node.omzone_id = drainzone_table.drainzone_id
LEFT JOIN dwfzone_table ON node.dwfzone_id = dwfzone_table.dwfzone_id
LEFT JOIN node_add ON node_add.node_id = node.node_id;
;

CREATE OR REPLACE VIEW ve_arc
AS WITH typevalue AS (
    SELECT 
        edit_typevalue.typevalue,
        edit_typevalue.id,
        edit_typevalue.idval
    FROM edit_typevalue
    WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
), sector_table AS (
    SELECT 
        sector.sector_id,
        sector.macrosector_id,
        sector.stylesheet,
        t.id::character varying(16) AS sector_type
    FROM sector
    LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
), omzone_table AS (
    SELECT 
        omzone.omzone_id,
        omzone.macroomzone_id,
        omzone.stylesheet,
        t.id::character varying(16) AS omzone_type
    FROM omzone
    LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
), drainzone_table AS (
    SELECT 
        drainzone.drainzone_id,
        drainzone.stylesheet,
        t.id::character varying(16) AS drainzone_type
    FROM drainzone
    LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
), dwfzone_table AS (
    SELECT 
        dwfzone.dwfzone_id,
        dwfzone.stylesheet,
        t.id::character varying(16) AS dwfzone_type,
        dwfzone.drainzone_id
    FROM dwfzone
    LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
), arc_selected AS (
    SELECT 
        arc.arc_id,
        arc.code,
        arc.sys_code,
        arc.node_1,
        arc.nodetype_1,
        arc.node_top_elev_1,
        arc.node_custom_top_elev_1,
        COALESCE(arc.node_custom_top_elev_1, arc.node_top_elev_1) AS node_sys_top_elev_1,
        arc.node_elev_1,
        arc.node_custom_elev_1,
        COALESCE(arc.node_custom_elev_1, arc.node_elev_1) AS node_sys_elev_1,
        arc.elev1,
        arc.custom_elev1,
        COALESCE(arc.custom_elev1, arc.elev1) AS sys_elev1,
        arc.y1,
        arc.node_2,
        arc.nodetype_2,
        arc.node_top_elev_2,
        arc.node_custom_top_elev_2,
        COALESCE(arc.node_custom_top_elev_2, arc.node_top_elev_2) AS node_sys_top_elev_2,
        arc.node_elev_2,
        arc.node_custom_elev_2,
        COALESCE(arc.node_custom_elev_2, arc.node_elev_2) AS node_sys_elev_2,
        arc.elev2,
        arc.custom_elev2,
        COALESCE(arc.custom_elev2, arc.elev2) AS sys_elev2,
        arc.y2,
        cat_feature.feature_class AS sys_type,
        arc.arc_type::text AS arc_type,
        arc.arccat_id,
        COALESCE(arc.matcat_id, cat_arc.matcat_id) AS matcat_id,
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
        COALESCE(pp.state, arc.state) AS p_state,
        arc.uuid,
        arc.treatment_type
    FROM arc
    LEFT JOIN LATERAL (
        SELECT pp.state
        FROM plan_psector_x_arc pp
        WHERE pp.arc_id = arc.arc_id
            AND pp.psector_id IN (
                SELECT sp.psector_id
                FROM selector_psector sp
                WHERE sp.cur_user = CURRENT_USER
            )
        ORDER BY pp.state DESC
        LIMIT 1
    ) pp ON TRUE
    JOIN selector_state ss ON ss.state_id = COALESCE(pp.state, arc.state) AND ss.cur_user = CURRENT_USER
    JOIN selector_sector ssec ON ssec.sector_id = arc.sector_id  AND ssec.cur_user = CURRENT_USER
    JOIN selector_municipality sm ON sm.muni_id = arc.muni_id AND sm.cur_user = CURRENT_USER
    JOIN selector_expl se ON se.expl_id = ANY (array_append(arc.expl_visibility, arc.expl_id)) AND se.cur_user = CURRENT_USER
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
    arc_selected.arc_id,
    arc_selected.code,
    arc_selected.sys_code,
    arc_selected.node_1,
    arc_selected.nodetype_1,
    arc_selected.node_top_elev_1,
    arc_selected.node_custom_top_elev_1,
    arc_selected.node_sys_top_elev_1,
    arc_selected.elev1,
    arc_selected.custom_elev1,
    COALESCE(arc_selected.sys_elev1, arc_selected.node_sys_elev_1) AS sys_elev1,
    arc_selected.y1,
        CASE
            WHEN (arc_selected.node_custom_top_elev_1 IS NOT NULL OR COALESCE(arc_selected.custom_elev1, arc_selected.node_custom_elev_1) IS NOT NULL) AND arc_selected.node_sys_top_elev_1 IS NOT NULL AND COALESCE(arc_selected.sys_elev1, arc_selected.node_sys_elev_1) IS NOT NULL THEN arc_selected.node_sys_top_elev_1 - COALESCE(arc_selected.sys_elev1, arc_selected.node_sys_elev_1)
            ELSE arc_selected.y1
        END AS sys_y1,
    arc_selected.node_sys_top_elev_1 - COALESCE(arc_selected.sys_elev1, arc_selected.node_sys_elev_1) - arc_selected.cat_geom1 AS r1,
    COALESCE(arc_selected.sys_elev1, arc_selected.node_sys_elev_1) - arc_selected.node_sys_elev_1 AS z1,
    arc_selected.node_2,
    arc_selected.nodetype_2,
    arc_selected.node_top_elev_2,
    arc_selected.node_custom_top_elev_2,
    arc_selected.node_sys_top_elev_2,
    arc_selected.elev2,
    arc_selected.custom_elev2,
    COALESCE(arc_selected.sys_elev2, arc_selected.node_sys_elev_2) AS sys_elev2,
    arc_selected.y2,
        CASE
            WHEN (arc_selected.node_custom_top_elev_2 IS NOT NULL OR COALESCE(arc_selected.custom_elev2, arc_selected.node_custom_elev_2) IS NOT NULL) AND arc_selected.node_sys_top_elev_2 IS NOT NULL AND COALESCE(arc_selected.sys_elev2, arc_selected.node_sys_elev_2) IS NOT NULL THEN arc_selected.node_sys_top_elev_2 - COALESCE(arc_selected.sys_elev2, arc_selected.node_sys_elev_2)
            ELSE arc_selected.y2
        END AS sys_y2,
    arc_selected.node_sys_top_elev_2 - COALESCE(arc_selected.sys_elev2, arc_selected.node_sys_elev_2) - arc_selected.cat_geom1 AS r2,
    COALESCE(arc_selected.sys_elev2, arc_selected.node_sys_elev_2) - arc_selected.node_sys_elev_2 AS z2,
    arc_selected.sys_type,
    arc_selected.arc_type,
    arc_selected.arccat_id,
    arc_selected.matcat_id,
    arc_selected.cat_shape,
    arc_selected.cat_geom1,
    arc_selected.cat_geom2,
    arc_selected.cat_width,
    arc_selected.cat_area,
    arc_selected.epa_type,
    arc_selected.state,
    arc_selected.state_type,
    arc_selected.parent_id,
    arc_selected.expl_id,
    arc_selected.macroexpl_id,
    arc_selected.muni_id,
    arc_selected.sector_id,
    arc_selected.macrosector_id,
    arc_selected.sector_type,
    arc_selected.drainzone_id,
    arc_selected.drainzone_type,
    arc_selected.drainzone_outfall,
    arc_selected.dwfzone_id,
    arc_selected.dwfzone_type,
    arc_selected.dwfzone_outfall,
    arc_selected.omzone_id,
    arc_selected.macroomzone_id,
    arc_selected.dma_id,
    arc_selected.omzone_type,
    arc_selected.omunit_id,
    arc_selected.minsector_id,
    arc_selected.pavcat_id,
    arc_selected.soilcat_id,
    arc_selected.function_type,
    arc_selected.category_type,
    arc_selected.location_type,
    arc_selected.fluid_type,
    arc_selected.custom_length,
    arc_selected.gis_length,
    arc_selected.slope,
    arc_selected.descript,
    arc_selected.annotation,
    arc_selected.observ,
    arc_selected.comment,
    arc_selected.link,
    arc_selected.num_value,
    arc_selected.district_id,
    arc_selected.postcode,
    arc_selected.streetaxis_id,
    arc_selected.postnumber,
    arc_selected.postcomplement,
    arc_selected.streetaxis2_id,
    arc_selected.postnumber2,
    arc_selected.postcomplement2,
    arc_selected.region_id,
    arc_selected.province_id,
    arc_selected.workcat_id,
    arc_selected.workcat_id_end,
    arc_selected.workcat_id_plan,
    arc_selected.builtdate,
    arc_selected.registration_date,
    arc_selected.enddate,
    arc_selected.ownercat_id,
    arc_selected.last_visitdate,
    arc_selected.visitability,
    arc_selected.om_state,
    arc_selected.conserv_state,
    arc_selected.brand_id,
    arc_selected.model_id,
    arc_selected.serial_number,
    arc_selected.asset_id,
    arc_selected.adate,
    arc_selected.adescript,
    arc_selected.verified,
    arc_selected.uncertain,
    arc_selected.datasource,
    arc_selected.label,
    arc_selected.label_x,
    arc_selected.label_y,
    arc_selected.label_rotation,
    arc_selected.label_quadrant,
    arc_selected.inventory,
    arc_selected.publish,
    arc_selected.is_operative,
    arc_selected.is_scadamap,
    arc_selected.inp_type,
    arc_selected.result_id,
    arc_selected.max_flow,
    arc_selected.max_veloc,
    arc_selected.mfull_flow,
    arc_selected.mfull_depth,
    arc_selected.manning_veloc,
    arc_selected.manning_flow,
    arc_selected.dwf_minflow,
    arc_selected.dwf_maxflow,
    arc_selected.dwf_minvel,
    arc_selected.dwf_maxvel,
    arc_selected.conduit_capacity,
    arc_selected.sector_style,
    arc_selected.drainzone_style,
    arc_selected.dwfzone_style,
    arc_selected.omzone_style,
    arc_selected.lock_level,
    arc_selected.initoverflowpath,
    arc_selected.inverted_slope,
    arc_selected.negative_offset,
    arc_selected.expl_visibility,
    arc_selected.created_at,
    arc_selected.created_by,
    arc_selected.updated_at,
    arc_selected.updated_by,
    arc_selected.the_geom,
    arc_selected.meandering,
    arc_selected.p_state,
    arc_selected.uuid,
    arc_selected.treatment_type
FROM arc_selected;



CREATE OR REPLACE VIEW v_edit_arc
AS WITH typevalue AS (
    SELECT 
        edit_typevalue.typevalue,
        edit_typevalue.id,
        edit_typevalue.idval
    FROM edit_typevalue
    WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
), sector_table AS (
    SELECT 
        sector.sector_id,
        sector.macrosector_id,
        sector.stylesheet,
        t.id::character varying(16) AS sector_type
    FROM sector
    LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
), omzone_table AS (
    SELECT 
        omzone.omzone_id,
        omzone.macroomzone_id,
        omzone.stylesheet,
        t.id::character varying(16) AS omzone_type
    FROM omzone
    LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
), drainzone_table AS (
    SELECT 
        drainzone.drainzone_id,
        drainzone.stylesheet,
        t.id::character varying(16) AS drainzone_type
    FROM drainzone
    LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
), dwfzone_table AS (
    SELECT 
        dwfzone.dwfzone_id,
        dwfzone.stylesheet,
        t.id::character varying(16) AS dwfzone_type,
        dwfzone.drainzone_id
    FROM dwfzone
    LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
), arc_selected AS (
    SELECT 
        arc.arc_id,
        arc.code,
        arc.sys_code,
        arc.node_1,
        arc.nodetype_1,
        arc.node_top_elev_1,
        arc.node_custom_top_elev_1,
        COALESCE(arc.node_custom_top_elev_1, arc.node_top_elev_1) AS node_sys_top_elev_1,
        arc.node_elev_1,
        arc.node_custom_elev_1,
        COALESCE(arc.node_custom_elev_1, arc.node_elev_1) AS node_sys_elev_1,
        arc.elev1,
        arc.custom_elev1,
        COALESCE(arc.custom_elev1, arc.elev1) AS sys_elev1,
        arc.y1,
        arc.node_2,
        arc.nodetype_2,
        arc.node_top_elev_2,
        arc.node_custom_top_elev_2,
        COALESCE(arc.node_custom_top_elev_2, arc.node_top_elev_2) AS node_sys_top_elev_2,
        arc.node_elev_2,
        arc.node_custom_elev_2,
        COALESCE(arc.node_custom_elev_2, arc.node_elev_2) AS node_sys_elev_2,
        arc.elev2,
        arc.custom_elev2,
        COALESCE(arc.custom_elev2, arc.elev2) AS sys_elev2,
        arc.y2,
        cat_feature.feature_class AS sys_type,
        arc.arc_type::text AS arc_type,
        arc.arccat_id,
        COALESCE(arc.matcat_id, cat_arc.matcat_id) AS matcat_id,
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
        COALESCE(pp.state, arc.state) AS p_state,
        arc.uuid
    FROM arc
    LEFT JOIN LATERAL (
        SELECT pp.state
        FROM plan_psector_x_arc pp
        WHERE pp.arc_id = arc.arc_id
            AND pp.psector_id IN (
                SELECT sp.psector_id
                FROM selector_psector sp
                WHERE sp.cur_user = CURRENT_USER
            )
        ORDER BY pp.state DESC
        LIMIT 1
    ) pp ON TRUE
    JOIN selector_state ss ON ss.state_id = COALESCE(pp.state, arc.state) AND ss.cur_user = CURRENT_USER
    JOIN selector_sector ssec ON ssec.sector_id = arc.sector_id  AND ssec.cur_user = CURRENT_USER
    JOIN selector_municipality sm ON sm.muni_id = arc.muni_id AND sm.cur_user = CURRENT_USER
    JOIN selector_expl se ON se.expl_id = ANY (array_append(arc.expl_visibility, arc.expl_id)) AND se.cur_user = CURRENT_USER
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
    arc_selected.arc_id,
    arc_selected.code,
    arc_selected.sys_code,
    arc_selected.node_1,
    arc_selected.nodetype_1,
    arc_selected.node_top_elev_1,
    arc_selected.node_custom_top_elev_1,
    arc_selected.node_sys_top_elev_1,
    arc_selected.elev1,
    arc_selected.custom_elev1,
    COALESCE(arc_selected.sys_elev1, arc_selected.node_sys_elev_1) AS sys_elev1,
    arc_selected.y1,
        CASE
            WHEN (arc_selected.node_custom_top_elev_1 IS NOT NULL OR COALESCE(arc_selected.custom_elev1, arc_selected.node_custom_elev_1) IS NOT NULL) AND arc_selected.node_sys_top_elev_1 IS NOT NULL AND COALESCE(arc_selected.sys_elev1, arc_selected.node_sys_elev_1) IS NOT NULL THEN arc_selected.node_sys_top_elev_1 - COALESCE(arc_selected.sys_elev1, arc_selected.node_sys_elev_1)
            ELSE arc_selected.y1
        END AS sys_y1,
    arc_selected.node_sys_top_elev_1 - COALESCE(arc_selected.sys_elev1, arc_selected.node_sys_elev_1) - arc_selected.cat_geom1 AS r1,
    COALESCE(arc_selected.sys_elev1, arc_selected.node_sys_elev_1) - arc_selected.node_sys_elev_1 AS z1,
    arc_selected.node_2,
    arc_selected.nodetype_2,
    arc_selected.node_top_elev_2,
    arc_selected.node_custom_top_elev_2,
    arc_selected.node_sys_top_elev_2,
    arc_selected.elev2,
    arc_selected.custom_elev2,
    COALESCE(arc_selected.sys_elev2, arc_selected.node_sys_elev_2) AS sys_elev2,
    arc_selected.y2,
        CASE
            WHEN (arc_selected.node_custom_top_elev_2 IS NOT NULL OR COALESCE(arc_selected.custom_elev2, arc_selected.node_custom_elev_2) IS NOT NULL) AND arc_selected.node_sys_top_elev_2 IS NOT NULL AND COALESCE(arc_selected.sys_elev2, arc_selected.node_sys_elev_2) IS NOT NULL THEN arc_selected.node_sys_top_elev_2 - COALESCE(arc_selected.sys_elev2, arc_selected.node_sys_elev_2)
            ELSE arc_selected.y2
        END AS sys_y2,
    arc_selected.node_sys_top_elev_2 - COALESCE(arc_selected.sys_elev2, arc_selected.node_sys_elev_2) - arc_selected.cat_geom1 AS r2,
    COALESCE(arc_selected.sys_elev2, arc_selected.node_sys_elev_2) - arc_selected.node_sys_elev_2 AS z2,
    arc_selected.sys_type,
    arc_selected.arc_type,
    arc_selected.arccat_id,
    arc_selected.matcat_id,
    arc_selected.cat_shape,
    arc_selected.cat_geom1,
    arc_selected.cat_geom2,
    arc_selected.cat_width,
    arc_selected.cat_area,
    arc_selected.epa_type,
    arc_selected.state,
    arc_selected.state_type,
    arc_selected.parent_id,
    arc_selected.expl_id,
    arc_selected.macroexpl_id,
    arc_selected.muni_id,
    arc_selected.sector_id,
    arc_selected.macrosector_id,
    arc_selected.sector_type,
    arc_selected.drainzone_id,
    arc_selected.drainzone_type,
    arc_selected.drainzone_outfall,
    arc_selected.dwfzone_id,
    arc_selected.dwfzone_type,
    arc_selected.dwfzone_outfall,
    arc_selected.omzone_id,
    arc_selected.macroomzone_id,
    arc_selected.dma_id,
    arc_selected.omzone_type,
    arc_selected.omunit_id,
    arc_selected.minsector_id,
    arc_selected.pavcat_id,
    arc_selected.soilcat_id,
    arc_selected.function_type,
    arc_selected.category_type,
    arc_selected.location_type,
    arc_selected.fluid_type,
    arc_selected.custom_length,
    arc_selected.gis_length,
    arc_selected.slope,
    arc_selected.descript,
    arc_selected.annotation,
    arc_selected.observ,
    arc_selected.comment,
    arc_selected.link,
    arc_selected.num_value,
    arc_selected.district_id,
    arc_selected.postcode,
    arc_selected.streetaxis_id,
    arc_selected.postnumber,
    arc_selected.postcomplement,
    arc_selected.streetaxis2_id,
    arc_selected.postnumber2,
    arc_selected.postcomplement2,
    arc_selected.region_id,
    arc_selected.province_id,
    arc_selected.workcat_id,
    arc_selected.workcat_id_end,
    arc_selected.workcat_id_plan,
    arc_selected.builtdate,
    arc_selected.registration_date,
    arc_selected.enddate,
    arc_selected.ownercat_id,
    arc_selected.last_visitdate,
    arc_selected.visitability,
    arc_selected.om_state,
    arc_selected.conserv_state,
    arc_selected.brand_id,
    arc_selected.model_id,
    arc_selected.serial_number,
    arc_selected.asset_id,
    arc_selected.adate,
    arc_selected.adescript,
    arc_selected.verified,
    arc_selected.uncertain,
    arc_selected.datasource,
    arc_selected.label,
    arc_selected.label_x,
    arc_selected.label_y,
    arc_selected.label_rotation,
    arc_selected.label_quadrant,
    arc_selected.inventory,
    arc_selected.publish,
    arc_selected.is_operative,
    arc_selected.is_scadamap,
    arc_selected.inp_type,
    arc_selected.result_id,
    arc_selected.max_flow,
    arc_selected.max_veloc,
    arc_selected.mfull_flow,
    arc_selected.mfull_depth,
    arc_selected.manning_veloc,
    arc_selected.manning_flow,
    arc_selected.dwf_minflow,
    arc_selected.dwf_maxflow,
    arc_selected.dwf_minvel,
    arc_selected.dwf_maxvel,
    arc_selected.conduit_capacity,
    arc_selected.sector_style,
    arc_selected.drainzone_style,
    arc_selected.dwfzone_style,
    arc_selected.omzone_style,
    arc_selected.lock_level,
    arc_selected.initoverflowpath,
    arc_selected.inverted_slope,
    arc_selected.negative_offset,
    arc_selected.expl_visibility,
    arc_selected.created_at,
    arc_selected.created_by,
    arc_selected.updated_at,
    arc_selected.updated_by,
    arc_selected.the_geom,
    arc_selected.meandering,
    arc_selected.p_state,
    arc_selected.uuid
FROM arc_selected;


CREATE OR REPLACE VIEW ve_connec
AS WITH typevalue AS (
    SELECT 
        edit_typevalue.typevalue,
        edit_typevalue.id,
        edit_typevalue.idval
    FROM edit_typevalue
    WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
), sector_table AS (
    SELECT 
        sector.sector_id,
        sector.macrosector_id,
        sector.stylesheet,
        t.id::character varying(16) AS sector_type
    FROM sector
    LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
), omzone_table AS (
    SELECT 
        omzone.omzone_id,
        omzone.macroomzone_id,
        omzone.stylesheet,
        t.id::character varying(16) AS omzone_type
    FROM omzone
    LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
), drainzone_table AS (
    SELECT 
        drainzone.drainzone_id,
        drainzone.stylesheet,
        t.id::character varying(16) AS drainzone_type
    FROM drainzone
    LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
), dwfzone_table AS (
    SELECT 
        dwfzone.dwfzone_id,
        dwfzone.stylesheet,
        t.id::character varying(16) AS dwfzone_type,
        dwfzone.drainzone_id
    FROM dwfzone
    LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
), link_planned AS (
    SELECT 
        l.link_id,
        l.feature_id,
        l.feature_type,
        l.exit_id,
        l.exit_type,
        l.expl_id
    FROM link l
    WHERE l.state = 2
)
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
    pp.arc_id,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.muni_id,
    connec.sector_id,
    sector_table.macrosector_id,
    dwfzone_table.drainzone_id,
    drainzone_table.drainzone_type,
    connec.dwfzone_id,
    dwfzone_table.dwfzone_type,
    connec.omzone_id,
    omzone_table.macroomzone_id,
    omzone_table.omzone_type,
    connec.dma_id,
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
    COALESCE(pp.state, connec.state) AS p_state,
    connec.uuid,
    connec.treatment_type,
    connec.xyz_date
FROM connec
LEFT JOIN LATERAL (
    SELECT pp.state, pp.arc_id, pp.link_id
    FROM plan_psector_x_connec pp
    WHERE pp.connec_id = connec.connec_id
    AND pp.psector_id IN (
        SELECT sp.psector_id
        FROM selector_psector sp
        WHERE sp.cur_user = CURRENT_USER
    )
    ORDER BY pp.state DESC, pp.link_id DESC NULLS LAST
    LIMIT 1
) pp ON TRUE
JOIN selector_state ss ON ss.state_id = COALESCE(pp.state, connec.state) AND ss.cur_user = CURRENT_USER
JOIN selector_sector ssec ON ssec.sector_id = connec.sector_id AND ssec.cur_user = CURRENT_USER
JOIN selector_municipality sm ON sm.muni_id = connec.muni_id AND sm.cur_user = CURRENT_USER
JOIN selector_expl se ON se.expl_id = ANY (array_append(connec.expl_visibility::integer[], connec.expl_id)) AND se.cur_user = CURRENT_USER
JOIN cat_connec ON cat_connec.id::text = connec.conneccat_id::text
JOIN cat_feature ON cat_feature.id::text = connec.connec_type::text
JOIN exploitation ON connec.expl_id = exploitation.expl_id
JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
JOIN value_state_type vst ON vst.id = connec.state_type
JOIN sector_table ON sector_table.sector_id = connec.sector_id
LEFT JOIN omzone_table ON omzone_table.omzone_id = connec.omzone_id
LEFT JOIN drainzone_table ON connec.omzone_id = drainzone_table.drainzone_id
LEFT JOIN dwfzone_table ON connec.dwfzone_id = dwfzone_table.dwfzone_id
LEFT JOIN link_planned ON link_planned.link_id = pp.link_id;

CREATE OR REPLACE VIEW ve_gully
AS WITH typevalue AS (
    SELECT 
        edit_typevalue.typevalue,
        edit_typevalue.id,
        edit_typevalue.idval
    FROM edit_typevalue
    WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
), sector_table AS (
    SELECT 
        sector.sector_id,
        sector.macrosector_id,
        sector.stylesheet,
        t.id::character varying(16) AS sector_type
    FROM sector
    LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
), omzone_table AS (
    SELECT 
        omzone.omzone_id,
        omzone.macroomzone_id,
        omzone.stylesheet,
        t.id::character varying(16) AS omzone_type
    FROM omzone
    LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
), drainzone_table AS (
    SELECT 
        drainzone.drainzone_id,
        drainzone.stylesheet,
        t.id::character varying(16) AS drainzone_type
    FROM drainzone
    LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
), dwfzone_table AS (
    SELECT 
        dwfzone.dwfzone_id,
        dwfzone.stylesheet,
        t.id::character varying(16) AS dwfzone_type,
        dwfzone.drainzone_id
    FROM dwfzone
    LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
), inp_network_mode AS (
    SELECT config_param_user.value
    FROM config_param_user
    WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
), link_planned AS (
    SELECT 
        l.link_id,
        l.feature_id,
        l.feature_type,
        l.exit_id,
        l.exit_type,
        l.expl_id
    FROM link l
    WHERE l.state = 2
)
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
    pp.arc_id,
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
    COALESCE(pp.state, gully.state) AS p_state,
    gully.uuid,
    gully.treatment_type,
    gully.xyz_date
FROM gully
LEFT JOIN LATERAL (
    SELECT pp.state, pp.arc_id, pp.link_id
    FROM plan_psector_x_gully pp
    WHERE pp.gully_id = gully.gully_id
    AND pp.psector_id IN (
        SELECT sp.psector_id
        FROM selector_psector sp
        WHERE sp.cur_user = CURRENT_USER
    )
    ORDER BY pp.state DESC, pp.link_id DESC NULLS LAST
    LIMIT 1
) pp ON TRUE
JOIN selector_state ss ON ss.state_id = COALESCE(pp.state, gully.state) AND ss.cur_user = CURRENT_USER
JOIN selector_sector ssec ON ssec.sector_id = gully.sector_id AND ssec.cur_user = CURRENT_USER
JOIN selector_municipality sm ON sm.muni_id = gully.muni_id AND sm.cur_user = CURRENT_USER
JOIN selector_expl se ON se.expl_id = ANY (array_append(gully.expl_visibility::integer[], gully.expl_id)) AND se.cur_user = CURRENT_USER
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
LEFT JOIN inp_network_mode ON true;


CREATE OR REPLACE VIEW ve_rtc_hydro_data_x_connec
AS SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
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
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer_x_data.hydrometer_id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
  ORDER BY ext_rtc_hydrometer_x_data.hydrometer_id, ext_rtc_hydrometer_x_data.cat_period_id DESC;


CREATE OR REPLACE VIEW v_ui_hydroval
AS SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id AS feature_id,
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
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::text = ext_rtc_hydrometer_x_data.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id = connec.connec_id
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
  ORDER BY ext_rtc_hydrometer_x_data.id;


CREATE OR REPLACE VIEW v_ui_hydroval_x_connec
AS SELECT ext_rtc_hydrometer_x_data.id,
    rtc_hydrometer_x_connec.connec_id,
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
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::text = ext_rtc_hydrometer_x_data.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id = connec.connec_id
     LEFT JOIN crm_typevalue crmtype ON ext_rtc_hydrometer_x_data.value_type = crmtype.id::integer AND crmtype.typevalue::text = 'crm_value_type'::text
     LEFT JOIN crm_typevalue crmstatus ON ext_rtc_hydrometer_x_data.value_status = crmstatus.id::integer AND crmstatus.typevalue::text = 'crm_value_status'::text
     LEFT JOIN crm_typevalue crmstate ON ext_rtc_hydrometer_x_data.value_state = crmstate.id::integer AND crmstate.typevalue::text = 'crm_value_state'::text
  ORDER BY ext_rtc_hydrometer_x_data.id;
  

-- create multiresult views to analyze results envelope   
CREATE OR REPLACE VIEW v_rpt_multi_arcflow_sum
AS SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_arcflow_sum.arc_type AS swarc_type,
    max(rpt_arcflow_sum.max_flow) AS max_flow,
    max(rpt_arcflow_sum.time_days) AS time_days,
    max(rpt_arcflow_sum.time_hour) AS time_hour,
    max(rpt_arcflow_sum.max_veloc) AS max_veloc,
    max(COALESCE(rpt_arcflow_sum.mfull_flow, 0::numeric(12,4))) AS mfull_flow,
    max(COALESCE(rpt_arcflow_sum.mfull_depth, 0::numeric(12,4))) AS mfull_depth,
    max(rpt_arcflow_sum.max_shear) AS max_shear,
    max(rpt_arcflow_sum.max_hr) AS max_hr,
    max(rpt_arcflow_sum.max_slope) AS max_slope,
    max(rpt_arcflow_sum.day_max) AS day_max,
    max(rpt_arcflow_sum.time_max) AS time_max,
    max(rpt_arcflow_sum.min_shear) AS min_shear,
    max(rpt_arcflow_sum.day_min) AS day_min,
    max(rpt_arcflow_sum.time_min) AS swartime_minc_type
   FROM selector_rpt_main ,  rpt_inp_arc
     JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_arcflow_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text 
 AND rpt_inp_arc.result_id::text = selector_rpt_main.result_id::TEXT
 GROUP BY 1,2,3,4,5,6,7,8;

 
CREATE OR REPLACE VIEW v_rpt_multi_nodeflooding_sum
AS SELECT rpt_inp_node.id,
    rpt_nodeflooding_sum.node_id,
    selector_rpt_main.result_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    max(rpt_nodeflooding_sum.hour_flood) AS hour_flood,
    max(rpt_nodeflooding_sum.max_rate) AS max_rate,
    max(rpt_nodeflooding_sum.time_days) AS time_days,
    max(rpt_nodeflooding_sum.time_hour) AS time_hour,
    max(rpt_nodeflooding_sum.tot_flood) AS tot_flood,
    max(rpt_nodeflooding_sum.max_ponded) AS max_ponded,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM selector_rpt_main,
    rpt_inp_node
     JOIN rpt_nodeflooding_sum ON rpt_nodeflooding_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_nodeflooding_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_node.result_id::text = selector_rpt_main.result_id::TEXT
  GROUP BY 1,2,3,4,5,12,13;

CREATE OR REPLACE VIEW ve_pol_storage
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
   FROM polygon
     JOIN ve_node ON polygon.feature_id = ve_node.node_id
  WHERE polygon.sys_type::text = 'STORAGE'::text;

CREATE OR REPLACE VIEW ve_pol_wwtp
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
   FROM polygon
     JOIN ve_node ON polygon.feature_id = ve_node.node_id
  WHERE polygon.sys_type::text = 'WWTP'::text;

CREATE OR REPLACE VIEW ve_pol_chamber
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
   FROM polygon
     JOIN ve_node ON polygon.feature_id = ve_node.node_id
  WHERE polygon.sys_type::text = 'CHAMBER'::text;

CREATE OR REPLACE VIEW ve_pol_netgully
AS SELECT polygon.pol_id,
    polygon.feature_id AS node_id,
    polygon.the_geom
   FROM polygon
     JOIN ve_node ON polygon.feature_id = ve_node.node_id
  WHERE polygon.sys_type::text = 'NETGULLY'::text;

CREATE OR REPLACE VIEW v_plan_node
AS SELECT node_id,
    nodecat_id,
    node_type::text AS node_type,
    top_elev,
    elev,
    epa_type,
    state,
    sector_id,
    expl_id,
    annotation,
    cost_unit,
    descript,
    cost,
    measurement,
    budget,
    the_geom
   FROM ( SELECT ve_node.node_id,
            ve_node.nodecat_id,
            ve_node.sys_type AS node_type,
            ve_node.top_elev,
            ve_node.elev,
            ve_node.epa_type,
            ve_node.state,
            ve_node.sector_id,
            ve_node.expl_id,
            ve_node.annotation,
            v_price_x_catnode.cost_unit,
            v_price_compost.descript,
            v_price_compost.price AS cost,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN 1::numeric
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN ve_node.sys_type::text = 'STORAGE'::text THEN man_storage.max_volume
                        WHEN ve_node.sys_type::text = 'CHAMBER'::text THEN man_chamber.max_volume
                        ELSE NULL::numeric
                    END
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN ve_node.ymax = 0::numeric THEN v_price_x_catnode.estimated_y
                        WHEN ve_node.ymax IS NULL THEN v_price_x_catnode.estimated_y
                        ELSE ve_node.ymax
                    END
                    ELSE NULL::numeric
                END::numeric(12,2) AS measurement,
                CASE
                    WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN v_price_x_catnode.cost
                    WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
                    CASE
                        WHEN ve_node.sys_type::text = 'STORAGE'::text THEN man_storage.max_volume * v_price_x_catnode.cost
                        WHEN ve_node.sys_type::text = 'CHAMBER'::text THEN man_chamber.max_volume * v_price_x_catnode.cost
                        ELSE NULL::numeric
                    END
                    WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
                    CASE
                        WHEN ve_node.ymax = 0::numeric THEN v_price_x_catnode.estimated_y * v_price_x_catnode.cost
                        WHEN ve_node.ymax IS NULL THEN v_price_x_catnode.estimated_y * v_price_x_catnode.cost
                        ELSE ve_node.ymax * v_price_x_catnode.cost
                    END
                    ELSE NULL::numeric
                END::numeric(12,2) AS budget,
            ve_node.the_geom
           FROM ve_node
             LEFT JOIN v_price_x_catnode ON ve_node.nodecat_id::text = v_price_x_catnode.id::text
             LEFT JOIN man_chamber ON man_chamber.node_id = ve_node.node_id
             LEFT JOIN man_storage ON man_storage.node_id = ve_node.node_id
             LEFT JOIN cat_node ON cat_node.id::text = ve_node.nodecat_id::text
             LEFT JOIN v_price_compost ON v_price_compost.id::text = cat_node.cost::text) a;

CREATE OR REPLACE VIEW v_ui_plan_node_cost
AS SELECT node.node_id,
    1 AS orderby,
    'element'::text AS identif,
    cat_node.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost,
    NULL::double precision AS length
   FROM node
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN v_price_compost ON cat_node.cost::text = v_price_compost.id::text
     JOIN v_plan_node ON node.node_id = v_plan_node.node_id;

CREATE OR REPLACE VIEW v_plan_aux_arc_pavement
AS SELECT plan_arc_x_pavement.arc_id,
    sum(v_price_x_catpavement.thickness * plan_arc_x_pavement.percent)::numeric(12,2) AS thickness,
    sum(v_price_x_catpavement.m2pav_cost * plan_arc_x_pavement.percent)::numeric(12,2) AS m2pav_cost,
    'Various pavements'::character varying AS pavcat_id,
    1 AS percent,
    'VARIOUS'::character varying AS price_id
   FROM plan_arc_x_pavement
     JOIN v_price_x_catpavement USING (pavcat_id)
  GROUP BY plan_arc_x_pavement.arc_id
UNION
 SELECT ve_arc.arc_id,
    c.thickness,
    v_price_x_catpavement.m2pav_cost,
    ve_arc.pavcat_id,
    1 AS percent,
    p.id AS price_id
   FROM ve_arc
     JOIN cat_pavement c ON c.id::text = ve_arc.pavcat_id::text
     JOIN v_price_x_catpavement USING (pavcat_id)
     LEFT JOIN v_price_compost p ON c.m2_cost::text = p.id::text
     LEFT JOIN ( SELECT plan_arc_x_pavement.arc_id
           FROM plan_arc_x_pavement) a USING (arc_id)
  WHERE a.arc_id IS NULL;

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
    'v_edit_arc'::text AS sys_table_id
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
    'v_edit_connec'::text AS sys_table_id
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
    'v_edit_connec'::text AS sys_table_id
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
    'v_edit_gully'::text AS sys_table_id
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
    'v_edit_gully'::text AS sys_table_id
   FROM ve_gully
     JOIN link ON link.feature_id = ve_gully.gully_id AND link.feature_type::text = 'GULLY'::text AND link.exit_type::text = 'GULLY'::text
     JOIN gully ON gully.gully_id = link.exit_id AND gully.pjoint_type::text = 'NODE'::text
     JOIN node ON gully.pjoint_id = node.node_id
     LEFT JOIN cat_connec ON ve_gully.connec_arccat_id::text = cat_connec.id::text
     JOIN value_state ON ve_gully.state = value_state.id;

CREATE OR REPLACE VIEW ve_inp_conduit
AS SELECT ve_arc.arc_id,
    ve_arc.node_1,
    ve_arc.node_2,
    ve_arc.y1,
    ve_arc.elev1,
    ve_arc.custom_elev1,
    ve_arc.sys_elev1,
    ve_arc.y2,
    ve_arc.elev2,
    ve_arc.custom_elev2,
    ve_arc.sys_elev2,
    ve_arc.arccat_id,
    ve_arc.matcat_id,
    ve_arc.cat_shape,
    ve_arc.cat_geom1,
    ve_arc.gis_length,
    ve_arc.sector_id,
    ve_arc.macrosector_id,
    ve_arc.state,
    ve_arc.state_type,
    ve_arc.annotation,
    ve_arc.inverted_slope,
    ve_arc.custom_length,
    ve_arc.expl_id,
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
    ve_arc.the_geom
   FROM ve_arc
     JOIN inp_conduit USING (arc_id)
  WHERE ve_arc.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_conduit
AS SELECT f.dscenario_id,
    f.arc_id,
    f.arccat_id,
    f.matcat_id,
    f.elev1,
    f.elev2,
    f.custom_n,
    f.barrels,
    f.culvert,
    f.kentry,
    f.kexit,
    f.kavg,
    f.flap,
    f.q0,
    f.qmax,
    f.seepage,
    ve_inp_conduit.the_geom
   FROM selector_inp_dscenario s,
    inp_dscenario_conduit f
     JOIN ve_inp_conduit USING (arc_id)
  WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_ui_node_x_connection_downstream
AS SELECT row_number() OVER (ORDER BY ve_arc.node_1) + 1000000 AS rid,
    ve_arc.node_1 AS node_id,
    ve_arc.arc_id AS feature_id,
    ve_arc.code AS feature_code,
    ve_arc.arc_type AS featurecat_id,
    ve_arc.arccat_id,
    ve_arc.y2 AS depth,
    st_length2d(ve_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS downstream_id,
    node.code AS downstream_code,
    node.node_type::text AS downstream_type,
    ve_arc.y1 AS downstream_depth,
    ve_arc.sys_type,
    st_x(st_lineinterpolatepoint(ve_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(ve_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_edit_arc'::text AS sys_table_id
   FROM ve_arc
     JOIN node ON ve_arc.node_2 = node.node_id
     LEFT JOIN cat_arc ON ve_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON ve_arc.state = value_state.id;

CREATE OR REPLACE VIEW ve_inp_orifice
AS SELECT ve_arc.arc_id,
    ve_arc.node_1,
    ve_arc.node_2,
    ve_arc.y1,
    ve_arc.elev1,
    ve_arc.custom_elev1,
    ve_arc.sys_elev1,
    ve_arc.y2,
    ve_arc.elev2,
    ve_arc.custom_elev2,
    ve_arc.sys_elev2,
    ve_arc.arccat_id,
    ve_arc.gis_length,
    ve_arc.sector_id,
    ve_arc.macrosector_id,
    ve_arc.state,
    ve_arc.state_type,
    ve_arc.annotation,
    ve_arc.inverted_slope,
    ve_arc.custom_length,
    ve_arc.expl_id,
    inp_orifice.ori_type,
    inp_orifice.offsetval,
    inp_orifice.cd,
    inp_orifice.orate,
    inp_orifice.flap,
    inp_orifice.shape,
    inp_orifice.geom1,
    inp_orifice.geom2,
    inp_orifice.geom3,
    inp_orifice.geom4,
    ve_arc.the_geom
   FROM ve_arc
     JOIN inp_orifice USING (arc_id)
  WHERE ve_arc.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_outlet
AS SELECT ve_arc.arc_id,
    ve_arc.node_1,
    ve_arc.node_2,
    ve_arc.y1,
    ve_arc.elev1,
    ve_arc.custom_elev1,
    ve_arc.sys_elev1,
    ve_arc.y2,
    ve_arc.elev2,
    ve_arc.custom_elev2,
    ve_arc.sys_elev2,
    ve_arc.arccat_id,
    ve_arc.gis_length,
    ve_arc.sector_id,
    ve_arc.macrosector_id,
    ve_arc.state,
    ve_arc.state_type,
    ve_arc.annotation,
    ve_arc.inverted_slope,
    ve_arc.custom_length,
    ve_arc.expl_id,
    inp_outlet.outlet_type,
    inp_outlet.offsetval,
    inp_outlet.curve_id,
    inp_outlet.cd1,
    inp_outlet.cd2,
    inp_outlet.flap,
    ve_arc.the_geom
   FROM ve_arc
     JOIN inp_outlet USING (arc_id)
  WHERE ve_arc.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_pump
AS SELECT ve_arc.arc_id,
    ve_arc.node_1,
    ve_arc.node_2,
    ve_arc.y1,
    ve_arc.elev1,
    ve_arc.custom_elev1,
    ve_arc.sys_elev1,
    ve_arc.y2,
    ve_arc.elev2,
    ve_arc.custom_elev2,
    ve_arc.sys_elev2,
    ve_arc.arccat_id,
    ve_arc.gis_length,
    ve_arc.sector_id,
    ve_arc.macrosector_id,
    ve_arc.state,
    ve_arc.state_type,
    ve_arc.annotation,
    ve_arc.inverted_slope,
    ve_arc.custom_length,
    ve_arc.expl_id,
    inp_pump.curve_id,
    inp_pump.status,
    inp_pump.startup,
    inp_pump.shutoff,
    ve_arc.the_geom
   FROM ve_arc
     JOIN inp_pump USING (arc_id)
  WHERE ve_arc.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_virtual
AS SELECT ve_arc.arc_id,
    ve_arc.node_1,
    ve_arc.node_2,
    ve_arc.arccat_id,
    ve_arc.gis_length,
    ve_arc.sector_id,
    ve_arc.macrosector_id,
    ve_arc.state,
    ve_arc.state_type,
    ve_arc.expl_id,
    inp_virtual.fusion_node,
    inp_virtual.add_length,
    ve_arc.the_geom
   FROM ve_arc
     JOIN inp_virtual ON ve_arc.arc_id::text = inp_virtual.arc_id::text
  WHERE ve_arc.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_weir
AS SELECT ve_arc.arc_id,
    ve_arc.node_1,
    ve_arc.node_2,
    ve_arc.y1,
    ve_arc.elev1,
    ve_arc.custom_elev1,
    ve_arc.sys_elev1,
    ve_arc.y2,
    ve_arc.elev2,
    ve_arc.custom_elev2,
    ve_arc.sys_elev2,
    ve_arc.arccat_id,
    ve_arc.gis_length,
    ve_arc.sector_id,
    ve_arc.macrosector_id,
    ve_arc.state,
    ve_arc.state_type,
    ve_arc.annotation,
    ve_arc.inverted_slope,
    ve_arc.custom_length,
    ve_arc.expl_id,
    inp_weir.weir_type,
    inp_weir.offsetval,
    inp_weir.cd,
    inp_weir.ec,
    inp_weir.cd2,
    inp_weir.flap,
    inp_weir.geom1,
    inp_weir.geom2,
    inp_weir.geom3,
    inp_weir.geom4,
    inp_weir.surcharge,
    ve_arc.the_geom,
    inp_weir.road_width,
    inp_weir.road_surf,
    inp_weir.coef_curve
   FROM ve_arc
     JOIN inp_weir USING (arc_id)
  WHERE ve_arc.is_operative IS TRUE;

CREATE OR REPLACE VIEW v_plan_result_node
AS SELECT plan_rec_result_node.node_id,
    plan_rec_result_node.nodecat_id,
    plan_rec_result_node.node_type::text AS node_type,
    plan_rec_result_node.top_elev,
    plan_rec_result_node.elev,
    plan_rec_result_node.epa_type,
    plan_rec_result_node.state,
    plan_rec_result_node.sector_id,
    plan_rec_result_node.expl_id,
    plan_rec_result_node.cost_unit,
    plan_rec_result_node.descript,
    plan_rec_result_node.measurement,
    plan_rec_result_node.cost,
    plan_rec_result_node.budget,
    plan_rec_result_node.the_geom,
    plan_rec_result_node.builtcost,
    plan_rec_result_node.builtdate,
    plan_rec_result_node.age,
    plan_rec_result_node.acoeff,
    plan_rec_result_node.aperiod,
    plan_rec_result_node.arate,
    plan_rec_result_node.amortized,
    plan_rec_result_node.pending
   FROM selector_expl,
    selector_plan_result,
    plan_rec_result_node
  WHERE plan_rec_result_node.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND plan_rec_result_node.result_id::text = selector_plan_result.result_id::text AND selector_plan_result.cur_user = "current_user"()::text AND plan_rec_result_node.state = 1
UNION
 SELECT v_plan_node.node_id,
    v_plan_node.nodecat_id,
    v_plan_node.node_type,
    v_plan_node.top_elev,
    v_plan_node.elev,
    v_plan_node.epa_type,
    v_plan_node.state,
    v_plan_node.sector_id,
    v_plan_node.expl_id,
    v_plan_node.cost_unit,
    v_plan_node.descript,
    v_plan_node.measurement,
    v_plan_node.cost,
    v_plan_node.budget,
    v_plan_node.the_geom,
    NULL::double precision AS builtcost,
    NULL::timestamp without time zone AS builtdate,
    NULL::double precision AS age,
    NULL::double precision AS acoeff,
    NULL::text AS aperiod,
    NULL::double precision AS arate,
    NULL::double precision AS amortized,
    NULL::double precision AS pending
   FROM v_plan_node
  WHERE v_plan_node.state = 2;

CREATE OR REPLACE VIEW v_plan_psector_budget_node
AS SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
    plan_psector_x_node.psector_id,
    plan_psector.psector_type,
    v_plan_node.node_id,
    v_plan_node.nodecat_id,
    v_plan_node.cost::numeric(12,2) AS cost,
    v_plan_node.measurement,
    v_plan_node.budget AS total_budget,
    v_plan_node.state,
    v_plan_node.expl_id,
    plan_psector.atlas_id,
    plan_psector_x_node.doable,
    plan_psector.priority,
    v_plan_node.the_geom
   FROM v_plan_node
     JOIN plan_psector_x_node ON plan_psector_x_node.node_id = v_plan_node.node_id
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_node.psector_id
  WHERE plan_psector_x_node.doable = true
  ORDER BY plan_psector_x_node.psector_id;

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
    1 AS measurement,
    a.m2pav_cost AS total_cost,
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

CREATE OR REPLACE VIEW ve_inp_outfall
AS SELECT ve_node.node_id,
    ve_node.top_elev,
    ve_node.custom_top_elev,
    ve_node.ymax,
    ve_node.elev,
    ve_node.custom_elev,
    ve_node.sys_elev,
    ve_node.nodecat_id,
    ve_node.sector_id,
    ve_node.macrosector_id,
    ve_node.state,
    ve_node.state_type,
    ve_node.annotation,
    ve_node.expl_id,
    inp_outfall.outfall_type,
    inp_outfall.stage,
    inp_outfall.curve_id,
    inp_outfall.timser_id,
    inp_outfall.gate,
    inp_outfall.route_to,
    ve_node.the_geom
   FROM ve_node
     JOIN inp_outfall USING (node_id)
  WHERE ve_node.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_outfall
AS SELECT s.dscenario_id,
    f.node_id,
    f.elev,
    f.ymax,
    f.outfall_type,
    f.stage,
    f.curve_id,
    f.timser_id,
    f.gate,
    f.route_to,
    ve_inp_outfall.the_geom
   FROM selector_inp_dscenario s,
    inp_dscenario_outfall f
     JOIN ve_inp_outfall USING (node_id)
  WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW ve_inp_storage
AS SELECT ve_node.node_id,
    ve_node.top_elev,
    ve_node.custom_top_elev,
    ve_node.ymax,
    ve_node.elev,
    ve_node.custom_elev,
    ve_node.sys_elev,
    ve_node.nodecat_id,
    ve_node.sector_id,
    ve_node.macrosector_id,
    ve_node.state,
    ve_node.state_type,
    ve_node.annotation,
    ve_node.expl_id,
    inp_storage.storage_type,
    inp_storage.curve_id,
    inp_storage.a1,
    inp_storage.a2,
    inp_storage.a0,
    inp_storage.fevap,
    inp_storage.sh,
    inp_storage.hc,
    inp_storage.imd,
    inp_storage.y0,
    inp_storage.ysur,
    ve_node.the_geom
   FROM ve_node
     JOIN inp_storage USING (node_id)
  WHERE ve_node.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_storage
AS SELECT s.dscenario_id,
    f.node_id,
    f.elev,
    f.ymax,
    f.storage_type,
    f.curve_id,
    f.a1,
    f.a2,
    f.a0,
    f.fevap,
    f.sh,
    f.hc,
    f.imd,
    f.y0,
    f.ysur,
    ve_inp_storage.the_geom
   FROM selector_inp_dscenario s,
    inp_dscenario_storage f
     JOIN ve_inp_storage USING (node_id)
  WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW ve_inp_netgully
AS SELECT n.node_id,
    n.code,
    n.top_elev,
    n.custom_top_elev,
    n.ymax,
    n.elev,
    n.custom_elev,
    n.sys_elev,
    n.node_type,
    n.nodecat_id,
    man_netgully.gullycat_id,
    (cat_gully.width / 100::numeric)::numeric(12,3) AS grate_width,
    (cat_gully.length / 100::numeric)::numeric(12,3) AS grate_length,
    n.sector_id,
    n.macrosector_id,
    n.expl_id,
    n.state,
    n.state_type,
    n.the_geom,
    man_netgully.units,
    man_netgully.units_placement,
    man_netgully.groove,
    man_netgully.groove_height,
    man_netgully.groove_length,
        CASE
            WHEN man_netgully.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_gully.width / 100::numeric)::numeric(12,3)
            WHEN man_netgully.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_gully.length / 100::numeric)::numeric(12,3)
            ELSE (cat_gully.width / 100::numeric)::numeric(12,3)
        END AS total_width,
        CASE
            WHEN man_netgully.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_gully.width / 100::numeric)::numeric(12,3)
            WHEN man_netgully.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_gully.length / 100::numeric)::numeric(12,3)
            ELSE (cat_gully.length / 100::numeric)::numeric(12,3)
        END AS total_length,
    n.ymax - COALESCE(man_netgully.sander_depth, 0::numeric) AS depth,
    n.annotation,
    i.y0,
    i.ysur,
    i.apond,
    i.outlet_type,
    i.custom_width,
    i.custom_length,
    i.custom_depth,
    i.gully_method,
    i.weir_cd,
    i.orifice_cd,
    i.custom_a_param,
    i.custom_b_param,
    i.efficiency
   FROM ve_node n
     JOIN inp_netgully i USING (node_id)
     LEFT JOIN man_netgully USING (node_id)
     LEFT JOIN cat_gully ON man_netgully.gullycat_id::text = cat_gully.id::text
  WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_divider
AS SELECT ve_node.node_id,
    ve_node.top_elev,
    ve_node.custom_top_elev,
    ve_node.ymax,
    ve_node.elev,
    ve_node.custom_elev,
    ve_node.sys_elev,
    ve_node.nodecat_id,
    ve_node.sector_id,
    ve_node.macrosector_id,
    ve_node.state,
    ve_node.state_type,
    ve_node.annotation,
    ve_node.expl_id,
    inp_divider.divider_type,
    inp_divider.arc_id,
    inp_divider.curve_id,
    inp_divider.qmin,
    inp_divider.ht,
    inp_divider.cd,
    inp_divider.y0,
    inp_divider.ysur,
    inp_divider.apond,
    ve_node.the_geom
   FROM ve_node
     JOIN inp_divider ON ve_node.node_id = inp_divider.node_id
  WHERE ve_node.is_operative = true;

CREATE OR REPLACE VIEW ve_inp_junction
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.ymax,
    n.elev,
    n.custom_elev,
    n.sys_elev,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    inp_junction.outfallparam::text AS outfallparam,
    n.the_geom
   FROM ve_node n
     JOIN inp_junction USING (node_id)
  WHERE n.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_inflows
AS SELECT s.dscenario_id,
    f.node_id,
    f.order_id,
    f.timser_id,
    f.sfactor,
    f.base,
    f.pattern_id
   FROM selector_inp_dscenario s,
    inp_dscenario_inflows f
     JOIN ve_inp_junction USING (node_id)
  WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW ve_inp_dscenario_inflows_poll
AS SELECT s.dscenario_id,
    f.node_id,
    f.poll_id,
    f.timser_id,
    f.form_type,
    f.mfactor,
    f.sfactor,
    f.base,
    f.pattern_id
   FROM selector_inp_dscenario s,
    inp_dscenario_inflows_poll f
     JOIN ve_inp_junction USING (node_id)
  WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW ve_inp_dscenario_junction
AS SELECT f.dscenario_id,
    f.node_id,
    f.elev,
    f.ymax,
    f.y0,
    f.ysur,
    f.apond,
    f.outfallparam,
    ve_inp_junction.the_geom
   FROM selector_inp_dscenario s,
    inp_dscenario_junction f
     JOIN ve_inp_junction USING (node_id)
  WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW ve_inp_dscenario_treatment
AS SELECT s.dscenario_id,
    f.node_id,
    f.poll_id,
    f.function
   FROM selector_inp_dscenario s,
    inp_dscenario_treatment f
     JOIN ve_inp_junction USING (node_id)
  WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW ve_inp_dwf
AS WITH inp_options_dwfscenario_current AS (
         SELECT config_param_user.value::integer AS dwfscenario_id
           FROM config_param_user
          WHERE config_param_user.cur_user::text = CURRENT_USER AND config_param_user.parameter::text = 'inp_options_dwfscenario_current'::text
         LIMIT 1
        )
 SELECT i.dwfscenario_id,
    i.node_id,
    i.value,
    i.pat1,
    i.pat2,
    i.pat3,
    i.pat4
   FROM inp_dwf i
     JOIN ve_inp_junction USING (node_id)
     JOIN inp_options_dwfscenario_current iodc ON iodc.dwfscenario_id = i.dwfscenario_id;

CREATE OR REPLACE VIEW ve_inp_inflows
AS SELECT inp_inflows.node_id,
    inp_inflows.order_id,
    inp_inflows.timser_id,
    inp_inflows.sfactor,
    inp_inflows.base,
    inp_inflows.pattern_id
   FROM inp_inflows
     JOIN ve_inp_junction USING (node_id);

CREATE OR REPLACE VIEW ve_inp_inflows_poll
AS SELECT inp_inflows_poll.node_id,
    inp_inflows_poll.poll_id,
    inp_inflows_poll.timser_id,
    inp_inflows_poll.form_type,
    inp_inflows_poll.mfactor,
    inp_inflows_poll.sfactor,
    inp_inflows_poll.base,
    inp_inflows_poll.pattern_id
   FROM inp_inflows_poll
     JOIN ve_inp_junction USING (node_id);

CREATE OR REPLACE VIEW ve_inp_treatment
AS SELECT inp_treatment.node_id,
    inp_treatment.poll_id,
    inp_treatment.function
   FROM inp_treatment
     JOIN ve_inp_junction USING (node_id);

CREATE OR REPLACE VIEW ve_inp_inlet
AS SELECT ve_node.node_id,
    ve_node.node_type,
    ve_node.top_elev,
    ve_node.ymax,
    ve_node.elev,
    ve_node.custom_elev,
    ve_node.sys_elev,
    ve_node.nodecat_id,
    ve_node.sector_id,
    ve_node.macrosector_id,
    ve_node.state,
    ve_node.state_type,
    ve_node.annotation,
    ve_node.expl_id,
    ve_node.the_geom,
    ve_node.ymax - COALESCE(ve_node.elev, 0::numeric) AS depth,
    inp_inlet.y0,
    inp_inlet.ysur,
    inp_inlet.apond,
    inp_inlet.inlet_type,
    inp_inlet.outlet_type,
    inp_inlet.gully_method,
    inp_inlet.custom_top_elev,
    inp_inlet.custom_depth,
    inp_inlet.inlet_length,
    inp_inlet.inlet_width,
    inp_inlet.cd1,
    inp_inlet.cd2,
    inp_inlet.efficiency
   FROM ve_node
     JOIN inp_inlet USING (node_id)
  WHERE ve_node.is_operative IS TRUE;

CREATE OR REPLACE VIEW ve_inp_dscenario_inlet
AS SELECT s.dscenario_id,
    f.node_id,
    f.y0,
    f.ysur,
    f.apond,
    f.inlet_type,
    f.outlet_type,
    f.gully_method,
    f.custom_top_elev,
    f.custom_depth,
    f.inlet_length,
    f.inlet_width,
    f.cd1,
    f.cd2,
    f.efficiency,
    ve_inp_inlet.the_geom
   FROM selector_inp_dscenario s,
    inp_dscenario_inlet f
     JOIN ve_inp_inlet USING (node_id)
  WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER;

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
