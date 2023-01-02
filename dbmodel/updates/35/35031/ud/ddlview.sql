/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_anl_graphanalytics_mapzones AS 
 SELECT temp_anlgraph.arc_id,
    temp_anlgraph.node_1,
    temp_anlgraph.node_2,
    temp_anlgraph.flag,
    a2.flag AS flagi,
    a2.value,
    a2.trace
   FROM temp_anlgraph
     JOIN ( SELECT temp_anlgraph_1.arc_id,
            temp_anlgraph_1.node_1,
            temp_anlgraph_1.node_2,
            temp_anlgraph_1.water,
            temp_anlgraph_1.flag,
            temp_anlgraph_1.checkf,
            temp_anlgraph_1.value,
            temp_anlgraph_1.trace
           FROM temp_anlgraph temp_anlgraph_1
          WHERE temp_anlgraph_1.water = 1) a2 ON temp_anlgraph.node_1::text = a2.node_2::text
  WHERE temp_anlgraph.flag < 2 AND temp_anlgraph.water = 0 AND a2.flag = 0;



CREATE OR REPLACE VIEW vu_arc AS 
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    nodetype_1,
    arc.y1,
    arc.custom_y1,
    arc.elev1,
    arc.custom_elev1,
    (CASE WHEN arc.sys_elev1 IS NULL THEN node_sys_elev_1::numeric(12,3) ELSE arc.sys_elev1 END) AS sys_elev1,
    CASE WHEN (CASE WHEN arc.custom_y1 IS NULL THEN y1::numeric(12,3) ELSE custom_y1 END) IS NULL THEN (node_sys_top_elev_1 - arc.sys_elev1)
	ELSE  (CASE WHEN arc.custom_y1 IS NULL THEN y1::numeric(12,3) ELSE custom_y1 END) END AS sys_y1,
    node_sys_top_elev_1 - (CASE WHEN arc.sys_elev1 IS NULL THEN node_sys_elev_1::numeric(12,3) ELSE arc.sys_elev1 END) - cat_arc.geom1 AS r1,
    (CASE WHEN arc.sys_elev1 IS NULL THEN node_sys_elev_1::numeric(12,3) ELSE arc.sys_elev1 END) - node_sys_elev_1 AS z1,
    arc.node_2,
    nodetype_2,
    arc.y2,
    arc.custom_y2,
    arc.elev2,
    arc.custom_elev2,
   (CASE WHEN arc.sys_elev2 IS NULL THEN node_sys_elev_2::numeric(12,3) ELSE arc.sys_elev2 END) AS sys_elev2,
    CASE WHEN (CASE WHEN arc.custom_y2 IS NULL THEN y2::numeric(12,3) ELSE custom_y2 END) IS NULL THEN (node_sys_top_elev_2 - arc.sys_elev2)
	ELSE  (CASE WHEN arc.custom_y2 IS NULL THEN y2::numeric(12,3) ELSE custom_y2 END) END AS sys_y2,
    node_sys_top_elev_2 - (CASE WHEN arc.sys_elev2 IS NULL THEN node_sys_elev_2::numeric(12,3) ELSE arc.sys_elev2 END) - cat_arc.geom2 AS r2,
    (CASE WHEN arc.sys_elev2 IS NULL THEN node_sys_elev_2::numeric(12,3) ELSE arc.sys_elev2 END) - node_sys_elev_2 AS z2,
    arc.sys_slope AS slope,
    arc.arc_type,
    cat_feature.system_id AS sys_type,
    arc.arccat_id,
    (CASE WHEN arc.matcat_id IS NULL THEN cat_arc.matcat_id ELSE arc.matcat_id END) AS matcat_id,
    cat_arc.shape AS cat_shape,
    cat_arc.geom1 AS cat_geom1,
    cat_arc.geom2 AS cat_geom2,
    cat_arc.width,
    arc.epa_type,
    arc.expl_id,
    e.macroexpl_id,
    arc.sector_id,
    s.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    st_length(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.inverted_slope,
    arc.observ,
    arc.comment,
    arc.dma_id,
    m.macrodma_id,
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
    c.descript::character varying(100) AS streetname,
    arc.postnumber,
    arc.postcomplement,
    d.descript::character varying(100) AS streetname2,
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
    arc.asset_id,
    arc.pavcat_id,
    arc.drainzone_id,
    cat_arc.area AS cat_area
   FROM arc
     JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
     JOIN sector s ON s.sector_id = arc.sector_id
     JOIN exploitation e USING (expl_id)
     JOIN dma m  USING (dma_id)
     LEFT JOIN v_ext_streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text;



CREATE OR REPLACE VIEW v_arc AS 
SELECT vu_arc.* FROM vu_arc
JOIN v_state_arc USING (arc_id);

CREATE OR REPLACE VIEW v_edit_arc AS 
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW ve_arc AS 
SELECT * FROM v_arc;


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
        CASE
            WHEN ((connec.y1 + connec.y2) / 2::numeric) IS NOT NULL THEN ((connec.y1 + connec.y2) / 2::numeric)::numeric(12,3)
            ELSE connec.connec_depth
        END AS connec_depth,
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
    c.descript::character varying(100) AS streetname,
    connec.postnumber,
    connec.postcomplement,
    d.descript::character varying(100) AS streetname2,
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
    connec.asset_id,
    connec.drainzone_id
   FROM connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN cat_feature ON connec.connec_type::text = cat_feature.id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = connec.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = connec.streetaxis2_id::text;



CREATE OR REPLACE VIEW v_connec AS 
SELECT vu_connec.* FROM vu_connec
JOIN v_state_connec USING (connec_id);


CREATE OR REPLACE VIEW v_edit_connec AS 
SELECT * FROM v_connec;

CREATE OR REPLACE VIEW ve_connec AS 
SELECT * FROM v_connec;


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
        CASE
            WHEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric) IS NOT NULL THEN ((gully.top_elev - gully.ymax + gully.sandbox + gully.connec_y2) / 2::numeric)::numeric(12,3)
            ELSE gully.connec_depth
        END AS connec_depth,
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
    c.descript::character varying(100) AS streetname,
    gully.postnumber,
    gully.postcomplement,
    d.descript::character varying(100) AS streetname2,
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
    gully.asset_id,
        CASE
            WHEN gully.connec_matcat_id IS NULL THEN cc.matcat_id::text
            ELSE gully.connec_matcat_id
        END AS connec_matcat_id,
    gully.gratecat2_id,
    gully.top_elev - gully.ymax + gully.sandbox AS connec_y1,
    gully.connec_y2,
    gully.epa_type,
    gully.groove_height,
    gully.groove_length,
    cat_grate.width AS grate_width,
    cat_grate.length AS grate_length,
    gully.units_placement,
    gully.drainzone_id
   FROM gully
     LEFT JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
     LEFT JOIN dma ON gully.dma_id = dma.dma_id
     LEFT JOIN sector ON gully.sector_id = sector.sector_id
     LEFT JOIN exploitation ON gully.expl_id = exploitation.expl_id
     LEFT JOIN cat_feature ON gully.gully_type::text = cat_feature.id::text
     LEFT JOIN v_ext_streetaxis c ON c.id::text = gully.streetaxis_id::text
     LEFT JOIN v_ext_streetaxis d ON d.id::text = gully.streetaxis2_id::text
     LEFT JOIN cat_connec cc ON cc.id::text = gully.connec_arccat_id::text;

