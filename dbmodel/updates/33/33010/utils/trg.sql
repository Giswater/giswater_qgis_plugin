/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--31/10/2019

DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON SCHEMA_NAME.man_addfields_parameter;
CREATE TRIGGER gw_trg_typevalue_fk
  AFTER INSERT OR UPDATE
  ON SCHEMA_NAME.man_addfields_parameter
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_typevalue_fk('man_addfields_parameter');


DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON SCHEMA_NAME.plan_psector;
CREATE TRIGGER gw_trg_typevalue_fk
  AFTER INSERT OR UPDATE
  ON SCHEMA_NAME.plan_psector
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_typevalue_fk('plan_psector');


DROP TRIGGER IF EXISTS gw_trg_typevalue_fk ON SCHEMA_NAME.om_visit_parameter;
CREATE TRIGGER gw_trg_typevalue_fk
  AFTER INSERT OR UPDATE
  ON SCHEMA_NAME.om_visit_parameter
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_typevalue_fk('om_visit_parameter');

