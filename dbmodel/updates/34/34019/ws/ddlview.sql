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


  
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"vnode", "column":"vnode_type"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"vnode", "column":"annotation"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"vnode", "column":"sector_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"vnode", "column":"dma_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"vnode", "column":"expl_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"vnode", "column":"rotation"}}$$);
