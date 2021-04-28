/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW vu_arc AS 
 WITH vu_node AS (
         SELECT node.node_id,
            node.top_elev,
            node.custom_top_elev,
                CASE
                    WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev
                    ELSE node.top_elev
                END AS sys_top_elev,
            node.ymax,
            node.custom_ymax,
                CASE
                    WHEN node.custom_ymax IS NOT NULL THEN node.custom_ymax
                    ELSE node.ymax
                END AS sys_ymax,
            node.elev,
            node.custom_elev,
                CASE
					WHEN node.custom_elev IS NOT NULL THEN node.custom_elev
                    WHEN node.elev IS NOT NULL AND node.custom_elev IS NULL THEN node.elev
                    WHEN node.custom_ymax IS NOT NULL THEN 
						CASE WHEN node.custom_top_elev IS NOT NULL THEN
							custom_top_elev - custom_ymax
						ELSE 
							top_elev - custom_ymax
						END
					WHEN node.ymax IS NOT NULL THEN 
						CASE WHEN node.custom_top_elev IS NOT NULL THEN
							custom_top_elev - ymax
						ELSE 
							top_elev - ymax
						END
                    ELSE NULL::numeric(12,3)
                END AS sys_elev,
                CASE
                    WHEN node.matcat_id IS NULL THEN cat_node.matcat_id
                    ELSE node.matcat_id
                END AS matcat_id,
            node.node_type,
            exploitation.macroexpl_id
           FROM node
             LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
             LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
        )
 SELECT arc.arc_id,
    arc.code,
    arc.node_1,
    a.node_type AS nodetype_1,
    arc.y1,
    arc.custom_y1,
    arc.elev1,
    arc.custom_elev1,
    arc.sys_elev1,
    a.sys_top_elev - arc.sys_elev1 AS sys_y1,
    a.sys_top_elev - arc.sys_elev1 - cat_arc.geom1 AS r1,
        CASE
            WHEN a.sys_elev IS NOT NULL THEN arc.sys_elev1 - a.sys_elev
            ELSE (arc.sys_elev1 - (a.sys_top_elev - a.sys_ymax))::numeric(12,3)
        END AS z1,
    arc.node_2,
    a.node_type AS nodetype_2,
    arc.y2,
    arc.custom_y2,
    arc.elev2,
    arc.custom_elev2,
    arc.sys_elev2,
    b.sys_top_elev - arc.sys_elev2 AS sys_y2,
    b.sys_top_elev - arc.sys_elev2 - cat_arc.geom1 AS r2,
        CASE
            WHEN b.sys_elev IS NOT NULL THEN arc.sys_elev2 - b.sys_elev
            ELSE (arc.sys_elev2 - (b.sys_top_elev - b.sys_ymax))::numeric(12,3)
        END AS z2,
    arc.sys_slope AS slope,
    arc.arc_type,
    cat_feature.system_id AS sys_type,
    arc.arccat_id,
        CASE
            WHEN arc.matcat_id IS NULL THEN cat_arc.matcat_id
            ELSE arc.matcat_id
        END AS matcat_id,
    cat_arc.shape AS cat_shape,
    cat_arc.geom1 AS cat_geom1,
    cat_arc.geom2 AS cat_geom2,
    cat_arc.width,
    arc.epa_type,
    arc.expl_id,
    a.macroexpl_id,
    arc.sector_id,
    sector.macrosector_id,
    arc.state,
    arc.state_type,
    arc.annotation,
    st_length(arc.the_geom)::numeric(12,2) AS gis_length,
    arc.custom_length,
    arc.inverted_slope,
    arc.observ,
    arc.comment,
    arc.dma_id,
    dma.macrodma_id,
    arc.soilcat_id,
    arc.function_type,
    arc.category_type,
    arc.fluid_type,
    arc.location_type,
    arc.workcat_id,
    arc.workcat_id_end,
    arc.builtdate,
    arc.enddate,
    arc.buildercat_id,
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
    arc.uncertain,
    arc.num_value,
    date_trunc('second'::text, arc.tstamp) AS tstamp,
    arc.insert_user,
    date_trunc('second'::text, arc.lastupdate) AS lastupdate,
    arc.lastupdate_user,
    arc.the_geom,
    arc.workcat_id_plan
   FROM arc
     JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
     LEFT JOIN vu_node a ON a.node_id::text = arc.node_1::text
     LEFT JOIN vu_node b ON b.node_id::text = arc.node_2::text
     JOIN sector ON sector.sector_id = arc.sector_id
     JOIN cat_feature ON arc.arc_type::text = cat_feature.id::text
     JOIN dma ON arc.dma_id = dma.dma_id
     LEFT JOIN ext_streetaxis c ON c.id::text = arc.streetaxis_id::text
     LEFT JOIN ext_streetaxis d ON d.id::text = arc.streetaxis2_id::text;
	 


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
            1 AS link_class,
            NULL::integer AS psector_rowid
           FROM selector_state, v_edit_connec c
             LEFT JOIN link ON link.feature_id::text = c.connec_id::text
             LEFT JOIN arc USING (arc_id)
             LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
             WHERE selector_state.cur_user = "current_user"()::text AND selector_state.state_id = c.state
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
            1 AS link_class,
            NULL::integer AS psector_rowid
           FROM selector_state, v_edit_gully c
             LEFT JOIN link ON link.feature_id::text = c.gully_id::text
             LEFT JOIN arc USING (arc_id)
             LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
             WHERE selector_state.cur_user = "current_user"()::text AND selector_state.state_id = c.state

        UNION
         SELECT l.link_id,
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
           FROM link l, selector_psector s, selector_expl e, plan_psector_x_connec p
             JOIN connec c USING (connec_id)
             LEFT JOIN arc a_1 ON a_1.arc_id::text = p.arc_id::text
             LEFT JOIN sector ON sector.sector_id::text = a_1.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = a_1.dma_id::text
          WHERE l.feature_id::text = p.connec_id::text AND p.state = 1 
		  AND s.psector_id = p.psector_id AND s.cur_user = current_user AND e.expl_id = c.expl_id AND e.cur_user = current_user
        UNION
         SELECT l.link_id,
            l.feature_type,
            l.feature_id,
            sector.macrosector_id,
            dma.macrodma_id,
            l.exit_type,
            l.exit_id,
            l.vnode_topelev,
            g.fluid_type,
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
           FROM link l, selector_expl e, selector_psector s,
            plan_psector_x_gully p
             JOIN gully g USING (gully_id)
             LEFT JOIN arc a_1 ON a_1.arc_id::text = p.arc_id::text
             LEFT JOIN sector ON sector.sector_id::text = a_1.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = a_1.dma_id::text
          WHERE l.feature_id::text = p.gully_id::text AND p.state = 1 AND s.psector_id = p.psector_id AND s.cur_user = current_user
          AND e.expl_id = g.expl_id AND e.cur_user = current_user
         order by link_class desc
          ) a ;

