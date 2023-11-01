/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 1/11/2023
CREATE CONSTRAINT TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON plan_psector_x_gully
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('plan_psector_x_gully');

CREATE CONSTRAINT TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OF expl_id, state, expl_id2 OR DELETE ON gully
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('gully');
