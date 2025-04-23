/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_vi_conduits ON vi_conduits;
DROP TRIGGER IF EXISTS gw_trg_vi_dividers ON vi_dividers;
DROP TRIGGER IF EXISTS gw_trg_vi_losses ON vi_losses;
DROP TRIGGER IF EXISTS gw_trg_vi_orifices ON vi_orifices;
DROP TRIGGER IF EXISTS gw_trg_vi_outfalls ON vi_outfalls;
DROP TRIGGER IF EXISTS gw_trg_vi_outlets ON vi_outlets;
DROP TRIGGER IF EXISTS gw_trg_vi_storage ON vi_storage;
DROP TRIGGER IF EXISTS gw_trg_vi_weirs ON vi_weirs;
DROP TRIGGER IF EXISTS gw_trg_vi_xsections ON vi_xsections;
DROP TRIGGER IF EXISTS gw_trg_vi_quality ON vi_quality;


CREATE TRIGGER gw_trg_edit_cat_feature INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_cat_feature_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_cat_feature('link');

CREATE TRIGGER gw_trg_edit_cat_feature INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_cat_feature_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_cat_feature('element');

-- CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON link
-- FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('link');

-- CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON cat_link
-- FOR EACH ROW WHEN (((old.matcat_id)::TEXT IS DISTINCT FROM (new.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('link');

DROP TRIGGER IF EXISTS gw_trg_edit_element ON man_frelem;
DROP TRIGGER IF EXISTS gw_trg_edit_element ON man_genelem;
DROP TRIGGER IF EXISTS gw_trg_edit_element ON element;

CREATE TRIGGER gw_trg_ui_doc_x_element INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_element
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('element');
