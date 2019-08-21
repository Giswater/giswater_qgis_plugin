/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_node_statecontrol ON node; 
CREATE TRIGGER gw_trg_node_statecontrol  BEFORE INSERT OR UPDATE OF state
ON node FOR EACH ROW EXECUTE PROCEDURE gw_trg_node_statecontrol();


DROP TRIGGER IF EXISTS gw_trg_unique_field ON connec ;
CREATE TRIGGER gw_trg_unique_field
AFTER INSERT OR UPDATE OF customer_code, state
ON connec  FOR EACH ROW EXECUTE PROCEDURE gw_trg_unique_field('connec');

DROP TRIGGER IF EXISTS gw_trg_unique_field ON plan_psector_x_arc ;
CREATE TRIGGER gw_trg_unique_field
AFTER INSERT OR UPDATE OF arc_id, state
ON plan_psector_x_arc FOR EACH ROW EXECUTE PROCEDURE gw_trg_unique_field('plan_x_arc');

DROP TRIGGER IF EXISTS gw_trg_unique_field ON plan_psector_x_node ;
CREATE TRIGGER gw_trg_unique_field
AFTER INSERT OR UPDATE OF node_id, state
ON plan_psector_x_node FOR EACH ROW EXECUTE PROCEDURE gw_trg_unique_field('plan_x_node');

DROP TRIGGER IF EXISTS gw_trg_unique_field ON plan_psector_x_connec ;
CREATE TRIGGER gw_trg_unique_field
AFTER INSERT OR UPDATE OF connec_id, state
ON plan_psector_x_connec FOR EACH ROW EXECUTE PROCEDURE gw_trg_unique_field('plan_x_connec');
