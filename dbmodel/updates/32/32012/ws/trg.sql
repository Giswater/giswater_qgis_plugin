/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- parent
---------

DROP TRIGGER IF EXISTS gw_trg_edit_arc ON "SCHEMA_NAME".v_edit_arc;
CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_arc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('parent');

DROP TRIGGER IF EXISTS gw_trg_edit_connec ON "SCHEMA_NAME".v_edit_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_connec 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec('parent');

DROP TRIGGER IF EXISTS gw_trg_edit_node ON "SCHEMA_NAME".v_edit_node;
CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_node 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('parent');



-- child
--------

DROP TRIGGER IF EXISTS gw_trg_edit_man_pipe ON "SCHEMA_NAME".v_edit_man_pipe;
CREATE TRIGGER gw_trg_edit_man_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_pipe 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('man_pipe');

DROP TRIGGER IF EXISTS gw_trg_edit_man_varc ON "SCHEMA_NAME".v_edit_man_varc;
CREATE TRIGGER gw_trg_edit_man_varc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_varc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('man_varc');

DROP TRIGGER IF EXISTS gw_trg_edit_man_greentap ON "SCHEMA_NAME".v_edit_man_greentap;
CREATE TRIGGER gw_trg_edit_man_greentap INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_greentap 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec('man_greentap');

DROP TRIGGER IF EXISTS gw_trg_edit_man_wjoin ON "SCHEMA_NAME".v_edit_man_wjoin;
CREATE TRIGGER gw_trg_edit_man_wjoin INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wjoin 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec('man_wjoin');

DROP TRIGGER IF EXISTS gw_trg_edit_man_tap ON "SCHEMA_NAME".v_edit_man_tap;
CREATE TRIGGER gw_trg_edit_man_tap INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_tap 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec('man_tap');

DROP TRIGGER IF EXISTS gw_trg_edit_man_fountain ON "SCHEMA_NAME".v_edit_man_fountain;
CREATE TRIGGER gw_trg_edit_man_fountain INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_fountain 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec('man_fountain');

DROP TRIGGER IF EXISTS gw_trg_edit_man_hydrant ON "SCHEMA_NAME".v_edit_man_hydrant;
CREATE TRIGGER gw_trg_edit_man_hydrant INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_hydrant 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_hydrant');

DROP TRIGGER IF EXISTS gw_trg_edit_man_pump ON "SCHEMA_NAME".v_edit_man_pump;
CREATE TRIGGER gw_trg_edit_man_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_pump 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_pump');

DROP TRIGGER IF EXISTS gw_trg_edit_man_manhole ON "SCHEMA_NAME".v_edit_man_manhole;
CREATE TRIGGER gw_trg_edit_man_manhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_manhole 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_manhole');

DROP TRIGGER IF EXISTS gw_trg_edit_man_source ON "SCHEMA_NAME".v_edit_man_source;
CREATE TRIGGER gw_trg_edit_man_source INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_source 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_source');

DROP TRIGGER IF EXISTS gw_trg_edit_man_meter ON "SCHEMA_NAME".v_edit_man_meter;
CREATE TRIGGER gw_trg_edit_man_meter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_meter 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_meter');

DROP TRIGGER IF EXISTS gw_trg_edit_man_tank ON "SCHEMA_NAME".v_edit_man_tank;
CREATE TRIGGER gw_trg_edit_man_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_tank 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_tank');

DROP TRIGGER IF EXISTS gw_trg_edit_man_junction ON "SCHEMA_NAME".v_edit_man_junction;
CREATE TRIGGER gw_trg_edit_man_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_junction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_junction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_waterwell ON "SCHEMA_NAME".v_edit_man_waterwell;
CREATE TRIGGER gw_trg_edit_man_waterwell INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_waterwell 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_waterwell');

DROP TRIGGER IF EXISTS gw_trg_edit_man_reduction ON "SCHEMA_NAME".v_edit_man_reduction;
CREATE TRIGGER gw_trg_edit_man_reduction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_reduction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_reduction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_valve ON "SCHEMA_NAME".v_edit_man_valve;
CREATE TRIGGER gw_trg_edit_man_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_valve 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_valve');

DROP TRIGGER IF EXISTS gw_trg_edit_man_filter ON "SCHEMA_NAME".v_edit_man_filter;
CREATE TRIGGER gw_trg_edit_man_filter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_filter 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_filter');

DROP TRIGGER IF EXISTS gw_trg_edit_man_register ON "SCHEMA_NAME".v_edit_man_register;
CREATE TRIGGER gw_trg_edit_man_register INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_register 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_register');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netwjoin ON "SCHEMA_NAME".v_edit_man_netwjoin;
CREATE TRIGGER gw_trg_edit_man_netwjoin INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netwjoin 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_netwjoin');

DROP TRIGGER IF EXISTS gw_trg_edit_man_expansiontank ON "SCHEMA_NAME".v_edit_man_expansiontank;
CREATE TRIGGER gw_trg_edit_man_expansiontank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_expansiontank 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_expansiontank');

