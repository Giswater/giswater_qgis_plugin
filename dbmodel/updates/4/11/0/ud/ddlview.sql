/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 21/05/2026
SELECT gw_fct_admin_manage_view_dependencies($${"data":{"action":"SAVE-DROP", "rootViews":["ve_node"], "batchId":1}}$$);

-- recreate ve_node to add has_access column and remove varchar(16) from sector_type, omzone_type, drainzone_type, dwfzone_type
CREATE OR REPLACE VIEW ve_node
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            omzone.macroomzone_id,
            omzone.stylesheet,
            t.id AS omzone_type
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.stylesheet,
            t.id AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), dwfzone_table AS (
         SELECT dwfzone.dwfzone_id,
            dwfzone.stylesheet,
            t.id AS dwfzone_type,
            dwfzone.drainzone_id
           FROM dwfzone
             LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
        ), sector_visibility_agg AS (
         SELECT node_x_sector_visibility.node_id,
            array_agg(node_x_sector_visibility.sector_id ORDER BY node_x_sector_visibility.sector_id) AS sector_visibility
           FROM node_x_sector_visibility
          GROUP BY node_x_sector_visibility.node_id
        ), muni_visibility_agg AS (
         SELECT node_x_municipality_visibility.node_id,
            array_agg(node_x_municipality_visibility.muni_id ORDER BY node_x_municipality_visibility.muni_id) AS muni_visibility
           FROM node_x_municipality_visibility
          GROUP BY node_x_municipality_visibility.node_id
        )
 SELECT n.node_id,
    n.code,
    n.sys_code,
    n.top_elev,
    n.custom_top_elev,
    COALESCE(n.custom_top_elev, n.top_elev) AS sys_top_elev,
    n.ymax,
    COALESCE(COALESCE(n.custom_top_elev, n.top_elev) - COALESCE(n.custom_elev, n.elev), n.ymax) AS sys_ymax,
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
    vm.region_id,
    vm.province_id,
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
    vf.p_state,
    n.uuid,
    n.treatment_type,
    n.has_treatment,
    sva.sector_visibility,
    mva.muni_visibility,
    n.has_access
   FROM node n
     JOIN vf_node vf ON vf.node_id = n.node_id
     JOIN cat_node ON n.nodecat_id::text = cat_node.id::text
     JOIN cat_feature ON cat_feature.id::text = n.node_type::text
     JOIN exploitation ON n.expl_id = exploitation.expl_id
     JOIN v_municipality vm ON n.muni_id = vm.muni_id
     JOIN value_state_type vst ON vst.id = n.state_type
     JOIN sector_table ON sector_table.sector_id = n.sector_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = n.omzone_id
     LEFT JOIN drainzone_table ON n.omzone_id = drainzone_table.drainzone_id
     LEFT JOIN dwfzone_table ON n.dwfzone_id = dwfzone_table.dwfzone_id
     LEFT JOIN node_add ON node_add.node_id = n.node_id
     LEFT JOIN sector_visibility_agg sva ON sva.node_id = n.node_id
     LEFT JOIN muni_visibility_agg mva ON mva.node_id = n.node_id;

SELECT gw_fct_admin_manage_view_dependencies($${"data":{"action":"RESTORE", "batchId":1}}$$);

SELECT gw_fct_admin_manage_view_dependencies($${"data":{"action":"SAVE-DROP", "rootViews":["ve_arc"], "batchId":2}}$$);

