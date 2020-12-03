/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;




DROP TRIGGER IF EXISTS gw_trg_connec_update ON connec;
DROP TRIGGER IF EXISTS gw_trg_update_link_arc_id ON connec;

--CREATE TRIGGER gw_trg_connect_update AFTER UPDATE OF arc_id, pjoint_id, pjoint_type, the_geom
--ON SCHEMA_NAME.connec FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_update_link_arc_id('connec');

CREATE TRIGGER gw_trg_om_lot_x_arc_geom AFTER INSERT OR UPDATE OR DELETE
ON om_visit_lot_x_arc FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_geom('lot');

CREATE TRIGGER gw_trg_om_lot_x_node_geom AFTER INSERT OR UPDATE OR DELETE
ON om_visit_lot_x_node FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_geom('lot');

CREATE TRIGGER gw_trg_om_lot_x_connec_geom AFTER INSERT OR UPDATE OR DELETE
ON om_visit_lot_x_connec FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_geom('lot');

CREATE TRIGGER gw_trg_typevalue_config_fk AFTER INSERT OR UPDATE ON typevalue_fk
FOR EACH ROW EXECUTE PROCEDURE gw_trg_typevalue_config_fk('typevalue_fk');

CREATE TRIGGER gw_trg_typevalue_config_fk AFTER INSERT OR UPDATE OR DELETE ON edit_typevalue FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_typevalue_config_fk('edit_typevalue');

CREATE TRIGGER gw_trg_typevalue_config_fk AFTER INSERT OR UPDATE OR DELETE ON plan_typevalue FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_typevalue_config_fk('plan_typevalue');

CREATE TRIGGER gw_trg_typevalue_config_fk AFTER INSERT OR UPDATE OR DELETE ON inp_typevalue FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_typevalue_config_fk('inp_typevalue');

CREATE TRIGGER gw_trg_typevalue_config_fk AFTER INSERT OR UPDATE OR DELETE ON om_typevalue FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_typevalue_config_fk('om_typevalue');
  
CREATE TRIGGER gw_trg_cat_manager AFTER INSERT OR UPDATE OR DELETE ON cat_manager FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_cat_manager();
  
  
ALTER TABLE edit_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
ALTER TABLE plan_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
ALTER TABLE om_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
ALTER TABLE typevalue_fk DISABLE TRIGGER gw_trg_typevalue_config_fk;
 


 