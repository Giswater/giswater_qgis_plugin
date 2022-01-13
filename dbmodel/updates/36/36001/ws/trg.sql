/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/01/03

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_junction 
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_junction');

CREATE TRIGGER gw_trg_edit_inp_node_inlet INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_inlet
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_inlet');

CREATE TRIGGER gw_trg_edit_inp_arc_pipe INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_pipe
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_pipe');

CREATE TRIGGER gw_trg_edit_inp_node_pump INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_pump
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_pump');

CREATE TRIGGER gw_trg_edit_inp_node_reservoir INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_reservoir
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_reservoir');

CREATE TRIGGER gw_trg_edit_inp_node_shortpipe INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_shortpipe
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_shortpipe');

CREATE TRIGGER gw_trg_edit_inp_node_tank INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_tank
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_tank');

CREATE TRIGGER gw_trg_edit_inp_node_valve INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_valve
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_valve');

CREATE TRIGGER gw_trg_edit_inp_arc_virtualvalve INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_virtualvalve
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_virtualvalve');

