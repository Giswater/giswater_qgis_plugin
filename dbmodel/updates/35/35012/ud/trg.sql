/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/09/06
DROP TRIGGER IF EXISTS gw_trg_edit_inp_gully ON v_edit_inp_gully;

CREATE TRIGGER gw_trg_edit_inp_gully
INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_inp_gully FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_gully();


--2021/09/18
CREATE TRIGGER gw_trg_notify
AFTER INSERT OR UPDATE OF dscenario_id OR DELETE ON cat_dscenario
FOR EACH ROW EXECUTE PROCEDURE gw_trg_notify('cat_dscenario');

CREATE TRIGGER gw_trg_notify
AFTER INSERT OR UPDATE OF rg_id OR DELETE ON inp_dscenario_raingage
FOR EACH ROW EXECUTE PROCEDURE gw_trg_notify('inp_dscenario_raingage');

CREATE TRIGGER gw_trg_typevalue_fk
AFTER INSERT OR UPDATE ON inp_dscenario_raingage
FOR EACH ROW EXECUTE PROCEDURE gw_trg_typevalue_fk('inp_raingage');

--2021/09/21
DROP TRIGGER IF EXISTS gw_trg_edit_pol_gully ON ve_pol_gully;
CREATE TRIGGER gw_trg_edit_pol_gully
INSTEAD OF INSERT OR UPDATE OR DELETE ON ve_pol_gully
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_man_gully_pol();


--2021/09/18
DROP TRIGGER IF EXISTS gw_trg_edit_inp_dscenario ON v_edit_inp_dscenario_conduit;
CREATE TRIGGER gw_trg_edit_inp_dscenario 
INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_conduit
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('CONDUIT');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_dscenario ON v_edit_inp_dscenario_junction;
CREATE TRIGGER gw_trg_edit_inp_dscenario 
INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_junction
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('JUNCTION');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_dscenario ON v_edit_inp_dscenario_raingage;
CREATE TRIGGER gw_trg_edit_inp_dscenario 
INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_dscenario_raingage
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_dscenario('RAINGAGE');

