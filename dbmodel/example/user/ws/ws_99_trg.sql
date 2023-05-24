/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;

  CREATE TRIGGER gw_trg_om_visit_multievent
  instead of insert or delete or update
  on ve_visit_arc_insp
  for each row execute function gw_trg_om_visit_multievent('6');

  CREATE TRIGGER gw_trg_om_visit_multievent
  instead of insert or delete or update
  on ve_visit_arc_leak
  for each row execute function gw_trg_om_visit_multievent('1');

  CREATE TRIGGER gw_trg_om_visit_multievent
  instead of insert or delete or update
  on ve_visit_connec_insp
  for each row execute function gw_trg_om_visit_multievent('2');

  CREATE TRIGGER gw_trg_om_visit_multievent
  instead of insert or delete or update
  on ve_visit_connec_leak
  for each row execute function gw_trg_om_visit_multievent('4');

  CREATE TRIGGER gw_trg_om_visit_multievent
  instead of insert or delete or update
  on ve_visit_node_insp
  for each row execute function gw_trg_om_visit_multievent('5');

  CREATE TRIGGER gw_trg_om_visit_multievent
  instead of insert or delete or update
  on ve_visit_node_leak
  for each row execute function gw_trg_om_visit_multievent('3');

  CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_noinfra
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_multievent();

  UPDATE config_param_system SET value='TRUE' WHERE parameter='admin_config_control_trigger';