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

DROP TRIGGER IF EXISTS gw_trg_vi_emitters ON vi_emitters;
CREATE TRIGGER gw_trg_vi_emitters INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_emitters FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_emitters');

DROP TRIGGER IF EXISTS gw_trg_vi_sources ON vi_sources;
CREATE TRIGGER gw_trg_vi_sources INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_sources FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_sources');

DROP TRIGGER IF EXISTS gw_trg_vi_quality ON vi_quality;
CREATE TRIGGER gw_trg_vi_quality INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_quality FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_quality');

DROP TRIGGER IF EXISTS gw_trg_vi_mixing ON vi_mixing;
CREATE TRIGGER gw_trg_vi_mixing INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_mixing FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_mixing');

DROP TRIGGER IF EXISTS gw_trg_vi_pumps ON vi_pumps;
CREATE TRIGGER gw_trg_vi_pumps INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_pumps FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_pumps');

DROP TRIGGER IF EXISTS gw_trg_vi_curves ON vi_curves;
CREATE TRIGGER gw_trg_vi_curves INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_curves FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_curves');

DROP TRIGGER IF EXISTS gw_trg_vi_energy ON vi_energy;
CREATE TRIGGER gw_trg_vi_energy INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_energy FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_energy');

DROP TRIGGER IF EXISTS gw_trg_vi_reactions ON vi_reactions;
CREATE TRIGGER gw_trg_vi_reactions INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_reactions FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_reactions');
