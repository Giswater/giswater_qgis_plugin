/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/05/05
DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_arc ON v_edit_review_audit_arc;
CREATE TRIGGER gw_trg_edit_review_audit_arc
  INSTEAD OF UPDATE
  ON v_edit_review_audit_arc
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_audit_arc();

  DROP TRIGGER IF EXISTS gw_trg_edit_review_arc ON v_edit_review_arc;
  CREATE TRIGGER gw_trg_edit_review_arc
  INSTEAD OF INSERT OR UPDATE
  ON v_edit_review_arc
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_arc();
  
  
  DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_node ON v_edit_review_audit_node;
  CREATE TRIGGER gw_trg_edit_review_audit_node
  INSTEAD OF UPDATE
  ON v_edit_review_audit_node
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_audit_node();
  
  
  DROP TRIGGER IF EXISTS gw_trg_edit_review_node ON v_edit_review_node;
  CREATE TRIGGER gw_trg_edit_review_node
  INSTEAD OF INSERT OR UPDATE
  ON v_edit_review_node
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_node();
  
  
  DROP TRIGGER IF EXISTS gw_trg_edit_review_audit_connec ON v_edit_review_audit_connec;
  CREATE TRIGGER gw_trg_edit_review_audit_connec
  INSTEAD OF UPDATE
  ON v_edit_review_audit_connec
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_audit_connec();
  
  
  DROP TRIGGER IF EXISTS gw_trg_edit_review_connec ON v_edit_review_connec;
  CREATE TRIGGER gw_trg_edit_review_connec
  INSTEAD OF INSERT OR UPDATE
  ON v_edit_review_connec
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_review_connec();
