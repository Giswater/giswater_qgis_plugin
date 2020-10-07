/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/09/29
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
		CASE
                    WHEN plan_psector_x_connec.connec_id IS NULL OR plan_psector_x_connec.state = 0 THEN link.state
                    ELSE plan_psector_x_connec.state
                END AS state,
                CASE
                    WHEN plan_psector_x_connec.connec_id IS NULL OR plan_psector_x_connec.state = 0 THEN st_length2d(link.the_geom)
                    ELSE st_length2d(plan_psector_x_connec.link_geom)
                END AS gis_length,
                CASE
                    WHEN plan_psector_x_connec.connec_id IS NULL OR plan_psector_x_connec.state = 0 THEN link.userdefined_geom
                    ELSE plan_psector_x_connec.userdefined_geom
                END AS userdefined_geom,
                CASE
                    WHEN plan_psector_x_connec.connec_id IS NULL OR plan_psector_x_connec.state = 0 THEN link.the_geom
                    ELSE plan_psector_x_connec.link_geom
                END AS the_geom,
                CASE
                    WHEN plan_psector_x_connec.connec_id IS NULL OR plan_psector_x_connec.state = 0 THEN false
                    ELSE true
                END AS ispsectorgeom,
                CASE
                    WHEN plan_psector_x_connec.connec_id IS NULL OR plan_psector_x_connec.state = 0 THEN NULL::integer
                    ELSE plan_psector_x_connec.id
                END AS psector_rowid,
            arc.fluid_type
           FROM link
             RIGHT JOIN v_edit_connec ON link.feature_id::text = v_edit_connec.connec_id::text
             LEFT JOIN arc USING (arc_id)
             LEFT JOIN sector ON sector.sector_id::text = arc.sector_id::text
             LEFT JOIN dma ON dma.dma_id::text = arc.dma_id::text
             LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)) a
  WHERE a.state > 0 AND a.link_id IS NOT NULL;



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
  
  
-- 2020/10/06  
DROP VIEW IF EXISTS vi_demands; 
CREATE OR REPLACE VIEW vi_demands AS 
SELECT inp_demand.feature_id,
    inp_demand.demand,
    inp_demand.pattern_id,
    inp_demand.demand_type,
    inp_demand.feature_type
   FROM selector_inp_demand, inp_demand
  WHERE  selector_inp_demand.dscenario_id::text = inp_demand.dscenario_id::text AND selector_inp_demand.cur_user = "current_user"()::text
ORDER BY 1;


CREATE OR REPLACE VIEW vi_curves AS 
SELECT
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value,
    NULL::text AS other
   FROM ( 

   SELECT DISTINCT ON (inp_curve_value.curve_id) ( SELECT min(sub.id) AS min
                   FROM inp_curve_value sub
                  WHERE sub.curve_id::text = inp_curve_value.curve_id::text) AS id,
            inp_curve_value.curve_id,
            concat(';', inp_curve.curve_type, ':', inp_curve.descript) AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM inp_curve
             JOIN inp_curve_value ON inp_curve_value.curve_id::text = inp_curve.id::text
        UNION
         SELECT inp_curve_value.id,
            inp_curve_value.curve_id,
            inp_curve.curve_type,
            inp_curve_value.x_value,
            inp_curve_value.y_value
           FROM inp_curve_value
             JOIN inp_curve ON inp_curve_value.curve_id::text = inp_curve.id::text
  ORDER BY 1, 4 DESC
  ) a
  WHERE (a.curve_id::text IN ( SELECT vi_tanks.curve_id FROM vi_tanks)) OR 
        (concat('HEAD ', a.curve_id) IN ( SELECT vi_pumps.head FROM vi_pumps)) OR 
        (a.curve_id::text IN ( SELECT vi_valves.setting FROM vi_valves)) OR 
        (a.curve_id::text IN ( SELECT vi_energy.energyvalue FROM vi_energy  WHERE vi_energy.idval::text = 'EFFIC'::text)) OR 
          ((( SELECT config_param_user.value FROM config_param_user WHERE config_param_user.parameter::text = 'inp_options_buildup_mode'::text AND config_param_user.cur_user::name = "current_user"()))::integer) = 1;



CREATE OR REPLACE VIEW vi_pumps AS 
SELECT * FROM (
SELECT temp_arc.arc_id,
    temp_arc.node_1,
    temp_arc.node_2,
        CASE
            WHEN (temp_arc.addparam::json ->> 'power'::text) <> ''::text THEN ('POWER'::text || ' '::text) || (temp_arc.addparam::json ->> 'power'::text)
            ELSE NULL::text
        END AS power,
        CASE
            WHEN (temp_arc.addparam::json ->> 'curve_id'::text) <> ''::text THEN ('HEAD'::text || ' '::text) || (temp_arc.addparam::json ->> 'curve_id'::text)
            ELSE NULL::text
        END AS head,
        CASE
            WHEN (temp_arc.addparam::json ->> 'speed'::text) <> ''::text THEN ('SPEED'::text || ' '::text) || (temp_arc.addparam::json ->> 'speed'::text)
            ELSE NULL::text
        END AS speed,
        CASE
            WHEN (temp_arc.addparam::json ->> 'pattern'::text) <> ''::text THEN ('PATTERN'::text || ' '::text) || (temp_arc.addparam::json ->> 'pattern'::text)
            ELSE NULL::text
        END AS pattern
   FROM selector_inp_result, temp_arc
  WHERE temp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text)a
WHERE power IS NOT NULL OR head IS NOT NULL OR speed IS NOT NULL or pattern IS NOT NULL;


DROP VIEW IF EXISTS v_edit_inp_demand;
CREATE OR REPLACE VIEW v_edit_inp_demand AS 
 SELECT inp_demand.id,
    inp_demand.feature_id,
    inp_demand.demand,
    inp_demand.pattern_id,
    inp_demand.demand_type,
    inp_demand.dscenario_id,
    inp_demand.feature_type
   FROM selector_sector,
    selector_inp_demand,
    inp_demand
     JOIN v_node ON v_node.node_id::text = inp_demand.feature_id::text
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND inp_demand.dscenario_id = selector_inp_demand.dscenario_id AND selector_inp_demand.cur_user = "current_user"()::text
UNION
 SELECT inp_demand.id,
    inp_demand.feature_id,
    inp_demand.demand,
    inp_demand.pattern_id,
    inp_demand.demand_type,
    inp_demand.dscenario_id,
    inp_demand.feature_type
   FROM selector_sector,
    selector_inp_demand,
    inp_demand
     JOIN v_connec ON v_connec.connec_id::text = inp_demand.feature_id::text
  WHERE v_connec.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND inp_demand.dscenario_id = selector_inp_demand.dscenario_id AND selector_inp_demand.cur_user = "current_user"()::text;
