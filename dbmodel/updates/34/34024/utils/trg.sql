/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/10/27

DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_connec ON plan_psector_x_connec;

CREATE TRIGGER gw_trg_plan_psector_x_connec
  BEFORE INSERT OR UPDATE OF connec_id, state OR DELETE
  ON plan_psector_x_connec FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_plan_psector_x_connec();

DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_node ON plan_psector_x_node;

CREATE TRIGGER gw_trg_plan_psector_x_node
  BEFORE INSERT OR UPDATE OF node_id, state OR DELETE
  ON plan_psector_x_node FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_plan_psector_x_node();

DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_arc ON plan_psector_x_arc;

CREATE TRIGGER gw_trg_plan_psector_x_arc
  BEFORE INSERT OR UPDATE OF arc_id, state OR DELETE
  ON plan_psector_x_arc FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_plan_psector_x_arc();