/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 21/05/2026
CREATE TRIGGER gw_trg_edit_omunit INSTEAD OF INSERT
OR DELETE
OR UPDATE ON
ve_omunit FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_omunit('EDIT');

CREATE TRIGGER gw_trg_edit_macroomunit INSTEAD OF INSERT
OR DELETE
OR UPDATE ON
ve_macroomunit FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macroomunit('EDIT');
