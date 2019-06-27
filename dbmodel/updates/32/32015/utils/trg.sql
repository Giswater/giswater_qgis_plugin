/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



CREATE TRIGGER gw_trg_om_psector_x_connec AFTER INSERT OR UPDATE OR DELETE ON om_psector_x_connec
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_geom('om');
  
  
CREATE TRIGGER gw_trg_plan_psector_x_connec AFTER INSERT OR UPDATE OF connec_id, arc_id ON plan_psector_x_connec 
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_x_connec();

  
CREATE TRIGGER gw_trg_plan_psector_x_connec_geom AFTER INSERT OR UPDATE OR DELETE  ON plan_psector_x_connec
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_geom('plan');
