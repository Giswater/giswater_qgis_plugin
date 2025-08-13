/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_frpump FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-PUMP');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_frorifice FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-ORIFICE');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_frweir FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-WEIR');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_froutlet FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-OUTLET');