CREATE OR REPLACE VIEW v_gully AS 
SELECT vu_gully.* FROM vu_gully
JOIN v_state_gully USING (gully_id);

CREATE OR REPLACE VIEW v_edit_gully AS 
SELECT * FROM v_gully;

CREATE OR REPLACE VIEW ve_gully AS 
SELECT * FROM v_gully;

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
            c.descript::character varying(100) AS streetname,
            node.postnumber,
            node.postcomplement,
            d.descript::character varying(100) AS streetname2,
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
            node.asset_id,
            node.drainzone_id,
	    node.parent_id,
	    node.arc_id
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
    vu_node.asset_id,
    vu_node.drainzone_id,
    vu_node.parent_id,
    vu_node.arc_id
   FROM vu_node;


CREATE OR REPLACE VIEW v_node AS 
SELECT vu_node.* FROM vu_node
JOIN v_state_node USING (node_id);

CREATE OR REPLACE VIEW v_edit_node AS 
SELECT * FROM v_node;

CREATE OR REPLACE VIEW ve_node AS 
SELECT * FROM v_node;

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"drainzone_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_arc"], "fieldName":"drainzone_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_connec"], "fieldName":"drainzone_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_gully"], "fieldName":"drainzone_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"arc_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"drainzone_id", "action":"ADD-FIELD","hasChilds":"True"}}$$);


SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_arc"], "fieldName":"cat_area", "action":"ADD-FIELD","hasChilds":"True"}}$$);

--add steps and covers on manhole views
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"step_pp", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"step_fe", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"step_replace", "action":"ADD-FIELD","hasChilds":"True"}}$$);
SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"cover", "action":"ADD-FIELD","hasChilds":"True"}}$$);

--2022/11/09
CREATE OR REPLACE VIEW ve_pol_gully
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    gully.fluid_type
   FROM gully
     JOIN v_state_gully USING (gully_id)
     JOIN polygon ON polygon.feature_id::text = gully.gully_id::text;


CREATE OR REPLACE VIEW v_edit_inp_conduit AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.matcat_id,
    v_arc.cat_shape,
    v_arc.cat_geom1,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
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
    v_arc.the_geom
   FROM selector_sector, v_arc
     JOIN inp_conduit USING (arc_id)
     JOIN value_state_type ON id=state_type
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


-- View: v_edit_inp_divider

-- DROP VIEW v_edit_inp_divider;

