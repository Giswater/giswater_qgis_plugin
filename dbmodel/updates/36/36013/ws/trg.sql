/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_sector INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_sector
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_sector('sector');

CREATE TRIGGER gw_trg_edit_inp_arc_pipe INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_pipe
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_pipe');

CREATE TRIGGER gw_trg_edit_ve_epa_pipe INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_epa_pipe
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_ve_epa('pipe');


-- 20/09/2024
drop trigger if exists gw_trg_typevalue_fk on arc;
create trigger gw_trg_typevalue_fk after insert or update of verified
on arc for each row execute function gw_trg_typevalue_fk('arc');

drop trigger if exists gw_trg_typevalue_fk on node;
create trigger gw_trg_typevalue_fk after insert or update of verified
on node for each row execute function gw_trg_typevalue_fk('node');

drop trigger if exists gw_trg_typevalue_fk on connec;
create trigger gw_trg_typevalue_fk after insert or update of verified
on connec for each row execute function gw_trg_typevalue_fk('connec');