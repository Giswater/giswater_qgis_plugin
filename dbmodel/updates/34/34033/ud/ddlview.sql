/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/02/28
CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.ymax,
    n.custom_ymax,
    n.elev,
    n.custom_elev,
    n.sys_elev,
    n.nodecat_id,
    n.sector_id,
    macrosector_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    inp_junction.outfallparam::text AS outfallparam,
    n.the_geom
   FROM selector_sector,  v_edit_node n
     JOIN inp_junction USING (node_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;
  
  
--2021/03/04
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
            c.state,
            st_length2d(link.the_geom) AS gis_length,
            userdefined_geom,	
            link.the_geom,
            false as ispsectorgeom,
            null::integer as psector_rowid
        FROM link
        RIGHT JOIN v_edit_connec c ON link.feature_id::text = c.connec_id::text
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
		    plan_psector_x_connec.state,
		    st_length2d(plan_psector_x_connec.link_geom) AS gis_length,
		    plan_psector_x_connec.userdefined_geom,
		    plan_psector_x_connec.link_geom,
		    true,
		    plan_psector_x_connec.id AS psector_rowid
		FROM plan_psector_x_connec, v_edit_connec c
		LEFT JOIN link ON link.feature_id::text = c.connec_id::text
		LEFT JOIN arc USING (arc_id)
		LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
		LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
		WHERE c.arc_id = plan_psector_x_connec.arc_id AND c.connec_id = plan_psector_x_connec.connec_id
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
            g.state,
            st_length2d(link.the_geom) AS gis_length,
            userdefined_geom,	
            link.the_geom,
            false as ispsectorgeom,
            null::integer as psector_rowid
        FROM link
        RIGHT JOIN v_edit_gully g ON link.feature_id::text = g.gully_id::text
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
		    g.fluid_type,
		    arc.sector_id,
		    arc.dma_id,
		    arc.expl_id,
		    plan_psector_x_gully.state,
		    st_length2d(plan_psector_x_gully.link_geom) AS gis_length,
		    plan_psector_x_gully.userdefined_geom,
		    plan_psector_x_gully.link_geom,
		    true,
		    plan_psector_x_gully.id AS psector_rowid
		FROM plan_psector_x_gully, v_edit_gully g
		LEFT JOIN link ON link.feature_id::text = g.gully_id::text
		LEFT JOIN arc USING (arc_id)
		LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
		LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
		WHERE g.arc_id = plan_psector_x_gully.arc_id AND g.gully_id = plan_psector_x_gully.gully_id) a
  WHERE (a.state IN ( SELECT selector_state.state_id
           FROM selector_state
          WHERE selector_state.cur_user = "current_user"()::text)) AND a.link_id IS NOT NULL;

