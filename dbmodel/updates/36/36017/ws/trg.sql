/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 10/01/2025
CREATE TRIGGER gw_trg_edit_sector INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_sector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('edit');

CREATE TRIGGER gw_trg_v_ui_sector INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_sector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('ui');

CREATE TRIGGER gw_trg_edit_dma INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_dma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('edit');

CREATE TRIGGER gw_trg_v_ui_dma INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_dma FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('ui');

CREATE TRIGGER gw_trg_edit_presszone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_presszone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_presszone('edit');

CREATE TRIGGER gw_trg_v_ui_presszone INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_presszone FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_presszone('ui');

CREATE TRIGGER gw_trg_edit_dqa INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_edit_dqa FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dqa('edit');

CREATE TRIGGER gw_trg_v_ui_dqa INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_dqa FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dqa('ui');

CREATE TRIGGER gw_trg_edit_controls AFTER DELETE OR UPDATE ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('arc_id');

CREATE TRIGGER gw_trg_edit_controls AFTER DELETE OR UPDATE ON node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('node_id');

CREATE TRIGGER gw_trg_edit_controls AFTER DELETE OR UPDATE ON connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('connec_id');

CREATE TRIGGER gw_trg_edit_controls AFTER DELETE OR UPDATE ON element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_controls('element_id');
