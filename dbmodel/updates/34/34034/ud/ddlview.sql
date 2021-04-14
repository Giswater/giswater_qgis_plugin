/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/22
DROP VIEW IF EXISTS v_edit_review_audit_gully;
CREATE OR REPLACE VIEW v_edit_review_audit_gully AS 
 SELECT review_audit_gully.id,
    review_audit_gully.gully_id,
    review_audit_gully.old_top_elev,
    review_audit_gully.new_top_elev,
    review_audit_gully.old_ymax,
    review_audit_gully.new_ymax,
    review_audit_gully.old_sandbox,
    review_audit_gully.new_sandbox,
    review_audit_gully.old_matcat_id,
    review_audit_gully.new_matcat_id,
    review_audit_gully.old_gully_type,
    review_audit_gully.new_gully_type,
    review_audit_gully.old_gratecat_id,
    review_audit_gully.new_gratecat_id,
    review_audit_gully.old_units,
    review_audit_gully.new_units,
    review_audit_gully.old_groove,
    review_audit_gully.new_groove,
    review_audit_gully.old_siphon,
    review_audit_gully.new_siphon,
    review_audit_gully.old_connec_arccat_id,
    review_audit_gully.new_connec_arccat_id,
    review_audit_gully.old_featurecat_id,
    review_audit_gully.new_featurecat_id,
    review_audit_gully.old_feature_id,
    review_audit_gully.new_feature_id,
    review_audit_gully.old_annotation,
    review_audit_gully.new_annotation,
    review_audit_gully.old_observ,
    review_audit_gully.new_observ,
    review_audit_gully.expl_id,
    review_audit_gully.the_geom,
    review_audit_gully.review_status_id,
    review_audit_gully.field_date,
    review_audit_gully.field_user,
    review_audit_gully.is_validated
   FROM review_audit_gully,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_audit_gully.expl_id = selector_expl.expl_id AND review_audit_gully.review_status_id <> 0;
  
  
  
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
    review_gully.featurecat_id,
    review_gully.feature_id,
    review_gully.annotation,
    review_gully.observ,
    review_gully.expl_id,
    review_gully.the_geom,
    review_gully.field_checked,
    review_gully.is_validated
   FROM review_gully,
    selector_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND review_gully.expl_id = selector_expl.expl_id;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"review_audit_gully", "column":"old_connec_matcat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"review_audit_gully", "column":"new_connec_matcat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"review_gully", "column":"connec_matcat_id"}}$$);


DROP VIEW IF EXISTS v_arc_x_vnode;
DROP VIEW IF EXISTS v_edit_vnode;

DROP VIEW IF EXISTS v_edit_link;

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
    a.state AS state,
    a.gis_length,
    a.userdefined_geom,
    a.the_geom,
    a.link_class,
    a.psector_rowid,
    a.fluid_type,
    a.vnode_topelev
   FROM selector_state,
    ( SELECT link.link_id,
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
            0 AS link_class,
            NULL::integer AS psector_rowid
           FROM v_edit_connec c
             LEFT JOIN link ON link.feature_id::text = c.connec_id::text
             LEFT JOIN arc USING (arc_id)
             LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
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
            0 AS link_class,
            NULL::integer AS psector_rowid
        FROM v_edit_gully c
        LEFT JOIN link ON link.feature_id::text = c.gully_id::text
        LEFT JOIN arc USING (arc_id)
        LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
        LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
UNION
	SELECT
	    l.link_id,
            l.feature_type,
            l.feature_id,
            sector.macrosector_id,
            dma.macrodma_id,
            l.exit_type,
            l.exit_id,
            l.vnode_topelev,
            c.fluid_type,
            a.sector_id,
            a.dma_id,
            a.expl_id,
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
                    WHEN p.link_geom IS NULL THEN 1
                    ELSE 2
                END AS link_class,
                p.id AS psector_rowid
	FROM link l, plan_psector_x_connec p
	JOIN connec c USING (connec_id)
	LEFT JOIN arc a ON a.arc_id = p.arc_id
	LEFT JOIN sector ON sector.sector_id::text = a.sector_id::text
	LEFT JOIN dma ON dma.dma_id::text = a.dma_id::text
	WHERE l.feature_id = p.connec_id AND p.state=1
UNION
	SELECT
	    l.link_id,
            l.feature_type,
            l.feature_id,
            sector.macrosector_id,
            dma.macrodma_id,
            l.exit_type,
            l.exit_id,
            l.vnode_topelev,
            g.fluid_type,
            a.sector_id,
            a.dma_id,
            a.expl_id,
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
                    WHEN p.link_geom IS NULL THEN 1
                    ELSE 2
                END AS link_class,
                p.id AS psector_rowid
	FROM link l, plan_psector_x_gully p
	JOIN gully g USING (gully_id)
	LEFT JOIN arc a ON a.arc_id = p.arc_id
	LEFT JOIN sector ON sector.sector_id::text = a.sector_id::text
	LEFT JOIN dma ON dma.dma_id::text = a.dma_id::text
	WHERE l.feature_id = p.gully_id AND p.state=1) a
  WHERE selector_state.cur_user = "current_user"()::text AND selector_state.state_id = a.state;



CREATE OR REPLACE VIEW v_arc_x_vnode AS 
 SELECT a.link_id,
    a.vnode_id,
    a.arc_id,
    a.feature_type,
    a.feature_id,
    a.node_1,
    a.node_2,
    (a.length * a.locate::double precision)::numeric(12,3) AS vnode_distfromnode1,
    (a.length * (1::numeric - a.locate)::double precision)::numeric(12,3) AS vnode_distfromnode2,
        CASE
            WHEN a.vnode_topelev IS NULL THEN (a.top_elev1 - a.locate * (a.top_elev1 - a.top_elev2))::numeric(12,3)::double precision
            ELSE a.vnode_topelev
        END AS vnode_topelev,
    (a.sys_y1 - a.locate * (a.sys_y1 - a.sys_y2))::numeric(12,3) AS vnode_ymax,
    (a.sys_elev1 - a.locate * (a.sys_elev1 - a.sys_elev2))::numeric(12,3) AS vnode_elev
   FROM ( SELECT a_1.link_id,
            vnode.vnode_id,
            v_edit_arc.arc_id,
            a_1.feature_type,
            a_1.feature_id,
            a_1.vnode_topelev,
            st_length(v_edit_arc.the_geom) AS length,
            st_linelocatepoint(v_edit_arc.the_geom, vnode.the_geom)::numeric(12,3) AS locate,
            v_edit_arc.node_1,
            v_edit_arc.node_2,
            v_edit_arc.sys_elev1,
            v_edit_arc.sys_elev2,
            v_edit_arc.sys_y1,
            v_edit_arc.sys_y2,
            v_edit_arc.sys_elev1 + v_edit_arc.sys_y1 AS top_elev1,
            v_edit_arc.sys_elev2 + v_edit_arc.sys_y2 AS top_elev2
           FROM v_edit_arc,
            vnode
             JOIN v_edit_link a_1 ON vnode.vnode_id = a_1.exit_id::integer
          WHERE st_dwithin(v_edit_arc.the_geom, vnode.the_geom, 0.01::double precision) AND v_edit_arc.state > 0 AND vnode.state > 0) a
  ORDER BY a.arc_id, a.node_2 DESC;



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

