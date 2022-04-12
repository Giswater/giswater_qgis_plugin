/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/04/07
CREATE TRIGGER gw_trg_edit_inp_coverage INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_coverage
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_coverage();


--2022/04/12
CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_flwreg_orifice
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('FLWREG-ORIFICE');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_flwreg_outlet
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('FLWREG-OUTLET');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_flwreg_pump
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('FLWREG-PUMP');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_flwreg_weir
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('FLWREG-WEIR');