CREATE OR REPLACE VIEW ve_arc
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            omzone.macroomzone_id,
            omzone.stylesheet,
            t.id AS omzone_type
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.stylesheet,
            t.id AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), dwfzone_table AS (
         SELECT dwfzone.dwfzone_id,
            dwfzone.stylesheet,
            t.id AS dwfzone_type,
            dwfzone.drainzone_id
           FROM dwfzone
             LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
        )
 SELECT a.arc_id,
    a.code,
    a.sys_code,
    a.node_1,
    a.nodetype_1,
    a.node_top_elev_1,
    a.node_custom_top_elev_1,
    COALESCE(a.node_custom_top_elev_1, a.node_top_elev_1) AS node_sys_top_elev_1,
    a.elev1,
    a.custom_elev1,
    COALESCE(a.custom_elev1, a.elev1, a.node_custom_elev_1, a.node_elev_1) AS sys_elev1,
    a.y1,
    COALESCE(COALESCE(a.node_custom_top_elev_1, a.node_top_elev_1) - COALESCE(a.custom_elev1, a.elev1, a.node_custom_elev_1, a.node_elev_1), a.y1) AS sys_y1,
    COALESCE(COALESCE(a.node_custom_top_elev_1, a.node_top_elev_1) - COALESCE(a.custom_elev1, a.elev1, a.node_custom_elev_1, a.node_elev_1), a.y1) - cat_arc.geom1 AS r1,
    COALESCE(a.custom_elev1, a.elev1, a.node_custom_elev_1, a.node_elev_1) - COALESCE(a.node_custom_elev_1, a.node_elev_1) AS z1,
    a.node_2,
    a.nodetype_2,
    a.node_top_elev_2,
    a.node_custom_top_elev_2,
    COALESCE(a.node_custom_top_elev_2, a.node_top_elev_2) AS node_sys_top_elev_2,
    a.elev2,
    a.custom_elev2,
    COALESCE(a.custom_elev2, a.elev2, a.node_custom_elev_2, a.node_elev_2) AS sys_elev2,
    a.y2,
    COALESCE(COALESCE(a.node_custom_top_elev_2, a.node_top_elev_2) - COALESCE(a.custom_elev2, a.elev2, a.node_custom_elev_2, a.node_elev_2), a.y2) AS sys_y2,
    COALESCE(COALESCE(a.node_custom_top_elev_2, a.node_top_elev_2) - COALESCE(a.custom_elev2, a.elev2, a.node_custom_elev_2, a.node_elev_2), a.y2) - cat_arc.geom1 AS r2,
    COALESCE(a.custom_elev2, a.elev2, a.node_custom_elev_2, a.node_elev_2) - COALESCE(a.node_custom_elev_2, a.node_elev_2) AS z2,
    cat_feature.feature_class AS sys_type,
    a.arc_type::text AS arc_type,
    a.arccat_id,
    COALESCE(a.matcat_id, cat_arc.matcat_id) AS matcat_id,
    cat_arc.shape AS cat_shape,
    cat_arc.geom1 AS cat_geom1,
    cat_arc.geom2 AS cat_geom2,
    cat_arc.width AS cat_width,
    cat_arc.area AS cat_area,
    a.epa_type,
    a.state,
    a.state_type,
    a.parent_id,
    a.expl_id,
    e.macroexpl_id,
    a.muni_id,
    a.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    dwfzone_table.drainzone_id,
    drainzone_table.drainzone_type,
    a.drainzone_outfall,
    a.dwfzone_id,
    dwfzone_table.dwfzone_type,
    a.dwfzone_outfall,
    a.omzone_id,
    omzone_table.macroomzone_id,
    a.dma_id,
    omzone_table.omzone_type,
    a.omunit_id,
    a.minsector_id,
    a.pavcat_id,
    a.soilcat_id,
    a.function_type,
    a.category_type,
    a.location_type,
    a.fluid_type,
    a.custom_length,
    st_length(a.the_geom)::numeric(12,2) AS gis_length,
        CASE
            WHEN a.sys_slope IS NULL THEN ((COALESCE(a.node_custom_elev_1, a.node_elev_1, a.elev1, a.node_top_elev_1 - a.y1, a.node_elev_1) - COALESCE(a.node_custom_elev_2, a.node_elev_2, a.elev2, a.node_top_elev_2 - a.y2, a.node_elev_2))::double precision / st_length(a.the_geom))::numeric(12,4)
            ELSE a.sys_slope
        END AS slope,
    a.descript,
    a.annotation,
    a.observ,
    a.comment,
    concat(cat_feature.link_path, a.link) AS link,
    a.num_value,
    a.district_id,
    a.postcode,
    a.streetaxis_id,
    a.postnumber,
    a.postcomplement,
    a.streetaxis2_id,
    a.postnumber2,
    a.postcomplement2,
    vm.region_id,
    vm.province_id,
    a.workcat_id,
    a.workcat_id_end,
    a.workcat_id_plan,
    a.builtdate,
    a.registration_date,
    a.enddate,
    a.ownercat_id,
    a.last_visitdate,
    a.visitability,
    a.om_state,
    a.conserv_state,
    a.brand_id,
    a.model_id,
    a.serial_number,
    a.asset_id,
    a.adate,
    a.adescript,
    a.verified,
    a.uncertain,
    a.datasource,
    cat_arc.label,
    a.label_x,
    a.label_y,
    a.label_rotation,
    a.label_quadrant,
    a.inventory,
    a.publish,
    vst.is_operative,
    a.is_scadamap,
        CASE
            WHEN a.sector_id > 0 AND vst.is_operative = true AND a.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN a.epa_type
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
    a.lock_level,
    a.initoverflowpath,
    a.inverted_slope,
    a.negative_offset,
    a.expl_visibility,
    date_trunc('second'::text, a.created_at) AS created_at,
    a.created_by,
    date_trunc('second'::text, a.updated_at) AS updated_at,
    a.updated_by,
    a.the_geom,
    a.meandering,
    vf.p_state,
    a.uuid,
    a.treatment_type
   FROM arc a
     JOIN vf_arc vf ON vf.arc_id = a.arc_id
     JOIN cat_arc ON a.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON a.arc_type::text = cat_feature.id::text
     JOIN exploitation e ON e.expl_id = a.expl_id
     JOIN v_municipality vm ON a.muni_id = vm.muni_id
     JOIN value_state_type vst ON vst.id = a.state_type
     JOIN sector_table ON sector_table.sector_id = a.sector_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = a.omzone_id
     LEFT JOIN drainzone_table ON a.omzone_id = drainzone_table.drainzone_id
     LEFT JOIN dwfzone_table ON a.dwfzone_id = dwfzone_table.dwfzone_id
     LEFT JOIN arc_add ON arc_add.arc_id = a.arc_id;

