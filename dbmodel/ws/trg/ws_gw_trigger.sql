/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

DROP TRIGGER IF EXISTS gw_trg_arc_noderotation_update ON "SCHEMA_NAME".arc;
CREATE TRIGGER gw_trg_arc_noderotation_update  AFTER INSERT OR UPDATE OF the_geom OR DELETE  ON "SCHEMA_NAME".arc 
FOR EACH ROW  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_arc_noderotation_update();

DROP TRIGGER IF EXISTS gw_trg_edit_arc ON "SCHEMA_NAME".v_edit_arc;
CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_arc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc();

DROP TRIGGER IF EXISTS gw_trg_edit_cat_node ON "SCHEMA_NAME".cat_node;
CREATE TRIGGER gw_trg_edit_cat_node BEFORE INSERT OR UPDATE ON "SCHEMA_NAME".cat_node 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_cat_node();

DROP TRIGGER IF EXISTS gw_trg_edit_connec ON "SCHEMA_NAME".v_edit_connec;
CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_connec 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_connec();

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_pipe ON "SCHEMA_NAME".v_edit_inp_pipe;
CREATE TRIGGER gw_trg_edit_inp_arc_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_pipe 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_pipe');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_demand ON "SCHEMA_NAME".v_edit_inp_demand;
CREATE TRIGGER gw_trg_edit_inp_demand INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_demand 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_demand();

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_shortpipe ON "SCHEMA_NAME".v_edit_inp_shortpipe;
CREATE TRIGGER gw_trg_edit_inp_node_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_shortpipe 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_shortpipe', 'SHORTPIPE');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_valve ON "SCHEMA_NAME".v_edit_inp_valve;
CREATE TRIGGER gw_trg_edit_inp_node_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_valve 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_valve', 'VALVE');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_pump ON "SCHEMA_NAME".v_edit_inp_pump;
CREATE TRIGGER gw_trg_edit_inp_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_pump 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_pump', 'PUMP');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_junction ON "SCHEMA_NAME".v_edit_inp_junction;
CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_junction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_junction', 'JUNCTION');
 
DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_reservoir ON "SCHEMA_NAME".v_edit_inp_reservoir;
CREATE TRIGGER gw_trg_edit_inp_node_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_reservoir 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_reservoir', 'RESERVOIR');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_tank ON "SCHEMA_NAME".v_edit_inp_tank;
CREATE TRIGGER gw_trg_edit_inp_node_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_tank 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_tank', 'TANK');

DROP TRIGGER IF EXISTS gw_trg_edit_man_pipe ON "SCHEMA_NAME".v_edit_man_pipe;
CREATE TRIGGER gw_trg_edit_man_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_pipe 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('man_pipe');

DROP TRIGGER IF EXISTS gw_trg_edit_man_varc ON "SCHEMA_NAME".v_edit_man_varc;
CREATE TRIGGER gw_trg_edit_man_varc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_varc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('man_varc');

DROP TRIGGER IF EXISTS gw_trg_edit_man_greentap ON "SCHEMA_NAME".v_edit_man_greentap;
CREATE TRIGGER gw_trg_edit_man_greentap INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_greentap 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec('man_greentap');

DROP TRIGGER IF EXISTS gw_trg_edit_man_wjoin ON "SCHEMA_NAME".v_edit_man_wjoin;
CREATE TRIGGER gw_trg_edit_man_wjoin INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wjoin 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec('man_wjoin');

DROP TRIGGER IF EXISTS gw_trg_edit_man_tap ON "SCHEMA_NAME".v_edit_man_tap;
CREATE TRIGGER gw_trg_edit_man_tap INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_tap 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec('man_tap');

DROP TRIGGER IF EXISTS gw_trg_edit_man_fountain ON "SCHEMA_NAME".v_edit_man_fountain;
CREATE TRIGGER gw_trg_edit_man_fountain INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_fountain 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec('man_fountain');

