/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT link.link_id,
    link.feature_type,
    link.feature_id,
    sector.macrosector_id,
    dma.macrodma_id,
    link.exit_type,
    link.exit_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.sector_id
            ELSE vnode.sector_id
        END AS sector_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.dma_id
            ELSE vnode.dma_id
        END AS dma_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.expl_id
            ELSE vnode.expl_id
        END AS expl_id,
    link.state,
    st_length2d(link.the_geom) AS gis_length,
    link.userdefined_geom,
        CASE
            WHEN plan_psector_x_connec.link_geom IS NULL THEN link.the_geom
            ELSE plan_psector_x_connec.link_geom
        END AS the_geom,
        CASE
            WHEN plan_psector_x_connec.link_geom IS NULL THEN false
            ELSE true
        END AS ispsectorgeom
   FROM link
     LEFT JOIN vnode ON link.feature_id::text = vnode.vnode_id::text AND link.feature_type::text = 'VNODE'::text
     JOIN v_edit_connec ON link.feature_id::text = v_edit_connec.connec_id::text
     JOIN arc USING (arc_id)
     JOIN sector ON sector.sector_id::text = v_edit_connec.sector_id::text
     JOIN dma ON dma.dma_id::text = v_edit_connec.dma_id::text OR dma.dma_id::text = vnode.dma_id::text
     LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)
UNION
 SELECT link.link_id,
    link.feature_type,
    link.feature_id,
    sector.macrosector_id,
    dma.macrodma_id,
    link.exit_type,
    link.exit_id,
        CASE
            WHEN link.feature_type::text = 'GULLY'::text THEN v_edit_gully.sector_id
            ELSE vnode.sector_id
        END AS sector_id,
        CASE
            WHEN link.feature_type::text = 'GULLY'::text THEN v_edit_gully.dma_id
            ELSE vnode.dma_id
        END AS dma_id,
        CASE
            WHEN link.feature_type::text = 'GULLY'::text THEN v_edit_gully.expl_id
            ELSE vnode.expl_id
        END AS expl_id,
    link.state,
    st_length2d(link.the_geom) AS gis_length,
    link.userdefined_geom,
        CASE
            WHEN plan_psector_x_gully.link_geom IS NULL THEN link.the_geom
            ELSE plan_psector_x_gully.link_geom
        END AS the_geom,
        CASE
            WHEN plan_psector_x_gully.link_geom IS NULL THEN false
            ELSE true
        END AS ispsectorgeom
   FROM link
     LEFT JOIN vnode ON link.feature_id::text = vnode.vnode_id::text AND link.feature_type::text = 'VNODE'::text
     JOIN v_edit_gully ON link.feature_id::text = v_edit_gully.gully_id::text
     LEFT JOIN arc USING (arc_id)
     JOIN sector ON sector.sector_id::text = v_edit_gully.sector_id::text
     JOIN dma ON dma.dma_id::text = v_edit_gully.dma_id::text OR dma.dma_id::text = vnode.dma_id::text
     LEFT JOIN plan_psector_x_gully USING (arc_id, gully_id);
