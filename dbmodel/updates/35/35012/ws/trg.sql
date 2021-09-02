/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



--2021/08/24

CREATE TRIGGER gw_trg_typevalue_fk
  AFTER INSERT OR UPDATE
  ON inp_dscenario_pipe
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_typevalue_fk('inp_dscenario_pipe');


CREATE TRIGGER gw_trg_typevalue_fk
  AFTER INSERT OR UPDATE
  ON inp_dscenario_shortpipe
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_typevalue_fk('inp_dscenario_shortpipe');


CREATE TRIGGER gw_trg_typevalue_fk
  AFTER INSERT OR UPDATE
  ON inp_dscenario_pump
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_typevalue_fk('inp_dscenario_pump');


CREATE TRIGGER gw_trg_typevalue_fk
  AFTER INSERT OR UPDATE
  ON inp_dscenario_valve
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_typevalue_fk('inp_dscenario_valve');


  --2021/09/01
  CREATE TRIGGER gw_trg_edit_inp_dscenario 
  INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_pipe 
  FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('PIPE');

  CREATE TRIGGER gw_trg_edit_inp_dscenario 
  INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_pump 
  FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('PUMP');

  CREATE TRIGGER gw_trg_edit_inp_dscenario 
  INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_reservoir 
  FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('RESERVOIR');

  CREATE TRIGGER gw_trg_edit_inp_dscenario 
  INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_shortpipe 
  FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('SHORTPIPE');

  CREATE TRIGGER gw_trg_edit_inp_dscenario 
  INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_tank 
  FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('TANK');

  CREATE TRIGGER gw_trg_edit_inp_dscenario 
  INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_valve 
  FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('VALVE');


CREATE TRIGGER gw_trg_edit_man_pump_pol
INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_pol_pump
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_pump_pol');

CREATE TRIGGER gw_trg_edit_man_source_pol
INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_pol_source
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_source_pol');

CREATE TRIGGER gw_trg_edit_man_netwjoin_pol
INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_pol_netwjoin
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_node_pol('man_netwjoin_pol');