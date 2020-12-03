/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW IF EXISTS v_edit_vnode; 
CREATE OR REPLACE VIEW v_edit_vnode AS 
 SELECT a.vnode_id,
    a.feature_type,
    a.elev,
    a.sector_id,
    a.dma_id,
    a.state,
    a.the_geom,
    a.expl_id,
    a.ispsectorgeom,
    a.psector_rowid
   FROM ( SELECT DISTINCT ON (vnode.vnode_id) vnode.vnode_id,
            link.feature_type,
            vnode.elev,
            link.sector_id,
            link.dma_id,
                CASE
                    WHEN plan_psector_x_connec.vnode_geom IS NULL THEN link.state
                    ELSE plan_psector_x_connec.state
                END AS state,
                CASE
                    WHEN plan_psector_x_connec.vnode_geom IS NULL THEN vnode.the_geom
                    ELSE plan_psector_x_connec.vnode_geom
                END AS the_geom,
            link.expl_id,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN false
                    ELSE true
                END AS ispsectorgeom,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN NULL::integer
                    ELSE plan_psector_x_connec.id
                END AS psector_rowid
           FROM v_edit_link link
             JOIN vnode ON link.exit_id::text = vnode.vnode_id::text AND link.exit_type::text = 'VNODE'::text
             LEFT JOIN v_state_connec ON link.feature_id::text = v_state_connec.connec_id::text
             LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)
          WHERE link.feature_id::text = v_state_connec.connec_id::text) a
  WHERE a.state < 2;


CREATE OR REPLACE VIEW vu_arc AS 
WITH query_node AS (SELECT node_id, elevation, depth, nodetype_id, staticpressure FROM node JOIN cat_node ON nodecat_id = id)
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    arc.node_2,
    a.elevation AS elevation1,
    a.depth AS depth1,
    b.elevation AS elevation2,
    b.depth AS depth2,
    arc.arccat_id,
    cat_arc.arctype_id AS arc_type,
    cat_feature.system_id AS sys_type,
    cat_arc.matcat_id AS cat_matcat_id,
    cat_arc.pnom AS cat_pnom,
    cat_arc.dnom AS cat_dnom,
    arc.epa_type,
    arc.expl_id,
    exploitation.macroexpl_id,
    arc.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    arc.observ,
    arc.comment,
    st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.minsector_id,
    arc.dma_id,
    dma.name AS dma_name,
    dma.macrodma_id,
    arc.presszone_id,
    presszone.name AS presszone_name,
    arc.dqa_id,
    dqa.name AS dqa_name,
    dqa.macrodqa_id,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.buildercat_id,
    arc.builtdate,
    arc.enddate,
    arc.ownercat_id,
    arc.muni_id,
    arc.postcode,
    arc.district_id,
    c.name AS streetname,
    arc.postnumber,
    arc.postcomplement,
    d.name AS streetname2,
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
    arc.num_value,
    cat_arc.arctype_id AS cat_arctype_id,
    a.nodetype_id AS nodetype_1,
    a.staticpressure AS staticpress1,
    b.nodetype_id AS nodetype_2,
    b.staticpressure AS staticpress2,
    date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
    arc.depth,
    arc.adate,
    arc.adescript,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style
   FROM arc
     LEFT JOIN sector ON arc.sector_id = sector.sector_id
     LEFT JOIN exploitation ON arc.expl_id = exploitation.expl_id
     LEFT JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arctype_id::text
     LEFT JOIN dma ON arc.dma_id = dma.dma_id
     LEFT JOIN query_node a ON a.node_id::text = arc.node_1::text
     LEFT JOIN query_node b ON b.node_id::text = arc.node_2::text
     LEFT JOIN dqa ON arc.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id::text = arc.presszone_id::text
     LEFT JOIN ext_streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text;

  
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"vnode", "column":"vnode_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"vnode", "column":"annotation"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"vnode", "column":"sector_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"vnode", "column":"dma_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"vnode", "column":"expl_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"vnode", "column":"rotation"}}$$);
