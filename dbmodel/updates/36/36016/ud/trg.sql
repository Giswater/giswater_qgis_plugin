/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 29/11/2024
DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_gully_geom ON plan_psector_x_gully;
create trigger gw_trg_plan_psector_x_gully_geom after insert or delete or update of the_geom 
on plan_psector_x_gully for each row execute procedure gw_trg_plan_psector_geom('plan')