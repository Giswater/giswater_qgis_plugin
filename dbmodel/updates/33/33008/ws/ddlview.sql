/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW IF EXISTS v_edit_samplepoint;
CREATE OR REPLACE VIEW v_edit_samplepoint AS 
 SELECT samplepoint.sample_id,
    samplepoint.code,
    samplepoint.lab_code,
    samplepoint.feature_id,
    samplepoint.featurecat_id,
    samplepoint.dma_id,
    dma.macrodma_id,
    samplepoint.presszonecat_id,
    samplepoint.state,
    samplepoint.builtdate,
    samplepoint.enddate,
    samplepoint.workcat_id,
    samplepoint.workcat_id_end,
    samplepoint.rotation,
    samplepoint.muni_id,
    samplepoint.streetaxis_id,
    samplepoint.postnumber,
    samplepoint.postcode,
    samplepoint.streetaxis2_id,
    samplepoint.postnumber2,
    samplepoint.postcomplement,
    samplepoint.postcomplement2,
    samplepoint.place_name,
    samplepoint.cabinet,
    samplepoint.observations,
    samplepoint.verified,
    samplepoint.the_geom,
    samplepoint.expl_id,
    samplepoint.link
   FROM selector_expl,
    samplepoint
     JOIN v_state_samplepoint ON samplepoint.sample_id::text = v_state_samplepoint.sample_id::text
     LEFT JOIN dma ON dma.dma_id = samplepoint.dma_id
  WHERE samplepoint.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;



DROP VIEW v_edit_vnode;
CREATE OR REPLACE VIEW v_edit_vnode AS 
 SELECT a.vnode_id,
    a.vnode_type,
    a.feature_type,
    a.elev,
    a.sector_id,
    a.dma_id,
    a.state,
    a.annotation,
    a.the_geom,
    a.expl_id,
    a.rotation,
    a.ispsectorgeom,
    a.psector_rowid
   FROM ( SELECT DISTINCT ON (vnode.vnode_id) vnode.vnode_id,
            vnode.vnode_type,
            link.feature_type,
            vnode.elev,
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
           FROM link
             JOIN vnode ON link.exit_id::text = vnode.vnode_id::text AND link.exit_type::text = 'VNODE'::text
             LEFT JOIN v_state_connec ON link.feature_id::text = v_state_connec.connec_id::text
             LEFT JOIN arc USING (arc_id)
             JOIN sector ON sector.sector_id::text = arc.sector_id::text
             JOIN dma ON dma.dma_id::text = arc.dma_id::text
             LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)
          WHERE link.feature_id::text = v_state_connec.connec_id::text) a
  WHERE a.state < 2;
