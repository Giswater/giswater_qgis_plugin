/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 14/10/2019

CREATE OR REPLACE VIEW v_rpt_arc_all AS 
 SELECT rpt_arc.id,
    arc.arc_id,
    rpt_selector_result.result_id,
    arc.arc_type,
    arc.arccat_id,
    rpt_arc.flow,
    rpt_arc.velocity,
    rpt_arc.fullpercent,
    rpt_arc.resultdate,
    rpt_arc.resulttime,
    arc.the_geom
   FROM rpt_selector_result,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text AND arc.result_id::text = rpt_selector_result.result_id::text
  ORDER BY  arc.arc_id;

CREATE OR REPLACE VIEW v_rpt_arc_timestep AS 
 SELECT rpt_arc.id,
    arc.arc_id,
    rpt_selector_result.result_id,
    rpt_arc.flow,
    rpt_arc.velocity,
    rpt_arc.fullpercent,
    rpt_arc.resultdate,
    rpt_arc.resulttime,
    arc.the_geom
   FROM rpt_selector_result,
    rpt_selector_timestep,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = rpt_selector_result.result_id::text AND rpt_arc.resulttime::text = rpt_selector_timestep.resulttime::text AND rpt_selector_result.cur_user = "current_user"()::text AND rpt_selector_timestep.cur_user = "current_user"()::text AND arc.result_id::text = rpt_selector_result.result_id::text
  ORDER BY rpt_arc.resulttime, arc.arc_id;


CREATE OR REPLACE VIEW v_rpt_arc_compare_all AS 
 SELECT rpt_arc.id,
    arc.arc_id,
    rpt_selector_compare.result_id,
    arc.arc_type,
    arc.arccat_id,
    rpt_arc.flow,
    rpt_arc.velocity,
    rpt_arc.fullpercent,
    rpt_arc.resultdate,
    rpt_arc.resulttime,
    arc.the_geom
   FROM rpt_selector_compare,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text AND arc.result_id::text = rpt_selector_compare.result_id::text
  ORDER BY  arc.arc_id;


CREATE OR REPLACE VIEW v_rpt_arc_compare_timestep AS 
 SELECT rpt_arc.id,
    arc.arc_id,
    rpt_selector_compare.result_id,
    rpt_arc.flow,
    rpt_arc.velocity,
    rpt_arc.fullpercent,
    rpt_arc.resultdate,
    rpt_arc.resulttime,
    arc.the_geom
   FROM rpt_selector_compare,
    rpt_selector_timestep_compare,
    rpt_inp_arc arc
     JOIN rpt_arc ON rpt_arc.arc_id::text = arc.arc_id::text
  WHERE rpt_arc.result_id::text = rpt_selector_compare.result_id::text AND rpt_arc.resulttime::text = rpt_selector_timestep_compare.resulttime::text AND rpt_selector_compare.cur_user = "current_user"()::text AND rpt_selector_timestep_compare.cur_user = "current_user"()::text AND arc.result_id::text = rpt_selector_compare.result_id::text
  ORDER BY rpt_arc.resulttime, arc.arc_id;

-- vistas rpt_node

CREATE OR REPLACE VIEW v_rpt_node_all AS 
 SELECT rpt_node.id,
    node.node_id,
    rpt_selector_result.result_id,
    node.node_type,
    node.nodecat_id,
    rpt_node.resultdate,
    rpt_node.resulttime,
    rpt_node.flooding,
    rpt_node.depth,
    rpt_node.head,
    node.the_geom
   FROM rpt_selector_result,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text AND node.result_id::text = rpt_selector_result.result_id::text
  GROUP BY rpt_node.id, node.node_id, node.node_type, node.nodecat_id, rpt_selector_result.result_id, node.the_geom
  ORDER BY node.node_id;