DROP TRIGGER IF EXISTS gw_trg_edit_man_flexunion ON "SCHEMA_NAME".v_edit_man_flexunion;
CREATE TRIGGER gw_trg_edit_man_flexunion INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_flexunion 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_flexunion');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netsamplepoint ON "SCHEMA_NAME".v_edit_man_netsamplepoint;
CREATE TRIGGER gw_trg_edit_man_netsamplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netsamplepoint 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_netsamplepoint');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netelement ON "SCHEMA_NAME".v_edit_man_netelement;
CREATE TRIGGER gw_trg_edit_man_netelement INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netelement 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_netelement');

DROP TRIGGER IF EXISTS gw_trg_edit_man_wtp ON "SCHEMA_NAME".v_edit_man_wtp;
CREATE TRIGGER gw_trg_edit_man_wtp INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wtp 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('man_wtp');




-- custom
---------

DROP TRIGGER IF EXISTS gw_trg_edit_arc_pipe ON "SCHEMA_NAME".ve_arc_pipe;
CREATE TRIGGER gw_trg_edit_arc_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_pipe FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('PIPE');

DROP TRIGGER IF EXISTS gw_trg_edit_arc_varc ON "SCHEMA_NAME".ve_arc_varc;
CREATE TRIGGER gw_trg_edit_arc_varc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_varc FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc('VARC');
	     
DROP TRIGGER IF EXISTS gw_trg_edit_connec_greentap ON "SCHEMA_NAME".ve_connec_greentap;
CREATE TRIGGER gw_trg_edit_connec_greentap INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_connec_greentap FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec('GREENTAP');

DROP TRIGGER IF EXISTS gw_trg_edit_connec_wjoin ON "SCHEMA_NAME".ve_connec_wjoin;
CREATE TRIGGER gw_trg_edit_connec_wjoin INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_connec_wjoin FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec('WJOIN');

DROP TRIGGER IF EXISTS gw_trg_edit_connec_tap ON "SCHEMA_NAME".ve_connec_tap;
CREATE TRIGGER gw_trg_edit_connec_tap INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_connec_tap FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec('TAP');

DROP TRIGGER IF EXISTS gw_trg_edit_connec_fountain ON "SCHEMA_NAME".ve_connec_fountain;
CREATE TRIGGER gw_trg_edit_connec_fountain INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_connec_fountain FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec('FOUNTAIN');

