/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



CREATE OR REPLACE VIEW v_state_connec AS 
(
         SELECT connec.connec_id, arc_id
           FROM selector_state,
            selector_expl,
            connec
          WHERE connec.state = selector_state.state_id AND connec.expl_id = selector_expl.expl_id AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
        EXCEPT
         SELECT plan_psector_x_connec.connec_id, plan_psector_x_connec.arc_id
           FROM selector_psector,
            selector_expl,
            plan_psector_x_connec
             JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
          WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
) UNION
 SELECT plan_psector_x_connec.connec_id, plan_psector_x_connec.arc_id
   FROM selector_psector,
    selector_expl,
    plan_psector_x_connec
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_link AS 
SELECT 
link.link_id,
    link.feature_type,
    link.feature_id,
    link.exit_type,
    link.exit_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.sector_id
            ELSE vnode.sector_id
        END AS sector_id,
    sector.macrosector_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.dma_id
            ELSE vnode.dma_id
        END AS dma_id,
    dma.macrodma_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.expl_id
            ELSE vnode.expl_id
        END AS expl_id,
    link.state,
    st_length2d(link.the_geom) AS gis_length,
    link.userdefined_geom,
case when plan_psector_x_connec.link_geom IS NULL THEN link.the_geom ELSE plan_psector_x_connec.link_geom END AS the_geom
from link 
LEFT JOIN vnode ON link.feature_id::text = vnode.vnode_id::text AND link.feature_type::text = 'VNODE'::text
join v_edit_connec ON feature_id=connec_id
join arc USING (arc_id)
JOIN sector ON sector.sector_id::text = v_edit_connec.sector_id::text
JOIN dma ON dma.dma_id::text = v_edit_connec.dma_id::text OR dma.dma_id::text = vnode.dma_id::text
left join plan_psector_x_connec USING (arc_id, connec_id);



CREATE OR REPLACE VIEW v_edit_vnode AS 
 SELECT vnode.vnode_id,
    vnode.vnode_type,
    vnode.sector_id,
    vnode.dma_id,
    vnode.state,
    vnode.annotation,
    case when plan_psector_x_connec.vnode_geom IS NULL THEN vnode.the_geom ELSE plan_psector_x_connec.vnode_geom END AS the_geom, 
    vnode.expl_id
   FROM vnode 
   JOIN v_edit_link ON exit_id::integer=vnode_id AND exit_type='VNODE'
   join v_edit_connec ON feature_id=connec_id
   join arc USING (arc_id)
   left join plan_psector_x_connec USING (arc_id, connec_id);
