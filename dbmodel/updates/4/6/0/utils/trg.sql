/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_exploitation INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_exploitation 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_exploitation();

CREATE TRIGGER gw_trg_ui_visit INSTEAD OF DELETE ON v_ui_om_visit 
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_visit();

CREATE TRIGGER gw_trg_v_edit_macrosector INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_macrosector 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrosector('EDIT');

CREATE TRIGGER gw_trg_v_edit_macroomzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_macroomzone 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macroomzone('EDIT');
