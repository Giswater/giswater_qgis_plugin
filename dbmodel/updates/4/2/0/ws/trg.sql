/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('LINK');

CREATE TRIGGER gw_trg_edit_link_link INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_link_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('LINK');

-- old v_edit parent tables:
CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_arc('parent');

CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_node('parent');

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('parent');
-- ================================
CREATE TRIGGER gw_trg_edit_ve_epa_frpump INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_frpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('frpump');

CREATE TRIGGER gw_trg_edit_ve_epa_frvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_frvalve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('frvalve');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_dscenario_frvalve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-VALVE');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_dscenario_frpump
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-PUMP');

CREATE TRIGGER gw_trg_edit_ve_epa_frvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_frvalve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('frvalve');

CREATE TRIGGER gw_trg_edit_ve_epa_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('valve');

CREATE TRIGGER gw_trg_edit_ve_epa_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_pipe 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('pipe');

CREATE TRIGGER gw_trg_edit_ve_epa_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_shortpipe 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('shortpipe');

CREATE TRIGGER gw_trg_edit_ve_epa_virtualvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_virtualvalve 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('virtualvalve');

CREATE TRIGGER gw_trg_edit_ve_epa_virtualpump INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_virtualpump 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('virtualpump');

CREATE TRIGGER gw_trg_edit_ve_epa_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_pump 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('pump');

CREATE TRIGGER gw_trg_edit_ve_epa_pump_additional INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_pump_additional 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('pump_additional');

CREATE TRIGGER gw_trg_edit_ve_epa_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_junction 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('junction');

CREATE TRIGGER gw_trg_edit_ve_epa_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_tank 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('tank');

CREATE TRIGGER gw_trg_edit_ve_epa_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_reservoir 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('reservoir');

CREATE TRIGGER gw_trg_edit_ve_epa_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_connec 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('connec');

CREATE TRIGGER gw_trg_edit_ve_epa_inlet INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_inlet 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('inlet');
