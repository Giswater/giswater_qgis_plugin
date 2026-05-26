/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON 
v_ui_element_x_node FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('node');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON 
v_ui_element_x_arc FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('arc');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON 
v_ui_element_x_connec FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('connec');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR DELETE OR UPDATE ON 
v_ui_element_x_link FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('link');