CREATE OR REPLACE VIEW v_rpt_node_timestep AS 
 SELECT rpt_node.id,
    node.node_id,
    rpt_selector_result.result_id,
    node.node_type,
    node.nodecat_id,
    rpt_node.resultdate,
    rpt_node.resulttime,
    rpt_node.flooding,
    rpt_node.depth,
    rpt_node.head,
    node.the_geom
   FROM rpt_selector_result,
    rpt_selector_timestep,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = rpt_selector_result.result_id::text AND rpt_node.resulttime::text = rpt_selector_timestep.resulttime::text AND rpt_selector_result.cur_user = "current_user"()::text AND rpt_selector_timestep.cur_user = "current_user"()::text AND node.result_id::text = rpt_selector_result.result_id::text
  ORDER BY rpt_node.resulttime, node.node_id;


CREATE OR REPLACE VIEW v_rpt_node_compare_all AS 
 SELECT rpt_node.id,
    node.node_id,
    rpt_selector_compare.result_id,
    node.node_type,
    node.nodecat_id,
    rpt_node.resultdate,
    rpt_node.resulttime,
    rpt_node.flooding,
    rpt_node.depth,
    rpt_node.head,
    node.the_geom
   FROM rpt_selector_compare,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text AND node.result_id::text = rpt_selector_compare.result_id::text
  GROUP BY rpt_node.id, node.node_id, node.node_type, node.nodecat_id, rpt_selector_compare.result_id, node.the_geom
  ORDER BY node.node_id;


CREATE OR REPLACE VIEW v_rpt_node_compare_timestep AS 
 SELECT rpt_node.id,
    node.node_id,
    rpt_selector_compare.result_id,
    node.node_type,
    node.nodecat_id,
    rpt_node.resultdate,
    rpt_node.resulttime,
    rpt_node.flooding,
    rpt_node.depth,
    rpt_node.head,
    node.the_geom
   FROM rpt_selector_compare,
    rpt_selector_timestep_compare,
    rpt_inp_node node
     JOIN rpt_node ON rpt_node.node_id::text = node.node_id::text
  WHERE rpt_node.result_id::text = rpt_selector_compare.result_id::text AND rpt_node.resulttime::text = rpt_selector_timestep_compare.resulttime::text AND rpt_selector_compare.cur_user = "current_user"()::text AND rpt_selector_timestep_compare.cur_user = "current_user"()::text AND node.result_id::text = rpt_selector_compare.result_id::text
  ORDER BY rpt_node.resulttime, node.node_id;

  
CREATE OR REPLACE VIEW v_edit_link AS
SELECT * FROM (SELECT link.link_id,
   link.feature_type,
   link.feature_id,
   sector.macrosector_id,
   dma.macrodma_id,
   link.exit_type,
   link.exit_id,
   arc.sector_id,
   arc.dma_id,
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
        WHEN plan_psector_x_connec.link_geom IS NULL THEN NULL
        ELSE plan_psector_x_connec.id
    END AS psector_rowid
	FROM link
    JOIN v_state_connec ON link.feature_id::text = v_state_connec.connec_id::text
    JOIN arc USING (arc_id)
    JOIN sector ON sector.sector_id::text = arc.sector_id::text
    JOIN dma ON dma.dma_id::text = arc.dma_id::text
    LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)
    WHERE link.feature_id::text = v_state_connec.connec_id::text
