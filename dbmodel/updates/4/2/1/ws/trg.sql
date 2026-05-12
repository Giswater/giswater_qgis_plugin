/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_ui_rpt_cat_result ON v_ui_rpt_cat_result;
CREATE TRIGGER gw_trg_ui_rpt_cat_result INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_rpt_cat_result
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_rpt_cat_result();

CREATE TRIGGER gw_trg_edit_ve_epa_link INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('link');

CREATE TRIGGER gw_trg_edit_ve_epa_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_epa_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_ve_epa('connec');

-- 27/08/2025
CREATE TRIGGER gw_trg_v_edit_sector INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_sector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('EDIT');

CREATE TRIGGER gw_trg_v_edit_presszone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_presszone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_presszone('EDIT');

CREATE TRIGGER gw_trg_v_edit_dma INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_dma
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('EDIT');

CREATE TRIGGER gw_trg_v_edit_dqa INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_dqa
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dqa('EDIT');

CREATE TRIGGER gw_trg_v_edit_supplyzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_supplyzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_supplyzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_omzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_omzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_omzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_macroomzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_macroomzone
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macroomzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_macrosector INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_macrosector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrosector('EDIT');

CREATE TRIGGER gw_trg_v_edit_macrodqa INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_macrodqa
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrodqa('EDIT');

CREATE TRIGGER gw_trg_v_edit_macrodma INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_macrodma
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrodma('EDIT');