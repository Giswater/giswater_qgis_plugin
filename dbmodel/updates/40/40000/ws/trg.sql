/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

CREATE TRIGGER gw_trg_edit_element_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_element_pol();

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_node');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_connec');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_element_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_arc');

CREATE TRIGGER gw_trg_edit_pol_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_connec_pol();

CREATE TRIGGER gw_trg_edit_pol_node INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol();

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_junction');

CREATE TRIGGER gw_trg_edit_inp_dscenario_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_junction
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('JUNCTION');

CREATE TRIGGER gw_trg_edit_inp_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_pump');

CREATE TRIGGER gw_trg_edit_inp_arc_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_pipe');

CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_virtualpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtualpump');

CREATE TRIGGER gw_trg_edit_inp_arc_virtualvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_virtualvalve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_arc('inp_virtualvalve');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_pipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PIPE');

CREATE TRIGGER gw_trg_edit_inp_dscenario_virtualvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_virtualvalve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('VIRTUALVALVE');

CREATE TRIGGER gw_trg_edit_inp_dscenario_virtualpump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_virtualpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('VIRTUALPUMP');

CREATE TRIGGER gw_trg_edit_man_register_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_register
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol('man_register_pol');

CREATE TRIGGER gw_trg_edit_man_fountain_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_fountain
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_connec_pol('man_fountain_pol');

CREATE TRIGGER gw_trg_edit_man_tank_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_pol_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol('man_tank_pol');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_pump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PUMP');

CREATE TRIGGER gw_trg_edit_inp_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_pump_additional
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_pump_additional');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pump_additional INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_pump_additional
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PUMP_ADDITIONAL');

CREATE TRIGGER gw_trg_edit_inp_dscenario_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_shortpipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('SHORTPIPE');

CREATE TRIGGER gw_trg_edit_inp_node_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_shortpipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_shortpipe');

CREATE TRIGGER gw_trg_edit_ve_epa_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_pipe
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('pipe');

CREATE TRIGGER gw_trg_edit_inp_dscenario_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('CONNEC');

CREATE TRIGGER gw_trg_edit_inp_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_connec();

CREATE TRIGGER gw_trg_edit_inp_dscenario_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('TANK');

CREATE TRIGGER gw_trg_edit_inp_node_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_tank
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_tank');

CREATE TRIGGER gw_trg_edit_inp_dscenario_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_reservoir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('RESERVOIR');

CREATE TRIGGER gw_trg_edit_inp_node_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_reservoir
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_reservoir');

CREATE TRIGGER gw_trg_edit_inp_dscenario_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('VALVE');

CREATE TRIGGER gw_trg_edit_inp_node_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_valve');

CREATE TRIGGER gw_trg_edit_inp_dscenario_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_dscenario_inlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('INLET');

CREATE TRIGGER gw_trg_edit_inp_node_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_inp_inlet
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_node('inp_inlet');

CREATE TRIGGER gw_trg_edit_ve_epa_virtualvalve INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_virtualvalve
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('virtualvalve');

CREATE TRIGGER gw_trg_edit_ve_epa_shorpipe INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_shortpipe
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('shortpipe');

CREATE TRIGGER gw_trg_edit_ve_epa_valve INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_valve
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('valve');

CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_link
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_link();

CREATE TRIGGER gw_trg_edit_dma INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_dma
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('dma');

CREATE TRIGGER gw_trg_edit_presszone INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_presszone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_presszone();

CREATE TRIGGER gw_trg_edit_dqa INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_dqa
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dqa();

CREATE TRIGGER gw_trg_edit_plan_netscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_plan_netscenario_presszone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_netscenario('PRESSZONE');

CREATE TRIGGER gw_trg_edit_minsector INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_minsector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_minsector();

CREATE TRIGGER gw_trg_edit_samplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_samplepoint FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_samplepoint('samplepoint');


CREATE TRIGGER gw_trg_edit_pond INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_pond FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_unconnected('pond');

CREATE TRIGGER gw_trg_edit_pool INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_pool FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_unconnected('pool');

CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE ON
dqa FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('dqa');

CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE ON
sector FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('sector');
