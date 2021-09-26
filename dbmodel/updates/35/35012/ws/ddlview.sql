/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/08/19
DROP VIEW IF EXISTS v_edit_inp_dscenario_pipe;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_pipe AS 
 SELECT
    d.dscenario_id,
    p.arc_id,
    minorloss,
    status,
    roughness,
    dint
   FROM selector_sector, selector_inp_dscenario, v_arc
     JOIN inp_dscenario_pipe p USING (arc_id)
	 JOIN cat_dscenario d USING (dscenario_id)
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text
  AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_dscenario_shortpipe;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_shortpipe AS 
 SELECT
    d.dscenario_id,
    p.node_id,
    minorloss,
    status
   FROM selector_sector, selector_inp_dscenario, v_node
     JOIN inp_dscenario_shortpipe p USING (node_id)
	 JOIN cat_dscenario d USING (dscenario_id)
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text
  AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS v_edit_inp_dscenario_pump;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump AS 
 SELECT
    d.dscenario_id,
    p.node_id,
    power,
    curve_id,
    speed,
    pattern,
    status
   FROM selector_sector, selector_inp_dscenario, v_node
     JOIN inp_dscenario_pump p USING (node_id)
	 JOIN cat_dscenario d USING (dscenario_id)
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text
  AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;



DROP VIEW IF EXISTS v_edit_inp_dscenario_valve;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_valve AS 
 SELECT
    d.dscenario_id,
    p.node_id,
    valv_type,
    pressure,
    flow,
    coef_loss,
    curve_id,
    minorloss,
    status
   FROM selector_sector, selector_inp_dscenario, v_node
     JOIN inp_dscenario_valve p USING (node_id)
	 JOIN cat_dscenario d USING (dscenario_id)
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text
  AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_dscenario_reservoir;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_reservoir AS 
 SELECT
    d.dscenario_id,
    p.node_id,
    pattern_id,
    head 
   FROM selector_sector, selector_inp_dscenario, v_node
     JOIN inp_dscenario_reservoir p USING (node_id)
	 JOIN cat_dscenario d USING (dscenario_id)
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text
  AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_dscenario_tank;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_tank AS 
 SELECT
    d.dscenario_id,
    p.node_id,
    initlevel,
    minlevel,
    maxlevel,
    diameter,
    minvol,
    curve_id
   FROM selector_sector, selector_inp_dscenario, v_node
     JOIN inp_dscenario_tank p USING (node_id)
	 JOIN cat_dscenario d USING (dscenario_id)
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text
  AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_pol_register AS 
SELECT polygon.pol_id,
polygon.feature_id as node_id,
polygon.the_geom
FROM v_node
JOIN polygon ON polygon.feature_id::text = v_node.node_id::text
WHERE polygon.sys_type='REGISTER';

CREATE OR REPLACE VIEW ve_pol_tank AS 
SELECT polygon.pol_id,
polygon.feature_id as node_id,
polygon.the_geom
FROM v_node
JOIN polygon ON polygon.feature_id::text = v_node.node_id::text
WHERE polygon.sys_type='TANK';

CREATE OR REPLACE VIEW ve_pol_fountain AS 
SELECT polygon.pol_id,
polygon.feature_id as connec_id,
polygon.the_geom
FROM v_connec
JOIN polygon ON polygon.feature_id::text = v_connec.connec_id::text
WHERE polygon.sys_type='FOUNTAIN';



CREATE OR REPLACE VIEW ws_sample.v_edit_inp_valve AS 
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
    inp_valve.custom_dint,
    inp_valve.add_settings
   FROM selector_sector, v_node
     JOIN inp_valve USING (node_id)
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


-- 2021/09/26
CREATE OR REPLACE VIEW v_edit_inp_dscenario_valve AS 
 SELECT d.dscenario_id,
    p.node_id,
    p.valv_type,
    p.pressure,
    p.flow,
    p.coef_loss,
    p.curve_id,
    p.minorloss,
    p.status,
    p.add_settings
   FROM selector_sector, selector_inp_dscenario, v_node
     JOIN inp_dscenario_valve p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;
