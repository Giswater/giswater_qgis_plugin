/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


ALTER TABLE "SCHEMA_NAME"."cat_arc" ADD FOREIGN KEY ("cost_unit") REFERENCES "SCHEMA_NAME"."price_value_unit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_arc" ADD FOREIGN KEY ("cost") REFERENCES "SCHEMA_NAME"."price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_arc" ADD FOREIGN KEY ("m2bottom_cost") REFERENCES "SCHEMA_NAME"."price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_arc" ADD FOREIGN KEY ("m3protec_cost") REFERENCES "SCHEMA_NAME"."price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."cat_node" ADD FOREIGN KEY ("cost_unit") REFERENCES "SCHEMA_NAME"."price_value_unit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_node" ADD FOREIGN KEY ("cost") REFERENCES "SCHEMA_NAME"."price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."cat_soil" ADD FOREIGN KEY ("m3exc_cost") REFERENCES "SCHEMA_NAME"."price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_soil" ADD FOREIGN KEY ("m3fill_cost") REFERENCES "SCHEMA_NAME"."price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_soil" ADD FOREIGN KEY ("m3excess_cost") REFERENCES "SCHEMA_NAME"."price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_soil" ADD FOREIGN KEY ("m2trenchl_cost") REFERENCES "SCHEMA_NAME"."price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."cat_pavement" ADD FOREIGN KEY ("m2_cost") REFERENCES "SCHEMA_NAME"."price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."plan_arc_x_psector" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."plan_arc_x_psector" ADD FOREIGN KEY ("psector_id") REFERENCES "SCHEMA_NAME"."plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."plan_node_x_psector" ADD FOREIGN KEY ("node_id") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."plan_node_x_psector" ADD FOREIGN KEY ("psector_id") REFERENCES "SCHEMA_NAME"."plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."plan_other_x_psector" ADD FOREIGN KEY ("price_id") REFERENCES "SCHEMA_NAME"."price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."plan_other_x_psector" ADD FOREIGN KEY ("psector_id") REFERENCES "SCHEMA_NAME"."plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."plan_psector" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."plan_arc_x_pavement" ADD FOREIGN KEY ("arc_id") REFERENCES "SCHEMA_NAME"."arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."plan_arc_x_pavement" ADD FOREIGN KEY ("pavcat_id") REFERENCES "SCHEMA_NAME"."cat_pavement" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."price_compost_value" ADD FOREIGN KEY ("compost_id") REFERENCES "SCHEMA_NAME"."price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."price_compost_value" ADD FOREIGN KEY ("simple_id") REFERENCES "SCHEMA_NAME"."price_simple" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."price_compost" ADD FOREIGN KEY ("unit") REFERENCES "SCHEMA_NAME"."price_value_unit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."price_simple" ADD FOREIGN KEY ("unit") REFERENCES "SCHEMA_NAME"."price_value_unit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."plan_selector_psector" ADD FOREIGN KEY ("id") REFERENCES "SCHEMA_NAME"."plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."plan_selector_economic" ADD FOREIGN KEY ("id") REFERENCES "SCHEMA_NAME".value_state (id) ON UPDATE CASCADE ON DELETE CASCADE;

