/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP 


--fk
ALTER TABLE "plan_psector"  DROP CONSTRAINT IF EXISTS "plan_psector_psector_type_fkey";
ALTER TABLE "plan_psector" DROP CONSTRAINT IF EXISTS "plan_psector_expl_id_fkey";
ALTER TABLE "plan_psector" DROP CONSTRAINT IF EXISTS "plan_psector_sector_id_fkey";
ALTER TABLE "plan_psector" DROP CONSTRAINT IF EXISTS "plan_psector_priority_fkey";


ALTER TABLE "plan_psector_x_arc" DROP CONSTRAINT IF EXISTS "plan_psector_x_arc_arc_id_fkey";
ALTER TABLE "plan_psector_x_arc" DROP CONSTRAINT IF EXISTS "plan_psector_x_arc_psector_id_fkey";
ALTER TABLE "plan_psector_x_arc" DROP CONSTRAINT IF EXISTS "plan_psector_x_arc_state_fkey";

ALTER TABLE "plan_psector_x_node" DROP CONSTRAINT IF EXISTS "plan_psector_x_node_node_id_fkey";
ALTER TABLE "plan_psector_x_node" DROP CONSTRAINT IF EXISTS "plan_psector_x_node_psector_id_fkey";
ALTER TABLE "plan_psector_x_node" DROP CONSTRAINT IF EXISTS "plan_psector_x_node_state_fkey";

ALTER TABLE "plan_psector_x_other" DROP CONSTRAINT IF EXISTS "plan_psector_x_other_price_id_fkey";
ALTER TABLE "plan_psector_x_other" DROP CONSTRAINT IF EXISTS "plan_psector_x_other_psector_id_fkey";

ALTER TABLE "plan_arc_x_pavement" DROP CONSTRAINT IF EXISTS "plan_arc_x_pavement_arc_id_fkey";
ALTER TABLE "plan_arc_x_pavement" DROP CONSTRAINT IF EXISTS "plan_arc_x_pavement_pavcat_id_fkey";

ALTER TABLE "plan_psector_selector" DROP CONSTRAINT IF EXISTS "plan_psector_selector_psector_id_fkey";

ALTER TABLE "price_simple" DROP CONSTRAINT IF EXISTS "price_simple_unit_fkey";

ALTER TABLE "price_compost" DROP CONSTRAINT IF EXISTS "price_compost_unit_fkey";

ALTER TABLE "price_compost_value" DROP CONSTRAINT IF EXISTS "price_compost_value_compost_id_fkey";
ALTER TABLE "price_compost_value" DROP CONSTRAINT IF EXISTS "price_compost_value_simple_id_fkey";

ALTER TABLE "plan_result_selector" DROP CONSTRAINT IF EXISTS "plan_result_selector_result_id_fk";

ALTER TABLE "plan_result_selector" DROP CONSTRAINT IF EXISTS "plan_result_selector_result_id_cur_user_unique";


--ADD

--fk
ALTER TABLE "plan_psector"  ADD CONSTRAINT "plan_psector_psector_type_fkey" FOREIGN KEY ("psector_type") REFERENCES "plan_psector_cat_type" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_psector"  ADD CONSTRAINT "plan_psector_expl_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_psector" ADD CONSTRAINT "plan_psector_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_psector" ADD CONSTRAINT "plan_psector_priority_fkey" FOREIGN KEY ("priority") REFERENCES "value_priority" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "plan_psector_x_arc" ADD CONSTRAINT "plan_psector_x_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_psector_x_arc" ADD CONSTRAINT "plan_psector_x_arc_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_psector_x_arc" ADD CONSTRAINT "plan_psector_x_arc_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "plan_psector_x_node" ADD CONSTRAINT "plan_psector_x_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_psector_x_node" ADD CONSTRAINT "plan_psector_x_node_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_psector_x_node" ADD CONSTRAINT "plan_psector_x_node_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "plan_psector_x_other" ADD CONSTRAINT "plan_psector_x_other_price_id_fkey" FOREIGN KEY ("price_id") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_psector_x_other" ADD CONSTRAINT "plan_psector_x_other_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "plan_arc_x_pavement" ADD CONSTRAINT "plan_arc_x_pavement_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "plan_arc_x_pavement" ADD CONSTRAINT "plan_arc_x_pavement_pavcat_id_fkey" FOREIGN KEY ("pavcat_id") REFERENCES "cat_pavement" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "plan_psector_selector" ADD CONSTRAINT "plan_psector_selector_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "price_simple" ADD CONSTRAINT "price_simple_unit_fkey" FOREIGN KEY ("unit") REFERENCES "price_value_unit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "price_compost" ADD CONSTRAINT "price_compost_unit_fkey" FOREIGN KEY ("unit") REFERENCES "price_value_unit" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "price_compost_value" ADD CONSTRAINT "price_compost_value_compost_id_fkey" FOREIGN KEY ("compost_id") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "price_compost_value" ADD CONSTRAINT "price_compost_value_simple_id_fkey" FOREIGN KEY ("simple_id") REFERENCES "price_simple" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "plan_result_selector" ADD CONSTRAINT "plan_result_selector_result_id_fk" FOREIGN KEY ("result_id") REFERENCES "om_result_cat" ("result_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "plan_result_selector" ADD CONSTRAINT "plan_result_selector_result_id_cur_user_unique" UNIQUE (result_id, cur_user);



