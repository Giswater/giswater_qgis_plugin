/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR DELETE OR UPDATE ON
v_edit_link FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('parent');

CREATE TRIGGER gw_trg_edit_link_link INSTEAD OF INSERT OR DELETE OR UPDATE ON
ve_link_link FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('LINK');