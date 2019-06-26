/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;





CREATE OR REPLACE VIEW v_state_gully AS 
(
         SELECT gully.gully_id
           FROM selector_state,
            selector_expl,
            gully
          WHERE gully.state = selector_state.state_id AND gully.expl_id = selector_expl.expl_id AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
        EXCEPT
         SELECT plan_psector_x_gully.gully_id
           FROM selector_psector,
            selector_expl,
            plan_psector_x_gully
             JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
          WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_gully.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
) UNION
 SELECT plan_psector_x_gully.gully_id
   FROM selector_psector,
    selector_expl,
    plan_psector_x_gully
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
  WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_gully.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT link.link_id,
    link.feature_type,
    link.feature_id,
    sector.macrosector_id,
    dma.macrodma_id,
    link.exit_type,
    link.exit_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.sector_id
            ELSE vnode.sector_id
        END AS sector_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.dma_id
            ELSE vnode.dma_id
        END AS dma_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN v_edit_connec.expl_id
            ELSE vnode.expl_id
        END AS expl_id,
    link.state,
    st_length2d(link.the_geom) AS gis_length,
    link.userdefined_geom,
    link.the_geom
   FROM selector_expl,
    selector_state,
    link
     JOIN v_edit_connec ON link.feature_id::text = v_edit_connec.connec_id::text AND link.feature_type::text = 'CONNEC'::text
     LEFT JOIN vnode ON link.feature_id::text = vnode.vnode_id::text AND link.feature_type::text = 'VNODE'::text
     LEFT JOIN sector ON sector.sector_id = v_edit_connec.sector_id
     LEFT JOIN dma ON dma.dma_id = v_edit_connec.dma_id
  WHERE link.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND link.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
UNION
SELECT link.link_id,
    link.feature_type,
    link.feature_id,
    sector.macrosector_id,
    dma.macrodma_id,
    link.exit_type,
    link.exit_id,
        CASE
            WHEN link.feature_type::text = 'GULLY'::text THEN v_edit_gully.sector_id
            ELSE vnode.sector_id
        END AS sector_id,
        CASE
            WHEN link.feature_type::text = 'GULLY'::text THEN v_edit_gully.dma_id
            ELSE vnode.dma_id
        END AS dma_id,
        CASE
            WHEN link.feature_type::text = 'GULLY'::text THEN v_edit_gully.expl_id
            ELSE vnode.expl_id
        END AS expl_id,
    link.state,
    st_length2d(link.the_geom) AS gis_length,
    link.userdefined_geom,
    link.the_geom
   FROM selector_expl,
    selector_state,
    link
     LEFT JOIN v_edit_gully ON link.feature_id::text = v_edit_gully.gully_id::text AND link.feature_type::text = 'GULLY'::text
     LEFT JOIN vnode ON link.feature_id::text = vnode.vnode_id::text AND link.feature_type::text = 'VNODE'::text
     LEFT JOIN sector ON sector.sector_id = v_edit_gully.sector_id
     LEFT JOIN dma ON dma.dma_id = v_edit_gully.dma_id
  WHERE link.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND link.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text;


