/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_arc ON v_ui_doc_x_arc;
DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_connec ON v_ui_doc_x_connec;
DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_node ON v_ui_doc_x_node;
DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_visit ON v_ui_doc_x_visit;

CREATE TRIGGER gw_trg_ui_doc_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_arc');

CREATE TRIGGER gw_trg_ui_doc_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_connec');

CREATE TRIGGER gw_trg_ui_doc_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_node');

CREATE TRIGGER gw_trg_ui_doc_x_visit INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_visit
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_visit');

create trigger gw_trg_edit_ve_epa_pipe instead of insert or delete or update on
ve_epa_pipe for each row execute procedure gw_trg_edit_ve_epa('pipe');

create trigger gw_trg_edit_ve_epa_pump instead of insert or delete or update on
ve_epa_pump for each row execute procedure gw_trg_edit_ve_epa('pump');

create trigger gw_trg_edit_ve_epa_pump_additional instead of insert or delete or update on
ve_epa_pump_additional for each row execute procedure gw_trg_edit_ve_epa('pump_additional');

create trigger gw_trg_edit_ve_epa_shortpipe instead of insert or delete or update on
ve_epa_shortpipe for each row execute procedure gw_trg_edit_ve_epa('shortpipe');

create trigger gw_trg_edit_ve_epa_valve instead of insert or delete or update on
ve_epa_valve for each row execute procedure gw_trg_edit_ve_epa('valve');

create trigger gw_trg_edit_ve_epa_virtualvalve instead of insert or delete or update on
ve_epa_virtualvalve for each row execute procedure gw_trg_edit_ve_epa('virtualvalve');

create trigger gw_trg_edit_ve_epa_virtualpump instead of insert or delete or update on
ve_epa_virtualpump for each row execute procedure gw_trg_edit_ve_epa('virtualpump');