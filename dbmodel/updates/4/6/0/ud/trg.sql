/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_v_edit_sector INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_sector 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('EDIT');

CREATE TRIGGER gw_trg_v_edit_omzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_omzone 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_omzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_dma INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_dma 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('EDIT');

CREATE TRIGGER gw_trg_v_edit_dwfzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_dwfzone 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dwfzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_drainzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_drainzone 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_drainzone('EDIT');

-- 02/12/2025
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table_update ON arc;
CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER
UPDATE OF arc_id ON arc FOR EACH ROW WHEN (OLD.arc_id IS DISTINCT FROM NEW.arc_id) EXECUTE FUNCTION gw_trg_array_fk_id_table('arc_id',
'{"man_frelem":"to_arc"}');
