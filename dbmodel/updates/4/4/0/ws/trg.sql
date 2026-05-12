/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON sector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('sector_id');

CREATE TRIGGER gw_trg_edit_ve_epa_frvalve INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_epa_frvalve FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('frvalve');

CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_inp_dscenario_frvalve FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('FLWREG-VALVE');