DROP TRIGGER IF EXISTS gw_trg_edit_man_fountain_pol ON "SCHEMA_NAME".v_edit_man_fountain_pol;
CREATE TRIGGER gw_trg_edit_man_fountain_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_fountain_pol 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec_pol('man_fountain_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_hydrant ON "SCHEMA_NAME".v_edit_man_hydrant;
CREATE TRIGGER gw_trg_edit_man_hydrant INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_hydrant 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_hydrant');

DROP TRIGGER IF EXISTS gw_trg_edit_man_pump ON "SCHEMA_NAME".v_edit_man_pump;
CREATE TRIGGER gw_trg_edit_man_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_pump 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_pump');

DROP TRIGGER IF EXISTS gw_trg_edit_man_manhole ON "SCHEMA_NAME".v_edit_man_manhole;
CREATE TRIGGER gw_trg_edit_man_manhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_manhole 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_manhole');

DROP TRIGGER IF EXISTS gw_trg_edit_man_source ON "SCHEMA_NAME".v_edit_man_source;
CREATE TRIGGER gw_trg_edit_man_source INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_source 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_source');

DROP TRIGGER IF EXISTS gw_trg_edit_man_meter ON "SCHEMA_NAME".v_edit_man_meter;
CREATE TRIGGER gw_trg_edit_man_meter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_meter 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_meter');

DROP TRIGGER IF EXISTS gw_trg_edit_man_tank ON "SCHEMA_NAME".v_edit_man_tank;
CREATE TRIGGER gw_trg_edit_man_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_tank 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_tank');

DROP TRIGGER IF EXISTS gw_trg_edit_man_junction ON "SCHEMA_NAME".v_edit_man_junction;
CREATE TRIGGER gw_trg_edit_man_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_junction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_junction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_waterwell ON "SCHEMA_NAME".v_edit_man_waterwell;
CREATE TRIGGER gw_trg_edit_man_waterwell INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_waterwell 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_waterwell');

DROP TRIGGER IF EXISTS gw_trg_edit_man_reduction ON "SCHEMA_NAME".v_edit_man_reduction;
CREATE TRIGGER gw_trg_edit_man_reduction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_reduction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_reduction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_valve ON "SCHEMA_NAME".v_edit_man_valve;
CREATE TRIGGER gw_trg_edit_man_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_valve 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_valve');

DROP TRIGGER IF EXISTS gw_trg_edit_man_filter ON "SCHEMA_NAME".v_edit_man_filter;
CREATE TRIGGER gw_trg_edit_man_filter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_filter 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_filter');

DROP TRIGGER IF EXISTS gw_trg_edit_man_register ON "SCHEMA_NAME".v_edit_man_register;
CREATE TRIGGER gw_trg_edit_man_register INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_register 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_register');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netwjoin ON "SCHEMA_NAME".v_edit_man_netwjoin;
CREATE TRIGGER gw_trg_edit_man_netwjoin INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netwjoin 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netwjoin');

DROP TRIGGER IF EXISTS gw_trg_edit_man_expansiontank ON "SCHEMA_NAME".v_edit_man_expansiontank;
CREATE TRIGGER gw_trg_edit_man_expansiontank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_expansiontank 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_expansiontank');

DROP TRIGGER IF EXISTS gw_trg_edit_man_flexunion ON "SCHEMA_NAME".v_edit_man_flexunion;
CREATE TRIGGER gw_trg_edit_man_flexunion INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_flexunion 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_flexunion');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netsamplepoint ON "SCHEMA_NAME".v_edit_man_netsamplepoint;
CREATE TRIGGER gw_trg_edit_man_netsamplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netsamplepoint 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netsamplepoint');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netelement ON "SCHEMA_NAME".v_edit_man_netelement;
CREATE TRIGGER gw_trg_edit_man_netelement INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netelement 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netelement');

DROP TRIGGER IF EXISTS gw_trg_edit_man_wtp ON "SCHEMA_NAME".v_edit_man_wtp;
CREATE TRIGGER gw_trg_edit_man_wtp INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wtp 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wtp');

DROP TRIGGER IF EXISTS gw_trg_edit_man_tank_pol ON "SCHEMA_NAME".v_edit_man_tank_pol;
CREATE TRIGGER gw_trg_edit_man_tank_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_tank_pol 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_tank_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_register_pol ON "SCHEMA_NAME".v_edit_man_register_pol;
CREATE TRIGGER gw_trg_edit_man_register_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_register_pol 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_register_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_node ON "SCHEMA_NAME".v_edit_node;
CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_node 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node();

DROP TRIGGER IF EXISTS gw_trg_edit_review_arc ON "SCHEMA_NAME".v_edit_review_arc;
CREATE TRIGGER gw_trg_edit_review_arc INSTEAD OF INSERT OR UPDATE ON "SCHEMA_NAME".v_edit_review_arc  
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_arc();

DROP TRIGGER IF EXISTS gw_trg_edit_review_connec ON "SCHEMA_NAME".v_edit_review_connec;
CREATE TRIGGER gw_trg_edit_review_connec INSTEAD OF INSERT OR UPDATE ON "SCHEMA_NAME".v_edit_review_connec 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_connec();

DROP TRIGGER IF EXISTS gw_trg_edit_review_node ON "SCHEMA_NAME".v_edit_review_node;
CREATE TRIGGER gw_trg_edit_review_node INSTEAD OF INSERT OR UPDATE ON "SCHEMA_NAME".v_edit_review_node 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_node();

DROP TRIGGER IF EXISTS gw_trg_edit_rtc_hydro_data ON "SCHEMA_NAME".v_edit_rtc_hydro_data_x_connec;
CREATE TRIGGER gw_trg_edit_rtc_hydro_data INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_rtc_hydro_data_x_connec 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_rtc_hydro_data();

DROP TRIGGER IF EXISTS gw_trg_edit_samplepoint ON "SCHEMA_NAME".v_edit_samplepoint;
CREATE TRIGGER gw_trg_edit_samplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_samplepoint 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_samplepoint('samplepoint');

DROP TRIGGER IF EXISTS gw_trg_edit_pond ON "SCHEMA_NAME".v_edit_pond;
CREATE TRIGGER gw_trg_edit_pond INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_pond 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_unconnected('pond');

DROP TRIGGER IF EXISTS gw_trg_edit_pool ON "SCHEMA_NAME".v_edit_pool;
CREATE TRIGGER gw_trg_edit_pool INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_pool 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_unconnected('pool');    

DROP TRIGGER IF EXISTS gw_trg_node_rotation_update ON "SCHEMA_NAME".node;
CREATE TRIGGER gw_trg_node_rotation_update  AFTER INSERT OR UPDATE OF hemisphere, the_geom ON "SCHEMA_NAME".node
FOR EACH ROW  EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_node_rotation_update();

DROP TRIGGER IF EXISTS gw_trg_node_update ON "SCHEMA_NAME"."node";
CREATE TRIGGER gw_trg_node_update AFTER INSERT OR UPDATE OF the_geom, "state", hemisphere ON "SCHEMA_NAME"."node" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_node_update"();

DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_arc ON "SCHEMA_NAME".v_edit_review_audit_arc;
CREATE TRIGGER gw_trg_edit_review_audit_arc INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_audit_arc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_audit_arc();

DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_connec ON "SCHEMA_NAME".v_edit_review_audit_connec;
CREATE TRIGGER gw_trg_edit_review_audit_connec INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_audit_connec 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_audit_connec();

DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_node ON "SCHEMA_NAME".v_edit_review_audit_node;
CREATE TRIGGER gw_trg_edit_review_audit_node INSTEAD OF UPDATE ON "SCHEMA_NAME".v_edit_review_audit_node 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_review_audit_node();

DROP TRIGGER IF EXISTS gw_trg_rtc_hydrometer ON "SCHEMA_NAME".rtc_hydrometer;
CREATE TRIGGER gw_trg_rtc_hydrometer BEFORE INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME".rtc_hydrometer 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_rtc_hydrometer();

DROP TRIGGER IF EXISTS gw_trg_topocontrol_arc ON "SCHEMA_NAME"."arc";
CREATE TRIGGER gw_trg_topocontrol_arc BEFORE INSERT OR UPDATE OF the_geom, "state" ON SCHEMA_NAME.arc
FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_topocontrol_arc();

DROP TRIGGER IF EXISTS gw_trg_ui_mincut_result_cat ON "SCHEMA_NAME".v_ui_anl_mincut_result_cat;
CREATE TRIGGER gw_trg_ui_mincut_result_cat INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_ui_anl_mincut_result_cat
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_mincut_result_cat();




