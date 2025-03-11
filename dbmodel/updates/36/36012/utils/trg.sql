/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--05/08/2024
DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_visit ON v_ui_doc_x_visit;
CREATE trigger gw_trg_ui_doc_x_visit instead OF
INSERT OR DELETE OR UPDATE ON v_ui_doc_x_visit FOR each row EXECUTE function gw_trg_ui_doc('doc_x_visit');

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_arc ON v_ui_doc_x_arc;
CREATE trigger gw_trg_ui_doc_x_arc instead OF
INSERT OR DELETE OR UPDATE ON v_ui_doc_x_arc FOR each row EXECUTE function gw_trg_ui_doc('doc_x_arc');

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_connec ON v_ui_doc_x_connec;
CREATE trigger gw_trg_ui_doc_x_connec instead OF
INSERT OR DELETE OR UPDATE ON v_ui_doc_x_connec FOR each row EXECUTE function gw_trg_ui_doc('doc_x_connec');

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_node ON v_ui_doc_x_node;
CREATE trigger gw_trg_ui_doc_x_node instead OF
INSERT OR DELETE OR UPDATE ON v_ui_doc_x_node FOR each row EXECUTE function gw_trg_ui_doc('doc_x_node');
