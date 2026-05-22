/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 21/05/2026
SELECT gw_fct_admin_manage_view_dependencies($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"action":"SAVE-DROP", "rootViews":["ve_node"], "batchId":1}}$$);

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

SELECT gw_fct_admin_manage_view_dependencies($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"action":"RESTORE", "batchId":1}}$$);

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
