/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/28
DROP TRIGGER IF EXISTS gw_trg_edit_inp_controls ON v_edit_inp_controls;
CREATE TRIGGER gw_trg_edit_inp_controls INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_controls
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_controls();

DROP TRIGGER IF EXISTS gw_trg_edit_inp_rules ON v_edit_inp_rules;
CREATE TRIGGER gw_trg_edit_inp_rules INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_rules
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_rules();	

DROP TRIGGER IF EXISTS gw_trg_edit_inp_curve ON v_edit_inp_curve;
CREATE TRIGGER gw_trg_edit_inp_curve INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_curve
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_curve('inp_curve');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_curve ON v_edit_inp_curve_value;
CREATE TRIGGER gw_trg_edit_inp_curve INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_curve_value
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_curve('inp_curve_value');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_pattern ON v_edit_inp_pattern;
CREATE TRIGGER gw_trg_edit_inp_pattern INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_pattern
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_pattern('inp_pattern');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_pattern ON v_edit_inp_pattern_value;
CREATE TRIGGER gw_trg_edit_inp_pattern INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_pattern_value
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_pattern('inp_pattern_value');