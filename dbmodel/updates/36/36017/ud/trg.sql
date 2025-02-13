/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 23/12/2024
create trigger gw_trg_edit_link instead of insert or delete or update
on v_edit_link_connec for each row execute function gw_trg_edit_link();

create trigger gw_trg_edit_link instead of insert or delete or update
on v_edit_link_gully for each row execute function gw_trg_edit_link();

-- 14/01/2025
CREATE TRIGGER gw_trg_v_ui_drainzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_drainzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_drainzone('ui');

CREATE TRIGGER gw_trg_edit_drainzone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_drainzone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_drainzone('edit');

DROP TRIGGER IF EXISTS gw_trg_edit_pol_connec ON ve_pol_connec;
CREATE TRIGGER gw_trg_edit_pol_connec INSTEAD OF INSERT OR DELETE OR UPDATE
ON ve_pol_connec FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_connec_pol();

DROP TRIGGER IF EXISTS gw_trg_edit_pol_node ON ve_pol_node;
CREATE TRIGGER gw_trg_edit_pol_node INSTEAD OF INSERT OR DELETE OR UPDATE
ON ve_pol_node FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_man_node_pol();
