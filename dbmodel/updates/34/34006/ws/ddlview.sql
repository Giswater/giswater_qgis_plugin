/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/28
DROP view if exists v_edit_vnode;

CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT a.link_id,
    a.feature_type,
    a.feature_id,
    a.exit_type,
    a.exit_id,
    a.sector_id,
    a.macrosector_id,
    a.dma_id,
    a.macrodma_id,
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
            link.exit_type,
            link.exit_id,
            arc.sector_id,
            sector.macrosector_id,
            arc.dma_id,
			vnode_topelev,
            dma.macrodma_id,
            arc.expl_id,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN link.state
                    ELSE plan_psector_x_connec.state
                END AS state,
            st_length2d(link.the_geom) AS gis_length,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN link.userdefined_geom
                    ELSE plan_psector_x_connec.userdefined_geom
                END AS userdefined_geom,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN link.the_geom
                    ELSE plan_psector_x_connec.link_geom
                END AS the_geom,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN false
                    ELSE true
                END AS ispsectorgeom,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN NULL::integer
                    ELSE plan_psector_x_connec.id
                END AS psector_rowid,
            arc.fluid_type
           FROM link
             JOIN v_state_connec ON link.feature_id::text = v_state_connec.connec_id::text
             LEFT JOIN arc USING (arc_id)
             LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
             LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)) a
  WHERE a.state < 2;

DROP VIEW IF EXISTS v_arc_x_vnode;
CREATE OR REPLACE VIEW v_arc_x_vnode AS 
 SELECT 
	link_id,
	a.vnode_id,
    a.arc_id,
    a.feature_type,
    a.feature_id,
    a.node_1,
    a.node_2,
    (a.length * a.locate::double precision)::numeric(12,3) AS vnode_distfromnode1,
    (a.length * (1::numeric - a.locate)::double precision)::numeric(12,3) AS vnode_distfromnode2,
	case when vnode_topelev IS NULL THEN (a.elevation1 - a.locate * (a.elevation1 - a.elevation2))::numeric(12,3) 
	ELSE vnode_topelev END AS vnode_topelev,
	(a.depth1 - a.locate * (a.depth1 - a.depth2))::numeric(12,3) AS vnode_ymax,
	(a.elev1 - a.locate * (a.elev1 - a.elev2))::numeric(12,3) AS vnode_elev
    FROM ( SELECT 
	    link_id,
            vnode.vnode_id,
            v_arc.arc_id,
            a_1.feature_type,
            a_1.feature_id,
	    vnode_topelev,
            st_length(v_arc.the_geom) AS length,
            st_linelocatepoint(v_arc.the_geom, vnode.the_geom)::numeric(12,3) AS locate,
            v_arc.node_1,
            v_arc.node_2,
            v_arc.elevation1,
            v_arc.elevation2,
            v_arc.depth1,
            v_arc.depth2,
	    v_arc.elevation1 - v_arc.depth1 as elev1,
            v_arc.elevation2 - v_arc.depth2 as elev2
           FROM v_arc,vnode
             JOIN v_edit_link a_1 ON vnode.vnode_id = a_1.exit_id::integer
          WHERE st_dwithin(v_arc.the_geom, vnode.the_geom, 0.01::double precision) AND v_arc.state > 0 AND vnode.state > 0) a
  ORDER BY a.arc_id, a.node_2 DESC;
 


CREATE OR REPLACE VIEW v_edit_vnode AS 
 SELECT a.vnode_id,
    a.feature_type,
    a.elev,
    a.state,
    a.the_geom,
    a.ispsectorgeom,
    a.psector_rowid
   FROM ( SELECT DISTINCT ON (vnode.vnode_id) vnode.vnode_id,
            link.feature_type,
            vnode.elev,
                CASE
                    WHEN plan_psector_x_connec.vnode_geom IS NULL THEN link.state
                    ELSE plan_psector_x_connec.state
                END AS state,
                CASE
                    WHEN plan_psector_x_connec.vnode_geom IS NULL THEN vnode.the_geom
                    ELSE plan_psector_x_connec.vnode_geom
                END AS the_geom,
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
  WHERE a.state < 2
