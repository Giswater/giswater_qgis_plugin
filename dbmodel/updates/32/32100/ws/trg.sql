/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

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