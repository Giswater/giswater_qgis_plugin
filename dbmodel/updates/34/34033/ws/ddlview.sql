/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/02/27

DROP TRIGGER IF EXISTS gw_trg_vi_demands ON vi_demands;
CREATE TRIGGER gw_trg_vi_demands
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_demands
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_demands');


CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    inp_junction.demand,
    inp_junction.pattern_id,
    n.the_geom
   FROM selector_sector, v_edit_node n
     JOIN inp_junction USING (node_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;
  


CREATE OR REPLACE VIEW v_edit_inp_valve AS 
SELECT v_node.node_id,
            v_node.elevation,
            v_node.depth,
            v_node.nodecat_id,
            v_node.sector_id,
            v_node.macrosector_id,
            v_node.state,
            v_node.state_type,
            v_node.annotation,
            v_node.expl_id,
            inp_valve.valv_type,
            inp_valve.pressure,
            inp_valve.flow,
            inp_valve.coef_loss,
            inp_valve.curve_id,
            inp_valve.minorloss,
            inp_valve.to_arc,
            inp_valve.status,
            v_node.the_geom,
            inp_valve.custom_dint
           FROM selector_sector, v_node
             JOIN inp_valve USING (node_id)
               WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;
               


CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT DISTINCT ON (a.link_id) a.link_id,
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
            link.vnode_topelev,
            dma.macrodma_id,
            arc.expl_id,
            v_edit_connec.state,
            st_length2d(link.the_geom) AS gis_length,
            userdefined_geom,
            link.the_geom,
            false as ispsectorgeom,
            null::integer as psector_rowid,
            arc.fluid_type
           FROM v_edit_connec
             LEFT JOIN link ON link.feature_id::text = v_edit_connec.connec_id::text
             LEFT JOIN arc USING (arc_id)
             LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
	UNION
	    SELECT link.link_id,
            link.feature_type,
            link.feature_id,
            link.exit_type,
            link.exit_id,
            arc.sector_id,
            sector.macrosector_id,
            arc.dma_id,
            link.vnode_topelev,
            dma.macrodma_id,
            arc.expl_id,
            plan_psector_x_connec.state,
            st_length2d(plan_psector_x_connec.link_geom) AS gis_length,
            plan_psector_x_connec.userdefined_geom,
            plan_psector_x_connec.link_geom,
            true,
            plan_psector_x_connec.id AS psector_rowid,
            arc.fluid_type
           FROM plan_psector_x_connec, v_edit_connec
             LEFT JOIN link ON link.feature_id::text = v_edit_connec.connec_id::text
             LEFT JOIN arc USING (arc_id)
             LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
             WHERE v_edit_connec.arc_id = plan_psector_x_connec.arc_id AND v_edit_connec.connec_id = plan_psector_x_connec.connec_id) a
  WHERE (a.state IN ( SELECT selector_state.state_id
           FROM selector_state
          WHERE selector_state.cur_user = "current_user"()::text)) AND a.link_id IS NOT NULL;


CREATE OR REPLACE VIEW vi_valves AS 
 SELECT DISTINCT ON (a.arc_id) a.arc_id,
    a.node_1,
    a.node_2,
    a.diameter,
    a.valv_type,
    a.setting,
    a.minorloss
   FROM ( SELECT rpt_inp_arc.arc_id::text AS arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            ((rpt_inp_arc.addparam::json ->> 'valv_type'::text))::character varying(18) AS valv_type,
            rpt_inp_arc.addparam::json ->> 'pressure'::text AS setting,
            rpt_inp_arc.minorloss
           FROM selector_inp_result, rpt_inp_arc
          WHERE ((rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PRV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PSV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PBV'::text) AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'flow'::text AS setting,
            rpt_inp_arc.minorloss
           FROM selector_inp_result,
            rpt_inp_arc
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'FCV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'coefloss'::text AS setting,
            rpt_inp_arc.minorloss
           FROM selector_inp_result, rpt_inp_arc
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'TCV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'curve_id'::text AS setting,
            rpt_inp_arc.minorloss
           FROM selector_inp_result,
            rpt_inp_arc
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'GPV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            'PRV'::character varying(18) AS valv_type,
            rpt_inp_arc.addparam::json ->> 'pressure'::text AS setting,
            rpt_inp_arc.minorloss
           FROM selector_inp_result, rpt_inp_arc
             JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a_4')
          WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'pressure'::text AS setting,
            rpt_inp_arc.minorloss
           FROM selector_inp_result, rpt_inp_arc
          WHERE ((rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PRV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PSV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PBV'::text) 
          AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'flow'::text AS setting,
            rpt_inp_arc.minorloss
           FROM selector_inp_result, rpt_inp_arc
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'FCV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'coef_loss'::text AS setting,
            rpt_inp_arc.minorloss
           FROM selector_inp_result, rpt_inp_arc
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'TCV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'curve_id'::text AS setting,
            rpt_inp_arc.minorloss
           FROM selector_inp_result, rpt_inp_arc
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'GPV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text) a;

