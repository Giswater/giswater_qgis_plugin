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



DROP TRIGGER IF EXISTS gw_trg_vi_junctions ON SCHEMA_NAME.vi_junctions;
CREATE TRIGGER gw_trg_vi_junctions INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_junctions FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_junctions');
DROP TRIGGER IF EXISTS gw_trg_vi_options ON SCHEMA_NAME.vi_options;
CREATE TRIGGER gw_trg_vi_options INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_options FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_options');
DROP TRIGGER IF EXISTS gw_trg_vi_reservoirs ON SCHEMA_NAME.vi_reservoirs;
CREATE TRIGGER gw_trg_vi_reservoirs INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_reservoirs FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_reservoirs');
DROP TRIGGER IF EXISTS gw_trg_vi_tanks ON SCHEMA_NAME.vi_tanks;
CREATE TRIGGER gw_trg_vi_tanks INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_tanks FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_tanks');
DROP TRIGGER IF EXISTS gw_trg_vi_pipes ON SCHEMA_NAME.vi_pipes;
CREATE TRIGGER gw_trg_vi_pipes INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_pipes FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_pipes');
DROP TRIGGER IF EXISTS gw_trg_vi_pumps ON SCHEMA_NAME.vi_pumps;
CREATE TRIGGER gw_trg_vi_pumps INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_pumps FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_pumps');
DROP TRIGGER IF EXISTS gw_trg_vi_valves ON SCHEMA_NAME.vi_valves;
CREATE TRIGGER gw_trg_vi_valves INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_valves FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_valves');
DROP TRIGGER IF EXISTS gw_trg_vi_tags ON SCHEMA_NAME.vi_tags;
CREATE TRIGGER gw_trg_vi_tags INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_tags FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_tags');
DROP TRIGGER IF EXISTS gw_trg_vi_demands ON SCHEMA_NAME.vi_demands;
CREATE TRIGGER gw_trg_vi_demands INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_demands FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_demands');
DROP TRIGGER IF EXISTS gw_trg_vi_status ON SCHEMA_NAME.vi_status;
CREATE TRIGGER gw_trg_vi_status INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_status FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_status');
DROP TRIGGER IF EXISTS gw_trg_vi_curves ON SCHEMA_NAME.vi_curves;
CREATE TRIGGER gw_trg_vi_curves INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_curves FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_curves');
DROP TRIGGER IF EXISTS gw_trg_vi_emitters ON SCHEMA_NAME.vi_emitters;
CREATE TRIGGER gw_trg_vi_emitters INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_emitters FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_emitters');
DROP TRIGGER IF EXISTS gw_trg_vi_quality ON SCHEMA_NAME.vi_quality;
CREATE TRIGGER gw_trg_vi_quality INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_quality FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_quality');
DROP TRIGGER IF EXISTS gw_trg_vi_sources ON SCHEMA_NAME.vi_sources;
CREATE TRIGGER gw_trg_vi_sources INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_sources FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_sources');
DROP TRIGGER IF EXISTS gw_trg_vi_mixing ON SCHEMA_NAME.vi_mixing;
CREATE TRIGGER gw_trg_vi_mixing INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_mixing FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_mixing');
DROP TRIGGER IF EXISTS gw_trg_vi_times ON SCHEMA_NAME.vi_times;
CREATE TRIGGER gw_trg_vi_times INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_times FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_times');
DROP TRIGGER IF EXISTS gw_trg_vi_report ON SCHEMA_NAME.vi_report;
CREATE TRIGGER gw_trg_vi_report INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_report FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_report');
DROP TRIGGER IF EXISTS gw_trg_vi_coordinates ON SCHEMA_NAME.vi_coordinates;
CREATE TRIGGER gw_trg_vi_coordinates INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_coordinates FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_coordinates');
DROP TRIGGER IF EXISTS gw_trg_vi_vertices ON SCHEMA_NAME.vi_vertices;
CREATE TRIGGER gw_trg_vi_vertices INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_vertices FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_vertices');
DROP TRIGGER IF EXISTS gw_trg_vi_labels ON SCHEMA_NAME.vi_labels;
CREATE TRIGGER gw_trg_vi_labels INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_labels FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_labels');
DROP TRIGGER IF EXISTS gw_trg_vi_backdrop ON SCHEMA_NAME.vi_backdrop;
CREATE TRIGGER gw_trg_vi_backdrop INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_backdrop FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_backdrop');
DROP TRIGGER IF EXISTS gw_trg_vi_patterns ON SCHEMA_NAME.vi_patterns;
CREATE TRIGGER gw_trg_vi_patterns INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_patterns FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_patterns');
DROP TRIGGER IF EXISTS gw_trg_vi_controls ON SCHEMA_NAME.vi_controls;
CREATE TRIGGER gw_trg_vi_controls INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_controls FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_controls');
DROP TRIGGER IF EXISTS gw_trg_vi_rules ON SCHEMA_NAME.vi_rules;
CREATE TRIGGER gw_trg_vi_rules INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_rules FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_rules');
DROP TRIGGER IF EXISTS gw_trg_vi_energy ON SCHEMA_NAME.vi_energy;
CREATE TRIGGER gw_trg_vi_energy INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_energy FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_energy');
DROP TRIGGER IF EXISTS gw_trg_vi_reactions ON SCHEMA_NAME.vi_reactions;
CREATE TRIGGER gw_trg_vi_reactions INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_reactions FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_reactions');

