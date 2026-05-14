/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_minsector instead of insert or delete or update
ON v_edit_minsector for each row execute function gw_trg_edit_minsector();

CREATE TRIGGER gw_trg_presszone_check_datatype BEFORE INSERT OR UPDATE of presszone_id 
ON presszone for each row execute function gw_trg_presszone_check_datatype();

CREATE TRIGGER gw_trg_presszone_check_datatype BEFORE INSERT OR UPDATE of presszone_id 
ON plan_netscenario_presszone FOR EACH ROW EXECUTE PROCEDURE gw_trg_presszone_check_datatype();

ALTER TABLE inp_valve DROP CONSTRAINT inp_valve_to_arc_fkey;
ALTER TABLE inp_valve  ADD CONSTRAINT inp_valve_to_arc_fkey FOREIGN KEY (to_arc)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_pump DROP CONSTRAINT inp_pump_to_arc_fkey;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_to_arc_fkey FOREIGN KEY (to_arc)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
