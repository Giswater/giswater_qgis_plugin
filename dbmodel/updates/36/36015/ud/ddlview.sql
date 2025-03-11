/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_edit_inp_dwf AS 
 SELECT i.dwfscenario_id,
    node_id,
    i.value,
    i.pat1,
    i.pat2,
    i.pat3,
    i.pat4,
    the_geom
   FROM config_param_user c, inp_dwf i
   JOIN v_edit_inp_junction USING (node_id)
   WHERE c.cur_user::name = CURRENT_USER AND c.parameter::text = 'inp_options_dwfscenario'::text AND c.value::integer = i.dwfscenario_id;


DROP VIEW v_edit_inp_orifice;
 CREATE OR REPLACE VIEW v_edit_inp_orifice AS 
 SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.y1,
    v_edit_arc.custom_y1,
    v_edit_arc.elev1,
    v_edit_arc.custom_elev1,
    v_edit_arc.sys_elev1,
    v_edit_arc.y2,
    v_edit_arc.custom_y2,
    v_edit_arc.elev2,
    v_edit_arc.custom_elev2,
    v_edit_arc.sys_elev2,
    v_edit_arc.arccat_id,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.annotation,
    v_edit_arc.inverted_slope,
    v_edit_arc.custom_length,
    v_edit_arc.expl_id,
    inp_orifice.ori_type,
    inp_orifice.offsetval,
    inp_orifice.cd,
    inp_orifice.orate,
    inp_orifice.flap,
    inp_orifice.shape,
    inp_orifice.geom1,
    inp_orifice.geom2,
    v_edit_arc.the_geom,
    inp_orifice.close_time
   FROM v_edit_arc
     JOIN inp_orifice USING (arc_id)
  WHERE v_edit_arc.is_operative IS TRUE;

CREATE TRIGGER gw_trg_edit_inp_arc_orifice
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_orifice
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_orifice');


CREATE OR REPLACE VIEW v_edit_inp_subcatchment AS 
 SELECT a.* from (SELECT inp_subcatchment.hydrology_id,
    inp_subcatchment.subc_id,
    inp_subcatchment.outlet_id,
    inp_subcatchment.rg_id,
    inp_subcatchment.area,
    inp_subcatchment.imperv,
    inp_subcatchment.width,
    inp_subcatchment.slope,
    inp_subcatchment.clength,
    inp_subcatchment.snow_id,
    inp_subcatchment.nimp,
    inp_subcatchment.nperv,
    inp_subcatchment.simp,
    inp_subcatchment.sperv,
    inp_subcatchment.zero,
    inp_subcatchment.routeto,
    inp_subcatchment.rted,
    inp_subcatchment.maxrate,
    inp_subcatchment.minrate,
    inp_subcatchment.decay,
    inp_subcatchment.drytime,
    inp_subcatchment.maxinfil,
    inp_subcatchment.suction,
    inp_subcatchment.conduct,
    inp_subcatchment.initdef,
    inp_subcatchment.curveno,
    inp_subcatchment.conduct_2,
    inp_subcatchment.drytime_2,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom,
    inp_subcatchment.descript,
    inp_subcatchment.minelev,
    muni_id
   FROM inp_subcatchment
   LEFT JOIN node ON node_id = outlet_id
   ) a, config_param_user, selector_sector, selector_municipality
   WHERE a.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
   AND a.muni_id = selector_municipality.muni_id AND selector_municipality.cur_user = "current_user"()::text 
   AND a.hydrology_id = config_param_user.value::integer AND config_param_user.cur_user::text = "current_user"()::text 
   AND config_param_user.parameter::text = 'inp_options_hydrology_scenario'::text;



CREATE OR REPLACE VIEW v_rpt_arcflow_sum AS 
 SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_arcflow_sum.arc_type AS swarc_type,
    rpt_arcflow_sum.max_flow,
    rpt_arcflow_sum.time_days,
    rpt_arcflow_sum.time_hour,
    rpt_arcflow_sum.max_veloc,
    coalesce(rpt_arcflow_sum.mfull_flow,0::numeric(12,4)) as mfull_flow,
    coalesce(rpt_arcflow_sum.mfull_dept,0::numeric(12,4)) as mfull_dept,
    rpt_arcflow_sum.max_shear,
    rpt_arcflow_sum.max_hr,
    rpt_arcflow_sum.max_slope,
    rpt_arcflow_sum.day_max,
    rpt_arcflow_sum.time_max,
    rpt_arcflow_sum.min_shear,
    rpt_arcflow_sum.day_min,
    rpt_arcflow_sum.time_min
   FROM selector_rpt_main,
    rpt_inp_arc
     JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_arcflow_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_main.result_id::text;



CREATE OR REPLACE VIEW v_state_link_connec AS 
WITH 
p AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active), 
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
	UNION ALL
SELECT DISTINCT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW v_state_link_gully AS 
WITH 
p AS (SELECT gully_id, psector_id, state, link_id FROM plan_psector_x_gully WHERE active), 
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
	UNION ALL
SELECT DISTINCT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW v_state_link AS
WITH 
c AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active), 
g AS (SELECT gully_id, psector_id, state, link_id FROM plan_psector_x_gully WHERE active), 
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT c.link_id FROM sp, se, c JOIN l USING (link_id) WHERE c.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND c.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
	EXCEPT ALL
SELECT g.link_id FROM sp, se, g JOIN l USING (link_id) WHERE g.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND g.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
	UNION ALL
SELECT DISTINCT c.link_id FROM sp, se, c JOIN l USING (link_id) WHERE c.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND c.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
	UNION ALL
SELECT DISTINCT g.link_id FROM sp, se, g JOIN l USING (link_id) WHERE g.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND g.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;
   

