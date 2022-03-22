/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/07
DROP VIEW v_edit_inp_dscenario_tank;
ALTER TABLE inp_dscenario_tank DROP COLUMN overflow;
ALTER TABLE inp_dscenario_tank ADD COLUMN overflow varchar(3);
CREATE OR REPLACE VIEW v_edit_inp_dscenario_tank AS 
 SELECT d.dscenario_id,
    p.node_id,
    p.initlevel,
    p.minlevel,
    p.maxlevel,
    p.diameter,
    p.minvol,
    p.curve_id,
    p.overflow,
    v.the_geom
   FROM selector_inp_dscenario,
    node v
     JOIN inp_dscenario_tank p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
  AND epa_type = 'TANK';


DROP VIEW v_edit_inp_dscenario_inlet;
ALTER TABLE inp_dscenario_inlet DROP COLUMN overflow;
ALTER TABLE inp_dscenario_inlet ADD COLUMN overflow varchar(3);
CREATE OR REPLACE VIEW v_edit_inp_dscenario_inlet AS 
 SELECT d.dscenario_id,
    n.node_id,
    i.initlevel,
    i.minlevel,
    i.maxlevel,
    i.diameter,
    i.minvol,
    i.curve_id,
    i.pattern_id,
    i.overflow,
    i.head,
    n.the_geom
   FROM selector_inp_dscenario,
    node n
     JOIN inp_dscenario_inlet i USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE i.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
  AND epa_type = 'INLET';
