/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 3.1.111 & 3.1.112

DROP TRIGGER IF EXISTS gw_trg_ui_element ON SCHEMA_NAME.v_ui_element_x_arc;
CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.v_ui_element_x_arc
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_ui_element('element_x_arc');
  
DROP TRIGGER IF EXISTS gw_trg_ui_element ON SCHEMA_NAME.v_ui_element_x_node;
CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.v_ui_element_x_node
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_ui_element('element_x_node');

DROP TRIGGER IF EXISTS gw_trg_ui_element ON SCHEMA_NAME.v_ui_element_x_connec;
CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.v_ui_element_x_connec
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_ui_element('element_x_connec');

DROP TRIGGER IF EXISTS gw_trg_doc ON SCHEMA_NAME.doc;
CREATE TRIGGER gw_trg_doc BEFORE INSERT ON SCHEMA_NAME.doc FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_doc();
