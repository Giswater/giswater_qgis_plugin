/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/05/06
CREATE INDEX IF NOT EXISTS plan_psector_x_gully_psector_id ON plan_psector_x_gully
  USING btree (psector_id);

CREATE INDEX IF NOT EXISTS plan_psector_x_gully_arc_id ON plan_psector_x_gully
  USING btree (arc_id);

CREATE INDEX IF NOT EXISTS plan_psector_x_gully_state ON plan_psector_x_gully
  USING btree (state);

CREATE INDEX IF NOT EXISTS plan_psector_x_gully_gully_id ON plan_psector_x_gully
  USING btree (gully_id);

ALTER TABLE cat_feature_node ALTER COLUMN isexitupperintro DROP DEFAULT;
