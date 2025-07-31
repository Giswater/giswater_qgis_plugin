/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_frelem_x_node BEFORE INSERT ON element_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_frelem_x_node();

CREATE TRIGGER gw_trg_edit_municipality INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ext_municipality
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_municipality();

CREATE TRIGGER gw_trg_ui_rpt_cat_result INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_rpt_cat_result
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_rpt_cat_result();

DROP TRIGGER IF EXISTS gw_trg_cat_feature_delete ON cat_feature;

CREATE TRIGGER gw_trg_cat_feature_delete BEFORE INSERT OR DELETE OR UPDATE ON 
cat_feature FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_feature('DELETE');
