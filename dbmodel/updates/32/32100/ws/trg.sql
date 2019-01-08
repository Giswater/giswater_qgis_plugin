/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_edit_inp_demand ON "SCHEMA_NAME".ve_inp_demand;
CREATE TRIGGER gw_trg_edit_inp_demand INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_demand
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_demand();
 
DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_pipe ON "SCHEMA_NAME".ve_inp_pipe;
CREATE TRIGGER gw_trg_edit_inp_arc_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_pipe 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_pipe');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_shortpipe ON "SCHEMA_NAME".ve_inp_shortpipe;
CREATE TRIGGER gw_trg_edit_inp_node_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_shortpipe 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_shortpipe', 'SHORTPIPE');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_valve ON "SCHEMA_NAME".ve_inp_valve;
CREATE TRIGGER gw_trg_edit_inp_node_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_valve 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_valve', 'VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_pump ON "SCHEMA_NAME".ve_inp_pump;
CREATE TRIGGER gw_trg_edit_inp_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_pump 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_pump', 'PUMP');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_junction ON "SCHEMA_NAME".ve_inp_junction;
CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_junction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_junction', 'JUNCTION');
 
DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_reservoir ON "SCHEMA_NAME".ve_inp_reservoir;
CREATE TRIGGER gw_trg_edit_inp_node_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_reservoir 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_reservoir', 'RESERVOIR');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_tank ON "SCHEMA_NAME".ve_inp_tank;
CREATE TRIGGER gw_trg_edit_inp_node_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_inp_tank 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_tank', 'TANK');
  
DROP TRIGGER IF EXISTS gw_trg_ui_mincut_result_cat ON "SCHEMA_NAME".ve_ui_mincut_result_cat;
CREATE TRIGGER gw_trg_ui_mincut_result_cat INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_mincut_result_cat
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_mincut_result_cat();

DROP TRIGGER IF EXISTS gw_trg_edit_arc ON "SCHEMA_NAME".ve_arc;
CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc();

DROP TRIGGER IF EXISTS gw_trg_edit_connec ON "SCHEMA_NAME".ve_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec();

DROP TRIGGER IF EXISTS gw_trg_edit_arc_pipe ON "SCHEMA_NAME".ve_arc_pipe;
CREATE TRIGGER gw_trg_edit_arc_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_pipe FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('PIPE');

DROP TRIGGER IF EXISTS gw_trg_edit_arc_varc ON "SCHEMA_NAME".ve_arc_varc;
CREATE TRIGGER gw_trg_edit_arc_varc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_varc FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('VARC');
	     
DROP TRIGGER IF EXISTS gw_trg_edit_connec_greentap ON "SCHEMA_NAME".ve_connec_greentap;
CREATE TRIGGER gw_trg_edit_connec_greentap INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_connec_greentap FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec('GREENTAP');

DROP TRIGGER IF EXISTS gw_trg_edit_connec_wjoin ON "SCHEMA_NAME".ve_connec_wjoin;
CREATE TRIGGER gw_trg_edit_connec_wjoin INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_connec_wjoin FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec('WJOIN');

DROP TRIGGER IF EXISTS gw_trg_edit_connec_tap ON "SCHEMA_NAME".ve_connec_tap;
CREATE TRIGGER gw_trg_edit_connec_tap INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_connec_tap FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec('TAP');

DROP TRIGGER IF EXISTS gw_trg_edit_connec_fountain ON "SCHEMA_NAME".ve_connec_fountain;
CREATE TRIGGER gw_trg_edit_connec_fountain INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_connec_fountain FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec('FOUNTAIN');