CREATE OR REPLACE VIEW v_edit_vnode AS 
SELECT DISTINCT ON (vnode_id) * FROM
(SELECT vnode_id,
    l.feature_type,
    v.top_elev,
    l.sector_id,
    l.dma_id,
    l.state,
    st_endpoint(l.the_geom),
    l.expl_id,
    l.link_class
FROM v_edit_link l
JOIN vnode v ON exit_id::integer = vnode_id
WHERE exit_type = 'VNODE'
ORDER BY link_class  DESC)a;


---2021/04/27
DROP VIEW IF EXISTS v_plan_psector_arc;
CREATE OR REPLACE VIEW v_plan_psector_arc AS
SELECT row_number() OVER () AS rid,
arc.arc_id,
plan_psector_x_arc.psector_id,
arc.code, 
arc.arccat_id,
arc.arc_type,
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
JOIN cat_feature ON cat_feature.id=arc.arc_type
WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_plan_psector_node;
CREATE OR REPLACE VIEW v_plan_psector_node AS
SELECT row_number() OVER () AS rid,
node.node_id,
plan_psector_x_node.psector_id,
node.code, 
node.nodecat_id,
node.node_type,
cat_feature.system_id,
node.state AS original_state,
node.state_type AS original_state_type,
plan_psector_x_node.state AS plan_state,
plan_psector_x_node.doable,
node.the_geom
FROM selector_psector, node
JOIN plan_psector_x_node USING (node_id)
JOIN cat_node ON cat_node.id=node.nodecat_id
JOIN cat_feature ON cat_feature.id=node.node_type
WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_plan_psector_connec;
CREATE OR REPLACE VIEW v_plan_psector_connec AS
SELECT row_number() OVER () AS rid,
connec.connec_id,
plan_psector_x_connec.psector_id,
connec.code, 
connec.connecat_id,
connec.connec_type,
cat_feature.system_id,
connec.state AS original_state,
connec.state_type AS original_state_type,
plan_psector_x_connec.state AS plan_state,
plan_psector_x_connec.doable,
connec.the_geom
FROM selector_psector, connec
JOIN plan_psector_x_connec USING (connec_id)
JOIN cat_connec ON cat_connec.id=connec.connecat_id
JOIN cat_feature ON cat_feature.id=connec.connec_type
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_plan_psector_gully;
CREATE OR REPLACE VIEW v_plan_psector_gully AS
SELECT row_number() OVER () AS rid,
gully.gully_id,
plan_psector_x_gully.psector_id,
gully.code, 
gully.gratecat_id,
gully.gully_type,
cat_feature.system_id,
gully.state AS original_state,
gully.state_type AS original_state_type,
plan_psector_x_gully.state AS plan_state,
plan_psector_x_gully.doable,
gully.the_geom
FROM selector_psector, gully
JOIN plan_psector_x_gully USING (gully_id)
JOIN cat_grate ON cat_grate.id=gully.gratecat_id
JOIN cat_feature ON cat_feature.id=gully.gully_type
WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

DROP VIEW IF EXISTS v_plan_psector_link;
CREATE OR REPLACE VIEW v_plan_psector_link AS 
SELECT row_number() OVER () AS rid,
a.link_id, 
a.psector_id,
a.feature_id,
a.original_state,
a.original_state_type,
a.plan_state,
a.doable,
a.the_geom FROM
(SELECT link.link_id,
plan_psector_x_connec.psector_id,
connec.connec_id AS feature_id,
connec.state AS original_state,
connec.state_type AS original_state_type,
plan_psector_x_connec.state AS plan_state,
plan_psector_x_connec.doable,
link.the_geom
FROM selector_psector,connec
JOIN plan_psector_x_connec USING (connec_id)
JOIN link ON link.feature_id=connec.connec_id
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text
UNION 
SELECT link.link_id,
plan_psector_x_gully.psector_id,
gully.gully_id AS feature_id,
gully.state AS original_state,
gully.state_type AS original_state_type,
plan_psector_x_gully.state AS plan_state,
plan_psector_x_gully.doable,
link.the_geom
FROM selector_psector,gully
JOIN plan_psector_x_gully USING (gully_id)
JOIN link ON link.feature_id=gully.gully_id
WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text)a;