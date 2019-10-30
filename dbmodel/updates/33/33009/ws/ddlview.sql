/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
  
CREATE OR REPLACE VIEW vi_options AS 
SELECT * FROM (
 SELECT a.idval AS parameter,
        CASE
            WHEN a.idval = 'UNBALANCED'::text AND b.value = 'CONTINUE'::text THEN concat(b.value, ' ', ( SELECT config_param_user.value
               FROM config_param_user
              WHERE config_param_user.parameter::text = 'inp_options_unbalanced_n'::text AND config_param_user.cur_user::name = "current_user"()))
            WHEN a.idval = 'QUALITY'::text AND b.value = 'TRACE'::text THEN concat(b.value, ' ', ( SELECT config_param_user.value
               FROM config_param_user
              WHERE config_param_user.parameter::text = 'inp_options_node_id'::text AND config_param_user.cur_user::name = "current_user"()))
            WHEN a.idval = 'HYDRAULICS'::text AND (b.value = 'USE'::text OR b.value = 'SAVE'::text) THEN concat(b.value, ' ', ( SELECT config_param_user.value
               FROM config_param_user WHERE config_param_user.parameter::text = 'inp_options_hydraulics_fname'::text AND config_param_user.cur_user::name = "current_user"()))
             WHEN a.idval = 'HYDRAULICS'::text AND (b.value = 'NONE') THEN NULL
            ELSE b.value
        END AS value
  FROM audit_cat_param_user a
  JOIN config_param_user b ON a.id = b.parameter::text
	WHERE (a.layoutname = ANY (ARRAY['grl_general_1'::text, 'grl_general_2'::text, 'grl_hyd_3'::text, 'grl_hyd_4'::text, 'grl_quality_5'::text, 'grl_quality_6'::text])) 
	AND (a.idval <> ALL (ARRAY['UNBALANCED_N'::text, 'NODE_ID'::text, 'HYDRAULICS_FNAME'::text])) 
	AND b.cur_user::name = "current_user"() 
	AND b.value IS NOT NULL 
	AND b.parameter::text <> 'PATTERN'::text 
	AND b.value <> 'NULLVALUE'::text)a 
	WHERE parameter !='HYDRAULICS' OR  (parameter ='HYDRAULICS' AND value IS NOT NULL);
  
  
CREATE OR REPLACE VIEW vi_curves AS 
 SELECT 
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value,
    NULL::text AS other
   FROM 


   ( SELECT DISTINCT ON (inp_curve.curve_id) ( SELECT min(sub.id) AS min
                   FROM inp_curve sub
                  WHERE sub.curve_id::text = inp_curve.curve_id::text) AS id,
            inp_curve.curve_id,
            concat(';', inp_curve_id.curve_type, ':', inp_curve_id.descript) AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM inp_curve_id
             JOIN inp_curve ON inp_curve.curve_id::text = inp_curve_id.id::text
        UNION
         SELECT inp_curve.id,
            inp_curve.curve_id,
            inp_curve_id.curve_type,
            inp_curve.x_value,
            inp_curve.y_value
           FROM inp_curve
             JOIN inp_curve_id ON inp_curve.curve_id::text = inp_curve_id.id::text
  ORDER BY 1, 4 DESC) a

WHERE 
curve_id IN (SELECT curve_id FROM vi_tanks) OR
concat('HEAD ',curve_id) IN (SELECT head FROM vi_pumps) OR
concat('GPV ',curve_id) IN (SELECT setting FROM vi_valves) OR
curve_id IN (SELECT energyvalue FROM vi_energy WHERE idval = 'EFFIC');




CREATE OR REPLACE VIEW v_edit_inp_tank AS 
 SELECT DISTINCT ON (v_node.node_id) v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
	FROM inp_selector_sector,
    v_node
     JOIN inp_tank USING (node_id)
     JOIN vi_parent_arc a ON a.node_1::text = v_node.node_id::text OR a.node_2::text = v_node.node_id::text
  WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_reservoir AS 
 SELECT DISTINCT ON (v_node.node_id) v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_reservoir.pattern_id
   FROM inp_selector_sector,
    v_node
     JOIN inp_reservoir USING (node_id)
     JOIN vi_parent_arc a ON a.node_1::text = v_node.node_id::text OR a.node_2::text = v_node.node_id::text
  WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;
  

 CREATE OR REPLACE VIEW v_edit_inp_inlet AS 
 SELECT DISTINCT ON (v_node.node_id) v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.pattern_id
   FROM inp_selector_sector,
    v_node
     JOIN inp_inlet USING (node_id)
     JOIN vi_parent_arc a ON a.node_1::text = v_node.node_id::text OR a.node_2::text = v_node.node_id::text
  WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

  
CREATE OR REPLACE VIEW v_edit_vnode AS 
 SELECT a.vnode_id,
    a.vnode_type,
    a.feature_type,
    a.elev,
    a.sector_id,
    a.dma_id,
    a.state,
    a.annotation,
    a.the_geom,
    a.expl_id,
    a.rotation,
    a.ispsectorgeom,
    a.psector_rowid
   FROM ( SELECT DISTINCT ON (vnode.vnode_id) vnode.vnode_id,
            vnode.vnode_type,
            link.feature_type,
            vnode.elev,
            vnode.sector_id,
            vnode.dma_id,
                CASE
                    WHEN plan_psector_x_connec.vnode_geom IS NULL THEN link.state
                    ELSE plan_psector_x_connec.state
                END AS state,
            vnode.annotation,
                CASE
                    WHEN plan_psector_x_connec.vnode_geom IS NULL THEN vnode.the_geom
                    ELSE plan_psector_x_connec.vnode_geom
                END AS the_geom,
            vnode.expl_id,
            vnode.rotation,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN false
                    ELSE true
                END AS ispsectorgeom,
                CASE
                    WHEN plan_psector_x_connec.link_geom IS NULL THEN NULL::integer
                    ELSE plan_psector_x_connec.id
                END AS psector_rowid
           FROM v_edit_link link
             JOIN vnode ON link.exit_id::text = vnode.vnode_id::text AND link.exit_type::text = 'VNODE'::text
             LEFT JOIN v_state_connec ON link.feature_id::text = v_state_connec.connec_id::text
             LEFT JOIN plan_psector_x_connec USING (arc_id, connec_id)
          WHERE link.feature_id::text = v_state_connec.connec_id::text) a
  WHERE a.state < 2;

  
