/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/21
CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_arc
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR UPDATE OR DELETE  ON v_edit_node
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_connec
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_connec('parent');

CREATE TRIGGER gw_trg_edit_man_varc INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_varc FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_arc('man_varc');

CREATE TRIGGER gw_trg_edit_man_pipe INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_pipe  FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_arc('man_pipe');

CREATE TRIGGER gw_trg_edit_man_expansiontank INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_expansiontank FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_expansiontank');

CREATE TRIGGER gw_trg_edit_man_filter INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_filter FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_filter');

CREATE TRIGGER gw_trg_edit_man_flexunion INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_flexunion FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_flexunion');

CREATE TRIGGER gw_trg_edit_man_fountain INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_fountain FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_connec('man_fountain');

CREATE TRIGGER gw_trg_edit_man_greentap INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_greentap FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_connec('man_greentap');

CREATE TRIGGER gw_trg_edit_man_wjoin INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_wjoin FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_connec('man_wjoin');

CREATE TRIGGER gw_trg_edit_man_hydrant INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_hydrant FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_hydrant');

CREATE TRIGGER gw_trg_edit_man_junction INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_junction FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_junction');

CREATE TRIGGER gw_trg_edit_man_manhole INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_manhole  FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_manhole');

CREATE TRIGGER gw_trg_edit_man_meter INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_meter FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_meter');

CREATE TRIGGER gw_trg_edit_man_netelement INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_netelement FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_netelement');

CREATE TRIGGER gw_trg_edit_man_netsamplepoint INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_netsamplepoint FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_netsamplepoint');
  
CREATE TRIGGER gw_trg_edit_man_pump INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_pump FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_pump');

CREATE TRIGGER gw_trg_edit_man_reduction INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_reduction FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_reduction');

CREATE TRIGGER gw_trg_edit_man_register INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_register FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_register');

CREATE TRIGGER gw_trg_edit_man_source INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_source FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_source');

CREATE TRIGGER gw_trg_edit_man_tank INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_tank FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_tank');

CREATE TRIGGER gw_trg_edit_man_tap INSTEAD OF INSERT OR UPDATE OR DELETE 
ON v_edit_man_tap FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_connec('man_tap');

CREATE TRIGGER gw_trg_edit_man_valve INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_valve FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_valve');

CREATE TRIGGER gw_trg_edit_man_waterwell INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_waterwell FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_waterwell');

CREATE TRIGGER gw_trg_edit_man_wtp INSTEAD OF INSERT OR UPDATE OR DELETE 
ON v_edit_man_wtp FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('man_wtp');

CREATE TRIGGER gw_trg_edit_man_register_pol INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_register_pol FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_register_pol');

CREATE TRIGGER gw_trg_edit_man_tank_pol INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_man_tank_pol FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_tank_pol');

CREATE TRIGGER gw_trg_edit_field_valve INSTEAD OF UPDATE
ON v_edit_field_valve FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_field_node('field_valve');
  
CREATE TRIGGER gw_trg_edit_inp_demand INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_demand FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_demand();

CREATE TRIGGER gw_trg_edit_man_tank_pol INSTEAD OF INSERT OR UPDATE OR DELETE
ON ve_pol_tank FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_tank_pol');

CREATE TRIGGER gw_trg_edit_man_register_pol INSTEAD OF INSERT OR UPDATE OR DELETE
ON ve_pol_register FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_register_pol');
 
CREATE TRIGGER gw_trg_edit_man_fountain_pol INSTEAD OF INSERT OR UPDATE OR DELETE
ON ve_pol_fountain FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_connec_pol('man_fountain_pol');