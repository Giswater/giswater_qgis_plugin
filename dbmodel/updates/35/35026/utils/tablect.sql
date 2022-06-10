/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/10
CREATE INDEX cat_arc_cost_pkey ON cat_arc USING btree (cost);
CREATE INDEX cat_arc_m2bottom_cost_pkey ON cat_arc USING btree (m2bottom_cost);
CREATE INDEX cat_arc_m3protec_cost_pkey ON cat_arc USING btree (m3protec_cost);
CREATE INDEX plan_price_compost_compost_id ON plan_price_compost USING btree (compost_id);
