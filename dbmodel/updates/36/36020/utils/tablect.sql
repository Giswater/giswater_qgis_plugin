/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE INDEX IF NOT EXISTS idx_selector_state_user_state ON selector_state (cur_user, state_id);
CREATE INDEX IF NOT EXISTS idx_selector_sector_user_sector ON selector_sector (cur_user, sector_id);
CREATE INDEX IF NOT EXISTS idx_selector_expl_user_expl ON selector_expl (cur_user, expl_id);
CREATE INDEX IF NOT EXISTS idx_selector_municipality_user_muni ON selector_municipality (cur_user, muni_id);
CREATE INDEX IF NOT EXISTS idx_selector_psector_user_psector ON selector_psector (cur_user, psector_id);
CREATE INDEX IF NOT EXISTS idx_plan_psector_x_arc_arc_psector ON plan_psector_x_arc (arc_id, psector_id, state);
