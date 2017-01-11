/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;

ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_cost_unit_fkey";
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_cost_unit_fkey" FOREIGN KEY ("cost_unit") REFERENCES "price_value_unit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_cost_fkey";
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_cost_fkey" FOREIGN KEY ("cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_m2bottom_cost_fkey";
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_m2bottom_cost_fkey" FOREIGN KEY ("m2bottom_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_m3protec_cost_fkey";
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_m3protec_cost_fkey" FOREIGN KEY ("m3protec_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_cost_unit_fkey";
ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_cost_unit_fkey" FOREIGN KEY ("cost_unit") REFERENCES "price_value_unit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_cost_fkey";
ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_cost_fkey" FOREIGN KEY ("cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "cat_soil" DROP CONSTRAINT IF EXISTS "cat_soil_m3exc_cost_fkey";
ALTER TABLE "cat_soil" ADD CONSTRAINT "cat_soil_m3exc_cost_fkey" FOREIGN KEY ("m3exc_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_soil" DROP CONSTRAINT IF EXISTS "cat_soil_m3fill_cost_fkey";
ALTER TABLE "cat_soil" ADD CONSTRAINT "cat_soil_m3fill_cost_fkey" FOREIGN KEY ("m3fill_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_soil" DROP CONSTRAINT IF EXISTS "cat_soil_m3excess_cost_fkey";
ALTER TABLE "cat_soil" ADD CONSTRAINT "cat_soil_m3excess_cost_fkey" FOREIGN KEY ("m3excess_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_soil" DROP CONSTRAINT IF EXISTS "cat_soil_m2trenchl_cost_fkey";
ALTER TABLE "cat_soil" ADD CONSTRAINT "cat_soil_m2trenchl_cost_fkey" FOREIGN KEY ("m2trenchl_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "cat_pavement" DROP CONSTRAINT IF EXISTS "cat_pavement_m2_cost_fkey";
ALTER TABLE "cat_pavement" ADD CONSTRAINT "cat_pavement_m2_cost_fkey" FOREIGN KEY ("m2_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "plan_arc_x_psector" DROP CONSTRAINT IF EXISTS "plan_arc_x_psector_arc_id_fkey";
ALTER TABLE "plan_arc_x_psector" ADD CONSTRAINT "plan_arc_x_psector_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_arc_x_psector" DROP CONSTRAINT IF EXISTS "plan_arc_x_psector_psector_id_fkey";
ALTER TABLE "plan_arc_x_psector" ADD CONSTRAINT "plan_arc_x_psector_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "plan_node_x_psector" DROP CONSTRAINT IF EXISTS "plan_node_x_psector_node_id_fkey";
ALTER TABLE "plan_node_x_psector" ADD CONSTRAINT "plan_node_x_psector_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_node_x_psector" DROP CONSTRAINT IF EXISTS "plan_node_x_psector_psector_id_fkey";
ALTER TABLE "plan_node_x_psector" ADD CONSTRAINT "plan_node_x_psector_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "plan_other_x_psector" DROP CONSTRAINT IF EXISTS "plan_other_x_psector_price_id_fkey";
ALTER TABLE "plan_other_x_psector" ADD CONSTRAINT "plan_other_x_psector_price_id_fkey" FOREIGN KEY ("price_id") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_other_x_psector" DROP CONSTRAINT IF EXISTS "plan_other_x_psector_psector_id_fkey";
ALTER TABLE "plan_other_x_psector" ADD CONSTRAINT "plan_other_x_psector_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "plan_psector" DROP CONSTRAINT IF EXISTS "plan_psector_sector_id_fkey";
ALTER TABLE "plan_psector" ADD CONSTRAINT "plan_psector_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "plan_arc_x_pavement" DROP CONSTRAINT IF EXISTS "plan_arc_x_pavement_arc_id_fkey";
ALTER TABLE "plan_arc_x_pavement" ADD CONSTRAINT "plan_arc_x_pavement_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_arc_x_pavement" DROP CONSTRAINT IF EXISTS "plan_arc_x_pavement_pavcat_id_fkey";
ALTER TABLE "plan_arc_x_pavement" ADD CONSTRAINT "plan_arc_x_pavement_pavcat_id_fkey" FOREIGN KEY ("pavcat_id") REFERENCES "cat_pavement" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "price_compost_value" DROP CONSTRAINT IF EXISTS "price_compost_value_compost_id_fkey";
ALTER TABLE "price_compost_value" ADD CONSTRAINT "price_compost_value_compost_id_fkey" FOREIGN KEY ("compost_id") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "price_compost_value" DROP CONSTRAINT IF EXISTS "price_compost_value_simple_id_fkey";
ALTER TABLE "price_compost_value" ADD CONSTRAINT "price_compost_value_simple_id_fkey" FOREIGN KEY ("simple_id") REFERENCES "price_simple" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "price_compost" DROP CONSTRAINT IF EXISTS "price_compost_unit_fkey";
ALTER TABLE "price_compost" ADD CONSTRAINT "price_compost_unit_fkey" FOREIGN KEY ("unit") REFERENCES "price_value_unit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "price_simple" DROP CONSTRAINT IF EXISTS "price_simple_unit_fkey";
ALTER TABLE "price_simple" ADD CONSTRAINT "price_simple_unit_fkey" FOREIGN KEY ("unit") REFERENCES "price_value_unit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "plan_selector_psector" DROP CONSTRAINT IF EXISTS "plan_selector_psector_id_fkey";
ALTER TABLE "plan_selector_psector" ADD CONSTRAINT "plan_selector_psector_id_fkey" FOREIGN KEY ("id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_selector_state" DROP CONSTRAINT IF EXISTS "plan_selector_state_id_fkey";
ALTER TABLE "plan_selector_state" ADD CONSTRAINT "plan_selector_state_id_fkey" FOREIGN KEY ("id") REFERENCES "value_state" ("id") ON UPDATE CASCADE ON DELETE CASCADE;