DROP TRIGGER IF EXISTS gw_trg_edit_man_fountain_pol ON "SCHEMA_NAME".ve_pol_fountain;
CREATE TRIGGER gw_trg_edit_man_fountain_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_fountain FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec_pol('man_fountain_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_node_shutoffvalve ON "SCHEMA_NAME".ve_node_shutoffvalve;
CREATE TRIGGER gw_trg_edit_node_shutoffvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_shutoffvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('SHUTOFF-VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_checkoffvalve ON "SCHEMA_NAME".ve_node_checkoffvalve;
CREATE TRIGGER gw_trg_edit_node_checkoffvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_checkoffvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('CHECK-VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_prbkvalve ON "SCHEMA_NAME".ve_node_prbkvalve;
CREATE TRIGGER gw_trg_edit_node_prbkvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_prbkvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('PR-BREAK.VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_flcontrvalve ON "SCHEMA_NAME".ve_node_flcontrvalve;
CREATE TRIGGER gw_trg_edit_node_flcontrvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_flcontrvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('FL-CONTR.VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_genpurpvalve ON "SCHEMA_NAME".ve_node_genpurpvalve;
CREATE TRIGGER gw_trg_edit_node_genpurpvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_genpurpvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('GEN-PURP.VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_throttlevalve ON "SCHEMA_NAME".ve_node_throttlevalve;
CREATE TRIGGER gw_trg_edit_node_throttlevalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_throttlevalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('THROTTLE-VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_prreducvalve ON "SCHEMA_NAME".ve_node_prreducvalve;
CREATE TRIGGER gw_trg_edit_node_prreducvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_prreducvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('PR-REDUC.VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_prsustavalve ON "SCHEMA_NAME".ve_node_prsustavalve;
CREATE TRIGGER gw_trg_edit_node_prsustavalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_prsustavalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('PR-SUSTA.VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_airvalve ON "SCHEMA_NAME".ve_node_airvalve;
CREATE TRIGGER gw_trg_edit_node_airvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_airvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('AIR-VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_greenvalve ON "SCHEMA_NAME".ve_node_greenvalve;
CREATE TRIGGER gw_trg_edit_node_greenvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_greenvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('GREEN-VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_outfallvalve ON "SCHEMA_NAME".ve_node_outfallvalve;
CREATE TRIGGER gw_trg_edit_node_outfallvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_outfallvalve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('OUTFALL-VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_register ON "SCHEMA_NAME".ve_node_register;
CREATE TRIGGER gw_trg_edit_node_register INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_register FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('REGISTER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_bypassregister ON "SCHEMA_NAME".ve_node_bypassregister;
CREATE TRIGGER gw_trg_edit_node_bypassregister INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_bypassregister FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('BYPASS-REGISTER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_valveregister ON "SCHEMA_NAME".ve_node_valveregister;
CREATE TRIGGER gw_trg_edit_node_valveregister INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_valveregister FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('VALVE-REGISTER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_controlregister ON "SCHEMA_NAME".ve_node_controlregister;
CREATE TRIGGER gw_trg_edit_node_controlregister INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_controlregister FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('CONTROL-REGISTER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_expansiontank ON "SCHEMA_NAME".ve_node_expansiontank;
CREATE TRIGGER gw_trg_edit_node_expansiontank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_expansiontank FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('EXPANTANK');

DROP TRIGGER IF EXISTS gw_trg_edit_node_filter ON "SCHEMA_NAME".ve_node_filter;
CREATE TRIGGER gw_trg_edit_node_filter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_filter FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('FILTER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_flexunion ON "SCHEMA_NAME".ve_node_flexunion;
CREATE TRIGGER gw_trg_edit_node_flexunion INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_flexunion FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('FLEXUNION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_hydrant ON "SCHEMA_NAME".ve_node_hydrant;
CREATE TRIGGER gw_trg_edit_node_hydrant INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_hydrant FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('HYDRANT');

DROP TRIGGER IF EXISTS gw_trg_edit_node_x ON "SCHEMA_NAME".ve_node_x;
CREATE TRIGGER gw_trg_edit_node_x INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_x FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('X');

DROP TRIGGER IF EXISTS gw_trg_edit_node_adaptation ON "SCHEMA_NAME".ve_node_adaptation;
CREATE TRIGGER gw_trg_edit_node_adaptation INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_adaptation FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('ADAPTATION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_endline ON "SCHEMA_NAME".ve_node_endline;
CREATE TRIGGER gw_trg_edit_node_endline INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_endline FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('ENDLINE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_t ON "SCHEMA_NAME".ve_node_t;
CREATE TRIGGER gw_trg_edit_node_t INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_t FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('T');

DROP TRIGGER IF EXISTS gw_trg_edit_node_curve ON "SCHEMA_NAME".ve_node_curve;
CREATE TRIGGER gw_trg_edit_node_curve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_curve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('CURVE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_junction ON "SCHEMA_NAME".ve_node_junction;
CREATE TRIGGER gw_trg_edit_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_junction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('JUNCTION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_manhole ON "SCHEMA_NAME".ve_node_manhole;
CREATE TRIGGER gw_trg_edit_node_manhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_manhole FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('MANHOLE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_flowmeter ON "SCHEMA_NAME".ve_node_flowmeter;
CREATE TRIGGER gw_trg_edit_node_flowmeter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_flowmeter FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('FLOWMETER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_pressuremeter ON "SCHEMA_NAME".ve_node_pressuremeter;
CREATE TRIGGER gw_trg_edit_node_pressuremeter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_pressuremeter FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('PRESSURE-METER');

DROP TRIGGER IF EXISTS gw_trg_edit_node_netelement ON "SCHEMA_NAME".ve_node_netelement;
CREATE TRIGGER gw_trg_edit_node_netelement INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_netelement FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('NETELEMENT');

DROP TRIGGER IF EXISTS gw_trg_edit_node_waterconnection ON "SCHEMA_NAME".ve_node_waterconnection;
CREATE TRIGGER gw_trg_edit_node_waterconnection INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_waterconnection FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('WATER-CONNECTION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_pump ON "SCHEMA_NAME".ve_node_pump;
CREATE TRIGGER gw_trg_edit_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_pump FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('PUMP');

DROP TRIGGER IF EXISTS gw_trg_edit_node_reduction ON "SCHEMA_NAME".ve_node_reduction;
CREATE TRIGGER gw_trg_edit_node_reduction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_reduction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('REDUCTION');

DROP TRIGGER IF EXISTS gw_trg_edit_node_source ON "SCHEMA_NAME".ve_node_source;
CREATE TRIGGER gw_trg_edit_node_source INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_source FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('SOURCE');

DROP TRIGGER IF EXISTS gw_trg_edit_node_tank ON "SCHEMA_NAME".ve_node_tank;
CREATE TRIGGER gw_trg_edit_node_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_tank FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('TANK');

DROP TRIGGER IF EXISTS gw_trg_edit_node_waterwell ON "SCHEMA_NAME".ve_node_waterwell;
CREATE TRIGGER gw_trg_edit_node_waterwell INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_waterwell FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('WATERWELL');

DROP TRIGGER IF EXISTS gw_trg_edit_node_wtp ON "SCHEMA_NAME".ve_node_wtp;
CREATE TRIGGER gw_trg_edit_node_wtp INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_node_wtp FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node('WTP');

DROP TRIGGER IF EXISTS gw_trg_edit_man_tank_pol ON "SCHEMA_NAME".ve_pol_tank;
CREATE TRIGGER gw_trg_edit_man_tank_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_tank FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_tank_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_register_pol ON "SCHEMA_NAME".ve_pol_register;
CREATE TRIGGER gw_trg_edit_man_register_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_pol_register FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_register_pol');
