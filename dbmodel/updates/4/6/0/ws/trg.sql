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
