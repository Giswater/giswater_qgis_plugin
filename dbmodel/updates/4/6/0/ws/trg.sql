/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 28/10/2025
CREATE TRIGGER gw_trg_edit_plan_netscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_plan_netscenario_dma 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_netscenario('DMA');

CREATE TRIGGER gw_trg_edit_plan_netscenario INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_plan_netscenario_presszone 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_plan_netscenario('PRESSZONE');

CREATE TRIGGER gw_trg_v_edit_sector INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_sector 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_sector('EDIT');

CREATE TRIGGER gw_trg_v_edit_omzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_omzone 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_omzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_dma INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_dma 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dma('EDIT');

CREATE TRIGGER gw_trg_v_edit_macrodma INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_macrodma 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrodma('EDIT');

CREATE TRIGGER gw_trg_v_edit_supplyzone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_supplyzone 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_supplyzone('EDIT');

CREATE TRIGGER gw_trg_v_edit_presszone INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_presszone 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_presszone('EDIT');

CREATE TRIGGER gw_trg_v_edit_dqa INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_dqa 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_dqa('EDIT');

CREATE TRIGGER gw_trg_v_edit_macrodqa INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_macrodqa 
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_macrodqa('EDIT');
