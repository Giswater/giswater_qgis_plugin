/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT link.link_id,
    link.feature_type,
    link.feature_id,
    link.exit_type,
    link.exit_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN connec.sector_id
            ELSE vnode.sector_id
        END AS sector_id,
    sector.macrosector_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN connec.dma_id
            ELSE vnode.dma_id
        END AS dma_id,
    dma.macrodma_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN connec.expl_id
            ELSE vnode.expl_id
        END AS expl_id,
    link.state,
    st_length2d(link.the_geom) AS gis_length,
    link.userdefined_geom,
        CASE
            WHEN plan_psector_x_connec.link_geom IS NULL THEN link.the_geom
            ELSE plan_psector_x_connec.link_geom
        END AS the_geom
   FROM link
     LEFT JOIN vnode ON link.feature_id::text = vnode.vnode_id::text AND link.feature_type::text = 'VNODE'::text
     JOIN connec ON link.feature_id::text = connec.connec_id::text
     LEFT JOIN arc USING (arc_id)
     JOIN sector ON sector.sector_id::text = connec.sector_id::text
     JOIN dma ON dma.dma_id::text = connec.dma_id::text OR dma.dma_id::text = vnode.dma_id::text
     LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id);
     

     
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
   FROM vnode
     JOIN v_edit_link ON v_edit_link.exit_id::integer = vnode.vnode_id AND v_edit_link.exit_type::text = 'VNODE'::text
     JOIN connec ON v_edit_link.feature_id::text = connec.connec_id::text
     JOIN arc USING (arc_id)
     LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id);
	
	
	

CREATE OR REPLACE VIEW vi_pipes AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
        CASE
            WHEN rpt_inp_arc.minorloss IS NULL THEN 0::numeric(12,6)
            ELSE rpt_inp_arc.minorloss
        END AS minorloss,
    inp_typevalue.idval AS status
   FROM inp_selector_result,
    rpt_inp_arc
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = rpt_inp_arc.status::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text 
  AND inp_typevalue.typevalue::text = 'inp_value_status_pipe'::text AND (rpt_inp_arc.epa_type::text = 'SHORTPIPE'::text OR rpt_inp_arc.epa_type::text = 'PIPE'::text)
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
        CASE
            WHEN inp_shortpipe.minorloss IS NULL THEN 0::numeric(12,6)
            ELSE inp_shortpipe.minorloss
        END AS minorloss,
    inp_typevalue.idval AS status
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_shortpipe ON rpt_inp_arc.arc_id::text = concat(inp_shortpipe.node_id, '_n2a')
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_shortpipe.status::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_status_pipe'::text;

