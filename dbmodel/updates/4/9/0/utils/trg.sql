/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 31/03/2026
DROP TRIGGER IF EXISTS gw_trg_edit_controls ON node;
DROP TRIGGER IF EXISTS gw_trg_edit_controls ON arc;
DROP TRIGGER IF EXISTS gw_trg_edit_controls ON connec;
DROP TRIGGER IF EXISTS gw_trg_edit_controls ON link;

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON node FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('node_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON arc FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('arc_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON connec FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('connec_id');

CREATE TRIGGER gw_trg_edit_controls BEFORE DELETE OR UPDATE
ON link FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('link_id');

DROP TRIGGER gw_trg_fk_array_array_table_expl ON ext_municipality;
DROP TRIGGER gw_trg_fk_array_array_table_sector ON ext_municipality;

create trigger gw_trg_edit_address instead of insert or delete or update on ve_address for each row execute function gw_trg_edit_address();
create trigger gw_trg_edit_municipality instead of insert or delete or update on ve_municipality for each row execute function gw_trg_edit_municipality();
create trigger gw_trg_edit_plot instead of insert or delete or update on ve_plot for each row execute function gw_trg_edit_plot();
create trigger gw_trg_edit_streetaxis instead of insert or delete or update on ve_streetaxis for each row execute function gw_trg_edit_streetaxis();
