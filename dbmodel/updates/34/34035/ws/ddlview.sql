/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/04/20
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
    a.link_class,
    a.psector_rowid,
    a.fluid_type,
    a.vnode_topelev
   FROM 
    ( 
    SELECT 
	    link.link_id,
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
            1 AS link_class,
            NULL::integer AS psector_rowid
           FROM selector_state, v_edit_connec c
             LEFT JOIN link ON link.feature_id::text = c.connec_id::text
             LEFT JOIN arc USING (arc_id)
             LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
             WHERE selector_state.cur_user = "current_user"()::text AND selector_state.state_id = c.state
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
            a_1.sector_id,
            a_1.dma_id,
            a_1.expl_id,
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
                    WHEN p.link_geom IS NULL THEN 2
                    ELSE 3
                END AS link_class,
            p.id AS psector_rowid
           FROM link l,
            selector_psector s,
            selector_expl e,
            plan_psector_x_connec p
             JOIN connec c USING (connec_id)
             LEFT JOIN arc a_1 ON a_1.arc_id::text = p.arc_id::text
             LEFT JOIN sector ON sector.sector_id::text = a_1.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = a_1.dma_id::text
          WHERE l.feature_id::text = p.connec_id::text AND p.state = 1 AND s.psector_id = p.psector_id AND s.cur_user = "current_user"()::text 
          AND e.expl_id = c.expl_id AND e.cur_user = "current_user"()::text
          order by link_class desc
          ) a;

CREATE OR REPLACE VIEW v_edit_vnode AS 
SELECT DISTINCT ON (vnode_id) * FROM
(SELECT vnode_id,
    l.feature_type,
    v.elev,
    l.sector_id,
    l.dma_id,
    l.state,
    st_endpoint(l.the_geom) as the_geom,
    l.expl_id,
    l.link_class
FROM v_edit_link l
JOIN vnode v ON exit_id::integer = vnode_id
WHERE exit_type = 'VNODE'
ORDER BY link_class  DESC)a;

--2021/04/27
DROP VIEW IF EXISTS v_plan_psector_arc;
CREATE OR REPLACE VIEW v_plan_psector_arc AS
SELECT row_number() OVER () AS rid,
arc.arc_id,
plan_psector_x_arc.psector_id,
arc.code, 
arc.arccat_id,
cat_arc.arctype_id,
cat_feature.system_id,
arc.state AS original_state,
arc.state_type AS original_state_type,
plan_psector_x_arc.state AS plan_state,
plan_psector_x_arc.doable,
plan_psector_x_arc.addparam,
arc.the_geom
FROM selector_psector, arc
JOIN plan_psector_x_arc USING (arc_id)
JOIN cat_arc ON cat_arc.id=arc.arccat_id
JOIN cat_feature ON cat_feature.id=cat_arc.arctype_id
WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_plan_psector_node;
CREATE OR REPLACE VIEW v_plan_psector_node AS
SELECT row_number() OVER () AS rid,
node.node_id,
plan_psector_x_node.psector_id,
node.code, 
node.nodecat_id,
cat_node.nodetype_id,
cat_feature.system_id,
node.state AS original_state,
node.state_type AS original_state_type,
plan_psector_x_node.state AS plan_state,
plan_psector_x_node.doable,
node.the_geom
FROM selector_psector, node
JOIN plan_psector_x_node USING (node_id)
JOIN cat_node ON cat_node.id=node.nodecat_id
JOIN cat_feature ON cat_feature.id=cat_node.nodetype_id
WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_plan_psector_connec;
CREATE OR REPLACE VIEW v_plan_psector_connec AS
SELECT row_number() OVER () AS rid,
connec.connec_id,
plan_psector_x_connec.psector_id,
connec.code, 
connec.connecat_id,
cat_connec.connectype_id,
cat_feature.system_id,
connec.state AS original_state,
connec.state_type AS original_state_type,
plan_psector_x_connec.state AS plan_state,
plan_psector_x_connec.doable,
connec.the_geom
FROM selector_psector, connec
JOIN plan_psector_x_connec USING (connec_id)
JOIN cat_connec ON cat_connec.id=connec.connecat_id
JOIN cat_feature ON cat_feature.id=cat_connec.connectype_id
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_plan_psector_link;
CREATE OR REPLACE VIEW v_plan_psector_link AS 
SELECT row_number() OVER () AS rid,
link.link_id,
plan_psector_x_connec.psector_id,
connec.connec_id,
connec.state AS original_state,
connec.state_type AS original_state_type,
plan_psector_x_connec.state AS plan_state,
plan_psector_x_connec.doable,
link.the_geom
FROM selector_psector,connec
JOIN plan_psector_x_connec USING (connec_id)
JOIN link ON link.feature_id=connec.connec_id
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;