SELECT gw_fct_admin_manage_view_dependencies($${"data":{"action":"RESTORE", "batchId":2}}$$);

SELECT gw_fct_admin_manage_view_dependencies($${"data":{"action":"SAVE-DROP", "rootViews":["ve_connec"], "batchId":3}}$$);


CREATE OR REPLACE VIEW ve_connec
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            omzone.macroomzone_id,
            omzone.stylesheet,
            t.id AS omzone_type
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.stylesheet,
            t.id AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), dwfzone_table AS (
         SELECT dwfzone.dwfzone_id,
            dwfzone.stylesheet,
            t.id AS dwfzone_type,
            dwfzone.drainzone_id
           FROM dwfzone
             LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
        )
 SELECT c.connec_id,
    c.code,
    c.sys_code,
    c.top_elev,
    c.y1,
    c.y2,
    cat_feature.feature_class AS sys_type,
    c.connec_type::text AS connec_type,
    c.matcat_id,
    c.conneccat_id,
    c.customer_code,
    c.connec_depth,
    c.connec_length,
    c.state,
    c.state_type,
    vf.arc_id,
    c.expl_id,
    exploitation.macroexpl_id,
    c.muni_id,
    c.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    dwfzone_table.drainzone_id,
    drainzone_table.drainzone_type,
    c.drainzone_outfall,
    c.dwfzone_id,
    dwfzone_table.dwfzone_type,
    c.dwfzone_outfall,
    c.omzone_id,
    omzone_table.macroomzone_id,
    omzone_table.omzone_type,
    c.dma_id,
    c.omunit_id,
    c.minsector_id,
    c.soilcat_id,
    c.function_type,
    c.category_type,
    c.location_type,
    c.fluid_type,
    c.n_hydrometer,
    c.n_inhabitants,
    c.demand,
    c.descript,
    c.annotation,
    c.observ,
    c.comment,
    c.link::text AS link,
    c.num_value,
    c.district_id,
    c.postcode,
    c.streetaxis_id,
    c.postnumber,
    c.postcomplement,
    c.streetaxis2_id,
    c.postnumber2,
    c.postcomplement2,
    vm.region_id,
    vm.province_id,
    c.block_code,
    c.plot_id,
    c.workcat_id,
    c.workcat_id_end,
    c.workcat_id_plan,
    c.builtdate,
    c.enddate,
    c.ownercat_id,
    c.om_state,
    vf.pjoint_id,
    vf.pjoint_type,
    c.access_type,
    c.placement_type,
    c.accessibility,
    c.brand_id,
    c.model_id,
    c.asset_id,
    c.adate,
    c.adescript,
    c.verified,
    c.uncertain,
    c.datasource,
    cat_connec.label,
    c.label_x,
    c.label_y,
    c.label_rotation,
    c.rotation,
    c.label_quadrant,
    cat_connec.svg,
    c.inventory,
    c.publish,
    vst.is_operative,
    sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
    drainzone_table.stylesheet ->> 'featureColor'::text AS drainzone_style,
    dwfzone_table.stylesheet ->> 'featureColor'::text AS dwfzone_style,
    omzone_table.stylesheet ->> 'featureColor'::text AS omzone_style,
    c.lock_level,
    c.expl_visibility,
    ( SELECT st_x(c.the_geom) AS st_x) AS xcoord,
    ( SELECT st_y(c.the_geom) AS st_y) AS ycoord,
    ( SELECT st_y(st_transform(c.the_geom, 4326)) AS st_y) AS lat,
    ( SELECT st_x(st_transform(c.the_geom, 4326)) AS st_x) AS long,
    date_trunc('second'::text, c.created_at) AS created_at,
    c.created_by,
    date_trunc('second'::text, c.updated_at) AS updated_at,
    c.updated_by,
    c.the_geom,
    c.diagonal,
    vf.p_state,
    c.uuid,
    c.treatment_type,
    c.xyz_date,
    c.has_treatment
   FROM connec c
     JOIN vf_connec vf ON vf.connec_id = c.connec_id
     JOIN cat_connec ON cat_connec.id::text = c.conneccat_id::text
     JOIN cat_feature ON cat_feature.id::text = c.connec_type::text
     JOIN exploitation ON c.expl_id = exploitation.expl_id
     JOIN v_municipality vm ON c.muni_id = vm.muni_id
     JOIN value_state_type vst ON vst.id = c.state_type
     JOIN sector_table ON sector_table.sector_id = c.sector_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = c.omzone_id
     LEFT JOIN drainzone_table ON c.omzone_id = drainzone_table.drainzone_id
     LEFT JOIN dwfzone_table ON c.dwfzone_id = dwfzone_table.dwfzone_id;