CREATE OR REPLACE VIEW v_edit_inp_divider AS 
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.expl_id,
    inp_divider.divider_type,
    inp_divider.arc_id,
    inp_divider.curve_id,
    inp_divider.qmin,
    inp_divider.ht,
    inp_divider.cd,
    inp_divider.y0,
    inp_divider.ysur,
    inp_divider.apond,
    v_node.the_geom
   FROM selector_sector, v_node
     JOIN inp_divider ON v_node.node_id::text = inp_divider.node_id::text
     JOIN value_state_type ON id=state_type
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;

  CREATE OR REPLACE VIEW v_edit_inp_flwreg_orifice AS 
 SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.ori_type,
    f.offsetval,
    f.cd,
    f.orate,
    f.flap,
    f.shape,
    f.geom1,
    f.geom2,
    f.geom3,
    f.geom4,
    f.close_time,
    st_setsrid(st_makeline(n.the_geom, st_lineinterpolatepoint(a.the_geom, f.flwreg_length / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE) AS the_geom
   FROM selector_sector s,
    inp_flwreg_orifice f
     JOIN v_edit_node n USING (node_id)
     JOIN value_state_type vs ON vs.id=state_type
     LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
  WHERE s.sector_id = n.sector_id AND s.cur_user = "current_user"()::text AND is_operative IS TRUE;



CREATE OR REPLACE VIEW v_edit_inp_flwreg_outlet AS 
 SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.outlet_type,
    f.offsetval,
    f.curve_id,
    f.cd1,
    f.cd2,
    f.flap,
    st_setsrid(st_makeline(n.the_geom, st_lineinterpolatepoint(a.the_geom, f.flwreg_length / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE) AS the_geom
   FROM selector_sector s,
    inp_flwreg_outlet f
     JOIN v_edit_node n USING (node_id)
     JOIN value_state_type vs ON vs.id=state_type
     LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
  WHERE s.sector_id = n.sector_id AND s.cur_user = "current_user"()::text AND is_operative IS TRUE;



CREATE OR REPLACE VIEW v_edit_inp_flwreg_pump AS 
 SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.curve_id,
    f.status,
    f.startup,
    f.shutoff,
    st_setsrid(st_makeline(n.the_geom, st_lineinterpolatepoint(a.the_geom, f.flwreg_length / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE) AS the_geom
   FROM selector_sector s,
    inp_flwreg_pump f
     JOIN v_edit_node n USING (node_id)
     JOIN value_state_type vs ON vs.id=state_type
     LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
  WHERE s.sector_id = n.sector_id AND s.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_flwreg_weir AS 
 SELECT f.nodarc_id,
    f.node_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    f.weir_type,
    f.offsetval,
    f.cd,
    f.ec,
    f.cd2,
    f.flap,
    f.geom1,
    f.geom2,
    f.geom3,
    f.geom4,
    f.surcharge,
    f.road_width,
    f.road_surf,
    f.coef_curve,
    st_setsrid(st_makeline(n.the_geom, st_lineinterpolatepoint(a.the_geom, f.flwreg_length / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE) AS the_geom
   FROM selector_sector s,
    inp_flwreg_weir f
     JOIN v_edit_node n USING (node_id)
     JOIN value_state_type vs ON vs.id=state_type
     LEFT JOIN arc a ON a.arc_id::text = f.to_arc::text
  WHERE s.sector_id = n.sector_id AND s.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_gully AS 
 SELECT g.gully_id,
    g.code,
    g.top_elev,
    g.gully_type,
    g.gratecat_id,
    (g.grate_width / 100::numeric)::numeric(12,2) AS grate_width,
    (g.grate_length / 100::numeric)::numeric(12,2) AS grate_length,
    g.arc_id,
    a.node_2 AS node_id,
    s.sector_id,
    g.expl_id,
    g.state,
    g.state_type,
    g.the_geom,
    g.units,
    g.units_placement,
    g.groove,
    g.groove_height,
    g.groove_length,
    cat_grate.a_param,
    cat_grate.b_param,
        CASE
            WHEN g.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_width / 100::numeric)::numeric(12,3)
            WHEN g.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.width / 100::numeric)::numeric(12,3)
        END AS total_width,
        CASE
            WHEN g.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_width / 100::numeric)::numeric(12,3)
            WHEN g.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(g.units::integer, 1)::numeric * g.grate_length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.length / 100::numeric)::numeric(12,3)
        END AS total_length,
    g.ymax - COALESCE(g.sandbox, 0::numeric) AS depth,
    g.annotation,
    i.outlet_type,
    i.custom_top_elev,
    i.custom_width,
    i.custom_length,
    i.custom_depth,
    i.method,
    i.weir_cd,
    i.orifice_cd,
    i.custom_a_param,
    i.custom_b_param,
    i.efficiency
   FROM selector_sector s,
    v_edit_gully g
     JOIN inp_gully i USING (gully_id)
     JOIN cat_grate ON g.gratecat_id::text = cat_grate.id::text
     JOIN value_state_type vs ON vs.id=state_type
     LEFT JOIN arc a USING (arc_id)
  WHERE g.sector_id = s.sector_id AND s.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.ymax,
    n.custom_ymax,
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
   FROM selector_sector,
    v_edit_node n
     JOIN inp_junction USING (node_id)
     JOIN value_state_type vs ON vs.id=state_type
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_netgully AS 
 SELECT n.node_id,
    n.code,
    n.top_elev,
    n.custom_top_elev,
    n.ymax,
    n.custom_ymax,
    n.elev,
    n.custom_elev,
    n.sys_elev,
    n.node_type,
    n.nodecat_id,
    man_netgully.gratecat_id,
    (cat_grate.width / 100::numeric)::numeric(12,3) AS grate_width,
    (cat_grate.length / 100::numeric)::numeric(12,3) AS grate_length,
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
    cat_grate.a_param,
    cat_grate.b_param,
        CASE
            WHEN man_netgully.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.width / 100::numeric)::numeric(12,3)
            WHEN man_netgully.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.width / 100::numeric)::numeric(12,3)
        END AS total_width,
        CASE
            WHEN man_netgully.units_placement::text = 'LENGTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.width / 100::numeric)::numeric(12,3)
            WHEN man_netgully.units_placement::text = 'WIDTH-SIDE'::text THEN (COALESCE(man_netgully.units::integer, 1)::numeric * cat_grate.length / 100::numeric)::numeric(12,3)
            ELSE (cat_grate.length / 100::numeric)::numeric(12,3)
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
    i.method,
    i.weir_cd,
    i.orifice_cd,
    i.custom_a_param,
    i.custom_b_param,
    i.efficiency
   FROM selector_sector s,
    v_node n
     JOIN inp_netgully i USING (node_id)
     JOIN value_state_type vs ON vs.id=state_type
     LEFT JOIN man_netgully USING (node_id)
     LEFT JOIN cat_grate ON man_netgully.gratecat_id::text = cat_grate.id::text
  WHERE n.sector_id = s.sector_id AND s.cur_user = "current_user"()::text AND is_operative IS TRUE;



CREATE OR REPLACE VIEW v_edit_inp_orifice AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
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
    v_arc.the_geom,
    inp_orifice.close_time
   FROM selector_sector,
    v_arc
     JOIN inp_orifice USING (arc_id)
     JOIN value_state_type ON id=state_type
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;



CREATE OR REPLACE VIEW v_edit_inp_outfall AS 
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.expl_id,
    inp_outfall.outfall_type,
    inp_outfall.stage,
    inp_outfall.curve_id,
    inp_outfall.timser_id,
    inp_outfall.gate,
    v_node.the_geom
   FROM selector_sector,
    v_node
     JOIN inp_outfall USING (node_id)
     JOIN value_state_type ON id=state_type
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;



CREATE OR REPLACE VIEW v_edit_inp_outlet AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
    inp_outlet.outlet_type,
    inp_outlet.offsetval,
    inp_outlet.curve_id,
    inp_outlet.cd1,
    inp_outlet.cd2,
    inp_outlet.flap,
    v_arc.the_geom
   FROM selector_sector,
    v_arc
     JOIN inp_outlet USING (arc_id)
     JOIN value_state_type ON id=state_type
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;



CREATE OR REPLACE VIEW v_edit_inp_pump AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
    inp_pump.curve_id,
    inp_pump.status,
    inp_pump.startup,
    inp_pump.shutoff,
    v_arc.the_geom
   FROM selector_sector,
    v_arc
     JOIN inp_pump USING (arc_id)
     JOIN value_state_type ON id=state_type
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;



CREATE OR REPLACE VIEW v_edit_inp_storage AS 
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.expl_id,
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
    inp_storage.apond,
    v_node.the_geom
   FROM selector_sector,
    v_node
     JOIN inp_storage USING (node_id)
     JOIN value_state_type ON id=state_type
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


CREATE OR REPLACE VIEW v_edit_inp_virtual AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.expl_id,
    inp_virtual.fusion_node,
    inp_virtual.add_length,
    v_arc.the_geom
   FROM selector_sector,
    v_arc
     JOIN inp_virtual USING (arc_id)
     JOIN value_state_type ON id=state_type
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;



CREATE OR REPLACE VIEW v_edit_inp_weir AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
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
    v_arc.the_geom,
    inp_weir.road_width,
    inp_weir.road_surf,
    inp_weir.coef_curve
   FROM selector_sector,
    v_arc
     JOIN inp_weir USING (arc_id)
     JOIN value_state_type ON id=state_type
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND is_operative IS TRUE;


--vistas review
DROP VIEW IF EXISTS v_edit_review_node;
CREATE OR REPLACE VIEW v_edit_review_node AS 
 SELECT review_node.node_id,
    review_node.top_elev,
    review_node.ymax,
    review_node.node_type,
    review_node.matcat_id,
    review_node.nodecat_id,
    review_node.step_pp,
    review_node.step_fe,
    review_node.step_replace,
    review_node.cover,
    review_node.annotation,
    review_node.observ,
    review_node.review_obs,
    review_node.expl_id,
    review_node.the_geom,
    review_node.field_date,
    review_node.field_checked,
    review_node.is_validated
   FROM review_node,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_node.expl_id = selector_expl.expl_id;



DROP VIEW  IF EXISTS v_edit_review_audit_node;
CREATE OR REPLACE VIEW v_edit_review_audit_node AS 
 SELECT review_audit_node.id,
    review_audit_node.node_id,
    review_audit_node.old_top_elev,
    review_audit_node.new_top_elev,
    review_audit_node.old_ymax,
    review_audit_node.new_ymax,
    review_audit_node.old_node_type,
    review_audit_node.new_node_type,
    review_audit_node.old_matcat_id,
    review_audit_node.new_matcat_id,
    review_audit_node.old_nodecat_id,
    review_audit_node.new_nodecat_id,
    review_audit_node.old_step_pp,
    review_audit_node.new_step_pp,
    review_audit_node.old_step_fe,
    review_audit_node.new_step_fe,
    review_audit_node.old_step_replace,
    review_audit_node.new_step_replace,
    review_audit_node.old_cover,
    review_audit_node.new_cover,
    review_audit_node.old_annotation,
    review_audit_node.new_annotation,
    review_audit_node.old_observ,
    review_audit_node.new_observ,
    review_audit_node.review_obs,
    review_audit_node.expl_id,
    review_audit_node.the_geom,
    review_audit_node.review_status_id,
    review_audit_node.field_date,
    review_audit_node.field_user,
    review_audit_node.is_validated
   FROM review_audit_node,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_audit_node.expl_id = selector_expl.expl_id AND review_audit_node.review_status_id <> 0;


DROP VIEW IF EXISTS v_edit_review_arc;
CREATE OR REPLACE VIEW v_edit_review_arc AS 
 SELECT review_arc.arc_id,
    arc.node_1,
    review_arc.y1,
    arc.node_2,
    review_arc.y2,
    review_arc.arc_type,
    review_arc.matcat_id,
    review_arc.arccat_id,
    review_arc.annotation,
    review_arc.observ,
    review_arc.review_obs,
    review_arc.expl_id,
    review_arc.the_geom,
    review_arc.field_date,
    review_arc.field_checked,
    review_arc.is_validated
   FROM selector_expl,
    review_arc
     JOIN arc ON review_arc.arc_id::text = arc.arc_id::text
  WHERE selector_expl.cur_user = "current_user"()::text AND review_arc.expl_id = selector_expl.expl_id;


DROP VIEW IF EXISTS v_edit_review_connec;
CREATE OR REPLACE VIEW v_edit_review_connec AS 
 SELECT review_connec.connec_id,
    review_connec.y1,
    review_connec.y2,
    review_connec.connec_type,
    review_connec.matcat_id,
    review_connec.connecat_id,
    review_connec.annotation,
    review_connec.observ,
    review_connec.review_obs,
    review_connec.expl_id,
    review_connec.the_geom,
    review_connec.field_date,
    review_connec.field_checked,
    review_connec.is_validated
   FROM review_connec,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_connec.expl_id = selector_expl.expl_id;

DROP VIEW IF EXISTS v_edit_review_gully;
CREATE OR REPLACE VIEW v_edit_review_gully AS 
 SELECT review_gully.gully_id,
    review_gully.top_elev,
    review_gully.ymax,
    review_gully.sandbox,
    review_gully.matcat_id,
    review_gully.gully_type,
    review_gully.gratecat_id,
    review_gully.units,
    review_gully.groove,
    review_gully.siphon,
    review_gully.connec_arccat_id,
    review_gully.annotation,
    review_gully.observ,
    review_gully.review_obs,
    review_gully.expl_id,
    review_gully.the_geom,
    review_gully.field_date,
    review_gully.field_checked,
    review_gully.is_validated
   FROM review_gully,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_gully.expl_id = selector_expl.expl_id;


CREATE OR REPLACE VIEW v_edit_drainzone AS
SELECT 
drainzone_id, 
name, 
drainzone.expl_id, 
descript,
undelete, 
link, 
graphconfig, 
stylesheet, 
active,
the_geom
FROM selector_expl, drainzone
WHERE drainzone.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_timeseries AS 
 SELECT DISTINCT p.id,
    p.timser_type,
    p.times_type,
    p.idval,
    p.descript,
    p.fname,
    p.expl_id,
    p.log,
    p.active
   FROM selector_expl s, inp_timeseries p
  WHERE (p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL)
  ORDER BY p.id;


CREATE OR REPLACE VIEW v_edit_inp_timeseries_value AS 
 SELECT DISTINCT p.id,
    p.timser_id,
    t.timser_type,
    t.times_type,
    t.idval,
    t.expl_id,
    p.date,
    p.hour,
    p."time",
    p.value
   FROM selector_expl s,
    inp_timeseries t
     JOIN inp_timeseries_value p ON t.id::text = p.timser_id::text
  WHERE (t.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR t.expl_id IS NULL ) 
  ORDER BY p.id;


CREATE OR REPLACE VIEW vi_timeseries AS 
SELECT timser_id, date, "time", value FROM
 (WITH t AS (
         SELECT 
		    a.id,
		    a.timser_id,
            a.other1 AS date,
            a.other2 AS "time",
            a.other3 AS value,
            a.expl_id
           FROM ( SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
                    inp_timeseries_value.date AS other1,
                    inp_timeseries_value.hour AS other2,
                    inp_timeseries_value.value AS other3,
                    inp_timeseries.expl_id
                   FROM inp_timeseries_value
                     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                  WHERE inp_timeseries.times_type::text = 'ABSOLUTE'::text AND active IS TRUE
                UNION
                 SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
                    concat('FILE', ' ', inp_timeseries.fname) AS other1,
                    NULL::character varying AS other2,
                    NULL::numeric AS other3,
                    inp_timeseries.expl_id
                   FROM inp_timeseries_value
                     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                  WHERE inp_timeseries.times_type::text = 'FILE'::text AND active IS TRUE
                UNION
                 SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
                    NULL::character varying AS other1,
                    inp_timeseries_value."time" AS other2,
                    inp_timeseries_value.value AS other3,
                    inp_timeseries.expl_id
                   FROM inp_timeseries_value
                     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                  WHERE inp_timeseries.times_type::text = 'RELATIVE'::text AND active IS TRUE) a
          ORDER BY a.id
        )
 SELECT t.id, t.timser_id, t.date, t."time", t.value FROM t, selector_expl s WHERE t.expl_id = s.expl_id AND s.cur_user = "current_user"()::text
UNION  SELECT t.id, t.timser_id, t.date, t."time", t.value FROM t WHERE t.expl_id IS NULL) a
ORDER BY id;



create or replace view vu_link as 
select link_id, l.feature_type, feature_id, exit_type, exit_id, l.state, l.expl_id, sector_id, 
dma_id, exit_topelev, exit_elev, fluid_type, (st_length2d(l.the_geom))::numeric(12,3) as gis_length, l.the_geom, 
s.name as sector_name, macrosector_id, macrodma_id
FROM link l
LEFT JOIN sector s USING (sector_id)
LEFT JOIN dma d USING (dma_id);


create or replace view vu_link_connec as 
select link_id, l.feature_type, feature_id, exit_type, exit_id, l.state, l.expl_id, sector_id, 
dma_id, exit_topelev, exit_elev, fluid_type, (st_length2d(l.the_geom))::numeric(12,3) as gis_length, l.the_geom, 
s.name as sector_name, macrosector_id, macrodma_id
FROM link l
LEFT JOIN sector s USING (sector_id)
LEFT JOIN dma d USING (dma_id)
WHERE feature_type = 'CONNEC';

create or replace view vu_link_gully as 
select link_id, l.feature_type, feature_id, exit_type, exit_id, l.state, l.expl_id, sector_id, 
dma_id, exit_topelev, exit_elev, fluid_type, (st_length2d(l.the_geom))::numeric(12,3) as gis_length, l.the_geom, 
s.name as sector_name, macrosector_id, macrodma_id
FROM link l
LEFT JOIN sector s USING (sector_id)
LEFT JOIN dma d USING (dma_id)
WHERE feature_type = 'GULLY';



CREATE OR REPLACE VIEW v_state_link_connec AS
SELECT link.link_id FROM selector_state,selector_expl, link
WHERE link.state = selector_state.state_id AND link.expl_id = selector_expl.expl_id AND selector_state.cur_user = "current_user"()::text 
AND selector_expl.cur_user = "current_user"()::text AND feature_type = 'CONNEC'

EXCEPT ALL

SELECT plan_psector_x_connec.link_id FROM selector_psector,selector_expl, plan_psector_x_connec JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 0
AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text
AND plan_psector_x_connec.active is true

UNION ALL

SELECT plan_psector_x_connec.link_id FROM selector_psector, selector_expl, plan_psector_x_connec  JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 1 
AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text
AND plan_psector_x_connec.active is true;




CREATE OR REPLACE VIEW v_state_link_gully AS
SELECT link.link_id FROM selector_state,selector_expl, link
WHERE link.state = selector_state.state_id AND link.expl_id = selector_expl.expl_id AND selector_state.cur_user = "current_user"()::text 
AND selector_expl.cur_user = "current_user"()::text AND feature_type = 'GULLY'

EXCEPT ALL

SELECT plan_psector_x_gully.link_id FROM selector_psector,selector_expl, plan_psector_x_gully JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_gully.state = 0 
AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text
AND plan_psector_x_gully.active is true

UNION ALL

SELECT plan_psector_x_gully.link_id FROM selector_psector, selector_expl, plan_psector_x_gully  JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_gully.state = 1 
AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text
AND plan_psector_x_gully.active is true;



CREATE OR REPLACE VIEW v_state_link AS
SELECT link.link_id FROM selector_state,selector_expl, link
WHERE link.state = selector_state.state_id AND link.expl_id = selector_expl.expl_id AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text

EXCEPT ALL

(SELECT plan_psector_x_connec.link_id FROM selector_psector,selector_expl, plan_psector_x_connec JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 0 
AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text
AND plan_psector_x_connec.active is true

UNION ALL
SELECT plan_psector_x_gully.link_id FROM selector_psector,selector_expl, plan_psector_x_gully JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_gully.state = 0 
AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text
AND plan_psector_x_gully.active is true)

UNION ALL

(SELECT plan_psector_x_connec.link_id FROM selector_psector, selector_expl, plan_psector_x_connec  JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 1 
AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text
AND plan_psector_x_connec.active is true

UNION ALL
SELECT plan_psector_x_gully.link_id FROM selector_psector, selector_expl, plan_psector_x_gully  JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_gully.state = 1 
AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text
AND plan_psector_x_gully.active is true);




create or replace view v_link_connec as 
select * from vu_link_connec
JOIN v_state_link_connec USING (link_id);

create or replace view v_link_gully as 
select * from vu_link_gully
JOIN v_state_link_gully USING (link_id);


create or replace view v_link as 
select * from vu_link
JOIN v_state_link USING (link_id);



CREATE OR REPLACE VIEW v_connec AS 
 SELECT vu_connec.connec_id,
    vu_connec.code,
    vu_connec.customer_code,
    vu_connec.top_elev,
    vu_connec.y1,
    vu_connec.y2,
    vu_connec.connecat_id,
    vu_connec.connec_type,
    vu_connec.sys_type,
    vu_connec.private_connecat_id,
    vu_connec.matcat_id,
    vu_connec.expl_id,
    vu_connec.macroexpl_id,
    (case when a.sector_id is null then vu_connec.sector_id else a.sector_id end) as sector_id,
    (case when a.macrosector_id is null then vu_connec.macrosector_id else a.macrosector_id end) as macrosector_id,
    vu_connec.demand,
    vu_connec.state,
    vu_connec.state_type,
    vu_connec.connec_depth,
    vu_connec.connec_length,
    v_state_connec.arc_id,
    vu_connec.annotation,
    vu_connec.observ,
    vu_connec.comment,
    (case when a.dma_id is null then vu_connec.dma_id else a.dma_id end) as dma_id,
    (case when a.macrodma_id is null then vu_connec.macrodma_id else a.macrodma_id end) as macrodma_id,
    vu_connec.soilcat_id,
    vu_connec.function_type,
    vu_connec.category_type,
    vu_connec.fluid_type,
    vu_connec.location_type,
    vu_connec.workcat_id,
    vu_connec.workcat_id_end,
    vu_connec.buildercat_id,
    vu_connec.builtdate,
    vu_connec.enddate,
    vu_connec.ownercat_id,
    vu_connec.muni_id,
    vu_connec.postcode,
    vu_connec.district_id,
    vu_connec.streetname,
    vu_connec.postnumber,
    vu_connec.postcomplement,
    vu_connec.streetname2,
    vu_connec.postnumber2,
    vu_connec.postcomplement2,
    vu_connec.descript,
    vu_connec.svg,
    vu_connec.rotation,
    vu_connec.link,
    vu_connec.verified,
    vu_connec.undelete,
    vu_connec.label,
    vu_connec.label_x,
    vu_connec.label_y,
    vu_connec.label_rotation,
    vu_connec.accessibility,
    vu_connec.diagonal,
    vu_connec.publish,
    vu_connec.inventory,
    vu_connec.uncertain,
    vu_connec.num_value,
    (case when a.exit_id is null then vu_connec.pjoint_id else a.exit_id end) as pjoint_id,
    (case when a.exit_type is null then vu_connec.pjoint_type else a.exit_type end) as pjoint_type,
    vu_connec.tstamp,
    vu_connec.insert_user,
    vu_connec.lastupdate,
    vu_connec.lastupdate_user,
    vu_connec.the_geom,
    vu_connec.workcat_id_plan,
    vu_connec.asset_id,
    vu_connec.drainzone_id
   FROM vu_connec
     JOIN v_state_connec USING (connec_id)
     LEFT JOIN (SELECT DISTINCT ON (feature_id) * FROM v_link_connec) a ON feature_id = connec_id;


CREATE OR REPLACE VIEW v_gully AS 
 SELECT vu_gully.gully_id,
    vu_gully.code,
    vu_gully.top_elev,
    vu_gully.ymax,
    vu_gully.sandbox,
    vu_gully.matcat_id,
    vu_gully.gully_type,
    vu_gully.sys_type,
    vu_gully.gratecat_id,
    vu_gully.cat_grate_matcat,
    vu_gully.units,
    vu_gully.groove,
    vu_gully.siphon,
    vu_gully.connec_arccat_id,
    vu_gully.connec_length,
    vu_gully.connec_depth,
    v_state_gully.arc_id,
    vu_gully.expl_id,
    vu_gully.macroexpl_id,
    vu_gully.sector_id,
    vu_gully.macrosector_id,
    vu_gully.state,
    vu_gully.state_type,
    vu_gully.annotation,
    vu_gully.observ,
    vu_gully.comment,
    vu_gully.dma_id,
    vu_gully.macrodma_id,
    vu_gully.soilcat_id,
    vu_gully.function_type,
    vu_gully.category_type,
    vu_gully.fluid_type,
    vu_gully.location_type,
    vu_gully.workcat_id,
    vu_gully.workcat_id_end,
    vu_gully.buildercat_id,
    vu_gully.builtdate,
    vu_gully.enddate,
    vu_gully.ownercat_id,
    vu_gully.muni_id,
    vu_gully.postcode,
    vu_gully.district_id,
    vu_gully.streetname,
    vu_gully.postnumber,
    vu_gully.postcomplement,
    vu_gully.streetname2,
    vu_gully.postnumber2,
    vu_gully.postcomplement2,
    vu_gully.descript,
    vu_gully.svg,
    vu_gully.rotation,
    vu_gully.link,
    vu_gully.verified,
    vu_gully.undelete,
    vu_gully.label,
    vu_gully.label_x,
    vu_gully.label_y,
    vu_gully.label_rotation,
    vu_gully.publish,
    vu_gully.inventory,
    vu_gully.uncertain,
    vu_gully.num_value,
    vu_gully.pjoint_id,
    vu_gully.pjoint_type,
    vu_gully.tstamp,
    vu_gully.insert_user,
    vu_gully.lastupdate,
    vu_gully.lastupdate_user,
    vu_gully.the_geom,
    vu_gully.workcat_id_plan,
    vu_gully.asset_id,
    vu_gully.connec_matcat_id,
    vu_gully.gratecat2_id,
    vu_gully.connec_y1,
    vu_gully.connec_y2,
    vu_gully.epa_type,
    vu_gully.groove_height,
    vu_gully.groove_length,
    vu_gully.grate_width,
    vu_gully.grate_length,
    vu_gully.units_placement,
    vu_gully.drainzone_id
   FROM vu_gully
     JOIN v_state_gully USING (gully_id)
     LEFT JOIN (SELECT DISTINCT ON (feature_id) * FROM v_link_gully) a ON feature_id = gully_id;


DROP VIEW v_arc_x_vnode;
DROP VIEW v_vnode;

DROP VIEW v_ui_arc_x_relations;

DROP VIEW v_edit_link;


CREATE OR REPLACE VIEW v_edit_link_connec AS SELECT *
FROM v_link_connec l;

CREATE OR REPLACE VIEW v_edit_link_gully AS SELECT *
FROM v_link_gully l;

CREATE OR REPLACE VIEW v_edit_link AS SELECT *
FROM v_link l;


CREATE OR REPLACE VIEW v_ui_arc_x_relations AS 
 SELECT row_number() OVER () + 1000000 AS rid,
    v_connec.arc_id,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS catalog,
    v_connec.connec_id AS feature_id,
    v_connec.code AS feature_code,
    v_connec.sys_type,
    v_connec.state AS arc_state,
    v_connec.state AS feature_state,
    st_x(v_connec.the_geom) AS x,
    st_y(v_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM v_connec
     LEFT JOIN v_edit_link l ON v_connec.connec_id::text = l.feature_id::text
  WHERE v_connec.arc_id IS NOT NULL
UNION
 SELECT row_number() OVER () + 2000000 AS rid,
    v_gully.arc_id,
    v_gully.gully_type AS featurecat_id,
    v_gully.gratecat_id AS catalog,
    v_gully.gully_id AS feature_id,
    v_gully.code AS feature_code,
    v_gully.sys_type,
    v_gully.state AS arc_state,
    v_gully.state AS feature_state,
    st_x(v_gully.the_geom) AS x,
    st_y(v_gully.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_gully'::text AS sys_table_id
   FROM v_gully
     LEFT JOIN v_edit_link l ON v_gully.gully_id::text = l.feature_id::text
  WHERE v_gully.arc_id IS NOT NULL;
  
create view  v_edit_plan_psector_x_connec  as
SELECT distinct on (connec_id, psector_id) *, rank(*) over (partition by connec_id order by state desc) FROM plan_psector_x_connec;

create view  v_edit_plan_psector_x_gully  as
SELECT distinct on (gully_id, psector_id) *, rank() over (partition by gully_id order by state desc) FROM plan_psector_x_gully;