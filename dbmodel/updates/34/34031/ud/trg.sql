/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_plan_psector_delete_gully ON plan_psector_x_gully;
CREATE TRIGGER gw_trg_plan_psector_delete_gully
AFTER DELETE ON plan_psector_x_gully
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_delete('gully');

DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_gully ON plan_psector_x_gully;
CREATE TRIGGER gw_trg_plan_psector_x_gully
BEFORE INSERT OR UPDATE OF gully_id, state
ON plan_psector_x_gully FOR EACH ROW
EXECUTE PROCEDURE gw_trg_plan_psector_x_gully();


