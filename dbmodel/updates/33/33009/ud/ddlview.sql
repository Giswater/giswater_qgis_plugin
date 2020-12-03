/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_edit_vnode AS 
 SELECT a.vnode_id,
    a.vnode_type,
    a.feature_type,
    a.top_elev,
    a.sector_id,
    a.dma_id,
    a.state,
    a.annotation,
    a.the_geom,
    a.expl_id,
    a.rotation,
    a.ispsectorgeom,
    a.psector_rowid
   FROM ( 

SELECT DISTINCT ON (vnode.vnode_id) vnode.vnode_id,
            vnode.vnode_type,
            link.feature_type,
            vnode.top_elev,
            vnode.sector_id,
            vnode.dma_id,
                CASE
                    WHEN plan_psector_x_connec.vnode_geom IS NULL THEN link.state
                    ELSE plan_psector_x_connec.state
                END AS state,
            vnode.annotation,
                CASE
                    WHEN plan_psector_x_connec.vnode_geom IS NULL THEN vnode.the_geom
                    ELSE plan_psector_x_connec.vnode_geom
                END AS the_geom,
            vnode.expl_id,
            vnode.rotation,
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
          WHERE link.feature_id::text = v_state_connec.connec_id::text
    UNION
    SELECT DISTINCT ON (vnode.vnode_id) vnode.vnode_id,
            vnode.vnode_type,
            link.feature_type,
            vnode.top_elev,
            vnode.sector_id,
            vnode.dma_id,
                CASE
                    WHEN plan_psector_x_gully.vnode_geom IS NULL THEN link.state
                    ELSE plan_psector_x_gully.state
                END AS state,
            vnode.annotation,
                CASE
                    WHEN plan_psector_x_gully.vnode_geom IS NULL THEN vnode.the_geom
                    ELSE plan_psector_x_gully.vnode_geom
                END AS the_geom,
            vnode.expl_id,
            vnode.rotation,
                CASE
                    WHEN plan_psector_x_gully.link_geom IS NULL THEN false
                    ELSE true
                END AS ispsectorgeom,
                CASE
                    WHEN plan_psector_x_gully.link_geom IS NULL THEN NULL::integer
                    ELSE plan_psector_x_gully.id
                END AS psector_rowid
           FROM v_edit_link link
             JOIN vnode ON link.exit_id::text = vnode.vnode_id::text AND link.exit_type::text = 'VNODE'::text
             LEFT JOIN v_state_gully ON link.feature_id::text = v_state_gully.gully_id::text
             LEFT JOIN plan_psector_x_gully USING (arc_id, gully_id)
          WHERE link.feature_id::text = v_state_gully.gully_id::text) a
  WHERE a.state < 2;
