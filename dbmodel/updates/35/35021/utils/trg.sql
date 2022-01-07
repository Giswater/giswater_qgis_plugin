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
  
   
CREATE TRIGGER gw_trg_ui_rpt_cat_result;
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON ud_sample.v_ui_plan_psector
  FOR EACH ROW
  EXECUTE PROCEDURE ud_sample.gw_trg_ui_plan_psector();
