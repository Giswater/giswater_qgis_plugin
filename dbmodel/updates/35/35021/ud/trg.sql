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
  ON v_edit_inp_dscenario_flwreg_weir
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('FLWREG-WEIR');
 
 
CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_flwreg_pump
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('FLWREG-PUMP');
  
 
CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_flwreg_orifice
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('FLWREG-ORIFICE');
  
  
CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_flwreg_outlet
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('FLWREG-OUTLET');
  

CREATE TRIGGER gw_trg_edit_inp_flwreg
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_flwreg_weir
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_flwreg('FLWREG-WEIR');
 
 
CREATE TRIGGER gw_trg_edit_inp_flwreg
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_flwreg_pump
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_flwreg('FLWREG-PUMP');
  
 
CREATE TRIGGER gw_trg_edit_inp_flwreg
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_flwreg_orifice
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_flwreg('FLWREG-ORIFICE');
  
  
CREATE TRIGGER gw_trg_edit_inp_flwreg
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_flwreg_outlet
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_flwreg('FLWREG-OUTLET');

  
CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_inflows
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('INFLOWS');


CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_inflows_poll
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('INFLOWS-POLL');
  
  
CREATE TRIGGER gw_trg_edit_inp_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_dscenario_treatment
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('TREATMENT');

 
CREATE TRIGGER gw_trg_vi_inflows
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_inflows
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_vi('vi_inflows');

 
CREATE TRIGGER gw_trg_vi_treatment
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_treatment
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_vi('vi_treatment');


CREATE TRIGGER gw_trg_vi_outlets
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_outlets
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_vi('vi_outlets');


CREATE TRIGGER gw_trg_vi_orifices
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_orifices
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_vi('vi_orifices');


CREATE TRIGGER gw_trg_vi_weirs
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_weirs
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_vi('vi_weirs');


CREATE TRIGGER gw_trg_vi_pumps
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_pumps
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_vi('vi_pumps');
  
    
CREATE TRIGGER gw_trg_edit_inp_inflows
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_inflows
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_inflows('INFLOWS');


CREATE TRIGGER gw_trg_edit_inp_inflows
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_inflows_poll
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_inflows('INFLOWS-POLL');
  
  
CREATE TRIGGER gw_trg_edit_inp_treatment
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_treatment
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_treatment();
  
  
CREATE TRIGGER gw_trg_edit_inp_arc_outlet
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_outlet
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_outlet');
  
  
CREATE TRIGGER gw_trg_edit_inp_arc_orifice
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_orifice
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_orifice');
  
  
  CREATE TRIGGER gw_trg_edit_inp_arc_weir
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_weir
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_weir');


