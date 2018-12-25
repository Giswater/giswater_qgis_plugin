/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE TRIGGER gw_trg_ui_rpt_cat_result INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.ve_ui_rpt_result_cat
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_ui_rpt_cat_result();

DROP TRIGGER IF EXISTS gw_trg_edit_psector_x_other ON "SCHEMA_NAME".ve_plan_psector_x_other;
CREATE TRIGGER gw_trg_edit_psector_x_other INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_plan_psector_x_other
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_psector_x_other('plan');

DROP TRIGGER IF EXISTS gw_trg_edit_psector_x_other ON "SCHEMA_NAME".ve_om_psector_x_other;
CREATE TRIGGER gw_trg_edit_psector_x_other INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_om_psector_x_other
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_psector_x_other('om');

DROP TRIGGER IF EXISTS gw_trg_edit_element ON "SCHEMA_NAME".ve_element;
CREATE TRIGGER gw_trg_edit_element INSTEAD OF INSERT OR DELETE OR UPDATE 
ON "SCHEMA_NAME".ve_element FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_element('element');

DROP TRIGGER IF EXISTS gw_trg_edit_dimensions ON "SCHEMA_NAME".ve_dimensions;
CREATE TRIGGER gw_trg_edit_dimensions INSTEAD OF INSERT OR DELETE OR UPDATE 
ON "SCHEMA_NAME".ve_dimensions FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_dimensions('dimensions');

DROP TRIGGER IF EXISTS gw_trg_edit_cad_aux ON "SCHEMA_NAME".ve_cad_auxcircle;
CREATE TRIGGER gw_trg_edit_cad_aux INSTEAD OF INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.ve_cad_auxcircle  FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_cad_aux('circle');

DROP TRIGGER IF EXISTS gw_trg_edit_cad_aux ON "SCHEMA_NAME".ve_cad_auxpoint;
CREATE TRIGGER gw_trg_edit_cad_aux  INSTEAD OF INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.ve_cad_auxpoint  FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_cad_aux('point');