SELECT gw_fct_admin_manage_view_dependencies($${"data":{"action":"RESTORE", "batchId":3}}$$);

SELECT gw_fct_admin_manage_view_dependencies($${"data":{"action":"SAVE-DROP", "rootViews":["ve_link"], "batchId":4}}$$);

CREATE OR REPLACE VIEW ve_link
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            omzone.macroomzone_id,
            omzone.stylesheet,
            t.id AS omzone_type
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.stylesheet,
            t.id AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), dwfzone_table AS (
         SELECT dwfzone.dwfzone_id,
            dwfzone.stylesheet,
            t.id AS dwfzone_type,
            dwfzone.drainzone_id
           FROM dwfzone
             LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
        ), inp_network_mode AS (
         SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        )
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
    cat_link.matcat_id,
    cat_link.dnom AS cat_dnom,
    cat_link.dint AS cat_dint,
    cat_link.pnom AS cat_pnom,
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
    vf.p_state,
    l.uuid,
    l.omunit_id,
    l.treatment_type
   FROM link l
     JOIN vf_link vf ON vf.link_id = l.link_id
     JOIN exploitation ON l.expl_id = exploitation.expl_id
     JOIN sector_table ON l.sector_id = sector_table.sector_id
     JOIN cat_link ON cat_link.id::text = l.linkcat_id::text
     JOIN cat_feature ON cat_feature.id::text = l.link_type::text
     LEFT JOIN omzone_table ON l.omzone_id = omzone_table.omzone_id
     LEFT JOIN drainzone_table ON l.omzone_id = drainzone_table.drainzone_id
     LEFT JOIN dwfzone_table ON l.dwfzone_id = dwfzone_table.dwfzone_id
     LEFT JOIN inp_network_mode ON true;


SELECT gw_fct_admin_manage_view_dependencies($${"data":{"action":"RESTORE", "batchId":4}}$$);

SELECT gw_fct_admin_manage_view_dependencies($${"data":{"action":"SAVE-DROP", "rootViews":["ve_gully"], "batchId":5}}$$);