DROP TRIGGER IF EXISTS gw_trg_edit_man_fountain_pol ON "SCHEMA_NAME".ve_pol_fountain;
CREATE TRIGGER gw_trg_edit_man_fountain_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_fountain FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec_pol('man_fountain_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_node_shutoffvalve ON "SCHEMA_NAME".ve_node_shutoffvalve;
CREATE TRIGGER gw_trg_edit_node_shutoffvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_shutoffvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('SHUTOFF-VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_checkoffvalve ON "SCHEMA_NAME".ve_node_checkoffvalve;
CREATE TRIGGER gw_trg_edit_node_checkoffvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_checkoffvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('CHECK-VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_prbkvalve ON "SCHEMA_NAME".ve_node_prbkvalve;
CREATE TRIGGER gw_trg_edit_node_prbkvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_prbkvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('PR-BREAK.VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_flcontrvalve ON "SCHEMA_NAME".ve_node_flcontrvalve;
CREATE TRIGGER gw_trg_edit_node_flcontrvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_flcontrvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('FL-CONTR.VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_genpurpvalve ON "SCHEMA_NAME".ve_node_genpurpvalve;
CREATE TRIGGER gw_trg_edit_node_genpurpvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_genpurpvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('GEN-PURP.VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_throttlevalve ON "SCHEMA_NAME".ve_node_throttlevalve;
CREATE TRIGGER gw_trg_edit_node_throttlevalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_throttlevalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('THROTTLE-VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_prreducvalve ON "SCHEMA_NAME".ve_node_prreducvalve;
CREATE TRIGGER gw_trg_edit_node_prreducvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_prreducvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('PR-REDUC.VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_prsustavalve ON "SCHEMA_NAME".ve_node_prsustavalve;
CREATE TRIGGER gw_trg_edit_node_prsustavalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_prsustavalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('PR-SUSTA.VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_airvalve ON "SCHEMA_NAME".ve_node_airvalve;
CREATE TRIGGER gw_trg_edit_node_airvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_airvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('AIR-VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_greenvalve ON "SCHEMA_NAME".ve_node_greenvalve;
CREATE TRIGGER gw_trg_edit_node_greenvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_greenvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('GREEN-VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_outfallvalve ON "SCHEMA_NAME".ve_node_outfallvalve;
CREATE TRIGGER gw_trg_edit_node_outfallvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_outfallvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('OUTFALL-VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_register ON "SCHEMA_NAME".ve_node_register;
CREATE TRIGGER gw_trg_edit_node_register INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_register FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('REGISTER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_bypassregister ON "SCHEMA_NAME".ve_node_bypassregister;
CREATE TRIGGER gw_trg_edit_node_bypassregister INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_bypassregister FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('BYPASS-REGISTER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_valveregister ON "SCHEMA_NAME".ve_node_valveregister;
CREATE TRIGGER gw_trg_edit_node_valveregister INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_valveregister FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('VALVE-REGISTER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_controlregister ON "SCHEMA_NAME".ve_node_controlregister;
CREATE TRIGGER gw_trg_edit_node_controlregister INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_controlregister FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('CONTROL-REGISTER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_expansiontank ON "SCHEMA_NAME".ve_node_expansiontank;
CREATE TRIGGER gw_trg_edit_node_expansiontank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_expansiontank FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('EXPANTANK');

DROP TRIGGER IF EXISTS gw_trg_edit_node_filter ON "SCHEMA_NAME".ve_node_filter;
CREATE TRIGGER gw_trg_edit_node_filter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_filter FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('FILTER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_flexunion ON "SCHEMA_NAME".ve_node_flexunion;
CREATE TRIGGER gw_trg_edit_node_flexunion INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_flexunion FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('FLEXUNION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_hydrant ON "SCHEMA_NAME".ve_node_hydrant;
CREATE TRIGGER gw_trg_edit_node_hydrant INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_hydrant FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('HYDRANT');

DROP TRIGGER IF EXISTS gw_trg_edit_node_x ON "SCHEMA_NAME".ve_node_x;
CREATE TRIGGER gw_trg_edit_node_x INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_x FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('X');

DROP TRIGGER IF EXISTS gw_trg_edit_node_adaptation ON "SCHEMA_NAME".ve_node_adaptation;
CREATE TRIGGER gw_trg_edit_node_adaptation INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_adaptation FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('ADAPTATION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_endline ON "SCHEMA_NAME".ve_node_endline;
CREATE TRIGGER gw_trg_edit_node_endline INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_endline FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('ENDLINE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_t ON "SCHEMA_NAME".ve_node_t;
CREATE TRIGGER gw_trg_edit_node_t INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_t FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('T');

DROP TRIGGER IF EXISTS gw_trg_edit_node_curve ON "SCHEMA_NAME".ve_node_curve;
CREATE TRIGGER gw_trg_edit_node_curve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_curve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('CURVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_junction ON "SCHEMA_NAME".ve_node_junction;
CREATE TRIGGER gw_trg_edit_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_junction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('JUNCTION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_manhole ON "SCHEMA_NAME".ve_node_manhole;
CREATE TRIGGER gw_trg_edit_node_manhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_manhole FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('MANHOLE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_flowmeter ON "SCHEMA_NAME".ve_node_flowmeter;
CREATE TRIGGER gw_trg_edit_node_flowmeter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_flowmeter FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('FLOWMETER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_pressuremeter ON "SCHEMA_NAME".ve_node_pressuremeter;
CREATE TRIGGER gw_trg_edit_node_pressuremeter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_pressuremeter FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('PRESSURE-METER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_netelement ON "SCHEMA_NAME".ve_node_netelement;
CREATE TRIGGER gw_trg_edit_node_netelement INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_netelement FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('NETELEMENT');

DROP TRIGGER IF EXISTS gw_trg_edit_node_waterconnection ON "SCHEMA_NAME".ve_node_waterconnection;
CREATE TRIGGER gw_trg_edit_node_waterconnection INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_waterconnection FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('WATER-CONNECTION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_pump ON "SCHEMA_NAME".ve_node_pump;
CREATE TRIGGER gw_trg_edit_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_pump FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('PUMP');

DROP TRIGGER IF EXISTS gw_trg_edit_node_reduction ON "SCHEMA_NAME".ve_node_reduction;
CREATE TRIGGER gw_trg_edit_node_reduction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_reduction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('REDUCTION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_source ON "SCHEMA_NAME".ve_node_source;
CREATE TRIGGER gw_trg_edit_node_source INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_source FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('SOURCE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_tank ON "SCHEMA_NAME".ve_node_tank;
CREATE TRIGGER gw_trg_edit_node_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_tank FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('TANK');

DROP TRIGGER IF EXISTS gw_trg_edit_node_waterwell ON "SCHEMA_NAME".ve_node_waterwell;
CREATE TRIGGER gw_trg_edit_node_waterwell INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_waterwell FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('WATERWELL');

DROP TRIGGER IF EXISTS gw_trg_edit_node_wtp ON "SCHEMA_NAME".ve_node_wtp;
CREATE TRIGGER gw_trg_edit_node_wtp INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_wtp FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('WTP');

DROP TRIGGER IF EXISTS gw_trg_edit_man_tank_pol ON "SCHEMA_NAME".ve_pol_tank;
CREATE TRIGGER gw_trg_edit_man_tank_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_tank FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_tank_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_register_pol ON "SCHEMA_NAME".ve_pol_register;
CREATE TRIGGER gw_trg_edit_man_register_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_register FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_register_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_node ON "SCHEMA_NAME".ve_node;
CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node();

  
DROP TRIGGER IF EXISTS gw_trg_om_visit_singlevent ON "SCHEMA_NAME".ve_visit_singlevent_x_arc;
CREATE TRIGGER gw_trg_om_visit_singlevent INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_visit_singlevent_x_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_om_visit_singlevent(singlevent_x_arc);

DROP TRIGGER IF EXISTS gw_trg_om_visit_singlevent ON "SCHEMA_NAME".ve_visit_singlevent_x_node;
CREATE TRIGGER gw_trg_om_visit_singlevent INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_visit_singlevent_x_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_om_visit_singlevent(singlevent_x_node);

DROP TRIGGER IF EXISTS gw_trg_om_visit_singlevent ON "SCHEMA_NAME".ve_visit_singlevent_x_connec;
CREATE TRIGGER gw_trg_om_visit_singlevent INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_visit_singlevent_x_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_om_visit_singlevent(singlevent_x_connec);

DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON "SCHEMA_NAME".ve_om_visit_multievent_x_arc;
CREATE TRIGGER gw_trg_om_visit_multievent INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_om_visit_multievent_x_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_om_visit_multievent(arc);

DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON "SCHEMA_NAME".ve_om_visit_multievent_x_node;
CREATE TRIGGER gw_trg_om_visit_multievent INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_om_visit_multievent_x_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_om_visit_multievent(node);

DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON "SCHEMA_NAME".ve_om_visit_multievent_x_connec;
CREATE TRIGGER gw_trg_om_visit_multievent INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_om_visit_multievent_x_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_om_visit_multievent(connec);