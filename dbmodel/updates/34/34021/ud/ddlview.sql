/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/09/29
CREATE OR REPLACE VIEW v_edit_link AS
 SELECT DISTINCT ON (a.link_id) a.link_id,
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
    a.ispsectorgeom,
    a.psector_rowid,
    a.fluid_type,
    a.vnode_topelev
   FROM ( SELECT link.link_id,
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
                 CASE
                    WHEN  plan_psector_x_connec.connec_id IS NULL or  plan_psector_x_connec.state = 0 THEN link.state
                    ELSE  plan_psector_x_connec.state
                END AS state,
                CASE
                    WHEN  plan_psector_x_connec.connec_id IS NULL or  plan_psector_x_connec.state = 0 THEN st_length2d(link.the_geom)
                    ELSE st_length2d( plan_psector_x_connec.link_geom)
                END AS gis_length,
                CASE
                    WHEN  plan_psector_x_connec.connec_id IS NULL or  plan_psector_x_connec.state = 0 THEN link.userdefined_geom
                    ELSE  plan_psector_x_connec.userdefined_geom
                END AS userdefined_geom,
                CASE
                    WHEN  plan_psector_x_connec.connec_id IS NULL or  plan_psector_x_connec.state = 0 THEN link.the_geom
                    ELSE  plan_psector_x_connec.link_geom
                END AS the_geom,
                CASE
                    WHEN  plan_psector_x_connec.connec_id IS NULL or  plan_psector_x_connec.state = 0 THEN false
                    ELSE true
                END AS ispsectorgeom,
                CASE
                    WHEN  plan_psector_x_connec.connec_id IS NULL or  plan_psector_x_connec.state = 0 THEN NULL::integer
                    ELSE  plan_psector_x_connec.id
                END AS psector_rowid
           FROM link
             RIGHT JOIN v_edit_connec c ON link.feature_id::text = c.connec_id::text
             LEFT JOIN arc USING (arc_id)
             LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
             LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)
        UNION
         SELECT link.link_id,
            link.feature_type,
            link.feature_id,
            sector.macrosector_id,
            dma.macrodma_id,
            link.exit_type,
            link.exit_id,
            link.vnode_topelev,
            g.fluid_type,
            arc.sector_id,
            arc.dma_id,
            arc.expl_id,
                CASE
                    WHEN plan_psector_x_gully.gully_id IS NULL or plan_psector_x_gully.state = 0 THEN link.state
                    ELSE plan_psector_x_gully.state
                END AS state,
                CASE
                    WHEN plan_psector_x_gully.gully_id IS NULL or plan_psector_x_gully.state = 0 THEN st_length2d(link.the_geom)
                    ELSE st_length2d(plan_psector_x_gully.link_geom)
                END AS gis_length,
                CASE
                    WHEN plan_psector_x_gully.gully_id IS NULL or plan_psector_x_gully.state = 0 THEN link.userdefined_geom
                    ELSE plan_psector_x_gully.userdefined_geom
                END AS userdefined_geom,
                CASE
                    WHEN plan_psector_x_gully.gully_id IS NULL or plan_psector_x_gully.state = 0 THEN link.the_geom
                    ELSE plan_psector_x_gully.link_geom
                END AS the_geom,
                CASE
                    WHEN plan_psector_x_gully.gully_id IS NULL or plan_psector_x_gully.state = 0 THEN false
                    ELSE true
                END AS ispsectorgeom,
                CASE
                    WHEN plan_psector_x_gully.gully_id IS NULL or plan_psector_x_gully.state = 0 THEN NULL::integer
                    ELSE plan_psector_x_gully.id
                END AS psector_rowid
           FROM link
             RIGHT JOIN v_edit_gully g ON link.feature_id::text = g.gully_id::text
             LEFT JOIN arc USING (arc_id)
             LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
             LEFT JOIN plan_psector_x_gully USING (arc_id, gully_id)) a
  WHERE a.state > 0 AND a.link_id IS NOT NULL;


CREATE OR REPLACE VIEW v_edit_vnode AS 
 SELECT a.vnode_id,
    a.feature_type,
    a.top_elev,
    a.sector_id,
    a.dma_id,
    a.state,
    a.the_geom,
    a.expl_id,
    a.ispsectorgeom,
    a.psector_rowid
   FROM ( SELECT DISTINCT ON (vnode.vnode_id) vnode.vnode_id,
            link.feature_type,
            vnode.top_elev,
            link.sector_id,
            link.dma_id,
                CASE
                    WHEN plan_psector_x_connec.connec_id IS NULL OR plan_psector_x_connec.state = 0 THEN link.state
                    ELSE plan_psector_x_connec.state
                END AS state,
                CASE
                    WHEN plan_psector_x_connec.connec_id IS NULL OR plan_psector_x_connec.state = 0 THEN vnode.the_geom
                    ELSE plan_psector_x_connec.vnode_geom
                END AS the_geom,
            link.expl_id,
                CASE
                    WHEN plan_psector_x_connec.connec_id IS NULL OR plan_psector_x_connec.state = 0 THEN false
                    ELSE true
                END AS ispsectorgeom,
                CASE
                    WHEN plan_psector_x_connec.connec_id IS NULL OR plan_psector_x_connec.state = 0 THEN NULL::integer
                    ELSE plan_psector_x_connec.id
                END AS psector_rowid
           FROM v_edit_link link
             JOIN vnode ON link.exit_id::text = vnode.vnode_id::text AND link.exit_type::text = 'VNODE'::text
             LEFT JOIN v_state_connec ON link.feature_id::text = v_state_connec.connec_id::text
             LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)
          WHERE link.feature_id::text = v_state_connec.connec_id::text
        UNION
         SELECT DISTINCT ON (vnode.vnode_id) vnode.vnode_id,
            link.feature_type,
            vnode.top_elev,
            link.sector_id,
            link.dma_id,
                CASE
                    WHEN plan_psector_x_gully.gully_id IS NULL OR plan_psector_x_gully.state = 0 THEN link.state
                    ELSE plan_psector_x_gully.state
                END AS state,
                CASE
                    WHEN plan_psector_x_gully.gully_id IS NULL OR plan_psector_x_gully.state = 0 THEN vnode.the_geom
                    ELSE plan_psector_x_gully.vnode_geom
                END AS the_geom,
            link.expl_id,
                CASE
                    WHEN plan_psector_x_gully.gully_id IS NULL OR plan_psector_x_gully.state = 0 THEN false
                    ELSE true
                END AS ispsectorgeom,
                CASE
                    WHEN plan_psector_x_gully.gully_id IS NULL OR plan_psector_x_gully.state = 0 THEN NULL::integer
                    ELSE plan_psector_x_gully.id
                END AS psector_rowid
           FROM v_edit_link link
             JOIN vnode ON link.exit_id::text = vnode.vnode_id::text AND link.exit_type::text = 'VNODE'::text
             LEFT JOIN v_state_gully ON link.feature_id::text = v_state_gully.gully_id::text
             LEFT JOIN plan_psector_x_gully USING (arc_id, gully_id)
          WHERE link.feature_id::text = v_state_gully.gully_id::text) a
  WHERE a.state > 0;