CREATE OR REPLACE VIEW ve_gully
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'drainzone_type'::character varying::text, 'omzone_type'::character varying::text, 'dwfzone_type'::character varying::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            omzone.macroomzone_id,
            omzone.stylesheet,
            t.id AS omzone_type
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), drainzone_table AS (
         SELECT drainzone.drainzone_id,
            drainzone.stylesheet,
            t.id AS drainzone_type
           FROM drainzone
             LEFT JOIN typevalue t ON t.id::text = drainzone.drainzone_type::text AND t.typevalue::text = 'drainzone_type'::text
        ), dwfzone_table AS (
         SELECT dwfzone.dwfzone_id,
            dwfzone.stylesheet,
            t.id AS dwfzone_type,
            dwfzone.drainzone_id
           FROM dwfzone
             LEFT JOIN typevalue t ON t.id::text = dwfzone.dwfzone_type::text AND t.typevalue::text = 'dwfzone_type'::text
        ), inp_network_mode AS (
         SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        )
 SELECT gully.gully_id,
    gully.code,
    gully.sys_code,
    gully.top_elev,
    COALESCE(gully.width, cat_gully.width) AS width,
    COALESCE(gully.length, cat_gully.length) AS length,
    COALESCE(gully.ymax, cat_gully.ymax) AS ymax,
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
    COALESCE(((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric)::numeric(12,3), gully.connec_depth) AS connec_depth,
    COALESCE(gully._connec_matcat_id, cc.matcat_id::text) AS connec_matcat_id,
    gully.top_elev - gully.ymax + gully.sandbox AS connec_y1,
    gully.connec_y2,
    vf.arc_id,
    gully.epa_type,
    gully.state,
    gully.state_type,
    gully.expl_id,
    exploitation.macroexpl_id,
    gully.muni_id,
    sector_table.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    dwfzone_table.drainzone_id,
    drainzone_table.drainzone_type,
    gully.drainzone_outfall,
    dwfzone_table.dwfzone_id,
    dwfzone_table.dwfzone_type,
    gully.dwfzone_outfall,
    omzone_table.omzone_id,
    omzone_table.macroomzone_id,
    gully.dma_id,
    omzone_table.omzone_type,
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
    vm.region_id,
    vm.province_id,
    gully.workcat_id,
    gully.workcat_id_end,
    gully.workcat_id_plan,
    gully.builtdate,
    gully.enddate,
    gully.ownercat_id,
    gully.om_state,
    vf.pjoint_id,
    vf.pjoint_type,
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
    vf.p_state,
    gully.uuid,
    gully.treatment_type,
    gully.xyz_date,
    gully.has_treatment
   FROM gully
     JOIN vf_gully vf ON vf.gully_id = gully.gully_id
     JOIN cat_gully ON gully.gullycat_id::text = cat_gully.id::text
     JOIN exploitation ON gully.expl_id = exploitation.expl_id
     JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
     LEFT JOIN cat_connec cc ON cc.id::text = gully._connec_arccat_id::text
     JOIN value_state_type vst ON vst.id = gully.state_type
     JOIN v_municipality vm ON gully.muni_id = vm.muni_id
     JOIN sector_table ON gully.sector_id = sector_table.sector_id
     LEFT JOIN omzone_table ON gully.omzone_id = omzone_table.omzone_id
     LEFT JOIN drainzone_table ON gully.omzone_id = drainzone_table.drainzone_id
     LEFT JOIN dwfzone_table ON gully.dwfzone_id = dwfzone_table.dwfzone_id
     LEFT JOIN inp_network_mode ON true;

SELECT gw_fct_admin_manage_view_dependencies($${"data":{"action":"RESTORE", "batchId":5}}$$);


CREATE OR REPLACE VIEW ve_omunit
AS WITH sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT DISTINCT ON (omunit_id) omunit_id,
    node_1,
    node_2,
    macroomunit_id,
    order_number,
    expl_id,
    muni_id,
    sector_id,
    the_geom
   FROM omunit o
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = ANY (o.expl_id))) AND omunit_id > 0
  ORDER BY omunit_id;

CREATE OR REPLACE VIEW ve_macroomunit
AS WITH sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT DISTINCT ON (macroomunit_id) macroomunit_id,
    node_1,
    node_2,
    catchment_node,
    order_number,
    expl_id,
    muni_id,
    sector_id,
    the_geom
   FROM macroomunit m
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = ANY (m.expl_id))) AND macroomunit_id > 0
  ORDER BY macroomunit_id;
