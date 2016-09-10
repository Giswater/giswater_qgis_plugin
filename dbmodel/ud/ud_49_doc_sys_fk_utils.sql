/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;

ALTER TABLE "cat_arc" ADD FOREIGN KEY ("cost_unit") REFERENCES "price_value_unit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD FOREIGN KEY ("cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD FOREIGN KEY ("m2bottom_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD FOREIGN KEY ("m3protec_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "cat_node" ADD FOREIGN KEY ("cost_unit") REFERENCES "price_value_unit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_node" ADD FOREIGN KEY ("cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "cat_soil" ADD FOREIGN KEY ("m3exc_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_soil" ADD FOREIGN KEY ("m3fill_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_soil" ADD FOREIGN KEY ("m3excess_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_soil" ADD FOREIGN KEY ("m2trenchl_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "cat_pavement" ADD FOREIGN KEY ("m2_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "plan_arc_x_psector" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_arc_x_psector" ADD FOREIGN KEY ("psector_id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "plan_node_x_psector" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_node_x_psector" ADD FOREIGN KEY ("psector_id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "plan_other_x_psector" ADD FOREIGN KEY ("price_id") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_other_x_psector" ADD FOREIGN KEY ("psector_id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "plan_psector" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "plan_arc_x_pavement" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_arc_x_pavement" ADD FOREIGN KEY ("pavcat_id") REFERENCES "cat_pavement" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "price_compost_value" ADD FOREIGN KEY ("compost_id") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "price_compost_value" ADD FOREIGN KEY ("simple_id") REFERENCES "price_simple" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "price_compost" ADD FOREIGN KEY ("unit") REFERENCES "price_value_unit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "price_simple" ADD FOREIGN KEY ("unit") REFERENCES "price_value_unit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "plan_selector_psector" ADD FOREIGN KEY ("id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_selector_economic" ADD FOREIGN KEY ("id") REFERENCES value_state (id) ON UPDATE CASCADE ON DELETE CASCADE;
