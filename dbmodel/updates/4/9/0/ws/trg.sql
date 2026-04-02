/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_inp_dscenario_pattern INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_dscenario_pattern 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PATTERN');

CREATE TRIGGER gw_trg_edit_inp_dscenario_pattern_value INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_dscenario_pattern_value 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('PATTERN_VALUE');

CREATE TRIGGER gw_trg_edit_inp_dscenario_demand INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_dscenario_demand 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario_demand();

CREATE TRIGGER gw_trg_dscenario_demand_feature AFTER INSERT ON inp_dscenario_demand
FOR EACH ROW EXECUTE FUNCTION gw_trg_dscenario_demand_feature();
CREATE TRIGGER gw_trg_typevalue_fk AFTER INSERT OR UPDATE ON inp_dscenario_demand
FOR EACH ROW EXECUTE FUNCTION gw_trg_typevalue_fk('inp_dscenario_demand');

CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_link 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_link('LINK');

CREATE TRIGGER gw_trg_edit_inp_dscenario_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_dscenario_connec 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_dscenario('CONNEC');

CREATE TRIGGER gw_trg_edit_inp_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_inp_connec 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_inp_connec();

CREATE TRIGGER gw_trg_edit_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_connec 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_connec('parent');

-- 02/04/2026
CREATE TRIGGER gw_trg_edit_plan_netscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_plan_netscenario_dma 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_netscenario('DMA');

CREATE TRIGGER gw_trg_edit_plan_netscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_plan_netscenario_presszone 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_netscenario('PRESSZONE');
