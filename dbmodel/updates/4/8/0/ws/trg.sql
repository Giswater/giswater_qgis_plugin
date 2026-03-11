/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 02/02/2026
CREATE TRIGGER gw_trg_ui_doc_x_visit INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_doc_x_visit FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('visit');

CREATE TRIGGER gw_trg_ui_doc_x_node INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_doc_x_node FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('node');

CREATE TRIGGER gw_trg_ui_doc_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_doc_x_arc FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('arc');

CREATE TRIGGER gw_trg_ui_doc_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_doc_x_connec FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('connec');

CREATE TRIGGER gw_trg_ui_doc_x_link INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_doc_x_link FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('link');

CREATE TRIGGER gw_trg_ui_doc_x_element INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_doc_x_element FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('element');



-- 11/03/2026
create trigger gw_trg_edit_inp_node_valve instead of insert or delete or update on
ve_inp_valve for each row execute function gw_trg_edit_inp_node('inp_valve');

create trigger gw_trg_edit_ve_epa_valve instead of insert or delete or update on
ve_epa_valve for each row execute function gw_trg_edit_ve_epa('valve');

create trigger gw_trg_edit_inp_dscenario_valve instead of insert or delete or update on
ve_inp_dscenario_valve for each row execute function gw_trg_edit_inp_dscenario('VALVE');

create trigger gw_trg_edit_inp_node_shortpipe instead of insert or delete or update on
ve_inp_shortpipe for each row execute function gw_trg_edit_inp_node('inp_shortpipe');

create trigger gw_trg_edit_inp_dscenario_shortpipe instead of insert or delete or update on
ve_inp_dscenario_shortpipe for each row execute function gw_trg_edit_inp_dscenario('SHORTPIPE');

create trigger gw_trg_edit_ve_epa_shortpipe instead of insert or delete or update on
ve_epa_shortpipe for each row execute function gw_trg_edit_ve_epa('shortpipe');
