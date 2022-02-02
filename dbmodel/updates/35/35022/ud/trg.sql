/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/31
DROP TRIGGER IF EXISTS gw_trg_edit_inp_pattern ON v_edit_inp_pattern;
CREATE TRIGGER gw_trg_edit_inp_pattern INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_pattern
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_pattern('inp_pattern');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_pattern ON v_edit_inp_pattern_value;
CREATE TRIGGER gw_trg_edit_inp_pattern INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_pattern_value
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_pattern('inp_pattern_value');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_timeseries ON v_edit_inp_timeseries;
CREATE TRIGGER gw_trg_edit_inp_timeseries INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_timeseries
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_timeseries('inp_timeseries');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_timeseries ON v_edit_inp_timeseries_value;
CREATE TRIGGER gw_trg_edit_inp_timeseries INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_timeseries_value
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_timeseries('inp_timeseries_value');

CREATE TRIGGER gw_trg_vi_outlets INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_outlets
FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_outlets');

CREATE TRIGGER gw_trg_vi_orifices INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_orifices
FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_orifices');

CREATE TRIGGER gw_trg_vi_weirs INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_weirs
FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_weirs');

CREATE TRIGGER gw_trg_vi_outfalls INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_outfalls
FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_outfalls');

DROP TRIGGER IF EXISTS gw_trg_vi_junctions ON vi_junctions;
CREATE TRIGGER gw_trg_vi_junctions INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_junctions
FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_junctions');

DROP TRIGGER IF EXISTS gw_trg_vi_xsections ON vi_xsections;
CREATE TRIGGER gw_trg_vi_xsections INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_xsections
FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_xsections');

DROP TRIGGER IF EXISTS gw_trg_vi_adjustments ON vi_adjustments;
CREATE TRIGGER gw_trg_vi_adjustments INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_adjustments
FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_adjustments');

DROP TRIGGER IF EXISTS  gw_trg_edit_inp_dscenario ON v_edit_inp_dscenario_lid_usage;
CREATE TRIGGER gw_trg_edit_inp_dscenario INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_lid_usage
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('LID-USAGE');

