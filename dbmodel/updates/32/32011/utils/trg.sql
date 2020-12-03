/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP TRIGGER IF EXISTS gw_trg_node_update ON SCHEMA_NAME.node;

DROP TRIGGER IF EXISTS gw_trg_topocontrol_node ON SCHEMA_NAME.node;
CREATE TRIGGER gw_trg_topocontrol_node AFTER INSERT OR UPDATE OF the_geom, state
ON SCHEMA_NAME.node FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_topocontrol_node();

DROP TRIGGER IF EXISTS gw_trg_om_visit ON "SCHEMA_NAME".om_visit;
CREATE TRIGGER gw_trg_om_visit AFTER INSERT OR UPDATE OF class_id, status OR DELETE ON "SCHEMA_NAME".om_visit
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_om_visit();


  
  CREATE TRIGGER gw_trg_om_visit_singlevent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_arc_singlevent
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_singlevent('arc');  
 
  CREATE TRIGGER gw_trg_om_visit_singlevent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_connec_singlevent
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_singlevent('connec');
 
  CREATE TRIGGER gw_trg_om_visit_singlevent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_node_singlevent
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_singlevent('node');
  
  


  