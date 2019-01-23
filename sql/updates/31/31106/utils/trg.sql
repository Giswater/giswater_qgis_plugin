/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_arc_insp
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_multievent('arc');


CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_node_insp
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_multievent('node');


CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_connec_insp
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_multievent('connec');


CREATE TRIGGER gw_trg_om_visit_singlevent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_singlevent_x_arc
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_singlevent('arc');


CREATE TRIGGER gw_trg_om_visit_singlevent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_singlevent_x_connec
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_singlevent('connec');


CREATE TRIGGER gw_trg_om_visit_singlevent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_singlevent_x_node
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_singlevent('node');
  
  

-- REVISAR
DROP TRIGGER IF EXISTS gw_trg_man_addfields_value_node_control ON node;
CREATE TRIGGER gw_trg_man_addfields_value_node_control AFTER UPDATE OF node_id OR DELETE ON SCHEMA_NAME.node
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_man_addfields_value_control('NODE');

DROP TRIGGER IF EXISTS gw_trg_man_addfields_value_arc_control ON arc;
CREATE TRIGGER gw_trg_man_addfields_value_arc_control AFTER UPDATE OF arc_id OR DELETE ON SCHEMA_NAME.arc
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_man_addfields_value_control('ARC');

DROP TRIGGER IF EXISTS gw_trg_man_addfields_value_connec_control ON connec;
CREATE TRIGGER gw_trg_man_addfields_value_connec_control AFTER UPDATE OF connec_id OR DELETE ON SCHEMA_NAME.connec
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_man_addfields_value_control('CONNEC');
