/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/05
CREATE TRIGGER gw_trg_edit_cat_dscenario
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_cat_dscenario
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_cat_dscenario();
  
   
CREATE TRIGGER gw_trg_ui_rpt_cat_result
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_ui_rpt_cat_result
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_ui_rpt_cat_result();


CREATE TRIGGER gw_trg_edit_psector_x_other
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_plan_psector_x_other
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_psector_x_other('plan');