UNION
SELECT link.link_id,
   link.feature_type,
   link.feature_id,
   sector.macrosector_id,
   dma.macrodma_id,
   link.exit_type,
   link.exit_id,
   arc.sector_id,
   arc.dma_id,
   arc.expl_id,
       CASE
       WHEN plan_psector_x_gully.link_geom IS NULL THEN link.state
       ELSE plan_psector_x_gully.state
    END AS state,
    st_length2d(link.the_geom) AS gis_length,
    CASE
        WHEN plan_psector_x_gully.link_geom IS NULL THEN link.userdefined_geom
        ELSE plan_psector_x_gully.userdefined_geom
    END AS userdefined_geom,
    CASE
        WHEN plan_psector_x_gully.link_geom IS NULL THEN link.the_geom
        ELSE plan_psector_x_gully.link_geom
    END AS the_geom,
	CASE
        WHEN plan_psector_x_gully.link_geom IS NULL THEN false
        ELSE true
    END AS ispsectorgeom,
    CASE
        WHEN plan_psector_x_gully.link_geom IS NULL THEN NULL
        ELSE plan_psector_x_gully.id
    END AS psector_rowid
	FROM link
    JOIN v_state_gully ON link.feature_id::text = v_state_gully.gully_id::text
    LEFT JOIN arc USING (arc_id)
    JOIN sector ON sector.sector_id::text = arc.sector_id::text
    JOIN dma ON dma.dma_id::text = arc.dma_id::text
    LEFT JOIN plan_psector_x_gully USING (arc_id, gully_id)
    WHERE link.feature_id::text = v_state_gully.gully_id::text) a
   WHERE state < 2;
   
    
CREATE OR REPLACE VIEW v_edit_vnode AS
SELECT * FROM (SELECT DISTINCT ON (vnode.vnode_id) vnode.vnode_id,
   vnode.vnode_type,
   vnode.top_elev,
   arc.sector_id,
   arc.dma_id,
    CASE
        WHEN plan_psector_x_connec.vnode_geom IS NULL THEN link.state
        ELSE plan_psector_x_connec.state
    END AS state,
    vnode.annotation,
    CASE
        WHEN plan_psector_x_connec.vnode_geom IS NULL THEN vnode.the_geom
        ELSE plan_psector_x_connec.vnode_geom
    END AS the_geom,
    arc.expl_id,
    vnode.rotation,
    CASE
        WHEN plan_psector_x_connec.link_geom IS NULL THEN false
        ELSE true
    END AS ispsectorgeom,
    CASE
        WHEN plan_psector_x_connec.link_geom IS NULL THEN NULL
        ELSE plan_psector_x_connec.id
    END AS psector_rowid,
	'CONNEC' as feature_type
   FROM link
    JOIN vnode ON link.exit_id::integer = vnode.vnode_id AND link.exit_type::text = 'VNODE'::text
    JOIN v_state_connec ON link.feature_id::text = v_state_connec.connec_id::text
    JOIN arc USING (arc_id)
    JOIN sector ON sector.sector_id::text = arc.sector_id::text
    JOIN dma ON dma.dma_id::text = arc.dma_id::text
    LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)
    WHERE link.feature_id::text = v_state_connec.connec_id::text
UNION
SELECT vnode.vnode_id,
   vnode.vnode_type,
   vnode.top_elev,
   arc.sector_id,
   arc.dma_id,
    CASE
        WHEN plan_psector_x_gully.vnode_geom IS NULL THEN link.state
        ELSE plan_psector_x_gully.state
    END AS state,
    vnode.annotation,
    CASE
        WHEN plan_psector_x_gully.vnode_geom IS NULL THEN vnode.the_geom
        ELSE plan_psector_x_gully.vnode_geom
    END AS the_geom,
    arc.expl_id,
    vnode.rotation,
    CASE
        WHEN plan_psector_x_gully.link_geom IS NULL THEN false
        ELSE true
    END AS ispsectorgeom,
    CASE
        WHEN plan_psector_x_gully.link_geom IS NULL THEN NULL
        ELSE plan_psector_x_gully.id
    END AS psector_rowid,
	'GULLY' as feature_type
   FROM link
    JOIN vnode ON link.exit_id::integer = vnode.vnode_id AND link.exit_type::text = 'VNODE'::text
    JOIN v_state_gully ON link.feature_id::text = v_state_gully.gully_id::text
    JOIN arc USING (arc_id)
    JOIN sector ON sector.sector_id::text = arc.sector_id::text
    JOIN dma ON dma.dma_id::text = arc.dma_id::text
    LEFT JOIN plan_psector_x_gully USING (arc_id, gully_id)
    WHERE link.feature_id::text = v_state_gully.gully_id::text) a
	WHERE state < 2;

  
