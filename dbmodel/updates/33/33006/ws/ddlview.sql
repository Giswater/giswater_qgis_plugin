/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 17/10/2019

CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT link.link_id,
    link.feature_type,
    link.feature_id,
    link.exit_type,
    link.exit_id,
    arc.sector_id,
    sector.macrosector_id,
    arc.dma_id,
    dma.macrodma_id,
    arc.expl_id,
    link.state,
    st_length2d(link.the_geom) AS gis_length,
    link.userdefined_geom,
        CASE
            WHEN plan_psector_x_connec.link_geom IS NULL THEN link.the_geom
            ELSE plan_psector_x_connec.link_geom
        END AS the_geom
   FROM link
     LEFT JOIN v_state_connec ON link.feature_id::text = v_state_connec.connec_id::text
     LEFT JOIN arc USING (arc_id)
     JOIN sector ON sector.sector_id::text = arc.sector_id::text
     JOIN dma ON dma.dma_id::text = arc.dma_id::text
     LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)
  WHERE link.feature_id::text = v_state_connec.connec_id::text AND plan_psector_x_connec.state=1;



  CREATE OR REPLACE VIEW v_edit_vnode AS 
 SELECT DISTINCT ON (vnode.vnode_id) vnode.vnode_id,
    vnode.vnode_type,
    vnode.elev,
    vnode.sector_id,
    vnode.dma_id,
    vnode.state,
    vnode.annotation,
        CASE
            WHEN plan_psector_x_connec.vnode_geom IS NULL THEN vnode.the_geom
            ELSE plan_psector_x_connec.vnode_geom
        END AS the_geom,
    vnode.expl_id,
    vnode.rotation
   FROM link
     LEFT JOIN vnode ON link.exit_id::text = vnode.vnode_id::text AND link.exit_type::text = 'VNODE'::text
     LEFT JOIN v_state_connec ON link.feature_id::text = v_state_connec.connec_id::text
     LEFT JOIN arc USING (arc_id)
     JOIN sector ON sector.sector_id::text = arc.sector_id::text
     JOIN dma ON dma.dma_id::text = arc.dma_id::text
     LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)
  WHERE link.feature_id::text = v_state_connec.connec_id::text AND plan_psector_x_connec.state=1;
  
