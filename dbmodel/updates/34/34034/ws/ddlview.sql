/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/22
CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    (rpt_inp_node.addparam::json ->> 'initlevel'::text)::numeric AS initlevel,
    (rpt_inp_node.addparam::json ->> 'minlevel'::text)::numeric AS minlevel,
    (rpt_inp_node.addparam::json ->> 'maxlevel'::text)::numeric AS maxlevel,
    (rpt_inp_node.addparam::json ->> 'diameter'::text)::numeric AS diameter,
    (rpt_inp_node.addparam::json ->> 'minvol'::text)::numeric AS minvol,
    (rpt_inp_node.addparam::json ->> 'curve_id'::text) AS curve_id
   FROM selector_inp_result, rpt_inp_node
  WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
  AND rpt_inp_node.epa_type::text = 'TANK'::text AND selector_inp_result.cur_user = "current_user"()::text;



-- 2021/04/01
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
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'GPV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            'PRV'::character varying(18) AS valv_type,
            rpt_inp_arc.addparam::json ->> 'pressure'::text AS setting,
            rpt_inp_arc.minorloss
           FROM selector_inp_result,rpt_inp_arc
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
           FROM selector_inp_result,rpt_inp_arc
          WHERE ((rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PRV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PSV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PBV'::text) AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'flow'::text AS setting,
            rpt_inp_arc.minorloss
           FROM selector_inp_result,rpt_inp_arc
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'FCV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'coef_loss'::text AS setting,
            rpt_inp_arc.minorloss
           FROM selector_inp_result,rpt_inp_arc
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
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'GPV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text) a;
		  

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
            1 AS link_class,
            NULL::integer AS psector_rowid
           FROM v_edit_connec c
             LEFT JOIN link ON link.feature_id::text = c.connec_id::text
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
                    WHEN p.link_geom IS NULL THEN 2
                    ELSE 3
                END AS link_class,
                p.id AS psector_rowid
	FROM link l, selector_psector s, selector_expl e, plan_psector_x_connec p
	JOIN connec c USING (connec_id)
	LEFT JOIN arc a ON a.arc_id = p.arc_id
	LEFT JOIN sector ON sector.sector_id::text = a.sector_id::text
	LEFT JOIN dma ON dma.dma_id::text = a.dma_id::text
	WHERE l.feature_id = p.connec_id AND p.state=1
	AND s.psector_id = p.psector_id AND s.cur_user = current_user AND e.expl_id = c.expl_id AND e.cur_user = current_user	
	) a
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
            WHEN a.vnode_topelev IS NULL THEN (a.elevation1 - a.locate * (a.elevation1 - a.elevation2))::numeric(12,3)::double precision
            ELSE a.vnode_topelev
        END AS vnode_topelev,
    (a.depth1 - a.locate * (a.depth1 - a.depth2))::numeric(12,3) AS vnode_ymax,
    (a.elev1 - a.locate * (a.elev1 - a.elev2))::numeric(12,3) AS vnode_elev
   FROM ( SELECT a_1.link_id,
            vnode.vnode_id,
            v_arc.arc_id,
            a_1.feature_type,
            a_1.feature_id,
            a_1.vnode_topelev,
            st_length(v_arc.the_geom) AS length,
            st_linelocatepoint(v_arc.the_geom, vnode.the_geom)::numeric(12,3) AS locate,
            v_arc.node_1,
            v_arc.node_2,
            v_arc.elevation1,
            v_arc.elevation2,
            v_arc.depth1,
            v_arc.depth2,
            v_arc.elevation1 - v_arc.depth1 AS elev1,
            v_arc.elevation2 - v_arc.depth2 AS elev2
           FROM v_arc,
            vnode
             JOIN v_edit_link a_1 ON vnode.vnode_id = a_1.exit_id::integer
          WHERE st_dwithin(v_arc.the_geom, vnode.the_geom, 0.01::double precision) AND v_arc.state > 0 AND vnode.state > 0) a
  ORDER BY a.arc_id, a.node_2 DESC;


CREATE OR REPLACE VIEW v_edit_vnode AS 
 SELECT a.vnode_id,
    a.feature_type,
    a.elev,
    a.sector_id,
    a.dma_id,
    a.state,
    a.the_geom,
    a.expl_id,
    a.ispsectorgeom,
    a.psector_rowid
   FROM ( SELECT DISTINCT ON (vnode.vnode_id) vnode.vnode_id,
            link.feature_type,
            vnode.elev,
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
          WHERE link.feature_id::text = v_state_connec.connec_id::text) a
  WHERE a.state > 0;