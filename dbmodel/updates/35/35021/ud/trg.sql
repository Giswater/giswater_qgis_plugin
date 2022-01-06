/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/05
CREATE TRIGGER gw_trg_vi_xsections
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_options
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_vi('vi_options');
 
  
CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_outfall
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('OUTFALL');


CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_storage
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('STORAGE');


CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_divider
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('DIVIDER');
  
  
CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_weir
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('WEIR');
 
 
CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_pump
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('PUMP');
  
 
CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_orifice
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('ORIFICE');
  
  
CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_outlet
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('OUTLET');
  
  
CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_inflows
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('INFLOWS');


CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_inflows_pol_x_node
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('INFLOWS_POL_X_NODE');
  
  
CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_treatment
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('TREATMENT');