/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/07/27
CREATE OR REPLACE VIEW vu_node AS 
 WITH vu_node AS (
         SELECT node.node_id,
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
            node.expl_id,
            exploitation.macroexpl_id,
            node.sector_id,
            sector.macrosector_id,
            node.state,
            node.state_type,
            node.annotation,
            node.observ,
            node.comment,
            node.dma_id,
            dma.macrodma_id,
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
            c.descript::varchar(100) AS streetname,
            node.postnumber,
            node.postcomplement,
            d.descript::varchar(100) AS streetname2,
            node.postnumber2,
            node.postcomplement2,
            node.descript,
            cat_node.svg,
            node.rotation,
            concat(cat_feature.link_path, node.link) AS link,
            node.verified,
            node.undelete,
            cat_node.label,
            node.label_x,
            node.label_y,
            node.label_rotation,
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
            node.the_geom,
            node.workcat_id_plan,
            node.asset_id
           FROM node
             LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
             LEFT JOIN cat_feature ON cat_feature.id::text = node.node_type::text
             LEFT JOIN dma ON node.dma_id = dma.dma_id
             LEFT JOIN sector ON node.sector_id = sector.sector_id
             LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
             LEFT JOIN v_ext_streetaxis c ON c.id::text = node.streetaxis_id::text
             LEFT JOIN v_ext_streetaxis d ON d.id::text = node.streetaxis2_id::text
        )
 SELECT vu_node.node_id,
    vu_node.code,
    vu_node.top_elev,
    vu_node.custom_top_elev,
    vu_node.sys_top_elev,
    vu_node.ymax,
    vu_node.custom_ymax,
        CASE
            WHEN vu_node.sys_ymax IS NOT NULL THEN vu_node.sys_ymax
            ELSE (vu_node.sys_top_elev - vu_node.sys_elev)::numeric(12,3)
        END AS sys_ymax,
    vu_node.elev,
    vu_node.custom_elev,
        CASE
            WHEN vu_node.sys_elev IS NOT NULL THEN vu_node.sys_elev
            ELSE (vu_node.sys_top_elev - vu_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    vu_node.node_type,
    vu_node.sys_type,
    vu_node.nodecat_id,
    vu_node.matcat_id,
    vu_node.epa_type,
    vu_node.expl_id,
    vu_node.macroexpl_id,
    vu_node.sector_id,
    vu_node.macrosector_id,
    vu_node.state,
    vu_node.state_type,
    vu_node.annotation,
    vu_node.observ,
    vu_node.comment,
    vu_node.dma_id,
    vu_node.macrodma_id,
    vu_node.soilcat_id,
    vu_node.function_type,
    vu_node.category_type,
    vu_node.fluid_type,
    vu_node.location_type,
    vu_node.workcat_id,
    vu_node.workcat_id_end,
    vu_node.buildercat_id,
    vu_node.builtdate,
    vu_node.enddate,
    vu_node.ownercat_id,
    vu_node.muni_id,
    vu_node.postcode,
    vu_node.district_id,
    vu_node.streetname,
    vu_node.postnumber,
    vu_node.postcomplement,
    vu_node.streetname2,
    vu_node.postnumber2,
    vu_node.postcomplement2,
    vu_node.descript,
    vu_node.svg,
    vu_node.rotation,
    vu_node.link,
    vu_node.verified,
    vu_node.the_geom,
    vu_node.undelete,
    vu_node.label,
    vu_node.label_x,
    vu_node.label_y,
    vu_node.label_rotation,
    vu_node.publish,
    vu_node.inventory,
    vu_node.uncertain,
    vu_node.xyz_date,
    vu_node.unconnected,
    vu_node.num_value,
    vu_node.tstamp,
    vu_node.insert_user,
    vu_node.lastupdate,
    vu_node.lastupdate_user,
    vu_node.workcat_id_plan,
    vu_node.asset_id
   FROM vu_node;


CREATE OR REPLACE VIEW vu_connec AS 
 SELECT connec.connec_id,
    connec.code,
    connec.customer_code,
    connec.top_elev,
    connec.y1,
    connec.y2,
    connec.connecat_id,
    connec.connec_type,
    cat_feature.system_id AS sys_type,
    connec.private_connecat_id,
        CASE
            WHEN connec.matcat_id IS NULL THEN cat_connec.matcat_id
            ELSE connec.matcat_id
        END AS matcat_id,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
    sector.macrosector_id,
    connec.demand,
    connec.state,
    connec.state_type,
    connec.connec_depth,
    connec.connec_length,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.dma_id,
    dma.macrodma_id,
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
    c.descript::varchar(100) AS streetname,
    connec.postnumber,
    connec.postcomplement,
    d.descript::varchar(100) AS streetname2,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    cat_connec.svg,
    connec.rotation,
    concat(cat_feature.link_path, connec.link) AS link,
    connec.verified,
    connec.undelete,
    cat_connec.label,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.accessibility,
    connec.diagonal,
    connec.publish,
    connec.inventory,
    connec.uncertain,
    connec.num_value,
    connec.pjoint_id,
    connec.pjoint_type,
    date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom,
    connec.workcat_id_plan,
    connec.asset_id
   FROM connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN cat_feature ON connec.connec_type::text = cat_feature.id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = connec.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = connec.streetaxis2_id::text;


CREATE OR REPLACE VIEW vu_gully AS 
 SELECT gully.gully_id,
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
    gully.siphon,
    gully.connec_arccat_id,
    gully.connec_length,
    gully.connec_depth,
    gully.arc_id,
    gully.expl_id,
    exploitation.macroexpl_id,
    gully.sector_id,
    sector.macrosector_id,
    gully.state,
    gully.state_type,
    gully.annotation,
    gully.observ,
    gully.comment,
    gully.dma_id,
    dma.macrodma_id,
    gully.soilcat_id,
    gully.function_type,
    gully.category_type,
    gully.fluid_type,
    gully.location_type,
    gully.workcat_id,
    gully.workcat_id_end,
    gully.buildercat_id,
    gully.builtdate,
    gully.enddate,
    gully.ownercat_id,
    gully.muni_id,
    gully.postcode,
    gully.district_id,
    c.descript::varchar(100) AS streetname,
    gully.postnumber,
    gully.postcomplement,
    d.descript::varchar(100) AS streetname2,
    gully.postnumber2,
    gully.postcomplement2,
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
    gully.publish,
    gully.inventory,
    gully.uncertain,
    gully.num_value,
    gully.pjoint_id,
    gully.pjoint_type,
    date_trunc('second'::text, gully.tstamp) AS tstamp,
    gully.insert_user,
    date_trunc('second'::text, gully.lastupdate) AS lastupdate,
    gully.lastupdate_user,
    gully.the_geom,
    gully.workcat_id_plan,
    gully.asset_id
   FROM gully
     LEFT JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
     LEFT JOIN ext_streetaxis ON gully.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON gully.dma_id = dma.dma_id
     LEFT JOIN sector ON gully.sector_id = sector.sector_id
     LEFT JOIN exploitation ON gully.expl_id = exploitation.expl_id
     LEFT JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = gully.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = gully.streetaxis2_id::text;


CREATE OR REPLACE VIEW vu_arc AS 
 WITH vu_node AS (
         SELECT node.node_id,
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
                    WHEN node.custom_elev IS NOT NULL THEN node.custom_elev
                    WHEN node.elev IS NOT NULL AND node.custom_elev IS NULL THEN node.elev
                    WHEN node.custom_ymax IS NOT NULL THEN
                    CASE
                        WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev - node.custom_ymax
                        ELSE node.top_elev - node.custom_ymax
                    END
                    WHEN node.ymax IS NOT NULL THEN
                    CASE
                        WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev - node.ymax
                        ELSE node.top_elev - node.ymax
                    END
                    ELSE NULL::numeric(12,3)
                END AS sys_elev,
                CASE
                    WHEN node.matcat_id IS NULL THEN cat_node.matcat_id
                    ELSE node.matcat_id
                END AS matcat_id,
            node.node_type,
            exploitation.macroexpl_id
           FROM node
             LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
             LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
        )
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    a.node_type AS nodetype_1,
    arc.y1,
    arc.custom_y1,
    arc.elev1,
    arc.custom_elev1,
    arc.sys_elev1,
    a.sys_top_elev - arc.sys_elev1 AS sys_y1,
    a.sys_top_elev - arc.sys_elev1 - cat_arc.geom1 AS r1,
        CASE
            WHEN a.sys_elev IS NOT NULL THEN arc.sys_elev1 - a.sys_elev
            ELSE (arc.sys_elev1 - (a.sys_top_elev - a.sys_ymax))::numeric(12,3)
        END AS z1,
    arc.node_2,
    a.node_type AS nodetype_2,
    arc.y2,
    arc.custom_y2,
    arc.elev2,
    arc.custom_elev2,
    arc.sys_elev2,
    b.sys_top_elev - arc.sys_elev2 AS sys_y2,
    b.sys_top_elev - arc.sys_elev2 - cat_arc.geom1 AS r2,
        CASE
            WHEN b.sys_elev IS NOT NULL THEN arc.sys_elev2 - b.sys_elev
            ELSE (arc.sys_elev2 - (b.sys_top_elev - b.sys_ymax))::numeric(12,3)
        END AS z2,
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
    cat_arc.width,
    arc.epa_type,
    arc.expl_id,
    a.macroexpl_id,
    arc.sector_id,
    sector.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    st_length(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.inverted_slope,
    arc.observ,
    arc.comment,
    arc.dma_id,
    dma.macrodma_id,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.builtdate,
    arc.enddate,
    arc.buildercat_id,
    arc.ownercat_id,
    arc.muni_id,
    arc.postcode,
    arc.district_id,
    c.descript::varchar(100) AS streetname,
    arc.postnumber,
    arc.postcomplement,
    d.descript::varchar(100) AS streetname2,
    arc.postnumber2,
    arc.postcomplement2,
    arc.descript,
    concat(cat_feature.link_path, arc.link) AS link,
    arc.verified,
    arc.undelete,
    cat_arc.label,
    arc.label_x,
    arc.label_y,
    arc.label_rotation,
    arc.publish,
    arc.inventory,
    arc.uncertain,
    arc.num_value,
    date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
    arc.workcat_id_plan,
    arc.asset_id
   FROM arc
     JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     LEFT JOIN vu_node a ON a.node_id::text = arc.node_1::text
     LEFT JOIN vu_node b ON b.node_id::text = arc.node_2::text
     JOIN sector ON sector.sector_id = arc.sector_id
     JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
     JOIN dma ON arc.dma_id = dma.dma_id
     LEFT JOIN v_ext_streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text;
	 
	 

CREATE OR REPLACE VIEW v_edit_link AS 
WITH query_text as (
SELECT * FROM (SELECT link.link_id,
            link.feature_type,
            link.feature_id,
            sector.macrosector_id,
            dma.macrodma_id,
            link.exit_type,
            link.exit_id,
            link.vnode_topelev,
            c.fluid_type,
            arc.sector_id,
            arc.dma_id,
            arc.expl_id,
            c.state,
            st_length2d(link.the_geom) AS gis_length,
            link.userdefined_geom,
            link.the_geom,
            1 AS link_class,
            NULL::integer AS psector_rowid
           FROM selector_state,
            v_edit_connec c
             LEFT JOIN link ON link.feature_id::text = c.connec_id::text
             LEFT JOIN arc USING (arc_id)
             LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
          WHERE selector_state.cur_user = "current_user"()::text AND selector_state.state_id = c.state
        UNION
         SELECT link.link_id,
            link.feature_type,
            link.feature_id,
            sector.macrosector_id,
            dma.macrodma_id,
            link.exit_type,
            link.exit_id,
            link.vnode_topelev,
            c.fluid_type,
            arc.sector_id,
            arc.dma_id,
            arc.expl_id,
            c.state,
            st_length2d(link.the_geom) AS gis_length,
            link.userdefined_geom,
            link.the_geom,
            1 AS link_class,
            NULL::integer AS psector_rowid
           FROM selector_state,
            v_edit_gully c
             LEFT JOIN link ON link.feature_id::text = c.gully_id::text
             LEFT JOIN arc USING (arc_id)
             LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
          WHERE selector_state.cur_user = "current_user"()::text AND selector_state.state_id = c.state
        UNION
         SELECT l.link_id,
            l.feature_type,
            l.feature_id,
            sector.macrosector_id,
            dma.macrodma_id,
            l.exit_type,
            l.exit_id,
            l.vnode_topelev,
            c.fluid_type,
            a_1.sector_id,
            a_1.dma_id,
            a_1.expl_id,
            p.state,
                CASE
                    WHEN p.link_geom IS NULL THEN st_length2d(l.the_geom)
                    ELSE st_length2d(p.link_geom)
                END AS gis_length,
                CASE
                    WHEN p.userdefined_geom IS NULL THEN l.userdefined_geom
                    ELSE p.userdefined_geom
                END AS userdefined_geom,
                CASE
                    WHEN p.link_geom IS NULL THEN l.the_geom
                    ELSE p.link_geom
                END AS the_geom,
                CASE
                    WHEN p.link_geom IS NULL THEN 2
                    ELSE 3
                END AS link_class,
            p.id AS psector_rowid
           FROM link l,
            selector_psector s,
            selector_expl e,
            plan_psector_x_connec p
             JOIN connec c USING (connec_id)
             LEFT JOIN arc a_1 ON a_1.arc_id::text = p.arc_id::text
             LEFT JOIN sector ON sector.sector_id::text = a_1.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = a_1.dma_id::text
          WHERE l.feature_id::text = p.connec_id::text AND p.state = 1 AND s.psector_id = p.psector_id AND s.cur_user = CURRENT_USER::text AND e.expl_id = c.expl_id AND e.cur_user = CURRENT_USER::text
        UNION
         SELECT l.link_id,
            l.feature_type,
            l.feature_id,
            sector.macrosector_id,
            dma.macrodma_id,
            l.exit_type,
            l.exit_id,
            l.vnode_topelev,
            g.fluid_type,
            a_1.sector_id,
            a_1.dma_id,
            a_1.expl_id,
            p.state,
                CASE
                    WHEN p.link_geom IS NULL THEN st_length2d(l.the_geom)
                    ELSE st_length2d(p.link_geom)
                END AS gis_length,
                CASE
                    WHEN p.userdefined_geom IS NULL THEN l.userdefined_geom
                    ELSE p.userdefined_geom
                END AS userdefined_geom,
                CASE
                    WHEN p.link_geom IS NULL THEN l.the_geom
                    ELSE p.link_geom
                END AS the_geom,
                CASE
                    WHEN p.link_geom IS NULL THEN 2
                    ELSE 3
                END AS link_class,
            p.id AS psector_rowid
           FROM link l,
            selector_expl e,
            selector_psector s,
            plan_psector_x_gully p
             JOIN gully g USING (gully_id)
             LEFT JOIN arc a_1 ON a_1.arc_id::text = p.arc_id::text
             LEFT JOIN sector ON sector.sector_id::text = a_1.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = a_1.dma_id::text
          WHERE l.feature_id::text = p.gully_id::text AND p.state = 1 AND s.psector_id = p.psector_id AND s.cur_user = CURRENT_USER::text 
		  AND e.expl_id = g.expl_id AND e.cur_user = CURRENT_USER::text) a)
 SELECT 
    a.link_id,
    a.feature_type,
    a.feature_id,
    a.macrosector_id,
    a.macrodma_id,
    a.exit_type,
    a.exit_id,
    a.sector_id,
    a.dma_id,
    a.expl_id,
    a.state,
    a.gis_length,
    a.userdefined_geom,
    a.the_geom,
    a.link_class,
    a.psector_rowid,
    a.fluid_type,
    a.vnode_topelev
    FROM query_text a
    JOIN (SELECT link_id, max(link_class) link_class FROM query_text GROUP BY link_id) b USING (link_id)
    WHERE a.link_class = b.link_class;