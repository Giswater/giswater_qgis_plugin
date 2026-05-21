/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_sector INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_sector
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_sector('sector');

CREATE TRIGGER gw_trg_edit_inp_arc_pipe INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_pipe
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_pipe');

CREATE TRIGGER gw_trg_edit_ve_epa_pipe INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_pipe
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('pipe');
