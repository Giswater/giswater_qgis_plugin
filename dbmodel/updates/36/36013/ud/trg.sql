/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

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

drop trigger if exists gw_trg_typevalue_fk on gully;
create trigger gw_trg_typevalue_fk after insert or update of verified, units_placement
on gully for each row execute function gw_trg_typevalue_fk('gully');