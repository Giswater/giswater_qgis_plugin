/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TRIGGER gw_trg_vi_coverages INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_coverages FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_coverages');
CREATE TRIGGER gw_trg_vi_groundwater INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_groundwater FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_groundwater');
CREATE TRIGGER gw_trg_vi_infiltration INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_infiltration FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_infiltration');
CREATE TRIGGER gw_trg_vi_lid_usage INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_lid_usage FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_lid_usage');
CREATE TRIGGER gw_trg_vi_loadings INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_loadings FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_loadings');
CREATE TRIGGER gw_trg_vi_subareas INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_subareas FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_subareas');
CREATE TRIGGER gw_trg_vi_subcatchments INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_subcatchments FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_subcatchments');
CREATE TRIGGER gw_trg_vi_gwf INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_gwf FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_gwf');

-- trigger deleted on 3.4.010
--CREATE TRIGGER gw_trg_edit_subcatchment INSTEAD OF INSERT OR UPDATE OR DELETE  ON SCHEMA_NAME.v_edit_subcatchment  
--FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_subcatchment('subcatchment');

CREATE TRIGGER gw_trg_plan_psector_x_gully BEFORE INSERT OR UPDATE OF gully_id ON plan_psector_x_gully 
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_x_gully();
  
CREATE TRIGGER gw_trg_plan_psector_x_gully_geom AFTER INSERT OR UPDATE OR DELETE  ON plan_psector_x_gully
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_geom('plan');


CREATE TRIGGER gw_trg_plan_psector_link AFTER INSERT OR UPDATE OF arc_id ON plan_psector_x_gully 
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_link('gully');


--28/06/2019
CREATE TRIGGER gw_trg_ui_event_x_gully INSTEAD OF INSERT OR UPDATE OR DELETE ON v_ui_event_x_gully
FOR EACH ROW EXECUTE PROCEDURE gw_trg_ui_event('om_visit_event');


DROP TRIGGER IF EXISTS gw_trg_man_addfields_value_gully_control ON gully;

CREATE TRIGGER gw_trg_edit_foreignkey AFTER UPDATE OF gully_id OR DELETE ON gully
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_foreignkey('gully_id');