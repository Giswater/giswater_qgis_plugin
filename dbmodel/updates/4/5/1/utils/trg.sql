/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT
OR DELETE
OR UPDATE ON
v_ui_element_x_connec FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('connec');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT
OR DELETE
OR UPDATE ON
v_ui_element_x_link FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('link');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT
OR DELETE
OR UPDATE ON
v_ui_element_x_node FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('node');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT
OR DELETE
OR UPDATE ON
v_ui_element_x_arc FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('arc');

DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_category;
DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_function;
DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_location;
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF feature_type, featurecat_id ON man_type_category FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_category');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF feature_type, featurecat_id ON man_type_function FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_function');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF feature_type, featurecat_id ON man_type_location FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_location');

CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER UPDATE OF category_type ON man_type_category FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('man_type_category', 'category_type');
CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER UPDATE OF function_type ON man_type_function FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('man_type_function', 'function_type');
CREATE TRIGGER gw_trg_mantypevalue_fk_update AFTER UPDATE OF location_type ON man_type_location FOR EACH ROW EXECUTE FUNCTION gw_trg_mantypevalue_fk('man_type_location', 'location_type');
