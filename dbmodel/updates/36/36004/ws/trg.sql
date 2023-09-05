/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_minsector
    INSTEAD OF INSERT OR DELETE OR UPDATE 
    ON v_edit_minsector
    FOR EACH ROW
    EXECUTE FUNCTION gw_trg_edit_minsector();

CREATE TRIGGER gw_trg_edit_plan_netscenario
    INSTEAD OF INSERT OR DELETE OR UPDATE 
    ON ws_sample36.v_edit_plan_netscenario_dma
    FOR EACH ROW
    EXECUTE FUNCTION ws_sample36.gw_trg_edit_plan_netscenario('DMA');


CREATE TRIGGER gw_trg_edit_plan_netscenario
    INSTEAD OF INSERT OR DELETE OR UPDATE 
    ON ws_sample36.v_edit_plan_netscenario_presszone
    FOR EACH ROW
    EXECUTE FUNCTION ws_sample36.gw_trg_edit_plan_netscenario('PRESSZONE');

