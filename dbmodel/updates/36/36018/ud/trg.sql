/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_arc ON v_ui_doc_x_arc;
DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_connec ON v_ui_doc_x_connec;
DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_gully ON v_ui_doc_x_gully;
DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_node ON v_ui_doc_x_node;
DROP TRIGGER IF EXISTS gw_trg_ui_doc_x_visit ON v_ui_doc_x_visit;



CREATE TRIGGER gw_trg_ui_doc_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_arc');

CREATE TRIGGER gw_trg_ui_doc_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_connec
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_connec');

CREATE TRIGGER gw_trg_ui_doc_x_gully INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_gully');

CREATE TRIGGER gw_trg_ui_doc_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_node');

CREATE TRIGGER gw_trg_ui_doc_x_visit INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_doc_x_visit
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('doc_x_visit');
