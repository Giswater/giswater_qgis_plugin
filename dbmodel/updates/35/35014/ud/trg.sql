/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/10/09
DROP TRIGGER IF EXISTS gw_trg_edit_inp_lid_usage ON v_edit_inp_lid_usage;
CREATE TRIGGER gw_trg_edit_inp_lid_usage INSTEAD OF INSERT OR UPDATE OR DELETE 
ON v_edit_inp_lid_usage FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_lid_usage();

CREATE TRIGGER gw_trg_vi_gwf INSTEAD OF INSERT OR UPDATE OR DELETE 
ON vi_gwf FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_gwf');

CREATE TRIGGER gw_trg_vi_subareas INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_subareas FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_subareas');

CREATE TRIGGER gw_trg_vi_coverages INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_coverages FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_coverages');

CREATE TRIGGER gw_trg_vi_groundwater INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_groundwater FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_groundwater');

CREATE TRIGGER gw_trg_vi_lid_usage INSTEAD OF INSERT OR UPDATE OR DELETE
ON vi_lid_usage FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_lid_usage');

CREATE TRIGGER gw_trg_edit_inp_dwf INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_dwf FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dwf();

CREATE TRIGGER gw_trg_edit_inp_subcatchment INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_subcatchment FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_subcatchment('subcatchment');
