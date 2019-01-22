/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

drop trigger if exists gw_trg_visit_update_enddate ON SCHEMA_NAME.om_visit;
CREATE TRIGGER gw_trg_visit_update_enddate AFTER INSERT OR UPDATE OF is_done ON SCHEMA_NAME.om_visit
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_visit_update_enddate('visit');

drop trigger if exists gw_trg_visit_update_enddate ON SCHEMA_NAME.om_visit_event;
CREATE TRIGGER gw_trg_visit_update_enddate BEFORE INSERT OR UPDATE ON SCHEMA_NAME.om_visit_event 
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_visit_update_enddate('event');

DROP TRIGGER IF EXISTS gw_trg_ui_visit ON "SCHEMA_NAME".v_ui_om_visit;
CREATE TRIGGER gw_trg_ui_visit INSTEAD OF DELETE ON "SCHEMA_NAME".v_ui_om_visit FOR EACH ROW EXECUTE PROCEDURE 
"SCHEMA_NAME".gw_trg_ui_visit();