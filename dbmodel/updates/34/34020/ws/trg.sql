/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/27

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_valve ON v_edit_inp_valve;
CREATE TRIGGER gw_trg_edit_inp_node_valve INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_valve FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_valve');

DROP TRIGGER IF EXISTS gw_trg_edit_rtc_hydro_data ON v_ui_hydroval_x_connec;
CREATE TRIGGER gw_trg_edit_hydroval_x_connec INSTEAD OF UPDATE
ON v_ui_hydroval_x_connec FOR EACH ROW EXECUTE PROCEDURE gw_trg_ui_hydroval_connec();

DROP TRIGGER IF EXISTS gw_trg_ui_mincut ON v_ui_mincut;
CREATE TRIGGER gw_trg_ui_mincut INSTEAD OF INSERT OR UPDATE OR DELETE 
ON v_ui_mincut FOR EACH ROW EXECUTE PROCEDURE gw_trg_ui_mincut();

DROP TRIGGER IF EXISTS gw_trg_vi_curves ON SCHEMA_NAME.vi_curves;
CREATE TRIGGER gw_trg_vi_curves INSTEAD OF INSERT OR UPDATE OR DELETE 
ON SCHEMA_NAME.vi_curves FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_curves');

DROP TRIGGER IF EXISTS gw_trg_vi_tanks ON SCHEMA_NAME.vi_tanks;
CREATE TRIGGER gw_trg_vi_tanks INSTEAD OF INSERT OR UPDATE OR DELETE 
ON SCHEMA_NAME.vi_tanks FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_tanks');

DROP TRIGGER IF EXISTS gw_trg_vi_valves ON SCHEMA_NAME.vi_valves;
CREATE TRIGGER gw_trg_vi_valves INSTEAD OF INSERT OR UPDATE OR DELETE 
ON SCHEMA_NAME.vi_valves FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_valves');